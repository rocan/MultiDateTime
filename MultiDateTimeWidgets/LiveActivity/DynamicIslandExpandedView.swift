import SwiftUI
import ActivityKit
import WidgetKit

enum ExpandedRegionSide { case leading, trailing, bottom }

struct DynamicIslandExpandedView: View {
    let context: ActivityViewContext<MultiDateTimeActivityAttributes>
    let side: ExpandedRegionSide

    private var primaryEntry: ClockEntry? { context.state.pinnedEntries.first }
    private var secondaryEntry: ClockEntry? {
        context.state.pinnedEntries.count > 1 ? context.state.pinnedEntries[1] : nil
    }

    var body: some View {
        switch side {
        case .leading:
            if let entry = primaryEntry {
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.cityLabel)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(context.state.lastUpdated, style: .time)
                        .font(.headline)
                        .environment(\.timeZone, entry.timeZone)
                }
            }
        case .trailing:
            if let entry = secondaryEntry {
                VStack(alignment: .trailing, spacing: 2) {
                    Text(entry.cityLabel)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(context.state.lastUpdated, style: .time)
                        .font(.headline)
                        .environment(\.timeZone, entry.timeZone)
                }
            }
        case .bottom:
            HStack(spacing: 20) {
                ForEach(context.state.pinnedEntries) { entry in
                    VStack(spacing: 2) {
                        Text(entry.cityLabel)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(dateString(from: context.state.lastUpdated, in: entry.timeZone))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private func dateString(from date: Date, in timeZone: TimeZone) -> String {
        let f = DateFormatter()
        f.timeZone = timeZone
        f.dateFormat = "E, MMM d"
        return f.string(from: date)
    }
}
