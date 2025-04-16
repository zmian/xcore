//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct QRCodeImageView: View {
    @Dependency(\.qrCode) private var qrCode
    @Environment(\.theme) private var theme
    @State private var qrCodeImage: UIImage?
    private let qrCodeSource: String
    private let centerLogo: ImageRepresentable?

    init(_ qrCodeSource: String, centerLogo: ImageRepresentable? = nil) {
        self.qrCodeSource = qrCodeSource
        self.centerLogo = centerLogo
    }

    var body: some View {
        ZStack {
            Image(uiImage: qrCodeImage ?? UIImage())
                .resizable()
                .interpolation(.none)
                .scaledToFit()

            VStack {
                if let centerLogo {
                    ImageView(centerLogo)
                        .clipShape(.circle)
                        .foregroundStyle(.clear)
                } else {
                    Image(system: .app)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(theme.tintColor)
                }
            }
            .frame(32)
            .padding(.s3)
            .background(theme.backgroundColor, in: .circle)
        }
        .task(id: qrCodeSource) {
            do {
                qrCodeImage = try qrCode
                    .generate(qrCodeSource)
                    .withRenderingMode(.alwaysTemplate)
            } catch {
                reportIssue(error)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        QRCodeImageView("hello world")
        QRCodeImageView("hello world", centerLogo: Samples.avatarUrl)
            .foregroundStyle(.indigo.gradient)
    }
}
