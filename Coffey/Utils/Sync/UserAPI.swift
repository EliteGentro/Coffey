//
//  UserAPI.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation

struct UserAPI: SyncAPI {
    typealias Model = User

    private let base = "https://coffey-api.vercel.app/user"
    private var api = APIUtil()

    func fetchAll() async throws -> [User] {
        try await api.get([User].self, from: base)
    }

    func fetchDeleted() async throws -> [User] {
        try await api.get([User].self, from: "\(base)/deleted")
    }

    func create(_ local: User) async throws -> User {
        try await api.sendAndDecode(User.self, local, to: base, method: "POST")
    }

    func update(_ local: User) async throws {
        try await api.send(local, to: "\(base)/\(local.user_id)", method: "PATCH")
    }

    func delete(_ local: User) async throws {
        try await api.send(local, to: "\(base)/\(local.user_id)", method: "DELETE")
    }
}
