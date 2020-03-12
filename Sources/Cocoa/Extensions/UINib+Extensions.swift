//
// UINib+Extensions.swift
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UINib {
    /// A optional initializer to return a `UINib` object initialized to the
    /// nib file in the specified bundle or in `main` bundle if no bundle is provided.
    ///
    /// - Parameters:
    ///   - named: The name of the nib file, without any leading path information.
    ///   - bundle: The bundle in which to search for the nib file. If you specify `nil`,
    ///             this method looks for the nib file in the `main` bundle.
    public convenience init?(named: String, bundle: Bundle? = nil) {
        let bundle = bundle ?? .main

        guard bundle.path(forResource: named, ofType: "nib") != nil else {
            return nil
        }

        self.init(nibName: named, bundle: bundle)
    }
}
