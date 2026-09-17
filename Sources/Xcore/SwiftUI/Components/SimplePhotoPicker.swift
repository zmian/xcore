//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import PhotosUI
import OSLog

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
public struct SimplePhotoPicker<Label: View & Sendable>: View {
    private let label: Label
    @State private var selectedItems: [PhotosPickerItem] = []
    private let selection: (UIImage) -> Void
    private let onFailure: (Error) -> Void

    /// Creates a simple image picker view.
    ///
    /// - Parameters:
    ///   - selection: A closure that will be called when an image is selected. The
    ///     selected `UIImage` is passed as a parameter to this closure.
    ///   - onFailure: Called when loading or decoding fails. Cancellation is ignored.
    ///   - label: The view that describes the action of choosing an item.
    public init(
        selection: @escaping (UIImage) -> Void,
        onFailure: @escaping (Error) -> Void = { error in
            Logger(subsystem: "Xcore", category: "PhotoPicker").error("Photo selection failed: \(error.localizedDescription)")
        },
        @ViewBuilder label: () -> Label
    ) {
        self.selection = selection
        self.onFailure = onFailure
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
        .task(id: selectedItems) {
            guard let item = selectedItems.first else { return }
            do {
                guard
                    let data = try await item.loadTransferable(type: Data.self),
                    let image = UIImage(data: data)
                else {
                    throw CocoaError(.fileReadCorruptFile)
                }
                try Task.checkCancellation()
                selection(image)
            } catch is CancellationError {
                // A new selection or dismissal cancels the previous load.
            } catch {
                guard !Task.isCancelled else { return }
                onFailure(error)
            }
        }
    }
}
