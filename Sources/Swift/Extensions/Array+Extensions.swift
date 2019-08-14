//
// Array+Extensions.swift
//
// Copyright © 2014 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

extension Array {
    /// Returns a random subarray of given length.
    ///
    /// - Parameter count: Number of random elements to return.
    /// - Returns: Random subarray of length n.
    public func randomElements(count: Int = 1) -> Array {
        let size = count
        let count = self.count

        if size >= count {
            return shuffled()
        }

        let index = Int.random(in: 0..<(count - size))
        return self[index..<(size + index)].shuffled()
    }

    /// Returns a random element from `self`.
    public func randomElement() -> Element {
        let randomIndex = Int(arc4random()) % count
        return self[randomIndex]
    }

    /// Split array by chunks of given size.
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    /// let chunks = array.splitBy(5)
    /// print(chunks) // [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10], [11, 12]]
    /// ```
    /// - seealso: https://gist.github.com/ericdke/fa262bdece59ff786fcb
    public func splitBy(_ subSize: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: subSize).map { startIndex in
            let endIndex = index(startIndex, offsetBy: subSize, limitedBy: count) ?? startIndex + (count - startIndex)
            return Array(self[startIndex..<endIndex])
        }
    }

    public func firstElement<T>(type: T.Type) -> T? {
        for element in self {
            if let element = element as? T {
                return element
            }
        }

        return nil
    }

    public func lastElement<T>(type: T.Type) -> T? {
        for element in reversed() {
            if let element = element as? T {
                return element
            }
        }

        return nil
    }
}

extension Array where Element: NSObjectProtocol {
    /// Returns the first index where the specified value appears in the
    /// collection.
    ///
    /// After using `firstIndex(of:)` to find the position of a particular element in
    /// a collection, you can use it to access the element by subscripting. This
    /// example shows how you can pop one of the view controller from the `UINavigationController`.
    ///
    /// ```swift
    /// let navigationController = UINavigationController()
    /// if let index = navigationController.viewControllers.firstIndex(of: SearchViewController.self) {
    ///     navigationController.popToViewController(at: index, animated: true)
    /// }
    /// ```
    ///
    /// - Parameter elementType: An element type to search for in the collection.
    /// - Returns: The first index where `element` is found. If `element` is not
    ///   found in the collection, returns `nil`.
    public func firstIndex(of elementType: Element.Type) -> Int? {
        return firstIndex { $0.isKind(of: elementType) }
    }

    /// Returns the last index where the specified value appears in the
    /// collection.
    ///
    /// After using `lastIndex(of:)` to find the position of a particular element in
    /// a collection, you can use it to access the element by subscripting. This
    /// example shows how you can pop one of the view controller from the `UINavigationController`.
    ///
    /// ```swift
    /// let navigationController = UINavigationController()
    /// if let index = navigationController.viewControllers.lastIndex(of: SearchViewController.self) {
    ///     navigationController.popToViewController(at: index, animated: true)
    /// }
    /// ```
    ///
    /// - Parameter elementType: An element type to search for in the collection.
    /// - Returns: The last index where `element` is found. If `element` is not
    ///   found in the collection, returns `nil`.
    public func lastIndex(of elementType: Element.Type) -> Int? {
        return lastIndex { $0.isKind(of: elementType) }
    }

    /// Returns a boolean value indicating whether the sequence contains an element
    /// that exists in the given parameter.
    ///
    /// ```swift
    /// let navigationController = UINavigationController()
    /// if navigationController.viewControllers.contains(any: [SearchViewController.self, HomeViewController.self]) {
    ///     _ = navigationController?.popToRootViewController(animated: true)
    /// }
    /// ```
    ///
    /// - Parameter any: An array of element types to search for in the collection.
    /// - Returns: `true` if the sequence contains an element; otherwise, `false`.
    public func contains(any elementTypes: [Element.Type]) -> Bool {
        for element in self {
            if elementTypes.contains(where: { element.isKind(of: $0) }) {
                return true
            }
        }

        return false
    }
}

extension Array where Element: Equatable {
    /// Sorts the collection in place, using the given preferred order as the comparison between elements.
    ///
    /// ```swift
    /// let preferredOrder = ["Z", "A", "B", "C", "D"]
    /// var alphabets = ["D", "C", "B", "A", "Z", "W"]
    /// alphabets.sort(by: preferredOrder)
    /// print(alphabets)
    /// // Prints ["Z", "A", "B", "C", "D", "W"]
    /// ```
    ///
    /// - Parameter preferredOrder: The ordered elements, which will be used to sort the sequence’s elements.
    public mutating func sort(by preferredOrder: [Element]) {
        return sort { (a, b) -> Bool in
            guard
                let first = preferredOrder.firstIndex(of: a),
                let second = preferredOrder.firstIndex(of: b)
            else {
                return false
            }

            return first < second
        }
    }

    // Credit: https://stackoverflow.com/a/51683055

    /// Returns the elements of the sequence, sorted using the given preferred order as the
    /// comparison between elements.
    ///
    /// ```swift
    /// let preferredOrder = ["Z", "A", "B", "C", "D"]
    /// let alphabets = ["D", "C", "B", "A", "Z", "W"]
    /// let sorted = alphabets.sorted(by: preferredOrder)
    /// print(sorted)
    /// // Prints ["Z", "A", "B", "C", "D", "W"]
    /// ```
    ///
    /// - Parameter preferredOrder: The ordered elements, which will be used to sort the sequence’s elements.
    /// - Returns: A sorted array of the sequence’s elements.
    public func sorted(by preferredOrder: [Element]) -> [Element] {
        return sorted { (a, b) -> Bool in
            guard
                let first = preferredOrder.firstIndex(of: a),
                let second = preferredOrder.firstIndex(of: b)
            else {
                return false
            }

            return first < second
        }
    }
}

extension Array where Element: RawRepresentable {
    /// Return an array containing all corresponding `rawValue`s of `self`.
    public var rawValues: [Element.RawValue] {
        return map { $0.rawValue }
    }
}

extension Array where Element == String? {
    /// Returns a new string by concatenating the elements of the sequence, adding
    /// the given separator between each element.
    ///
    /// The following example shows how an array of strings can be joined to a
    /// single, comma-separated string:
    ///
    /// ```swift
    /// let cast = ["Vivien", nil, "Kim", "Karl"]
    /// let list = cast.joined(separator: ", ")
    /// print(list)
    /// // Prints "Vivien, Kim, Karl"
    /// ```
    ///
    /// - Parameter separator: A string to insert between each of the elements in
    ///                        this sequence. The default value is an empty string.
    /// - Returns: A single, concatenated string.
    public func joined(separator: String = "") -> String {
        return lazy.compactMap { $0 }.filter { !$0.isBlank }.joined(separator: separator)
    }
}

extension Array {
    func binarySearch<T>(target: T, transform: (Element) -> T, _ comparison: (T, T) -> ComparisonResult) -> Int? {
        var localRange = 0..<count

        while localRange.startIndex < localRange.endIndex {
            // Find the middle point in the array within the given range
            let midIndex: Int = localRange.startIndex + (localRange.endIndex - localRange.startIndex) / 2
            let comparableObject = transform(self[midIndex])
            let result = comparison(comparableObject, target)
            switch result {
                case .orderedSame:
                    // If we found our search key, return the index
                    return midIndex
                case .orderedAscending:
                    // If the middle value is less than the target, look at the right half
                    localRange = (midIndex + 1)..<localRange.endIndex
                case .orderedDescending:
                    // If the midle value is greater than the target, look at the left half
                    localRange = localRange.startIndex..<midIndex
            }
        }
        return nil
    }
}
