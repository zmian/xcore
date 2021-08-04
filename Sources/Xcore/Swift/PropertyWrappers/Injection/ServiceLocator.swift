//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// The inject property wrapper responsible for communicating with
/// `ServiceLocator` to inject given service.
///
/// **Usage**
///
/// ```swift
/// // 1. Create a service protocol
/// protocol ProfileServiceProtocol: AnyObject {
///     func avatarDidChange(_ image: UIImage)
/// }
///
/// // 2. Implement service protocol
/// class ProfileService: ProfileServiceProtocol {
///     func avatarDidChange(_ image: UIImage) {
///         // ...
///     }
/// }
///
/// // 3. Register service with service locator
/// final class AppDelegate: UIResponder, UIApplicationDelegate {
///     var window: UIWindow?
///
///     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
///         ServiceLocator.register(ProfileService(), for: ProfileServiceProtocol.self)
///         return true
///     }
/// }
///
/// // 4. Usage
/// class Model {
///     // Use the @Inject property wrapper and the service locator will resolve the
///     // service.
///     @Inject private var profileService: ProfileServiceProtocol
///
///     func avatarChanged(_ image: UIImage) {
///         profileService.avatarDidChange(image)
///     }
/// }
/// ```
@propertyWrapper
public struct Inject<Service> {
    public init() {}

    public var wrappedValue: Service {
        ServiceLocator.resolve()
    }
}

// MARK: - ServiceLocator

/// The service locator, responsible for registering and resolving services.
///
/// **Usage**
///
/// ```swift
/// // 1. Create a service protocol
/// protocol ProfileServiceProtocol: AnyObject {
///     func avatarDidChange(_ image: UIImage)
/// }
///
/// // 2. Implement service protocol
/// class ProfileService: ProfileServiceProtocol {
///     func avatarDidChange(_ image: UIImage) {
///         // ...
///     }
/// }
///
/// // 3. Register service with service locator
/// final class AppDelegate: UIResponder, UIApplicationDelegate {
///     var window: UIWindow?
///
///     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
///         ServiceLocator.register(ProfileService(), for: ProfileServiceProtocol.self)
///         return true
///     }
/// }
///
/// // 4. Usage
/// class Model {
///     // Use the @Inject property wrapper and the service locator will resolve the
///     // service.
///     @Inject private var profileService: ProfileServiceProtocol
///
///     func avatarChanged(_ image: UIImage) {
///         profileService.avatarDidChange(image)
///     }
/// }
/// ```
public enum ServiceLocator {
    private static var services: [ObjectIdentifier: Any] = [:]

    public static func register<T>(_ service: T, for type: T.Type) {
        let key = ObjectIdentifier(type)
        services[key] = service
    }

    fileprivate static func resolve<T>() -> T {
        let key = ObjectIdentifier(T.self)

        guard let service = services[key] as? T else {
            fatalError("Failed to resolve service '\(T.self)'")
        }

        return service
    }
}
