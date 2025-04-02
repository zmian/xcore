//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A SwiftUI view that asynchronously loads and displays an image with an
/// optional placeholder.
///
/// This view automatically selects an appropriate rendering strategy based on
/// the current execution target (e.g., app, widget, or extension). It provides
/// built-in support for placeholders, smooth image loading transitions, and
/// specialized handling for widgets.
///
/// **Usage**
///
/// ```swift
/// ImageView(url) {
///     PlaceholderImage()
/// }
/// ```
public struct ImageView<Placeholder: View>: View {
    @State private var uiImage: UIImage?
    @State private var showPlaceholder = false
    private let imageRepresentable: ImageRepresentable?
    private let placeholder: () -> Placeholder
    private let contentMode: ContentMode
    private var animated = true
    private var useSampleImageForTesting = ImageView<Never>.useSampleImageForTesting

    public var body: some View {
        switch AppInfo.executionTarget {
            case .app:
                appBody
            case .widget, .appExtension:
                widgetsBody
        }
    }

    /// The view rendered when the execution context is a standard app.
    private var appBody: some View {
        VStack {
            if showPlaceholder, hasPlaceholderView {
                placeholder()
            } else if let image = imageRepresentable {
                ImageViewRepresentable(
                    image,
                    contentMode: contentMode,
                    animated: animated,
                    useSampleImageForTesting: useSampleImageForTesting,
                    uiImage: $uiImage
                )
            } else {
                makePlaceholderView()
            }
        }
        .onChange(of: uiImage) { _, uiImage in
            let shouldShowPlaceholder = uiImage == nil

            if showPlaceholder != shouldShowPlaceholder {
                showPlaceholder = shouldShowPlaceholder
            }
        }
    }

    /// The specialized synchronous view used in widget contexts.
    ///
    /// Widgets prohibit asynchronous loading from views. This synchronous method
    /// is only used within widget targets as the OS optimizes to prevent UI
    /// blocking.
    @ViewBuilder
    private var widgetsBody: some View {
        if let widgetsImage {
            Image(uiImage: widgetsImage.removingAlpha())
                .resizable()
        } else {
            makePlaceholderView()
        }
    }

    private var widgetsImage: UIImage? {
        switch imageRepresentable?.imageSource {
            case .none:
                return nil
            case let .url(string):
                if
                    let url = URL(string: string),
                    let data = try? Data(contentsOf: url),
                    let uiImage = UIImage(data: data)
                {
                    return uiImage
                }

                return nil
            case let .uiImage(image):
                return image
        }
    }

    /// A Boolean value indicating whether a placeholder view is provided.
    private var hasPlaceholderView: Bool {
        Placeholder.self != Never.self
    }

    /// Generates and returns the placeholder view or a transparent fallback.
    @ViewBuilder
    private func makePlaceholderView() -> some View {
        if hasPlaceholderView {
            placeholder()
        } else {
            Color.clear
        }
    }
}

// MARK: - Inits

extension ImageView {
    /// Creates an image view with the provided image source and placeholder.
    ///
    /// - Parameters:
    ///   - image: The source of the image to load.
    ///   - contentMode: The content mode specifying how the image should fit the
    ///     available space.
    ///   - placeholder: A view builder returning the placeholder to be displayed
    ///     when the source image is not found or an error occurs.
    public init(
        _ image: ImageRepresentable?,
        contentMode: ContentMode = .fit,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.imageRepresentable = image
        self.placeholder = placeholder
        self.contentMode = contentMode
    }

    /// Creates an image view with the provided image source.
    ///
    /// - Parameters:
    ///   - image: The source of the image to load.
    ///   - contentMode: The content mode specifying how the image should fit the
    ///     available space.
    public init(
        _ image: ImageRepresentable?,
        contentMode: ContentMode = .fit
    ) where Placeholder == Never {
        self.init(image, contentMode: contentMode) {
            fatalError()
        }
    }
}

// MARK: - Convenience Methods

extension ImageView {
    /// Configures whether the image loading transition is animated.
    ///
    /// - Parameter animate: A Boolean indicating if the image transition should
    ///   animate.
    /// - Returns: An updated `ImageView` instance.
    ///
    /// - Note: When set to `true` the image will only fade in when fetched from a remote
    /// url and not in memory cache.
    public func animated(_ animate: Bool) -> Self {
        var copy = self
        copy.animated = animate
        return copy
    }
}

