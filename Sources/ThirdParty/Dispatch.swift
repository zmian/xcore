//
// Dispatch.swift
// Based on https://gist.github.com/Inferis/0813bf742742774d55fa
//

import Foundation

public final class dispatch {
    public enum QOS {
        case userInteractive, userInitiated, `default`, utility, background, unspecified

        fileprivate var identifier: DispatchQoS.QoSClass {
            switch self {
                case .userInteractive: return DispatchQoS.QoSClass.userInteractive
                case .userInitiated:   return DispatchQoS.QoSClass.userInitiated
                case .default:         return DispatchQoS.QoSClass.default
                case .utility:         return DispatchQoS.QoSClass.utility
                case .background:      return DispatchQoS.QoSClass.background
                case .unspecified:     return DispatchQoS.QoSClass.unspecified
            }
        }
    }

    public final class async {
        /// Submits a block for asynchronous execution on a dispatch queue and returns immediately.
        ///
        /// - parameter qos:   The quality of service you want to give to tasks executed using this queue.
        ///                    The default value is `.default`.
        /// - parameter block: The block to submit to the target dispatch queue.
        public static func bg(_ qos: QOS = .default, block: @escaping () -> Void) {
            DispatchQueue.global(qos: qos.identifier).async(execute: block)
        }

        /// Returns the serial dispatch queue associated with the application’s main thread.
        ///
        /// - parameter block: The block to submit to the target dispatch queue.
        public static func main(_ block: @escaping () -> Void) {
            DispatchQueue.main.async(execute: DispatchWorkItem(flags: .inheritQoS, block: block))
        }
    }

    public final class sync {
        /// Submits a block object for execution on a dispatch queue and waits until that block completes.
        ///
        /// - parameter qos:   The quality of service you want to give to tasks executed using this queue.
        ///                    The default value is `.default`.
        /// - parameter block: The block to be invoked on the target dispatch queue.
        public static func bg(_ qos: QOS = .default, block: () -> Void) {
            DispatchQueue.global(qos: qos.identifier).sync(execute: block)
        }

        /// Submits a block object for execution on application’s main thread and waits until that block completes.
        ///
        /// - parameter block: The block to be invoked on the target dispatch queue.
        public static func main(_ block: () -> Void) {
            if Thread.isMainThread  {
                block()
            }
            else {
                DispatchQueue.main.sync(execute: block)
            }
        }
    }

    public final class after {
        /// Enqueue a block for execution at the specified time.
        ///
        /// - parameter when:  The temporal milestone returned by `DispatchTime` or `DispatchWallTime`.
        /// - parameter qos:   The quality of service you want to give to tasks executed using this queue.
        ///                    The default value is `.default`.
        /// - parameter block: The block to submit.
        public static func bg(dispatchTime when: DispatchTime, qos: QOS = .default, block: @escaping () -> Void) {
            DispatchQueue.global(qos: qos.identifier).asyncAfter(deadline: when, execute: block)
        }

        /// Enqueue a block for execution at the specified time on application’s main thread.
        ///
        /// - parameter when:  The temporal milestone returned by `DispatchTime` or `DispatchWallTime`.
        /// - parameter block: The block to submit.
        public static func main(dispatchTime when: DispatchTime, block: @escaping () -> Void) {
            DispatchQueue.main.asyncAfter(deadline: when, execute: block)
        }

        /// Enqueue a block for execution at the specified time.
        ///
        /// - parameter interval: The time interval, in seconds, to wait before the task is executed.
        /// - parameter qos:      The quality of service you want to give to tasks executed using this queue.
        ///                       The default value is `.default`.
        /// - parameter block:    The block to submit.
        public static func bg(_ interval: TimeInterval, qos: QOS = .default, block: @escaping () -> Void) {
            DispatchQueue.global(qos: qos.identifier).asyncAfter(deadline: dispatch.seconds(interval), execute: block)
        }

        /// Enqueue a block for execution at the specified time on application’s main thread.
        ///
        /// - parameter interval: The time interval, in seconds, to wait before the task is executed.
        /// - parameter block:    The block to submit.
        public static func main(_ interval: TimeInterval, block: @escaping () -> Void) {
            DispatchQueue.main.asyncAfter(deadline: dispatch.seconds(interval), execute: block)
        }
    }

    /// A convenience method to convert `TimeInterval` to `DispatchTime`.
    ///
    /// - parameter interval: The time interval, in seconds.
    ///
    /// - returns: A new `DispatchTime` from specified seconds.
    public static func seconds(_ interval: TimeInterval) -> DispatchTime {
        return DispatchTime.now() + Double(Int64(interval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    }
}
