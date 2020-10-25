//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
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
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .maximumPadding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.maximumPadding),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func createSeparatorsVertical() -> UIStackView {
        UIStackView(arrangedSubviews: [
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
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 200).activate()
        }
    }

    private func createSeparatorsHorizontal() -> UIStackView {
        let appliedSeparator = SeparatorView().apply {
            $0.lineCap = .square
            $0.thickness = 10
            $0.style = .dash(value: [1, 15, 10, 20])
        }

        let freeSeparator = SeparatorView(backgroundColor: .blue, automaticallySetThickness: false).apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 12).activate()
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
