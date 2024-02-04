//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct RootView: View {
    private let items = Menu.allCases

    var body: some View {
        Form {
            Section {
                ForEach(items) { item in
                    NavigationLink(destination: item.content()) {
                        VStack(alignment: .leading) {
                            Text(item.title)
                            if let subtitle = item.subtitle {
                                Spacer()
                                    .frame(height: 2)
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
        }
        .listStyle(.insetGrouped)
        .environment(\.defaultMinListRowHeight, 55)
        .navigationTitle("Showcase")
        .embedInNavigation()
    }
}

// MARK: - Preview

#Preview {
    RootView()
}
