//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Environment Support

extension EnvironmentValues {
    private struct PopupAlertAttributesKey: EnvironmentKey {
        static var defaultValue: Popup.AlertAttributes = .init()
    }

    var popupAlertAttributes: Popup.AlertAttributes {
        get { self[PopupAlertAttributesKey.self] }
        set { self[PopupAlertAttributesKey.self] = newValue }
    }
}

// MARK: - View Helpers

extension View {
    public func popupAlert(cornerRadius: CGFloat = 16, width: CGFloat = 300, textAlignment: TextAlignment = .center) -> some View {
        transformEnvironment(\.popupAlertAttributes) {
            $0.cornerRadius = cornerRadius
            $0.width = width
            $0.textAlignment = textAlignment
        }
    }
}

extension Popup {
    struct AlertAttributes {
        var cornerRadius: CGFloat = 16
        var width: CGFloat = 300
        var textAlignment: TextAlignment = .center
    }
}
