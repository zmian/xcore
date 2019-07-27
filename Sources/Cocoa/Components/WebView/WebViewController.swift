//
// WebViewController.swift
//
// Copyright © 2016 Xcore
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
import WebKit

open class WebViewController: UIViewController {
    public private(set) lazy var webView: WKWebView = {
        guard let configuration = configuration else {
            return WKWebView()
        }

        return WKWebView(frame: .zero, configuration: configuration)
    }()

    private var shareFileInteractor: UIDocumentInteractionController?
    public var configuration: WKWebViewConfiguration?
    public var style: Style = .default
    private let toolbar = WebViewToolbar()
    private var autofill: Autofill?
    public let progressBar = ProgressView()
    public private(set) var loader: ViewMaskable?

    open var loaderClass: ViewMaskable.Type {
        return style.loaderClass
    }

    /// The default value is `0`.
    public var loaderDismissDelayInterval: TimeInterval = 0

    /// A boolean property to autofill forms if we support autofilling for the
    /// current url.
    ///
    /// The default value is `false`.
    public var isAutofillEnabled = false {
        didSet {
            getAutofillScriptIfNeeded()
        }
    }

    /// A boolean property to hide the native back button when loader is active.
    ///
    /// The default value is `false`.
    public var isBackButtonHiddenWhenLoaderVisible = false

    /// A boolean property to only show the progress bar when loader is active.
    ///
    /// The default value is `false`.
    public var isProgressBarOnlyVisibleWhenLoaderVisible = false

    /// A boolean property to override the native back button with done button.
    ///
    /// The default value is `false`.
    public var isBackButtonReplacedWithDoneButton = false {
        didSet {
            isSwipeBackGestureEnabled = !isBackButtonReplacedWithDoneButton
        }
    }

    /// A boolean property to override the native back button to pop web pages
    /// automatically.
    ///
    /// The default value is `false`.
    public var automaticallyOverrideBackButtonToPopWebPages = false

    public var isToolbarHidden = true {
        didSet {
            updateToolbarIfNeeded()
        }
    }

    public var url: URL? {
        didSet {
            show()
        }
    }

    public var request: URLRequest? {
        didSet {
            show()
        }
    }

    public init(configuration: WKWebViewConfiguration) {
        super.init(nibName: nil, bundle: nil)
        self.configuration = configuration
    }

    public init(url: URL? = nil, style: Style? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
        self.style = style ?? .default
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        title = style.title
        setupWebView()
        setupToolbar()
        setupProgressBar()
        addKVOObservers()
        overrideBackButtonWithDoneIfNeeded()
        show()
        didLoadView?()
    }

    private func setupWebView() {
        view.addSubview(webView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.anchor.edges.equalToSuperview()
    }

    private func setupToolbar() {
        view.addSubview(toolbar)
        toolbar.anchor.make {
            if prefersTabBarHidden {
                $0.horizontally.equalToSuperview()
                $0.bottom.equalToSuperview()
            } else {
                $0.horizontally.equalToSuperviewSafeArea()
                $0.bottom.equalToSuperviewSafeArea()
            }
        }

        toolbar.didTapButton { [weak self] button in
            guard let strongSelf = self else { return }

            switch button {
                case .back:
                    strongSelf.webView.goBack()
                case .forward:
                    strongSelf.webView.goForward()
            }
        }

        updateToolbarIfNeeded()
    }

    private func updateToolbarIfNeeded() {
        guard isViewLoaded else {
            return
        }

        toolbar.isHidden = isToolbarHidden
        toolbar.backButton.isEnabled = webView.canGoBack
        toolbar.forwardButton.isEnabled = webView.canGoForward
        updateContentInset()
    }

    private func updateContentInset() {
        let bottomInset = isToolbarHidden ? 0 : WebViewToolbar.height
        webView.scrollView.contentInset.bottom = bottomInset
        webView.scrollView.scrollIndicatorInsets = webView.scrollView.contentInset
    }

    open override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        toolbar.updateHeight(isTabBarHidden: prefersTabBarHidden)
    }

    private func setupProgressBar() {
        view.addSubview(progressBar)
        progressBar.anchor.make {
            $0.horizontally.equalToSuperview()
            $0.top.equalToSuperview().inset(AppConstants.statusBarPlusNavBarHeight)
        }
        progressBar.isHidden = !webView.isLoading
        style.configureProgressBar(progressBar)
    }

