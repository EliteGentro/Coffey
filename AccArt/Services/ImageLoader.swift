//
//  ImageLoader.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 25/09/25.
//

import SwiftUI

final class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSURL, UIImage>()
    private init() {}

    func loadImage(url: URL) async -> UIImage? {
        if let cached = cache.object(forKey: url as NSURL) { return cached }
        do {
            let (data, resp) = try await URLSession.shared.data(from: url)
            if let http = resp as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
                print("ImageLoader: HTTP error \(http.statusCode) for \(url)")
                return nil
            }
            guard let img = UIImage(data: data) else {
                print("ImageLoader: decode failed for \(url)")
                return nil
            }
            cache.setObject(img, forKey: url as NSURL)
            return img
        } catch {
            print("ImageLoader: network error \(error) for \(url)")
            return nil
        }
    }
}
