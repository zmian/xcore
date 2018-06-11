//
// ButtonsViewController.swift
//
// Copyright © 2018 Zeeshan Mian
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
import Xcore

final class ButtonsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        exampleButtonType()
        examplePlainButton()
    }

    private func examplePlainButton() {
        let button = UIButton()
        button.text = "Hello World"
        button.textColor = .red
        button.sizeToFit()
        view.addSubview(button)

        button.addAction(.touchUpInside) { _ in
            print("plain button tapped")
        }

        button.center = CGPoint(x: 100, y: 300)
    }

    private func exampleButtonType() {
        // UIButtonType when the button is .contactAdd then don't apply any of the custom background color etc

        let button = UIButton(type: .contactAdd)
        view.addSubview(button)

        button.addAction(.touchUpInside) { _ in
            print("Contact add button tapped")
        }

        button.center = CGPoint(x: 100, y: 400)
    }
}
