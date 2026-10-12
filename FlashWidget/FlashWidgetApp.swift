import SwiftUI

@main
struct FlashWidgetApp: App {
    @StateObject private var deckStore = DeckStore()
    @AppStorage("appLanguage") private var appLanguage: String = "system"

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(deckStore)
                .environment(\.locale, resolvedLocale)
        }
    }

    private var resolvedLocale: Locale {
        guard appLanguage != "system" else { return .autoupdatingCurrent }
        return Locale(identifier: appLanguage)
    }
}
