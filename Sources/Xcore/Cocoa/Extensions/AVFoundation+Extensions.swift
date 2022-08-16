//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import AVFoundation

// MARK: - AVPlayerItem

extension AVPlayerItem {
    /// Creates an ``AVPlayerItem`` with local resource referenced file name.
    ///
    /// - Parameters:
    ///   - filename: The local file name.
    ///   - bundle: The bundle containing the specified file name. If you specify
    ///     `nil`, this method looks in the main bundle of the current application.
    /// - Returns: An instance of AVPlayerItem.
    public convenience init?(filename: String, bundle: Bundle? = nil) {
        guard let url = (bundle ?? Bundle.main).url(filename: filename) else {
            return nil
        }

        self.init(url: url)
    }

    /// Automatically detect and load the asset from local or a remote url.
    public convenience init?(string: String) {
        guard let url = URL(string: string), url.host != nil else {
            self.init(filename: string)
            return
        }

        self.init(url: url)
    }
}

// MARK: - AVAsset

extension AVAsset {
    /// Creates an ``AVAsset`` with local resource referenced file name.
    ///
    /// - Parameters:
    ///   - filename: The local file name.
    ///   - bundle: The bundle containing the specified file name. If you specify
    ///     `nil`, this method looks in the main bundle of the current application.
    /// - Returns: An instance of AVAsset.
    public convenience init?(filename: String, bundle: Bundle? = nil) {
        guard let url = (bundle ?? Bundle.main).url(filename: filename) else {
            return nil
        }

        self.init(url: url)
    }

    /// Automatically detect and load the asset from local or a remote url.
    public convenience init?(string: String) {
        guard let url = URL(string: string), url.host != nil else {
            self.init(filename: string)
            return
        }

        self.init(url: url)
    }
}
