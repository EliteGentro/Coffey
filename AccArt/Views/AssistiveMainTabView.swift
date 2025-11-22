//
//  AssistiveMainTabView.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 07/10/25.
//

import SwiftUI


struct AssistiveMainTabView: View {
    @Binding var selectedMuseum: Museum?
    @ObservedObject var recognizer: ArtworkRecognizer
    @State private var showArtCameraSheet: Bool = false
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 32) {

                    // MARK: - Gallery
                    NavigationLink {
                        NavigationStack {
                            GalleryView()
                                .navigationDestination(item: $recognizer.recognizedArtwork) { art in
                                    ArtworkDetailView(artwork: art)
                                }
                        }
                    } label: {
                        assistiveCell(systemName: "photo.on.rectangle", title: "Gallery")
                    }

                    // MARK: - Recognize Art
                    Button {
                        showArtCameraSheet = true
                    } label: {
                        assistiveCell(systemName: "camera.aperture", title: "Recognize Art")
                    }

                    // MARK: - Map
                    NavigationLink {
                        NavigationStack {
                            MuseumMapView(selectedMuseum: $selectedMuseum, tabSelection: .constant(1))
                        }
                    } label: {
                        assistiveCell(systemName: "map.circle", title: "Map")
                    }

                    // MARK: - Text Reader
                    NavigationLink {
                        TextReaderContainer()
                    } label: {
                        assistiveCell(systemName: "text.viewfinder", title: "Text Reader")
                    }

                    // MARK: - Chat
                    NavigationLink {
                        NavigationStack {
                            ChatView(viewModel: ChatViewModel(mlxService: MLXService()))
                        }
                    } label: {
                        assistiveCell(systemName: "bubble", title: "Chat")
                    }

                    // MARK: - Settings
                    NavigationLink {
                        NavigationStack {
                            SettingsView()
                                .id(selectedLanguage) // refresh when language changes
                        }
                    } label: {
                        assistiveCell(systemName: "gearshape", title: "Settings")
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            .navigationTitle("Menu")

            // Recognized artwork destination
            .navigationDestination(item: $recognizer.recognizedArtwork) { art in
                ArtworkDetailView(artwork: art)
            }

            // Camera sheet
            .sheet(isPresented: $showArtCameraSheet) {
                CameraCaptureView(
                    onImageCaptured: { img in
                        showArtCameraSheet = false
                        if let image = img {
                            recognizer.recognize(image: image)
                        }
                    },
                    onCancel: {
                        showArtCameraSheet = false
                    }
                )
            }

            // Low-confidence alert (original text used because TranslatedText is a View)
            .alert("Recognition not confident enough.", isPresented: $recognizer.showLowConfidenceAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }

    // Reusable cell using TranslatedText for the title
    @ViewBuilder
    private func assistiveCell(systemName: String, title: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: systemName)
                .imageScale(.large)
                .foregroundStyle(.tint)
                .font(.system(size: 40))

            TranslatedText(original: title)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
        .contentShape(Rectangle())
        .accessibilityElement()
        .accessibilityLabel(title) // original string works for VoiceOver
        .accessibilityAddTraits(.isButton)
    }
}


    // Reusable cell view for consistent styling
    @ViewBuilder
    private func assistiveCell(systemName: String, title: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: systemName)
                .imageScale(.large)
                .foregroundStyle(.tint)
                .font(.system(size: 40)) // larger target; tune as desired
            Text(title)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
        .contentShape(Rectangle()) // ensure the whole cell is tappable
        .accessibilityElement()
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }


// MARK: - Text Reader Container (unchanged)
struct TextReaderContainer: View {
    @State private var showCameraSheetForText = false
    @State private var recognizedText: String? = nil
    @State private var showTextAlert = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Text Reader").font(.headline)
            Text("Point the camera at text to recognize it.")
                .font(.subheadline).foregroundStyle(.secondary)

            Button("Open Camera") {
                showCameraSheetForText = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Text Reader")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: Binding(
            get: { recognizedText != nil },
            set: { if !$0 { recognizedText = nil } }
        )) {
            if let text = recognizedText {
                TextRecognitionView(text: text)
            }
        }
        .sheet(isPresented: $showCameraSheetForText) {
            CameraCaptureView(
                onImageCaptured: { img in
                    showCameraSheetForText = false
                    if let image = img {
                        Task {
                            let recognizer = await TextRecognizer(image: image)
                            if !recognizer.recognizedText.isEmpty {
                                recognizedText = recognizer.recognizedText
                            } else {
                                showTextAlert = true
                            }
                        }
                    }
                },
                onCancel: {
                    showCameraSheetForText = false
                }
            )
        }
        .alert("Text could not be confidently read.", isPresented: $showTextAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

//#Preview{
//    AssistiveMainTabView(selectedMuseum: nil, recognizer:nil  )
//}
