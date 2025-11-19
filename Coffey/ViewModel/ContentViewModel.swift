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
class ContentViewModel: ObservableObject{
    var localContentsArr = [Content]()
    var remoteContentsArr = [Content]()
    private let baseURL = "https://coffey-api.vercel.app/content"
    private var apiUtil = APIUtil()
    
    func getContents() async throws {
        self.remoteContentsArr = try await apiUtil.get([Content].self, from: baseURL)
    }
    
    func updateContents(localContents: [Content]) async throws{
        for content in localContents {
            try await apiUtil.send(
                content,
                to: "\(baseURL)/\(content.content_id)",
                method: "PATCH"
            )
        }
    }
    
    func createContents(localContents: [Content], remoteContents: [Content]) async throws{
        for content in localContents {
            try await apiUtil.send(
                content,
                to: "\(baseURL)/\(content.content_id)",
                method: "POST"
            )
        }
    }
    
    func contentNeedsUpdate(local: Content, remote: Content) -> Bool {
        return (local.name != remote.name || local.url != remote.url
                || local.resourceType != remote.resourceType || local.details != remote.details
                || local.transcript != remote.transcript)
    }
    
    ///  Synchronize remote API contents with local SwiftData store
    func syncContents(using context: ModelContext, removeStale: Bool = false) async throws {
        
        //First upload everything as it is locally
        
        // Fetch remote contents (reusing your existing function)
        try await getContents()
        loadLocalContents(using: context)
        // Fetch local contents
        let localByID = Dictionary(uniqueKeysWithValues: localContentsArr.map { ($0.content_id, $0) })
        let remoteByID = Dictionary(uniqueKeysWithValues: remoteContentsArr.map { ($0.content_id, $0) })
        //Save local IDs that we know are identical to database
        var remoteIDs = Set<Int>()
        
        for local in localContentsArr {
            if let remote = remoteByID[local.content_id],
               contentNeedsUpdate(local: local, remote: remote) {
                
            }
        }
        
        // Add or update local entries
        for remote in remoteContentsArr {
            remoteIDs.insert(remote.content_id)
            
            if let local = localByID[remote.content_id] {
                // Update if any values changed (excluding local-only properties like isDownloaded)
                var needsUpdate = false
                if local.name != remote.name { local.name = remote.name; needsUpdate = true }
                if local.url != remote.url { local.url = remote.url; needsUpdate = true }
                if local.resourceType != remote.resourceType { local.resourceType = remote.resourceType; needsUpdate = true }
                
                if needsUpdate {
                    // SwiftData automatically tracks changes; you just need to save later
                }
            } else {
                // Insert new content
                let new = Content(
                    content_id: remote.content_id,
                    name: remote.name,
                    details:remote.details,
                    url: remote.url,
                    resourceType: remote.resourceType,
                    transcript: remote.transcript,
                    isDownloaded: false
                )
                context.insert(new)
            }
        }
        
        // Optionally delete local entries that no longer exist on the server
        if removeStale {
            for local in localContentsArr where !remoteIDs.contains(local.content_id) {
                context.delete(local)
            }
        }
        
        // Save
        try context.save()
        
        // Refresh local array for the view
        loadLocalContents(using: context)
    }
    
    /// Fetch only local contents from SwiftData
    func loadLocalContents(using context: ModelContext) {
        do {
            localContentsArr = try context.fetch(FetchDescriptor<Content>())
        } catch {
            print("Failed to fetch local contents: \(error)")
            localContentsArr = []
        }
    }}
