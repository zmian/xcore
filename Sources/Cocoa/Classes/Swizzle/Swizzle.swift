//
// Swizzle.swift
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

import UIKit

/// Swizzle selector for the given class.
///
/// ```swift
/// extension UIApplication {
///     private static let runOnce: Void = {
///         UIViewController.runOnceSwapViewWillAppear()
///     }()
///
///     open override var next: UIResponder? {
///         // Called before applicationDidFinishLaunching
///         UIApplication.runOnce
///         return super.next
///     }
/// }
///
/// extension UIViewController {
///     private static func runOnceSwapViewWillAppear() {
///         swizzle(
///             UIViewController.self,
///             originalSelector: #selector(UIViewController.viewWillAppear(_:)),
///             swizzledSelector: #selector(UIViewController.swizzled_viewWillAppear(_:))
///         )
///     }
///
///     @objc private func swizzled_viewWillAppear(_ animated: Bool) {
///         swizzled_viewWillAppear(animated)
///     }
/// }
/// ```
public func swizzle(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector, kind: SwizzleMethodKind = .instance) {
    let original: Method?
    let swizzled: Method?

    switch kind {
        case .instance:
            original = class_getInstanceMethod(forClass, originalSelector)
            swizzled = class_getInstanceMethod(forClass, swizzledSelector)
        case .class:
            original = class_getClassMethod(forClass, originalSelector)
            swizzled = class_getClassMethod(forClass, swizzledSelector)
    }

    guard let originalMethod = original, let swizzledMethod = swizzled else {
        return
    }

    let didAddMethod = class_addMethod(
        forClass,
        originalSelector,
        method_getImplementation(swizzledMethod),
        method_getTypeEncoding(swizzledMethod)
    )

    if didAddMethod {
        class_replaceMethod(
            forClass,
            swizzledSelector,
            method_getImplementation(originalMethod),
            method_getTypeEncoding(originalMethod)
        )
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}

public enum SwizzleMethodKind {
    case `class`
    case instance
}
