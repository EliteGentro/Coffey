//
//  SectionAudioControls.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 25/09/25.
//

import SwiftUI

struct SectionAudioControls: View {
    let text: String
    @ObservedObject private var speech = SpeechManager.shared

    private var isPlayingThisText: Bool {
        speech.isSpeaking && speech.currentText.hashValue == text.hashValue
    }

    var body: some View {
        HStack {
            Button {
                if isPlayingThisText {
                    speech.stop()
                } else {
                    speech.speak(text)
                }
            } label: {
                Image(systemName: isPlayingThisText ? "stop.fill" : "play.fill")
            }
        }
    }
}

//#Preview{
//    SectionAudioControls(text: Artwork.mock.visualDescription, label: "TestDescription")
//}
