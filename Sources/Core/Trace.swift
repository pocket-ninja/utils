//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public func trace(_ message: String = "", file: String = #file, line: Int = #line) {
    guard !Environment.isRelease else {
        return
    }
    
    let filename = file.components(separatedBy: "/").last ?? ""
    print("\(TimestampFormatter.default.timestamp) \(filename):\(line) \(message)")
}

private class TimestampFormatter {
    static let `default` = TimestampFormatter()

    var timestamp: String {
        return self.formatter.string(from: Date())
    }

    init() {
        formatter.dateFormat = "HH:mm:ss:SSS"
    }

    private let formatter = DateFormatter()
}
