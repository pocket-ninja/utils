//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public func assertWrapper(_ condition: @autoclosure () -> Bool,
                          _ domain: @autoclosure () -> String = String(),
                          _ message: @autoclosure () -> String? = nil,
                          file: StaticString = #file,
                          line: UInt = #line) {
    guard !condition() else {
        return
    }

    trace("assertion failed:" + domain(), file: String(describing: file), line: Int(line))

    if Environment.isDebug && !Environment.isTests {
        assertionFailure(domain(), file: file, line: line)
    }

    if !Environment.isDebug {
        let domain = "[Assertion]: \(domain().capitalized)"
        let parameters = ["message": message() ?? domain, "file": String(describing: file), "line": "\(line)"]
        let error = AnalyticsError(domain: domain, parameters: parameters)
        errorTracker?.track(error)
    }
}

public func assertionWrapperFailure(_ domain: @autoclosure () -> String = String(),
                                    _ message: @autoclosure () -> String? = nil,
                                    file: StaticString = #file,
                                    line: UInt = #line) {
    assertWrapper(false, domain(), message(), file: file, line: line)
}

public func assertError(_ domain: @autoclosure () -> String? = nil,
                        file: StaticString = #file,
                        line: UInt = #line,
                        in block: () throws -> Void) {
    do {
        try block()
    } catch {
        let message = error.localizedDescription
        assertionWrapperFailure(domain() ?? "error caught", message, file: file, line: line)
    }
}
