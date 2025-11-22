//
//  CameraCaptureView.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 25/09/25.
//

import SwiftUI

struct CameraCaptureView: View {
    var onImageCaptured: (UIImage?) -> Void
    var onCancel: () -> Void
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Present the UIKit picker full-screen
            ImagePicker(sourceType: .camera, allowsEditing: false) { image in
                if let img = image {
                    // Return the captured image
                    onImageCaptured(img)
                } else {
                    onCancel()
                }
            }
            .ignoresSafeArea()
            
        }
    }
}


#Preview {
    CameraCaptureView(
        onImageCaptured: { _ in
        },
        onCancel: {
        })
}
