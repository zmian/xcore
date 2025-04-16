//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct QRCodeView: View {
    @State private var string = ""

    var body: some View {
        VStack {
            QRCodeImageView(string, centerLogo: Samples.avatarUrl)
                .foregroundStyle(.indigo.gradient)
                .alignment(vertical: .center)

            DynamicTextField("QR Code Source", value: $string, configuration: .plain)
                .padding()
                .background(.quinary, in: .rect(cornerRadius: AppConstants.cornerRadius))

            Spacer()
        }
        .padding()
        .navigationTitle("QR Code Generator")
    }
}

// MARK: - Preview

#Preview {
    QRCodeView()
        .embedInNavigation()
}
