//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct NoopAudioClient: AudioClient {
    public func play(_ file: AudioFile) {}
}

// MARK: - Dot Syntax Support

extension AudioClient where Self == NoopAudioClient {
    /// Returns noop variant of `AudioClient`.
    public static var noop: Self { .init() }
}
