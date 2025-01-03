//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import UIKit
@testable import Xcore

struct ImageRepresentableTests {
    @Test
    func codable() throws {
        let values: [ImageSourceType] = [
            .url("arrow"),
            .url("http://example.com/avatar.png"),
            .uiImage(UIImage.rect)
        ]

        let encoder = JSONEncoder()
        let data = try encoder.encode(values)
        let encodedValue = String(data: data, encoding: .utf8)!
        let expectedEncodedValue = "[\"arrow\",\"http:\\/\\/example.com\\/avatar.png\",\"iVBORw0KGgoAAAANSUhEUgAAAAMAAAADCAYAAABWKLW\\/AAAAAXNSR0IArs4c6QAAAIRlWElmTU0AKgAAAAgABQESAAMAAAABAAEAAAEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAIdpAAQAAAABAAAAWgAAAAAAAADYAAAAAQAAANgAAAABAAOgAQADAAAAAQABAACgAgAEAAAAAQAAAAOgAwAEAAAAAQAAAAMAAAAAGuc7vgAAAAlwSFlzAAAhOAAAITgBRZYxYAAAABxpRE9UAAAAAgAAAAAAAAACAAAAKAAAAAIAAAABAAAARxQf8tcAAAATSURBVBgZYvjPwPAfhhlgDBANAAAA\\/\\/9N3En5AAAADElEQVRj+M\\/A8B+GAV3XEe9euoaRAAAAAElFTkSuQmCC\"]"
        #expect(encodedValue == expectedEncodedValue)

        let decoder = JSONDecoder()
        let decodedValues = try decoder.decode([ImageSourceType].self, from: data)

        for (index, value) in values.enumerated() {
            switch value {
                case .url:
                    #expect(value == decodedValues[index])
                case let .uiImage(expectedImage):
                    if case let .uiImage(decodedImage) = decodedValues[index] {
                        // Double converting it to PNG so the conversion passes matches.
                        let expectedImageData = UIImage(data: expectedImage.pngData()!)!.pngData()!
                        let decodedImageData = decodedImage.pngData()!
                        #expect(decodedImageData == expectedImageData)
                    } else {
                        Issue.record("Failed to convert UIImage to Data.")
                    }
            }
        }
    }
}

// MARK: - Helpers

extension UIImage {
    fileprivate static var rect: UIImage {
        let color = UIColor.red.cgColor
        let rect = CGRect(.init(1))

        let image = UIGraphicsImageRenderer(bounds: rect).image { rendererContext in
            let context = rendererContext.cgContext
            context.setFillColor(color)
            context.fill(rect)
        }

        return .init(
            cgImage: image.cgImage!,
            scale: image.scale,
            orientation: image.imageOrientation
        )
    }
}
