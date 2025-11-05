//
//  Item.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftData
import Foundation

@Model
class User: Identifiable, Hashable, Decodable {
    @Attribute(.unique) var id: UUID
    var user_id: Int
    var name: String
    var cooperativa_id: Int
    var puntaje_aprendizaje: Int
    var contenidos_terminados: Int
    
    enum CodingKeys: String, CodingKey {
        case user_id, name, cooperativa_id, puntaje_aprendizaje, contenidos_terminados
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.user_id = try container.decode(Int.self, forKey: .user_id)
        self.name = try container.decode(String.self, forKey: .name)
        self.cooperativa_id = try container.decode(Int.self, forKey: .cooperativa_id)
        self.puntaje_aprendizaje = try container.decode(Int.self, forKey: .puntaje_aprendizaje)
        self.contenidos_terminados = try container.decode(Int.self, forKey: .contenidos_terminados)
    }
    
    init(
        id: UUID = UUID(),
        user_id: Int,
        name: String,
        cooperativa_id: Int,
        puntaje_aprendizaje: Int,
        contenidos_terminados: Int
    ) {
        self.id = id
        self.user_id = user_id
        self.name = name
        self.cooperativa_id = cooperativa_id
        self.puntaje_aprendizaje = puntaje_aprendizaje
        self.contenidos_terminados = contenidos_terminados
    }
    
    // Mock data
    static let mockUsers: [User] = [
        User(user_id: 1, name: "Ernesto", cooperativa_id: 234, puntaje_aprendizaje: 100, contenidos_terminados: 10),
        User(user_id: 2, name: "Javier", cooperativa_id: 5243, puntaje_aprendizaje: 150, contenidos_terminados: 13),
        User(user_id: 3, name: "Jaime", cooperativa_id: 234, puntaje_aprendizaje: 30, contenidos_terminados: 6)
    ]

    static func isValidName(_ name: String ) -> Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
