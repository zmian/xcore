//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Font {
    /// Creates a variable font with the specified name, size, and variation
    /// settings.
    ///
    /// A variable font supports design variations along axes such as weight, width,
    /// or slant, as defined in the font’s OpenType `fvar` table. Each axis is
    /// identified by a 4-byte tag (e.g., 'wght' for weight), represented as a
    /// 32-bit integer where each byte corresponds to an ASCII character. For
    /// example, the weight axis tag is `0x77676874`, encoding the characters
    /// "wght". The axis value, specified as a `Double`, sets the current position
    /// within the axis’s range, typically normalized between its minimum and
    /// maximum values.
    ///
    /// The `variation` dictionary maps axis tags to their values. If duplicate tags
    /// are provided, only the last value for each tag is used. Default axis values
    /// from the font’s `fvar` table are applied for unspecified axes.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// // 1. Create a helper extension
    /// extension Font {
    ///     static func inter(size: CGFloat, weight: Double, slant: Double? = nil) -> Font {
    ///         variableFont("Inter", size: size, variation: [
    ///             0x77676874: weight,
    ///             0x736c6e74: slant
    ///         ].compacted())
    ///     }
    /// }
    ///
    /// // 2: Usage
    /// Text("Hello World")
    ///     .font(.inter(size: 20, weight: 400, .slant(-10)))
    /// ```
    ///
    /// ### Standard Axis Values
    ///
    /// The following standard axes are commonly supported:
    ///
    /// - **Weight ('wght', `0x77676874`)**:
    ///   - Controls the thickness of the font’s strokes.
    ///   - **Possible Values**: Ranges from 1 to 1000, where:
    ///     - **100**: Thin
    ///     - **200**: Extra Light
    ///     - **300**: Light
    ///     - **400**: Regular
    ///     - **500**: Medium
    ///     - **600**: SemiBold
    ///     - **700**: Bold
    ///     - **800**: Extra Bold
    ///     - **900**: Black
    ///
    /// - **Width ('wdth', `0x77647468`)**:
    ///   - Adjusts the horizontal proportions of the font’s glyphs.
    ///   - **Possible Values**: Percentage of normal width, typically 50 to 200,
    ///     where:
    ///     - **50**: Ultra Condensed
    ///     - **62.5**: Extra Condensed
    ///     - **75**: Condensed
    ///     - **87.5**: Semi Condensed
    ///     - **100**: Normal
    ///     - **112.5**: Semi Expanded
    ///     - **125**: Expanded
    ///     - **150**: Extra Expanded
    ///     - **200**: Ultra Expanded
    ///
    /// - **Slant ('slnt', `0x736c6e74`)**:
    ///   - Tilts the font’s glyphs to create an oblique effect.
    ///   - **Possible Values**: Angle in degrees counterclockwise from upright,
    ///     typically -90 to 90, where:
    ///     - **0**: Upright
    ///     - **10 to 20**: Forward slant (common for oblique styles)
    ///     - **-10 to -20**: Backslant
    ///     - **-90 to 90**: Extreme angles (for special effects)
    ///
    /// - **Italic ('ital', `0x6974616c`)**:
    ///   - Transitions the font between upright and italic styles.
    ///   - **Possible Values**: Typically 0 to 1, where:
    ///     - **0**: Upright
    ///     - **1**: Italic
    ///     - **0 to 1**: Partial transitions (supported by some fonts)
    ///
    /// - **Optical Size ('opsz', `0x6f70737a`)**:
    ///   - Adjusts the font’s design for different display sizes.
    ///   - **Possible Values**: Typically in points, 6 to 144, where:
    ///     - **6 to 12**: Captions or fine print
    ///     - **12 to 18**: Body text
    ///     - **24 to 36**: Subheadings
    ///     - **36 to 72**: Headlines
    ///     - **72 to 144**: Display or posters
    ///
    /// Custom axes may be supported by specific fonts, with ranges defined in the
    /// font’s `fvar` table.
    ///
    /// - Important: The font must support variable axes, and the provided variation
    ///   settings should match those in the font’s `fvar` table. Invalid axes or
    ///   their values may result in undefined rendering behavior.
    ///
    /// - Parameters:
    ///   - name: The name of the variable font (e.g., "InterVariable").
    ///   - size: The point size of the font.
    ///   - variation: A dictionary mapping axis tags (e.g., `0x77676874` for
    ///     'wght') to their values.
    ///   - features: An array of font feature settings.
    ///
    /// - Returns: A `Font` instance configured with the specified variable font
    ///   settings.
    ///
    /// - SeeAlso: [OpenType `fvar` Table Specification](https://learn.microsoft.com/en-us/typography/opentype/spec/fvar)
    public static func variableFont(
        _ name: String,
        size: CGFloat,
        variation: [UInt32: Double],
        features: [FeatureSetting]? = nil
    ) -> Font {
        let attributes: [UIFontDescriptor.AttributeName: Any?] = [
            .name: name,
            kCTFontVariationAttribute as UIFontDescriptor.AttributeName: variation,
            .featureSettings: features?.compactMap { $0.dictionary() }
        ]

        return Font(UIFont(
            descriptor: UIFontDescriptor(fontAttributes: attributes.compacted()),
            size: size
        ))
    }

    /// Creates a variable font with the specified name, style, and variation
    /// settings.
    ///
    /// A variable font supports design variations along axes such as weight, width,
    /// or slant, as defined in the font’s OpenType `fvar` table. Each axis is
    /// identified by a 4-byte tag (e.g., 'wght' for weight), represented as a
    /// 32-bit integer where each byte corresponds to an ASCII character. For
    /// example, the weight axis tag is `0x77676874`, encoding the characters
    /// "wght". The axis value, specified as a `Double`, sets the current position
    /// within the axis’s range, typically normalized between its minimum and
    /// maximum values.
    ///
    /// The `variation` dictionary maps axis tags to their values. If duplicate tags
    /// are provided, only the last value for each tag is used. Default axis values
    /// from the font’s `fvar` table are applied for unspecified axes.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// // 1. Create a helper extension
    /// extension Font {
    ///     static func inter(style: TextStyle, weight: Double, slant: Double? = nil) -> Font {
    ///         variableFont("Inter", style: style, variation: [
    ///             0x77676874: weight,
    ///             0x736c6e74: slant
    ///         ].compacted())
    ///     }
    /// }
    ///
    /// // 2: Usage
    /// Text("Hello World")
    ///     .font(.inter(size: 20, weight: 400, .slant(-10)))
    /// ```
    ///
    /// ### Standard Axis Values
    ///
    /// The following standard axes are commonly supported:
    ///
    /// - **Weight ('wght', `0x77676874`)**:
    ///   - Controls the thickness of the font’s strokes.
    ///   - **Possible Values**: Ranges from 1 to 1000, where:
    ///     - **100**: Thin
    ///     - **200**: Extra Light
    ///     - **300**: Light
    ///     - **400**: Regular
    ///     - **500**: Medium
    ///     - **600**: SemiBold
    ///     - **700**: Bold
    ///     - **800**: Extra Bold
    ///     - **900**: Black
    ///
    /// - **Width ('wdth', `0x77647468`)**:
    ///   - Adjusts the horizontal proportions of the font’s glyphs.
    ///   - **Possible Values**: Percentage of normal width, typically 50 to 200,
    ///     where:
    ///     - **50**: Ultra Condensed
    ///     - **62.5**: Extra Condensed
    ///     - **75**: Condensed
    ///     - **87.5**: Semi Condensed
    ///     - **100**: Normal
    ///     - **112.5**: Semi Expanded
    ///     - **125**: Expanded
    ///     - **150**: Extra Expanded
    ///     - **200**: Ultra Expanded
    ///
    /// - **Slant ('slnt', `0x736c6e74`)**:
    ///   - Tilts the font’s glyphs to create an oblique effect.
    ///   - **Possible Values**: Angle in degrees counterclockwise from upright,
    ///     typically -90 to 90, where:
    ///     - **0**: Upright
    ///     - **10 to 20**: Forward slant (common for oblique styles)
    ///     - **-10 to -20**: Backslant
    ///     - **-90 to 90**: Extreme angles (for special effects)
    ///
    /// - **Italic ('ital', `0x6974616c`)**:
    ///   - Transitions the font between upright and italic styles.
    ///   - **Possible Values**: Typically 0 to 1, where:
    ///     - **0**: Upright
    ///     - **1**: Italic
    ///     - **0 to 1**: Partial transitions (supported by some fonts)
    ///
    /// - **Optical Size ('opsz', `0x6f70737a`)**:
    ///   - Adjusts the font’s design for different display sizes.
    ///   - **Possible Values**: Typically in points, 6 to 144, where:
    ///     - **6 to 12**: Captions or fine print
    ///     - **12 to 18**: Body text
    ///     - **24 to 36**: Subheadings
    ///     - **36 to 72**: Headlines
    ///     - **72 to 144**: Display or posters
    ///
    /// Custom axes may be supported by specific fonts, with ranges defined in the
    /// font’s `fvar` table.
    ///
    /// - Important: The font must support variable axes, and the provided variation
    ///   settings should match those in the font’s `fvar` table. Invalid axes or
    ///   their values may result in undefined rendering behavior.
    ///
    /// - Parameters:
    ///   - name: The name of the variable font (e.g., "InterVariable").
    ///   - style: The text style of the font.
    ///   - variation: A dictionary mapping axis tags (e.g., `0x77676874` for
    ///     'wght') to their values.
    ///   - features: An array of font feature settings.
    ///
    /// - Returns: A `Font` instance configured with the specified variable font
    ///   settings.
    ///
    /// - SeeAlso: [OpenType `fvar` Table Specification](https://learn.microsoft.com/en-us/typography/opentype/spec/fvar)
    public static func variableFont(
        _ name: String,
        style: TextStyle,
        variation: [UInt32: Double],
        features: [FeatureSetting]? = nil
    ) -> Font {
        let preferredPointSize = UIFontDescriptor.preferredFontDescriptor(
            withTextStyle: UIFont.TextStyle(style),
            compatibleWith: UIFont.compatibleWithTraitCollection()
        ).pointSize

        return variableFont(
            name,
            size: preferredPointSize,
            variation: variation,
            features: features
        )
    }
}

