//
//  ArtworkViewModel.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 01/10/25.
//

import Foundation

@Observable
class ArtworkViewModel {
    var artworks = [Artwork]()
    
    init() {
        artworks = load("curated_artworks.json")
    }
    
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    // MARK: - Helpers
    
    func artwork(forTitle title: String) -> Artwork? {
        artworks.first { $0.title.localizedCaseInsensitiveContains(title) }
    }
    
    func artworks(inGallery gallery: String) -> [Artwork] {
        artworks.filter { $0.gallery == gallery }
    }
}
