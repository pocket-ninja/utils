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

    func hms(
        style: DateComponentsFormatter.UnitsStyle = .full,
        units: NSCalendar.Unit = [.hour, .minute, .second],
        zeroBehavior: DateComponentsFormatter.ZeroFormattingBehavior = .default
    ) -> String {
        formattedString(
            units: units,
            style: style,
            zeroBehavior: zeroBehavior
        )
    }
    
    func formattedString(
        units: NSCalendar.Unit,
        style: DateComponentsFormatter.UnitsStyle = .full,
        zeroBehavior: DateComponentsFormatter.ZeroFormattingBehavior = .default
    ) -> String {
        let formatter = DateComponentsFormatter()
        formatter.calendar = .current
        formatter.allowedUnits = units
        formatter.unitsStyle = style
        formatter.zeroFormattingBehavior = zeroBehavior
        return formatter.string(from: self) ?? ""
    }
}
