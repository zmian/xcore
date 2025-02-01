//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct TrimmedTests {
    @Test
    func basics() {
        struct Post {
            @Trimmed var title: String
            @Trimmed var body: String
        }

        var post = Post(
            title: "  Swift Property Wrappers  ",
            body: "..."
        )

        #expect(post.title == "Swift Property Wrappers")
        post.title = "      @propertyWrapper     "
        #expect(post.title == "@propertyWrapper")

        post.title = "  Swift Property            Wrappers  "
        #expect(post.title == "Swift Property Wrappers")
    }
}
