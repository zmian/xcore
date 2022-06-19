//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A control that displays a horizontal series of dots, each of which
/// corresponds to a page in the app’s document or other data-model entity.
public struct PageControl: View {
    @Binding private var currentPage: Int
    private let numberOfPages: Int

    public init(
        currentPage: Binding<Int> = .constant(0),
        numberOfPages: Int
    ) {
        self._currentPage = currentPage
        self.numberOfPages = numberOfPages
    }

    public var body: some View {
        PageControlRepresentable(
            currentPage: $currentPage,
            numberOfPages: currentPage
        )
    }
}

// MARK: - Representable

private struct PageControlRepresentable: UIViewRepresentable {
    @Binding var currentPage: Int
    let numberOfPages: Int

    func makeUIView(context: Context) -> UIPageControl {
        UIPageControl().apply {
            $0.numberOfPages = numberOfPages
            $0.pageIndicatorTintColor = context.pageIndicatorTintColor
            $0.currentPageIndicatorTintColor = context.currentPageIndicatorTintColor
            $0.addAction(.valueChanged) {
                currentPage = $0.currentPage
            }
        }
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.apply {
            $0.currentPage = currentPage
            $0.numberOfPages = numberOfPages
            $0.pageIndicatorTintColor = context.pageIndicatorTintColor
            $0.currentPageIndicatorTintColor = context.currentPageIndicatorTintColor
        }
    }
}

// MARK: - Helpers

extension UIViewRepresentableContext {
    private var theme: Theme {
        environment.theme
    }

    fileprivate var currentPageIndicatorTintColor: UIColor {
        theme.tintColor
    }

    fileprivate var pageIndicatorTintColor: UIColor {
        currentPageIndicatorTintColor.alpha(0.1)
    }
}