// MARK: - FeatureSetting

extension Font {
    /// A setting for controlling typographic features in a font, such as fractions
    /// or smart quotes.
    ///
    /// OpenType and TrueType fonts support typographic features that modify glyph
    /// rendering, such as enabling fractions, toggling slashed zeros, or replacing
    /// straight quotes with curly quotes. A feature setting consists of a type,
    /// which identifies the feature (e.g., fractions), and a selector, which
    /// specifies the feature’s state or variant (e.g., on or off). These settings
    /// are applied to a font using `UIFontDescriptor`’s feature attributes, as
    /// defined by Core Text.
    ///
    /// Use helper methods like `fractions(_:)` to create settings for standard
    /// features. The feature type and selector must match values defined in the
    /// font’s feature table, as invalid settings may result in undefined rendering
    /// behavior.
    ///
    /// - SeeAlso: [Core Text Feature Settings](https://developer.apple.com/fonts/TrueType-Reference-Manual/RM09/AppendixF.html)
    public struct FeatureSetting {
        /// The feature type identifier, specifying the typographic feature.
        ///
        /// Common feature types include:
        /// - Fractions (`kFractionsType`, 11): Controls fraction rendering.
        /// - Typographic Extras (`kTypographicExtrasType`, 14): Includes slashed zero
        ///   and smart quotes.
        ///
        /// Values are defined by Core Text and must match the font’s supported
        /// features.
        public let type: Int

