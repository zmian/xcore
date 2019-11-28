//
// InterstitialCompatibleViewController.swift
//
// Copyright © 2018 Xcore
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

import Foundation

public protocol InterstitialCompatibleViewController: UIViewController, ObstructableView {
    var didComplete: (() -> Void)? { get set }

    /// A method invoked when the interstitial is canceled by the user using the
    /// dismiss button.
    func didDismiss()
}

extension InterstitialCompatibleViewController {
    public func didDismiss() { }
}

// MARK: - Identifier

extension InterstitialCompatibleViewController {
    public var interstitialId: Interstitial.Identifier {
        get {
            guard let id = objc_getAssociatedObject(
                self,
                &Interstitial.AssociatedKey.interstitialId
            ) as? Interstitial.Identifier else {
                return Identifier(rawValue: name(of: self))
            }

            return id
        }
        set {
            objc_setAssociatedObject(
                self,
                &Interstitial.AssociatedKey.interstitialId,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}

extension Interstitial {
    fileprivate struct AssociatedKey {
        static var interstitialId = "InterstitialCompatibleViewController.interstitialId"
    }
}
