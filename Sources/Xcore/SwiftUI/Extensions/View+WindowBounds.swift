//
// Xcore
// Copyright © 2026 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Adds an action to perform when the bounds of the containing window change.
    ///
    /// Use this modifier to adapt content to the size of its window, including
    /// when the content occupies only part of that window. For example, you can
    /// limit a popup's width to a fraction of the window's shortest side:
    ///
    /// ```swift
    /// struct WindowSizedPopup: View {
    ///     @State private var preferredWidth: CGFloat = 300
    ///
    ///     var body: some View {
    ///         Text("Hello, world!")
    ///             .frame(width: preferredWidth)
    ///             .onWindowBoundsChange { bounds in
    ///                 preferredWidth = min(300, bounds.size.min * 0.8)
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// The bounds are measured in points in the containing window's coordinate
    /// space and include its safe areas. They describe the window, rather than
    /// the modified view or the physical display.
    ///
    /// The action receives an initial measurement after the view attaches to a
    /// window, then receives changed bounds as the window lays out. Attaching to
    /// another window starts a new sequence of measurements, even if its bounds
    /// match the previous window's bounds.
    ///
    /// Delivery occurs asynchronously on the main actor so the action can update
    /// view state. Pending measurements are coalesced, and unchanged bounds are
    /// reported only once per attachment. No value is delivered while the view
    /// is detached. Removing the modifier stops observation.
    ///
    /// - Parameter action: The action to perform with the containing window's
    ///   current bounds.
    /// - Returns: A view that observes the bounds of its containing window.
    public func onWindowBoundsChange(
        perform action: @escaping @MainActor (CGRect) -> Void
    ) -> some View {
        background {
            WindowBoundsObserver(action: action)
                .allowsHitTesting(false)
                .accessibilityHidden(true)
        }
    }
}

/// Bridges a SwiftUI action to the containing window's layout lifecycle.
///
/// SwiftUI owns the attachment view. Each update supplies the current action,
/// and dismantling removes the measurement view and cancels pending delivery.
private struct WindowBoundsObserver: UIViewRepresentable {
    let action: @MainActor (CGRect) -> Void

    func makeUIView(context: Context) -> WindowBoundsAttachmentView {
        let view = WindowBoundsAttachmentView()
        view.isUserInteractionEnabled = false
        view.measurementView.onChange = action
        return view
    }

    func updateUIView(_ uiView: WindowBoundsAttachmentView, context: Context) {
        uiView.measurementView.onChange = action
    }

    static func dismantleUIView(_ uiView: WindowBoundsAttachmentView, coordinator: Void) {
        uiView.measurementView.onChange = nil
        uiView.measurementView.removeFromSuperview()
    }
}

/// Locates the window containing the modified SwiftUI view.
///
/// This view follows SwiftUI's hierarchy, while its measurement view is
/// installed directly in the window. Keeping these roles separate allows window
/// resizing to be observed even when a fixed-size SwiftUI ancestor doesn't
/// resize. Detaching from a window removes the measurement view from that
/// window.
private final class WindowBoundsAttachmentView: UIView {
    /// The noninteractive view that follows the containing window's size.
    let measurementView = WindowBoundsView()

    override func didMoveToWindow() {
        super.didMoveToWindow()
        measurementView.removeFromSuperview()
        guard let window else { return }
        measurementView.frame = window.bounds
        measurementView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        measurementView.isUserInteractionEnabled = false
        measurementView.accessibilityElementsHidden = true
        window.insertSubview(measurementView, at: 0)
    }
}

/// Observes window layout independently of the modified SwiftUI view's size.
///
/// The attachment view sizes this view to the window and enables flexible width
/// and height. Layout callbacks schedule a measurement of the window's bounds,
/// rather than reporting the measurement view's own frame.
private final class WindowBoundsView: UIView {
    /// The action to receive measurements, or `nil` after observation ends.
    var onChange: (@MainActor (CGRect) -> Void)?
    private var reportedBounds: CGRect?
    private var updatePending = false

    override func didMoveToWindow() {
        super.didMoveToWindow()
        reportedBounds = nil
        scheduleMeasurement()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scheduleMeasurement()
    }

    /// Coalesces layout callbacks into a deferred measurement.
    ///
    /// Reading the window and action at delivery time avoids reporting stale
    /// bounds after reattachment. Weak capture and attachment checks prevent
    /// pending work from retaining this view or reporting after detachment.
    private func scheduleMeasurement() {
        guard !updatePending else { return }
        updatePending = true
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            updatePending = false
            guard let window, let onChange else { return }
            let bounds = window.bounds
            guard bounds != reportedBounds else { return }
            reportedBounds = bounds
            onChange(bounds)
        }
    }
}