        /// The feature selector, specifying the state or variant of the feature.
        ///
        /// Selectors are specific to each feature type. For example:
        /// - For `kFractionsType`: `kDiagonalFractionsSelector` (1) enables fractions,
        ///   `kNoFractionsSelector` (0) disables them.
        /// - For `kTypographicExtrasType`: `kSlashedZeroOnSelector` (4) enables slashed
        ///   zero, `kSlashedZeroOffSelector` (5) disables it.
        ///
        /// Values must be valid for the feature type, as defined by Core Text.
        public let selector: Int

        /// Initializes a feature setting with the specified type and selector.
        ///
        /// - Parameters:
        ///   - type: The feature type identifier (e.g., `kFractionsType`).
        ///   - selector: The feature selector (e.g., `kNoFractionsSelector`).
        public init(type: Int, selector: Int) {
            self.type = type
            self.selector = selector
        }

        /// Converts the feature setting to a dictionary for use with
        /// `UIFontDescriptor`.
        ///
        /// - Returns: A dictionary mapping `UIFontDescriptor.FeatureKey` keys to their
        ///   values, with `.type` and `.selector` entries.
        func dictionary() -> [UIFontDescriptor.FeatureKey: Int] {
            [.type: type, .selector: selector]
        }
    }
}

// MARK: - Feature Setting Helpers

