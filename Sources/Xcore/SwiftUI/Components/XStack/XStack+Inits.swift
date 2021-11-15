//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Configuration

extension XStack where Title == XStackStyleConfiguration.Title, Value == XStackStyleConfiguration.Value {
    /// Creates a stack based on a stack style configuration.
    ///
    /// You can use this initializer within the ``makeBody(configuration:)`` method
    /// of a ``XStackStyle`` to create an instance of the styled stack. This is
    /// useful for custom stack styles that only modify the current stack style,
    /// as opposed to implementing a brand new style.
    ///
    /// For example, the following style adds a red border around the stack, but
    /// otherwise preserves the stack’s current style:
    ///
    /// ```swift
    /// struct RedBorderedXStackStyle: XStackStyle {
    ///     func makeBody(configuration: Configuration) -> some View {
    ///         XStack(configuration)
    ///             .border(Color.red)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter configuration: A stack style configuration.
    public init(_ configuration: XStackStyleConfiguration) {
        self.init(title: { configuration.title }, value: { configuration.value })
    }
}

// MARK: - Title Only

extension XStack where Value == Never {
    /// Creates a stack with a title.
    ///
    /// ```swift
    /// XStack {
    ///     Text("Hello")
    ///         .multilineTextAlignment(.trailing)
    /// }
    /// ```
    public init(@ViewBuilder title: @escaping () -> Title) {
        self.init {
            title()
        } value: {
            fatalError()
        }
    }
}

extension XStack where Title == Text, Value == Never {
    /// Creates a stack with a title generated from a string.
    ///
    /// ```swift
    /// XStack("Version")
    /// ```
    public init<S>(_ title: S) where S: StringProtocol {
        self.init {
            Text(title)
        }
    }
}

extension XStack where Title == Text {
    /// Creates a stack with a title generated from a string and a value.
    ///
    /// ```swift
    /// XStack("Favorite") {
    ///     Image(system: .star)
    /// }
    /// ```
    public init<S>(
        _ title: S,
        @ViewBuilder value: @escaping () -> Value
    ) where S: StringProtocol {
        self.init {
            Text(title)
        } value: {
            value()
        }
    }
}

extension XStack where Title == Text {
    /// Creates a stack with a title generated from a string and a value.
    ///
    /// ```swift
    /// XStack("Favorite", value: Image(system: .star))
    /// ```
    public init<S>(_ title: S, value: Value) where S: StringProtocol {
        self.init {
            Text(title)
        } value: {
            value
        }
    }
}

extension XStack where Title == Text, Value == Text? {
    /// Creates a stack with a title and a value generated from a string.
    ///
    /// ```swift
    /// XStack("First Name", value: "John")
    /// ```
    public init<S1, S2>(_ title: S1, value: S2?) where S1: StringProtocol, S2: StringProtocol {
        self.init {
            Text(title)
        } value: {
            value.map(Text.init)
        }
    }
}

// MARK: - Money

extension XStack where Title == Text, Value == Money? {
    /// Creates a stack with a title generated from a string and a value formatted
    /// as money.
    ///
    /// ```swift
    /// XStack("Price", money: 10) // formats the value as "$10.00"
    /// ```
    public init<S>(_ title: S, money: Decimal?) where S: StringProtocol {
        self.init {
            Text(title)
        } value: {
            Money(money)
        }
    }

    /// Creates a stack with a title generated from a string and a value formatted
    /// as money.
    ///
    /// ```swift
    /// XStack("Price", money: 10) // formats the value as "$10.00"
    /// ```
    @_disfavoredOverload
    public init<S>(_ title: S, money: Double?) where S: StringProtocol {
        self.init {
            Text(title)
        } value: {
            Money(money)
        }
    }
}

// MARK: - Double

extension XStack where Title == Text, Value == Text? {
    /// Creates a stack with a title generated from a string and a value formatted
    /// using number formatter.
    ///
    /// ```swift
    /// XStack("Quantity", value: 1000) // formats the value as "1,000"
    /// ```
    public init<S>(_ title: S, value: Double?) where S: StringProtocol {
        self.init {
            Text(title)
        } value: {
            (value?.formattedString()).map(Text.init)
        }
    }
}

// MARK: - Image

