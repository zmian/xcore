//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
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
        addCaretButton()
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

    private func addCaretButton() {
        let button = UIButton().apply {
            $0.configuration = .caret(in: .pill, text: "Hello World")
            $0.action { _ in
                print("caret button tapped")
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
