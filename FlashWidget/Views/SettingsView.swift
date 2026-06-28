import SwiftUI
import WidgetKit
import UniformTypeIdentifiers

struct SettingsView: View {
    @EnvironmentObject var store: DeckStore

    @State private var selectedDeckId: UUID? = WidgetSettings.selectedDeckId
    @State private var selectedInterval: CardInterval = WidgetSettings.interval
    @State private var showingImport = false
    @State private var importError: String?
    @State private var showingImportError = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Widget") {
                    Picker("Active Deck", selection: $selectedDeckId) {
                        Text("None").tag(nil as UUID?)
                        ForEach(store.decks) { deck in
                            Text(deck.name).tag(deck.id as UUID?)
                        }
                    }
                    Picker("Interval", selection: $selectedInterval) {
                        ForEach(CardInterval.allCases, id: \.self) { interval in
                            Text(LocalizedStringKey(interval.displayName)).tag(interval)
                        }
                    }
                }
                Section("Import") {
                    Button("Import Deck from JSON") {
                        showingImport = true
                    }
                }
            }
            .navigationTitle("Settings")
            .onChange(of: selectedDeckId) { newValue in
                WidgetSettings.selectedDeckId = newValue
                WidgetSettings.currentCardIndex = 0
                WidgetCenter.shared.reloadAllTimelines()
            }
            .onChange(of: selectedInterval) { newValue in
                WidgetSettings.interval = newValue
                WidgetCenter.shared.reloadAllTimelines()
            }
            .fileImporter(
                isPresented: $showingImport,
                allowedContentTypes: [.json]
            ) { result in
                handleImport(result)
            }
            .alert("Import Error", isPresented: $showingImportError) {
                Button("OK") {}
            } message: {
                Text(importError ?? String(localized: "Unknown error"))
            }
        }
    }

    private func handleImport(_ result: Result<URL, Error>) {
        switch result {
        case .failure(let error):
            importError = error.localizedDescription
            showingImportError = true
        case .success(let url):
            guard url.startAccessingSecurityScopedResource() else {
                importError = String(localized: "You don't have access to the file")
                showingImportError = true
                return
            }
            defer { url.stopAccessingSecurityScopedResource() }
            do {
                let data = try Data(contentsOf: url)
                let imported = try JSONDecoder().decode(ImportedDeck.self, from: data)

                for card in imported.cards {
                    if card.phrase.count > 40 {
                        importError = String(format: String(localized: "Phrase '%@' exceeds the 40 character limit"), card.phrase)
                        showingImportError = true
                        return
                    }
                    if card.translation.count > 80 {
                        importError = String(format: String(localized: "Translation for '%@' exceeds the 80 character limit"), card.phrase)
                        showingImportError = true
                        return
                    }
                }

                let deck = Deck(
                    name: imported.name,
                    cards: imported.cards.map { Card(phrase: $0.phrase, translation: $0.translation) }
                )
                store.addDeck(deck)
            } catch {
                importError = String(localized: "Invalid JSON format. Please check the file structure.")
                showingImportError = true
            }
        }
    }
}

private struct ImportedDeck: Codable {
    let name: String
    let cards: [ImportedCard]
}

private struct ImportedCard: Codable {
    let phrase: String
    let translation: String
}
