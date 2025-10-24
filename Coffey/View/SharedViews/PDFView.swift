//
//  PDFView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 23/10/25.
//

import Foundation
import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    let content: Content
    
    
    func makeUIView(context: Context) -> PDFView {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = docsUrl.appendingPathComponent("\(content.content_id).pdf")
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.document = PDFDocument(url: destinationUrl)
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
