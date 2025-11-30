//
//  SyncManager.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation
import SwiftData


final class SyncManager {
    static let shared = SyncManager()
    private init() {}

    enum Direction { case updateLocal, updateRemote, none }

    private func compare<T: Syncable>(_ local: T, _ remote: T) -> Direction {
        let l = local.updatedAt ?? .distantPast
        let r = remote.updatedAt ?? .distantPast
        if l > r { return .updateRemote }
        if r > l { return .updateLocal }
        return .none
    }

    func sync<T: Syncable, API: SyncAPI>(
        model: T.Type,
        api: API,
        using context: ModelContext
    ) async throws where API.Model == T {
        let localArr = try context.fetch(FetchDescriptor<T>())
        let remoteArr = try await api.fetchAll()
        let remoteDeleted = try await api.fetchDeleted()

        var synced = Set<T.IDType>()
        let remoteByID = Dictionary(uniqueKeysWithValues: remoteArr.map { ($0.remoteID, $0) })
        
        // Step 1 — Create local-only items
        for local in localArr where local.remoteID as? Int == 0 && local.deletedAt == nil {
            let created = try await api.create(local)
            local.remoteID = created.remoteID
            local.updatedAt = created.updatedAt
            synced.insert(local.remoteID)
        }

        let updatedLocalArr = try context.fetch(FetchDescriptor<T>())
        let localByID = Dictionary(uniqueKeysWithValues: updatedLocalArr.map { ($0.remoteID, $0) })

        // Step 2 — Apply remote deletions
        for deleted in remoteDeleted {
            if let local = localByID[deleted.remoteID] {
                context.delete(local)
            }
        }

        // Step 3 — Handle local records
        for local in updatedLocalArr {
            if let id = local.remoteID as? Int, id == 0 { continue }

            // Skip records that were just created in Step 1
            if synced.contains(local.remoteID) { continue }

            if local.deletedAt != nil {
                if remoteByID[local.remoteID] != nil {
                    try await api.delete(local)
                }
                context.delete(local)
                continue
            }

            if let remote = remoteByID[local.remoteID] {
                switch compare(local, remote) {
                case .updateRemote:
                    try await api.update(local)
                case .updateLocal:
                    let mutable = local
                    mutable.merge(from: remote)
                case .none:
                    break
                }

                synced.insert(local.remoteID)
                continue
            }

            // Local exists but remote removed → recreate
            let recreated = try await api.create(local)
            local.remoteID = recreated.remoteID
            local.updatedAt = recreated.updatedAt
            synced.insert(local.remoteID)
        }

        // Step 4 — Add remote-only items
        for remote in remoteArr where !synced.contains(remote.remoteID) {
            let newLocal = T.makeLocal(from: remote)
            context.insert(newLocal)
        }

        // Step 5 — Save
        try context.save()
    }
}
