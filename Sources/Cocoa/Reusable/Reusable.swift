//
// Reusable.swift
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

/// A type that all `UICollectionViewCell`, `UICollectionReusableView`,
/// `UITableViewCell`, and `UITableViewHeaderFooterView` subclasses conform to.
/// It provides a safe way to register and dequeue cells.
///
/// The default `reuseIdentifier` value is conforming class name.
///
/// ```swift
/// class ProfileCollectionViewCell: UICollectionViewCell { }
///
/// print(ProfileCollectionViewCell.reuseIdentifier)
///
/// "ProfileCollectionViewCell"
///
/// ```
/// If you want to provide your own custom `reuseIdentifier` you can do so like:
/// ```swift
/// class ProfileCollectionViewCell: UICollectionViewCell {
///     class var reuseIdentifier: String { return "ProfileCell" }
/// }
/// ```
public protocol Reusable: class {
    /// The reuse identifier to use when registering and dequeuing a reusable view.
    static var reuseIdentifier: String { get }
}

extension Reusable {
    public static var reuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

extension UICollectionReusableView: Reusable { }
extension UITableViewCell: Reusable { }
extension UITableViewHeaderFooterView: Reusable { }
