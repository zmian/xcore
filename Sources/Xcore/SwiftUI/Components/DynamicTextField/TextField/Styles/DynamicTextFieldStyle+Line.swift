//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct LineDynamicTextFieldStyle: DynamicTextFieldStyle {
    private let withValidationColors: Bool
    private let height: CGFloat?

    init(withValidationColors: Bool = true, height: CGFloat? = nil) {
        self.withValidationColors = withValidationColors
        self.height = height
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        EnvironmentReader(\.textFieldAttributes) { attributes in
            EnvironmentReader(\.theme) { theme in
                let color: Color = {
                    if withValidationColors, configuration.isFocused {
                        return configuration.isValid ? attributes.successColor : attributes.errorColor
                    }

                    return Color(theme.separatorColor)
                }()

                VStack(alignment: .leading, spacing: .s2) {
                    DynamicTextField.default(configuration)
                    color.frame(height: height ?? .onePixel)
                }
            }
        }
    }
}

// MARK: - Dot Syntax Support

extension DynamicTextFieldStyle where Self == LineDynamicTextFieldStyle {
    public static var line: Self { line() }

    public static func line(withValidationColors: Bool = true, height: CGFloat? = nil) -> Self {
        Self(withValidationColors: withValidationColors, height: height)
    }
}
