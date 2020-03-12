//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public protocol ImageRepresentablePlugin {
    /// A unique id for the image plugin.
    var id: String { get }
}

extension ImageRepresentablePlugin {
    public var id: String {
        name(of: self)
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
