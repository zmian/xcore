//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIResponder {
    /// A convenience function to find the response of type `T`.
    ///
    /// ```swift
    /// extension UICollectionViewCell {
    ///     func configure() {
    ///         if let collectionView = responder() as? UICollectionView {
    ///
    ///         }
    ///     }
    /// }
    /// ```
    open func responder<T: UIResponder>() -> T? {
        var responder: UIResponder = self
        while let nextResponder = responder.next {
            responder = nextResponder
            if responder is T {
                return responder as? T
            }
        }
        return nil
    }
}
