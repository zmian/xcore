//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    public func onLongPressTrackingGesture(
        minimumPressDuration: TimeInterval = 0.1,
        allowableMovement: CGFloat = 500,
        onChanged: @escaping (CGPoint) -> Void,
        onEnded: @escaping () -> Void
    ) -> some View {
        overlay(
            LongPressTrackingGestureRecognizer(
                minimumPressDuration: minimumPressDuration,
                allowableMovement: allowableMovement,
                onChanged: onChanged,
                onEnded: onEnded
            )
        )
    }
}

// MARK: - Representable

private struct LongPressTrackingGestureRecognizer: UIViewRepresentable {
    private let minimumPressDuration: TimeInterval
    private let allowableMovement: CGFloat
    private let onChanged: (CGPoint) -> Void
    private let onEnded: () -> Void

    init(
        minimumPressDuration: TimeInterval,
        allowableMovement: CGFloat,
        onChanged: @escaping (CGPoint) -> Void,
        onEnded: @escaping () -> Void
    ) {
        self.minimumPressDuration = minimumPressDuration
        self.allowableMovement = allowableMovement
        self.onChanged = onChanged
        self.onEnded = onEnded
    }

    func makeUIView(context: Context) -> some UIView {
        let view = UIView().apply {
            $0.backgroundColor = .clear
        }

        let longPressGesture = UILongPressGestureRecognizer {
            onChanged($0.location(in: $0.view))
            if [.ended, .cancelled, .failed].contains($0.state) {
                onEnded()
            }
        }.apply {
            $0.minimumPressDuration = minimumPressDuration
            $0.allowableMovement = allowableMovement
        }

        view.addGestureRecognizer(longPressGesture)
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
