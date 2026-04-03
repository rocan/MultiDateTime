import SwiftUI

@main
struct MultiDateTimeApp: App {
    @StateObject private var store = ClockStore()
    @StateObject private var liveActivityService = LiveActivityService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(liveActivityService)
                .onChange(of: store.entries) { _, _ in
                    Task { await liveActivityService.syncIfActive(store: store) }
                }
                .onChange(of: store.timeFormat) { _, _ in
                    Task { await liveActivityService.syncIfActive(store: store) }
                }
                .onAppear {
                    PhotoService.shared.requestPermissionAndSync()
                }
                .onReceive(
                    NotificationCenter.default.publisher(
                        for: UIApplication.protectedDataDidBecomeAvailableNotification
                    )
                ) { _ in
                    PhotoService.shared.advancePhotoOnUnlock()
                }
        }
    }
}
