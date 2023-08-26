//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - On Tap Gesture

extension View {
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
    ///         Image(systemName: .heartFill)
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
    ///    - simultaneous: A Boolean value indicating whether to process tap gesture
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

// MARK: - On Long Press Gesture

extension View {
    /// Adds an action to perform when this view recognizes a long press gesture
    /// that works in `ScrollView` and `TabView` when set to `.page` style.
    ///
    /// - Parameters:
    ///   - minimumDuration: The minimum duration of the long press that must
    ///     elapse before the gesture succeeds.
    ///   - maximumDistance: The maximum distance that the fingers or cursor
    ///     performing the long press can move before the gesture fails.
    ///   - action: The action to perform when a long press is recognized and the
    ///     pressing state of the gesture changes, passing the current state as a
    ///     parameter.
    public func onLongPressGestureSupportingScrollView(
        minimumDuration: Double = 10,
        maximumDistance: Double = .greatestFiniteMagnitude,
        perform action: @escaping (_ isPressing: Bool) -> Void
    ) -> some View {
        /// A ``Timer`` is used to avoid flickering (``true`` and ``false`` values sent)
        /// on scroll gesture.
        weak var clearTimer: Timer?

        func startClearTimer(isPressing: Bool) {
            clearTimer = Timer.after(isPressing ? 0.1 : 0) {
                action(isPressing)
            }
            clearTimer?.resume()
        }

        return self
            /// In order to properly work inside a scroll view a `onTapGesture` has to be
            /// also added. Adding tap gesture prevents "LongPressGesture" from disabling
            /// scroll view's swipe gesture.
            .onTapGesture {}
            .onLongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance) {
                clearTimer?.invalidate()
                startClearTimer(isPressing: false)
            } onPressingChanged: { isPressing in
                clearTimer?.invalidate()
                startClearTimer(isPressing: isPressing)
            }
    }
}
