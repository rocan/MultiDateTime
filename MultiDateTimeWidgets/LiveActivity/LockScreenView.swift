import SwiftUI
import ActivityKit
import WidgetKit

struct LockScreenView: View {
    let context: ActivityViewContext<MultiDateTimeActivityAttributes>

    var body: some View {
        HStack(spacing: 20) {
            ForEach(context.state.pinnedEntries) { entry in
                VStack(alignment: .center, spacing: 4) {
                    Text(entry.cityLabel)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(context.state.lastUpdated, style: .time)
                        .font(.system(size: 18, weight: .light, design: .rounded))
                        .environment(\.timeZone, entry.timeZone)
                    Text(dateString(from: context.state.lastUpdated, in: entry.timeZone))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }

    private func dateString(from date: Date, in timeZone: TimeZone) -> String {
        let f = DateFormatter()
        f.timeZone = timeZone
        f.dateFormat = "E, MMM d"
        return f.string(from: date)
    }
}
