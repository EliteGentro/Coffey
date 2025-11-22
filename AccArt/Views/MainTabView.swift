//
//  MainTabView.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 25/09/25.
//


// MainTabView.swift
import SwiftUI

import Vision

struct MainTabView: View {
    @Environment(\.accessibilityAssistiveAccessEnabled) private var isAssistiveAccessEnabled

    
    @EnvironmentObject var repo: ArtworkRepository
    @EnvironmentObject var recognizer: ArtworkRecognizer
    
    @State private var selection: Int = 0
    @State private var showCameraSheet: Bool = false
    @State private var selectedMuseum: Museum?
    
    // Text recognition state
    @State private var recognizedText: String? = nil
    @State private var showTextAlert: Bool = false
    @State private var showCameraSheetForText: Bool = false
    
    var body: some View {
        if !isAssistiveAccessEnabled{
            ZStack{
                TabView(selection: $selection) {
                    
                    // MARK: - Gallery Tab
                    NavigationStack {
                        GalleryView()
                            .navigationDestination(item: $recognizer.recognizedArtwork) { art in
                                ArtworkDetailView(artwork: art)
                            }
                    }
                    .tabItem { Label("Gallery", systemImage: "photo.on.rectangle") }
                    .tag(0)
                    
                    // MARK: - Map Tab
                    NavigationStack {
                        MuseumMapView(selectedMuseum: $selectedMuseum, tabSelection: $selection)
                    }
                    .tabItem { Label("Map", systemImage: "map.circle") }
                    .tag(1)
                    
                    
                    // MARK: - Text Reader Tab
                    NavigationStack {
                        // You can keep a small placeholder UI; we immediately present the camera sheet on appear
                        VStack(spacing: 16) {
                            Text("Text Reader").font(.headline)
                            Text("Point the camera at text to recognize it.")
                                .font(.subheadline).foregroundStyle(.secondary)
                            Button("Open Camera") {
                                showCameraSheetForText = true
                            }
                        }
                        .padding()
                        // Programmatic push into TextRecognitionView when recognizedText becomes non-nil
                        .navigationDestination(isPresented: Binding(
                            get: { recognizedText != nil },
                            set: { if !$0 { recognizedText = nil } }
                        )) {
                            if let text = recognizedText {
                                TextRecognitionView(text: text)
                            }
                        }
                        .onAppear {
                            // Optional: automatically open camera when user selects the Text Reader tab
                            // Comment this line out if you prefer requiring an explicit button tap
                            showCameraSheetForText = true
                        }
                    }
                    .tabItem { Label("Text Reader", systemImage: "text.viewfinder") }
                    .tag(2)
                    .sheet(isPresented: $showCameraSheetForText) {
                        CameraCaptureView(
                            onImageCaptured: { img in
                                // Dismiss camera sheet
                                showCameraSheetForText = false
                                
                                // If an image was captured, process it
                                if let image = img {
                                    Task {
                                        let recognizer = await TextRecognizer(image: image)
                                        
                                        if !recognizer.recognizedText.isEmpty {
                                            // This will cause the NavigationStack above to push TextRecognitionView
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
                    NavigationStack {
                        ChatView(viewModel: ChatViewModel(mlxService: MLXService()))
                    }
                    .tabItem { Label("Chat", systemImage: "bubble") }
                    .tag(3)
                    
                    NavigationStack{
                        SettingsView()
                    }
                    .tabItem{Label("Settings", systemImage: "gearshape") }
                    .accessibilityHint("Open app settings")
                    .tag(4)
                    
                }
                
                
                
            }
        } else{
            AssistiveMainTabView(
                    selectedMuseum: $selectedMuseum,
                    recognizer: recognizer
                )

        }
    }
}
    
#Preview{
    MainTabView().environmentObject(ArtworkRepository()).environmentObject(ArtworkRecognizer(repo: ArtworkRepository()))
}
