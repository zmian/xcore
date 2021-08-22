//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Support for String based page data

public struct IdentifiableString: Identifiable {
    public let id: String
}

extension StoryView where Page == IdentifiableString {
    public init(
        interval: TimeInterval = 4,
        pages: [String],
        @ViewBuilder content: @escaping (String) -> Content,
        @ViewBuilder background: @escaping (String) -> Background
    ) {
        self.init(
            interval: interval,
            pages: pages.map(IdentifiableString.init(id:)),
            content: { page in
                content(page.id)
            },
            background: { page in
                background(page.id)
            }
        )
    }
}

extension StoryView where Page == IdentifiableString, Background == Never {
    public init(
        interval: TimeInterval = 4,
        pages: [String],
        @ViewBuilder content: @escaping (String) -> Content
    ) {
        self.init(
            interval: interval,
            pages: pages,
            content: content,
            background: { _ in fatalError() }
        )
    }
}
