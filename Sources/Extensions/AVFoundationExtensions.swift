//
// AVFoundationExtensions.swift
//
// Copyright © 2014 Zeeshan Mian
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

// Current Playback Time monitoring

public extension AVPlayer {
    public func currentTime(block: (seconds: Int, formattedTime: String) -> Void) -> AnyObject {
        let interval = CMTimeMake(1, 1)
        return addPeriodicTimeObserverForInterval(interval, queue: dispatch_get_main_queue()) {[weak self] time in
            if let weakSelf = self {
                let normalizedTime = Double(weakSelf.currentTime().value) / Double(weakSelf.currentTime().timescale)
                block(seconds: Int(normalizedTime), formattedTime: weakSelf.formatSeconds(Int(normalizedTime)))
            }
        }
    }

    private func formatSeconds(seconds: Int) -> String {
        let sec = seconds % 60
        let min = seconds / 60
        let hrs = seconds / 3600

        if hrs == 0 {
            return String(format: "%02d:%02d", min, sec)
        }

        return String(format: "%02d:%02d:%02d", hrs, min, sec)
    }

    /// Loops playback of the current item.
    public func loop() {
        NSNotificationCenter.defaultCenter().addObserverForName(AVPlayerItemDidPlayToEndTimeNotification, object: self.currentItem, queue: nil) {[weak self] notification in
            self?.seekToTime(kCMTimeZero)
            self?.play()
        }
    }
}

// Convenience methods for initializing videos

public extension AVPlayer {
    /// Initializes an AVPlayer that plays a single local audiovisual resource referenced file name.
    ///
    /// Implicitly creates an AVPlayerItem. Clients can obtain the AVPlayerItem as it becomes the player's currentItem.
    ///
    /// - parameter filename: The local file name from `NSBundle.mainBundle()`
    /// - returns:            An instance of AVPlayer
    public convenience init?(fileName: String) {
        if let playerItem = AVPlayerItem(fileName: fileName) {
            self.init(playerItem: playerItem)
        } else {
            return nil
        }
    }
}

// Convenience methods for initializing videos

public extension AVPlayerItem {
    /// Initializes an AVPlayerItem with local resource referenced file name.
    ///
    /// - parameter filename: The local file name from `NSBundle.mainBundle()`
    /// - returns:            An instance of AVPlayerItem
    public convenience init?(fileName: String) {
        let name = fileName.lastPathComponent.stringByDeletingPathExtension
        let ext  = fileName.pathExtension

        if let url = NSBundle.mainBundle().URLForResource(name, withExtension: ext) {
            self.init(URL: url)
        } else {
            return nil
        }
    }

    /// Automatically detect and load the asset from local or a remote url.
    public convenience init?(remoteOrLocalName: String) {
        if let url = NSURL(string: remoteOrLocalName) where url.host != nil {
            self.init(URL: url)
        } else {
            self.init(fileName: remoteOrLocalName)
        }
    }

    public var hasValidDuration: Bool {
        return status == .ReadyToPlay && duration.isValid
    }
}

public extension CMTime {
    public var isValid: Bool { return flags.contains(.Valid) }
}
