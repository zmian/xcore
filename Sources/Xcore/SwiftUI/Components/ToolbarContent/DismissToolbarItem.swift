//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A toolbar content item that displays a dismiss button labeled with an `X`,
/// executing the provided action when tapped.
///
/// The button appears in the navigation bar with the `.destructiveAction`
/// placement.
///
/// **Usage**
///
/// ```swift
/// NavigationStack {
///     Text("Hello, World!")
///         .toolbar {
///             DismissToolbarItem {
///                 print("Handle dismiss")
///             }
///         }
/// }
/// ```
public struct DismissToolbarItem: ToolbarContent {
    private let action: @MainActor () -> Void

    public init(action: @escaping @MainActor () -> Void) {
        self.action = action
    }

    public var body: some ToolbarContent {
        ToolbarItem(placement: .destructiveAction) {
            Button.dismiss(action: action)
        }
    }
}

// MARK: - Preview

#Preview {
    Text("Hello, World!")
        .toolbar {
            DismissToolbarItem {
                print("Handle dismiss")
            }
        }
        .embedInNavigation()
}
