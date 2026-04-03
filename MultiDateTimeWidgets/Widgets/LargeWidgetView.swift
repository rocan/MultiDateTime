import SwiftUI
import WidgetKit

struct LargeWidgetView: View {
    let entry: ClockTimelineEntry
    private var hasPhoto: Bool { entry.photoCount > 0 }

    var body: some View {
        ZStack(alignment: .bottom) {
            if hasPhoto {
                LinearGradient(
                    colors: [.clear, .black.opacity(0.75)],
                    startPoint: .center,
                    endPoint: .bottom
                )
            }
            VStack(spacing: 0) {
                ForEach(Array(entry.clockEntries.prefix(4).enumerated()), id: \.element.id) { index, clock in
                    LargeClockRowView(clock: clock, date: entry.date, hasPhoto: hasPhoto)
                    if index < min(entry.clockEntries.count, 4) - 1 {
                        Divider()
                            .background(hasPhoto ? Color.white.opacity(0.3) : Color.primary.opacity(0.2))
                            .padding(.horizontal)
                    }
                }
                if entry.clockEntries.isEmpty {
                    Spacer()
                    Text("No clocks added")
                        .foregroundStyle(hasPhoto ? .white : .secondary)
                    Spacer()
                }
            }
            .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}

struct LargeClockRowView: View {
    let clock: ClockEntry
    let date: Date
    let hasPhoto: Bool

    var body: some View {
        HStack {
            Text(clock.cityLabel)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .lineLimit(1)
                .foregroundStyle(hasPhoto ? .white : .primary)
                .shadow(color: .black.opacity(0.5), radius: 2)
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(date, style: .time)
                    .font(.system(size: 20, weight: .light, design: .rounded))
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                    .foregroundStyle(hasPhoto ? .white : .primary)
                    .environment(\.timeZone, clock.timeZone)
                    .shadow(color: .black.opacity(0.5), radius: 2)
                Text(dateString(from: date, in: clock.timeZone))
                    .font(.system(size: 11, weight: .regular, design: .rounded))
                    .minimumScaleFactor(0.7)
                    .foregroundStyle(hasPhoto ? .white.opacity(0.85) : .secondary)
                    .shadow(color: .black.opacity(0.4), radius: 2)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    private func dateString(from date: Date, in timeZone: TimeZone) -> String {
        let f = DateFormatter()
        f.timeZone = timeZone
        f.dateFormat = "E, MMM d"
        return f.string(from: date)
    }
}
