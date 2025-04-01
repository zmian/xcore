//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct DataStatusListPreview: View {
    private typealias Status = ReloadableDataStatus<[Ocean], AppError>
    @State private var data: Status = .idle
    @State private var showFailureAsAlert = true

    var body: some View {
        Group {
            if showFailureAsAlert {
                failureAlertBody
            } else {
                customFailureViewBody
            }
        }
        // ✅ Built-in list modifier supported
        .listStyle(.plain)
        // ✅ Built-in refreshable modifier supported
        .refreshable {
            await fetch()
        }
        .task {
            await fetch()
        }
        .onAppear {
            print("DataStatusList appeared")
        }
        .onDisappear {
            print("DataStatusList disappeared")
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Section("DataStatus Cases") {
                        button("Idle", action: .idle)
                        button("Loading", action: .loading)
                        button("Success", action: .success(Ocean.data))
                        button("Reloading", action: .reloading(Ocean.data))
                        button("Failure", action: .failure(Ocean.error))
                    }

                    Section("Empty State") {
                        button("Content Unavailable (.success)", action: .success([]))
                        button("Content Unavailable (.reloading)", action: .reloading([]))
                    }

                    Section {
                        Button("Failure As Alert") {
                            Task {
                                showFailureAsAlert = true
                                data = .loading // Allows alert to be re-displayed.
                                try? await Task.sleep(for: .seconds(0.5))
                                data = .failure(Ocean.error)
                            }
                        }
                    }
                } label: {
                    Label("Settings", systemImage: .gear)
                }
            }
        }
    }

    private var customFailureViewBody: some View {
        DataStatusList(data) { oceans in
            ForEach(oceans) { ocean in
                Text(ocean.name)
            }
        } contentUnavailable: {
            contentUnavailableView
        } failure: { error in
            ErrorRecoveryView(error) { error in
                Task {
                    await fetch()
                }
            }
        }
    }

    private var failureAlertBody: some View {
        DataStatusList(data) { oceans in
            ForEach(oceans) { ocean in
                Text(ocean.name)
            }
        } contentUnavailable: {
            contentUnavailableView
        }
    }

    private func button(_ label: String, action: Status) -> some View {
        Button(label) {
            withAnimation {
                if action.isFailure {
                    showFailureAsAlert = false
                }
                data = action
            }
        }
    }

    private func fetch() async {
        data = if let value = data.value, !value.isEmpty {
            .reloading(value)
        } else {
            .loading
        }

        try? await Task.sleep(for: .seconds(1))

        withAnimation {
            data = .success(Ocean.data)
        }
    }

    private var contentUnavailableView: some View {
        ContentUnavailableView {
            Label("Ocean Data Unavailable", systemImage: "water.waves")
        } description: {
            Text("There is currently no ocean data available. Please check back later or refresh the view to check for new data.")
        } actions: {
            Button("Refresh") {
                Task {
                    await fetch()
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    DataStatusListPreview()
        .embedInNavigation()
}
