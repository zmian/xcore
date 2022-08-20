//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// An enumeration representing the swizzle method type.
public enum SwizzleMethodType {
    /// Swizzle the class method of a class.
    case `class`

    /// Swizzle an instance method of a class.
    case instance
}

/// Swizzle selector for the given class.
///
/// **Swizzling desired method:**
///
/// ```swift
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
///         // ... custom code
///     }
/// }
/// ```
///
/// Initializing the swizzle hook to ensure it's only run once:
///
/// ```swift
/// @main
/// struct ExampleApp: App {
///     init() {
///         UIViewController.runOnceSwapViewWillAppear()
///     }
///
///     var body: some Scene {
///         // ...
///     }
/// }
/// ```
public func swizzle(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector, type: SwizzleMethodType = .instance) {
    let original: Method?
    let swizzled: Method?

    switch type {
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
