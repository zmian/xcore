//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class ImageRepresentableTests: TestCase {
    func testCodable() throws {
        let values: [ImageSourceType] = [
            .url("arrow"),
            .url("http://example.com/avatar.png"),
            .uiImage(UIImage.rect)
        ]

        let encoder = JSONEncoder()
        let data = try encoder.encode(values)
        let encodedValue = String(data: data, encoding: .utf8)!
        let expectedEncodedValue = "[\"arrow\",\"http:\\/\\/example.com\\/avatar.png\",\"iVBORw0KGgoAAAANSUhEUgAAAAMAAAADCAYAAABWKLW\\/AAAAAXNSR0IArs4c6QAAAHhlWElmTU0AKgAAAAgABAEaAAUAAAABAAAAPgEbAAUAAAABAAAARgEoAAMAAAABAAIAAIdpAAQAAAABAAAATgAAAAAAAADYAAAAAQAAANgAAAABAAOgAQADAAAAAQABAACgAgAEAAAAAQAAAAOgAwAEAAAAAQAAAAMAAAAA2lJiigAAAAlwSFlzAAAhOAAAITgBRZYxYAAAABxpRE9UAAAAAgAAAAAAAAACAAAAKAAAAAIAAAABAAAARxQf8tcAAAATSURBVBgZYvjPwPAfhhlgDBANAAAA\\/\\/9N3En5AAAADElEQVRj+M\\/A8B+GAV3XEe9euoaRAAAAAElFTkSuQmCC\"]"
        XCTAssertEqual(encodedValue, expectedEncodedValue)

        let decoder = JSONDecoder()
        let decodedValues = try decoder.decode([ImageSourceType].self, from: data)

        for (index, value) in values.enumerated() {
            switch value {
                case .url:
                    XCTAssertEqual(value, decodedValues[index])
                case let .uiImage(expectedImage):
                    if case let .uiImage(decodedImage) = decodedValues[index] {
                        // Double converting it to PNG so the conversion passes matches.
                        let expectedImageData = UIImage(data: expectedImage.pngData()!)!.pngData()!
                        let decodedImageData = decodedImage.pngData()!
                        XCTAssertEqual(decodedImageData, expectedImageData)
                    } else {
                        XCTAssert(false, "Failed to convert UIImage to Data.")
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
