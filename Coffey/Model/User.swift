//
//  Item.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//


import Foundation
import SwiftData


struct User: Identifiable, Decodable, Hashable  {
    var id : Int
    var name: String
    var cooperativa_id: String
    var puntaje_aprendizaje: Int
    var contenidos_terminados : Int
    
    enum codigKeys: String, CodingKey {
        case id,name, cooperativa_id, puntaje_aprendizaje,contenidos_terminados
    }
    
    static let mockUsers: [User] = [
        User(id:1,name: "Ernesto", cooperativa_id: "12345", puntaje_aprendizaje: 100,contenidos_terminados:10),
            User(id:2,name: "Javier", cooperativa_id: "12345", puntaje_aprendizaje: 150,contenidos_terminados:13),
            User(id:3,name: "Jaime", cooperativa_id: "12345", puntaje_aprendizaje: 30,contenidos_terminados:6)
        ]
    
}
