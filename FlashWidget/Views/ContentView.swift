import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DeckListView()
                .tabItem { Label("Decky", systemImage: "rectangle.stack") }
            SettingsView()
                .tabItem { Label("Nastavenia", systemImage: "gear") }
        }
    }
}
