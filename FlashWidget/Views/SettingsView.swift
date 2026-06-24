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
                    Picker("Aktívny deck", selection: $selectedDeckId) {
                        Text("Žiadny").tag(nil as UUID?)
                        ForEach(store.decks) { deck in
                            Text(deck.name).tag(deck.id as UUID?)
                        }
                    }
                    Picker("Interval", selection: $selectedInterval) {
                        ForEach(CardInterval.allCases, id: \.self) { interval in
                            Text(interval.displayName).tag(interval)
                        }
                    }
                }
                Section("Import") {
                    Button("Importovať deck z JSON") {
                        showingImport = true
                    }
                }
            }
            .navigationTitle("Nastavenia")
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
            .alert("Chyba importu", isPresented: $showingImportError) {
                Button("OK") {}
            } message: {
                Text(importError ?? "Neznáma chyba")
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
                importError = "Nemáš prístup k súboru"
                showingImportError = true
                return
            }
            defer { url.stopAccessingSecurityScopedResource() }
            do {
                let data = try Data(contentsOf: url)
                let imported = try JSONDecoder().decode(ImportedDeck.self, from: data)

                for card in imported.cards {
                    if card.phrase.count > 40 {
                        importError = "Fráza '\(card.phrase)' je dlhšia ako 40 znakov"
                        showingImportError = true
                        return
                    }
                    if card.translation.count > 80 {
                        importError = "Preklad pre '\(card.phrase)' je dlhší ako 80 znakov"
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
                importError = "Neplatný formát JSON. Skontroluj štruktúru súboru."
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
