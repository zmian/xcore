//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
@_implementationOnly import AVKit

public final class LiveAudioClient: AudioClient {
    private var audioPlayer: AVAudioPlayer?

    public func play(_ file: AudioFile) {
        guard
            let url = file.bundle.url(filename: file.name),
            let audioPlayer = try? AVAudioPlayer(contentsOf: url)
        else {
            return
        }

        try? AVAudioSession.sharedInstance().setCategory(file.category)
        self.audioPlayer = audioPlayer
        audioPlayer.play()
    }
}

// MARK: - Dot Syntax Support

extension AudioClient where Self == LiveAudioClient {
    /// Returns live variant of `AudioClient`.
    static var live: Self { .init() }
}
