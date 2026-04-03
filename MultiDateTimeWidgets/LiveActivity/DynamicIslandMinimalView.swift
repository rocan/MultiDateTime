import SwiftUI
import ActivityKit
import WidgetKit

struct DynamicIslandMinimalView: View {
    let context: ActivityViewContext<MultiDateTimeActivityAttributes>

    private var primaryEntry: ClockEntry? { context.state.pinnedEntries.first }

    var body: some View {
        if let entry = primaryEntry {
            Text(context.state.lastUpdated, style: .time)
                .font(.caption2)
                .minimumScaleFactor(0.5)
                .environment(\.timeZone, entry.timeZone)
        }
    }
}
