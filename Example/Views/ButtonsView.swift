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
        .listStyle(InsetGroupedListStyle())
    }
}

extension ButtonsView {
    private var fillStates: some View {
        Section(header: Text("Fill Button")) {
            button {
                Text("FillButtonStyle")
            }
            .buttonStyle(FillButtonStyle())

            button {
                Text("FillButtonStyle")
            }
            .buttonStyle(FillButtonStyle())
            .environment(\.isEnabled, false)

            button {
                Text("FillButtonStyle")
            }
            .buttonStyle(FillButtonStyle())
            .defaultButtonCornerRadius(0)
        }
    }

    private var outlineStates: some View {
        Section(header: Text("Outline Button")) {
            button {
                Text("OutlineButtonStyle")
            }
            .buttonStyle(OutlineButtonStyle())

            button {
                Text("OutlineButtonStyle")
            }
            .buttonStyle(OutlineButtonStyle())
            .environment(\.isEnabled, false)

            button {
                Text("OutlineButtonStyle")
            }
            .buttonStyle(OutlineButtonStyle())
            .defaultButtonCornerRadius(0)
        }
    }

    private var pillStates: some View {
        Section(header: Text("Pill Button")) {
            button {
                Text("PillButtonStyle")
            }
            .buttonStyle(PillButtonStyle())

            button {
                Text("PillButtonStyle")
            }
            .buttonStyle(PillButtonStyle())
            .environment(\.isEnabled, false)

            button {
                Text("PillButtonStyle")
            }
            .buttonStyle(PillButtonStyle())
            .defaultButtonCornerRadius(0)
        }
    }

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
                    Image(system: .chevronRight)
                }
            }
        }
        .buttonStyle(PillButtonStyle())
    }

    private var others: some View {
        Section(header: Text("Others")) {
            button {
                HStack {
                    Text("BorderlessButtonStyle")
                    Image(system: .chevronRight)
                }
            }
            .buttonStyle(BorderlessButtonStyle())

            button {
                HStack {
                    Text("BorderlessButtonStyle")
                    Image(system: .chevronRight)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
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

struct ButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonsView()
            .embedInNavigation()
    }
}
