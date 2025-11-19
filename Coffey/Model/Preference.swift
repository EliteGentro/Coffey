//
//  Preference.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 18/10/25.
//

import SwiftData
import Foundation


@Model
class Preference: Identifiable, Decodable, Encodable {
    @Attribute(.unique) var id: UUID
    var preference_id : Int?
    var user_id: Int
    var local_user_reference: UUID
    var font_multiplier: Double
    
    enum CodingKeys: String, CodingKey {
        case preference_id, user_id, font_multiplier
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID() // SwiftData unique ID
        self.preference_id = try container.decode(Int.self, forKey: .preference_id)
        self.user_id = try container.decode(Int.self, forKey: .user_id)
        self.local_user_reference = UUID()
        self.font_multiplier = try container.decode(Double.self, forKey: .font_multiplier)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.preference_id, forKey: .preference_id)
        try container.encode(self.user_id, forKey: .user_id)
        try container.encode(self.font_multiplier, forKey: .font_multiplier)
        
    }
    
    init(id: UUID = UUID(), preference_id: Int? = nil , user_id: Int , local_user_reference: UUID , font_multiplier: Double = 1.0) {
        self.id = id
        self.preference_id = preference_id
        self.user_id = user_id
        self.local_user_reference = local_user_reference
        self.font_multiplier = font_multiplier
    }
    
    static let mockPreference: Preference = Preference(preference_id: 1, user_id: User.mockUsers.first!.user_id, local_user_reference: User.mockUsers.first!.id,font_multiplier: 1.0)
    
}
