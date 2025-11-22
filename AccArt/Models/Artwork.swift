//
//  Artwork.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 25/09/25.
//
import Foundation

struct Artwork: Identifiable, Decodable, Hashable {
    var id: Int
    var title: String
    var artist: String
    var year: Int?
    var gallery: String?
    var imageURL: URL?
    var license: String?
    var background: String
    var visualDescription: String
    var interpretation: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, artist, year, gallery, imageURL, license, background, visualDescription, interpretation
    }
    
    static let mock: Artwork = {
        let json = """
        {
          "id": 10,
          "title": "Broadway Boogie Woogie",
          "artist": "Piet Mondrian",
          "year": 1943,
          "gallery": "Museum of Modern Art",
          "imageURL": "https://upload.wikimedia.org/wikipedia/commons/3/30/Piet_Mondrian%2C_1942_-_Broadway_Boogie_Woogie.jpg",
          "background": "Painted in New York; one of Mondrian’s final works.",
          "visualDescription": "A grid of red, blue, and yellow squares mimicking New York’s rhythm.",
          "interpretation": "Celebrates energy, jazz, and the dynamism of modern life."
        }
        """
        let data = Data(json.utf8)
        return try! JSONDecoder().decode(Artwork.self, from: data)
    }()
}
