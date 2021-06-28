//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Default Style

private struct DefaultFieldPreview: View {
    @State private var height: CGFloat = 0
    @State private var text: String = ""

    var body: some View {
        VStack(spacing: .maximumPadding) {
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
        VStack(spacing: .maximumPadding) {
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
        VStack(spacing: .maximumPadding) {
            DynamicTextField("SSN", value: $text, configuration: .ssn)
                .dynamicTextFieldStyle(.prominent(options: .elevated))
                .readSize {
                    height = $0.height
                }

            Text("Text Field Height \(height)")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

// MARK: - Preview Provider

struct DynamicTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DefaultFieldPreview()
            LineFieldPreview()

            ZStack {
                Color(UIColor.systemBackground)
                ProminentFieldPreview()
                    .textFieldAttributes {
                        $0.disableFloatingPlaceholder = true
                    }
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
