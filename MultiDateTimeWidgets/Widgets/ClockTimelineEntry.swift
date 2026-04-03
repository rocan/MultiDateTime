import WidgetKit
import Foundation

struct ClockTimelineEntry: TimelineEntry {
    let date: Date
    let clockEntries: [ClockEntry]
    let timeFormat: TimeFormat
    let photoIndex: Int
    let photoCount: Int
}
