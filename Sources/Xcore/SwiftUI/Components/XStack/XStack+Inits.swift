//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

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

extension XStack where Title == Text, Value == Image {
    /// Creates a stack with a title generated from a string and a value with a
    /// system image.
    ///
    /// ```swift
    /// XStack("Favorite", systemImage: .star)
    /// ```
    public init<S>(_ title: S, systemImage: SystemAssetIdentifier) where S: StringProtocol {
        self.init {
            Text(title)
        } value: {
            Image(system: systemImage)
        }
    }

    /// Creates a stack with a title generated from a string and a value with an
    /// image.
    ///
    /// ```swift
    /// XStack("Favorite", image: .disclosureIndicator)
    /// ```
    public init<S>(_ title: S, image: ImageAssetIdentifier) where S: StringProtocol {
        self.init {
            Text(title)
        } value: {
            Image(assetIdentifier: image)
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
        subtitle: S2,
        spacing: CGFloat? = nil,
        @ViewBuilder value: @escaping () -> Value
    ) where Title == _XStackTSSV<S1, S2>, S1: StringProtocol, S2: StringProtocol {
        self.init {
            _XStackTSSV(
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
        subtitle: S2,
        value: Value
    ) where Title == _XStackTSSV<S1, S2>, S1: StringProtocol, S2: StringProtocol {
        self.init(title, subtitle: subtitle, value: { value })
    }

    /// Creates a stack with a title and subtitle generated from string and a value
    /// with a system image.
    ///
    /// ```swift
    /// XStack("Apple", subtitle: "AAPL", systemImage: .docOnDoc)
    /// ```
    public init<S1, S2>(
        _ title: S1,
        subtitle: S2,
        systemImage: SystemAssetIdentifier
    ) where Value == Image, Title == _XStackTSSV<S1, S2>, S1: StringProtocol, S2: StringProtocol {
        self.init(title, subtitle: subtitle, value: Image(system: systemImage))
    }

    /// Creates a stack with a title and subtitle generated from string and a value
    /// with an image.
    ///
    /// ```swift
    /// XStack("Apple", subtitle: "AAPL", image: .disclosureIndicator)
    /// ```
    public init<S1, S2>(
        _ title: S1,
        subtitle: S2,
        image: ImageAssetIdentifier
    ) where Value == Image, Title == _XStackTSSV<S1, S2>, S1: StringProtocol, S2: StringProtocol {
        self.init(title, subtitle: subtitle, value: Image(assetIdentifier: image))
    }
}

// MARK: - Internal Views

/// This view is an implementation detail of XStack. Don't use it.
///
/// :nodoc:
public struct _XStackTSSV<S1: StringProtocol, S2: StringProtocol>: View {
    @Environment(\.theme) private var theme
    var title: S1
    var subtitle: S2
    var spacing: CGFloat?

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text(title)
                .foregroundColor(theme.textColor)
            Text(subtitle)
                .font(.app(.footnote))
                .truncationMode(.middle)
        }
        .multilineTextAlignment(.leading)
    }
}
