//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Presents a share sheet when a binding to a Boolean value that you provide is
    /// `true`.
    ///
    /// Use this method when you want to present a share sheet to the user when a
    /// Boolean value you provide is `true`. The example below displays a share
    /// sheet with software license agreement when the user toggles the
    /// `isShowingShareSheet` variable by clicking or tapping on the "Share License
    /// Agreement" button:
    ///
    /// ```swift
    /// struct ShareLicenseAgreement: View {
    ///     @State private var isShowingShareSheet = false
    ///
    ///     var body: some View {
    ///         Button {
    ///             isShowingShareSheet.toggle()
    ///         } label: {
    ///             Text("Share License Agreement")
    ///         }
    ///         .shareSheet(isPresented: $isShowingShareSheet, items: ["License Agreement..."]) {
    ///             print("onComplete", $0)
    ///         } onDismiss: {
    ///             print("onDismiss")
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the share sheet.
    ///   - items: The array of data objects on which to perform the activity. The
    ///     type of objects in the array is variable and dependent on the data your
    ///     application manages. For example, the data might consist of one or more
    ///     string or image objects representing the currently selected content.
    ///
    ///     Instead of actual data objects, the objects in this array can be objects
    ///     that adopt the ``UIActivityItemSource`` protocol, such as
    ///     ``UIActivityItemProvider`` objects. Source and provider objects act as
    ///     proxies for the corresponding data in situations where you do not want
    ///     to provide that data until it is needed. Note that you should not reuse
    ///     an activity view controller object that includes a
    ///     ``UIActivityItemProvider`` object in its activityItems array.
    ///   - activities: An array of ``UIActivity`` objects representing the custom
    ///     services that your application supports.
    ///   - excludedActivityTypes: The list of services that should not be
    ///     displayed. You might exclude services that you feel are not suitable for
    ///     the content you are providing. For example, you might not want to allow
    ///     the user to print a specific image.
    ///   - onComplete: The closure to execute when user completes sharing the given
    ///     items.
    ///   - onDismiss: The closure to execute when dismissing the share sheet.
    public func shareSheet(
        isPresented: Binding<Bool>,
        items: [Any],
        activities: [UIActivity]? = nil,
        excludedActivityTypes: [UIActivity.ActivityType]? = nil,
        onComplete: ((UIActivity.ActivityType) -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        modifier(ShareSheetViewModifer(
            isPresented: isPresented,
            items: items,
            activities: activities,
            excludedActivityTypes: excludedActivityTypes,
            onComplete: onComplete,
            onDismiss: onDismiss
        ))
    }
}

// MARK: - View Modifier

private struct ShareSheetViewModifer: ViewModifier {
    var isPresented: Binding<Bool>
    var items: [Any]
    var activities: [UIActivity]?
    var excludedActivityTypes: [UIActivity.ActivityType]?
    var onComplete: ((UIActivity.ActivityType) -> Void)?
    var onDismiss: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .background(ShareSheetView(
                isPresented: isPresented,
                items: items,
                activities: activities,
                excludedActivityTypes: excludedActivityTypes,
                onComplete: onComplete,
                onDismiss: onDismiss
            ))
    }
}

// MARK: - View

private struct ShareSheetView: UIViewControllerRepresentable {
    var isPresented: Binding<Bool>
    var items: [Any]
    var activities: [UIActivity]?
    var excludedActivityTypes: [UIActivity.ActivityType]?
    var onComplete: ((UIActivity.ActivityType) -> Void)?
    var onDismiss: (() -> Void)?

    func makeUIViewController(context: Context) -> ShareSheetViewPresenter {
        .init(
            isPresented: isPresented,
            items: items,
            activities: activities,
            excludedActivityTypes: excludedActivityTypes,
            onComplete: onComplete,
            onDismiss: onDismiss
        )
    }

    func updateUIViewController(
        _ uiViewController: ShareSheetViewPresenter,
        context: Context
    ) {
        uiViewController.isPresented = isPresented
        uiViewController.presentIfNeeded()
    }
}

// MARK: - Presenter

private final class ShareSheetViewPresenter: UIViewController {
    fileprivate var isPresented: Binding<Bool>
    private let items: [Any]
    private let activities: [UIActivity]?
    private let excludedActivityTypes: [UIActivity.ActivityType]?
    private let onComplete: ((UIActivity.ActivityType) -> Void)?
    private let onDismiss: (() -> Void)?

    init(
        isPresented: Binding<Bool>,
        items: [Any],
        activities: [UIActivity]?,
        excludedActivityTypes: [UIActivity.ActivityType]?,
        onComplete: ((UIActivity.ActivityType) -> Void)?,
        onDismiss: (() -> Void)?
    ) {
        self.isPresented = isPresented
        self.items = items
        self.activities = activities
        self.excludedActivityTypes = excludedActivityTypes
        self.onComplete = onComplete
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        presentIfNeeded()
    }

    fileprivate func presentIfNeeded() {
        let isShown = presentedViewController != nil

        guard !isShown, isShown != isPresented.wrappedValue else {
            return
        }

        let vc = UIActivityViewController(
            activityItems: items,
            applicationActivities: activities
        ).apply {
            $0.excludedActivityTypes = excludedActivityTypes
            $0.popoverPresentationController?.sourceView = view
            $0.completionWithItemsHandler = { [weak self] type, completed, _, error in
                guard let strongSelf = self else { return }

                strongSelf.isPresented.wrappedValue = false

                if completed {
                    if let type = type {
                        strongSelf.onComplete?(type)
                    }
                } else {
                    strongSelf.onDismiss?()
                }
            }
        }

        present(vc, animated: true)
    }
}
