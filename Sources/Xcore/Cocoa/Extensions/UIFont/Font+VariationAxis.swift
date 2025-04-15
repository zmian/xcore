//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Font {
    /// Creates a variable font with the specified name, size, and axis settings.
    ///
    /// This method configures a variable font using the provided axis settings,
    /// allowing customization of design variations such as weight, width, or slant,
    /// as defined in the font’s `fvar` table.
    ///
    /// If the `variationAxes` array contains duplicate tags, only the last
    /// value for each tag is used. To ensure predictable behavior, provide
    /// unique tags for each axis.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// Text("Hello World")
    ///     .font(.variableFont("InterVariable", size: 20, axes: [.weight(400)]))
    /// ```
    ///
    /// **Advanced Usage**
    ///
    /// ```swift
    /// // 1. Create a helper extension
    /// extension Font {
    ///     public static func inter(size: CGFloat, _ axes: VariationAxis...) -> Font {
    ///         variableFont("InterVariable", size: size, axes: axes)
    ///     }
    /// }
    ///
    /// // 2: Usage
    /// Text("Hello World")
    ///     .font(.inter(size: 20, .weight(400), .slant(-10)))
    /// ```
    ///
    /// - Note: The font must support variable axes, and the provided axis tags
    ///   should match those defined in the font’s `fvar` table. Invalid tags or
    ///   values may result in undefined rendering behavior. Default axis values
    ///   from the font’s `fvar` table are used for unspecified axes.
    ///
    /// - Parameters:
    ///   - name: The name of the variable font (e.g., "Inter").
    ///   - size: The point size of the font.
    ///   - variationAxes: An array of `VariationAxis` instances specifying the axis
    ///     tags and values to apply.
    ///
    /// - Returns: A `Font` instance configured with the specified variable font
    ///   settings.
    /// - SeeAlso: [OpenType `fvar` Table Specification](https://learn.microsoft.com/en-us/typography/opentype/spec/fvar)
    public static func variableFont(
        _ font: String,
        size: CGFloat,
        axes variationAxes: [VariationAxis]
    ) -> Font {
        // Convert axes to a dictionary, keeping the last value for duplicate tags
        let axes = Dictionary(
            variationAxes.map { ($0.tag, $0.value) },
            uniquingKeysWith: { _, new in new }
        )

        return Font(UIFont(
            descriptor: UIFontDescriptor(fontAttributes: [
                .name: font,
                kCTFontVariationAttribute as UIFontDescriptor.AttributeName: axes
            ]),
            size: size
        ))
    }
}

extension Font {
    /// Represents a design variation axis in a variable font, as defined in the
    /// OpenType `fvar` table.
    ///
    /// A variation axis defines a single dimension of design variation in a
    /// variable font, such as weight, width, or slant. Each axis is identified by a
    /// 4-byte tag (e.g., 'wght' for weight), represented as a 32-bit integer where
    /// each byte corresponds to an ASCII character. For example, the weight axis
    /// tag is `0x77676874`, encoding the characters "wght". The axis value,
    /// typically a float, specifies the current setting within a defined range,
    /// normalized between the axis’s minimum and maximum values. The `fvar` table
    /// provides metadata for each axis, including its tag, default value, minimum
    /// and maximum values, and additional properties. This type simplifies the
    /// concept to focus on the essential tag and value pair.
    ///
    /// - Tip: Use helper methods like `.weight(_:)` to specify standard axes.
    ///
    /// - SeeAlso: [OpenType `fvar` Table Specification](https://learn.microsoft.com/en-us/typography/opentype/spec/fvar)
    public struct VariationAxis: Sendable, Hashable {
        /// A 4-byte tag identifying the design variation axis.
        ///
        /// Tags are defined as 4-character ASCII strings, represented as a 32‑bit
        /// integer. For example, the weight axis is represented as `0x77676874`,
        /// corresponding to "wght".
        public let tag: UInt32

        /// The value of the axis, typically a normalized float within the axis's
        /// defined range.
        ///
        /// For standard axes, values are interpreted as follows:
        /// - **Weight ('wght')**: 1 to 1000 (e.g., 400 for regular, 700 for bold).
        /// - **Width ('wdth')**: Percentage of normal width (e.g., 100 for normal, 50
        ///   for condensed).
        /// - **Slant ('slnt')**: Angle in degrees counterclockwise from upright (e.g.,
        ///   -90 to 90).
        /// - **Italic ('ital')**: 0 (upright) to 1 (italic).
        /// - **Optical Size ('opsz')**: Typically 6 to 144 points (e.g., 12 for
        ///   captions, 72 for display).
        ///
        /// Custom axes may define their own ranges, as specified in the font’s `fvar`
        /// table.
        public let value: Double

