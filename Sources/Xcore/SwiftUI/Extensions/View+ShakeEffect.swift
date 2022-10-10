//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Shakes this view based on given number of shakes.
    public func shakeEffect(_ shakes: Int) -> some View {
        modifier(ShakeEffect(shakes: shakes))
    }
}

// MARK: - GeometryEffect

/// - SeeAlso: https://talk.objc.io/episodes/S01E173-building-a-shake-animation
public struct ShakeEffect: GeometryEffect, Sendable {
    public var animatableData: CGFloat

    public init(shakes: Int) {
        animatableData = CGFloat(shakes)
    }

    public func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: -10 * sin(animatableData * 2 * .pi), y: 0))
    }
}
