//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public struct BackgroundImageTransform: ImageTransform {
    private let color: UIColor
    private let preferredSize: CGSize
    private let alignment: UIControl.ContentHorizontalAlignment

    public var id: String {
        "\(transformName)-color:(\(color.hex))-preferredSize:(\(preferredSize.width)x\(preferredSize.height))-alignment:(\(alignment))"
    }

    public init(color: UIColor, preferredSize: CGSize, alignment: UIControl.ContentHorizontalAlignment = .center) {
        self.color = color
        self.preferredSize = preferredSize
        self.alignment = alignment
    }

    public func transform(_ image: UIImage, source: ImageRepresentable) -> UIImage {
        let size = image.size
        let finalSize = CGSize(
            width: max(size.width, preferredSize.width),
            height: max(size.height, preferredSize.width)
        )

        let rect = CGRect(origin: .zero, size: finalSize)
        var drawingPosition = CGPoint(x: 0, y: (finalSize.height - size.height) / 2)

        switch alignment {
            case .center, .fill:
                drawingPosition.x = (finalSize.width - size.width) / 2
            case .left, .leading:
                break
            case .right, .trailing:
                drawingPosition.x = finalSize.width - size.width
            @unknown default:
                fatalError(because: .unknownCaseDetected(alignment))
        }

        return UIGraphicsImageRenderer(bounds: rect).image { rendererContext in
            let context = rendererContext.cgContext
            context.setFillColor(color.cgColor)
            context.fill(rect)
            image.draw(at: drawingPosition)
        }
    }
}
