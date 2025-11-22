//
//  TextRecognitionView.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 01/10/25.
//

import SwiftUI

struct TextRecognitionView: View {
    let text: String
    @ObservedObject private var speech = SpeechManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Recognized Text")
                .font(.headline)
            ScrollView {
                TranslatedText(original:text, font: .body)
                    .padding()
            }
            Button {
                if speech.isSpeaking {
                    speech.stop()
                } else {
                    speech.speak(text)
                }
            } label: {
                Label(speech.isSpeaking ? "Stop Reading" : "Read / Stop", systemImage: speech.isSpeaking ? "stop.fill" : "play.fill")
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke())
            }
        }
        .padding()
        .navigationTitle("Text Reader")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    TextRecognitionView(text: "This is a sample text for testing purposes. It should be replaced with actual text from an image.")
}
