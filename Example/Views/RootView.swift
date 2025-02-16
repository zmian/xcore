//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    private let items = Menu.allCases

    var body: some View {
        List {
            Section {
                ForEach(items) { item in
                    NavigationLink(destination: item.content) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.title)
                            if let subtitle = item.subtitle {
                                Text(subtitle)
                                    .foregroundStyle(.secondary)
                                    .font(.footnote)
                            }
                        }
                    }
                }
            } header: {
                Text("Components")
            } footer: {
                Text("A demonstration of components included in Xcore.")
            }

            Section {
                NavigationLink("Address Form") {
                    AddressFormView(store: .init(
                        initialState: .init(navigationTitle: "Address"),
                        reducer: {
                            AddressForm()
                        }
                    ))
                }
            } header: {
                Text("Dependencies")
            } footer: {
                Text("A demonstration of components using dependencies included in Xcore.")
            }
        }
        .environment(\.defaultMinListRowHeight, 55)
        .navigationTitle("Showcase")
        .embedInNavigation()
    }
}

// MARK: - Preview

#Preview {
    RootView()
}
