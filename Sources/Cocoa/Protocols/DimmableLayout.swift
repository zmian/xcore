//
// DimmableLayout.swift
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public protocol DimmableLayout: UICollectionViewLayout {
    var shouldDimElements: Bool { get set }
}