    private func show() {
        guard isViewLoaded else {
            return
        }

        setLoaderHidden(false)

        let urlRequest: URLRequest

        if let url = self.url {
            urlRequest = URLRequest(url: url)
        } else if let request = self.request {
            urlRequest = request
        } else {
            return
        }

        if urlRequest.url?.pathExtension == "pdf" {
            addShareOption(url: urlRequest)
        }

        webView.load(urlRequest)
    }

    open override var preferredNavigationBarBackground: Chrome.Style {
        return style.preferredNavigationBarBackground
    }

    open override var preferredNavigationBarTintColor: UIColor {
        if let loader = loader {
            return loader.preferredNavigationBarTintColor
        }

        return super.preferredNavigationBarTintColor
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if let loader = loader {
            return loader.preferredStatusBarStyle
        }

        return super.preferredStatusBarStyle
    }

    // MARK: KVO

    private var canGoBackKvoToken: NSKeyValueObservation?
    private var canGoForwardKvoToken: NSKeyValueObservation?
    private var isLoadingKvoToken: NSKeyValueObservation?

    private func addKVOObservers() {
        canGoBackKvoToken = webView.observe(\.canGoBack, options: .new) { [weak self] webView, _ in
            self?.updateState()
        }

        canGoForwardKvoToken = webView.observe(\.canGoForward, options: .new) { [weak self] webView, _ in
            self?.updateState()
        }

        isLoadingKvoToken = webView.observe(\.isLoading, options: .new) { [weak self] webView, _ in
            self?.updateState()
        }
    }

    private func updateState() {
        toolbar.backButton.isEnabled = webView.canGoBack
        toolbar.forwardButton.isEnabled = webView.canGoForward
        if !isProgressBarOnlyVisibleWhenLoaderVisible {
            progressBar.isHidden = !webView.isLoading
        }

        autofillFormsIfNeeded()
    }

    deinit {
        #if DEBUG
            print("\(self) deinit")
        #endif
    }

    open func autofillToken(completionHandler: @escaping (Autofill?) -> Void) {

    }

    // MARK: Hooks

    private var configureLoader: ((_ loader: ViewMaskable) -> Void)?
    public func configureLoader(_ callback: @escaping (_ loader: ViewMaskable) -> Void) {
        configureLoader = callback
    }

    private var didLoadView: (() -> Void)?
    public func didLoadView(_ callback: @escaping () -> Void) {
        didLoadView = callback
    }

    private var didFinishLoading: (() -> Void)?
    public func didFinishLoading(_ callback: @escaping () -> Void) {
        didFinishLoading = callback
    }

    private var didTapDoneButton: ((_ url: URL?) -> Void)?
    public func didTapDoneButton(_ callback: @escaping (_ url: URL?) -> Void) {
        didTapDoneButton = callback
    }
}

extension WebViewController {
    private func setLoaderHidden(_ hide: Bool) {
        guard isViewLoaded else {
            return
        }

        setNeedsChromeAppearanceUpdate()

        RunLoop.cancelPreviousPerformRequests(withTarget: self)

        if !hide && isBackButtonHiddenWhenLoaderVisible {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "")
        }

        if hide && loader == nil {
            return
        }

        if hide {
            delay(by: loaderDismissDelayInterval) { [weak self] in
                guard let strongSelf = self else { return }
                if strongSelf.isProgressBarOnlyVisibleWhenLoaderVisible {
                    strongSelf.progressBar.isHidden = hide
                }

                self?.loader?.dismiss { [weak self] in
                    guard let strongSelf = self, strongSelf.isBackButtonHiddenWhenLoaderVisible else { return }
                    strongSelf.navigationItem.leftBarButtonItem = nil
                    strongSelf.loader = nil
                    strongSelf.setNeedsChromeAppearanceUpdate()
                }
            }
            return
        } else {
            if isProgressBarOnlyVisibleWhenLoaderVisible {
                progressBar.isHidden = hide
            }
        }

