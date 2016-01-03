//
// Environment.swift
//
// Copyright © 2015 Zeeshan Mian
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

public class Environment {
    public enum Type: CustomStringConvertible {
        case Development, Staging, Production

        public var description: String {
            switch self {
                case .Development:
                    return "Development"
                case .Staging:
                    return "Staging"
                case .Production:
                    return "Production"
            }
        }
    }

    public var isDevelopment: Bool { return type == .Development }
    public var isStaging: Bool     { return type == .Staging }
    public var isProduction: Bool  { return type == .Production }

    public private(set) var type = Type.Production // Safest default

    public init() {
        #if ENVIRONMENT_Release
            type = .Production
        #elseif ENVIRONMENT_Staging
            type = .Staging
        #elseif ENVIRONMENT_Debug
            type = .Development
        #endif

        setupSharedEnvironment()

        switch type {
            case .Development:
                setupDevelopment()
            case .Staging:
                setupStaging()
            case .Production:
                setupProduction()
        }
    }

    public func setupSharedEnvironment() {}
    public func setupDevelopment() {}
    public func setupStaging() {}
    public func setupProduction() {}
}
