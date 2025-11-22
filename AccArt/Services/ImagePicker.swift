//
//  ImagePicker.swift
//  AccArt
//
//  Created by Humberto Genaro Cisneros Salinas on 25/09/25.
//

import SwiftUI

/// Simple UIImagePickerController wrapper. Use `sourceType: .camera` to open camera.
/// Falls back to .photoLibrary if camera not available (simulator or restricted device).
struct ImagePicker: UIViewControllerRepresentable {
    enum PickerError: Error {
        case unavailable
    }

    var sourceType: UIImagePickerController.SourceType = .camera
    var allowsEditing: Bool = false
    var completion: (UIImage?) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = allowsEditing
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(sourceType) ? sourceType : .photoLibrary
        // prefer high-quality capture
        picker.cameraCaptureMode = .photo
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // nothing to update
    }

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.completion(nil)
        }
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let key: UIImagePickerController.InfoKey = parent.allowsEditing ? .editedImage : .originalImage
            let img = info[key] as? UIImage
            parent.completion(img)
        }
    }
}
