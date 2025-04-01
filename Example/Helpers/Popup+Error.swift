//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Displays popup with the title and message provided by the error.
    func popup<Failure: Error>(
        _ error: Binding<Failure?>,
        axis: Axis = .horizontal,
        dismissMethods: Popup.DismissMethods = [.tapOutside],
        @ViewBuilder footer: @escaping (Binding<Failure?>) -> some View
    ) -> some View {
        popup(
            error.wrappedValue?.title ?? "",
            message: error.wrappedValue?.message,
            isPresented: .constant(error.wrappedValue != nil),
            dismissMethods: dismissMethods,
            footer: {
                switch axis {
                    case .horizontal:
                        HStack(spacing: .s2) {
                            footer(error)
                        }
                    case .vertical:
                        VStack(spacing: .defaultSpacing) {
                            footer(error)
                        }
                }
            }
        )
    }

    /// Displays popup with the title and message provided by the error with "OK"
    /// labeled button to dismiss the popup.
    func popup<Failure: Error>(
        _ error: Binding<Failure?>,
        dismissMethods: Popup.DismissMethods = [.tapOutside],
        action: (() -> Void)? = nil
    ) -> some View {
        popup(
            error,
            axis: .vertical,
            dismissMethods: dismissMethods,
            footer: {
                ErrorPopupDefaultActions($0, action: action)
            }
        )
    }
}

private struct ErrorPopupDefaultActions<Failure: Error>: View {
    @Dependency(\.openUrl) private var openUrl
    private let error: Binding<Failure?>
    private let action: (() -> Void)?

    init(_ error: Binding<Failure?>, action: (() -> Void)? = nil) {
        self.error = error
        self.action = action
    }

    var body: some View {
        if let appError = error.wrappedValue as? AppError {
            if appError.openAppSettings {
                Button.openAppSettings {
                    error.wrappedValue = nil
                    openUrl(.settingsApp)
                    action?()
                }
                .buttonStyle(.primary)
            }

            Button.okay {
                error.wrappedValue = nil
                action?()
            }
            .buttonStyle(appError.openAppSettings ? .secondary : .primary)
        } else {
            Button.okay {
                error.wrappedValue = nil
                action?()
            }
            .buttonStyle(.primary)
        }
    }
}
