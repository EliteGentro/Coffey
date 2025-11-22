//
//  MuseumDetailView.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 25/09/25.
//

import SwiftUI

struct MuseumDetailView: View {
    @EnvironmentObject var repo: ArtworkRepository
    let museum: Museum
    var onClose: () -> Void
    @Binding var tabSelection: Int

    @State private var navigateToGallery = false

    var body: some View {
        VStack(spacing: 12) {
            // Title + Close button
            HStack {
                TranslatedText(original: museum.name, font: .headline)
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                }
                .accessibilityLabel("Close")
                .accessibilityHint("Close museum details")
            }

            // Collections heading
            TranslatedText(original: "Collections:", font: .subheadline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)

            // List of collections
            ForEach(museum.collections, id: \.self) { collection in
                Button(action: {
                    repo.currentGallery = museum.name
                    tabSelection = 0
                    onClose()
                }) {
                    TranslatedText(original: collection)
                        .padding(6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 6).stroke())
                }
            }
        }
        .padding()
    }
}

#Preview {
    MuseumDetailView(museum: .mock, onClose: {}, tabSelection: .constant(1))
}
