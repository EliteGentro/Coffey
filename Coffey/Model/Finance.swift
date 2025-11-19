//
//  Finance.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/10/25.
//

import Foundation
import SwiftData

@Model
final class Finance: Identifiable, Decodable, Hashable, Sendable {
    @Attribute(.unique) var id : UUID
    var finance_id : Int
    var user_id : Int
    var name : String
    var date : Date
    var category : String
    var amount : Double
    var type : String
    var local_user_reference: UUID
    var updatedAt: Date?
    var deletedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case finance_id, user_id, name, date, category, amount, type, updatedAt, deletedAt
    }
    
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.finance_id = try container.decode(Int.self, forKey: .finance_id)
        self.user_id = try container.decode(Int.self, forKey: .user_id)
        self.name = try container.decode(String.self, forKey: .name)
        self.date = try container.decode(Date.self, forKey: .date)
        self.category = try container.decode(String.self, forKey: .category)
        self.amount = try container.decode(Double.self, forKey: .amount)
        self.type = try container.decode(String.self, forKey: .type)
        self.local_user_reference = UUID()
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        self.deletedAt = try container.decodeIfPresent(Date.self, forKey: .deletedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(finance_id, forKey: .finance_id)
        try container.encode(user_id, forKey: .user_id)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(amount, forKey: .amount)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(deletedAt, forKey: .deletedAt)
    }
    
    init(
        id:UUID = UUID(),
        finance_id: Int,
        user_id: Int,
        name: String,
        date: Date,
        category: String,
        amount: Double,
        type: String,
        local_user_reference: UUID,
        updatedAt: Date? = nil,
        deletedAt: Date? = nil
    ){
        self.id = id
        self.finance_id = finance_id
        self.user_id = user_id
        self.name = name
        self.date = date
        self.category = category
        self.amount = amount
        self.type = type
        self.local_user_reference = local_user_reference
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
    
    static let mockFinances: [Finance] = [
        Finance(
            finance_id: 1,
            user_id: 1,
            name: "Compra de ropa",
            date: Date(),
            category: "Personal",
            amount: 200.00,
            type: "Egresos",
            local_user_reference: User.mockUsers[0].id
        ),
        Finance(
            finance_id: 2,
            user_id: 1,
            name: "Pago de la Semana",
            date: Date(),
            category: "Trabajo",
            amount: 2000.00,
            type: "Ingresos",
            local_user_reference: User.mockUsers[0].id
        ),
        Finance(
            finance_id: 3,
            user_id: 1,
            name: "Recibo de Luz",
            date: Date(),
            category: "Hogar",
            amount: 300.00,
            type: "Egresos",
            local_user_reference: User.mockUsers[0].id
        )]
    
    static func isValidFinance(_ name: String, _ category: String, _ amount: Double, _ type: String) -> Bool{
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !category.trimmingCharacters(in: .whitespaces).isEmpty &&
        !(amount < 0) &&
        !type.trimmingCharacters(in: .whitespaces).isEmpty
    }

    static func isValidFecha(_ fecha: Date) -> Bool {
        fecha.timeIntervalSinceNow <= 0
    }
    
}
