//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Interstitial {
    final public class Controller: Appliable {
        private let displayTimestamp: DisplayTimestamp
        private var interstitials = [Interstitial.Item]()
        private lazy var hud = HUD().apply {
            $0.willShow { [weak self] _ in
                self?.updatePageControl()
            }
        }

        /// Store all interstitials and their completion status in a given session. A
        /// session begins when the navigation controller is presented and ends when it
        /// is dismissed.
        private var sessionInterstitials: [Interstitial.Item: Bool] = [ : ]
        private var currentInterstitialIndex: Int {
            sessionInterstitials.filter { $0.1 == true }.count
        }

        public var isPageControlEnabled = true

        /// A boolean property indicating whether interstitial items are currently being
        /// presented.
        public var isPresenting: Bool {
            hud.isPresenting
        }

        public init(storage: InterstitialDisplayTimestampStorage) {
            self.displayTimestamp = .init(storage: storage)
        }

        public func canPresent(_ interstitials: [Interstitial.Item]) -> Bool {
            !interstitials.filter(presentPrecondition(interstitial:)).isEmpty
        }

        public func setInterstitials(_ newInterstitials: [Interstitial.Item]) {
            interstitials = newInterstitials.filter(presentPrecondition(interstitial:))

            // Mark all current session interstitials as completes.
            sessionInterstitials.keys.forEach {
                sessionInterstitials[$0] = true
            }

            // Unmark any of the new interstitials as incomplete that are in the session
            // interstitials.
            interstitials.forEach {
                sessionInterstitials[$0] = false
            }

            updatePageControl()

            if interstitials.isEmpty {
                dismissIfNeeded()
            } else {
                presentIfNeeded()
            }
        }

        private func showIfNeeded() {
            hud.showIfNeeded { [weak self] in
                self?.didShowInterstitial?()
            }
        }

        private func dismissIfNeeded(shouldNotifyDismissal: Bool = false) {
            interstitials.removeAll()
            hud.hide { [weak self] in
                self?.sessionInterstitials = [:]
                if shouldNotifyDismissal {
                    self?.notifyDismissalIfNeeded()
                }
            }
        }

        private func notifyDismissalIfNeeded() {
            guard interstitials.isEmpty else { return }
            didDismissAllInterstitials?()
        }

        @discardableResult
        private func presentIfNeeded() -> Bool {
            guard let firstInterstitial = interstitials.first else {
                return false
            }

            // We are on the correct interstitial screen. Do nothing.
            if let currentViewController = hud.currentViewController, currentViewController.interstitialId == firstInterstitial.id {
                interstitials.removeFirst()
                showIfNeeded()
                return true
            }

            // Present first interstitial and only animate if in different interstitial group
            present(interstitial: firstInterstitial, animated: hud.currentViewController?.interstitialId != firstInterstitial.id)
            return true
        }

        private func present(interstitial: Interstitial.Item, animated: Bool = true) {
            let vc = interstitial.viewController()
            vc.didComplete = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.didComplete(interstitial: interstitial)
            }
            setViewControllers([vc], animated: animated)
            interstitials.remove(interstitial)
            showIfNeeded()
        }

        private func didComplete(interstitial: Interstitial.Item) {
            // Mark interstitial in question as completed
            sessionInterstitials[interstitial] = true
            displayTimestamp.setDisplay(true, id: interstitial.id)
            guard !presentIfNeeded() else { return }
            dismissIfNeeded(shouldNotifyDismissal: true)
        }

        // MARK: - Hooks

        private var didShowInterstitial: (() -> Void)?
        /// A block invoked when an interstitial is presented.
        public func didShowInterstitial(_ callback: @escaping () -> Void) {
            didShowInterstitial = callback
        }

        private var didDismissAllInterstitials: (() -> Void)?
        /// A block invoked when all interstitials are dismissed.
        public func didDismissAllInterstitials(_ callback: @escaping () -> Void) {
            didDismissAllInterstitials = callback
        }
    }
}

// MARK: - Display Policy

extension Interstitial.Controller {
    private func presentPrecondition(interstitial: Interstitial.Item) -> Bool {
        #if DEBUG
        if ProcessInfo.Arguments.isAllInterstitialsEnabled {
            return true
        }
        #endif

        return interstitial.displayPolicy.precondition() && shouldShow(interstitial)
    }

    private func shouldShow(_ item: Interstitial.Item) -> Bool {
        !displayTimestamp.contains(item.id, before: item.displayPolicy.replayDelay)
    }
}

// MARK: - Helpers

extension Interstitial.Controller {
    private func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        hud.navigationController.setViewControllers(viewControllers, animated: animated)
        hud.navigationController.currentPage = currentInterstitialIndex
    }

    private func updatePageControl() {
        hud.navigationController.apply {
            $0.numberOfPages = sessionInterstitials.count
            $0.currentPage = currentInterstitialIndex

            // Don't show page control on a view other than the interstitial compatible view
            // controller. For example, if the user taps on web view link on an interstitial
            // it shouldn't display page control on the newly presented web view.
            guard $0.topViewController is InterstitialCompatibleViewController else {
                $0.isPageControlHidden = true
                return
            }

            if !isPageControlEnabled {
                $0.isPageControlHidden = true
            }
        }
    }
}

// MARK: - Reset

extension Interstitial.Controller {
    public func reset() {
        interstitials.removeAll()
        displayTimestamp.removeAll()
        sessionInterstitials = [:]
        dismissIfNeeded()
    }
}
