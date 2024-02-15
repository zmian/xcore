//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct ButtonsView: View {
    @State private var isLoading = true
    @State private var isContentUnavailable = false

    var body: some View {
        List {
            Toggle("Show Loading", isOn: $isLoading)

            Button("Show Content Unavailable") {
                isContentUnavailable = true
            }

            fillStates
            outlineStates
            symbolLabels
            others
            builtin
        }
        .contentUnavailable(isContentUnavailable) {
            Text("No content to display")
        }
        .task {
            try? await Task.sleep(for: .seconds(3))
            isLoading = false
        }
    }
}

extension ButtonsView {
    private var fillStates: some View {
        Section("Fill Prominence") {
            button {
                Text("Fill")
            }
            .buttonStyle(.rectFill)

            button {
                Text("Fill Disabled")
            }
            .buttonStyle(.rectFill)
            .disabled(true)

            button {
                Text("Fill")
            }
            .buttonStyle(.rectFill)
            .isLoading(isLoading)

            button {
                Text("Fill Hard Edges")
            }
            .buttonStyle(.fill(shape: .rect))

            button {
                Text("Capsule")
            }
            .buttonStyle(.capsuleFill)

            button {
                Text("Capsule Disabled")
            }
            .buttonStyle(.capsuleFill)
            .disabled(true)
        }
    }

    private var outlineStates: some View {
        Section("Outline Prominence") {
            button {
                Text("Outline")
            }
            .buttonStyle(.rectOutline)

            button {
                Text("Outline Disabled")
            }
            .buttonStyle(.rectOutline)
            .disabled(true)

            button {
                Text("Outline Hard Edges")
            }
            .buttonStyle(.outline(shape: .rect))

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

    private var symbolLabels: some View {
        Section("Labels with Symbols") {
            button {
                Label("Fill", systemImage: .chevronRight)
                    .labelStyle(.iconAfter)
            }
            .buttonStyle(.rectFill)

            button {
                Label("Fill", systemImage: .heartFill)
                    .imageScale(.large)
                    .padding(.vertical)
                    .labelStyle(.iconBefore(axis: .vertical))
            }
            .buttonStyle(.rectFill)

            button {
                Label("Capsule", systemImage: .chevronRight)
                    .labelStyle(.iconAfter)
            }
            .buttonStyle(.capsuleFill)
        }
    }

    private var others: some View {
        Section("Others") {
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
                    Spacer()
                    Image(system: .chevronRight)
                }
            }
            .buttonStyle(.borderless)
            .disabled(true)
        }
    }

    private var builtin: some View {
        Section("Built-in Styles") {
            button {
                Text("No style")
            }

            button {
                Text("DefaultButtonStyle (.automatic)")
            }
            .buttonStyle(.automatic)

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
