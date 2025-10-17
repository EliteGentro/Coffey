//
//  Item.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//


import Foundation
import SwiftData


struct User: Identifiable, Decodable, Hashable  {
    var id = UUID()
    var name: String
    var cooperativa_id: String
    
    enum codigKeys: String, CodingKey {
        case name, cooperativa_id, password
    }
    
    static let mockUsers: [User] = [
            User(name: "Ernestp", cooperativa_id: "12345"),
            User(name: "Javier", cooperativa_id: "12345"),
            User(name: "Jaime", cooperativa_id: "12345")
        ]
    
}
