//
// ViewMaskable.swift
//
// Copyright © 2017 Xcore
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

public protocol ViewMaskable: class {
    static func add(to superview: UIView) -> Self
    func dismiss(_ completion: (() -> Void)?)
    var preferredNavigationBarTintColor: UIColor { get }
    var preferredStatusBarStyle: UIStatusBarStyle { get }
}

extension ViewMaskable {
    public var preferredNavigationBarTintColor: UIColor {
        return .appTint
    }

    public var preferredStatusBarStyle: UIStatusBarStyle {
        return preferredNavigationBarTintColor == .white ? .lightContent : .default
    }

    public func dismiss(after delayDuration: TimeInterval, _ completion: (() -> Void)? = nil) {
        delay(by: delayDuration) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(completion)
        }
    }
}
