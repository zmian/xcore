//
// ImageRepresentablePlugin.swift
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

import Foundation

public protocol ImageRepresentablePlugin {
    /// A unique id for the image plugin.
    var id: String { get }
}

extension ImageRepresentablePlugin {
    public var id: String {
        return name(of: self)
    }
}

// MARK: - ImageRepresentable

extension ImageRepresentable {
    /// Adds a plugin to the end of the collection.
    ///
    /// - Parameter plugin: The plugin to append to the collection.
    /// - Returns: An `ImageRepresentable` instance with given plugin.
    public func append(_ plugin: ImageRepresentablePlugin) -> ImageRepresentable {
        var pluginImage = self as? PluginImage ?? PluginImage(self, plugins: [])
        pluginImage.add(plugin)
        return pluginImage
    }

    /// Returns the last plugin of given type `T`.
    public func plugin<T>() -> T? {
        guard let pluginImage = self as? PluginImage else {
            return nil
        }

        return pluginImage.last { $0 is T } as? T
    }
}
