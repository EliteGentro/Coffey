//
//  ProgressAPI.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation

@MainActor
struct ProgressAPI: SyncAPI {
    typealias Model = Progress

    private let base = "https://coffey-api.vercel.app/progress"
    private var api = APIUtil()

    func fetchAll() async throws -> [Progress] {
        try await api.get([Progress].self, from: base)
    }

    func fetchDeleted() async throws -> [Progress] {
        try await api.get([Progress].self, from: "\(base)/deleted")
    }

    func create(_ local: Progress) async throws -> Progress {
        try await api.sendAndDecode(Progress.self, local, to: base, method: "POST")
    }

    func update(_ local: Progress) async throws {
        try await api.send(local, to: "\(base)/\(local.progress_id)", method: "PATCH")
    }

    func delete(_ local: Progress) async throws {
        try await api.send(local, to: "\(base)/\(local.progress_id)", method: "DELETE")
    }
}
