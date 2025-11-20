//
//  AdminViewModel.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation
import Combine
import SwiftData
import SwiftUI

@Observable
class AdminViewModel: ObservableObject {

    // MARK: - In-memory caches
    var localAdminsArr = [Admin]()
    var remoteAdminsArr = [Admin]()
    var remoteDeletedAdminsArr = [Admin]()

    // MARK: - API
    private var api = AdminAPI()

    // MARK: - API Calls
    func getAdmins() async throws {
        self.remoteAdminsArr = try await api.fetchAll()
    }

    func getDeletedAdmins() async throws {
        self.remoteDeletedAdminsArr = try await api.fetchDeleted()
    }

    func createRemoteReturning(_ local: Admin) async throws -> Admin {
        return try await api.create(local)
    }

    func updateRemote(_ local: Admin) async throws {
        try await api.update(local)
    }

    func deleteRemote(_ local: Admin) async throws {
        try await api.delete(local)
    }

    // MARK: - Conflict Resolution
    enum UpdateDirection { case updateLocal, updateRemote, none }

    func compareUpdates(local: Admin, remote: Admin) -> UpdateDirection {
        let localTS = local.updatedAt ?? .distantPast
        let remoteTS = remote.updatedAt ?? .distantPast

        if localTS > remoteTS { return .updateRemote }
        if remoteTS > localTS { return .updateLocal }
        return .none
    }

    func mergeRemote(into local: Admin, remote: Admin) {
        local.name = remote.name
        local.correo = remote.correo
        local.cooperativa_id = remote.cooperativa_id
        local.password = remote.password
        local.updatedAt = remote.updatedAt
    }

    // MARK: - Local DB Load
    func loadLocalAdmins(using context: ModelContext) {
        do {
            localAdminsArr = try context.fetch(FetchDescriptor<Admin>())
        } catch {
            print("Failed to fetch local admins: \(error)")
            localAdminsArr = []
        }
    }

    // MARK: - SYNC ENTRY POINT
    func syncAdmins(using context: ModelContext) async throws {
        try await SyncManager.shared.sync(model: Admin.self, api: api, using: context)
        loadLocalAdmins(using: context)
    }
}
