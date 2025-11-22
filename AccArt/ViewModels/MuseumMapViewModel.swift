//
//  MuseumMapViewModel.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 25/09/25.
//

import Foundation
import MapKit
import Combine
import SwiftUI

@MainActor
class MuseumMapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var museums: [Museum] = []
    @Published var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.7794, longitude: -73.9632), // Default: NYC
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Example museum data
        museums = loadMuseumsFromFile()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else { return }
        
        // Smoothly update camera position instead of abruptly jumping
            withAnimation {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: loc.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            )
        }
    }
    private func loadMuseumsFromFile() -> [Museum] {
        guard let url = Bundle.main.url(forResource: "curated_museums", withExtension: "json") else {
            print("❌ curated_museums.json not found")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let museums = try JSONDecoder().decode([Museum].self, from: data)
            return museums
        } catch {
            print("❌ Failed to decode curated_museums.json: \(error)")
            return []
        }
    }

}



