//
// Environment.swift
//
// Copyright © 2015 Xcore
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

open class Environment {
    public enum EnvironmentType: CustomStringConvertible {
        case development, staging, production

        public var description: String {
            switch self {
                case .development:
                    return "Development"
                case .staging:
                    return "Staging"
                case .production:
                    return "Production"
            }
        }
    }

    open var isDevelopment: Bool {
        return type == .development
    }

    open var isStaging: Bool {
        return type == .staging
    }

    open var isProduction: Bool {
        return type == .production
    }

    open private(set) var type: EnvironmentType = .production // Safest default

    public init() {
        #if XCORE_ENVIRONMENT_Release
            type = .production
        #elseif XCORE_ENVIRONMENT_Staging
            type = .staging
        #elseif XCORE_ENVIRONMENT_Debug
            type = .development
        #endif

        setupSharedEnvironment()

        switch type {
            case .development:
                setupDevelopment()
            case .staging:
                setupStaging()
            case .production:
                setupProduction()
        }
    }

    open func setupSharedEnvironment() {}
    open func setupDevelopment() {}
    open func setupStaging() {}
    open func setupProduction() {}
}
