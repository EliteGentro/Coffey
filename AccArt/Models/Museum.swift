//
//  Museum.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 25/09/25.
//

import Foundation

struct Museum: Identifiable, Decodable {
    var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
    var collections: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, name, latitude, longitude, collections
    }
    
    // ✅ Keep mock for previews
    static let mock: Museum = {
        let json = """
        {
          "id": 1,
          "name": "Metropolitan Museum of Art",
          "latitude": 40.7794,
          "longitude": -73.9632,
          "collections": ["Paintings"]
        }
        """
        let data = Data(json.utf8)
        return try! JSONDecoder().decode(Museum.self, from: data)
    }()
}

