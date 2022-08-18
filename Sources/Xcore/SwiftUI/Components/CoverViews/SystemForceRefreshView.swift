//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A view that shows the loading screen and asks ``AppStatusClient`` to force
/// refresh.
public struct SystemForceRefreshView: View {
    @Environment(\.theme) private var theme
    @Dependency(\.appStatus) private var appStatus

    public init() {}

    public var body: some View {
        loadingView
            .onAppear {
                appStatus.systemForceRefresh()
            }
    }

    private var loadingView: some View {
        ProgressView()
            .frame(max: .infinity)
            .background(theme.backgroundColor)
    }
}
