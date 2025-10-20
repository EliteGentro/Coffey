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
    @State private var fontSettings = FontSettings()

    var sharedModelContainer: ModelContainer = {
            let schema = Schema([
                User.self,
                Admin.self,
                Content.self,
                Preference.self,
                Finance.self
            ])
            
            let configuration = ModelConfiguration(
                "MainStore",
                schema: schema,
                isStoredInMemoryOnly: false
            )
            
            do {
                return try ModelContainer(for: schema, configurations: [configuration])
            } catch {
                fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
            }
        }()
    var body: some Scene {
        WindowGroup {
           ContentView()
                .modelContainer(sharedModelContainer)
                .environmentObject(fontSettings)
        }
    }
}
