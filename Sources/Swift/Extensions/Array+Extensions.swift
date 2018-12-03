//
// Array+Extensions.swift
//
// Copyright © 2014 Zeeshan Mian
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
    /// - Parameter size: Length
    /// - Returns: Random subarray of length n.
    public func randomElements(_ size: Int = 1) -> Array {
        if size >= count {
            return self
        }

        let index = Int(arc4random_uniform(UInt32(count - size)))
        return Array(self[index..<(size + index)])
    }

    /// Returns a random element from `self`.
    public func randomElement() -> Element {
        let randomIndex = Int(arc4random()) % count
        return self[randomIndex]
    }

    /// Split array by chunks of given size.
    ///
    /// ```swift
    /// let arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    /// let chunks = arr.splitBy(5)
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
        for element in self.reversed() {
            if let element = element as? T {
                return element
            }
        }

        return nil
    }
}

extension Array where Element: Equatable {
    /// Remove element by value.
    ///
    /// - Returns: true if removed; false otherwise
    @discardableResult
    public mutating func remove(_ element: Element) -> Bool {
        for (index, elementToCompare) in enumerated() where element == elementToCompare {
            remove(at: index)
            return true
        }
        return false
    }

    /// Remove elements by value.
    public mutating func remove(_ elements: [Element]) {
        elements.forEach { remove($0) }
    }

    /// Move an element in `self` to a specific index.
    ///
    /// - Parameters:
    ///   - element: The element in `self` to move.
    ///   - index: An index locating the new location of the element in `self`.
    /// - Returns: `true` if moved; otherwise, `false`.
    @discardableResult
    public mutating func move(_ element: Element, to index: Int) -> Bool {
        guard remove(element) else {
            return false
        }

        insert(element, at: index)
        return true
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
                let first = preferredOrder.index(of: a),
                let second = preferredOrder.index(of: b)
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
                let first = preferredOrder.index(of: a),
                let second = preferredOrder.index(of: b)
            else {
                return false
            }

            return first < second
        }
    }
}

extension Array {
    /// Returns an array by removing all the elements that satisfy the given predicate.
    ///
    /// Use this method to remove every element in a collection that meets
    /// particular criteria. This example removes all the odd values from an
    /// array of numbers:
    ///
    ///     var numbers = [5, 6, 7, 8, 9, 10, 11]
    ///     let removedNumbers = numbers.removingAll(where: { $0 % 2 == 1 })
    ///
    ///     // numbers == [6, 8, 10]
    ///     // removedNumbers == [5, 7, 9, 11]
    ///
    /// - Parameter predicate: A closure that takes an element of the
    ///   sequence as its argument and returns a Boolean value indicating
    ///   whether the element should be removed from the collection.
    public mutating func removingAll(where predicate: (Element) throws -> Bool) rethrows -> [Element] {
        let result = try filter(predicate)
        try removeAll(where: predicate)
        return result
    }
}

extension Array where Element: RawRepresentable {
    /// Return an array containing all corresponding `rawValue`s of `self`.
    public var rawValues: [Element.RawValue] {
        return map { $0.rawValue }
    }
}
