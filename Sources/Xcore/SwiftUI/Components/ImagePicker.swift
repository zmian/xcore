//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) fileprivate var presentationMode
    fileprivate var callback: (UIImage) -> Void

    public init(callback: @escaping (UIImage) -> Void) {
        self.callback = callback
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIViewController(context: Context) -> UIImagePickerController {
        UIImagePickerController().apply {
            $0.allowsEditing = true
            $0.delegate = context.coordinator
        }
    }

    public func updateUIViewController(_ picker: UIImagePickerController, context: Context) {}
}

extension ImagePicker {
    public final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        private let parent: ImagePicker

        fileprivate init(_ parent: ImagePicker) {
            self.parent = parent
        }

        public func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let uiImage = info[.editedImage] as? UIImage {
                parent.callback(uiImage)
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
