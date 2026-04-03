import Photos
import UIKit
import Foundation
#if !WIDGET_EXTENSION
import WidgetKit
#endif

class PhotoService {
    static let shared = PhotoService()
    static let photosFolderName = "WidgetPhotos"
    static let photoCountKey = "wc.photoCount"
    static let currentPhotoIndexKey = "wc.currentPhotoIndex"
    static let selectedAlbumIdsKey = "wc.selectedAlbumIds"
    static let maxPhotos = 20

    func requestPermissionAndSync() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            guard status == .authorized || status == .limited else { return }
            DispatchQueue.global(qos: .background).async {
                self?.syncPhotos()
            }
        }
    }

    func syncPhotos() {
        let assets = fetchAssets()
        saveToAppGroup(assets)
    }

    func advancePhotoOnUnlock() {
        let defaults = UserDefaults(suiteName: ClockStore.suiteName)
        let count = defaults?.integer(forKey: Self.photoCountKey) ?? 0
        guard count > 1 else { return }
        let current = defaults?.integer(forKey: Self.currentPhotoIndexKey) ?? 0
        let next = (current + 1) % count
        defaults?.set(next, forKey: Self.currentPhotoIndexKey)
#if !WIDGET_EXTENSION
        WidgetCenter.shared.reloadAllTimelines()
#endif
    }

    private func fetchAssets() -> [PHAsset] {
        var assets: [PHAsset] = []
        let defaults = UserDefaults(suiteName: ClockStore.suiteName)
        let selectedIds = Set(defaults?.stringArray(forKey: Self.selectedAlbumIdsKey) ?? [])

        // 1. Favorites always first
        let favOptions = PHFetchOptions()
        favOptions.predicate = NSPredicate(format: "isFavorite == YES")
        favOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        favOptions.fetchLimit = Self.maxPhotos
        PHAsset.fetchAssets(with: .image, options: favOptions)
            .enumerateObjects { asset, _, _ in assets.append(asset) }

        // 2. Photos from user-selected albums
        if !selectedIds.isEmpty && assets.count < Self.maxPhotos {
            let seen = Set(assets.map { $0.localIdentifier })
            for id in selectedIds {
                guard assets.count < Self.maxPhotos else { break }
                let collections = PHAssetCollection.fetchAssetCollections(
                    withLocalIdentifiers: [id], options: nil
                )
                collections.enumerateObjects { collection, _, _ in
                    guard assets.count < Self.maxPhotos else { return }
                    let opts = PHFetchOptions()
                    opts.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                    PHAsset.fetchAssets(in: collection, options: opts).enumerateObjects { asset, _, _ in
                        if assets.count < Self.maxPhotos && !seen.contains(asset.localIdentifier) {
                            assets.append(asset)
                        }
                    }
                }
            }
        }

        // 3. Recent photos as final fallback
        if assets.count < Self.maxPhotos {
            let seen = Set(assets.map { $0.localIdentifier })
            let recentOptions = PHFetchOptions()
            recentOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            recentOptions.fetchLimit = Self.maxPhotos
            PHAsset.fetchAssets(with: .image, options: recentOptions).enumerateObjects { asset, _, _ in
                if assets.count < Self.maxPhotos && !seen.contains(asset.localIdentifier) {
                    assets.append(asset)
                }
            }
        }

        return Array(assets.prefix(Self.maxPhotos))
    }

    private func saveToAppGroup(_ assets: [PHAsset]) {
        guard let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: ClockStore.suiteName
        ) else { return }

        let photosURL = containerURL.appendingPathComponent(Self.photosFolderName)
        try? FileManager.default.createDirectory(at: photosURL, withIntermediateDirectories: true)

        if let existing = try? FileManager.default.contentsOfDirectory(
            at: photosURL, includingPropertiesForKeys: nil
        ) {
            existing.forEach { try? FileManager.default.removeItem(at: $0) }
        }

        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        let targetSize = CGSize(width: 800, height: 800)

        for (index, asset) in assets.enumerated() {
            manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
                guard let image, let data = image.jpegData(compressionQuality: 0.8) else { return }
                let fileURL = photosURL.appendingPathComponent("photo_\(index).jpg")
                try? data.write(to: fileURL)
            }
        }

        let defaults = UserDefaults(suiteName: ClockStore.suiteName)
        defaults?.set(assets.count, forKey: Self.photoCountKey)
        defaults?.set(0, forKey: Self.currentPhotoIndexKey)   // reset index after resync

#if !WIDGET_EXTENSION
        WidgetCenter.shared.reloadAllTimelines()
#endif
    }
}
