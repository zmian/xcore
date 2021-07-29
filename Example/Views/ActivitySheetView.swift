//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct ActivitySheetView: View {
    @State private var isShowingActivitySheet = false

    var body: some View {
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
    }
}

struct ActivitySheetView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitySheetView()
            .embedInNavigation()
    }
}
