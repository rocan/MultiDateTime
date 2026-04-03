import SwiftUI

struct LiveTimeText: View {
    let entry: ClockEntry
    let timeFormat: TimeFormat

    var body: some View {
        TimelineView(.periodic(from: .now, by: 60.0)) { context in
            VStack(alignment: .trailing, spacing: 2) {
                Text(timeString(from: context.date))
                    .font(.system(size: 18, weight: .light, design: .monospaced))
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                Text(dateString(from: context.date))
                    .font(.system(size: 18, weight: .light, design: .monospaced))
                    .minimumScaleFactor(0.6)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = entry.timeZone
        formatter.dateFormat = timeFormat.formatString
        return formatter.string(from: date)
    }

    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = entry.timeZone
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
