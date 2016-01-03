//
//  Dispatch.swift
//  Inferis
//

import Foundation

public final class dispatch {
    public class async {
        public class func bg(block: dispatch_block_t) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block)
        }

        public class func main(block: dispatch_block_t) {
            dispatch_async(dispatch_get_main_queue(), dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block))
        }
    }

    public class sync {
        public class func bg(block: dispatch_block_t) {
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block)
        }

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
        public class func bg(when: dispatch_time_t, block: dispatch_block_t) {
            dispatch_after(when, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)!, block)
        }

        public class func main(when: dispatch_time_t, block: dispatch_block_t) {
            dispatch_after(when, dispatch_get_main_queue(), block)
        }
    }

    public class func seconds(interval: NSTimeInterval) -> dispatch_time_t {
        return dispatch_time(DISPATCH_TIME_NOW, Int64(interval * Double(NSEC_PER_SEC)))
    }
}
