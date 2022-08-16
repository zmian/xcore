//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import AVFoundation

// MARK: - Current Playback Time monitoring

extension AVPlayer {
    /// A Boolean property indicating whether playback is in progress.
    public var isPlaying: Bool {
        timeControlStatus == .playing
    }

    public func currentTime(_ block: @escaping (_ seconds: TimeInterval, _ formattedTime: String) -> Void) -> Any {
        let interval = CMTime(value: 1, timescale: 1)

        return addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] _ in
            guard let strongSelf = self else { return }
            let currentTime = strongSelf.currentTime()
            let normalizedTime = Double(currentTime.value) / Double(currentTime.timescale)
            block(normalizedTime, strongSelf.format(seconds: normalizedTime))
        }
    }

    private func format(seconds: TimeInterval) -> String {
        let sec = seconds % 60
        let min = seconds / 60
        let hrs = seconds / 3600

        if hrs == 0 {
            return String(format: "%02d:%02d", min, sec)
        }

        return String(format: "%02d:%02d:%02d", hrs, min, sec)
    }
}

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
