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
        view.backgroundColor = Theme.current.backgroundColor
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
            SeparatorView(axis: .vertical, backgroundColor: .systemRed),
            SeparatorView(axis: .vertical, backgroundColor: .systemPurple),
            SeparatorView(style: .dot, axis: .vertical, backgroundColor: .systemRed),
            SeparatorView(style: .dot, axis: .vertical, backgroundColor: .systemBlue),
            SeparatorView(style: .dash(value: [2, 4]), axis: .vertical, backgroundColor: .systemPurple),
            SeparatorView(axis: .vertical, backgroundColor: .systemBlue, thickness: 4)
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

        let freeSeparator = SeparatorView(backgroundColor: .systemBlue, automaticallySetThickness: false).apply {
            $0.snp.makeConstraints { make in
                make.height.equalTo(12)
            }
        }

        let bigDotsSeparator = SeparatorView(backgroundColor: .systemGreen).apply {
            $0.thickness = 10
            $0.style = .dot
        }

        return UIStackView(arrangedSubviews: [
            SeparatorView(),
            SeparatorView(style: .dot),
            SeparatorView(backgroundColor: .systemRed),
            SeparatorView(backgroundColor: .systemPurple),
            SeparatorView(style: .dot, backgroundColor: .systemRed),
            SeparatorView(style: .dot, backgroundColor: .systemBlue),
            SeparatorView(style: .dash(value: [2, 5]), backgroundColor: .systemPurple),
            SeparatorView(backgroundColor: .systemPurple, thickness: 5),
            SeparatorView(style: .plain, backgroundColor: .systemPurple, thickness: 2),
            SeparatorView(style: .dot, backgroundColor: .systemPurple, thickness: 2),
            appliedSeparator,
            freeSeparator,
            bigDotsSeparator
        ]).apply {
            $0.axis = .vertical
            $0.spacing = .maximumPadding
        }
    }
}
