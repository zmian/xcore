//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import AVKit

extension AudioPlayerClient {
    /// Returns live variant of `AudioPlayerClient`.
    public static var live: Self {
        let client = LiveAudioClient()

        return .init { file in
            client.play(file)
        }
    }
}

// MARK: - Implementation

private final class LiveAudioClient {
    private var audioPlayer: AVAudioPlayer?

    public func play(_ file: AudioFile) {
        guard
            let url = file.url,
            let audioPlayer = try? AVAudioPlayer(contentsOf: url)
        else {
            return
        }

        try? AVAudioSession.sharedInstance().setCategory(file.category)
        self.audioPlayer = audioPlayer
        audioPlayer.play()
    }
}
