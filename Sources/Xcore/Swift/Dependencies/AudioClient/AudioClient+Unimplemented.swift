//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

#if DEBUG
import Foundation

public struct UnimplementedAudioClient: AudioClient {
    public func play(_ file: AudioFile) {
        internal_XCTFail("\(Self.self).play is unimplemented")
    }
}

// MARK: - Dot Syntax Support

extension AudioClient where Self == UnimplementedAudioClient {
    /// Returns unimplemented variant of `AudioClient`.
    public static var unimplemented: Self { .init() }
}
#endif
