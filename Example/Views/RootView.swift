//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct RootView: View {
    private let items = Menu.allCases

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Components"), footer: Text("A demonstration of components included in Xcore.")) {
                    ForEach(items) { item in
                        NavigationLink(destination: item.content()) {
                            VStack(alignment: .leading) {
                                Text(item.title)
                                if let subtitle = item.subtitle {
                                    Text(subtitle)
                                        .foregroundColor(.secondary)
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .environment(\.defaultMinListRowHeight, 55)
            .environment(\.horizontalSizeClass, .regular)
            .navigationTitle("Showcase")
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
