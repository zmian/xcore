//
// ButtonsViewController.swift
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

final class ButtonsViewController: UIViewController {
    private let stackView = UIStackView().apply {
        $0.axis = .vertical
        $0.spacing = .maximumPadding
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Buttons"
        view.backgroundColor = .white

        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(.maximumPadding * 2)
            make.centerY.equalToSuperview()
        }

        addCalloutButton()
        addPlainButton()
        addSystemButton()
    }

    private func addCalloutButton() {
        let button = UIButton().apply {
            $0.configuration = .callout
            $0.text = "Hello World"
            $0.action { _ in
                print("callout button tapped")
            }
        }

        stackView.addArrangedSubview(button)
    }

    private func addPlainButton() {
        let button = UIButton().apply {
            $0.text = "Hello World"
            $0.textColor = .red
            $0.action { _ in
                print("plain button tapped")
            }
        }

        stackView.addArrangedSubview(button)
    }

    private func addSystemButton() {
        let button = UIButton(type: .contactAdd).apply {
            $0.action { _ in
                print("Contact add button tapped")
            }
        }

        stackView.addArrangedSubview(button)
    }
}
