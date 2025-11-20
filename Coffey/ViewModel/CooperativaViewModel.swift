//
//  CooperativeViewModel.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation
import Combine
import SwiftData
import SwiftUI

@Observable
class CooperativaViewModel: ObservableObject {

    // MARK: - In-memory caches
    var localCooperativasArr = [Cooperativa]()
    var remoteCooperativasArr = [Cooperativa]()
    var remoteDeletedCooperativasArr = [Cooperativa]()

    // MARK: - API
    private var api = CooperativaAPI()

    // MARK: - API Calls
    func getCooperativas() async throws {
        self.remoteCooperativasArr = try await api.fetchAll()
    }

    func getDeletedCooperativas() async throws {
        self.remoteDeletedCooperativasArr = try await api.fetchDeleted()
    }

    func createRemoteReturning(_ local: Cooperativa) async throws -> Cooperativa {
        return try await api.create(local)
    }

    func updateRemote(_ local: Cooperativa) async throws {
        try await api.update(local)
    }

    func deleteRemote(_ local: Cooperativa) async throws {
        try await api.delete(local)
    }

    // MARK: - Conflict Resolution
    enum UpdateDirection { case updateLocal, updateRemote, none }

    func compareUpdates(local: Cooperativa, remote: Cooperativa) -> UpdateDirection {
        let localTS = local.updatedAt ?? .distantPast
        let remoteTS = remote.updatedAt ?? .distantPast

        if localTS > remoteTS { return .updateRemote }
        if remoteTS > localTS { return .updateLocal }
        return .none
    }

    func mergeRemote(into local: Cooperativa, remote: Cooperativa) {
        local.name = remote.name
        local.updatedAt = remote.updatedAt
    }

    // MARK: - Local DB Load
    func loadLocalCooperativas(using context: ModelContext) {
        do {
            localCooperativasArr = try context.fetch(FetchDescriptor<Cooperativa>())
        } catch {
            print("Failed to fetch local cooperativas: \(error)")
            localCooperativasArr = []
        }
    }

    // MARK: - SYNC ENTRY POINT
    func syncCooperativas(using context: ModelContext) async throws {
        try await SyncManager.shared.sync(model: Cooperativa.self, api: api, using: context)
        loadLocalCooperativas(using: context)
    }
}
