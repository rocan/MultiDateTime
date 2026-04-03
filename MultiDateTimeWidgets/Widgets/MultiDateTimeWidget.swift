import WidgetKit
import SwiftUI

struct WorldClockWidget: Widget {
    let kind: String = "WorldClockWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockTimelineProvider()) { entry in
            MultiDateTimeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Global Date Time")
        .description("See the current time in your saved cities.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

struct MultiDateTimeWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: ClockTimelineEntry

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
                .containerBackground(for: .widget) { PhotoBackground(entry: entry) }
        case .systemMedium:
            MediumWidgetView(entry: entry)
                .containerBackground(for: .widget) { PhotoBackground(entry: entry) }
        case .systemLarge:
            LargeWidgetView(entry: entry)
                .containerBackground(for: .widget) { PhotoBackground(entry: entry) }
        case .accessoryCircular:
            LockScreenCircularView(entry: entry)
                .containerBackground(for: .widget) { Color.clear }
        case .accessoryRectangular:
            LockScreenRectangularView(entry: entry)
                .containerBackground(for: .widget) { Color.clear }
        case .accessoryInline:
            LockScreenInlineView(entry: entry)
                .containerBackground(for: .widget) { Color.clear }
        default:
            SmallWidgetView(entry: entry)
                .containerBackground(for: .widget) { PhotoBackground(entry: entry) }
        }
    }
}

struct PhotoBackground: View {
    let entry: ClockTimelineEntry

    private var fallbackGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.05, green: 0.10, blue: 0.25),
                Color(red: 0.12, green: 0.05, blue: 0.30)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        if entry.photoCount > 0,
           let image = SharedStore.loadPhoto(at: entry.photoIndex) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            fallbackGradient
        }
    }
}
