//
//  GalleryView.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 25/09/25.
//
import SwiftUI
import Vision

struct GalleryView: View {
    @State var artworkVM = ArtworkViewModel()
    @State private var showCameraSheet: Bool = false
    @EnvironmentObject var repo: ArtworkRepository
    @EnvironmentObject var recognizer: ArtworkRecognizer
    
    var body: some View {
        ZStack {
            List(repo.filteredArtworks) { art in
                NavigationLink(destination: ArtworkDetailView(artwork: art)) {
                    ArtworkCellView(artwork: art)
                }
                .accessibilityHint("Opens detail view with description and audio")
            }
            .listStyle(.insetGrouped)
            .navigationTitle(repo.currentGallery)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if repo.currentGallery != "General" {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            withAnimation { repo.currentGallery = "General" }
                        } label: {
                            Image(systemName: "arrow.left")
                        }
                        .accessibilityLabel("Back to General Gallery")
                        .accessibilityHint("Returns to the general gallery view")
                    }
                }
            }
            .onAppear {
                if repo.currentGallery.isEmpty {
                    repo.currentGallery = "General"
                }
            }

            // Floating button overlay
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    CameraFloatingButton {
                        showCameraSheet = true
                    }
                    .accessibilityIdentifier("CameraFloatingButton")
                    .padding(.trailing, 18)
                }
                .padding(.bottom, 30)
            }
        }
        // Attach modifiers HERE to ZStack
        .sheet(isPresented: $showCameraSheet) {
            CameraCaptureView(
                onImageCaptured: { resultImage in
                    showCameraSheet = false
                    if let img = resultImage {
                        recognizer.recognize(image: img)
                    }
                },
                onCancel: { showCameraSheet = false }
            )
        }
        .alert("Recognition not confident enough.",
               isPresented: $recognizer.showLowConfidenceAlert) {
            Button("OK", role: .cancel) { }
        }
    }

}


struct CameraFloatingButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 64, height: 64)
                    .shadow(radius: 6)
                Image(systemName: "camera.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .accessibilityLabel("Open camera")
        .accessibilityHint("Opens the camera to capture a photo of artwork")
        // Make tappable area generous
        .contentShape(Rectangle())
        .padding(6)
    }
}


#Preview {
    GalleryView()
        .environmentObject(ArtworkRepository())
        .environmentObject(ArtworkRecognizer(repo: ArtworkRepository()))
}

