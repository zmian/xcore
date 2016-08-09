//
// StoryboardInstantiable.swift
//
// Copyright © 2015 Zeeshan Mian
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

/// A type that all `UIViewController` subclasses conform to.
/// It provides a safe way to init view controllers from Storyboard.
/// It also eliminates casting as `initFromStoryboard()` method automatically
/// returns the correct `UIViewController`'s subclass.
///
/// The default `storyboardIdentifier` value is `UIViewController`'s class name.
/// ```
/// class SettingsViewController: UIViewController { }
///
/// print(SettingsViewController.storyboardIdentifier)
///
/// "SettingsViewController"
///
/// let vc = SettingsViewController.initFromStoryboard()
/// navigationController.pushViewController(vc, animated: true)
///
/// ```
/// If you want to provide your own custom `storyboardIdentifier` you can do so like:
/// ```
/// class SettingsViewController: UIViewController {
///     override class var storyboardIdentifier: String { return "Settings" }
/// }
/// 
/// let vc = SettingsViewController.initFromStoryboard()
/// navigationController.pushViewController(vc, animated: true)
/// ```
public protocol StoryboardInstantiable {
    static var storyboardIdentifier: String { get }
}

extension UIViewController: StoryboardInstantiable {
    public class var storyboardIdentifier: String { return "\(self)" }
}

public extension StoryboardInstantiable where Self: UIViewController {
    @warn_unused_result
    public static func initFromStoryboard(named named: String = "Main", bundle: NSBundle? = nil) -> Self {
        let bundle = bundle ?? NSBundle(forClass: Self.self)
        return ControllerFromStoryboard(storyboardIdentifier, storyboardName: named, bundle: bundle) as! Self
    }
}
