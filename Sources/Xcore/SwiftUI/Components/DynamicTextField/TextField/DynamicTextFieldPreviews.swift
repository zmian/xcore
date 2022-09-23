//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

#if DEBUG

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
            content
                .accentColor(.secondary)
                .readSize {
                    height = $0.height
                }
        } header: {
            Text(title)
        } footer: {
            Text("Text Field Height \(height)")
        }
    }
}

// MARK: - Showcase

private struct ShowcaseFieldPreview: View {
    @State private var style = Style.default
    @State private var disableFloatingPlaceholder = false
    @State private var text = ""

    var body: some View {
        TextFieldPreviewBox("Showcase") {
            DynamicTextField(value: $text, configuration: .emailAddress) {
                Label("Email Address", systemImage: .mail)
            }
            .dynamicTextFieldStyle(style.textFieldStyle)
            .textFieldAttributes {
                $0.disableFloatingPlaceholder = disableFloatingPlaceholder
            }

            // Placeholder Style Picker
            Button("\(disableFloatingPlaceholder ? "Enable" : "Disable") Floating Placeholder") {
                disableFloatingPlaceholder.toggle()
            }
            .accentColor(Color(UIColor.link))

            // Style Picker
            Picker("", selection: $style) {
                ForEach(Style.allCases) {
                    Text($0.rawValue)
                        .tag($0)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private enum Style: String, Hashable, CaseIterable, Identifiable {
        case `default` = "Default"
        case line = "Line"
        case prominent1 = "P1"
        case prominent2 = "P2"

        var textFieldStyle: AnyDynamicTextFieldStyle {
            switch self {
                case .default:
                    return AnyDynamicTextFieldStyle(.default)
                case .line:
                    return AnyDynamicTextFieldStyle(.line)
                case .prominent1:
                    return AnyDynamicTextFieldStyle(.prominent(.fill))
                case .prominent2:
                    return AnyDynamicTextFieldStyle(.prominent(.outline, shape: Capsule()))
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
                .onChange(of: money) {
                    print("Money: \(String(describing: $0))")
                }

            DynamicTextField("Decimal", value: $decimal, configuration: .number)
                .onChange(of: decimal) {
                    print("Decimal: \(String(describing: $0))")
                }

            DynamicTextField("Integer", value: $integer, configuration: .number)
                .onChange(of: integer) {
                    print("Integer: \(String(describing: $0))")
                }

            Button("Change to 500") {
                money = 500.0
                decimal = 500
                integer = 500
            }
            .accentColor(Color(UIColor.link))

            Button("Change to 1,000,000") {
                money = 1_000_000.00
                decimal = 1_000_000.00
                integer = 1_000_000
            }
            .accentColor(Color(UIColor.link))
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
                .onChange(of: ssn) {
                    print("SSN: \($0)")
                }

            DynamicTextField("Social Security Number Last 4", value: $ssnLastFour, configuration: .ssnLastFour)
                .onChange(of: ssnLastFour) {
                    print("SSN (Last Four): \($0)")
                }

            DynamicTextField("Phone Number", value: $phoneNumber, configuration: .phoneNumber(for: .us))
                .onChange(of: phoneNumber) {
                    print("Phone Number: \($0)")
                }
        }
        .textFieldAttributes {
            $0.disableFloatingPlaceholder = false
        }
    }
}

// MARK: - Preview Provider

struct DynamicTextField_Previews: PreviewProvider {
    static var previews: some View {
        Samples.dynamicTextFieldPreviews
    }
}

extension Samples {
    public static var dynamicTextFieldPreviews: some View {
        List {
            NumberFieldPreview()
            ShowcaseFieldPreview()
            DataFormatTypesFieldPreview()
        }
    }
}
#endif
