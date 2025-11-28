//
//  SyncManager.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//
// Edited by Augusto Orozco on 27/11/25.
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

        // 1. Cargar todo lo local
        let localArr = try context.fetch(FetchDescriptor<T>())
        let localByID = Dictionary(uniqueKeysWithValues: localArr.map { ($0.remoteID, $0) })

        for local in localArr where (local.remoteID == nil || local.remoteID as! Int == 0) && !local.isDeleted {
            let created = try await api.create(local)
            local.remoteID = created.remoteID      // ← MUY IMPORTANTE
            local.updatedAt = Date()
        }

        try? context.save()

        // Reindexar después de creaciones
        let updatedLocalArr = try context.fetch(FetchDescriptor<T>())
        let updatedLocalByID = Dictionary(uniqueKeysWithValues: updatedLocalArr.map { ($0.remoteID, $0) })

        for local in updatedLocalArr where local.isDeleted == true {
            if let id = local.remoteID as? Int, id != 0 {
                try await api.delete(local)
            }
        }

        let remoteArr = try await api.fetchAll()
        var synced = Set<T.IDType>()

        for remote in remoteArr {

            // Si local está eliminado → NO revivirlo
            if let local = updatedLocalByID[remote.remoteID], local.isDeleted {
                continue
            }

            if let local = updatedLocalByID[remote.remoteID] {
                // Synchronization
                switch compare(local, remote) {
                case .updateLocal:
                    local.merge(from: remote)
                case .updateRemote:
                    try await api.update(local)
                case .none:
                    break
                }
            } else {
                // Crear uno nuevo local
                let newLocal = T.makeLocal(from: remote)
                context.insert(newLocal)
            }

            synced.insert(remote.remoteID)
        }

        for local in updatedLocalArr {
            // Ignorar los nuevos que todavía no tienen remoteID bien asignado
            if local.remoteID == nil || local.remoteID as! Int == 0 { continue }

            if !synced.contains(local.remoteID) {
                context.delete(local)
            }
        }

        try context.save()
    }
}
