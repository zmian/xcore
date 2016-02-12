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

// Credit: https://medium.com/swift-programming/ce22d76f120c

public struct ArrayGenerator<Element>: GeneratorType {
    public let array: [Element]
    public var currentIndex = 0

    public init(_ array: [Element]) {
        self.array = array
    }

    public mutating func next() -> Element? {
        let element = array.at(currentIndex)
        currentIndex += 1
        return element
    }
}

public struct Section<Element>: CollectionType {
    public var title: String?
    public var detail: String?
    public var items: [Element]

    public init(title: String? = nil, detail: String? = nil, items: [Element]) {
        self.title  = title
        self.detail = detail
        self.items  = items
    }

    public let startIndex = 0
    public var endIndex: Int {
        return items.count
    }

    public subscript(index: Int) -> Element {
        return items[index]
    }

    public func generate() -> ArrayGenerator<Element> {
        return ArrayGenerator(items)
    }
}
