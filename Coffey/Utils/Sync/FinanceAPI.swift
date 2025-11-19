//
//  FinanceAPI.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation

struct FinanceAPI: SyncAPI {
    typealias Model = Finance

    private let base = "https://coffey-api.vercel.app/finance"
    private var api = APIUtil()

    func fetchAll() async throws -> [Finance] {
        try await api.get([Finance].self, from: base)
    }

    func fetchDeleted() async throws -> [Finance] {
        try await api.get([Finance].self, from: "\(base)/deleted")
    }

    func create(_ local: Finance) async throws -> Finance {
        try await api.sendAndDecode(Finance.self, local, to: base, method: "POST")
    }

    func update(_ local: Finance) async throws {
        try await api.send(local, to: "\(base)/\(local.finance_id)", method: "PATCH")
    }

    func delete(_ local: Finance) async throws {
        try await api.send(local, to: "\(base)/\(local.finance_id)", method: "DELETE")
    }
}
