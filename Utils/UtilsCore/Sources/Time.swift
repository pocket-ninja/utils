//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import Foundation

public struct Time: Codable, Hashable {
    public var hour: Int {
        didSet {
            hour = hour.clamped(from: 0, to: 23)
        }
    }

    public var minute: Int {
        didSet {
            minute = minute.clamped(from: 0, to: 59)
        }
    }

    public var duration: TimeInterval {
        return TimeInterval(hour * 60 * 60 + minute * 60)
    }

    public var dateComponents: DateComponents {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        return components
    }

    public var description: String {
        return String(format: "%02d:%02d", hour, minute)
    }

    public init(hour: Int = 0, minute: Int = 0) {
        self.hour = hour.clamped(from: 0, to: 23)
        self.minute = minute.clamped(from: 0, to: 59)
    }

    public init(with date: Date, in calendar: Calendar) {
        let components = calendar.dateComponents([.hour, .minute], from: date)
        self.init(hour: components.hour ?? 0, minute: components.minute ?? 0)
    }
}

public extension Date {
    func with(time: Time, in calendar: Calendar) -> Date {
        return calendar.startOfDay(for: self).addingTimeInterval(time.duration)
    }
}
