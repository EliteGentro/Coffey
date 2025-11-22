//
//  MuseumViewModel.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 01/10/25.
//

import Foundation
import CoreLocation

@Observable
class MuseumViewModel {
    var museums = [Museum]()
    
    init() {
        museums = load("curated_museums.json")
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
    
    // Helper: convert coordinates
    func coordinate(for museum: Museum) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: museum.latitude, longitude: museum.longitude)
    }
}
