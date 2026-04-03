import Foundation

struct ClockEntry: Identifiable, Codable, Hashable {
    let id: UUID
    var timeZoneIdentifier: String
    var cityLabel: String
    var sortOrder: Int

    var timeZone: TimeZone {
        TimeZone(identifier: timeZoneIdentifier) ?? .current
    }

    init(id: UUID = UUID(), timeZoneIdentifier: String, cityLabel: String, sortOrder: Int) {
        self.id = id
        self.timeZoneIdentifier = timeZoneIdentifier
        self.cityLabel = cityLabel
        self.sortOrder = sortOrder
    }

    var utcOffsetString: String {
        let seconds = timeZone.secondsFromGMT(for: Date())
        let hours = seconds / 3600
        let minutes = abs(seconds % 3600) / 60
        if minutes == 0 {
            return hours >= 0 ? "UTC+\(hours)" : "UTC\(hours)"
        } else {
            return hours >= 0 ? "UTC+\(hours):\(String(format: "%02d", minutes))" : "UTC\(hours):\(String(format: "%02d", minutes))"
        }
    }
}