        /// Initializes a variation axis with the specified tag and value.
        ///
        /// - Parameters:
        ///   - tag: The 4-byte axis tag (e.g., `0x77676874` for 'wght').
        ///   - value: The axis value, typically a normalized `Float`.
        public init(tag: UInt32, value: Double) {
            self.tag = tag
            self.value = value
        }
    }
}

// MARK: - Built-in Axes

extension Font.VariationAxis {
    /// Creates a weight axis with the specified value.
    ///
    /// The weight axis ('wght') controls the thickness of the font’s strokes.
    ///
    /// - **Possible Values**: Ranges from 1 to 1000, where:
    ///   - **100**: Thin
    ///   - **200**: Extra Light
    ///   - **300**: Light
    ///   - **400**: Regular
    ///   - **500**: Medium
    ///   - **600**: SemiBold
    ///   - **700**: Bold
    ///   - **800**: Extra Bold
    ///   - **900**: Black
    ///
    /// - Parameter value: The weight value, typically 1 to 1000.
    /// - Returns: A `VariationAxis` with the 'wght' tag.
    public static func weight(_ value: Double) -> Self {
        Self(tag: 0x77676874, value: value)
    }

    /// Creates a width axis with the specified value.
    ///
    /// The width axis ('wdth') adjusts the horizontal proportions of the font’s
    /// glyphs.
    ///
    /// - **Possible Values**: Expressed as a percentage of normal width, typically
    ///   50 to 200, where:
    ///   - **50**: Ultra Condensed
    ///   - **62.5**: Extra Condensed
    ///   - **75**: Condensed
    ///   - **87.5**: Semi Condensed
    ///   - **100**: Normal
    ///   - **112.5**: Semi Expanded
    ///   - **125**: Expanded
    ///   - **150**: Extra Expanded
    ///   - **200**: Ultra Expanded
    ///
    /// - Parameter value: The width value, typically 50 to 200.
    /// - Returns: A `VariationAxis` with the 'wdth' tag.
    public static func width(_ value: Double) -> Self {
        Self(tag: 0x77647468, value: value)
    }

    /// Creates a slant axis with the specified value.
    ///
    /// The slant axis ('slnt') tilts the font’s glyphs to create an oblique effect.
    ///
    /// - **Possible Values**: Angle in degrees counterclockwise from upright,
    ///   typically -90 to 90, where:
    ///   - **0**: Upright
    ///   - **10 to 20**: Forward slant (common for oblique styles)
    ///   - **-10 to -20**: Backslant
    ///   - **-90 to 90**: Extreme angles (for special effects)
    ///
    /// - Parameter value: The slant angle in degrees, typically -90 to 90.
    /// - Returns: A `VariationAxis` with the 'slnt' tag.
    public static func slant(_ value: Double) -> Self {
        Self(tag: 0x736c6e74, value: value)
    }

    /// Creates an italic axis with the specified value.
    ///
    /// The italic axis ('ital') transitions the font between upright and italic
    /// styles.
    ///
    /// - **Possible Values**: Typically 0 to 1, where:
    ///   - **0**: Upright
    ///   - **1**: Italic
    ///   - **0 to 1**: Partial transitions (supported by some fonts)
    ///
    /// - Parameter value: The italic value, typically 0 to 1.
    /// - Returns: A `VariationAxis` with the 'ital' tag.
    public static func italic(_ value: Double) -> Self {
        Self(tag: 0x6974616c, value: value)
    }

    /// Creates an optical size axis with the specified value.
    ///
    /// The optical size axis ('opsz') adjusts the font’s design for different
    /// display sizes.
    ///
    /// - **Possible Values**: Typically in points, 6 to 144, where:
    ///   - **6 to 12**: Captions or fine print
    ///   - **12 to 18**: Body text
    ///   - **24 to 36**: Subheadings
    ///   - **36 to 72**: Headlines
    ///   - **72 to 144**: Display or posters
    ///
    /// - Parameter value: The optical size in points, typically 6 to 144.
    /// - Returns: A `VariationAxis` with the 'opsz' tag.
    public static func opticalSize(_ value: Double) -> Self {
        Self(tag: 0x6f70737a, value: value)
    }
}
