import Foundation
import ActivityKit

struct MultiDateTimeActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var pinnedEntries: [ClockEntry]
        var timeFormat: TimeFormat
        var lastUpdated: Date
    }

    var activityTitle: String
}
