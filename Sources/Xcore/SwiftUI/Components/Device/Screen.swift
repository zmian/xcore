//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import Combine

/// The display associated with a specific window scene.
///
/// Create a screen from the scene presenting your content. For SwiftUI layout,
/// prefer the view's proposed size and the `displayScale` environment value.
@MainActor
public final class Screen: ObservableObject {
    private let screen: UIScreen
    private var cancellable: AnyCancellable?

    /// Creates a display wrapper for the supplied window scene.
    public init(scene: UIWindowScene) {
        screen = scene.screen
        cancellable = NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .sink { [weak self] _ in
                Task { @MainActor [weak self] in
                    self?.objectWillChange.send()
                }
            }
    }

    /// The number of pixels per point on this display.
    public var scale: CGFloat {
        screen.scale
    }

    /// The display bounds in points. Use the window bounds for window layout.
    public var bounds: CGRect {
        screen.bounds
    }

    /// The display size in points.
    public var size: CGSize {
        bounds.size
    }

    /// The reference size matching this display.
    public var referenceSize: ReferenceSize {
        .init(size: size)
    }

    /// The display brightness, between zero and one.
    ///
    /// UIKit supports changing brightness only on the device's built-in display.
    public var brightness: CGFloat {
        get { screen.brightness }
        set { screen.brightness = newValue }
    }
}
