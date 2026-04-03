import Foundation

enum TimeFormat: String, Codable, CaseIterable {
    case twelveHour = "12h"
    case twentyFourHour = "24h"

    var displayName: String {
        switch self {
        case .twelveHour: return "12-Hour"
        case .twentyFourHour: return "24-Hour"
        }
    }

    var formatString: String {
        switch self {
        case .twelveHour: return "h:mm a"
        case .twentyFourHour: return "HH:mm"
        }
    }
}
