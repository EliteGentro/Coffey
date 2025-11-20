//
//  FinanceViewModel.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation
import Combine
import SwiftData
import SwiftUI

@Observable
class FinanceViewModel: ObservableObject {

    // MARK: - In-memory caches
    var localFinancesArr = [Finance]()
    var remoteFinancesArr = [Finance]()
    var remoteDeletedFinancesArr = [Finance]()

    // MARK: - API
    private var api = FinanceAPI()

    // MARK: - API Calls
    func getFinances() async throws {
        self.remoteFinancesArr = try await api.fetchAll()
    }

    func getDeletedFinances() async throws {
        self.remoteDeletedFinancesArr = try await api.fetchDeleted()
    }

    func createRemoteReturning(_ local: Finance) async throws -> Finance {
        return try await api.create(local)
    }

    func updateRemote(_ local: Finance) async throws {
        try await api.update(local)
    }

    func deleteRemote(_ local: Finance) async throws {
        try await api.delete(local)
    }

    // MARK: - Conflict Resolution
    enum UpdateDirection { case updateLocal, updateRemote, none }

    func compareUpdates(local: Finance, remote: Finance) -> UpdateDirection {
        let localTS = local.updatedAt ?? .distantPast
        let remoteTS = remote.updatedAt ?? .distantPast

        if localTS > remoteTS { return .updateRemote }
        if remoteTS > localTS { return .updateLocal }
        return .none
    }

    func mergeRemote(into local: Finance, remote: Finance) {
        local.user_id = remote.user_id
        local.name = remote.name
        local.date = remote.date
        local.category = remote.category
        local.amount = remote.amount
        local.type = remote.type
        local.updatedAt = remote.updatedAt
    }

    // MARK: - Local DB Load
    func loadLocalFinances(using context: ModelContext) {
        do {
            localFinancesArr = try context.fetch(FetchDescriptor<Finance>())
        } catch {
            print("Failed to fetch local finances: \(error)")
            localFinancesArr = []
        }
    }

    // MARK: - SYNC ENTRY POINT
    func syncFinances(using context: ModelContext) async throws {
        try await SyncManager.shared.sync(model: Finance.self, api: api, using: context)
        loadLocalFinances(using: context)
    }
}
