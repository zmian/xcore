//
// Collectionify.swift
//
// Copyright © 2016 Zeeshan Mian
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

/// A convenience wrapper to turn single object fetcher into collection fetcher.
///
/// - parameter fetcher:  A fetcher function that is executed with each of the `param`.
/// - parameter params:   An array of parameters to pass to the fetcher.
/// - parameter callback: The block to invoked when we have th results of all the `params` by calling `fetcher`.
public func collectionify<Parameter, Result>(_ fetcher: @escaping (_ param: Parameter, _ callback: (_ object: Result?) -> Void) -> Void, params: [Parameter], callback: @escaping (_ objects: [Result]) -> Void) {
    var objects = [Result]()
    var fetchedCount = 0

    params.forEach {
        fetcher($0) { object in
            fetchedCount += 1

            if let object = object {
                objects.append(object)
            }

            if fetchedCount == params.count {
                callback(objects)
            }
        }
    }
}

/// A convenience wrapper to turn single object fetcher into collection fetcher.
///
/// - parameter fetcher:  A fetcher function that is executed with each of the `param`.
/// - parameter params:   An array of parameters to pass to the fetcher.
/// - parameter callback: The block to invoked when we have th results of all the `params` by calling `fetcher`.
public func collectionify<Parameter, Result>(_ fetcher: @escaping (_ param: Parameter, _ callback: (_ object: Result) -> Void) -> Void, params: [Parameter], callback: @escaping (_ objects: [Result]) -> Void) {
    var objects = [Result]()
    var fetchedCount = 0

    params.forEach {
        fetcher($0) { object in
            fetchedCount += 1
            objects.append(object)
            if fetchedCount == params.count {
                callback(objects)
            }
        }
    }
}

/// A convenience wrapper to turn rate limiting multiple object fetcher into collection fetcher
/// by splitting fetching size to `splitSize`.
///
/// - parameter fetcher:   A fetcher function that is executed with each of the `params`.
/// - parameter splitSize: The maximum number of requests allowed in the fetcher.
/// - parameter params:    An array of parameters to pass to the fetcher.
/// - parameter callback:  The block to invoked when we have th results of all the `params` by calling `fetcher`.
public func collectionify<Parameter, Result>(_ fetcher: @escaping (_ param: [Parameter], _ callback: (_ object: [Result]) -> Void) -> Void, splitSize: Int, params: [Parameter], callback: @escaping (_ objects: [Result]) -> Void) {
    let pages            = params.splitBy(splitSize)
    var allObjects       = [Result]()
    var fetchedPageCount = 0

    pages.forEach {
        fetcher($0) { objects in
            fetchedPageCount += 1
            allObjects += objects
            if fetchedPageCount == pages.count {
                callback(allObjects)
            }
        }
    }
}