        if !hide && loader == nil {
            loader = loaderClass.add(to: view)
            view.bringSubviewToFront(progressBar)
            style.configureLoader?(loader!)
            configureLoader?(loader!)
            setNeedsChromeAppearanceUpdate()
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        setLoaderHidden(!webView.isLoading)
        didFinishLoading?()
    }

    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        style.evaluateJavaScript(webView)
        decisionHandler(.allow)
    }

    open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        overrideBackButtonIfNeeded()
        style.evaluateJavaScript(webView)
    }

    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        debugPrint(error)
    }

    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint(error)
    }
}

extension WebViewController: WKUIDelegate {
    open func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // Open new window links in the same view.
        if navigationAction.targetFrame == nil || !navigationAction.targetFrame!.isMainFrame {
            webView.load(navigationAction.request)
        }

        return nil
    }

    open func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return false
    }

    // MARK: - JavaScript Alert Support

#warning("Add support for alerts")
/*
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        // TODO: Handle alert panel
    }

    open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        // TODO: Handle confirm panel
    }

    open func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        // TODO: Handle prompt
    }
*/
}

extension WebViewController: WKScriptMessageHandler {
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    }
}

extension WebViewController {
    private func overrideBackButtonIfNeeded() {
        if isBackButtonReplacedWithDoneButton {
            return
        }

        guard automaticallyOverrideBackButtonToPopWebPages, webView.canGoBack else {
            navigationItem.leftBarButtonItem = nil
            return
        }

        let backBarButtonItem = UIBarButtonItem(assetIdentifier: .navigationBarBackArrow) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.webView.goBack()
        }

        backBarButtonItem.imageInsets = UIEdgeInsets(top: 7, left: -8, bottom: 0, right: 0)
        backBarButtonItem.tintColor = preferredNavigationBarTintColor
        navigationItem.leftBarButtonItem = backBarButtonItem
    }

    private func overrideBackButtonWithDoneIfNeeded() {
        guard isBackButtonReplacedWithDoneButton else {
            navigationItem.leftBarButtonItem = nil
            return
        }

        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.didTapDoneButton?(strongSelf.webView.url)
            strongSelf.navigationController?.popViewController(animated: true)
        }

        doneBarButtonItem.accessibilityIdentifier = "webViewController doneButton"
        navigationItem.leftBarButtonItem = doneBarButtonItem
    }
}

// MARK: - Autofill

extension WebViewController {
    private func autofillFormsIfNeeded() {
        // Only autofill if we are on the new page. If user navigates to the previous
        // page then don't autofill.
        guard !webView.isLoading, !webView.canGoForward, isAutofillEnabled else {
            return
        }

        autofill?.execute(webView)
    }

    private func getAutofillScriptIfNeeded() {
        guard isAutofillEnabled, autofill == nil else { return }

        autofillToken { [weak self] autofill in
            self?.autofill = autofill
        }
    }
}

// MARK: - Preview PDF files

extension WebViewController: UIDocumentInteractionControllerDelegate {
    private func addShareOption(url: URLRequest) {
        guard
            let docsUrl = Bundle.url(for: .documentDirectory),
            let nameUrl = url.url
        else {
            return
        }

        let fileUrl = docsUrl.appendingPathComponent(style.saveFileNameConvention(nameUrl))

        guard !FileManager.default.fileExists(atPath: fileUrl.path) else {
            return addShareFileButton(fileUrl: fileUrl)
        }

        let indicator = UIActivityIndicatorView(style: .gray).apply {
            $0.startAnimating()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: indicator)

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let strongSelf = self, let data = data else {
                self?.navigationItem.rightBarButtonItem = nil
                return
            }

            do {
                try data.write(to: fileUrl)
                strongSelf.addShareFileButton(fileUrl: fileUrl)
            } catch {
                strongSelf.navigationItem.rightBarButtonItem = nil
            }
        }.resume()
    }

    private func addShareFileButton(fileUrl: URL) {
        let shareItem = UIBarButtonItem(assetIdentifier: .moreIcon) { [weak self] _ in
            self?.shareLocalFile(url: fileUrl)
        }
        navigationItem.rightBarButtonItem = shareItem
    }

    private func shareLocalFile(url: URL) {
        shareFileInteractor = UIDocumentInteractionController(url: url).apply {
            $0.delegate = self
            $0.presentOptionsMenu(from: .zero, in: view, animated: true)
        }
    }
}
