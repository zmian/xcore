//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct DataStatusViewPreview: View {
    private typealias Status = DataStatus<[Ocean], AppError>
    @State private var data: Status = .idle

    var body: some View {
        DataStatusView(data) { oceans in
            List(oceans) { ocean in
                Text(ocean.name)
            }
        } failure: { error in
            ErrorRecoveryView(error) { error in
                Task {
                    await fetch()
                }
            }
        }
        .task {
            await fetch()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Section("DataStatus Cases") {
                        button("Idle", action: .idle)
                        button("Loading", action: .loading)
                        button("Success", action: .success(Ocean.data))
                        button("Failure", action: .failure(Ocean.error))
                    }
                } label: {
                    Label("Settings", systemImage: .gear)
                }
            }
        }
    }

    private func button(_ label: String, action: Status) -> some View {
        Button(label) {
            withAnimation {
                data = action
            }
        }
    }

    private func fetch() async {
        data = .loading
        try? await Task.sleep(for: .seconds(1))

        withAnimation {
            data = .success(Ocean.data)
        }
    }
}

// MARK: - Ocean

private struct Ocean: Identifiable, Hashable {
    let id = UUID()
    let name: String

    static let data = [
        Ocean(name: "Pacific"),
        Ocean(name: "Atlantic"),
        Ocean(name: "Indian"),
        Ocean(name: "Southern"),
        Ocean(name: "Arctic")
    ]

    static let error = AppError(
        id: "ocean_fetch_failure",
        title: "Unable to Retrieve Oceans",
        message: "We could not retrieve the ocean data at this time. Please try again later."
    )
}

// MARK: - ErrorRecoveryView

private struct ErrorRecoveryView<Failure: Error>: View {
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

// MARK: - Preview

#Preview {
    DataStatusViewPreview()
        .embedInNavigation()
}
