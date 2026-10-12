import Foundation

enum CardInterval: String, CaseIterable, Codable {
    case oneHour   = "1h"
    case twoHours  = "2h"
    case fourHours = "4h"
    case eightHours = "8h"
    case oneDay    = "24h"
    case twoDays   = "2d"

    var displayName: String {
        switch self {
        case .oneHour:    return String(localized: "1 hour")
        case .twoHours:   return String(localized: "2 hours")
        case .fourHours:  return String(localized: "4 hours")
        case .eightHours: return String(localized: "8 hours")
        case .oneDay:     return String(localized: "24 hours")
        case .twoDays:    return String(localized: "2 days")
        }
    }

    var timeInterval: TimeInterval {
        switch self {
        case .oneHour:    return 3_600
        case .twoHours:   return 7_200
        case .fourHours:  return 14_400
        case .eightHours: return 28_800
        case .oneDay:     return 86_400
        case .twoDays:    return 172_800
        }
    }
}

enum WidgetSettings {
    static let appGroupIdentifier = "group.com.slizik.linguadrill"

    private static var defaults: UserDefaults {
        UserDefaults(suiteName: appGroupIdentifier) ?? .standard
    }

    static var selectedDeckId: UUID? {
        get {
            guard let str = defaults.string(forKey: "selectedDeckId") else { return nil }
            return UUID(uuidString: str)
        }
        set { defaults.set(newValue?.uuidString, forKey: "selectedDeckId") }
    }

    static var currentCardIndex: Int {
        get { defaults.integer(forKey: "currentCardIndex") }
        set { defaults.set(newValue, forKey: "currentCardIndex") }
    }

    static var interval: CardInterval {
        get {
            let raw = defaults.string(forKey: "interval") ?? CardInterval.oneHour.rawValue
            return CardInterval(rawValue: raw) ?? .oneHour
        }
        set { defaults.set(newValue.rawValue, forKey: "interval") }
    }
}
