//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct ShareSheetView: View {
    @State private var isShowingShareSheet = false

    var body: some View {
        List {
            Button {
                isShowingShareSheet = true
            } label: {
                Label("Share License Agreement", systemImage: .squareAndArrowUp)
            }
        }
        .shareSheet(isPresented: $isShowingShareSheet, items: ["License Agreement..."]) {
            print("onComplete", $0)
        } onDismiss: {
            print("onDismiss")
        }
    }
}

struct ShareSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ShareSheetView()
            .embedInNavigation()
    }
}
