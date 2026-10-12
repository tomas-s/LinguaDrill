import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var showingQuickAdd = false

    var body: some View {
        TabView {
            DeckListView()
                .tabItem { Label("Decks", systemImage: "rectangle.stack") }
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
        }
        .sheet(isPresented: $showingQuickAdd) {
            QuickAddCardView()
        }
        .onAppear(perform: handlePendingAddCard)
        .onChange(of: scenePhase) { phase in
            if phase == .active { handlePendingAddCard() }
        }
        .onReceive(NotificationCenter.default.publisher(for: .addCardRequested)) { _ in
            handlePendingAddCard()
        }
    }

    private func handlePendingAddCard() {
        guard WidgetSettings.pendingAddCard else { return }
        WidgetSettings.pendingAddCard = false
        showingQuickAdd = true
    }
}
