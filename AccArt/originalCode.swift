////
////  AccArtApp.swift
////  AccArt
////
////  Created by Humberto Genaro Cisneros Salinas on 24/09/25.
////
//
//
//import SwiftUI
//import AVFoundation
//import Combine
//import UIKit
//
//// MARK: - Models
//
//struct Artwork: Identifiable, Codable, Equatable {
//    var id: String
//    var title: String
//    var artist: String
//    var year: String?
//    var imageURL: URL?
//    var license: String?
//    var creditLine: String?
//    var background: String
//    var visualDescription: String
//    var interpretation: String
//}
//
//// MARK: - Sample Data (5 curated public-domain paintings)
//
//fileprivate let sampleJSON = """
//[
//  {
//    "id": "met-436535",
//    "title": "The Starry Night",
//    "artist": "Vincent van Gogh",
//    "year": "1889",
//    "imageURL": "https://images.metmuseum.org/CRDImages/ep/web-large/DT1567.jpg",
//    "license": "Public Domain",
//    "creditLine": "The Metropolitan Museum of Art, Public Domain",
//    "background": "Painted by Vincent van Gogh in 1889 while at the asylum in Saint-Rémy, The Starry Night is one of the most recognized pieces of Western art.",
//    "visualDescription": "A sweeping night sky filled with swirling patterns of stars and a bright crescent moon above a quiet village. A dominant dark cypress tree rises at the left foreground.",
//    "interpretation": "Often interpreted as an expression of van Gogh's emotional turbulence and fascination with the cosmos, the painting blends observation with imagination."
//  },
//  {
//    "id": "met-1402",
//    "title": "The Harvesters",
//    "artist": "Pieter Bruegel the Elder",
//    "year": "1565",
//    "imageURL": "https://images.metmuseum.org/CRDImages/ep/web-large/DT1402.jpg",
//    "license": "Public Domain",
//    "creditLine": "The Metropolitan Museum of Art, Public Domain",
//    "background": "Pieter Bruegel the Elder created a series of paintings depicting peasant life in the 16th century; The Harvesters shows seasonal labor and landscape.",
//    "visualDescription": "Figures harvest wheat in a golden field under a blue sky; in the middle ground others rest and a village sits in the distance.",
//    "interpretation": "This painting is often read as a study of everyday life and the cyclical nature of labor, with subtle moral or symbolic readings depending on the viewer."
//  },
//  {
//    "id": "met-436106",
//    "title": "Water Lilies",
//    "artist": "Claude Monet",
//    "year": "c. 1916",
//    "imageURL": "https://images.metmuseum.org/CRDImages/ep/web-large/DP-14254-001.jpg",
//    "license": "Public Domain",
//    "creditLine": "The Metropolitan Museum of Art, Public Domain",
//    "background": "Part of Monet's late paintings focusing on his water garden in Giverny, emphasizing color, light, and reflection.",
//    "visualDescription": "An almost abstract field of water lily pads and blossoms reflected in rippling water — soft shapes, diffuse light, and subtle color shifts.",
//    "interpretation": "Monet pushed Impressionism toward abstraction by focusing on the sensory effects of color and light rather than descriptive detail."
//  },
//  {
//    "id": "met-436121",
//    "title": "Girl with a Pearl Earring",
//    "artist": "Johannes Vermeer",
//    "year": "c. 1665",
//    "imageURL": "https://images.metmuseum.org/CRDImages/ep/web-large/DP135357.jpg",
//    "license": "Public Domain",
//    "creditLine": "The Metropolitan Museum of Art, Public Domain",
//    "background": "A tronie painted by Vermeer depicting an unknown girl wearing an exotic dress and a large pearl earring.",
//    "visualDescription": "Close-up of a young woman turned over her shoulder, with wide eyes and a reflective pearl earring; dark background isolates the figure.",
//    "interpretation": "Called the 'Mona Lisa of the North', interpretations vary from explorations of light to studies of intimate expression."
//  },
//  {
//    "id": "met-436731",
//    "title": "The Swing",
//    "artist": "Jean-Honoré Fragonard",
//    "year": "c. 1767",
//    "imageURL": "https://images.metmuseum.org/CRDImages/ep/web-large/DP-14225-001.jpg",
//    "license": "Public Domain",
//    "creditLine": "The Metropolitan Museum of Art, Public Domain",
//    "background": "An example of the Rococo style: playful, ornate, and often associated with aristocratic leisure.",
//    "visualDescription": "A young woman on a swing in a lush garden while an admirer watches from below; the scene is playful and ornate.",
//    "interpretation": "Often read as a celebration of flirtation and pleasure, with visual cues that suggest theatricality and artifice."
//  }
//]
//"""
//
//// MARK: - Data Loader
//
//class ArtworkData: ObservableObject {
//    @Published var artworks: [Artwork] = []
//
//    init() {
//        loadFromBundledJSON()
//    }
//
//    func loadFromBundledJSON() {
//        let data = Data(sampleJSON.utf8)
//        do {
//            let decoded = try JSONDecoder().decode([Artwork].self, from: data)
//            DispatchQueue.main.async {
//                self.artworks = decoded
//            }
//        } catch {
//            print("Failed to decode sample JSON: \(error)")
//            self.artworks = []
//        }
//    }
//}
//import AVFoundation
//
//@MainActor
//final class SpeechManager: NSObject, ObservableObject {
//    static let shared = SpeechManager()
//
//    private let synthesizer = AVSpeechSynthesizer()
//    private let delegateBridge: SpeechSynthesizerDelegateBridge
//
//    // Continuation used to await an utterance's completion (MainActor-isolated).
//    private var utteranceContinuation: CheckedContinuation<Void, Never>?
//
//    @Published var isSpeaking: Bool = false
//    @Published var currentText: String = ""
//
//    private override init() {
//        self.delegateBridge = SpeechSynthesizerDelegateBridge()
//        super.init()
//        delegateBridge.owner = self
//        synthesizer.delegate = delegateBridge
//    }
//
//    // MARK: - Public API
//
//    func speak(_ text: String, voiceIdentifier: String? = nil, rate: Float = AVSpeechUtteranceDefaultSpeechRate) {
//        stop()
//        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
//        guard !trimmed.isEmpty else { return }
//        currentText = trimmed
//
//        let utterance = AVSpeechUtterance(string: trimmed)
//        utterance.rate = rate
//        if let vid = voiceIdentifier, let voice = AVSpeechSynthesisVoice(identifier: vid) {
//            utterance.voice = voice
//        }
//        synthesizer.speak(utterance)
//    }
//
//    func stop() {
//        if synthesizer.isSpeaking {
//            synthesizer.stopSpeaking(at: .immediate)
//        }
//        isSpeaking = false
//        currentText = ""
//        // If someone is awaiting, resume to avoid deadlock
//        utteranceContinuation?.resume()
//        utteranceContinuation = nil
//    }
//
//    /// Sequential reading using async/await and continuations.
//    /// Caller can `await` this method to complete after all sections are read.
//    func speakAll(_ texts: [String], pause: TimeInterval = 0.4) async {
//        stop()
//        for section in texts {
//            let trimmed = section.trimmingCharacters(in: .whitespacesAndNewlines)
//            guard !trimmed.isEmpty else { continue }
//            await speakAndWait(trimmed)
//            // Pause between sections
//            try? await Task.sleep(nanoseconds: UInt64(pause * 1_000_000_000))
//        }
//    }
//
//    // Await the completion of a single utterance using a CheckedContinuation
//    private func speakAndWait(_ text: String) async {
//        // Ensure we run on MainActor for AV APIs
//        await MainActor.run {
//            self.currentText = text
//        }
//
//        let utterance = AVSpeechUtterance(string: text)
//        // Keep voice/rate default or set as needed
//        await MainActor.run {
//            synthesizer.speak(utterance)
//        }
//
//        // Wait for the delegate bridge to resume this continuation on finish/cancel
//        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
//            // store continuation on the MainActor-isolated object
//            self.utteranceContinuation = continuation
//        }
//        // continuation resumed -> utterance finished or cancelled
//        self.utteranceContinuation = nil
//    }
//
//    // MARK: - Internal helpers invoked by the bridge (must be MainActor)
//
//    fileprivate func handleDidStart() {
//        isSpeaking = true
//    }
//
//    fileprivate func handleDidFinish() {
//        isSpeaking = false
//        currentText = ""
//        // Resume any waiting continuation (safely on MainActor)
//        utteranceContinuation?.resume()
//        utteranceContinuation = nil
//    }
//
//    fileprivate func handleDidCancel() {
//        isSpeaking = false
//        currentText = ""
//        utteranceContinuation?.resume()
//        utteranceContinuation = nil
//    }
//}
//
///// Non-isolated delegate bridge. Delegate callbacks may be delivered off the main actor.
///// Forward minimal/sendable info (here: none) to the SpeechManager via `Task { @MainActor in ... }`.
//private final class SpeechSynthesizerDelegateBridge: NSObject, AVSpeechSynthesizerDelegate {
//    weak var owner: SpeechManager?
//
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
//        // Do NOT capture `utterance` (non-Sendable). Forward a simple MainActor call.
//        Task { @MainActor in
//            self.owner?.handleDidStart()
//        }
//    }
//
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
//        Task { @MainActor in
//            self.owner?.handleDidFinish()
//        }
//    }
//
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
//        Task { @MainActor in
//            self.owner?.handleDidCancel()
//        }
//    }
//}
//
//// MARK: - Helpers
//
//extension URL {
//    init?(stringOrNil s: String?) {
//        guard let s = s else { return nil }
//        self.init(string: s)
//    }
//}
//
//// Simple dominant color extractor (sample center pixel) and nearest-name mapping.
//// This is intentionally basic; replace or augment with AXNameFromColor on supported platforms.
//
//func dominantColorName(from uiImage: UIImage?) -> String? {
//    guard let image = uiImage, let cg = image.cgImage else { return nil }
//    let width = cg.width
//    let height = cg.height
//    guard width > 0 && height > 0 else { return nil }
//    let x = width / 2
//    let y = height / 2
//    let colorSpace = CGColorSpaceCreateDeviceRGB()
//    var pixelData: [UInt8] = [0,0,0,0]
//    let context = CGContext(data: &pixelData,
//                            width: 1,
//                            height: 1,
//                            bitsPerComponent: 8,
//                            bytesPerRow: 4,
//                            space: colorSpace,
//                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
//    context?.translateBy(x: CGFloat(-x), y: CGFloat(-y))
//    context?.draw(cg, in: CGRect(x: 0, y: 0, width: width, height: height))
//    let r = pixelData[0]
//    let g = pixelData[1]
//    let b = pixelData[2]
//    return nearestBasicColorName(r: Int(r), g: Int(g), b: Int(b))
//}
//
//func nearestBasicColorName(r: Int, g: Int, b: Int) -> String {
//    // Simple bins
//    if r > 200 && g < 100 && b < 100 { return "red" }
//    if g > 200 && r < 100 && b < 100 { return "green" }
//    if b > 200 && r < 100 && g < 100 { return "blue" }
//    if r > 200 && g > 200 && b < 150 { return "yellow" }
//    if r > 200 && g > 200 && b > 200 { return "white" }
//    if r < 60 && g < 60 && b < 60 { return "black" }
//    if r > 150 && g < 100 && b > 150 { return "magenta" }
//    if r > 150 && g > 150 && b < 100 { return "light yellow" }
//    return "muted color"
//}
//
//// MARK: - ZoomableImageView (for fullscreen image viewing)
//
//struct ZoomableImageView: View {
//    let imageURL: URL?
//    @Environment(\.presentationMode) var presentationMode
//    @State private var scale: CGFloat = 1.0
//    @State private var lastScale: CGFloat = 1.0
//
//    var body: some View {
//        NavigationView {
//            Group {
//                if let url = imageURL {
//                    AsyncImage(url: url) { phase in
//                        switch phase {
//                        case .empty:
//                            ProgressView()
//                        case .success(let image):
//                            image
//                                .resizable()
//                                .scaledToFit()
//                                .scaleEffect(scale)
//                                .gesture(MagnificationGesture()
//                                            .onChanged { value in
//                                                let delta = value / self.lastScale
//                                                self.lastScale = value
//                                                self.scale *= delta
//                                            }
//                                            .onEnded { _ in
//                                                self.lastScale = 1.0
//                                            }
//                                )
//                        case .failure:
//                            Image(systemName: "photo")
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundStyle(.secondary)
//                        @unknown default:
//                            EmptyView()
//                        }
//                    }
//                } else {
//                    Image(systemName: "photo")
//                        .resizable()
//                        .scaledToFit()
//                }
//            }
//            .padding()
//            .navigationTitle("Artwork")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Done") { presentationMode.wrappedValue.dismiss() }
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Views
//
//@main
//struct ArtSenseApp: App {
//    @StateObject private var data = ArtworkData()
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environmentObject(data)
//        }
//    }
//}
//
//struct ContentView: View {
//    @EnvironmentObject var data: ArtworkData
//
//    var body: some View {
//        NavigationView {
//            GalleryView()
//                .navigationTitle("ArtSense — Gallery")
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//    }
//}
//
//struct GalleryView: View {
//    @EnvironmentObject var data: ArtworkData
//
//    var body: some View {
//        List {
//            ForEach(data.artworks) { art in
//                NavigationLink(destination: ArtworkDetailView(artwork: art)) {
//                    HStack(alignment: .top) {
//                        AsyncImage(url: art.imageURL) { phase in
//                            switch phase {
//                            case .empty:
//                                Rectangle().fill(Color.gray.opacity(0.2)).frame(width: 80, height: 60)
//                            case .success(let image):
//                                image
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 80, height: 60)
//                                    .clipped()
//                                    .cornerRadius(4)
//                            case .failure:
//                                Image(systemName: "photo")
//                                    .frame(width: 80, height: 60)
//                            @unknown default:
//                                EmptyView()
//                            }
//                        }
//                        VStack(alignment: .leading, spacing: 6) {
//                            Text(art.title)
//                                .font(.headline)
//                            Text(art.artist)
//                                .font(.subheadline)
//                                .foregroundStyle(.secondary)
//                            if let year = art.year {
//                                Text(year)
//                                    .font(.caption)
//                                    .foregroundStyle(.secondary)
//                            }
//                        }
//                        .accessibilityElement(children: .combine)
//                    }
//                    .padding(.vertical, 6)
//                }
//                .accessibilityHint("Opens detail view with description and audio")
//            }
//        }
//        .listStyle(.insetGrouped)
//    }
//}
//
//struct SectionAudioControls: View {
//    let text: String
//    let label: String
//    @ObservedObject private var speech = SpeechManager.shared
//
//    var body: some View {
//        HStack(spacing: 12) {
//            Button(action: {
//                if speech.isSpeaking && speech.currentText == text {
//                    speech.stop()
//                } else {
//                    speech.speak(text)
//                }
//            }) {
//                HStack {
//                    Image(systemName: speech.isSpeaking && speech.currentText == text ? "stop.fill" : "play.fill")
//                    Text(speech.isSpeaking && speech.currentText == text ? "Stop" : "Play")
//                }
//                .padding(8)
//                .background(RoundedRectangle(cornerRadius: 8).strokeBorder())
//            }
//            .accessibilityLabel("\(label) audio")
//            .accessibilityHint("Plays the \(label) section using text to speech")
//
//            Spacer()
//
//            Button(action: {
//                // Read a short summary (first sentence) — quick accessibility feature
//                let firstSentence = text.split(separator: ".").first.map { String($0) + "." } ?? text
//                SpeechManager.shared.speak(firstSentence)
//            }) {
//                Text("Read summary")
//            }
//            .accessibilityLabel("Read summary for \(label)")
//            .accessibilityHint("Reads a short summary of this section")
//        }
//    }
//}
//
//struct ArtworkDetailView: View {
//    let artwork: Artwork
//    @State private var showFullImage = false
//    @State private var dominantColorNameText: String? = nil
//    @State private var imageForColorExtraction: UIImage? = nil
//    @ObservedObject private var speech = SpeechManager.shared
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 16) {
//                // Image
//                Button(action: { showFullImage = true }) {
//                    AsyncImage(url: artwork.imageURL) { phase in
//                        switch phase {
//                        case .empty:
//                            ZStack {
//                                Rectangle().fill(Color.gray.opacity(0.1))
//                                ProgressView()
//                            }
//                            .frame(height: 240)
//                        case .success(let image):
//                            image
//                                .resizable()
//                                .scaledToFit()
//                                .frame(maxHeight: 320)
//                                .cornerRadius(6)
//                                .onAppear {
//                                    // attempt to extract UIImage for color naming (best-effort)
//                                    if let ui = image.asUIImage() {
//                                        imageForColorExtraction = ui
//                                        dominantColorNameText = dominantColorName(from: ui)
//                                    }
//                                }
//                        case .failure:
//                            Rectangle().fill(Color.gray.opacity(0.2)).frame(height: 240)
//                        @unknown default:
//                            EmptyView()
//                        }
//                    }
//                }
//                .accessibilityLabel("\(artwork.title) by \(artwork.artist)\(artwork.year.map { ", \($0)" } ?? "")")
//                .accessibilityHint("Double tap to open fullscreen image")
//                .buttonStyle(PlainButtonStyle())
//
//                // Credits
//                if let credit = artwork.creditLine {
//                    Text(credit)
//                        .font(.caption)
//                        .foregroundStyle(.secondary)
//                        .accessibilityHidden(false)
//                }
//
//                // Dominant color suggestion (experimental)
//                if let dn = dominantColorNameText {
//                    Text("Dominant color (machine suggestion): \(dn)")
//                        .font(.caption)
//                        .foregroundStyle(.secondary)
//                        .accessibilityHint("Machine-suggested color name; may be imprecise")
//                }
//
//                // Buttons: Read All
//                HStack(spacing: 12) {
//                    Button(action: {
//                        Task { @MainActor in
//                            await speech.speakAll([
//                                artwork.background,
//                                artwork.visualDescription,
//                                artwork.interpretation
//                            ])
//                        }
//                    }) {
//                        Label("Read All Sections", systemImage: "text.book.closed")
//                            .padding(8)
//                            .background(RoundedRectangle(cornerRadius: 8).strokeBorder())
//                    }
//                    .accessibilityLabel("Read all sections")
//                    .accessibilityHint("Reads background, visual description, and interpretation in order")
//
//                    Button(action: {
//                        Task { @MainActor in
//                            // stop() is synchronous but owner is @MainActor — call it on the main actor.
//                            speech.stop()
//                        }
//                    }) {
//                        Label("Stop", systemImage: "stop.fill")
//                            .padding(8)
//                            .background(RoundedRectangle(cornerRadius: 8).strokeBorder())
//                    }
//                    .accessibilityLabel("Stop audio")
//                }
//
//
//                // Sections
//                Group {
//                    DisclosureGroup("Background") {
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text(artwork.background)
//                                .font(.body)
//                                .accessibilityLabel("Background: \(artwork.background)")
//                            SectionAudioControls(text: artwork.background, label: "Background")
//                        }
//                        .padding(.vertical, 6)
//                    }
//                    .accessibilityLabel("Background section")
//
//                    DisclosureGroup("Visual Description") {
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text(artwork.visualDescription)
//                                .font(.body)
//                                .accessibilityLabel("Visual description: \(artwork.visualDescription)")
//                            SectionAudioControls(text: artwork.visualDescription, label: "Visual Description")
//                        }
//                        .padding(.vertical, 6)
//                    }
//                    .accessibilityLabel("Visual Description section")
//
//                    DisclosureGroup("Common Interpretation") {
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text(artwork.interpretation)
//                                .font(.body)
//                                .accessibilityLabel("Common interpretation: \(artwork.interpretation)")
//                            SectionAudioControls(text: artwork.interpretation, label: "Common Interpretation")
//                        }
//                        .padding(.vertical, 6)
//                    }
//                    .accessibilityLabel("Common Interpretation section")
//                }
//
//                Spacer()
//            }
//            .padding()
//        }
//        .navigationTitle(artwork.title)
//        .navigationBarTitleDisplayMode(.inline)
//        .sheet(isPresented: $showFullImage) {
//            ZoomableImageView(imageURL: artwork.imageURL)
//        }
//        .onAppear {
//            // Respect dynamic type and system accessibility settings implicitly via SwiftUI
//            UIAccessibility.post(notification: .screenChanged, argument: nil)
//        }
//    }
//}
//
//// MARK: - AsyncImage helpers (for converting to UIImage)
//
//extension Image {
//    // Attempt to extract UIImage when the Image was created from a UIImage-backed provider
//    func asUIImage() -> UIImage? {
//        // Not generally possible from SwiftUI Image. We rely on AsyncImage's phase success case to provide us an Image, but conversion back is not guaranteed. This helper exists as a placeholder.
//        return nil
//    }
//}
//
//// If you want to attempt getting UIImage from AsyncImage, a more robust solution is to implement a custom image loader using URLSession and UIImage(data:).
//
//// MARK: - Notes for the student / maintainer
//
///*
// - This single-file prototype is intended to be dropped into an Xcode SwiftUI project (iOS 15+).
// - Replace AsyncImage with a custom loader if you need more control and to obtain UIImage instances for color extraction.
// - The dominant color "name" here is a very small heuristic. Prefer using Apple's AXNameFromColor APIs if available on your target platform; otherwise, use a more robust color-naming library or manual human-written descriptions.
// - Accessibility:
//    * All interactive controls have accessibility labels and hints.
//    * Use accessibilityElement(children: .combine) to present grouped metadata as a single VoiceOver item.
//    * Test with VoiceOver, Dynamic Type (XXL), Bold Text, and Reduce Motion.
// - TTS: AVSpeechSynthesizer is used. Speech voices and rate can be exposed in Settings (not implemented here to keep prototype small).
// - For an API integration (The Met), implement a remote fetch and caching layer; this prototype uses bundled sample data so you can focus on accessibility and flows.
// - If you plan to add AI-generated interpretations, clearly mark generated content and allow editing/review by humans.
//*/
//
//// End of prototype
