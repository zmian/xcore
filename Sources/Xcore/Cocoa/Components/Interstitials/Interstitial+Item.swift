//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Interstitial {
    public struct Item {
        public let id: Interstitial.Identifier
        private let _displayPolicy: DisplayPolicy
        private var _viewController: () -> InterstitialCompatibleViewController

        public init(
            id: Interstitial.Identifier,
            displayPolicy: DisplayPolicy,
            viewController: @escaping () -> InterstitialCompatibleViewController
        ) {
            self.id = id
            self._displayPolicy = displayPolicy
            self._viewController = viewController
        }

        public init(
            id: Interstitial.Identifier,
            viewController: @escaping () -> InterstitialCompatibleViewController
        ) {
            self.id = id
            self._displayPolicy = .always
            self._viewController = viewController
        }

        public var displayPolicy: DisplayPolicy {
            _displayPolicy.updateFromFeatureFlag(id: id)
        }

        public func viewController() -> InterstitialCompatibleViewController {
            let vc = _viewController().apply {
                $0.interstitialId = id
            }

            if displayPolicy.isDismissable {
                vc.navigationItem.rightBarButtonItem = dismissButton(for: vc)
            } else {
                vc.navigationItem.rightBarButtonItem = nil
            }

            #if DEBUG
            if ProcessInfo.Arguments.isAllInterstitialsEnabled {
                vc.navigationItem.rightBarButtonItem = dismissButton(for: vc)
            }
            #endif

            return vc
        }
    }
}

extension Interstitial.Item {
    private func dismissButton(for vc: InterstitialCompatibleViewController) -> UIBarButtonItem {
        UIBarButtonItem(system: .xMark).apply {
            $0.accessibilityLabel = "Dismiss"
            $0.accessibilityIdentifier = "dismissButton"
            $0.tintColor = vc.theme.accentColor
            $0.addAction { [weak vc] _ in
                guard let vc = vc else { return }
                vc.didDismiss()
                vc.didComplete?()
            }
        }
    }
}

// MARK: - Hashable

extension Interstitial.Item: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Equatable

extension Interstitial.Item: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
