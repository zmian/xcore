//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

private typealias L = Localized
public typealias EitherAnyViewText = _ConditionalContent<AnyView, Text>

// MARK: - Text

extension Button<Text> {
    /// An accessible button that has the given `text` as label and performs the
    /// provided `action`.
    public static func accessible(
        text: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(text)
        }
        .accessibilityIdentifier("\(text.camelcased())Button")
    }

    /// A button with `OK` label and given action.
    public static func okay(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.ok)
        }
        .accessibilityIdentifier("okayButton")
    }

    /// A button with `Yes` label and given action.
    public static func yes(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.yes)
        }
        .accessibilityIdentifier("yesButton")
    }

    /// A button with `No` label and given action.
    public static func no(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.no)
        }
        .accessibilityIdentifier("noButton")
    }

    /// A button with `Submit` label and given action.
    public static func submit(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.submit)
        }
        .accessibilityIdentifier("submitButton")
    }

    /// A button with `Done` label and given action.
    public static func done(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.done)
        }
        .accessibilityIdentifier("doneButton")
    }

    /// A button with `Cancel` label and given action.
    public static func cancel(action: @escaping () -> Void) -> some View {
        Button(role: .cancel, action: action) {
            Text(L.cancel)
        }
        .accessibilityIdentifier("cancelButton")
    }

    /// A button with `Enable` label and given action.
    public static func enable(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.enable)
        }
        .accessibilityIdentifier("enableButton")
    }

    /// A button with `Hide` label and given action.
    public static func hide(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.hide)
        }
        .accessibilityIdentifier("hideButton")
    }

    /// A button with `Remove` label and given action.
    public static func remove(action: @escaping () -> Void) -> some View {
        Button(role: .destructive, action: action) {
            Text(L.remove)
        }
        .accessibilityIdentifier("removeButton")
    }

    /// A button with `Retry` label and given action.
    public static func retry(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.retry)
        }
        .accessibilityIdentifier("retryButton")
    }

    /// A button with `Unlink` label and given action.
    public static func unlink(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.unlink)
        }
        .accessibilityIdentifier("unlinkButton")
    }

    /// A button with `Unlock` label and given action.
    public static func unlock(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.unlock)
        }
        .accessibilityIdentifier("unlockButton")
    }

    /// A button with `Continue` label and given action.
    public static func `continue`(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.continue)
        }
        .accessibilityIdentifier("continueButton")
    }

    /// A button with `Resend` label and given action.
    public static func resend(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.resend)
        }
        .accessibilityIdentifier("resendButton")
    }

    /// A button with `Next` label and given action.
    public static func next(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.next)
        }
        .accessibilityIdentifier("nextButton")
    }

    /// A button with `Get Started` label and given action.
    public static func getStarted(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.getStarted)
        }
        .accessibilityIdentifier("getStartedButton")
    }

    /// A button with `Help` label and given action.
    public static func help(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.help)
        }
        .accessibilityIdentifier("helpButton")
    }

    /// A button with `Contact Support` label and given action.
    public static func contactSupport(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.contactSupport)
        }
        .accessibilityIdentifier("contactSupportButton")
    }

    /// A button with `Open App Settings` label and given action.
    public static func openAppSettings(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.openAppSettings)
        }
        .accessibilityIdentifier("openAppSettingsButton")
    }

    /// A button with `Track` label and given action.
    public static func track(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.track)
        }
        .accessibilityIdentifier("trackButton")
    }

    /// A button with `Start` label and given action.
    public static func start(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.start)
        }
        .accessibilityIdentifier("startButton")
    }

    /// A button with `Share` label and given action.
    public static func share(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.share)
        }
        .accessibilityIdentifier("shareButton")
    }

    /// A button with `Sign Up` label and given action.
    public static func signup(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.signup)
        }
        .accessibilityIdentifier("signupButton")
    }

    /// A button with `Log In` label and given action.
    public static func signin(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(L.signin)
        }
        .accessibilityIdentifier("signinButton")
    }
}

