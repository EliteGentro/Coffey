//
//  AccArtApp.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 24/09/25.
//

// ArtSenseApp.swift
// Main app entry and ContentView bootstrap
import SwiftUI

@main
struct AccArtApp: App {
    @StateObject private var repo = ArtworkRepository()
    @StateObject private var recognizer: ArtworkRecognizer

    init() {
        let repository = ArtworkRepository()
        _repo = StateObject(wrappedValue: repository)
        _recognizer = StateObject(wrappedValue: ArtworkRecognizer(repo: repository))
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(repo)
                .environmentObject(recognizer) 
        }
        
    }
}


