//
//  TranslatedText.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 08/10/25.
//

// TranslatedText.swift
import SwiftUI
import Translation

/// A small view that displays `original` and automatically translates it
/// to the language stored in AppStorage("selectedLanguage") using
/// the Translation framework.
/// - Note: Translation framework requires device testing (doesn't work on simulator).
struct TranslatedText: View {
    let original: String
    var font: Font? = nil
    var multilineAlignment: TextAlignment = .leading

    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"

    @State private var translated: String? = nil
    @State private var translationConfig: TranslationSession.Configuration? = nil

    var body: some View {
        Group {
            if let translated = translated, !translated.isEmpty {
                Text(translated)
                    .font(font)
                    .multilineTextAlignment(multilineAlignment)
            } else {
                // While we are translating (or if translation fails), show the original
                Text(original)
                    .font(font)
                    .multilineTextAlignment(multilineAlignment)
            }
        }
        // Rebuild / trigger new session when the selected language changes
        .onChange(of: selectedLanguage) {
            prepareTranslationConfig()
        }

        .onAppear {
            prepareTranslationConfig()
        }
        // Attach the translationTask modifier which gives us the live session
        .translationTask(translationConfig) { session in
            // If target is "en" (English) we still attempt to translate because user may
            // want explicit target. If original language == target, translate() will return same text.
            do {
                // Optionally pre-download models (prepareTranslation()) and then translate.
                try await session.prepareTranslation()
                let response = try await session.translate(original)
                await MainActor.run {
                    self.translated = response.targetText
                }
            } catch {
                // On failure, keep the original text (translated stays nil).
                // Print error for debugging but don't crash.
                print("Translation error for text: \(error)")
            }
        }
    }

    private func prepareTranslationConfig() {
        // invalidate previous if present
        translationConfig?.invalidate()

        // Map the small language code into the expected Locale.Language (Translation API uses Locale.Language)
        let lang = languageFrom(code: selectedLanguage)
        translationConfig = TranslationSession.Configuration(
            source: Locale.Language(languageCode: .english),
            target: lang
        )
        // reset cached translation until a new session produces translated text
        translated = nil
    }

    private func languageFrom(code: String) -> Locale.Language {
        switch code {
        case "es": return Locale.Language(languageCode: .spanish)
        case "fr": return Locale.Language(languageCode: .french)
        default:  return Locale.Language(languageCode: .english)
        }
    }
}
