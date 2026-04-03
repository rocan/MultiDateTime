import SwiftUI

struct ClockListView: View {
    @EnvironmentObject var store: ClockStore
    @State private var showingAddSheet = false
    @State private var showingSettings = false

    var body: some View {
        List {
            ForEach(store.entries) { entry in
                ClockRowView(entry: entry, timeFormat: store.timeFormat)
            }
            .onDelete(perform: store.remove)
            .onMove(perform: store.move)
        }
        .navigationTitle("Global Date Time")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddTimezoneView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}
