//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Label where Icon == EmptyView {
    /// Creates a label with a custom title.
    ///
    /// ```swift
    /// Label {
    ///     Text("Hello")
    ///         .multilineTextAlignment(.trailing)
    /// }
    /// ```
    public init(@ViewBuilder title: @escaping () -> Title) {
        self.init {
            title()
        } icon: {}
    }
}

extension Label where Title == Text, Icon == EmptyView {
    /// Creates a label with a title generated from a string.
    ///
    /// ```swift
    /// Label("Version")
    /// ```
    public init<S>(_ title: S) where S: StringProtocol {
        self.init {
            Text(title)
        }
    }
}

extension Label where Title == Text {
    /// Creates a label with an icon and a title generated from a string.
    ///
    /// ```swift
    /// Label("Favorite") {
    ///     Image(system: .star)
    /// }
    /// ```
    public init<S>(
        _ title: S, @ViewBuilder icon: @escaping () -> Icon
    ) where S: StringProtocol {
        self.init {
            Text(title)
        } icon: {
            icon()
        }
    }
}

extension Label where Title == Text {
    /// Creates a label with an icon and a title generated from a string.
    ///
    /// ```swift
    /// Label("Favorite", icon: Image(system: .star))
    /// ```
    public init<S>(_ title: S, icon: Icon) where S: StringProtocol {
        self.init {
            Text(title)
        } icon: {
            icon
        }
    }
}

extension Label where Title == Text, Icon == Text? {
    /// Creates a label with a value and a title generated from a string.
    ///
    /// ```swift
    /// Label("First Name", value: "John")
    /// ```
    public init(_ title: String, value: String?) {
        self.init {
            Text(title)
        } icon: {
            value.map(Text.init)
        }
    }
}

// MARK: - Money

extension Label where Title == Text, Icon == Money? {
    /// Creates a label with a title and a value represented as Money.
    ///
    /// ```swift
    /// Label("Price", money: 10) // formats the value as "$10.00"
    /// ```
    public init(_ title: String, money: Double?) {
        self.init {
            Text(title)
        } icon: {
            Money(money)
        }
    }
}

// MARK: - Double

extension Label where Title == Text, Icon == Text? {
    /// Creates a label with a title and a value formatted using number formatter.
    ///
    /// ```swift
    /// Label("Quantity", value: 1000) // formats the value as "1,000"
    /// ```
    public init(_ title: String, value: Double?) {
        self.init {
            Text(title)
        } icon: {
            (value?.formattedString()).map(Text.init)
        }
    }
}

// MARK: - Image

extension Label where Icon == Image {
    /// Creates a label with an icon image and a custom title.
    ///
    /// ```swift
    /// Label(image: Image(system: .docOnDoc)) {
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
        } icon: {
            image
        }
    }

    /// Creates a label with a system icon image and a custom title.
    ///
    /// ```swift
    /// Label(systemImage: .docOnDoc) {
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

extension Label where Title == _LabelTSSV {
    /// Creates a label with a title, subtitle and a custom icon.
    ///
    /// ```swift
    /// Label("Apple", subtitle: "AAPL") {
    ///     Image(system: .docOnDoc)
    /// }
    /// ```
    public init(
        _ title: String,
        subtitle: String,
        spacing: CGFloat? = nil,
        @ViewBuilder icon: @escaping () -> Icon
    ) {
        self.init {
            _LabelTSSV(
                title: title,
                subtitle: subtitle,
                spacing: spacing
            )
        } icon: {
            icon()
        }
    }

    /// Creates a label with a title, subtitle and a custom icon.
    ///
    /// ```swift
    /// Label("Apple", subtitle: "AAPL", icon: Image(system: .docOnDoc))
    /// ```
    public init(_ title: String, subtitle: String, icon: Icon) {
        self.init(title, subtitle: subtitle, icon: { icon })
    }
}

extension Label where Title == _LabelTSSV, Icon == Image {
    /// Creates a label with a title, subtitle and a custom icon.
    ///
    /// ```swift
    /// Label("Apple", subtitle: "AAPL", systemImage: .docOnDoc)
    /// ```
    public init(_ title: String, subtitle: String, systemImage: SystemAssetIdentifier) {
        self.init(title, subtitle: subtitle, icon: Image(system: systemImage))
    }
}

// MARK: - Internal Views

/// This view is an implementation detail of Label. Don't use it.
///
/// :nodoc:
public struct _LabelTSSV: View {
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
