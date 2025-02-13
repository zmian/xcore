//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// Provides functionality for playing audio on the device.
///
/// **Usage**
///
/// ```swift
/// class ViewModel {
///     @Dependency(\.audioPlayer) var audioPlayer
///
///     func play() {
///         audioPlayer.play(.success)
///     }
/// }
///
/// extension AudioFile {
///     static var success: Self {
///         .init(name: "success.mp3", bundle: .module, category: .ambient)
///     }
/// }
/// ```
public struct AudioPlayerClient: Sendable {
    /// Play the given audio file.
    public let play: @Sendable (_ file: AudioFile) -> Void

    /// Creates a client that plays the given audio file.
    ///
    /// - Parameter play: The closure to play the given audio file.
    public init(play: @escaping @Sendable (_ file: AudioFile) -> Void) {
        self.play = play
    }
}

// MARK: - Variants

extension AudioPlayerClient {
    /// Returns noop variant of `AudioPlayerClient`.
    public static var noop: Self {
        .init { _ in }
    }

    /// Returns unimplemented variant of `AudioPlayerClient`.
    public static var unimplemented: Self {
        .init { _ in
            reportIssue(#"Unimplemented: @Dependency(\.audioPlayer)"#)
        }
    }
}

// MARK: - Dependency

extension DependencyValues {
    private enum AudioPlayerClientKey: DependencyKey {
        static let liveValue: AudioPlayerClient = .live
        static let testValue: AudioPlayerClient = .unimplemented
    }

    /// Provides functionality for playing audio on the device.
    public var audioPlayer: AudioPlayerClient {
        get { self[AudioPlayerClientKey.self] }
        set { self[AudioPlayerClientKey.self] = newValue }
    }
}