// MARK: - Convenience Methods (Testing)

extension ImageView {
    /// Configures whether a sample image is displayed during tests for remote image
    /// sources.
    ///
    /// When set to `true`, the `ImageView` uses a lightweight, local sample image
    /// to avoid network requests during testing, reducing test runtime. Set to
    /// `false` to disable this behavior and use the actual provided image source.
    /// The default value is `true`.
    ///
    /// - Parameter flag: A Boolean value indicating whether to use a sample image
    ///   during testing when source is a _remote image_.
    /// - Returns: An updated `ImageView` instance configured with the specified
    ///   setting.
    public func useSampleImageForTesting(_ flag: Bool) -> Self {
        var copy = self
        copy.useSampleImageForTesting = flag
        return copy
    }
}

extension ImageView<Never> {
    /// A global flag indicating if a sample image should be used by default during
    /// testing for _remote images_.
    ///
    /// The default value is `true`. Set this property to `false` to globally
    /// disable the use of sample image.
    public static var useSampleImageForTesting = true
}

// MARK: - Representable

private struct ImageViewRepresentable: UIViewRepresentable {
    private let imageRepresentable: ImageRepresentable?
    private let contentMode: UIView.ContentMode
    private let animated: Bool
    private let useSampleImageForTesting: Bool
    @Binding private var uiImage: UIImage?

    /// Creates a UIKit-based representable image view.
    ///
    /// - Parameters:
    ///   - image: The source of the image to load.
    ///   - contentMode: Specifies how the image should fit its bounds.
    ///   - animated: Controls whether the image transition is animated.
    ///   - useSampleImageForTesting: A Boolean value indicating whether to use a
    ///     sample image during testing when source is a _remote image_.
    ///   - uiImage: A binding to the loaded `UIImage`.
    init(
        _ image: ImageRepresentable?,
        contentMode: ContentMode,
        animated: Bool,
        useSampleImageForTesting: Bool,
        uiImage: Binding<UIImage?>
    ) {
        self.imageRepresentable = image
        self.useSampleImageForTesting = useSampleImageForTesting
        self.animated = animated
        self._uiImage = uiImage
        self.contentMode = switch contentMode {
            case .fill: .scaleAspectFill
            case .fit: .scaleAspectFit
        }
    }

    func makeUIView(context: Context) -> WrapperView {
        WrapperView().apply {
            configure($0)
        }
    }

    func updateUIView(_ uiView: WrapperView, context: Context) {
        configure(uiView)
    }

    /// Configures the underlying UIKit view with provided settings.
    private func configure(_ uiView: WrapperView) {
        uiView.imageView.apply {
            var source = imageRepresentable

            #if DEBUG
            if isTesting, useSampleImageForTesting, source?.imageSource.isRemoteUrl == true {
                source = UIImage.sample
            }
            #endif

            $0.setImage(source, duration: animated ? .default : 0) { image in
                DispatchQueue.main.async {
                    uiImage = image
                }
            }
            $0.contentMode = contentMode
        }
    }
}

// MARK: - Wrapper View

extension ImageViewRepresentable {
    /// A container view hosting a UIKit image view within SwiftUI.
    final class WrapperView: XCView {
        let imageView = UIImageView().apply {
            $0.enableSmoothScaling()
        }

        override func commonInit() {
            addSubview(imageView)

            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
    }
}

// MARK: - Widget Image Processing

extension UIImage {
    /// Returns a copy of the image with the alpha channel removed.
    ///
    /// This addresses rendering issues in widgets, where images containing an
    /// alpha channel may display incorrectly.
    fileprivate func removingAlpha() -> UIImage {
        let format = UIGraphicsImageRendererFormat().apply {
            $0.opaque = true
            $0.scale = scale
        }

        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            draw(in: CGRect(size))
        }
    }
}

#if DEBUG

// MARK: - Sample Image (Testing)

extension UIImage {
    /// Provides a lightweight sample image suitable for use in tests.
    ///
    /// The `ImageView` uses this sample image during tests to avoid unnecessary
    /// network requests for _remote images_ and to reduce test runtime. You can
    /// disable this behavior globally or per `ImageView` instance by setting the
    /// ``ImageView.useSampleImageForTesting`` flag to `false`.
    public static let sample = UIImage(system: .photo)
}
#endif
