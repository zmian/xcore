//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A marker protocol for ``DependencyVariantKey`` value to ensure user provides
/// both `live` and `failing` versions so that in the testing environment we can
/// set all dependency variants to `failing` by default.
///
/// **Usage**
///
/// ```swift
/// class MyTests: TestCase {
///     // Reset all of the variants to failing.
///     func setUp() async throws {
///         DependencyValues.resetAll(toVariant: .failing)
///     }
///
///     func testPasteboard() throws {
///         DependencyValues.set(\.pasteboard, .stub)
///         // ... now test pasteboard
///     }
/// }
/// ```
///
/// This ensures you are required to override the dependencies to are expected
/// to be testing.
public protocol DependencyVariant {
    /// The live value for the dependency.
    static var live: Self { get }

    #if DEBUG
    /// The failing value for the dependency.
    ///
    /// ``DependencyValues.resetAll(toVariant: .failing)`` call this method in tests
    /// to automatically set all of the variant based dependencies to failing in
    /// test target, thus requiring you to explicitly set them to non-failing
    /// variant before attempting to test components.
    static var failing: Self { get }
    #endif
}

// MARK: - DependencyVariantKey

/// A key for accessing values in the ``DependencyValues`` container.
///
/// You can create custom dependency values by extending the
/// ``DependencyValues`` structure with new properties. First declare a new
/// dependency key type and specify a value for the required ``currentValue``
/// property:
///
/// ```swift
///
/// // 1. Create dependency
/// struct Pasteboard {
///     let copy: (String) -> Void
/// }
///
/// // 2. Create dependency variants
/// extension Pasteboard: DependencyVariant {
///     static var live: Self {
///         .init {
///             UIPasteboard.general.string = $0
///         }
///     }
///
///     static var failing: Self {
///         .init { _ in
///             XCTFail("Pasteboard.copy is unimplemented")
///         }
///     }
/// }
///
/// // 3. Create dependency variants key
/// private struct PasteboardClientKey: DependencyVariantKey {
///     static let defaultValue: Pasteboard = .failing
/// }
///
/// // 4. Create dependency values property
/// extension DependencyValues {
///     var pasteboard: Pasteboard {
///         get { self[PasteboardClientKey.self] }
///         set { self[PasteboardClientKey.self] = newValue }
///     }
/// }
/// ```
public protocol DependencyVariantKey: DependencyKey where Value: DependencyVariant {}

// MARK: - Reset to variant

extension DependencyValues {
    public enum Variant {
        case live
        #if DEBUG
        case failing
        #endif
    }

    /// Reset all ``DependencyValues`` to given variant.
    public static func resetAll(toVariant variant: Variant) {
        for (key, value) in shared.storage {
            if let value = value as? DependencyVariant {
                switch variant {
                    case .live:
                        shared.storage[key] = type(of: value).live
                    #if DEBUG
                    case .failing:
                        shared.storage[key] = type(of: value).failing
                    #endif
                }
            }
        }
    }
}
