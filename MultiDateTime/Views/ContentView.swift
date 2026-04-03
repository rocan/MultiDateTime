import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ClockListView()
        }
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    ContentView()
        .environmentObject(ClockStore())
        .environmentObject(LiveActivityService())
}
