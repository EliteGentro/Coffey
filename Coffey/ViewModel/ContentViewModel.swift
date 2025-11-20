//
//  ContentViewModel.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 05/11/25.
//

import Foundation
import Combine
import FoundationModels
import SwiftData
import SwiftUI
@Observable
class ContentViewModel: ObservableObject {

    // MARK: - In-memory caches
    var localContentsArr = [Content]()
    var remoteContentsArr = [Content]()
    var remoteDeletedContentsArr = [Content]()

    // MARK: - API
    private var api = ContentAPI()

    // MARK: - API Calls
    func getContents() async throws {
        self.remoteContentsArr = try await api.fetchAll()
    }

    func getDeletedContents() async throws {
        self.remoteDeletedContentsArr = try await api.fetchDeleted()
    }

    /// POST that returns created remote object (with content_id assigned)
    func createRemoteReturning(_ local: Content) async throws -> Content {
        return try await api.create(local)
    }

    func updateRemote(_ local: Content) async throws {
        try await api.update(local)
    }

    func deleteRemote(_ local: Content) async throws {
        try await api.delete(local)
    }

    // MARK: - Conflict Resolution
    enum UpdateDirection { case updateLocal, updateRemote, none }

    func compareUpdates(local: Content, remote: Content) -> UpdateDirection {
        let localTS = local.updatedAt ?? .distantPast
        let remoteTS = remote.updatedAt ?? .distantPast

        if localTS > remoteTS { return .updateRemote }
        if remoteTS > localTS { return .updateLocal }
        return .none
    }

    func mergeRemote(into local: Content, remote: Content) {
        local.name = remote.name
        local.details = remote.details
        local.url = remote.url
        local.resourceType = remote.resourceType
        local.transcript = remote.transcript
        local.updatedAt = remote.updatedAt
    }

    // MARK: - Local DB Load
    func loadLocalContents(using context: ModelContext) {
        do {
            localContentsArr = try context.fetch(FetchDescriptor<Content>())
        } catch {
            print("Failed to fetch local contents: \(error)")
            localContentsArr = []
        }
    }

    // MARK: - SYNC ENTRY POINT
    func syncContents(using context: ModelContext) async throws {
        try await SyncManager.shared.sync(model: Content.self, api: api, using: context)
        loadLocalContents(using: context)
    }
}