extension XStack where Title == Text, Value == Image? {
    /// Creates a stack with a title generated from a string and a value with a
    /// system image.
    ///
    /// ```swift
    /// XStack("Favorite", systemImage: .star)
    /// ```
    public init<S>(_ title: S, systemImage: SystemAssetIdentifier?) where S: StringProtocol {
        self.init {
            Text(title)
        } value: {
            systemImage.map(Image.init(system:))
        }
    }

    /// Creates a stack with a title generated from a string and a value with an
    /// image.
    ///
    /// ```swift
    /// XStack("Favorite", image: .disclosureIndicator)
    /// ```
    public init<S>(_ title: S, image: ImageAssetIdentifier?) where S: StringProtocol {
        self.init {
            Text(title)
        } value: {
            image.map(Image.init(assetIdentifier:))
        }
    }
}

extension XStack where Value == Image {
    /// Creates a stack with a title and a value with an image.
    ///
    /// ```swift
    /// XStack(image: Image(system: .docOnDoc)) {
    ///     VStack(alignment: .leading) {
    ///         Text("Apple")
    ///         Text("AAPL")
    ///             .font(.app(.footnote))
    ///             .foregroundColor(theme.textSecondaryColor)
    ///     }
    /// }
    /// ```
    public init(
        image: Image,
        @ViewBuilder title: @escaping () -> Title
    ) {
        self.init {
            title()
        } value: {
            image
        }
    }

    /// Creates a stack with a title and a value with a system image.
    ///
    /// ```swift
    /// XStack(systemImage: .docOnDoc) {
    ///     VStack(alignment: .leading) {
    ///         Text("Apple")
    ///         Text("AAPL")
    ///             .font(.app(.footnote))
    ///             .foregroundColor(theme.textSecondaryColor)
    ///     }
    /// }
    /// ```
    public init(
        systemImage: SystemAssetIdentifier,
        @ViewBuilder title: @escaping () -> Title
    ) {
        self.init(image: Image(system: systemImage), title: title)
    }
}

// MARK: - Title & Subtitle

extension XStack {
    /// Creates a stack with a title and subtitle generated from string and a value.
    ///
    /// ```swift
    /// XStack("Apple", subtitle: "AAPL") {
    ///     Image(system: .docOnDoc)
    /// }
    /// ```
    public init<S1, S2>(
        _ title: S1,
        subtitle: S2?,
        spacing: CGFloat? = nil,
        @ViewBuilder value: @escaping () -> Value
    ) where Title == _XIVTSSV<S2>, S1: StringProtocol, S2: StringProtocol {
        self.init {
            _XIVTSSV(
                title: title,
                subtitle: subtitle,
                spacing: spacing
            )
        } value: {
            value()
        }
    }

    /// Creates a stack with a title and subtitle generated from string and a value.
    ///
    /// ```swift
    /// XStack("Apple", subtitle: "AAPL", value: Image(system: .docOnDoc))
    /// ```
    public init<S1, S2>(
        _ title: S1,
        subtitle: S2?,
        spacing: CGFloat? = nil,
        value: Value
    ) where Title == _XIVTSSV<S2>, S1: StringProtocol, S2: StringProtocol {
        self.init(title, subtitle: subtitle, spacing: spacing, value: { value })
    }

    /// Creates a stack with a title and subtitle generated from string and a value
    /// with a system image.
    ///
    /// ```swift
    /// XStack("Apple", subtitle: "AAPL", systemImage: .docOnDoc)
    /// ```
    public init<S1, S2>(
        _ title: S1,
        subtitle: S2?,
        systemImage: SystemAssetIdentifier,
        spacing: CGFloat? = nil
    ) where Value == Image, Title == _XIVTSSV<S2>, S1: StringProtocol, S2: StringProtocol {
        self.init(title, subtitle: subtitle, spacing: spacing, value: Image(system: systemImage))
    }

    /// Creates a stack with a title and subtitle generated from string and a value
    /// with an image.
    ///
    /// ```swift
    /// XStack("Apple", subtitle: "AAPL", image: .disclosureIndicator)
    /// ```
    public init<S1, S2>(
        _ title: S1,
        subtitle: S2?,
        image: ImageAssetIdentifier,
        spacing: CGFloat? = nil
    ) where Value == Image, Title == _XIVTSSV<S2>, S1: StringProtocol, S2: StringProtocol {
        self.init(title, subtitle: subtitle, spacing: spacing, value: Image(assetIdentifier: image))
    }
}
