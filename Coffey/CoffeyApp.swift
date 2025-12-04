//
//  CoffeyApp.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 16/10/25.
//

import SwiftUI
import SwiftData

@main
struct CoffeyApp: App {
    @StateObject private var fontSettings = FontSettings()
    let sharedModelContainer: ModelContainer
    let downloadManager: DownloadManager

    init() {
        let schema = Schema([
            User.self,
            Admin.self,
            Content.self,
            Cooperativa.self,
            Preference.self,
            Finance.self,
            Progress.self
        ])
        
        let configuration = ModelConfiguration(
            "MainStore",
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])
            self.sharedModelContainer = container
            self.downloadManager = DownloadManager(modelContainer: container)
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
                .environmentObject(fontSettings)
                .environment(
                    \.font,
                    Font.system(size: 17 * fontSettings.multiplier)
                )
                .environmentObject(downloadManager)
                .preferredColorScheme(ColorScheme.light)
        }
    }
}
