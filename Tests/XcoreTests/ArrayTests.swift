//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import UIKit
@testable import Xcore

struct ArrayTests {
    @Test
    func sortByPreferredOrder() {
        let preferredOrder = ["Z", "A", "B", "C", "D"]
        var alphabets = ["D", "C", "B", "A", "Z", "W"]
        alphabets.sort(by: preferredOrder)
        let expected = ["Z", "A", "B", "C", "D", "W"]
        #expect(alphabets == expected)
    }

    @Test
    func sortedByPreferredOrder() {
        let preferredOrder = ["Z", "A", "B", "C", "D"]
        let alphabets = ["D", "C", "B", "A", "Z", "W"]
        let sorted = alphabets.sorted(by: preferredOrder)
        let expected = ["Z", "A", "B", "C", "D", "W"]
        #expect(sorted == expected)
        #expect(sorted != alphabets)
    }

    @Test
    func rawValues() {
        let values = [
            SomeType(rawValue: "Hello"),
            SomeType(rawValue: "World"),
            SomeType(rawValue: "!")
        ]

        let expectedRawValues = [
            "Hello",
            "World",
            "!"
        ]

        #expect(values.rawValues == expectedRawValues)
    }

    @MainActor
    @Test
    func contains() {
        let instances = [UIView(), UIImageView()]
        let result = instances.contains(any: [UIImageView.self, UILabel.self])
        #expect(result == true)
        #expect(instances.contains(any: [UILabel.self]) == false)
    }

    @Test
    func randomElement() {
        let values = [132, 2432, 35435, 455]
        let randomValue = values.randomElement()
        #expect(values.contains(randomValue))
    }

    @Test
    func randomElements() {
        let values = [132, 2432, 35435, 455]
        let randomValue1 = values.randomElements(length: 17)
        let randomValue2 = values.randomElements(length: 2)

        #expect(randomValue1.count == values.count)
        #expect(randomValue2.count == 2)
    }

    @Test
    func emptyRandomElements() {
        let values: [Int] = []
        let randomValue1 = values.randomElements(length: 17)
        let randomValue2 = values.randomElements(length: 2)

        #expect(randomValue1.count == values.count)
        #expect(randomValue2.count == 0)
    }

    @Test
    func firstElement() {
        let value: [Any] = ["232", 12, 2, 11.0, "hello"]
        let resultString = value.firstElement(type: String.self)
        let resultInt = value.firstElement(type: Int.self)
        let resultDouble = value.firstElement(type: Double.self)
        let resultCGFloat = value.firstElement(type: CGFloat.self)
        #expect(resultString == "232")
        #expect(resultInt == 12)
        #expect(resultDouble == 11)
        #expect(resultCGFloat == nil)
    }

    @Test
    func lastElement() {
        let value: [Any] = ["232", 12, 2, 11.0, "hello"]
        let resultString = value.lastElement(type: String.self)
        let resultInt = value.lastElement(type: Int.self)
        let resultDouble = value.lastElement(type: Double.self)
        let resultCGFloat = value.lastElement(type: CGFloat.self)
        #expect(resultString == "hello")
        #expect(resultInt == 2)
        #expect(resultDouble == 11)
        #expect(resultCGFloat == nil)
    }

    @MainActor
    @Test
    func firstIndex() {
        let tag1View = UIView().apply { $0.tag = 1 }
        let tag2View = UIView().apply { $0.tag = 2 }

        let tag1Label = UILabel().apply { $0.tag = 1 }
        let tag2Label = UILabel().apply { $0.tag = 2 }

        let value: [NSObject] = [NSString("232"), tag1View, tag2View, tag1Label, tag2Label, NSString("hello")]
        let resultNSString = value.firstIndex(of: NSString.self)
        let resultUIView = value.firstIndex(of: UIView.self)
        let resultUILabel = value.firstIndex(of: UILabel.self)
        let resultUIViewController = value.firstIndex(of: UIViewController.self)
        #expect(resultNSString == 0)
        #expect(resultUIView == 1)
        #expect(resultUILabel == 3)
        #expect(resultUIViewController == nil)
    }

    @MainActor
    @Test
    func lastIndex() {
        let tag1View = UIView().apply { $0.tag = 1 }
        let tag2View = UIView().apply { $0.tag = 2 }

        let tag1Label = UILabel().apply { $0.tag = 1 }
        let tag2Label = UILabel().apply { $0.tag = 2 }

        let value: [NSObject] = [NSString("232"), tag1View, tag2View, tag1Label, tag2Label, NSString("hello")]
        let resultNSString = value.lastIndex(of: NSString.self)
        let resultUIView = value.lastIndex(of: UIView.self)
        let resultUILabel = value.lastIndex(of: UILabel.self)
        let resultUIViewController = value.lastIndex(of: UIViewController.self)
        #expect(resultNSString == 5)
        #expect(resultUIView == 4) // UILabel is subclass of UIView
        #expect(resultUILabel == 4)
        #expect(resultUIViewController == nil)
    }

    @MainActor
    @Test
    func joined() {
        let label1 = UILabel().apply {
            $0.text = "Hello"
        }

        let label2 = UILabel()

        let label3 = UILabel().apply {
            $0.text = " "
        }

        let button = UIButton().apply {
            $0.setTitle("World!", for: .normal)
        }

        let value1 = [label1.text, label2.text, label3.text, button.title(for: .normal)].joined(separator: ", ")
        #expect(value1 == "Hello, World!")

        let value2 = [label1.text, label2.text, label3.text, button.title(for: .normal)].joined()
        #expect(value2 == "HelloWorld!")
    }
}

private struct SomeType: RawRepresentable {
    let rawValue: String
}
