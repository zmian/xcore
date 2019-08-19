//
// SeparatorViewController.swift
//
// Copyright © 2019 Xcore
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

final class SeparatorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Separators"
        view.backgroundColor = .white
        setupContentView()
    }

    private func setupContentView() {
        let stackView = UIStackView(arrangedSubviews: [
            createSeparatorsVertical(),
            createSeparatorsHorizontal()
        ]).apply {
            $0.axis = .vertical
            $0.spacing = .maximumPadding
        }

        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperviewSafeArea().inset(.maximumPadding)
            $0.centerY.equalToSuperviewSafeArea()
        }
    }

    private func createSeparatorsVertical() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            SeparatorView(axis: .vertical),
            SeparatorView(style: .dot, axis: .vertical),
            SeparatorView(axis: .vertical, backgroundColor: .red),
            SeparatorView(axis: .vertical, backgroundColor: UIColor.black.alpha(0.2)),
            SeparatorView(style: .dot, axis: .vertical, backgroundColor: .red),
            SeparatorView(style: .dot, axis: .vertical, backgroundColor: UIColor.blue.alpha(0.2)),
            SeparatorView(style: .dash(value: [2, 4]), axis: .vertical, backgroundColor: .black),
            SeparatorView(axis: .vertical, backgroundColor: .blue, thickness: 4)
        ]).apply {
            $0.axis = .horizontal
            $0.spacing = .maximumPadding
            $0.distribution = .equalSpacing
            $0.snp.makeConstraints {
                $0.height.equalTo(200)
            }
        }
    }

    private func createSeparatorsHorizontal() -> UIStackView {
        let appliedSeparator = SeparatorView().apply {
            $0.lineCap = .square
            $0.thickness = 10
            $0.style = .dash(value: [1, 15, 10, 20])
        }

        let freeSeparator = SeparatorView(backgroundColor: .blue, automaticallySetThickness: false).apply {
            $0.snp.makeConstraints { make in
                make.height.equalTo(12)
            }
        }

        let bigDotsSeparator = SeparatorView(backgroundColor: .gray).apply {
            $0.thickness = 10
            $0.style = .dot
        }

        return UIStackView(arrangedSubviews: [
            SeparatorView(),
            SeparatorView(style: .dot),
            SeparatorView(backgroundColor: .red),
            SeparatorView(backgroundColor: UIColor.black.alpha(0.2)),
            SeparatorView(style: .dot, backgroundColor: .red),
            SeparatorView(style: .dot, backgroundColor: UIColor.blue.alpha(0.2)),
            SeparatorView(style: .dash(value: [2, 5]), backgroundColor: .black),
            SeparatorView(backgroundColor: .black, thickness: 5),
            SeparatorView(style: .plain, backgroundColor: .black, thickness: 2),
            SeparatorView(style: .dot, backgroundColor: .black, thickness: 2),
            appliedSeparator,
            freeSeparator,
            bigDotsSeparator
        ]).apply {
            $0.axis = .vertical
            $0.spacing = .maximumPadding
        }
    }
}
