//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct ButtonsView: View {
    @State private var isLoading = true

    var body: some View {
        List {
            Toggle("Loading", isOn: $isLoading)
                .toggleStyle(.checkbox(edge: .trailing))
            fillStates
            outlineStates
            callout
            capsules
            others
            builtin
        }
        .listStyle(.insetGrouped)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isLoading = false
            }
        }
    }
}

extension ButtonsView {
    private var fillStates: some View {
        Section(header: Text("Fill Prominence")) {
            button {
                Text("Fill")
            }
            .buttonStyle(.fill)

            button {
                Text("Fill Disabled")
            }
            .buttonStyle(.fill)
            .disabled(true)

            button {
                Text("Fill")
            }
            .buttonStyle(.fill)
            .isLoading(isLoading)

            button {
                Text("Fill Hard Edges")
            }
            .buttonStyle(.fill(cornerRadius: 0))

            button {
                Text("Capsule")
            }
            .buttonStyle(.capsule)

            button {
                Text("Capsule Disabled")
            }
            .buttonStyle(.capsule)
            .disabled(true)
        }
    }

    private var outlineStates: some View {
        Section(header: Text("Outline Prominence")) {
            button {
                Text("Outline")
            }
            .buttonStyle(.outline)

            button {
                Text("Outline Disabled")
            }
            .buttonStyle(.outline)
            .disabled(true)

            button {
                Text("Outline Hard Edges")
            }
            .buttonStyle(.outline(cornerRadius: 0))

            button {
                Text("Capsule Outline")
            }
            .buttonStyle(.capsuleOutline)

            button {
                Text("Capsule Outline Disabled")
            }
            .buttonStyle(.capsuleOutline)
            .disabled(true)
        }
    }

    private var callout: some View {
        Section(header: Text("Callout")) {
            button {
                Text("Fill")
            }
            .buttonStyle(.fill)

            button {
                Label("Fill", systemImage: .chevronRight)
                    .labelStyle(.iconAfter)
            }
            .buttonStyle(.fill)

            button {
                Label("Fill", systemImage: .heartFill)
                    .imageScale(.large)
                    .padding(.vertical)
                    .labelStyle(.iconBefore(axis: .vertical))
            }
            .buttonStyle(.fill)

            button {
                Text("Outline")
            }
            .buttonStyle(.outline)
        }
    }

    private var capsules: some View {
        Section(header: Text("Capsule")) {
            button {
                Text("Capsule")
            }

            button {
                Label("Capsule", systemImage: .chevronRight)
                    .labelStyle(.iconAfter)
            }
        }
        .buttonStyle(.capsule)
    }

    private var others: some View {
        Section(header: Text("Others")) {
            button {
                HStack {
                    Text("Borderless")
                    Image(system: .chevronRight)
                }
            }
            .buttonStyle(.borderless)

            button {
                HStack {
                    Text("Borderless")
                    Image(system: .chevronRight)
                }
            }
            .buttonStyle(.borderless)
            .disabled(true)
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
                Text("Borderless")
            }
            .buttonStyle(.borderless)

            button {
                Text("Plain")
            }
            .buttonStyle(.plain)
        }
    }

    private func button(@ViewBuilder label: () -> some View) -> some View {
        Button {
            print("Button tapped")
        } label: {
            label()
        }
    }
}

// MARK: - Preview

#Preview {
    ButtonsView()
        .embedInNavigation()
}
