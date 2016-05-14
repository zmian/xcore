//
// Dispatch.swift
// Based on https://gist.github.com/Inferis/0813bf742742774d55fa
//

import Foundation

public final class dispatch {
    public enum QOS {
        case userInteractive, userInitiated, `default`, utility, background, unspecified

        private var identifier: qos_class_t {
            switch self {
                case .userInteractive: return QOS_CLASS_USER_INTERACTIVE
                case .userInitiated:   return QOS_CLASS_USER_INITIATED
                case .`default`:       return QOS_CLASS_DEFAULT
                case .utility:         return QOS_CLASS_UTILITY
                case .background:      return QOS_CLASS_BACKGROUND
                case .unspecified:     return QOS_CLASS_UNSPECIFIED
            }
        }
    }

    public class async {
        /// Submits a block for asynchronous execution on a dispatch queue and returns immediately.
        ///
        /// - parameter qos:   The quality of service you want to give to tasks executed using this queue.
        ///                    The default value is `QOS_CLASS_BACKGROUND`.
        /// - parameter block: The block to submit to the target dispatch queue.
        public class func bg(qos: QOS = .background, block: dispatch_block_t) {
            dispatch_async(dispatch_get_global_queue(qos.identifier, 0), block)
        }

        /// Returns the serial dispatch queue associated with the application’s main thread.
        ///
        /// - parameter block: The block to submit to the target dispatch queue.
        public class func main(block: dispatch_block_t) {
            dispatch_async(dispatch_get_main_queue(), dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block))
        }
    }

    public class sync {
        /// Submits a block object for execution on a dispatch queue and waits until that block completes.
        ///
        /// - parameter qos:   The quality of service you want to give to tasks executed using this queue.
        ///                    The default value is `QOS_CLASS_BACKGROUND`.
        /// - parameter block: The block to be invoked on the target dispatch queue.
        public class func bg(qos: QOS = .background, block: dispatch_block_t) {
            dispatch_sync(dispatch_get_global_queue(qos.identifier, 0), block)
        }

        /// Submits a block object for execution on application’s main thread and waits until that block completes.
        ///
        /// - parameter block: The block to be invoked on the target dispatch queue.
        public class func main(block: dispatch_block_t) {
            if NSThread.isMainThread()  {
                block()
            }
            else {
                dispatch_sync(dispatch_get_main_queue(), block)
            }
        }
    }

    public class after {
        /// Enqueue a block for execution at the specified time.
        ///
        /// - parameter when:  The temporal milestone returned by `dispatch_time` or `dispatch_walltime`.
        /// - parameter qos:   The quality of service you want to give to tasks executed using this queue.
        ///                    The default value is `QOS_CLASS_BACKGROUND`.
        /// - parameter block: The block to submit.
        public class func bg(dispatchTime when: dispatch_time_t, qos: QOS = .background, block: dispatch_block_t) {
            dispatch_after(when, dispatch_get_global_queue(qos.identifier, 0), block)
        }

        /// Enqueue a block for execution at the specified time on application’s main thread.
        ///
        /// - parameter when:  The temporal milestone returned by `dispatch_time` or `dispatch_walltime`.
        /// - parameter block: The block to submit.
        public class func main(dispatchTime when: dispatch_time_t, block: dispatch_block_t) {
            dispatch_after(when, dispatch_get_main_queue(), block)
        }

        /// Enqueue a block for execution at the specified time.
        ///
        /// - parameter interval: The time interval, in seconds, to wait before the task is executed.
        /// - parameter qos:      The quality of service you want to give to tasks executed using this queue.
        ///                       The default value is `QOS_CLASS_BACKGROUND`.
        /// - parameter block:    The block to submit.
        public class func bg(interval: NSTimeInterval, qos: QOS = .background, block: dispatch_block_t) {
            dispatch_after(dispatch.seconds(interval), dispatch_get_global_queue(qos.identifier, 0), block)
        }

        /// Enqueue a block for execution at the specified time on application’s main thread.
        ///
        /// - parameter interval: The time interval, in seconds, to wait before the task is executed.
        /// - parameter block:    The block to submit.
        public class func main(interval: NSTimeInterval, block: dispatch_block_t) {
            dispatch_after(dispatch.seconds(interval), dispatch_get_main_queue(), block)
        }
    }

    /// A convenience method to convert `NSTimeInterval` to `dispatch_time_t`.
    ///
    /// - parameter interval: The time interval, in seconds.
    ///
    /// - returns: A new `dispatch_time_t` from specified seconds.
    public class func seconds(interval: NSTimeInterval) -> dispatch_time_t {
        return dispatch_time(DISPATCH_TIME_NOW, Int64(interval * Double(NSEC_PER_SEC)))
    }
}
