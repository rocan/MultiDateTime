import ActivityKit
import WidgetKit
import SwiftUI

struct MultiDateTimeLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MultiDateTimeActivityAttributes.self) { context in
            LockScreenView(context: context)
                .activityBackgroundTint(Color.black.opacity(0.8))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    DynamicIslandExpandedView(context: context, side: .leading)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    DynamicIslandExpandedView(context: context, side: .trailing)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    DynamicIslandExpandedView(context: context, side: .bottom)
                }
            } compactLeading: {
                DynamicIslandCompactView(context: context, position: .leading)
            } compactTrailing: {
                DynamicIslandCompactView(context: context, position: .trailing)
            } minimal: {
                DynamicIslandMinimalView(context: context)
            }
        }
    }
}
