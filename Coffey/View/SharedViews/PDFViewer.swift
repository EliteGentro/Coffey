//
//  PDFViewer.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 13/11/25.
//

import Foundation
import SwiftUI
import PDFKit

struct PDFViewerContainer: View {
    @Environment(\.dismiss) private var dismiss
    let content: Content

    var body: some View {
        ZStack(alignment: .topTrailing) {
            PDFKitView(content: content)
                .ignoresSafeArea()

            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .scaledFont(.system(size: 32))
                    .foregroundColor(.white)
                    .shadow(radius: 4)
                    .padding()
            }
        }
    }
}
