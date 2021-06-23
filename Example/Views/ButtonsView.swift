//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct ButtonsView: View {
    var body: some View {
        List {
            fillStates
            outlineStates
            pillStates
            callout
            pills
            others
            builtin
        }
        .listStyle(.insetGrouped)
    }
}

extension ButtonsView {
    private var fillStates: some View {
        Section(header: Text("Fill Button")) {
            button {
                Text("FillButtonStyle")
            }
            .buttonStyle(.fill)

            button {
                Text("FillButtonStyle")
            }
            .buttonStyle(.fill)
            .environment(\.isEnabled, false)

            button {
                Text("FillButtonStyle")
            }
            .buttonStyle(.fill)
            .defaultButtonCornerRadius(0)
        }
    }

    private var outlineStates: some View {
        Section(header: Text("Outline Button")) {
            button {
                Text("OutlineButtonStyle")
            }
            .buttonStyle(.outline)

            button {
                Text("OutlineButtonStyle")
            }
            .buttonStyle(.outline)
            .environment(\.isEnabled, false)

            button {
                Text("OutlineButtonStyle")
            }
            .buttonStyle(.outline)
            .defaultButtonCornerRadius(0)
        }
    }

    private var pillStates: some View {
        Section(header: Text("Pill Button")) {
            button {
                Text("PillButtonStyle")
            }
            .buttonStyle(.pill)

            button {
                Text("PillButtonStyle")
            }
            .buttonStyle(.pill)
            .environment(\.isEnabled, false)

            button {
                Text("PillButtonStyle")
            }
            .buttonStyle(.pill)
            .defaultButtonCornerRadius(0)
        }
    }

    private var callout: some View {
        Section(header: Text("Callout")) {
            button {
                Text("FillButtonStyle")
            }
            .buttonStyle(.fill)

            button {
                Label("FillButtonStyle", systemImage: .chevronRight)
                    .labelStyle(.iconAfter)
            }
            .buttonStyle(.fill)

            button {
                Label("FillButtonStyle", systemImage: .heartFill)
                    .imageScale(.large)
                    .padding(.vertical)
                    .labelStyle(.iconBefore(axis: .vertical))
            }
            .buttonStyle(.fill)

            button {
                Text("OutlineButtonStyle")
            }
            .buttonStyle(.outline)
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
                    Image(system: .chevronRight)
                }
            }
        }
        .buttonStyle(.pill)
    }

    private var others: some View {
        Section(header: Text("Others")) {
            button {
                HStack {
                    Text("BorderlessButtonStyle")
                    Image(system: .chevronRight)
                }
            }
            .buttonStyle(.borderless)

            button {
                HStack {
                    Text("BorderlessButtonStyle")
                    Image(system: .chevronRight)
                }
            }
            .buttonStyle(.borderless)
            .environment(\.isEnabled, false)
        }
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
            .buttonStyle(.borderless)

            button {
                Text("PlainButtonStyle")
            }
            .buttonStyle(.plain)
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

struct ButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonsView()
            .embedInNavigation()
    }
}
