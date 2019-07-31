//
// StoryboardInstantiable.swift
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

/// A type to which all `UIViewController` subclasses conform.
///
/// It provides a safe way to init view controllers from Storyboard. It also
/// eliminates casting as `initFromStoryboard()` method automatically returns
/// the correct `UIViewController`'s subclass.
///
/// The default `storyboardId` value is `UIViewController`'s class name:
///
/// ```swift
/// class SettingsViewController: UIViewController { }
///
/// print(SettingsViewController.storyboardId)
/// // "SettingsViewController"
///
/// let vc = SettingsViewController.initFromStoryboard()
/// navigationController.pushViewController(vc, animated: true)
/// ```
///
/// If you want to provide your own custom `storyboardId` you can do so like:
///
/// ```swift
/// class SettingsViewController: UIViewController {
///     class var storyboardId: String { return "Settings" }
/// }
///
/// let vc = SettingsViewController.initFromStoryboard()
/// navigationController.pushViewController(vc, animated: true)
/// ```
public protocol StoryboardInstantiable {
    static var storyboardId: String { get }
}

extension StoryboardInstantiable {
    public static var storyboardId: String {
        return String(describing: self)
    }
}

extension StoryboardInstantiable where Self: UIViewController {
    /// Instantiates and returns the view controller of type `Self`.
    ///
    /// - Parameters:
    ///   - named: The name of the storyboard file without the file extension. The
    ///            default value is `Main`.
    ///   - bundle: The bundle containing the storyboard file and its related
    ///             resources. If `nil`, then this method looks in the `main` bundle
    ///             of the current application. The default value is `nil`.
    /// - Returns: The view controller of type `Self`.
    public static func initFromStoryboard(named: String = "Main", bundle: Bundle? = nil) -> Self {
        let bundle = bundle ?? Bundle(for: Self.self)
        return UIStoryboard(name: named, bundle: bundle).instantiateViewController(withIdentifier: storyboardId) as! Self
    }
}

extension UIViewController: StoryboardInstantiable { }
