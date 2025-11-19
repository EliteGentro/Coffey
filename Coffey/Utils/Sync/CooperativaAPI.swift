//
//  CooperativaAPI.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation

struct CooperativaAPI: SyncAPI {
    typealias Model = Cooperativa

    private let base = "https://coffey-api.vercel.app/cooperativa"
    private var api = APIUtil()

    func fetchAll() async throws -> [Cooperativa] {
        try await api.get([Cooperativa].self, from: base)
    }

    func fetchDeleted() async throws -> [Cooperativa] {
        try await api.get([Cooperativa].self, from: "\(base)/deleted")
    }

    func create(_ local: Cooperativa) async throws -> Cooperativa {
        try await api.sendAndDecode(Cooperativa.self, local, to: base, method: "POST")
    }

    func update(_ local: Cooperativa) async throws {
        try await api.send(local, to: "\(base)/\(local.cooperativa_id)", method: "PATCH")
    }

    func delete(_ local: Cooperativa) async throws {
        try await api.send(local, to: "\(base)/\(local.cooperativa_id)", method: "DELETE")
    }
}
