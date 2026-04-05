import SwiftUI
import WidgetKit

struct MediumWidgetView: View {
    let entry: ClockTimelineEntry
    private var hasPhoto: Bool { entry.photoCount > 0 }

    var body: some View {
        ZStack(alignment: .bottom) {
            if hasPhoto {
                LinearGradient(
                    colors: [.clear, .black.opacity(0.65)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            HStack(spacing: 0) {
                ForEach(Array(entry.clockEntries.prefix(2).enumerated()), id: \.element.id) { index, clock in
                    ClockCellView(clock: clock, date: entry.date, hasPhoto: hasPhoto)
                        .frame(maxWidth: .infinity)
                    if index == 0 && entry.clockEntries.count > 1 {
                        Divider()
                            .background(hasPhoto ? Color.white.opacity(0.4) : Color.primary.opacity(0.2))
                    }
                }
                if entry.clockEntries.isEmpty {
                    Text("No clocks added")
                        .foregroundStyle(hasPhoto ? .white : .secondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ClockCellView: View {
    let clock: ClockEntry
    let date: Date
    let hasPhoto: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(clock.cityLabel)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .lineLimit(1)
                .foregroundStyle(hasPhoto ? .white : .primary)
                .shadow(color: .black.opacity(0.5), radius: 2)
            Text(date, style: .time)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .foregroundStyle(hasPhoto ? .white : .primary)
                .environment(\.timeZone, clock.timeZone)
                .shadow(color: .black.opacity(0.5), radius: 2)
            Text(dateString(from: date, in: clock.timeZone))
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.5)
                .foregroundStyle(hasPhoto ? .white.opacity(0.85) : .secondary)
                .lineLimit(1)
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func dateString(from date: Date, in timeZone: TimeZone) -> String {
        let f = DateFormatter()
        f.timeZone = timeZone
        f.dateFormat = "E, MMM d"
        return f.string(from: date)
    }
}
