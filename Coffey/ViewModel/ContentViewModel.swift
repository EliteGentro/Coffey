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
        var arrContents = [Content]()
        private let baseURL = "https://coffey-api.vercel.app/content"

        func getContents() async throws {
            guard let url = URL(string: baseURL) else { return }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            self.arrContents = try JSONDecoder().decode([Content].self, from: data)
        }

        ///  Synchronize remote API contents with local SwiftData store
        func syncContents(using context: ModelContext, removeStale: Bool = false) async throws {
            // 1️⃣ Fetch remote contents (reusing your existing function)
            try await getContents()
            let remoteContents = arrContents

            // 2️⃣ Fetch local contents
            let localContents: [Content] = try context.fetch(FetchDescriptor<Content>())
            let localByID = Dictionary(uniqueKeysWithValues: localContents.map { ($0.content_id, $0) })
            var remoteIDs = Set<Int>()

            // 3️⃣ Add or update local entries
            for remote in remoteContents {
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

            // 4️⃣ Optionally delete local entries that no longer exist on the server
            if removeStale {
                for local in localContents where !remoteIDs.contains(local.content_id) {
                    context.delete(local)
                }
            }

            // 5️⃣ Save
            try context.save()

            // 6️⃣ Refresh local array for the view
            arrContents = try context.fetch(FetchDescriptor<Content>())
        }

        /// Fetch only local contents from SwiftData
        func loadLocalContents(using context: ModelContext) {
            do {
                arrContents = try context.fetch(FetchDescriptor<Content>())
            } catch {
                print("Failed to fetch local contents: \(error)")
                arrContents = []
            }
        }}
