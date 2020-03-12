//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

public protocol Configurable {
    associatedtype ObjectType
    func configure(_ object: ObjectType)
}

// MARK: - AnyConfigurable

public struct AnyConfigurable<T> {
    public let base: Any
    private let _configure: (_ object: T) -> Void

    public init<C: Configurable>(_ base: C) where C.ObjectType == T {
        self.base = base
        self._configure = {
            base.configure($0)
        }
    }
}

extension AnyConfigurable: Configurable {
    public func configure(_ object: T) {
        _configure(object)
    }
}
