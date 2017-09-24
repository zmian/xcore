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
    /// - parameter size: Length
    /// - returns:        Random subarray of length n.
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

    public func get<T>(_ type: T.Type) -> T? {
        for element in self {
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
    /// - returns: true if removed; false otherwise
    @discardableResult
    public mutating func remove(_ element: Element) -> Bool {
        for (index, elementToCompare) in enumerated() {
            if element == elementToCompare {
                remove(at: index)
                return true
            }
        }
        return false
    }

    /// Remove elements by value.
    public mutating func remove(_ elements: [Element]) {
        elements.forEach { remove($0) }
    }

    /// Move an element in `self` to a specific index.
    ///
    /// - parameter element: The element in `self` to move.
    /// - parameter to:      An index locating the new location of the element in `self`.
    ///
    /// - returns: true if moved; false otherwise.
    @discardableResult
    public mutating func move(_ element: Element, to index: Int) -> Bool {
        guard remove(element) else { return false }
        insert(element, at: index)
        return true
    }
}

extension Array where Element: NSObjectProtocol {
    /// Returns the first index where the specified value appears in the
    /// collection.
    ///
    /// After using `index(of:)` to find the position of a particular element in
    /// a collection, you can use it to access the element by subscripting. This
    /// example shows how you can modify one of the names in an array of
    /// students.
    ///
    /// ```swift
    /// let navigationController = UINavigationController()
    /// if let index = navigationController.viewControllers.index(of: SearchViewController.self) {
    ///     navigationController.popToViewController(at: index, animated: true)
    /// }
    /// ```
    ///
    /// - parameter element: An element to search for in the collection.
    /// - returns: The first index where `element` is found. If `element` is not
    ///   found in the collection, returns `nil`.
    public func index(of elementType: Element.Type) -> Int? {
        return index(where: { $0.isKind(of: elementType) })
    }
}
