//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A stylized view, with an optional label, that is visually presented in a
/// capsule shape.
public struct CapsuleView<Label>: View where Label: View {
    @Environment(\.theme) private var theme
    private let image: SystemAssetIdentifier?
    private let title: Text
    private let label: () -> Label

    public var body: some View {
        HStack(spacing: .s4) {
            if let image {
                Image(system: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(28)
            }

            VStack {
                title
                    .font(.app(.headline, weight: .semibold))

                if Label.self != Never.self {
                    label()
                        .font(.app(.subheadline))
                        .foregroundColor(theme.textSecondaryColor)
                }
            }
            .padding(hasImage ? .trailing : .horizontal)
        }
        .padding(.horizontal)
        .frame(minHeight: 56)
        .background(Color(light: .systemBackground, dark: .secondarySystemBackground))
        .clipShape(.capsule)
        .floatingShadow()
        .accessibilityElement(children: .combine)
    }

    private var hasImage: Bool {
        image != nil
    }
}

// MARK: - Inits

extension CapsuleView {
    public init(
        _ title: Text,
        systemImage: SystemAssetIdentifier? = nil,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.image = systemImage
        self.title = title
        self.label = label
    }

    public init(
        _ title: some StringProtocol,
        systemImage: SystemAssetIdentifier? = nil,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.init(Text(title), systemImage: systemImage, label: label)
    }
}

extension CapsuleView<Text?> {
    public init(
        _ title: Text,
        subtitle: Text?,
        systemImage: SystemAssetIdentifier? = nil
    ) {
        self.init(title, systemImage: systemImage) {
            subtitle
        }
    }

    public init(
        _ title: some StringProtocol,
        subtitle: (some StringProtocol)?,
        systemImage: SystemAssetIdentifier? = nil
    ) {
        self.init(title, systemImage: systemImage) {
            Text(subtitle)
        }
    }
}

extension CapsuleView<Never> {
    public init(
        _ title: Text,
        systemImage: SystemAssetIdentifier? = nil
    ) {
        self.init(title, systemImage: systemImage) {
            fatalError()
        }
    }

    public init(
        _ title: some StringProtocol,
        systemImage: SystemAssetIdentifier? = nil
    ) {
        self.init(title, systemImage: systemImage) {
            fatalError()
        }
    }
}

#if DEBUG

// MARK: - Preview Provider

struct CapsuleView_Previews: PreviewProvider {
    static var previews: some View {
        Samples.capsuleViewPreviews
            .colorScheme(.light)
    }
}

extension Samples {
    public static var capsuleViewPreviews: some View {
        LazyView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()

                VStack(spacing: .s6) {
                    CapsuleView("Apple Pencil") {
                        HStack {
                            Text("100%")
                            Image(system: .battery100Bolt)
                                .renderingMode(.original)
                        }
                    }

                    CapsuleView("Do Not Disturb", subtitle: "On", systemImage: .moonFill)
                        .foregroundColor(.indigo)
                        .colorScheme(.dark)

                    CapsuleView("No Internet Connection", systemImage: .boltSlashFill)
                        .foregroundColor(.orange)

                    CapsuleView("Mail pasted from Photos")

                    CapsuleView("Dismiss")

                    CapsuleView("9:41 AM", systemImage: .bellFill)
                }
            }
        }
    }
}
#endif
