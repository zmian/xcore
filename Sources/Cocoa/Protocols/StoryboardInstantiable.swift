//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
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
/// class SettingsViewController: UIViewController {}
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
///     class var storyboardId: String { "Settings" }
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
        String(describing: self)
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

extension UIViewController: StoryboardInstantiable {}
