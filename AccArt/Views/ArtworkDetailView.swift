//
//  ArtworkDetailView.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 25/09/25.
//

import SwiftUI

struct ArtworkDetailView: View {
    let artwork: Artwork

    @State private var uiImage: UIImage? = nil
    @State private var isLoadingImage: Bool = false
    @State private var showZoomableImage: Bool = false

    // Keep a reference to the running read-all task so we can cancel it
    @State private var readAllTask: Task<Void, Never>? = nil

    @ObservedObject private var speech = SpeechManager.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Image area
                Group {
                    if isLoadingImage {
                        ZStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.08))
                                .frame(height: 240)
                            ProgressView()
                        }
                    } else if let img = uiImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 320)
                            .cornerRadius(6)
                            .onTapGesture {
                                showZoomableImage = true
                            }
                            .sheet(isPresented: $showZoomableImage) {
                                ZoomableImageView(imageURL: URL(string: artwork.imageURL!.absoluteString))
                            }
                            .accessibilityLabel(
                                "\(artwork.title) by \(artwork.artist)\(artwork.year.map { ", \($0)" } ?? "")"
                            )
                    } else {
                        // Placeholder if no image
                        Rectangle()
                            .fill(Color.gray.opacity(0.12))
                            .frame(height: 240)
                            .overlay(
                                VStack {
                                    Image(systemName: "photo")
                                    TranslatedText(original: "Image not available", font: .caption)
                                        .foregroundStyle(.secondary)
                                }
                            )
                    }
                }

                // Buttons: Read All / Stop
                HStack(spacing: 12) {
                    Button(action: {
                        readAllTask?.cancel()
                        readAllTask = Task { @MainActor in
                            await speech.speakAll([
                                artwork.background,
                                artwork.visualDescription,
                                artwork.interpretation
                            ])
                            readAllTask = nil
                        }
                    }) {
                        Label {
                            TranslatedText(original: "Read All Sections")
                                .padding(8)
                        } icon: {
                            Image(systemName: "text.book.closed")
                        }
                        .background(RoundedRectangle(cornerRadius: 8).strokeBorder())
                    }
                    .accessibilityLabel("Read all sections")
                    .accessibilityHint("Reads background, visual description, and interpretation in order")

                    Button(action: {
                        readAllTask?.cancel()
                        readAllTask = nil
                        Task { @MainActor in
                            speech.stop()
                        }
                    }) {
                        Label {
                            TranslatedText(original: "Stop")
                                .padding(8)
                        } icon: {
                            Image(systemName: "stop.fill")
                        }
                        .background(RoundedRectangle(cornerRadius: 8).strokeBorder())
                    }
                    .accessibilityLabel("Stop audio")
                }

                // Collapsible translated sections
                DisclosureGroup {
                    VStack(alignment: .leading, spacing: 8) {
                        TranslatedText(original: artwork.background, font: .body)
                        SectionAudioControls(text: artwork.background, label: "Background")
                    }
                    .padding(.vertical, 6)
                } label: {
                    TranslatedText(original: "Background", font: .headline)
                }

                DisclosureGroup {
                    VStack(alignment: .leading, spacing: 8) {
                        TranslatedText(original: artwork.visualDescription, font: .body)
                        SectionAudioControls(text: artwork.visualDescription, label: "Visual Description")
                    }
                    .padding(.vertical, 6)
                } label: {
                    TranslatedText(original: "Visual Description", font: .headline)
                }

                DisclosureGroup {
                    VStack(alignment: .leading, spacing: 8) {
                        TranslatedText(original: artwork.interpretation, font: .body)
                        SectionAudioControls(text: artwork.interpretation, label: "Common Interpretation")
                    }
                    .padding(.vertical, 6)
                } label: {
                    TranslatedText(original: "Common Interpretation", font: .headline)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle(artwork.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadImage()
        }
        .onDisappear {
            readAllTask?.cancel()
            readAllTask = nil
            Task { @MainActor in speech.stop() }
        }
    }

    // MARK: - Load image into UIImage
    private func loadImage() {
        guard let url = artwork.imageURL else {
            uiImage = nil
            isLoadingImage = false
            return
        }
        isLoadingImage = true
        Task {
            let loaded = await ImageLoader.shared.loadImage(url: url)
            await MainActor.run {
                uiImage = loaded
                isLoadingImage = false
            }
        }
    }
}

#Preview {
    ArtworkDetailView(artwork: .mock)
}
