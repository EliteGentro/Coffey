import Foundation
import Vision
import UIKit

class TextRecognizer {
    static func extractText(from image: UIImage, completion: @escaping (String) -> Void) {
        guard let cgImage = image.cgImage else {
            completion("")
            return
        }

        let request = VNRecognizeTextRequest { (request, error) in
            guard error == nil else {
                completion("")
                return
            }

            let recognizedStrings = request.results?.compactMap { result in
                (result as? VNRecognizedTextObservation)?
                    .topCandidates(1)
                    .first?
                    .string
            } ?? []

            completion(recognizedStrings.joined(separator: "\n"))
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            
            try? handler.perform([request])
        }
    }
}
