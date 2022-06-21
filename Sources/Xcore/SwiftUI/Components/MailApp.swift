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

// MARK: - View

extension View {
    /// A view modifier that shows either sheet of available mail apps user has
    /// installed; otherwise, it opens Apple Mail app directly.
    func openMailApp(_ isPresented: Binding<Bool>) -> some View {
        modifier(MailAppViewModifier(isPresented: isPresented))
    }
}

// MARK: - ViewModifier

private struct MailAppViewModifier: ViewModifier {
    private typealias L = Localized.MailApp
    @Environment(\.theme) private var theme
    @Dependency(\.openUrl) var openUrl
    private let apps = MailApp.available
    @Binding var isPresented: Bool
    private var sheetPresented: Binding<Bool> {
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
            .popup(isPresented: sheetPresented, style: .sheet) {
                StandardPopupSheet(L.open) {
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
                    .padding(.defaultSpacing)
                }
            }
    }
}
