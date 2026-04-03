import SwiftUI
import Photos

struct AlbumItem: Identifiable {
    let id: String          // localIdentifier
    let title: String
    let count: Int
    let type: String        // "People", "Smart Album", "Album"
}

struct AlbumPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var albums: [AlbumItem] = []
    @State private var selectedIds: Set<String>
    @State private var isLoading = true

    private let defaults = UserDefaults(suiteName: ClockStore.suiteName)

    init() {
        let saved = UserDefaults(suiteName: ClockStore.suiteName)?
            .stringArray(forKey: "wc.selectedAlbumIds") ?? []
        _selectedIds = State(initialValue: Set(saved))
    }

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Loading albums…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        Section {
                            ForEach(albums) { album in
                                Button {
                                    if selectedIds.contains(album.id) {
                                        selectedIds.remove(album.id)
                                    } else {
                                        selectedIds.insert(album.id)
                                    }
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(album.title)
                                                .foregroundStyle(.primary)
                                            Text("\(album.type) · \(album.count) photos")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        if selectedIds.contains(album.id) {
                                            Image(systemName: "checkmark")
                                                .foregroundStyle(.blue)
                                        }
                                    }
                                }
                            }
                        } footer: {
                            Text("Selected albums are used as widget photo backgrounds. Favorite photos are always included first.")
                        }
                    }
                }
            }
            .navigationTitle("Photo Albums")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        defaults?.set(Array(selectedIds), forKey: "wc.selectedAlbumIds")
                        DispatchQueue.global(qos: .background).async {
                            PhotoService.shared.syncPhotos()
                        }
                        dismiss()
                    }
                }
            }
            .onAppear { loadAlbums() }
        }
    }

    private func loadAlbums() {
        DispatchQueue.global(qos: .userInitiated).async {
            var items: [AlbumItem] = []

            // Smart albums (Recents, Screenshots, Selfies, etc.)
            let smartAlbums = PHAssetCollection.fetchAssetCollections(
                with: .smartAlbum, subtype: .any, options: nil
            )
            smartAlbums.enumerateObjects { collection, _, _ in
                let count = PHAsset.fetchAssets(in: collection, options: nil).count
                guard count > 0, let title = collection.localizedTitle else { return }
                items.append(AlbumItem(
                    id: collection.localIdentifier,
                    title: title,
                    count: count,
                    type: "Smart Album"
                ))
            }

            // User-created albums
            let userAlbums = PHAssetCollection.fetchAssetCollections(
                with: .album, subtype: .any, options: nil
            )
            userAlbums.enumerateObjects { collection, _, _ in
                let count = PHAsset.fetchAssets(in: collection, options: nil).count
                guard count > 0, let title = collection.localizedTitle else { return }
                items.append(AlbumItem(
                    id: collection.localIdentifier,
                    title: title,
                    count: count,
                    type: "Album"
                ))
            }

            let sorted = items.sorted { $0.title.localizedCompare($1.title) == .orderedAscending }

            DispatchQueue.main.async {
                albums = sorted
                isLoading = false
            }
        }
    }
}
