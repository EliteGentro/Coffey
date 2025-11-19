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
    private let baseURL = "https://coffey-api.vercel.app/content"
    private var apiUtil = APIUtil()

    // MARK: - API Calls
    func getContents() async throws {
        self.remoteContentsArr = try await apiUtil.get([Content].self, from: baseURL)
    }

    func getDeletedContents() async throws {
        self.remoteDeletedContentsArr = try await apiUtil.get([Content].self, from: "\(baseURL)/deleted")
    }

    /// POST that returns created remote object (with content_id assigned)
    func createRemoteReturning(_ local: Content) async throws -> Content {
        return try await apiUtil.sendAndDecode(Content.self, local, to: baseURL, method: "POST")
    }

    func updateRemote(_ local: Content) async throws {
        try await apiUtil.send(local, to: "\(baseURL)/\(local.content_id)", method: "PATCH")
    }

    func deleteRemote(_ local: Content) async throws {
        try await apiUtil.send(local, to: "\(baseURL)/\(local.content_id)", method: "DELETE")
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

        //Load data
        loadLocalContents(using: context)
        try await getContents()
        try await getDeletedContents()

        // Make lookup dictionaries
        let remoteByID = Dictionary(uniqueKeysWithValues: remoteContentsArr.map { ($0.content_id, $0) })
        var syncedIDs = Set<Int>()

        //Crete local that have no ID
        for local in localContentsArr where local.content_id == 0 && local.deletedAt == nil {

            let createdRemote = try await createRemoteReturning(local)

            // assign remote ID and updatedAt
            local.content_id = createdRemote.content_id
            local.updatedAt = createdRemote.updatedAt

            syncedIDs.insert(createdRemote.content_id)
        }

        // Rebuild lookup now that new IDs exist
        loadLocalContents(using: context)
        let localByID = Dictionary(uniqueKeysWithValues: localContentsArr.map { ($0.content_id, $0) })

        //Delete locally everything that has been deleted in the database
        for remoteDeleted in remoteDeletedContentsArr {
            if let local = localByID[remoteDeleted.content_id] {
                context.delete(local)
            }
        }

        //Process local items that are not new and haven't been deleted
        for local in localContentsArr {

            // Already processed as new, shouldn't be used
            if local.content_id == 0 { continue }

            //If deleted locally, delete from database and delete locally
            if local.deletedAt != nil {
                if remoteByID[local.content_id] != nil {
                    try await deleteRemote(local)
                }
                context.delete(local)
                continue
            }

            // If a content exist locally, update baesed on which one was updated first
            if let remote = remoteByID[local.content_id] {

                switch compareUpdates(local: local, remote: remote) {
                    case .updateRemote:
                        try await updateRemote(local)

                    case .updateLocal:
                        mergeRemote(into: local, remote: remote)

                    case .none:
                        break
                }

                syncedIDs.insert(local.content_id)
                continue
            }

            // Local exists but is missing remotely → recreate remotely
            //Fallback that shouldn't happen
            let recreated = try await createRemoteReturning(local)
            local.content_id = recreated.content_id
            local.updatedAt = recreated.updatedAt
            syncedIDs.insert(recreated.content_id)
        }

        
        //Pull remote contents only
        for remote in remoteContentsArr {
            if !syncedIDs.contains(remote.content_id) {

                let newLocal = Content(
                    content_id: remote.content_id,
                    name: remote.name,
                    details: remote.details,
                    url: remote.url,
                    resourceType: remote.resourceType,
                    transcript: remote.transcript,
                    isDownloaded: false,
                    updatedAt: remote.updatedAt ?? Date(),
                    deletedAt: nil
                )

                context.insert(newLocal)
            }
        }

        //Svae to swift Data
        try context.save()
        loadLocalContents(using: context)
    }
}
