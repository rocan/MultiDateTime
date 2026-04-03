import SwiftUI
import WidgetKit

struct SmallWidgetView: View {
    @Environment(\.showsWidgetContainerBackground) var showsBackground
    let entry: ClockTimelineEntry

    private var primaryEntry: ClockEntry? { entry.clockEntries.first }
    private var hasPhoto: Bool { entry.photoCount > 0 }

    var body: some View {
        if !showsBackground {
            StandByWidgetView(entry: entry)
        } else {
            ZStack(alignment: .bottomLeading) {
                if hasPhoto {
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.65)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                if let clock = primaryEntry {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(clock.cityLabel)
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(hasPhoto ? .white : .primary)
                            .lineLimit(1)
                            .shadow(color: .black.opacity(0.5), radius: 2)
                        Text(entry.date, style: .time)
                            .font(.system(size: 22, weight: .light, design: .rounded))
                            .minimumScaleFactor(0.6)
                            .lineLimit(1)
                            .foregroundStyle(hasPhoto ? .white : .primary)
                            .environment(\.timeZone, clock.timeZone)
                            .shadow(color: .black.opacity(0.5), radius: 2)
                        Text(entry.date.formatted(Date.FormatStyle(timeZone: clock.timeZone).weekday(.abbreviated).month(.abbreviated).day()))
                            .font(.system(size: 11, weight: .regular, design: .rounded))
                            .foregroundStyle(hasPhoto ? .white.opacity(0.85) : .secondary)
                            .lineLimit(1)
                            .shadow(color: .black.opacity(0.5), radius: 2)
                    }
                    .padding(10)
                } else {
                    Text("No clocks").foregroundStyle(.secondary).padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
    }
}

struct StandByWidgetView: View {
    let entry: ClockTimelineEntry
    private var clocks: [ClockEntry] { Array(entry.clockEntries.prefix(4)) }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(clocks) { clock in
                HStack {
                    Text(clock.cityLabel)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(entry.date, style: .time)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .environment(\.timeZone, clock.timeZone)
                        .widgetAccentable()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}
