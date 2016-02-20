//
// TextViewController.swift
//
// Copyright © 2016 Zeeshan Mian
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
import MDHTMLLabel

public class TextViewController: XCScrollViewController, MDHTMLLabelDelegate {
    public private(set) lazy var textLabel: MDHTMLLabel = {
        var textLabel                  = MDHTMLLabel()
        textLabel.delegate             = self
        textLabel.font                 = UIFont.systemFont(UIFont.Size.Small)
        textLabel.textColor            = UIColor.darkGrayColor()
        textLabel.lineBreakMode        = .ByWordWrapping
        textLabel.numberOfLines        = 0
        textLabel.linkAttributes       = [NSForegroundColorAttributeName: textLabel.tintColor]
        textLabel.activeLinkAttributes = [NSForegroundColorAttributeName: textLabel.tintColor]
        textLabel.lineHeightMultiple   = 1.1
        return textLabel
    }()

    /// The distance that the text is inset from the enclosing scroll view.
    /// The default value is `UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)`.
    public var contentInset = UIEdgeInsets(all: 15)

    /// A convenience property to set view’s background image.
    /// The default value is `nil`, which means apply view's background color.
    public var backgroundImage: UIImage?

    /// The text that will be displayed.
    public var text = "Sample Text" {
        didSet {
            textLabel.htmlText = text
        }
    }

    /// Sets text from the specified file name.
    ///
    /// ```
    /// let vc = TextViewController()
    /// vc.setText("Terms.txt")
    /// navigationController.pushViewController(vc, animated: true)
    /// ```
    ///
    /// - parameter filename: The file name.
    /// - parameter bundle:   The bundle containing the specified file name. If you specify nil,
    ///   this method looks in the main bundle of the current application. The default value is `nil`.
    public func setText(filename: String, bundle: NSBundle? = nil) {
        dispatch.async.bg(.UserInitiated) {[weak self] in
            guard let weakSelf = self else { return }

            let name   = filename.lastPathComponent.stringByDeletingPathExtension
            let ext    = filename.pathExtension
            let bundle = bundle ?? NSBundle.mainBundle()

            if let path = bundle.pathForResource(name, ofType: ext), content = try? String(contentsOfFile: path, encoding: NSUTF8StringEncoding) {
                dispatch.async.main {
                    weakSelf.text = content
                }
            }
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTextLabel()
    }

    deinit {
        console.info("deinit")
        textLabel.delegate = nil
    }

    // MARK: Setup Methods

    private func setupTextLabel() {
        textLabel.htmlText              = text
        scrollView.alwaysBounceVertical = true
        scrollView.addSubview(textLabel)
        NSLayoutConstraint.constraintsForViewToFillSuperview(textLabel, padding: contentInset).activate()

        if let backgroundImage = backgroundImage?.CGImage {
            view.layer.contents = backgroundImage
        }
    }

    public func HTMLLabel(label: MDHTMLLabel, didSelectLinkWithURL URL: NSURL) {
        openURL(self, url: URL)
    }
}
