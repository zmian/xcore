//
// Interstitial+Item.swift
//
// Copyright © 2018 Xcore
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

extension Interstitial {
    public struct Item {
        public let id: Interstitial.Identifier
        private let _displayPolicy: DisplayPolicy
        private var _viewController: (_ userState: Interstitial.UserState) -> InterstitialCompatibleViewController

        public init(
            id: Interstitial.Identifier,
            displayPolicy: DisplayPolicy,
            viewController: @escaping (_ userState: Interstitial.UserState) -> InterstitialCompatibleViewController
        ) {
            self.id = id
            self._displayPolicy = displayPolicy
            self._viewController = viewController
        }

        public init(
            id: Interstitial.Identifier,
            viewController: @escaping (_ userState: Interstitial.UserState) -> InterstitialCompatibleViewController
        ) {
            self.id = id
            self._displayPolicy = .always
            self._viewController = viewController
        }

        public var displayPolicy: DisplayPolicy {
            _displayPolicy.updateFromFeatureFlag(id: id)
        }

        public func viewController(userState: Interstitial.UserState) -> InterstitialCompatibleViewController {
            let vc = _viewController(userState).apply {
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
        UIBarButtonItem(assetIdentifier: .closeIcon).apply {
            $0.tintColor = .appTint
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