// MARK: - Image

extension Button<Image> {
    /// A button with `X` label and given action.
    public static func dismiss(action: @escaping () -> Void) -> some View {
        Button(role: .cancel, action: action) {
            Image(system: .xMark)
        }
        .accessibilityLabel("Dismiss")
        .accessibilityIdentifier("dismissButton")
    }
}

// MARK: - Learn More, Read More, See More, See More/Less, See All, See All/Less

extension Button<EitherAnyViewText> {
    /// A button with `Learn More` label and an option to display a chevron and
    /// given action.
    public static func learnMore(withChevron: Bool = true, action: @escaping () -> Void) -> some View {
        Button.menu(L.learnMore, image: withChevron ? .chevronRight : nil, action: action)
            .accessibilityIdentifier("learnMoreButton")
    }

    /// A button with `Read More` label and an option to display a chevron and
    /// given action.
    public static func readMore(withChevron: Bool = true, action: @escaping () -> Void) -> some View {
        Button.menu(L.readMore, image: withChevron ? .chevronRight : nil, action: action)
            .accessibilityIdentifier("readMoreButton")
    }

    /// A button with `See More` label and given action.
    public static func seeMore(withChevron: Bool = true, action: @escaping () -> Void) -> some View {
        Button.menu(L.seeMore, image: withChevron ? .chevronRight : nil, action: action)
            .accessibilityIdentifier("seeMoreButton")
    }

    /// A button with `See More/Less` label based on `toggled` and given action.
    public static func seeMore(withChevron: Bool = true, toggled: Bool, action: @escaping () -> Void) -> some View {
        menu(
            toggled ? L.toggleSeeLess : L.toggleSeeMore,
            image: withChevron ? (toggled ? .chevronUp : .chevronDown) : nil,
            action: action
        )
        .accessibilityIdentifier(toggled ? "seeLessButton" : "seeMoreButton")
    }

    /// A button with `See All` label and given action.
    public static func seeAll(withChevron: Bool = true, action: @escaping () -> Void) -> some View {
        Button.menu(L.seeAll, image: withChevron ? .chevronRight : nil, action: action)
            .accessibilityIdentifier("seeAllButton")
    }

    /// A button with `See All/Less` label based on `toggled` and given action.
    public static func seeAll(withChevron: Bool = true, toggled: Bool, action: @escaping () -> Void) -> some View {
        menu(
            toggled ? L.toggleSeeLess : L.toggleSeeAll,
            image: withChevron ? (toggled ? .chevronUp : .chevronDown) : nil,
            action: action
        )
        .accessibilityIdentifier(toggled ? "seeLessButton" : "seeAllButton")
    }
}

// MARK: - Menu

extension Button<EitherAnyViewText> {
    /// A button with label generated from the string and `image` and given action.
    public static func menu(
        _ title: String,
        image: SystemAssetIdentifier?,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            if let image {
                Text(title)
                    .symbol(image, scale: .small)
                    .eraseToAnyView()
            } else {
                Text(title)
            }
        }
    }
}

// MARK: - Dropdown

extension Button<Never> {
    /// A button with label generated from the string and optional `prompt` string
    /// above the button and given action.
    public static func dropdown(
        _ title: String,
        prompt: String? = nil,
        action: @escaping () -> Void
    ) -> some View {
        EnvironmentReader(\.theme) { theme in
            VStack(alignment: .leading, spacing: .s2) {
                if let prompt {
                    Text(prompt)
                        .font(.app(.footnote))
                        .foregroundStyle(theme.textSecondaryColor)
                        .padding(.leading, .s4)
                }

                Button<XLabeledContent>(action: action) {
                    XLabeledContent(title, systemImage: .chevronDown)
                }
                .buttonStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.defaultSpacing)
        }
        .accessibilityIdentifier("dropdownButton")
    }
}
