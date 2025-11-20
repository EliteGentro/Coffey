//
//  ProgressViewModel.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation
import Combine
import SwiftData
import SwiftUI

@Observable
class ProgressViewModel: ObservableObject {

    // MARK: - In-memory caches
    var localProgressesArr = [Progress]()
    var remoteProgressesArr = [Progress]()
    var remoteDeletedProgressesArr = [Progress]()

    // MARK: - API
    private var api = ProgressAPI()

    // MARK: - API Calls
    func getProgresses() async throws {
        self.remoteProgressesArr = try await api.fetchAll()
    }

    func getDeletedProgresses() async throws {
        self.remoteDeletedProgressesArr = try await api.fetchDeleted()
    }

    func createRemoteReturning(_ local: Progress) async throws -> Progress {
        return try await api.create(local)
    }

    func updateRemote(_ local: Progress) async throws {
        try await api.update(local)
    }

    func deleteRemote(_ local: Progress) async throws {
        try await api.delete(local)
    }

    // MARK: - Conflict Resolution
    enum UpdateDirection { case updateLocal, updateRemote, none }

    func compareUpdates(local: Progress, remote: Progress) -> UpdateDirection {
        let localTS = local.updatedAt ?? .distantPast
        let remoteTS = remote.updatedAt ?? .distantPast

        if localTS > remoteTS { return .updateRemote }
        if remoteTS > localTS { return .updateLocal }
        return .none
    }

    func mergeRemote(into local: Progress, remote: Progress) {
        local.user_id = remote.user_id
        local.content_id = remote.content_id
        local.grade = remote.grade
        local.status = remote.status
        local.updatedAt = remote.updatedAt
    }

    // MARK: - Local DB Load
    func loadLocalProgresses(using context: ModelContext) {
        do {
            localProgressesArr = try context.fetch(FetchDescriptor<Progress>())
        } catch {
            print("Failed to fetch local progresses: \(error)")
            localProgressesArr = []
        }
    }

    // MARK: - UPDATE GLOBAL USER ID
    func resolveUserReferences(context: ModelContext) {
        let userVM = UserViewModel()
        userVM.loadLocalUsers(using: context)

        let map = Dictionary(uniqueKeysWithValues:
                                userVM.localUsersArr.map { ($0.id, $0.user_id) })

        for progress in localProgressesArr {
            if progress.user_id == 0,
               let resolved = map[progress.local_user_reference] {
                progress.user_id = resolved
            }
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save context in ProgressVM:", error)
        }
    }
    
    // MARK: - SYNC ENTRY POINT
    func syncProgresses(using context: ModelContext) async throws {
        
        loadLocalProgresses(using: context)
        resolveUserReferences(context: context)
        try await SyncManager.shared.sync(model: Progress.self, api: api, using: context)
        loadLocalProgresses(using: context)
    }
}
