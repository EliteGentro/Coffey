//
//  UserViewModel.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation
import Combine
import SwiftData
import SwiftUI

@Observable
class UserViewModel: ObservableObject {

    // MARK: - In-memory caches
    var localUsersArr = [User]()
    var remoteUsersArr = [User]()
    var remoteDeletedUsersArr = [User]()

    // MARK: - API
    private var api = UserAPI()

    // MARK: - API Calls
    func getUsers() async throws {
        self.remoteUsersArr = try await api.fetchAll()
    }

    func getDeletedUsers() async throws {
        self.remoteDeletedUsersArr = try await api.fetchDeleted()
    }

    func createRemoteReturning(_ local: User) async throws -> User {
        return try await api.create(local)
    }

    func updateRemote(_ local: User) async throws {
        try await api.update(local)
    }

    func deleteRemote(_ local: User) async throws {
        try await api.delete(local)
    }

    // MARK: - Conflict Resolution
    enum UpdateDirection { case updateLocal, updateRemote, none }

    func compareUpdates(local: User, remote: User) -> UpdateDirection {
        let localTS = local.updatedAt ?? .distantPast
        let remoteTS = remote.updatedAt ?? .distantPast

        if localTS > remoteTS { return .updateRemote }
        if remoteTS > localTS { return .updateLocal }
        return .none
    }

    func mergeRemote(into local: User, remote: User) {
        local.name = remote.name
        local.cooperativa_id = remote.cooperativa_id
        local.updatedAt = remote.updatedAt
    }

    // MARK: - Local DB Load
    func loadLocalUsers(using context: ModelContext) {
        do {
            localUsersArr = try context.fetch(FetchDescriptor<User>())
        } catch {
            print("Failed to fetch local users: \(error)")
            localUsersArr = []
        }
    }

    // MARK: - SYNC ENTRY POINT
    func syncUsers(using context: ModelContext) async throws {
        try await SyncManager.shared.sync(model: User.self, api: api, using: context)
        loadLocalUsers(using: context)
    }
    
    // MARK: - User Statistics
    func getPuntajeAprendizaje(for user: User, progresses: [Progress]) -> Int {
        let filtered = progresses.filter { progress in
            if user.user_id == 0 {
                return progress.local_user_reference == user.id
            } else {
                return progress.user_id == user.user_id
            }
        }
        return filtered.reduce(0) { $0 + $1.grade }
    }
    
    func getContenidosTerminados(for user: User, progresses: [Progress]) -> Int {
        let filtered = progresses.filter { progress in
            let matchesUser = (user.user_id == 0 ? 
                progress.local_user_reference == user.id : 
                progress.user_id == user.user_id)
            return matchesUser && progress.status == .completed
        }
        return filtered.count
    }
}
