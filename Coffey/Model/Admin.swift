//
//  Item.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//


import Foundation


struct Admin: Identifiable, Decodable, Hashable  {
    var id : Int
    var name: String
    var correo : String
    var cooperativa_id: String
    var password: String
    
    enum codigKeys: String, CodingKey {
        case id, name, correo, cooperativa_id, password
    }
    
    static let mockAdmins: [Admin] = [
            Admin(id:1,name: "Humberto", correo:"mail@mail.com", cooperativa_id: "12345", password: "12345"),
            Admin(id:2,name: "Pablo", correo:"mail@mail.com", cooperativa_id: "12345", password: "12345"),
            Admin(id:3,name: "Pedro", correo:"mail@mail.com", cooperativa_id: "12345", password: "12345")
        ]
    
}
