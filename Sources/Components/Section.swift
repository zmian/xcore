//
// Section.swift
//
// Copyright © 2016 Zeeshan Mian
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

// Adopted: https://medium.com/swift-programming/ce22d76f120c

public struct ArrayGenerator<Element>: GeneratorType {
    private let array: [Element]
    private var currentIndex = 0

    public init(_ array: [Element]) {
        self.array = array
    }

    public mutating func next() -> Element? {
        let element = array.at(currentIndex)
        currentIndex += 1
        return element
    }
}

public struct Section<Element>: RangeReplaceableCollectionType, MutableSliceable, ArrayLiteralConvertible {
    public var title: String?
    public var detail: String?
    public var elements: [Element]

    public init() {
        self.title    = nil
        self.detail   = nil
        self.elements = []
    }

    public init(arrayLiteral elements: Element...) {
        self.elements = elements
    }

    public init(title: String? = nil, detail: String? = nil, elements: [Element]) {
        self.title    = title
        self.detail   = detail
        self.elements = elements
    }

    public let startIndex = 0
    public var endIndex: Int {
        return elements.count
    }

    public subscript(index: Int) -> Element {
        get { return elements[index] }
        set { elements[index] = newValue }
    }

    public func generate() -> ArrayGenerator<Element> {
        return ArrayGenerator(elements)
    }

    public mutating func replaceRange<C: CollectionType where C.Generator.Element == Element>(subRange: Range<Int>, with newElements: C) {
        elements.replaceRange(subRange, with: newElements)
    }
}

public extension Array where Element: MutableCollectionType, Element.Index == Int {
    /// A convenience subscript to return the element at the specified index path.
    ///
    /// - parameter indexPath: The index path for the element.
    ///
    /// - returns: The element at the specified index path iff it is within bounds, otherwise fatalError.
    public subscript(indexPath: NSIndexPath) -> Element.Generator.Element {
        get { return self[indexPath.section][indexPath.item] }
        set { self[indexPath.section][indexPath.item] = newValue }
    }
}

public extension Array where Element: RangeReplaceableCollectionType, Element.Index == Int {
    /// Remove the element at the specified index path.
    ///
    /// - parameter indexPath: The index path for the element to remove.
    ///
    /// - returns: The removed element.
    public mutating func removeAt(indexPath: NSIndexPath) -> Element.Generator.Element {
        return self[indexPath.section].removeAtIndex(indexPath.item)
    }

    /// Insert newElement at the specified index path.
    ///
    /// - parameter newElement: The new element to insert.
    /// - parameter indexPath:  The index path to insert the element at.
    public mutating func insert(newElement: Element.Generator.Element, atIndexPath: NSIndexPath) {
        self[atIndexPath.section].insert(newElement, atIndex: atIndexPath.item)
    }

    /// Move an element at a specific location in the `self` to another location.
    ///
    /// - parameter fromIndexPath: An index path locating the element to be moved in `self`.
    /// - parameter toIndexPath:   An index path locating the element in `self` that is the destination of the move.
    ///
    /// - returns: The moved element.
    public mutating func moveElement(fromIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) -> Element.Generator.Element {
        let elementToMove = removeAt(fromIndexPath)
        insert(elementToMove, atIndexPath: toIndexPath)
        return elementToMove
    }
}
