//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A list view that presents content based on the current state of a
/// `DataStatus` or `ReloadableDataStatus`.
///
/// When data is loading, it displays a loading indicator. On success, it shows
/// the content using the provided content view builder. On failure, it presents
/// the view produced by the failure view builder.
///
/// If the given `Success` value is of a collection type, you can optionally
/// provide content unavailable view.
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
///         }
///     }
/// }
///
/// // With Content Unavailable View
///
/// struct ContentView: View {
///     @State var data = DataStatus<[String], AppError>.loading
///
///     var body: some View {
///         DataStatusList(data) { places in
///             ForEach(places, id: \.self) { place in
///                 Text(place)
///             }
///         } contentUnavailable: {
///             Text("No places available")
///         }
///     }
/// }
///
/// // With Failure View
///
/// struct ContentView: View {
///     @State var data = DataStatus<[String], AppError>.loading
///
///     var body: some View {
///         DataStatusList(data) { places in
///             ForEach(places, id: \.self) { place in
///                 Text(place)
///             }
///         } contentUnavailable: {
///             Text("No places available")
///         } failure: { error in
///             // Optionally provide a view to display when an error occurs.
///             Button("Reload") {
///                 // handle reload
///             }
///         }
///     }
/// }
///
/// // With Retry Option
///
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
public struct DataStatusList<Success: Equatable, Failure: Error & Equatable, SuccessView: View, FailureView: View, ContentUnavailable: View>: View {
    @Environment(\.dataStatusLoadingStateEnabled) private var isLoadingStateEnabled
    @State private var error: Failure?
    private let data: ReloadableDataStatus<Success, Failure>
    private let success: (Success) -> SuccessView
    private let failure: (Failure) -> FailureView
    private let contentUnavailable: () -> ContentUnavailable

    public var body: some View {
        List {
            if let value = data.value, !data.isEmpty {
                success(value)
            }
        }
        .overlay {
            switch data {
                case .loading where isLoadingStateEnabled:
                    ProgressView()
                case .success, .reloading:
                    contentUnavailableViewIfEmpty
                case let .failure(error) where hasFailureView:
                    failure(error)
                case .idle, .loading, .failure:
                    EmptyView()
            }
        }
        .applyIf(!hasFailureView) { content in
            content
                .popup($error)
                .onChange(of: data) { _, data in
                    error = data.error
                }
        }
    }

    @ViewBuilder
    private var contentUnavailableViewIfEmpty: some View {
        if ContentUnavailable.self != Never.self && data.isEmpty {
            contentUnavailable()
        }
    }

    private var hasFailureView: Bool {
        FailureView.self != Never.self
    }
}

// MARK: - Inits: DataStatus

extension DataStatusList {
    /// Creates a list view that displays content based on the provided data status.
    ///
    /// Configures the list view that automatically presents the appropriate UI
    /// based on the current data status. When the data status indicates a failure
    /// it presents the view produced by the failure view builder.
    ///
    /// If the data is empty and a content-unavailable view is supplied, that view
    /// is displayed.
    ///
    /// - Parameters:
    ///   - data: A `DataStatus` instance representing the state of the data.
    ///   - success: A view builder that produces a view for the successfully loaded
    ///     data.
    ///   - contentUnavailable: A view builder that produces a view to display when
    ///     no content is available.
    ///   - failure: A view builder that produces a view to display in case of an
    ///     error.
    public init(
        _ data: DataStatus<Success, Failure>,
        @ViewBuilder success: @escaping (Success) -> SuccessView,
        @ViewBuilder contentUnavailable: @escaping () -> ContentUnavailable,
        @ViewBuilder failure: @escaping (Failure) -> FailureView
    ) {
        self.data = .init(data)
        self.success = success
        self.contentUnavailable = contentUnavailable
        self.failure = failure
    }

    /// Creates a list view that displays content based on the provided data status.
    ///
    /// Configures the list view that automatically presents the appropriate UI
    /// based on the current data status. When the data status indicates a failure
    /// it presents the view produced by the failure view builder.
    ///
    /// - Parameters:
    ///   - data: A `DataStatus` instance representing the state of the data.
    ///   - success: A view builder that produces a view for the successfully loaded
    ///     data.
    ///   - failure: A view builder that produces a view to display in case of an
    ///     error.
    public init(
        _ data: DataStatus<Success, Failure>,
        @ViewBuilder success: @escaping (Success) -> SuccessView,
        @ViewBuilder failure: @escaping (Failure) -> FailureView
    ) where ContentUnavailable == Never {
        self.init(
            data,
            success: success,
            contentUnavailable: { fatalError() },
            failure: failure
        )
    }

    /// Creates a list view that displays content based on the provided data status.
    ///
    /// Configures the list view that automatically presents the appropriate UI
    /// based on the current data status. When the data status indicates a failure
    /// an error alert is shown.
    ///
    /// If the data is empty and a content-unavailable view is supplied, that view
    /// is displayed.
    ///
    /// - Parameters:
    ///   - data: A `DataStatus` instance representing the state of the data.
    ///   - success: A view builder that produces a view for the successfully loaded
    ///     data.
    ///   - contentUnavailable: A view builder that produces a view to display when
    ///     no content is available.
    public init(
        _ data: DataStatus<Success, Failure>,
        @ViewBuilder success: @escaping (Success) -> SuccessView,
        @ViewBuilder contentUnavailable: @escaping () -> ContentUnavailable
    ) where FailureView == Never {
        self.init(
            data,
            success: success,
            contentUnavailable: contentUnavailable,
            failure: { _ in fatalError() }
        )
    }

