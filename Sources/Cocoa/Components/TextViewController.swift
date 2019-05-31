//
// TextViewController.swift
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

open class TextViewController: XCScrollViewController {
    private var textLabelConstraints: NSLayoutConstraint.Edges!

    public let textLabel = LabelTextView()

    /// The distance that the text is inset from the enclosing scroll view.
    /// The default value is `UIEdgeInsets(.defaultPadding)`.
    open var contentInset = UIEdgeInsets(.defaultPadding) {
        didSet {
            textLabelConstraints.update(from: contentInset)
        }
    }

    /// The text that will be displayed.
    ///
    /// ```swift
    /// let vc = TextViewController()
    /// vc.text = "Some text..."
    /// navigationController.pushViewController(vc, animated: true)
    /// ```
    open var text: StringRepresentable = "" {
        didSet {
            textLabel.setText(text)
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupTextLabel()
    }

    deinit {
        Console.info("deinit")
    }

    // MARK: - Setup Methods

    private func setupTextLabel() {
        view.backgroundColor = .white
        scrollView.alwaysBounceVertical = true
        scrollView.addSubview(textLabel)

        textLabelConstraints = NSLayoutConstraint.Edges(
            textLabel.anchor.edges.equalToSuperview().inset(contentInset).priority(.defaultHigh).constraints
        )

        if LabelTextView.defaultDidTapUrlHandler == nil {
            // Set the `didTapUrl` handler if default handler isn't assigned.
            textLabel.didTapUrl { [weak self] url, text in
                guard let strongSelf = self else { return }
                open(url: url, from: strongSelf)
            }
        }
    }

    /// Sets text from the specified file name.
    ///
    /// ```swift
    /// let vc = TextViewController()
    /// vc.setText("Terms.txt")
    /// navigationController.pushViewController(vc, animated: true)
    /// ```
    ///
    /// - Parameters:
    ///   - filename: The file name.
    ///   - bundle: The bundle containing the specified file name. If you specify
    ///             `nil`, this method looks in the main bundle of the current
    ///             application. The default value is `nil`.
    open func setText(_ filename: String, bundle: Bundle? = nil) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let name = filename.lastPathComponent.deletingPathExtension
            let ext = filename.pathExtension
            let bundle = bundle ?? Bundle.main

            guard
                let path = bundle.path(forResource: name, ofType: ext),
                let content = try? String(contentsOfFile: path, encoding: .utf8)
            else {
                return
            }

            DispatchQueue.main.async { [weak self] in
                self?.text = content
            }
        }
    }
}
