//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A namespace for previews purpose.
public enum Samples {}

// MARK: - Built-in

extension Samples {
    /// Returns a sample email address suitable to display in the previews and tests.
    public static let emailAddress = "hello@example.com"

    /// Returns a sample first name suitable to display in the previews and tests.
    public static let firstName = "Sam"

    /// Returns a sample last name suitable to display in the previews and tests.
    public static let lastName = "Swift"

    /// Returns a sample last name initial suitable to display in the previews and
    /// tests.
    public static let lastNameInitial = "S"

    /// Returns a sample url suitable to display in the previews and tests.
    public static let url = URL(string: "https://www.example.com")!

    /// Returns a url to a sample PDF suitable to display in the previews and tests.
    public static let pdfUrl = URL(string: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf")!
}

extension Samples {
    /// Strings used for debug and previews purpose.
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
