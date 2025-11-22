//
//  TextRecognizer.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 01/10/25.
//

import Foundation
import SwiftUI
import Vision
import UIKit

struct TextRecognizer {
    var recognizedText: String = ""
    var observations: [RecognizedTextObservation] = []

    init(image: UIImage) async {
        var request = RecognizeTextRequest()
        request.recognitionLevel = .accurate

        if let imageData = image.pngData() {
            do {
                let results = try await request.perform(on: imageData)
                observations = results

                for observation in observations {
                    let candidates = observation.topCandidates(1)
                    if let candidate = candidates.first,
                       candidate.confidence >= 0.6 {
                        recognizedText += "\(candidate.string) "
                    }
                }
            } catch {
                print("Text recognition failed: \(error.localizedDescription)")
            }
        }
    }
}


// A lightweight model for navigation
struct TextReaderResult: Hashable {
    let text: String
}
