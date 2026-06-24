import SwiftUI

@main
struct FlashWidgetApp: App {
    @StateObject private var deckStore = DeckStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(deckStore)
        }
    }
}
