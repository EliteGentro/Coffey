//
//  ArtworkRepository.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 25/09/25.
//

import Foundation
import Combine
import SwiftUI

final class ArtworkRepository: ObservableObject {
    @Published private(set) var artworks: [Artwork] = []
    @Published var currentGallery: String  = "General"
    
    var filteredArtworks: [Artwork] {
            artworks.filter { $0.gallery == currentGallery }
    }
    
    init() {
        loadBundled()
    }

    private func loadBundled() {
        guard let url = Bundle.main.url(forResource: "curated_artworks", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return }
        let decoded = (try? JSONDecoder().decode([Artwork].self, from: data)) ?? []
        artworks = decoded
    }
    
    // Placeholder for future remote fetch method:
    // func fetchFromMet(objectId: Int) async throws -> Artwork { ... }
}

extension ArtworkRepository {
    /// Find an artwork by title and update the current gallery
    func artwork(forTitle title: String) -> Artwork? {
        let match = artworks.first { $0.title.localizedCaseInsensitiveContains(title) }
        if let art = match, let gallery = art.gallery {
            withAnimation {
                currentGallery = gallery
            }
        }
        return match
    }
}
