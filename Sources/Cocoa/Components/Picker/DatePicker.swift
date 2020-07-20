//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

final class DatePicker: DrawerScreen.Content, Appliable {
    private var initialDate: Date?
    private var didChangeValue: ((Date?) -> Void)?
    private var caller: Any?

    var drawerContentView: UIView {
        stackView
    }

    private lazy var stackView = UIStackView(arrangedSubviews: [
        toolbar,
        pickerView
    ]).apply {
        $0.axis = .vertical
    }

    private lazy var toolbar = InputToolbar().apply {
        $0.backgroundColor = .clear
        $0.didTapDone { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.didChangeValue?(strongSelf.pickerView.date)
            DrawerScreen.dismiss()
        }

        $0.didTapCancel { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.didChangeValue?(strongSelf.initialDate)
            DrawerScreen.dismiss()
            UIAccessibility.post(notification: .layoutChanged, argument: strongSelf.caller)
        }

        $0.didTapDone { [weak self] in
            DrawerScreen.dismiss()
            UIAccessibility.post(notification: .layoutChanged, argument: self?.caller)
        }
    }

    private lazy var pickerView = UIDatePicker().apply {
        $0.datePickerMode = .date
        $0.backgroundColor = .clear
        $0.addAction(.valueChanged) { [weak self] sender in
            self?.didChangeValue?(sender.date)
        }
    }

    static func present(
        initialValue date: Date? = nil,
        configuration: Configuration<UIDatePicker>? = nil,
        caller: Any? = nil,
        _ callback: @escaping (Date?) -> Void
    ) {
        let picker = DatePicker().apply {
            $0.initialDate = date
            $0.pickerView.date = date ?? Date()
            $0.caller = caller
            $0.didChangeValue = callback
            if let configuration = configuration {
                $0.pickerView.apply(configuration)
            }
        }

        DrawerScreen.present(picker)
    }
}
