//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct ActivitySheetView: View {
    @State private var isShowingActivitySheet = false

    var body: some View {
        if #available(iOS 16.0, *) {
            List {
                ShareLink("Share License Agreement", item: "License Agreement...")
                    .buttonStyle(.capsule)

                ShareLink(item: "License Agreement...") {
                    Label("Share License Agreement", systemImage: .doc)
                }
            }
        } else {
            body15
        }
    }

    private var body15: some View {
        List {
            Button {
                isShowingActivitySheet = true
            } label: {
                Label("Share License Agreement", systemImage: .squareAndArrowUp)
            }
        }
        .activitySheet(isPresented: $isShowingActivitySheet, items: ["License Agreement..."]) {
            print("onComplete", $0)
        } onDismiss: {
            print("onDismiss")
        }
        .onAppear {
            withDelay(2) {
                isShowingActivitySheet = false
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ActivitySheetView()
        .embedInNavigation()
}