extension Font.FeatureSetting {
    /// Creates a setting to control fraction rendering.
    ///
    /// The fractions feature enables or disables the display of fractions, such as
    /// converting "1/2" to a single glyph.
    ///
    /// - Parameter value: The selector value, typically `kNoFractionsSelector` or
    ///   `kDiagonalFractionsSelector`.
    /// - Returns: A `FeatureSetting` for the fractions feature.
    public static func fractions(_ value: Int) -> Self {
        .init(type: kFractionsType, selector: value)
    }

    /// Creates a setting to enable or disable slashed zero.
    ///
    /// The slashed zero feature replaces the standard zero with a slashed variant
    /// (e.g., "Ø") to distinguish it from the letter "O".
    ///
    /// - Parameter value: A Boolean indicating whether to enable slashed zero.
    /// - Returns: A `FeatureSetting` for the slashed zero feature.
    public static func slashedZero(_ value: Bool) -> Self {
        .init(type: kTypographicExtrasType, selector: value ? kSlashedZeroOnSelector : kSlashedZeroOffSelector)
    }

    /// Creates a setting to enable or disable smart quotes.
    ///
    /// The smart quotes feature replaces straight quotes (e.g., "'") with curly
    /// quotes (e.g., "‘" or "’") for a more polished appearance.
    ///
    /// - Parameter value: A Boolean indicating whether to enable smart quotes.
    /// - Returns: A `FeatureSetting` for the smart quotes feature.
    public static func smartQuotesAndComma(_ value: Bool) -> Self {
        .init(type: kTypographicExtrasType, selector: value ? kSmartQuotesOnSelector : kSmartQuotesOffSelector)
    }

    /// Creates a setting to enable or disable alternate shapes for
    /// context-dependent glyphs.
    ///
    /// The contextual alternates feature uses different glyphs based on the
    /// surrounding context (e.g., a centered semicolon between numbers for clock
    /// notation). This feature is typically enabled by default.
    ///
    /// - Parameter value: A Boolean indicating whether to enable contextual
    ///   alternates.
    /// - Returns: A `FeatureSetting` for the contextual alternates feature.
    public static func contextualAlternates(_ value: Bool) -> Self {
        .init(type: kContextualAlternatesType, selector: value ? kContextualAlternatesOnSelector : kContextualAlternatesOffSelector)
    }
}
