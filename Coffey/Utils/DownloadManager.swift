//
//  DownloadManager.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 20/10/25.
//


import Foundation
import AVKit
import Combine
import SwiftData
import PDFKit
import SwiftUI

final class DownloadManager: ObservableObject {
    //May be missing context
    let modelContainer: ModelContainer
    private let context: ModelContext

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.context = modelContainer.mainContext
    }



    @Published private var downloadingStatus: [Int: Bool] = [:]
    @Published private var downloadedStatus: [Int: Bool] = [:]
    
    // MARK: - Public computed helpers
    func isDownloading(_ content: Content) -> Bool {
        return downloadingStatus[content.content_id] ?? false
    }

    func isDownloaded(_ content: Content) -> Bool {
        return downloadedStatus[content.content_id] ?? false
    }

    // MARK: - Core logic
    func downloadFile(content: Content) {
        print("downloadFile \(content.url)")
        
        let contentID = content.content_id // capture simple Sendable value
        let contentURLString = content.url

        downloadingStatus[contentID] = true
        objectWillChange.send()

        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationUrl = content.resourceType == "video" ? docsUrl.appendingPathComponent("\(contentID).mp4") :
            docsUrl.appendingPathComponent("\(contentID).pdf")
        
        print(docsUrl)
        print(destinationUrl)

        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("File already exists")
            downloadingStatus[contentID] = false
            downloadedStatus[contentID] = true
            return
        }

        guard let url = URL(string: contentURLString) else {
            print("Invalid URL")
            downloadingStatus[contentID] = false
            return
        }

        // ✅ only captures Sendable values (Int, String)
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            defer {
                DispatchQueue.main.async {
                    self.downloadingStatus[contentID] = false
                }
            }

            if let error = error {
                print("Request error: ", error)
                return
            }

            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data
            else { return }

            DispatchQueue.main.async {
                do {
                    try data.write(to: destinationUrl, options: .atomic)
                    self.downloadedStatus[contentID] = true
                    content.isDownloaded = true
                    do {
                        //Save context
                        try self.context.save()
                    } catch {
                        print(error)
                    }
                } catch {
                    print("Error writing file: ", error)
                }
            }
        }

        dataTask.resume()
    }


    func deleteFile(content: Content) {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationUrl = content.resourceType == "video" ? docsUrl.appendingPathComponent("\(content.content_id).mp4") :
            docsUrl.appendingPathComponent("\(content.content_id).pdf")

        guard FileManager.default.fileExists(atPath: destinationUrl.path) else { return }

        do {
            try FileManager.default.removeItem(at: destinationUrl)
            print("File deleted successfully")
            downloadedStatus[content.content_id] = false
            content.isDownloaded = false
            do {
                //Save context
                try self.context.save()
            } catch {
                print(error)
            }

        } catch {
            print("Error while deleting video file: ", error)
        }
    }

    func checkFileExists(content: Content) {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = content.resourceType == "video" ? docsUrl.appendingPathComponent("\(content.content_id).mp4") :
            docsUrl.appendingPathComponent("\(content.content_id).pdf")

        downloadedStatus[content.content_id] = FileManager.default.fileExists(atPath: destinationUrl.path)
    }

    func getVideoFileAsset(content: Content) -> AVPlayerItem? {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = docsUrl.appendingPathComponent("\(content.content_id).mp4")
        print("Video File Asset \(destinationUrl)")
        print("Name: \(content.name)")

        guard FileManager.default.fileExists(atPath: destinationUrl.path) else { return nil }
        let avAsset = AVURLAsset(url: destinationUrl)
        return AVPlayerItem(asset: avAsset)
    }
    
    

    func getPDFView(for content: Content) -> PDFView? {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = docsUrl.appendingPathComponent("\(content.content_id).pdf")
        print("PDF File Path: \(destinationUrl)")
        print("Name: \(content.name)")

        guard FileManager.default.fileExists(atPath: destinationUrl.path) else { return nil }

        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.document = PDFDocument(url: destinationUrl)
        return pdfView
    }

}
