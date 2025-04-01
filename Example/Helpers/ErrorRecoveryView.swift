//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A view that displays an error message along with a retry button, allowing
/// the user to attempt to recover from a failure.
///
/// When an error occurs, this view presents a cover view that shows the error
/// and, if an `onRetry` closure is provided, includes a retry button. Tapping
/// the retry button invokes the provided closure.
///
/// **Usage**
///
/// ```swift
/// struct ContentView: View {
///     @State var data = DataStatus<[String], AppError>.loading
///
///     var body: some View {
///         DataStatusList(data) { places in
///             ForEach(places, id: \.self) { place in
///                 Text(place)
///             }
///         } failure: { error in
///             ErrorRecoveryView(error) {
///                 fetchPlaces()
///             }
///         }
///     }
/// }
/// ```
struct ErrorRecoveryView<Failure: Error>: View {
    private let error: Failure
    private let onRetry: (@MainActor (Failure) -> Void)?

    init(_ error: Failure, onRetry: (@MainActor (Failure) -> Void)?) {
        self.error = error
        self.onRetry = onRetry
    }

    var body: some View {
        if let onRetry {
            ContentUnavailableView {
                Label(error.title, systemImage: "water.waves")
            } description: {
                Text(error.message)
            } actions: {
                Button.retry {
                    onRetry(error)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
            }
        } else {
            // Return a placeholder view instead of using EmptyView, ensuring that
            // lifecycle events such as `onAppear` or `onDisappear` are triggered
            // appropriately.
            Color.clear
        }
    }
}
