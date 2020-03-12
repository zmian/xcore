//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
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
