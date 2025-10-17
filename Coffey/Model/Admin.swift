//
//  Item.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//


import Foundation
import SwiftData


struct Admin: Identifiable, Decodable, Hashable  {
    var id = UUID()
    var name: String
    var cooperativa_id: String
    var password: String
    
    enum codigKeys: String, CodingKey {
        case name, cooperativa_id, password
    }
    
    static let mockAdmins: [Admin] = [
            Admin(name: "Humberto", cooperativa_id: "12345", password: "12345"),
            Admin(name: "Pablo", cooperativa_id: "12345", password: "12345"),
            Admin(name: "Pedro", cooperativa_id: "12345", password: "12345")
        ]
    
}
