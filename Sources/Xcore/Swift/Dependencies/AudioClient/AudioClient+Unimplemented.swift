//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct UnimplementedAudioClient: AudioClient {
    public func play(_ file: AudioFile) {
        XCTFail("\(Self.self).play is unimplemented")
    }
}

// MARK: - Dot Syntax Support

extension AudioClient where Self == UnimplementedAudioClient {
    /// Returns unimplemented variant of `AudioClient`.
    public static var unimplemented: Self { .init() }
}
