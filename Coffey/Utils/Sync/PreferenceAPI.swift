//
//  PreferenceAPI.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation

struct PreferenceAPI: SyncAPI {
    typealias Model = Preference

    private let base = "https://coffey-api.vercel.app/preference"
    private var api = APIUtil()

    func fetchAll() async throws -> [Preference] {
        try await api.get([Preference].self, from: base)
    }

    func fetchDeleted() async throws -> [Preference] {
        try await api.get([Preference].self, from: "\(base)/deleted")
    }

    func create(_ local: Preference) async throws -> Preference {
        try await api.sendAndDecode(Preference.self, local, to: base, method: "POST")
    }

    func update(_ local: Preference) async throws {
        guard let preferenceId = local.preference_id else {
            throw URLError(.badURL)
        }
        try await api.send(local, to: "\(base)/\(preferenceId)", method: "PATCH")
    }

    func delete(_ local: Preference) async throws {
        guard let preferenceId = local.preference_id else {
            throw URLError(.badURL)
        }
        try await api.send(local, to: "\(base)/\(preferenceId)", method: "DELETE")
    }
}
