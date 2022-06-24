//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct MailApp: Hashable, Identifiable {
    let name: String
    let url: URL

    var id: String {
        name + "-" + url.absoluteString
    }

    private var isAvailable: Bool {
        UIApplication.sharedOrNil?.canOpenURL(url) ?? false
    }

    static var available: [Self] {
        all.filter(\.isAvailable)
    }
}

// MARK: - Apps

extension MailApp {
    private static var all: [Self] {
        [.mail, .gmail, .outlook, .yahoo]
    }

    private static var mail: Self {
        .init(name: "Mail", url: .mailApp)
    }

    private static var gmail: Self {
        .init(name: "Gmail", url: URL(string: "googlegmail://")!)
    }

    private static var outlook: Self {
        .init(name: "Outlook", url: URL(string: "ms-outlook://")!)
    }

    private static var yahoo: Self {
        .init(name: "Yahoo Mail", url: URL(string: "ymail://")!)
    }
}
