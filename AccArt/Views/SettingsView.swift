//
//  SettingsView.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 08/10/25.
//

// SettingsView.swift
import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"

    var body: some View {
        Form {
            // Language selection section
            Section(header: TranslatedText(original: "Language")) {
                Picker(selection: $selectedLanguage) {
                    Label {
                        TranslatedText(original: "English")
                    } icon: {
                        Image(systemName: "globe")
                    }
                    .tag("en")

                    Label {
                        TranslatedText(original: "Spanish")
                    } icon: {
                        Image(systemName: "globe")
                    }
                    .tag("es")

                    Label {
                        TranslatedText(original: "French")
                    } icon: {
                        Image(systemName: "globe")
                    }
                    .tag("fr")
                } label: {
                    TranslatedText(original: "App language")
                }
                .pickerStyle(.inline)
                .accessibilityLabel("App language")
                .accessibilityHint("Choose the language for on-device translations")
            }

            // Info / description section
            Section {
                TranslatedText(
                    original: "Translations are performed on-device using Apple's Translation models. The system may prompt to download language models the first time you request a translation.",
                    font: .footnote
                )
                .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
}
