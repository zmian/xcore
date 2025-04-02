//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A namespace for common data suitable for use in previews and tests.
public enum Samples {}

// MARK: - Built-in

extension Samples {
    /// Returns a sample email address suitable for use in previews and tests.
    public static let emailAddress = "hello@example.com"

    /// Returns a sample given name or first name suitable for use in previews and
    /// tests.
    public static let givenName = "Sam"

    /// Returns a sample family name or last name suitable for use in previews and
    /// tests.
    public static let familyName = "Swift"

    /// Returns a sample family name or last name initial suitable for use in
    /// previews and tests.
    public static let familyNameInitial = "S"

    /// Returns a sample avatar URL suitable for use in previews and tests.
    public static let avatarUrl = URL(string: "https://avatars.githubusercontent.com/u/621693")!

    /// Returns a sample URL suitable for use in previews and tests.
    public static let url = URL(string: "https://www.example.com")!

    /// Returns a URL to a sample PDF suitable for use in previews and tests.
    public static let pdfUrl = URL(string: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf")!
}

extension Samples {
    /// Strings used for debugging and preview purposes.
    public enum Strings {
        public typealias Alert = (title: String, message: String)

        public static let locationAlert = Alert(
            title: "Current Location Not Available",
            message: "Your current location can’t be determined at this time."
        )

        public static let deleteMessageAlert = Alert(
            title: "Delete Message",
            message: "Are you sure you want to delete this message?"
        )
    }
}
