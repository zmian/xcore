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
    /// Creates a stack with a title.
    ///
    /// ```swift
    /// XStack(title: "Version")
    /// ```
    public init(title: String) {
        self.init {
            Text(title)
        }
    }
}

extension XStack where Title == Text {
    /// Creates a stack with a title string and a custom value.
    ///
    /// ```swift
    /// XStack(title: "Favorite") {
    ///     Image(system: .star)
    /// }
    /// ```
    public init(title: String, @ViewBuilder value: @escaping () -> Value) {
        self.init {
            Text(title)
        } value: {
            value()
        }
    }
}

extension XStack where Title == Text {
    /// Creates a stack with a title string and a custom value.
    ///
    /// ```swift
    /// XStack(title: "Favorite", value: Image(system: .star))
    /// ```
    public init(title: String, value: Value) {
        self.init {
            Text(title)
        } value: {
            value
        }
    }
}

extension XStack where Title == Text, Value == Text? {
    /// Creates a stack with a title and a value.
    ///
    /// ```swift
    /// XStack(title: "First Name", value: "John")
    /// ```
    public init(title: String, value: String?) {
        self.init {
            Text(title)
        } value: {
            value.map(Text.init)
        }
    }
}

// MARK: - Money

extension XStack where Title == Text, Value == Money? {
    /// Creates a stack with a title and a value represented as Money.
    ///
    /// ```swift
    /// XStack(title: "Price", money: 10) // formats the value as "$10.00"
    /// ```
    public init(title: String, money: Double?) {
        self.init {
            Text(title)
        } value: {
            Money(money)
        }
    }
}

// MARK: - Double

extension XStack where Title == Text, Value == Text? {
    /// Creates a stack with a title and a value formatted using number formatter.
    ///
    /// ```swift
    /// XStack(title: "Quantity", value: 1000) // formats the value as "1,000"
    /// ```
    public init(title: String, value: Double?) {
        self.init {
            Text(title)
        } value: {
            (value?.formattedString()).map(Text.init)
        }
    }
}

// MARK: - Image

extension XStack where Title == Text, Value == Image {
    /// Creates a stack with a title string and a value as the given image.
    ///
    /// ```swift
    /// XStack(title: "Favorite", systemImage: .star)
    /// ```
    public init(title: String, systemImage: SystemAssetIdentifier) {
        self.init {
            Text(title)
        } value: {
            Image(system: systemImage)
        }
    }

    /// Creates a stack with a title string and a value as the given image.
    ///
    /// ```swift
    /// XStack(title: "Favorite", image: .disclosureIndicator)
    /// ```
    public init(title: String, image: ImageAssetIdentifier) {
        self.init {
            Text(title)
        } value: {
            Image(assetIdentifier: image)
        }
    }
}

extension XStack where Value == Image {
    /// Creates a stack with a title and a value as the given image.
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

    /// Creates a stack with a title and a value as the given system image.
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

extension XStack where Title == _XStackTSSV {
    /// Creates a stack with a title, subtitle and a value using the given closure.
    ///
    /// ```swift
    /// XStack(title: "Apple", subtitle: "AAPL") {
    ///     Image(system: .docOnDoc)
    /// }
    /// ```
    public init(
        title: String,
        subtitle: String,
        spacing: CGFloat? = nil,
        @ViewBuilder value: @escaping () -> Value
    ) {
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
}

extension XStack where Title == _XStackTSSV {
    /// Creates a stack with a title, subtitle and a value using the given closure.
    ///
    /// ```swift
    /// XStack(title: "Apple", subtitle: "AAPL", value: Image(system: .docOnDoc))
    /// ```
    public init(title: String, subtitle: String, value: Value) {
        self.init(title: title, subtitle: subtitle, value: { value })
    }
}

extension XStack where Title == _XStackTSSV, Value == Image {
    /// Creates a stack with a title, subtitle and a value using the given closure.
    ///
    /// ```swift
    /// XStack(title: "Apple", subtitle: "AAPL", systemImage: .docOnDoc)
    /// ```
    public init(title: String, subtitle: String, systemImage: SystemAssetIdentifier) {
        self.init(title: title, subtitle: subtitle, value: Image(system: systemImage))
    }
}

// MARK: - Internal Views

/// This view is an implementation detail of XStack. Don't use it.
///
/// :nodoc:
public struct _XStackTSSV: View {
    @Environment(\.theme) private var theme
    var title: String
    var subtitle: String
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
