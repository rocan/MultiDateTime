import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: ClockStore
    @EnvironmentObject var liveActivityService: LiveActivityService
    @Environment(\.dismiss) private var dismiss
    @State private var showingAlbumPicker = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Widget Photos") {
                    Button {
                        showingAlbumPicker = true
                    } label: {
                        HStack {
                            Label("Photo Albums", systemImage: "photo.on.rectangle")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .foregroundStyle(.primary)
                    Text("Choose which albums appear as widget backgrounds. Favorites are always included first.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Time Format") {
                    Picker("Format", selection: Binding(
                        get: { store.timeFormat },
                        set: { store.setTimeFormat($0) }
                    )) {
                        ForEach(TimeFormat.allCases, id: \.self) { format in
                            Text(format.displayName).tag(format)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Live Activity") {
                    Toggle("Show in Dynamic Island", isOn: Binding(
                        get: { liveActivityService.isActive },
                        set: { enabled in
                            Task {
                                if enabled {
                                    await liveActivityService.start(store: store)
                                } else {
                                    await liveActivityService.stop()
                                }
                            }
                        }
                    ))
                    Text("Displays the current time in the Dynamic Island while the phone is locked.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showingAlbumPicker) {
                AlbumPickerView()
            }
        }
    }
}
