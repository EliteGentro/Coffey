//
//  ZoomableImageView.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 25/09/25.
//

// ZoomableImageView.swift
import SwiftUI

/// Fullscreen zoomable image viewer. Use by presenting as a sheet:
/// .sheet(isPresented: $showFullImage) { ZoomableImageView(imageURL: url) }
struct ZoomableImageView: View {
    let imageURL: URL?

    @Environment(\.presentationMode) private var presentationMode

    @State private var uiImage: UIImage? = nil
    @State private var isLoading: Bool = true
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Text("Loading image...")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let image = uiImage {
                    GeometryReader { geo in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(scale)
                            .offset(x: offset.width, y: offset.height)
                            .gesture(magnificationGesture())
                            .gesture(dragGesture(constrainedTo: geo.size))
                            .onTapGesture(count: 2) {
                                // reset zoom with double tap
                                withAnimation { resetTransforms() }
                            }
                            .accessibilityLabel(accessibilityLabel(for: image))
                            .accessibilityAddTraits(.isImage)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else {
                    VStack {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                        Text("No image available")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding()
            .navigationTitle("Artwork")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { presentationMode.wrappedValue.dismiss() }
                    .accessibilityLabel("Done")
                    .accessibilityHint("Closes the fullscreen image view")
                }
            }
            .onAppear {
                loadImage()
            }
            .onDisappear {
                // Reset state for next presentation
                resetTransforms()
                uiImage = nil
            }
        }
    }

    // MARK: - Gestures

    private func magnificationGesture() -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let delta = value / (lastScale == 0 ? 1 : lastScale)
                lastScale = value
                scale = max(1.0, min(scale * delta, 5.0)) // clamp
            }
            .onEnded { _ in
                lastScale = 1.0
                // keep scale as-is; optionally clamp smaller values
                if scale < 1.0 {
                    withAnimation { scale = 1.0 }
                }
            }
    }

    private func dragGesture(constrainedTo size: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                // limit panning so image doesn't drift too far
                let newOffset = CGSize(width: lastOffset.width + value.translation.width, height: lastOffset.height + value.translation.height)
                // optional boundary checks could be added here
                offset = newOffset
            }
            .onEnded { _ in
                lastOffset = offset
                // Optional: add bounce-back if out of bounds
            }
    }

    private func resetTransforms() {
        scale = 1.0
        lastScale = 1.0
        offset = .zero
        lastOffset = .zero
    }

    // MARK: - Loading

    private func loadImage() {
        guard let url = imageURL else {
            self.isLoading = false
            self.uiImage = nil
            return
        }
        Task {
            self.isLoading = true
            let img = await ImageLoader.shared.loadImage(url: url) // expects ImageLoader service
            await MainActor.run {
                self.uiImage = img
                self.isLoading = false
            }
        }
    }

    // MARK: - Accessibility helper

    private func accessibilityLabel(for image: UIImage) -> String {
        // Prefer not to synthesize descriptions here. The detail view should provide the full textual visual description.
        // Provide a succinct label for the image itself (title/artist would be better passed in if available).
        "Artwork image, double-tap to reset zoom, two-finger pan to move."
    }
}

#Preview {
    ZoomableImageView(imageURL: URL(string: Artwork.mock.imageURL!.absoluteString))
}
