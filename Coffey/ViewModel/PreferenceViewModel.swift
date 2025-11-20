//
//  PreferenceViewModel.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation
import Combine
import SwiftData
import SwiftUI

@Observable
class PreferenceViewModel: ObservableObject {

    // MARK: - In-memory caches
    var localPreferencesArr = [Preference]()
    var remotePreferencesArr = [Preference]()
    var remoteDeletedPreferencesArr = [Preference]()

    // MARK: - API
    private var api = PreferenceAPI()

    // MARK: - API Calls
    func getPreferences() async throws {
        self.remotePreferencesArr = try await api.fetchAll()
    }

    func getDeletedPreferences() async throws {
        self.remoteDeletedPreferencesArr = try await api.fetchDeleted()
    }

    func createRemoteReturning(_ local: Preference) async throws -> Preference {
        return try await api.create(local)
    }

    func updateRemote(_ local: Preference) async throws {
        try await api.update(local)
    }

    func deleteRemote(_ local: Preference) async throws {
        try await api.delete(local)
    }

    // MARK: - Conflict Resolution
    enum UpdateDirection { case updateLocal, updateRemote, none }

    func compareUpdates(local: Preference, remote: Preference) -> UpdateDirection {
        let localTS = local.updatedAt ?? .distantPast
        let remoteTS = remote.updatedAt ?? .distantPast

        if localTS > remoteTS { return .updateRemote }
        if remoteTS > localTS { return .updateLocal }
        return .none
    }

    func mergeRemote(into local: Preference, remote: Preference) {
        local.user_id = remote.user_id
        local.font_multiplier = remote.font_multiplier
        local.updatedAt = remote.updatedAt
    }

    // MARK: - Local DB Load
    func loadLocalPreferences(using context: ModelContext) {
        do {
            localPreferencesArr = try context.fetch(FetchDescriptor<Preference>())
        } catch {
            print("Failed to fetch local preferences: \(error)")
            localPreferencesArr = []
        }
    }

    // MARK: - SYNC ENTRY POINT
    func syncPreferences(using context: ModelContext) async throws {
        try await SyncManager.shared.sync(model: Preference.self, api: api, using: context)
        loadLocalPreferences(using: context)
    }
}
