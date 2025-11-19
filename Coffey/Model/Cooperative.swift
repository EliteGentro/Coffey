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
class Cooperativa: Identifiable, Hashable, Decodable, Encodable {
    @Attribute(.unique) var id: UUID
    var cooperativa_id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case cooperativa_id, name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID() 
        self.cooperativa_id = try container.decode(Int.self, forKey: .cooperativa_id)
        self.name = try container.decode(String.self, forKey: .name)

    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cooperativa_id, forKey: .cooperativa_id)
        try container.encode(name, forKey: .name)
    }
    
    init(
        id: UUID = UUID(),
        cooperativa_id: Int,
        name: String
    ) {
        self.id = id
        self.cooperativa_id = cooperativa_id
        self.name = name
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
