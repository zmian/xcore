//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A container view that presents content based on the current state of a
/// `DataStatus` or `ReloadableDataStatus`.
///
/// `DataStatusView` displays different content depending on whether data is
/// loading, successfully loaded, or failed to load.
///
/// When data is loading, it displays a loading indicator. On success, it shows
/// the content using the provided success view builder. On failure, it presents
/// the view produced by the failure view builder.
///
/// The view uses the environment value `dataStatusLoadingStateEnabled` to
/// determine whether to display the loading state.
///
/// **Usage**
///
/// ```swift
/// struct ContentView: View {
///     @State var places = DataStatus<[String], AppError>.loading
///
///     var body: some View {
///         DataStatusView(places) { places in
///             ForEach(places, id: \.self) { place in
///                 Text(place)
///             }
///         } failure: { error in
///             // Optionally provide a view to display when an error occurs.
///             Button("Reload") {
///                 // handle reload
///             }
///         }
///         .onAppear {
///             print("Content view is shown")
///         }
///     }
/// }
/// ```
///
/// **Advanced Usage**
///
/// A custom extension to provide error recovery. It allows you to provide a
/// custom error recovery view that gives users the option to recover from a
/// data fetching failure by invoking a retry mechanism.
///
/// ```swift
/// // With Retry Option
///
/// struct ContentView: View {
///     @State var data = DataStatus<[String], AppError>.loading
///
///     var body: some View {
///         DataStatusView(data) { places in
///             ForEach(places, id: \.self) { place in
///                 Text(place)
///             }
///         } onRetry: { error in
///             // Optionally provide a "onRetry" closure to retry the data fetching operation.
///             fetchPlaces()
///         }
///     }
/// }
///
/// // Here is how to write a custom onRetry option
///
/// // 1. Your custom error recovery view
///
/// struct ErrorRecoveryView<Failure: Error>: View {
///     private let error: Failure
///     private let onRetry: (@MainActor (Failure) -> Void)?
///
///     init(_ error: Failure, onRetry: (@MainActor (Failure) -> Void)?) {
///         self.error = error
///         self.onRetry = onRetry
///     }
///
///     var body: some View {
///         if onRetry != nil {
///             ContentUnavailableView {
///                 Label(error.title, systemImage: "network")
///             } description: {
///                 Text(error.message)
///             } actions: {
///                 actions
///             }
///         } else {
///             // Return a placeholder view instead of using EmptyView, ensuring that
///             // lifecycle events such as `onAppear` or `onDisappear` are triggered
///             // appropriately.
///             Color.clear
///         }
///     }
///
///     private var actions: some View {
///         HStack(spacing: .defaultSpacing) {
///             if let error = error as? AppError, error.contactSupport {
///                 Button.help {
///                     // Handle help
///                 }
///                 .buttonStyle(.primary)
///             }
///
///             Button.retry {
///                 onRetry?(error)
///             }
///             .buttonStyle(.secondary)
///         }
///     }
/// }
///
/// // 2. Now expose it as a convenience extension
///
/// extension DataStatusView where FailureView == ErrorRecoveryView<Failure> {
///     /// Creates a new instance of `DataStatusView`.
///     ///
///     /// - Parameters:
///     ///   - data: A `DataStatus` value representing the current state of the data.
///     ///   - success: A view builder that produces a view for the successfully loaded
///     ///     data.
///     ///   - onRetry: An optional closure that is executed to retry the data fetching
///     ///     operation when an error occurs.
///     init(
///         _ data: DataStatus<Success, Failure>,
///         @ViewBuilder success: @escaping (Success) -> SuccessView,
///         onRetry: (@MainActor (Failure) -> Void)?
///     ) {
///         self.init(data, success: success) { error in
///             ErrorRecoveryView(error, onRetry: onRetry)
///         }
///     }
/// }
/// ```
public struct DataStatusView<Success, Failure: Error, SuccessView: View, FailureView: View>: View {
    @Environment(\.dataStatusLoadingStateEnabled) private var isLoadingStateEnabled
    private let data: ReloadableDataStatus<Success, Failure>
    private let success: (Success) -> SuccessView
    private let failure: (Failure) -> FailureView

    public var body: some View {
        switch data {
            case .idle:
                placeholder
            case .loading:
                if isLoadingStateEnabled {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    placeholder
                }
            case let .success(value), let .reloading(value):
                success(value)
            case let .failure(error):
                failureView(error)
        }
    }

    @ViewBuilder
    private func failureView(_ error: Failure) -> some View {
        if FailureView.self != Never.self {
            failure(error)
        } else {
            placeholder
        }
    }

    // Returns a placeholder view instead of using EmptyView, ensuring that
    // lifecycle events such as `onAppear` or `onDisappear` are triggered.
    private var placeholder: some View {
        Color.clear
    }
}

// MARK: - Inits

extension DataStatusView {
    /// Creates a new instance of `DataStatusView`.
    ///
    /// - Parameters:
    ///   - data: A `DataStatus` value representing the current state of the data.
    ///   - success: A view builder that produces a view for the successfully loaded
    ///     data.
    ///   - failure: A view builder that produces a view to display in case of an
    ///     error.
    public init(
        _ data: DataStatus<Success, Failure>,
        @ViewBuilder success: @escaping (Success) -> SuccessView,
        @ViewBuilder failure: @escaping (Failure) -> FailureView
    ) {
        self.init(.init(data), success: success, failure: failure)
    }

    /// Creates a new instance of `DataStatusView`.
    ///
    /// - Parameters:
    ///   - data: A `ReloadableDataStatus` value representing the current state of
    ///     the data.
    ///   - success: A view builder that produces a view for the successfully loaded
    ///     data.
    ///   - failure: A view builder that produces a view to display in case of an
    ///     error.
    public init(
        _ data: ReloadableDataStatus<Success, Failure>,
        @ViewBuilder success: @escaping (Success) -> SuccessView,
        @ViewBuilder failure: @escaping (Failure) -> FailureView
    ) {
        self.data = data
        self.success = success
        self.failure = failure
    }
}
