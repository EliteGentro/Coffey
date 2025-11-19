//
//  ContentAPI.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation

struct ContentAPI: SyncAPI {
    typealias Model = Content

    private let base = "https://coffey-api.vercel.app/content"
    private var api = APIUtil()

    func fetchAll() async throws -> [Content] {
        try await api.get([Content].self, from: base)
    }

    func fetchDeleted() async throws -> [Content] {
        try await api.get([Content].self, from: "\(base)/deleted")
    }

    func create(_ local: Content) async throws -> Content {
        try await api.sendAndDecode(Content.self, local, to: base, method: "POST")
    }

    func update(_ local: Content) async throws {
        try await api.send(local, to: "\(base)/\(local.content_id)", method: "PATCH")
    }

    func delete(_ local: Content) async throws {
        try await api.send(local, to: "\(base)/\(local.content_id)", method: "DELETE")
    }
}
