//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import AVKit

/// Provides functionality for playing audio on the device.
public protocol AudioClient {
    func play(_ file: AudioFile)
}

// MARK: - File

public struct AudioFile: Equatable {
    public let name: String
    public let bundle: Bundle
    public let category: AVAudioSession.Category

    /// Creates audio file.
    ///
    /// - Parameters:
    ///   - name: The name of the audio file.
    ///   - bundle: The bundle where audio file is located.
    ///   - category: The audio session category.
    public init(name: String, bundle: Bundle = .main, category: AVAudioSession.Category) {
        self.name = name
        self.bundle = bundle
        self.category = category
    }
}

// MARK: - Dependency

extension DependencyValues {
    private struct AudioClientKey: DependencyKey {
        static let defaultValue: AudioClient = .live
    }

    /// Provides functionality for playing audio on the device.
    public var audio: AudioClient {
        get { self[AudioClientKey.self] }
        set { self[AudioClientKey.self] = newValue }
    }

    /// Provides functionality for playing audio on the device.
    @discardableResult
    public static func audio(_ value: AudioClient) -> Self.Type {
        set(\.audio, value)
        return Self.self
    }
}
