//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

/// A convenience wrapper to turn single object fetcher into collection fetcher.
///
/// - Parameters:
///   - fetcher:    A fetcher function that is executed with each of the `param`.
///   - parameters: An array of parameters to pass to the fetcher.
///   - callback:   The block to invoked when we have the results of all the `parameters` by calling `fetcher`.
func collectionify<Parameter, Result>(_ fetcher: @escaping (_ parameters: Parameter, _ callback: @escaping (_ object: Result?) -> Void) -> Void, parameters: [Parameter], callback: @escaping (_ objects: [Result]) -> Void) {
    var objects = [Result]()
    var fetchedCount = 0

    parameters.forEach {
        fetcher($0) { object in
            fetchedCount += 1

            if let object = object {
                objects.append(object)
            }

            if fetchedCount == parameters.count {
                callback(objects)
            }
        }
    }
}

/// A convenience wrapper to turn single object fetcher into collection fetcher.
///
/// - Parameters:
///   - fetcher:    A fetcher function that is executed with each of the `param`.
///   - parameters: An array of parameters to pass to the fetcher.
///   - callback:   The block to invoked when we have the results of all the `parameters` by calling `fetcher`.
func collectionify<Parameter, Result>(_ fetcher: @escaping (_ parameters: Parameter, _ callback: @escaping (_ object: Result) -> Void) -> Void, parameters: [Parameter], callback: @escaping (_ objects: [Result]) -> Void) {
    var objects = [Result]()
    var fetchedCount = 0

    parameters.forEach {
        fetcher($0) { object in
            fetchedCount += 1
            objects.append(object)
            if fetchedCount == parameters.count {
                callback(objects)
            }
        }
    }
}

/// A convenience wrapper to turn rate limiting multiple object fetcher into collection fetcher
/// by splitting fetching size to `splitSize`.
///
/// - Parameters:
///   - fetcher:    A fetcher function that is executed with each of the `parameters`.
///   - splitSize:  The maximum number of requests allowed in the fetcher.
///   - parameters: An array of parameters to pass to the fetcher.
///   - callback:   The block to invoked when we have the results of all the `parameters` by calling `fetcher`.
func collectionify<Parameter, Result>(_ fetcher: @escaping (_ parameters: [Parameter], _ callback: @escaping (_ object: [Result]) -> Void) -> Void, splitSize: Int, parameters: [Parameter], callback: @escaping (_ objects: [Result]) -> Void) {
    let pages = parameters.splitBy(splitSize)
    var allObjects = [Result]()
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
