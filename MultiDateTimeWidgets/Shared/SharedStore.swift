import Foundation
import UIKit

struct SharedStore {
    static let suiteName = "group.com.zzc.multidatetime"
    static let entriesKey = "wc.entries"
    static let formatKey = "wc.timeFormat"
    static let photoCountKey = "wc.photoCount"
    static let currentPhotoIndexKey = "wc.currentPhotoIndex"
    static let photosFolderName = "WidgetPhotos"

    static func loadEntries() -> [ClockEntry] {
        guard let defaults = UserDefaults(suiteName: suiteName),
              let data = defaults.data(forKey: entriesKey),
              let entries = try? JSONDecoder().decode([ClockEntry].self, from: data)
        else { return [] }
        return entries.sorted { $0.sortOrder < $1.sortOrder }
    }

    static func loadTimeFormat() -> TimeFormat {
        guard let defaults = UserDefaults(suiteName: suiteName),
              let raw = defaults.string(forKey: formatKey),
              let format = TimeFormat(rawValue: raw)
        else { return .twelveHour }
        return format
    }

    static func loadPhotoCount() -> Int {
        UserDefaults(suiteName: suiteName)?.integer(forKey: photoCountKey) ?? 0
    }

    static func loadCurrentPhotoIndex() -> Int {
        UserDefaults(suiteName: suiteName)?.integer(forKey: currentPhotoIndexKey) ?? 0
    }

    static func loadPhoto(at index: Int) -> UIImage? {
        guard let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: suiteName
        ) else { return nil }
        let fileURL = containerURL
            .appendingPathComponent(photosFolderName)
            .appendingPathComponent("photo_\(index).jpg")
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }
}
