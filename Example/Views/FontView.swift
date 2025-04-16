//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct FontView: View {
    @State private var size: Double = 17
    @State private var weight: Double = 400
    @State private var opticalSize: Double = 18

    var body: some View {
        VStack {
            VStack {
                Spacer()
                Text(#"Inter is a variable font with several OpenType features, like contextual alternates that adjusts punctuation depending on the shape of surrounding glyphs, slashed zero for when you need to disambiguate "0" from "o", tabular numbers, etc."#)

                Divider()
                    .frame(width: 100)

                Text("Features")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)

                Divider()
                    .frame(width: 100)

                Text(#"Difficult 1/3 0123"#)
                Text(#"3*9  12:34  3–8  +8+x"#)
                Text(#"-> --> ---> => ==> <->"#)
                Text(#"I'm not, uhm "smol"#)
                Spacer()
            }
            .font(.inter(size: size, weight: weight, opticalSize: opticalSize))

            Slider("Weight", value: $weight, in: 100...900, step: 50)
            Slider("Optical Size", value: $opticalSize, in: 14...32)
            Slider("Size", value: $size, in: 10...100)
        }
        .padding()
        .frame(max: .infinity)
        .background(.gray.quaternary)
    }

    private func Slider(
        _ label: String,
        value: Binding<Double>,
        in bounds: ClosedRange<Double>,
        step: Double.Stride = 1
    ) -> some View {
        VStack {
            Text(label + " ")
                .fontWeight(.semibold)
            +
            Text(value.wrappedValue, format: .number)
                .monospacedDigit()
                .foregroundStyle(.tint)
                .fontWeight(.semibold)

            SwiftUI.Slider(value: value, in: bounds, step: step) {
                Text(label)
            } minimumValueLabel: {
                Text(bounds.lowerBound, format: .number)
            } maximumValueLabel: {
                Text(bounds.upperBound, format: .number)
            }
            .foregroundStyle(.tertiary)
        }
        .padding()
        .background(.background, in: .rect(cornerRadius: AppConstants.cornerRadius))
    }
}

// MARK: - Helpers

extension Font {
    fileprivate static func inter(size: CGFloat, weight: Double, opticalSize: Double) -> Font {
        variableFont(
            "InterVariable",
            size: size,
            variation: [
                0x77676874: weight,
                0x6f70737a: opticalSize
            ],
            features: [
                .fractions(2),
                .slashedZero(true),
                .smartQuotesAndComma(true),
                .contextualAlternates(true)
            ]
        )
    }

    static func configureDefaultAppTypeface() {
        guard AppInfo.executionTarget == .app else {
            return
        }

        do {
            try UIFont.registerIfNeeded("InterVariable.ttf")
        } catch {
            #if DEBUG
            if AppInfo.isDebuggerAttached {
                fatalError("Unable to register custom font: \(String(describing: error))")
            }
            #endif
        }
    }
}
