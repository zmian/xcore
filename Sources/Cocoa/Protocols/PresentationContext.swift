//
// PresentationContext.swift
//
// Copyright © 2017 Xcore
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

/// A type that can be initialized in multiple contexts.
///
/// The presentation context is a simple way to express how the view is being
/// displayed. The context helps manage complexity by enabling code reuse and
/// and allowing context specific logic where necessary. For example, context
/// can be used to add padding in details screen only and add tracking events
/// based on context while sharing the same code.
public protocol PresentationContext {
    typealias Kind = PresentationContextKind
    var context: Kind { get }
    init(collectionView: UICollectionView, context: Kind)
}

// MARK: - Kind

// If Swift ever allows nested types this enum can move under the
// protocol namespace as `PresentationContextKind.Kind`.
public struct PresentationContextKind: Equatable {
    public let id: Identifier<PresentationContextKind>

    public init(id: Identifier<PresentationContextKind>) {
        self.id = id
    }
}

extension PresentationContextKind: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(id: .init(rawValue: value))
    }
}

extension PresentationContextKind {
    public static var feed: PresentationContextKind {
        return "feed"
    }

    public static var detail: PresentationContextKind {
        return "detail"
    }
}
