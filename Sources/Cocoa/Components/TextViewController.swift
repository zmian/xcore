//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
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

    // MARK: - Setup Methods

    private func setupTextLabel() {
        view.backgroundColor = Theme.current.backgroundColor
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

    /// Sets text from the specified filename.
    ///
    /// ```swift
    /// let vc = TextViewController()
    /// vc.setText("Terms.txt")
    /// navigationController.pushViewController(vc, animated: true)
    /// ```
    ///
    /// - Parameters:
    ///   - filename: The filename.
    ///   - bundle: The bundle containing the specified filename. The default value
    ///     is `.main`.
    ///   - transform: A block to transform the text once it's been parsed.
    open func setText(
        _ filename: String,
        bundle: Bundle = .main,
        _ transform: ((String) -> StringRepresentable)? = nil
    ) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let name = filename.lastPathComponent.deletingPathExtension
            let ext = filename.pathExtension

            guard
                let path = bundle.path(forResource: name, ofType: ext),
                let content = try? String(contentsOfFile: path, encoding: .utf8)
            else {
                return
            }

            let finalContent = transform?(content) ?? content

            DispatchQueue.main.async { [weak self] in
                self?.text = finalContent
            }
        }
    }
}
