//
// AVFoundation+Extensions.swift
//
// Copyright © 2014 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import AVFoundation
import ObjectiveC

// MARK: Current Playback Time monitoring

extension AVPlayer {
    public var isPlaying: Bool {
        return timeControlStatus == .playing
    }

    public func currentTime(_ block: @escaping (_ seconds: Int, _ formattedTime: String) -> Void) -> Any {
        let interval = CMTime(value: 1, timescale: 1)

        return addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let strongSelf = self else { return }
            let currentTime = strongSelf.currentTime()
            let normalizedTime = Double(currentTime.value) / Double(currentTime.timescale)
            block(Int(normalizedTime), strongSelf.format(seconds: Int(normalizedTime)))
        }
    }

    private func format(seconds: Int) -> String {
        let sec = seconds % 60
        let min = seconds / 60
        let hrs = seconds / 3600

        if hrs == 0 {
            return String(format: "%02d:%02d", min, sec)
        }

        return String(format: "%02d:%02d:%02d", hrs, min, sec)
    }
}

extension AVPlayer {
    private struct AssociatedKey {
        static var playerRepeat = "playerRepeat"
    }

    /// Indicates whether to repeat playback of the current item.
    public var `repeat`: Bool {
        get { return associatedObject(&AssociatedKey.playerRepeat, default: false) }
        set {
            guard newValue != `repeat` else { return }
            setAssociatedObject(&AssociatedKey.playerRepeat, value: newValue)

            guard newValue else {
                NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: currentItem)
                return
            }

            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: currentItem, queue: nil) { [weak self] notification in
                guard let strongSelf = self, let currentItem = notification.object as? AVPlayerItem else {
                    return
                }

                strongSelf.actionAtItemEnd = .none
                currentItem.seek(to: .zero) { [weak self] _ in
                    self?.play()
                }
            }
        }
    }
}

extension AVPlayerItem {
    public var hasValidDuration: Bool {
        return status == .readyToPlay && duration.isValid
    }
}

extension CMTime {
    public var isValid: Bool {
        return flags.contains(.valid)
    }

    public func offset(by: TimeInterval) -> CMTime {
        let seconds = CMTimeGetSeconds(self)
        let secondsWithOffset = seconds + by
        return CMTime(seconds: secondsWithOffset, preferredTimescale: timescale)
    }
}

// MARK: RemoteOrLocalInstantiable

// Convenience methods for initializing videos

extension AVPlayer {
    /// Initializes an AVPlayer that automatically detect and load the asset from local or a remote url.
    ///
    /// Implicitly creates an AVPlayerItem. Clients can obtain the AVPlayerItem as it becomes the player's currentItem.
    ///
    /// - Parameter remoteOrLocalName: The local file name from `NSBundle.mainBundle()` or remote url.
    /// - Returns: An instance of AVPlayer.
    public convenience init?(remoteOrLocalName: String) {
        guard let playerItem = AVPlayerItem(remoteOrLocalName: remoteOrLocalName) else {
            return nil
        }

        self.init(playerItem: playerItem)
    }
}

extension AVPlayerItem {
    /// Initializes an AVPlayerItem with local resource referenced file name.
    ///
    /// - Parameters:
    ///   - fileName: The local file name.
    ///   - bundle: The bundle containing the specified file name. If you specify `nil`,
    ///   this method looks in the main bundle of the current application. The default value is `nil`.
    /// - Returns: An instance of AVPlayerItem.
    public convenience init?(fileName: String, bundle: Bundle? = nil) {
        let name = fileName.lastPathComponent.deletingPathExtension
        let ext = fileName.pathExtension
        let bundle = bundle ?? Bundle.main

        guard let url = bundle.url(forResource: name, withExtension: ext) else {
            return nil
        }

        self.init(url: url)
    }

    /// Automatically detect and load the asset from local or a remote url.
    public convenience init?(remoteOrLocalName: String) {
        guard let url = URL(string: remoteOrLocalName), url.host != nil else {
            self.init(fileName: remoteOrLocalName)
            return
        }

        self.init(url: url)
    }
}

extension AVAsset {
    /// Initializes an AVAsset with local resource referenced file name.
    ///
    /// - Parameters:
    ///   - fileName: The local file name.
    ///   - bundle: The bundle containing the specified file name. If you specify `nil`,
    ///             this method looks in the main bundle of the current application.
    ///             The default value is `nil`.
    /// - Returns: An instance of AVAsset.
    public convenience init?(fileName: String, bundle: Bundle? = nil) {
        let name = fileName.lastPathComponent.deletingPathExtension
        let ext = fileName.pathExtension
        let bundle = bundle ?? Bundle.main

        guard let url = bundle.url(forResource: name, withExtension: ext) else {
            return nil
        }

        self.init(url: url)
    }

    /// Automatically detect and load the asset from local or a remote url.
    public convenience init?(remoteOrLocalName: String) {
        guard let url = URL(string: remoteOrLocalName), url.host != nil else {
            self.init(fileName: remoteOrLocalName)
            return
        }

        self.init(url: url)
    }
}
