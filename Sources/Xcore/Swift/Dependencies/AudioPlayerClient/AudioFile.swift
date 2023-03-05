//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import AVKit

/// A structure representing an audio file.
public struct AudioFile: Hashable, @unchecked Sendable {
    public let url: URL?
    public let category: AVAudioSession.Category

    /// Creates a reference to an audio file.
    ///
    /// - Parameters:
    ///   - url: The url of the audio file.
    ///   - category: The audio session category.
    public init(url: URL?, category: AVAudioSession.Category) {
        self.url = url
        self.category = category
    }

    /// Creates a reference to an audio file.
    ///
    /// - Parameters:
    ///   - name: The name of the audio file.
    ///   - bundle: The bundle where audio file is located.
    ///   - category: The audio session category.
    public init(name: String, bundle: Bundle = .main, category: AVAudioSession.Category) {
        self.init(
            url: bundle.url(filename: name),
            category: category
        )
    }
}
