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

    var body: some View {

        HStack{
            Button(action: {
                Task { @MainActor in
                    if speech.isSpeaking && speech.currentText == text {
                        speech.stop()
                    } else {
                        speech.speak(text)
                    }
                }
            }) {
                Image(systemName: speech.isSpeaking && speech.currentText == text ? "stop.fill" : "play.fill")
            }
        }
    }
}

//#Preview{
//    SectionAudioControls(text: Artwork.mock.visualDescription, label: "TestDescription")
//}