    /// Creates a list view that displays content based on the provided data status.
    ///
    /// Configures the list view that automatically presents the appropriate UI
    /// based on the current data status. When the data status indicates a failure
    /// an error alert is shown.
    ///
    /// - Parameters:
    ///   - data: A `DataStatus` instance representing the state of the data.
    ///   - success: A view builder that produces a view for the successfully loaded
    ///     data.
    public init(
        _ data: DataStatus<Success, Failure>,
        @ViewBuilder success: @escaping (Success) -> SuccessView
    ) where FailureView == Never, ContentUnavailable == Never {
        self.init(
            data,
            success: success,
            contentUnavailable: { fatalError() },
            failure: { _ in fatalError() }
        )
    }
}

// MARK: - Inits: ReloadableDataStatus

extension DataStatusList {
    /// Creates a list view that displays content based on the provided reloadable
    /// data status.
    ///
    /// Configures the list view that automatically presents the appropriate UI
    /// based on the current data status and supports reloading. When the data
    /// status indicates a failure it presents the view produced by the failure view
    /// builder.
    ///
    /// If the data is empty and a content-unavailable view is supplied, that view
    /// is displayed.
    ///
    /// - Parameters:
    ///   - data: A `ReloadableDataStatus` instance representing the state of the
    ///     data.
    ///   - success: A view builder that produces a view for the successfully loaded
    ///     data.
    ///   - contentUnavailable: A view builder that produces a view to display when
    ///     no content is available.
    ///   - failure: A view builder that produces a view to display in case of an
    ///     error.
    public init(
        _ data: ReloadableDataStatus<Success, Failure>,
        @ViewBuilder success: @escaping (Success) -> SuccessView,
        @ViewBuilder contentUnavailable: @escaping () -> ContentUnavailable,
        @ViewBuilder failure: @escaping (Failure) -> FailureView
    ) {
        self.data = data
        self.success = success
        self.contentUnavailable = contentUnavailable
        self.failure = failure
    }

    /// Creates a list view that displays content based on the provided reloadable
    /// data status.
    ///
    /// Configures the list view that automatically presents the appropriate UI
    /// based on the current data status and supports reloading. When the data
    /// status indicates a failure it presents the view produced by the failure view
    /// builder.
    ///
    /// - Parameters:
    ///   - data: A `ReloadableDataStatus` instance representing the state of the
    ///     data.
    ///   - success: A view builder that produces a view for the successfully loaded
    ///     data.
    ///   - failure: A view builder that produces a view to display in case of an
    ///     error.
    public init(
        _ data: ReloadableDataStatus<Success, Failure>,
        @ViewBuilder success: @escaping (Success) -> SuccessView,
        @ViewBuilder failure: @escaping (Failure) -> FailureView
    ) where ContentUnavailable == Never {
        self.init(
            data,
            success: success,
            contentUnavailable: { fatalError() },
            failure: failure
        )
    }

    /// Creates a list view that displays content based on the provided reloadable
    /// data status.
    ///
    /// Configures the list view that automatically presents the appropriate UI
    /// based on the current data status and supports reloading. When the data
    /// status indicates a failure an error alert is shown.
    ///
    /// If the data is empty and a content-unavailable view is supplied, that view
    /// is displayed.
    ///
    /// - Parameters:
    ///   - data: A `ReloadableDataStatus` instance representing the state of the
    ///     data.
    ///   - success: A view builder that produces a view for the successfully loaded
    ///     data.
    ///   - contentUnavailable: A view builder that produces a view to display when
    ///     no content is available.
    public init(
        _ data: ReloadableDataStatus<Success, Failure>,
        @ViewBuilder success: @escaping (Success) -> SuccessView,
        @ViewBuilder contentUnavailable: @escaping () -> ContentUnavailable
    ) where FailureView == Never {
        self.init(
            data,
            success: success,
            contentUnavailable: contentUnavailable,
            failure: { _ in fatalError() }
        )
    }

    /// Creates a list view that displays content based on the provided reloadable
    /// data status.
    ///
    /// Configures the list view that automatically presents the appropriate UI
    /// based on the current data status and supports reloading. When the data
    /// status indicates a failure an error alert is shown.
    ///
    /// - Parameters:
    ///   - data: A `ReloadableDataStatus` instance representing the state of the
    ///     data.
    ///   - success: A view builder that produces a view for the successfully loaded
    ///     data.
    public init(
        _ data: ReloadableDataStatus<Success, Failure>,
        @ViewBuilder success: @escaping (Success) -> SuccessView
    ) where FailureView == Never, ContentUnavailable == Never {
        self.init(
            data,
            success: success,
            contentUnavailable: { fatalError() },
            failure: { _ in fatalError() }
        )
    }
}

// MARK: - Helpers

extension ReloadableDataStatus {
    fileprivate var isEmpty: Bool {
        guard let value else {
            return false
        }

        return Mirror.isEmpty(value) == true
    }
}
