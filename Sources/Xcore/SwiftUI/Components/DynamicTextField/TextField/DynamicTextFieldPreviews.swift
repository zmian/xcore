//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

#if DEBUG
import SwiftUI

// MARK: - Showcase

private struct ShowcaseFieldPreview: View {
    private typealias PlaceholderPlacement = TextFieldAttributes.PlaceholderPlacement
    @State private var placeholderPlacement = PlaceholderPlacement.floating
    @State private var style = Style.default
    @State private var showLoading = false
    @State private var text = ""

    var body: some View {
        TextFieldPreviewBox("Showcase") {
            DynamicTextField(value: $text, configuration: .emailAddress) {
                Label("Email Address", systemImage: .mail)
            }
            .dynamicTextFieldStyle(style.textFieldStyle)
            .textFieldAttributes {
                $0.placeholderPlacement = placeholderPlacement
            }
            .isLoading(showLoading)
            .listRowSeparator(.hidden)
            .listRowBackground(Rectangle().fill(.bar))

            Toggle("Show Loading State", isOn: $showLoading)

            // Placeholder Style Picker
            Picker("Placeholder Placement", selection: $placeholderPlacement) {
                ForEach(PlaceholderPlacement.allCases, id: \.self) {
                    Text(String(describing: $0).titlecased())
                        .tag($0)
                }
            }

            // Style Picker
            Picker("Text Field Style", selection: $style) {
                ForEach(Style.allCases) {
                    Text($0.rawValue)
                        .tag($0)
                }
            }
        }
    }

    private enum Style: String, Hashable, CaseIterable, Identifiable {
        case `default` = "Default"
        case line = "Line"
        case prominent1 = "Prominent: Fill"
        case prominent2 = "Prominent: Outline"

        @MainActor
        var textFieldStyle: AnyDynamicTextFieldStyle {
            switch self {
                case .default:
                    AnyDynamicTextFieldStyle(.default)
                case .line:
                    AnyDynamicTextFieldStyle(.line)
                case .prominent1:
                    AnyDynamicTextFieldStyle(.prominent(.fill))
                case .prominent2:
                    AnyDynamicTextFieldStyle(.prominent(.outline, shape: .capsule))
            }
        }
    }
}

// MARK: - Number Style

private struct NumberFieldPreview: View {
    @State private var money: Double? = 0.0
    @State private var decimal: Double?
    @State private var integer: Int? = 10

    var body: some View {
        TextFieldPreviewBox("Numbers") {
            DynamicTextField("Money", value: $money, configuration: .currency)
                .onChange(of: money) { _, newValue in
                    print("Money: \(String(describing: newValue))")
                }

            DynamicTextField("Decimal", value: $decimal, configuration: .number)
                .onChange(of: decimal) { _, newValue in
                    print("Decimal: \(String(describing: newValue))")
                }

            DynamicTextField("Integer", value: $integer, configuration: .number)
                .onChange(of: integer) { _, newValue in
                    print("Integer: \(String(describing: newValue))")
                }

            Button("Change to 500") {
                money = 500.0
                decimal = 500
                integer = 500
            }

            Button("Change to 1,000,000") {
                money = 1_000_000.00
                decimal = 1_000_000.00
                integer = 1_000_000
            }
        }
    }
}

// MARK: - Data Format Types

private struct DataFormatTypesFieldPreview: View {
    @State private var ssn = ""
    @State private var ssnLastFour = ""
    @State private var phoneNumber = ""

    var body: some View {
        TextFieldPreviewBox("Data Types") {
            DynamicTextField("Social Security Number", value: $ssn, configuration: .ssn)
                .onChange(of: ssn) { _, newValue in
                    print("SSN: \(newValue)")
                }

            DynamicTextField("Social Security Number Last 4", value: $ssnLastFour, configuration: .ssnLastFour)
                .onChange(of: ssnLastFour) { _, newValue in
                    print("SSN (Last Four): \(newValue)")
                }

            DynamicTextField("Phone Number", value: $phoneNumber, configuration: .phoneNumber(for: .us))
                .onChange(of: phoneNumber) { _, newValue in
                    print("Phone Number: \(newValue)")
                }
        }
        .tint(.secondary)
    }
}

// MARK: - Preview Box

private struct TextFieldPreviewBox<Content: View>: View {
    @State private var height: CGFloat = 0
    private let title: String
    private let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        Section {
            if #available(iOS 18.0, *) {
                Group(subviews: content) { subviews in
                    if let first = subviews.first {
                        first
                            .background(Color.clear.onSizeChange {
                                height = $0.height.rounded()
                            })
                    }
                    subviews.dropFirst()
                }
            }
        } header: {
            Text(title)
        } footer: {
            Text("Text Field Height \(height.formatted())")
        }
    }
}

// MARK: - Preview

#Preview {
    Samples.dynamicTextFieldPreviews
}

extension Samples {
    @MainActor
    public static var dynamicTextFieldPreviews: some View {
        List {
            ShowcaseFieldPreview()
            NumberFieldPreview()
            DataFormatTypesFieldPreview()
        }
    }
}
#endif
