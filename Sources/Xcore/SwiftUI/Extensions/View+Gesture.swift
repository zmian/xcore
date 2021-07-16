//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - On Tap

extension View {
    /// Returns a version of `self` that will perform `action` when `self` is
    /// triggered.
    public func onTap(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            self
        }
        .buttonStyle(.scaleEffect)
    }

    /// Adds an action to perform when this view recognizes a tap gesture.
    ///
    /// Use this method to perform a specific `action` when the user clicks or
    /// taps on the view or container `count` times.
    ///
    /// > Note: If you are creating a control that's functionally equivalent
    /// to a ``Button``, use ``ButtonStyle`` to create a customized button
    /// instead.
    ///
    /// In the example below, the color of the heart images changes to a random
    /// color from the `colors` array whenever the user clicks or taps on the
    /// view twice:
    ///
    /// ```swift
    /// struct TapGestureExample: View {
    ///     @State private var fgColor: Color = .gray
    ///     let colors: [Color] = [
    ///         .gray, .red, .orange, .yellow,
    ///         .green, .blue, .purple, .pink
    ///     ]
    ///
    ///     var body: some View {
    ///         Image(systemName: "heart.fill")
    ///             .resizable()
    ///             .frame(width: 200, height: 200)
    ///             .foregroundColor(fgColor)
    ///             .onTapGesture(count: 2, simultaneous: true) {
    ///                 fgColor = colors.randomElement()!
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// ![A screenshot of a view of a heart.](SwiftUI-View-TapGesture.png)
    ///
    /// - Parameters:
    ///    - count: The number of taps or clicks required to trigger the action
    ///      closure provided in `action`. Defaults to `1`.
    ///    - simultaneous: A boolean value determine whether to process tap gesture
    ///      simultaneously with gestures defined by the view.
    ///    - action: The action to perform.
    @ViewBuilder
    public func onTapGesture(count: Int = 1, simultaneous: Bool, perform action: @escaping () -> Void) -> some View {
        #if os(tvOS)
        // `TapGesture` isn't supported on tvOS.
        self
        #else
        if simultaneous {
            simultaneousGesture(TapGesture(count: count).onEnded {
                action()
            })
        } else {
            onTapGesture(count: count, perform: action)
        }
        #endif
    }

    /// Adds a simultaneous tap gesture only if given condition is satisfied.
    ///
    /// - Parameters:
    ///   - condition: The condition that must be `true` in order to add tap gesture
    ///     and perform the given action.
    ///   - action: The action to perform.
    func onTapGestureIf(_ condition: Bool, perform action: @escaping () -> Void) -> some View {
        applyIf(condition) {
            $0.onTapGesture(simultaneous: true, perform: action)
        }
    }
}
