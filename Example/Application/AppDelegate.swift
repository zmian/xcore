//
// AppDelegate.swift
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Theme.start()
        return true
    }
}
