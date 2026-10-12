import AppIntents
import Foundation

extension Notification.Name {
    static let addCardRequested = Notification.Name("addCardRequested")
}

struct AddCardIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Card"
    static var description = IntentDescription("Opens LinguaDrill to add a new card to your active deck.")
    static var openAppWhenRun = true

    @MainActor
    func perform() async throws -> some IntentResult {
        // The flag survives a cold launch or the intent running in the widget extension;
        // the notification covers the app already being in the foreground.
        WidgetSettings.pendingAddCard = true
        NotificationCenter.default.post(name: .addCardRequested, object: nil)
        return .result()
    }
}
