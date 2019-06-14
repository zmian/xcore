//
//  DimmableLayout.swift
//  Haring
//
//  Created by Guillermo Waitzel on 14/06/2019.
//

import Foundation

protocol DimmableLayout: UICollectionViewLayout {
    var shouldDimElements: Bool { get set }
}
