//
//  ArtworkCellView.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 25/09/25.
//

import SwiftUI

struct ArtworkCellView: View {
    let artwork: Artwork
    @State private var thumbnail: UIImage? = nil
    @State private var isLoading: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Group {
                if isLoading {
                    Rectangle()
                        .fill(Color.gray.opacity(0.12))
                        .frame(width: 80, height: 60)
                        .overlay(ProgressView().scaleEffect(0.6))
                } else if let img = thumbnail {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 60)
                        .clipped()
                        .cornerRadius(4)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.08))
                        .frame(width: 80, height: 60)
                        .overlay(Image(systemName: "photo").foregroundStyle(.secondary))
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                TranslatedText(original:artwork.title, font:.headline)
                TranslatedText(original:artwork.artist, font:.subheadline).foregroundStyle(.secondary)
                if let year = artwork.year { Text(String(year)).font(.caption).foregroundStyle(.secondary) }
            }
            .accessibilityElement(children: .combine)
        }
        .padding(.vertical, 6)
        .onAppear {
            loadThumbnailIfNeeded()
        }
        .onDisappear {
            // Optional: cancelable tasks would be better if heavy list scrolling
        }
    }

    private func loadThumbnailIfNeeded() {
        guard thumbnail == nil, !isLoading, let url = artwork.imageURL else {
            if artwork.imageURL == nil {
                print("ArtworkCellView: artwork \(artwork.id) has nil imageURL")
            }
            return
        }
        isLoading = true
        Task {
            let img = await ImageLoader.shared.loadImage(url: url)
            await MainActor.run {
                self.thumbnail = img
                self.isLoading = false
                if img == nil {
                    print("ArtworkCellView: failed to load image for \(url)")
                }
            }
        }
    }
}

#Preview{
    ArtworkCellView(artwork: .mock)
}
