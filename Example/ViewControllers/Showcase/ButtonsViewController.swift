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
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Buttons"
        view.backgroundColor = Theme.backgroundColor

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .maximumPadding * 2),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.maximumPadding * 2),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        addCalloutButton()
        addCaretButton()
        addPlainButton()
        addSystemButton()
    }

    private func addCalloutButton() {
        let button = UIButton().apply {
            $0.text = "Hello World"
            $0.action { _ in
                print("callout button tapped")
            }
        }

        stackView.addArrangedSubview(button)
    }

    private func addCaretButton() {
        let button = UIButton().apply {
            $0.attributedText = NSAttributedString(
                string: "Continue",
                font: .app(.body),
                color: .systemPink,
                direction: .forward
            )
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
