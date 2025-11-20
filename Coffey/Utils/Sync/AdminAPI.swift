//
//  AdminAPI.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation

@MainActor
struct AdminAPI: SyncAPI {
    typealias Model = Admin

    private let base = "https://coffey-api.vercel.app/admin"
    private var api = APIUtil()

    func fetchAll() async throws -> [Admin] {
        try await api.get([Admin].self, from: base)
    }

    func fetchDeleted() async throws -> [Admin] {
        try await api.get([Admin].self, from: "\(base)/deleted")
    }

    func create(_ local: Admin) async throws -> Admin {
        try await api.sendAndDecode(Admin.self, local, to: base, method: "POST")
    }

    func update(_ local: Admin) async throws {
        try await api.send(local, to: "\(base)/\(local.admin_id)", method: "PATCH")
    }

    func delete(_ local: Admin) async throws {
        try await api.send(local, to: "\(base)/\(local.admin_id)", method: "DELETE")
    }
}
