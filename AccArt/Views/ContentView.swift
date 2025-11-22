//
//  ContentView.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 25/09/25.
//

import SwiftUI

struct ContentView: View {
    @State private var repo = ArtworkRepository()

    var body: some View {
        NavigationView {
            GalleryView()
                .environmentObject(repo)
                .navigationTitle("Gallery")
        }
    }
}


#Preview {
    ContentView()
}
