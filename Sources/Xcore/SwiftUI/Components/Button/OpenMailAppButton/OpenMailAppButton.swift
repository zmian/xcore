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

// MARK: - View

extension View {
    /// A view modifier that shows either sheet of available mail apps user has
    /// installed; otherwise, it opens Apple Mail app directly.
    fileprivate func openMailApp(_ isPresented: Binding<Bool>) -> some View {
        modifier(MailAppViewModifier(isPresented: isPresented))
    }
}

// MARK: - ViewModifier

private struct MailAppViewModifier: ViewModifier {
    private typealias L = Localized.MailApp
    @Environment(\.theme) private var theme
    @Dependency(\.openUrl) private var openUrl
    private let apps = MailApp.available
    @Binding var isPresented: Bool
    private var isSheetPresented: Binding<Bool> {
        .init(
            get: { isPresented && apps.count > 1 },
            set: { isPresented = $0 }
        )
    }

    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { isPresented in
                if isPresented, apps.count == 1 {
                    // Attempt to open the first one, which will be Apple's Mail.
                    //
                    // Even if user has deleted this app, it will show as available and tapping on
                    // it will prompt the user to restore it.
                    openUrl(apps[0].url)
                    self.isPresented = false
                }
            }
            .sheet(isPresented: isSheetPresented) {
                CustomBottomSheet(L.open) {
                    ForEach(apps) { app in
                        Button(app.name) {
                            openUrl(app.url)
                            isPresented = false
                        }
                        .foregroundColor(theme.tintColor)
                        .multilineTextAlignment(.center)
                    }

                    Button.cancel {
                        isPresented = false
                    }
                    .buttonStyle(.secondary)
                    .padding(.allButBottom, .defaultSpacing)
                    .padding(.bottom, .onePixel)
                }
            }
    }
}
