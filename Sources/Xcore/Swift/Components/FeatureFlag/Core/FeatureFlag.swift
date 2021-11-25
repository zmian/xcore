//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Namespace

/// A namespace for flags that serve as feature flags.
///
/// The various feature flags defined as extensions on ``FeatureFlag`` implement
/// their functionality as classes or structures that extend this enumeration.
/// For example, the **System Alert** flag returns a `SystemAlertConfiguration`
/// instance.
public enum FeatureFlag {}
