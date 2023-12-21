//
//  Copyright © 2023 sroik. All rights reserved.
//

import Foundation

public extension TimeInterval {
    static let minute: TimeInterval = 60.0
    static let hour = TimeInterval.minute * 60.0
    static let day: TimeInterval =  TimeInterval.hour * 24
    
    var hours: Int {
        Int(self) / (60 * 60)
    }

    var minutes: Int {
        Int(self / 60)
    }

    var seconds: Int {
        Int(self)
    }

    var milliseconds: Int {
        Int(truncatingRemainder(dividingBy: 1) * 1000)
    }

    func hms(style: DateComponentsFormatter.UnitsStyle = .full) -> String {
        formattedString(units: [.hour, .minute, .second], style: style)
    }
    
    func formattedString(units: NSCalendar.Unit, style: DateComponentsFormatter.UnitsStyle = .full) -> String {
        let formatter = DateComponentsFormatter()
        formatter.calendar = .current
        formatter.allowedUnits = units
        formatter.unitsStyle = style
        return formatter.string(from: self) ?? ""
    }
}
