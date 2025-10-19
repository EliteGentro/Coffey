//
//  Item.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//


import Foundation
import SwiftData

@Model
final class Admin: Identifiable, Hashable, Decodable {
    @Attribute(.unique) var id: UUID
    var admin_id: Int
    var name: String
    var correo: String
    var cooperativa_id: Int
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case admin_id, name, correo, cooperativa_id, password
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID() 
        self.admin_id = try container.decode(Int.self, forKey: .admin_id)
        self.name = try container.decode(String.self, forKey: .name)
        self.correo = try container.decode(String.self, forKey: .correo)
        self.cooperativa_id = try container.decode(Int.self, forKey: .cooperativa_id)
        self.password = try container.decode(String.self, forKey: .password)
    }
    
    init(
        id: UUID = UUID(),
        admin_id: Int,
        name: String,
        correo: String,
        cooperativa_id: Int,
        password: String
    ) {
        self.id = id
        self.admin_id = admin_id
        self.name = name
        self.correo = correo
        self.cooperativa_id = cooperativa_id
        self.password = password
    }

    
    // Mock data
    static let mockAdmins: [Admin] = [
        Admin(admin_id: 1, name: "Humberto", correo: "mail@mail.com", cooperativa_id: 123, password: "12345"),
        Admin(admin_id: 2, name: "Pablo", correo: "mail@mail.com", cooperativa_id: 234, password: "12345"),
        Admin(admin_id: 3, name: "Pedro", correo: "mail@mail.com", cooperativa_id: 2342, password: "12345")
    ]
}
