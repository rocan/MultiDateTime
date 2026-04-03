import SwiftUI
import ActivityKit
import WidgetKit

enum CompactPosition { case leading, trailing }

struct DynamicIslandCompactView: View {
    let context: ActivityViewContext<MultiDateTimeActivityAttributes>
    let position: CompactPosition

    private var primaryEntry: ClockEntry? { context.state.pinnedEntries.first }
    private var secondaryEntry: ClockEntry? {
        context.state.pinnedEntries.count > 1 ? context.state.pinnedEntries[1] : nil
    }

    var body: some View {
        switch position {
        case .leading:
            if let entry = primaryEntry {
                Text(entry.cityLabel.prefix(3).uppercased())
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
        case .trailing:
            if let entry = primaryEntry {
                Text(context.state.lastUpdated, style: .time)
                    .font(.caption2)
                    .environment(\.timeZone, entry.timeZone)
            }
        }
    }
}
