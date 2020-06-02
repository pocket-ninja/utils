//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import Foundation
import UIKit

@propertyWrapper
public struct CodableColor: Equatable {
    public var wrappedValue: UIColor = .clear

    public init(wrappedValue value: UIColor) {
        self.wrappedValue = value
    }
}

extension CodableColor: Codable {
    public func encode(to encoder: Encoder) throws {
        let nsCoder = NSKeyedArchiver(requiringSecureCoding: true)
        wrappedValue.encode(with: nsCoder)
        var container = encoder.unkeyedContainer()
        try container.encode(nsCoder.encodedData)
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let decodedData = try container.decode(Data.self)
        let nsCoder = try NSKeyedUnarchiver(forReadingFrom: decodedData)
        let color = try UIColor(coder: nsCoder).get()
        self.init(wrappedValue: color)
    }
}
