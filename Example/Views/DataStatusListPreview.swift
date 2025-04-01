//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct DataStatusListPreview: View {
    private typealias Status = DataStatus<[Ocean], AppError>
    @State private var data: Status = .idle

    var body: some View {
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

                    Section("Empty State") {
                        button("Content Unavailable", action: .success([]))
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
