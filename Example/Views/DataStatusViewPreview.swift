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
        .onAppear {
            print("DataStatusView appeared")
        }
        .onDisappear {
            print("DataStatusView disappeared")
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

// MARK: - Preview

#Preview {
    DataStatusViewPreview()
        .embedInNavigation()
}
