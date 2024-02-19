//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import PhotosUI

/// A view that displays a Photos picker for choosing a single image from the
/// photo library.
///
/// Use the simple Photos picker view to browse and select an image from the
/// photo library.
///
/// **Usage**
///
/// ```swift
/// struct ContentView: View {
///     @State private var selectedImage: UIImage?
///
///     var body: some View {
///         SimplePhotoPicker { image in
///             selectedImage = image
///         } label: {
///             Text("Select Image")
///         }
///     }
/// }
/// ```
public struct SimplePhotoPicker<Label: View>: View {
    private let label: Label
    @State var selectedItems: [PhotosPickerItem] = []
    private let callback: (UIImage) -> Void

    /// Creates a simple image picker view.
    ///
    /// - Parameters:
    ///   - selection: A closure that will be called when an image is selected. The
    ///     selected `UIImage` is passed as a parameter to this closure.
    ///   - label: The view that describes the action of choosing an item.
    public init(
        selection: @escaping (UIImage) -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.callback = selection
        self.label = label()
    }

    public var body: some View {
        PhotosPicker(
            selection: $selectedItems,
            maxSelectionCount: 1,
            matching: .images
        ) {
            label
        }
        .onChange(of: selectedItems) { selectedItems in
            Task {
                if
                    let data = try await selectedItems.first?.loadTransferable(type: Data.self),
                    let image = UIImage(data: data) {
                    callback(image)
                }
            }
        }
    }
}
