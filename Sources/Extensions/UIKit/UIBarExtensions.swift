//
// UIBarExtensions.swift
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

import UIKit

// MARK: UINavigationBar Extension

extension UINavigationBar {
    fileprivate struct AssociatedKey {
        static var isTransparent = "XcoreIsTransparent"
    }

    open var isTransparent: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKey.isTransparent) as? Bool ?? false }
        set {
            guard newValue != isTransparent else { return }
            objc_setAssociatedObject(self, &AssociatedKey.isTransparent, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            if newValue {
                setBackgroundImage(UIImage(), for: .default)
                shadowImage     = UIImage()
                isTranslucent   = true
                backgroundColor = .clear
            } else {
                setBackgroundImage(nil, for: .default)
            }
        }
    }
}

// MARK: UIToolbar Extension

extension UIToolbar {
    fileprivate struct AssociatedKey {
        static var isTransparent = "XcoreIsTransparent"
    }

    open var isTransparent: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKey.isTransparent) as? Bool ?? false }
        set {
            guard newValue != isTransparent else { return }
            objc_setAssociatedObject(self, &AssociatedKey.isTransparent, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            if newValue {
                setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
                isTranslucent   = true
                backgroundColor = .clear
            } else {
                setBackgroundImage(nil, forToolbarPosition: .any, barMetrics: .default)
            }
        }
    }
}

// MARK: UITabBar Extension

extension UITabBar {
    fileprivate struct AssociatedKey {
        static var isTransparent = "XcoreIsTransparent"
    }

    open var isTransparent: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKey.isTransparent) as? Bool ?? false }
        set {
            guard newValue != isTransparent else { return }
            objc_setAssociatedObject(self, &AssociatedKey.isTransparent, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            if newValue {
                backgroundImage = UIImage()
                shadowImage     = UIImage()
                isTranslucent   = true
                backgroundColor = .clear
            } else {
                backgroundImage = nil
            }
        }
    }

    open var isBorderHidden: Bool {
        get { return value(forKey: "_hidesShadow") as? Bool ?? false }
        set { setValue(newValue, forKey: "_hidesShadow") }
    }

    open func setBorder(color: UIColor, thickness: CGFloat = 1) {
        isBorderHidden = true
        addBorder(edges: .top, color: color, thickness: thickness)
    }
}

// MARK: UIBarButtonItem Extension

extension UIBarButtonItem {
    open dynamic var textColor: UIColor? {
        get { return titleTextAttributes(for: .normal)?[NSForegroundColorAttributeName] as? UIColor }
        set {
            var attributes = titleTextAttributes(for: .normal) ?? [:]
            attributes[NSForegroundColorAttributeName] = newValue
            setTitleTextAttributes(attributes, for: .normal)
        }
    }

    open dynamic var font: UIFont? {
        get { return titleTextAttributes(for: .normal)?[NSFontAttributeName] as? UIFont }
        set {
            var attributes = titleTextAttributes(for: .normal) ?? [:]
            attributes[NSFontAttributeName] = newValue
            setTitleTextAttributes(attributes, for: .normal)
        }
    }
}
