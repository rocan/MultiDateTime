import SwiftUI
import WidgetKit

struct LockScreenCircularView: View {
    let entry: ClockTimelineEntry

    private var primaryEntry: ClockEntry? { entry.clockEntries.first }

    var body: some View {
        if let clock = primaryEntry {
            ZStack {
                AccessoryWidgetBackground()
                VStack(spacing: 1) {
                    Text(clock.cityLabel)
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .widgetAccentable()
                    Text(entry.date, style: .time)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                        .environment(\.timeZone, clock.timeZone)
                }
                .padding(4)
            }
        } else {
            ZStack {
                AccessoryWidgetBackground()
                Image(systemName: "clock")
                    .font(.system(size: 20))
                    .widgetAccentable()
            }
        }
    }
}

struct LockScreenRectangularView: View {
    let entry: ClockTimelineEntry

    private var primaryEntry: ClockEntry? { entry.clockEntries.first }

    var body: some View {
        if let clock = primaryEntry {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.black.opacity(0.6))
                VStack(alignment: .leading, spacing: 2) {
                    Text(clock.cityLabel)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .widgetAccentable()
                    HStack(spacing: 6) {
                        Text(entry.date, style: .time)
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .environment(\.timeZone, clock.timeZone)
                        Text(entry.date.formatted(
                            Date.FormatStyle(timeZone: clock.timeZone)
                                .weekday(.abbreviated).month(.abbreviated).day()
                        ))
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        } else {
            Text("No clocks")
                .foregroundStyle(.secondary)
        }
    }
}

struct LockScreenInlineView: View {
    let entry: ClockTimelineEntry

    private var primaryEntry: ClockEntry? { entry.clockEntries.first }

    var body: some View {
        if let clock = primaryEntry {
            ViewThatFits {
                HStack(spacing: 4) {
                    Text(clock.cityLabel)
                    Text(entry.date, style: .time)
                        .environment(\.timeZone, clock.timeZone)
                }
                Text(entry.date, style: .time)
                    .environment(\.timeZone, clock.timeZone)
            }
        } else {
            Text("No clocks")
        }
    }
}
