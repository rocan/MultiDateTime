import WidgetKit
import Foundation

struct ClockTimelineProvider: TimelineProvider {
    typealias Entry = ClockTimelineEntry

    func placeholder(in context: Context) -> ClockTimelineEntry {
        ClockTimelineEntry(
            date: Date(),
            clockEntries: [
                ClockEntry(timeZoneIdentifier: "America/New_York", cityLabel: "New York", sortOrder: 0),
                ClockEntry(timeZoneIdentifier: "Europe/London", cityLabel: "London", sortOrder: 1),
            ],
            timeFormat: .twelveHour,
            photoIndex: 0,
            photoCount: 0
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (ClockTimelineEntry) -> Void) {
        let clockEntries = SharedStore.loadEntries()
        let photoCount = SharedStore.loadPhotoCount()
        let entry = ClockTimelineEntry(
            date: Date(),
            clockEntries: clockEntries.isEmpty ? placeholder(in: context).clockEntries : clockEntries,
            timeFormat: SharedStore.loadTimeFormat(),
            photoIndex: 0,
            photoCount: photoCount
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ClockTimelineEntry>) -> Void) {
        let clockEntries = SharedStore.loadEntries()
        let format = SharedStore.loadTimeFormat()
        let photoCount = SharedStore.loadPhotoCount()
        let now = Date()

        let calendar = Calendar.current
        var minuteStart = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: now)
        minuteStart.second = 0
        let firstDate = calendar.date(from: minuteStart) ?? now

        // One entry every 5 minutes for 2 hours (24 entries), cycling from current index
        let intervalMinutes = 5
        let totalEntries = 24
        let startIndex = SharedStore.loadCurrentPhotoIndex()

        let timelineEntries = (0..<totalEntries).map { offset -> ClockTimelineEntry in
            let date = calendar.date(byAdding: .minute, value: offset * intervalMinutes, to: firstDate) ?? firstDate
            let photoIndex = photoCount > 0 ? (startIndex + offset) % photoCount : 0
            return ClockTimelineEntry(
                date: date,
                clockEntries: clockEntries,
                timeFormat: format,
                photoIndex: photoIndex,
                photoCount: photoCount
            )
        }

        completion(Timeline(entries: timelineEntries, policy: .atEnd))
    }
}
