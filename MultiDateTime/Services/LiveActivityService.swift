import Foundation
import ActivityKit

@MainActor
class LiveActivityService: ObservableObject {
    @Published var isActive: Bool = false

    private var activity: Activity<MultiDateTimeActivityAttributes>?
    private var minuteTimer: Timer?

    func start(store: ClockStore) async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        guard activity == nil else { return }

        let attributes = MultiDateTimeActivityAttributes(activityTitle: "World Clock")
        let state = MultiDateTimeActivityAttributes.ContentState(
            pinnedEntries: Array(store.entries.prefix(2)),
            timeFormat: store.timeFormat,
            lastUpdated: Date()
        )

        do {
            let activity = try Activity.request(
                attributes: attributes,
                contentState: state,
                pushType: nil
            )
            self.activity = activity
            self.isActive = true
            scheduleMinuteUpdates(store: store)
        } catch {
            print("LiveActivity start error: \(error)")
        }
    }

    func stop() async {
        minuteTimer?.invalidate()
        minuteTimer = nil
        await activity?.end(dismissalPolicy: .immediate)
        activity = nil
        isActive = false
    }

    func syncIfActive(store: ClockStore) async {
        guard isActive, activity != nil else { return }
        await update(store: store)
    }

    private func update(store: ClockStore) async {
        let state = MultiDateTimeActivityAttributes.ContentState(
            pinnedEntries: Array(store.entries.prefix(2)),
            timeFormat: store.timeFormat,
            lastUpdated: Date()
        )
        await activity?.update(using: state)
    }

    private func scheduleMinuteUpdates(store: ClockStore) {
        minuteTimer?.invalidate()
        let now = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: now)
        components.minute = (components.minute ?? 0) + 1
        components.second = 0
        let nextMinute = calendar.date(from: components) ?? now.addingTimeInterval(60)
        let delay = nextMinute.timeIntervalSinceNow

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self, self.isActive else { return }
            Task {
                await self.update(store: store)
                self.scheduleMinuteUpdates(store: store)
            }
        }
    }
}
