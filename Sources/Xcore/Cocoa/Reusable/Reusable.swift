//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// A type that all `UICollectionViewCell`, `UICollectionReusableView`,
/// `UITableViewCell`, and `UITableViewHeaderFooterView` subclasses conform to.
/// It provides a safe way to register and dequeue cells.
///
/// The default `reuseIdentifier` value is conforming class name.
///
/// ```swift
/// class ProfileCollectionViewCell: UICollectionViewCell {}
///
/// print(ProfileCollectionViewCell.reuseIdentifier)
///
/// "ProfileCollectionViewCell"
///
/// ```
///
/// If you want to provide your own custom `reuseIdentifier` you can do so like:
///
/// ```swift
/// class ProfileCollectionViewCell: UICollectionViewCell {
///     class var reuseIdentifier: String { "ProfileCell" }
/// }
/// ```
public protocol Reusable: AnyObject {
    /// The reuse identifier to use when registering and dequeuing a reusable view.
    static var reuseIdentifier: String { get }
}

extension Reusable {
    public static var reuseIdentifier: String {
        NSStringFromClass(self)
    }
}

extension UICollectionReusableView: Reusable {}
extension UITableViewCell: Reusable {}
extension UITableViewHeaderFooterView: Reusable {}
