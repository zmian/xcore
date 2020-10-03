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
        }

        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(CGFloat.maximumPadding)
            $0.centerY.equalToSuperview()
        }
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
