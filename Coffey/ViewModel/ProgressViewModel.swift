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

    // MARK: - SYNC ENTRY POINT
    func syncProgresses(using context: ModelContext) async throws {
        try await SyncManager.shared.sync(model: Progress.self, api: api, using: context)
        loadLocalProgresses(using: context)
    }
}
