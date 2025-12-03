//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import UniformTypeIdentifiers

public extension String {
    static var empty: String {
        return ""
    }
    
    func substring(from: Int, to: Int) -> String {
        guard to >= from else {
            return .empty
        }

        let range = (from ..< to + 1).clamped(to: 0 ..< count)
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start ..< end])
    }
    
    func appending(pathComponent: String) -> String {
        NSString(string: self).appendingPathComponent(pathComponent)
    }
    
    func replacingPathExtension(to type: UTType) -> String {
        NSString(string: self).deletingPathExtension.appending(pathExtensionFor: type)
    }
    
    func appending(pathExtensionFor type: UTType) -> String {
        NSString(string: self).appendingPathExtension(for: type)
    }
    
    func appending(pathExtension: String) -> String {
        appending(".\(pathExtension)")
    }
}

/// Leveraging Swift 5 new string interpolation API
/// References:
/// - [String Interpolation in Swift explained | Antoine van der Lee](https://www.avanderlee.com/swift/string-interpolation)
/// - [SE-228 | Fix ExpressibleByStringInterpolation] (https://github.com/apple/swift-evolution/blob/master/proposals/0228-fix-expressiblebystringinterpolation.md)
public extension String.StringInterpolation {
    /// Prints `Optional` values by only interpolating it if the value is set.
    /// `nil` is used as a fallback value to provide a clear output.
    mutating func appendInterpolation<T: CustomStringConvertible>(_ value: T?) {
        appendInterpolation(value ?? "nil" as CustomStringConvertible)
    }
    
    ///    let jsonData = """
    ///        {
    ///            "name": "Antoine van der Lee"
    ///        }
    ///    """.data(using: .utf8)!
    ///
    ///    print("The provided JSON is \(json: jsonData)")
    /// Prints: The provided JSON is
    /// {
    ///   "name" : "Antoine van der Lee"
    /// }
    mutating func appendInterpolation(json JSONData: Data) {
           guard
               let JSONObject = try? JSONSerialization.jsonObject(with: JSONData, options: []),
               let jsonData = try? JSONSerialization.data(withJSONObject: JSONObject, options: .prettyPrinted) else {
               appendInterpolation("Invalid JSON data")
               return
           }
           appendInterpolation("\n\(String(decoding: jsonData, as: UTF8.self))")
       }
    
    /// let request = URLRequest(url: URL(string: "https://google.com")!)
    /// print("The request is \(request)")
    /// Prints: "The request is https://google.com | GET | Headers: nil"
    mutating func appendInterpolation(_ request: URLRequest) {
        appendInterpolation("\(request.url) | \(request.httpMethod) | Headers: \(request.allHTTPHeaderFields)")
    }
}
