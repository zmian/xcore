//
// PluginImage.swift
//
// Copyright © 2019 Xcore
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

import UIKit

struct PluginImage: ImageRepresentable {
    private let base: ImageRepresentable
    private var plugins: [ImageRepresentablePlugin]

    init() {
        self.base = ""
        self.plugins = []
    }

    init(_ base: ImageRepresentable, plugins: [ImageRepresentablePlugin]) {
        self.base = base
        self.plugins = plugins
    }

    /// Adds a new plugin at the end of the array.
    mutating func add(_ plugin: ImageRepresentablePlugin) {
        plugins.append(plugin)
    }

    /// Removes the given plugin.
    mutating func remove(_ plugin: ImageRepresentablePlugin) {
        let identifiers = plugins.map { $0.identifier }

        guard let index = identifiers.firstIndex(of: plugin.identifier) else {
            return
        }

        plugins.remove(at: index)
    }
}

// MARK: - ImageRepresentable

extension PluginImage {
    var imageSource: ImageSourceType {
        return base.imageSource
    }

    var bundle: Bundle? {
        return base.bundle
    }
}

// MARK: - Collection

extension PluginImage: MutableCollection, RangeReplaceableCollection, BidirectionalCollection {
    var startIndex: Int {
        return 0
    }

    var endIndex: Int {
        return plugins.count
    }

    subscript(index: Int) -> ImageRepresentablePlugin {
        get { return plugins[index] }
        set { plugins[index] = newValue }
    }

    /// Returns the position immediately after the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    /// `endIndex`.
    /// - Returns: The index value immediately after `i`.
    func index(after i: Int) -> Int {
        return i + 1
    }

    /// Returns the position immediately before the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be greater than
    ///   `startIndex`.
    /// - Returns: The index value immediately before `i`.
    func index(before i: Int) -> Int {
        return i - 1
    }

    func makeIterator() -> ArrayIterator<ImageRepresentablePlugin> {
        return ArrayIterator(plugins)
    }

    mutating func replaceSubrange<C: Collection>(_ subRange: Range<Int>, with newElements: C) where C.Iterator.Element == Element {
        plugins.replaceSubrange(subRange, with: newElements)
    }
}
