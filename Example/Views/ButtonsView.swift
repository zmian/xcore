//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct ButtonsView: View {
    var body: some View {
        List {
            callout
            pills
            builtin
        }
        .listStyle(InsetGroupedListStyle())
    }
}

extension ButtonsView {
    private var callout: some View {
        Section(header: Text("Callout")) {
            button {
                Text("FillButtonStyle")
            }
            .buttonStyle(FillButtonStyle())

            button {
                Label("FillButtonStyle", systemImage: "chevron.right")
                    .labelStyle(IconAfterLabelStyle())
            }
            .buttonStyle(FillButtonStyle())

            button {
                Label("FillButtonStyle", systemImage: "heart.fill")
                    .imageScale(.large)
                    .padding(.vertical)
                    .labelStyle(IconBeforeLabelStyle(axis: .vertical))
            }
            .buttonStyle(FillButtonStyle())

            button {
                Text("OutlineButtonStyle")
            }
            .buttonStyle(OutlineButtonStyle())
        }
    }

    private var pills: some View {
        Section(header: Text("Pill")) {
            button {
                Text("PillButtonStyle")
            }

            button {
                HStack {
                    Text("PillButtonStyle")
                    Image(systemName: "chevron.right")
                }
            }
        }
        .buttonStyle(PillButtonStyle())
    }

    private var builtin: some View {
        Section(header: Text("Built-in Styles")) {
            button {
                Text("No style")
            }

            button {
                Text("DefaultButtonStyle")
            }
            .buttonStyle(DefaultButtonStyle())

            button {
                Text("BorderlessButtonStyle")
            }
            .buttonStyle(BorderlessButtonStyle())

            button {
                Text("PlainButtonStyle")
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    private func button<Label: View>(@ViewBuilder label: () -> Label) -> some View {
        Button {
            print("Button tapped")
        } label: {
            label()
        }
    }
}
