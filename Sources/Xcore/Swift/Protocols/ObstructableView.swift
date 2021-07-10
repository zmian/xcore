//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// A protocol to indicate that conforming view is obstructing the screen
/// (e.g., interstitial view).
///
/// Such information is useful when certain actions can't be triggered,
/// for example, in-app deep-linking routing.
public protocol ObstructableView {}
