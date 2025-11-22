//
//  ArtworkRecognizer.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 27/09/25.
//
import Foundation
import CoreML
import UIKit
import Combine


@MainActor
class ArtworkRecognizer: ObservableObject {
    @Published var recognizedArtwork: Artwork? = nil
    @Published var showLowConfidenceAlert: Bool = false
    
    private let repo: ArtworkRepository
    private let model: AccArtClassifier_
    
    init(repo: ArtworkRepository) {
        self.repo = repo
        self.model = try! AccArtClassifier_(configuration: MLModelConfiguration())
    }
    
    func recognize(image: UIImage) {
        guard let buffer = image.pixelBuffer(width: 224, height: 224) else { return }
        
        do {
            let prediction = try model.prediction(image: buffer)
            let predictedName = prediction.target
            let confidence = prediction.targetProbability[predictedName] ?? 0.0
            if confidence >= 0.6, let art = repo.artwork(forTitle: predictedName) {
                self.recognizedArtwork = art
            } else {
                self.showLowConfidenceAlert = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showLowConfidenceAlert = false
                }
            }
        } catch {
            print("❌ Prediction failed: \(error)")
        }
    }
}

