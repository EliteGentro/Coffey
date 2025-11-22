//
//  Extensions.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 25/09/25.
//

// Extensions.swift
import SwiftUI
import UIKit

import Foundation
@preconcurrency import Hub

// Convenience: Construct a SwiftUI Image from a UIImage
extension Image {
    init(uiImageOrPlaceholder uiImage: UIImage?) {
        if let ui = uiImage {
            self = Image(uiImage: ui)
        } else {
            self = Image(systemName: "photo")
        }
    }
}

// UIImage helper: downscale (if needed)
extension UIImage {
    func scaled(toMaxDimension maxDim: CGFloat) -> UIImage {
        let maxSide = max(size.width, size.height)
        guard maxSide > maxDim else { return self }
        let scale = maxDim / maxSide
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let scaled = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaled ?? self
    }
}

// String helpers
extension String {
    /// Return the first sentence (a simple heuristic)
    var firstSentence: String {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if let idx = trimmed.firstIndex(of: ".") {
            let end = trimmed.index(after: idx)
            return String(trimmed[..<end])
        }
        return trimmed
    }
}



/// Extension providing a default HubApi instance for downloading model files
extension HubApi {
    /// Default HubApi instance configured to download models to the user's Downloads directory
    /// under a 'huggingface' subdirectory.
    #if os(macOS)
        static let `default` = HubApi(
            downloadBase: URL.downloadsDirectory.appending(path: "huggingface")
        )
    #else
        static let `default` = HubApi(
            downloadBase: URL.cachesDirectory.appending(path: "huggingface")
        )
    #endif
}
