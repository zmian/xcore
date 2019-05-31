//
// TargetActionBlockRepresentable.swift
//
// Copyright © 2015 Xcore
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

import UIKit
import ObjectiveC

public protocol TargetActionBlockRepresentable: class {
    associatedtype Sender

    /// Add action handler when the item is selected.
    ///
    /// - Parameter handler: The block to invoke when the item is selected.
    func addAction(_ handler: @escaping (_ sender: Sender) -> Void)

    /// Removes action handler from `self`.
    func removeAction()
}

@objcMembers
class ClosureWrapper: NSObject {
    var closure: (() -> Void)?

    init(_ closure: (() -> Void)?) {
        self.closure = closure
    }

    func invoke(_ sender: AnyObject) {
        closure?()
    }
}

@objcMembers
class SenderClosureWrapper: NSObject {
    var closure: ((_ sender: AnyObject) -> Void)?

    init(_ closure: ((_ sender: AnyObject) -> Void)?) {
        self.closure = closure
    }

    func invoke(_ sender: AnyObject) {
        closure?(sender)
    }
}
