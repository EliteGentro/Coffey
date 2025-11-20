//
//  Cooperative.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//


import Foundation
import SwiftData
import Combine

@Model
final class Cooperativa: Identifiable, Hashable, Codable  {
    @Attribute(.unique) var id: UUID
    var cooperativa_id: Int
    var name: String
    var updatedAt: Date?
    var deletedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case cooperativa_id, name, updatedAt, deletedAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID() 
        self.cooperativa_id = try container.decode(Int.self, forKey: .cooperativa_id)
        self.name = try container.decode(String.self, forKey: .name)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        self.deletedAt = try container.decodeIfPresent(Date.self, forKey: .deletedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(deletedAt, forKey: .deletedAt)
    }
    
    init(
        id: UUID = UUID(),
        cooperativa_id: Int,
        name: String,
        updatedAt: Date? = nil,
        deletedAt: Date? = nil
    ) {
        self.id = id
        self.cooperativa_id = cooperativa_id
        self.name = name
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }

    
    // Mock data
    static let mockCooperativas: [Cooperativa] = [
        Cooperativa(cooperativa_id: 1, name: "Cooperativa Alfa"),
        Cooperativa(cooperativa_id: 2, name: "Cooperativa Gamma"),
        Cooperativa(cooperativa_id: 3, name: "Cooperativa Beta")
    ]

    static func isValidCooperativa(_ name: String) -> Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
