//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final public class PickerButton<T: PickerOptionsEnum>: UIButton {
    public private(set) var value: T!
    private var didTap: ((_ currentValue: T) -> Void)?
    private var didChange: ((_ oldValue: T, _ newValue: T) -> Void)?

    public convenience init() {
        self.init(frame: .zero)
    }

    public convenience init(_ value: T) {
        self.init()
        configure(value)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        configuration = .caret(text: "-", direction: .down)
        setupActionHandler()
    }

    private func setupActionHandler() {
        action { [weak self] _ in
            guard
                let strongSelf = self,
                let windowOptional = UIApplication.sharedOrNil?.delegate?.window,
                let window = windowOptional
            else {
                return
            }

            window.endEditing(true)
            strongSelf.didTap?(strongSelf.value)
            let oldValue = strongSelf.value!
            Picker.List.present(selected: strongSelf.value) { [weak self] newValue in
                guard let strongSelf = self else { return }
                strongSelf.configure(newValue)
                strongSelf.didChange?(oldValue, newValue)
            }
        }
    }

    public func configure(_ value: T) {
        self.value = value
        accessibilityValue = value.title
        configuration = .caret(text: value.title, direction: .down)
        sizeToFit()
    }

    /// A callback for listening to picker tapped event.
    ///
    /// - Note: This is a cancellable action, meaning user can opt-out from changing
    /// the value. If you require callback only when the value actually changes,
    /// use `didChange(_:)` closure.
    ///
    /// - Parameter callback: The callback invoked whenever picker value is tapped.
    public func didTap(_ callback: @escaping (_ currentValue: T) -> Void) {
        didTap = callback
    }

    /// A callback for listening to picker value changed event.
    ///
    /// - Note: This is only invoked when the value actually changes. If you require
    /// callback whenever user taps the picker, use `didTap(_:)` closure.
    ///
    /// - Parameter callback: The callback invoked whenever picker value is changed.
    public func didChange(_ callback: @escaping (_ oldValue: T, _ newValue: T) -> Void) {
        didChange = callback
    }
}
