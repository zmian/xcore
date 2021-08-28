//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

#if DEBUG

// MARK: - Default Style

private struct DefaultFieldPreview: View {
    @State private var height: CGFloat = 0
    @State private var text: String = ""

    var body: some View {
        VStack(spacing: .s6) {
            DynamicTextField(value: $text, configuration: .emailAddress) {
                Label("Email Address", systemImage: .mail)
            }
            .readSize {
                height = $0.height
            }
            .accentColor(.secondary)

            Text("Text Field Height \(height)")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

// MARK: - Line Style

private struct LineFieldPreview: View {
    @State private var height: CGFloat = 0
    @State private var text: String = "hello@example.com"

    var body: some View {
        VStack(spacing: .s6) {
            DynamicTextField(value: $text, configuration: .emailAddress) {
                Label("Email Address", systemImage: .mail)
            }
            .dynamicTextFieldStyle(.line)
            .readSize {
                height = $0.height
            }
            .accentColor(.secondary)

            Text("Text Field Height \(height)")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

// MARK: - Prominent Style

private struct ProminentFieldPreview: View {
    @State private var height: CGFloat = 0
    @State private var text: String = ""

    var body: some View {
        VStack {
            VStack(spacing: .s6) {
                DynamicTextField("SSN", value: $text, configuration: .ssn)
                    .dynamicTextFieldStyle(.prominent(.fill))
                    .readSize {
                        height = $0.height
                    }

                Text("Text Field Height \(height)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            VStack(spacing: .s6) {
                DynamicTextField("SSN", value: $text, configuration: .ssn)
                    .dynamicTextFieldStyle(.prominent(.outline, shape: Capsule()))
                    .readSize {
                        height = $0.height
                    }

                Text("Text Field Height \(height)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

// MARK: - Preview Provider

@available(iOS 15.0, *)
struct DynamicTextField_Previews: PreviewProvider {
    static var previews: some View {
        Samples.dynamicTextFieldPreviews
    }
}

extension Samples {
    @available(iOS 15.0, *)
    public static var dynamicTextFieldPreviews: some View {
        LazyView {
            VStack {
                Section("Default Style") {
                    DefaultFieldPreview()
                }

                Section("Line Style") {
                    LineFieldPreview()
                }

                Section("Prominent Style") {
                    ProminentFieldPreview()
                        .textFieldAttributes {
                            $0.disableFloatingPlaceholder = true
                        }
                }
            }
        }
    }
}
#endif
