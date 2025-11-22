//
//  SectionAudioControls.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 25/09/25.
//

import SwiftUI

struct SectionAudioControls: View {
    let text: String
    let label: String
    @ObservedObject private var speech = SpeechManager.shared

    var body: some View {
        HStack {
            Button {
                Task { @MainActor in
                    if speech.isSpeaking && speech.currentText == text {
                        speech.stop()
                    } else {
                        speech.speak(text)
                    }
                }
            } label: {
                Image(systemName: speech.isSpeaking && speech.currentText == text ? "stop.fill" : "play.fill")
            }
            Button {
                Task { @MainActor in
                    let summary = text.split(separator: ".").first.map { String($0) + "." } ?? text
                    speech.speak(summary)
                }
            } label: { Text("Read summary") }
        }
    }
}

#Preview{
    SectionAudioControls(text: Artwork.mock.visualDescription, label: "TestDescription")
}
