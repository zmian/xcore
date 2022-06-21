//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A button that shows either sheet of available mail apps user has installed;
/// otherwise, it opens Apple Mail app directly.
public struct OpenMailAppButton: View {
    @State private var openMailApp = false
    private let onTap: (() -> Void)?

    public init(onTap: (() -> Void)? = nil) {
        self.onTap = onTap
    }

    public var body: some View {
        Button(Localized.openMailApp) {
            openMailApp = true
            onTap?()
        }
        .openMailApp($openMailApp)
    }
}
