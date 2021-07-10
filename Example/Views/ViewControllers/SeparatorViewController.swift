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
        view.backgroundColor = Theme.backgroundColor
        setupContentView()
    }

    private func setupContentView() {
        let stackView = UIStackView(arrangedSubviews: [
            createSeparatorsVertical(),
            createSeparatorsHorizontal()
        ]).apply {
            $0.axis = .vertical
            $0.spacing = .s6
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .s6),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.s6),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func createSeparatorsVertical() -> UIStackView {
        UIStackView(arrangedSubviews: [
            SeparatorView(axis: .vertical),
            SeparatorView(style: .dot, axis: .vertical),
            SeparatorView(axis: .vertical, backgroundColor: .systemRed),
            SeparatorView(axis: .vertical, backgroundColor: UIColor.label.alpha(0.2)),
            SeparatorView(style: .dot, axis: .vertical, backgroundColor: .systemRed),
            SeparatorView(style: .dot, axis: .vertical, backgroundColor: UIColor.systemBlue.alpha(0.2)),
            SeparatorView(style: .dash(value: [2, 4]), axis: .vertical, backgroundColor: .label),
            SeparatorView(axis: .vertical, backgroundColor: .systemBlue, thickness: 4)
        ]).apply {
            $0.axis = .horizontal
            $0.spacing = .s6
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

        let freeSeparator = SeparatorView(backgroundColor: .systemBlue, automaticallySetThickness: false).apply {
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
            SeparatorView(backgroundColor: .systemRed),
            SeparatorView(backgroundColor: UIColor.label.alpha(0.2)),
            SeparatorView(style: .dot, backgroundColor: .systemRed),
            SeparatorView(style: .dot, backgroundColor: UIColor.systemBlue.alpha(0.2)),
            SeparatorView(style: .dash(value: [2, 5]), backgroundColor: .label),
            SeparatorView(backgroundColor: .label, thickness: 5),
            SeparatorView(style: .plain, backgroundColor: .label, thickness: 2),
            SeparatorView(style: .dot, backgroundColor: .label, thickness: 2),
            appliedSeparator,
            freeSeparator,
            bigDotsSeparator
        ]).apply {
            $0.axis = .vertical
            $0.spacing = .s6
        }
    }
}
