//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    private let items = Destination.allCases

    var body: some View {
        List {
            Section {
                ForEach(items) { item in
                    NavigationLink(destination: item.content) {
                        Label {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.title)
                                if let subtitle = item.subtitle {
                                    Text(subtitle)
                                        .foregroundStyle(.secondary)
                                        .font(.footnote)
                                }
                            }
                        } icon: {
                            Image(system: item.icon)
                                .foregroundStyle(.foreground)
                        }
                    }
                }
            } header: {
                Text("Components")
            } footer: {
                Text("A demonstration of components included in Xcore.")
            }

            Section {
                NavigationLink {
                    QRCodeView()
                } label: {
                    Label("QR Codes", systemImage: "qrcode")
                        .foregroundStyle(.foreground)
                }

                NavigationLink {
                    AddressFormView(store: .init(
                        initialState: .init(navigationTitle: "Address"),
                        reducer: {
                            AddressForm()
                        }
                    ))
                } label: {
                    Label("Address Form", systemImage: "text.page.badge.magnifyingglass")
                        .foregroundStyle(.foreground)
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
