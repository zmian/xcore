//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct ImageView: UIViewRepresentable {
    private let imageRepresentable: ImageRepresentable
    private var contentMode: UIView.ContentMode

    init(_ image: ImageRepresentable, contentMode: ContentMode = .fit) {
        self.imageRepresentable = image

        switch contentMode {
            case .fill:
                self.contentMode = .scaleAspectFill
            case .fit:
                self.contentMode = .scaleAspectFit
        }
    }

    func makeUIView(context: Context) -> WrapperView {
        WrapperView().apply(configure)
    }

    func updateUIView(_ uiView: WrapperView, context: Context) {
        configure(uiView)
    }

    private func configure(_ uiView: WrapperView) {
        uiView.imageView.apply {
            $0.setImage(imageRepresentable)
            $0.contentMode = contentMode
        }
    }
}

// MARK: - Wrapper View

extension ImageView {
    final class WrapperView: XCView {
        let imageView = UIImageView().apply {
            $0.enableSmoothScaling()
        }

        override func commonInit() {
            addSubview(imageView)

            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
    }
}
