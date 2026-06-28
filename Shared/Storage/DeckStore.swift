import Foundation
import Combine

final class DeckStore: ObservableObject {
    @Published var decks: [Deck] = []

    private var fileURL: URL {
        let container = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: WidgetSettings.appGroupIdentifier)
            ?? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return container.appendingPathComponent("decks.json")
    }

    init() {
        load()
    }

    func load() {
        guard
            let data = try? Data(contentsOf: fileURL),
            let decoded = try? JSONDecoder().decode([Deck].self, from: data)
        else {
            decks = []
            return
        }
        decks = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(decks) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    func addDeck(_ deck: Deck) {
        decks.append(deck)
        save()
    }

    func deleteDeck(at offsets: IndexSet) {
        offsets.sorted(by: >).forEach { decks.remove(at: $0) }
        save()
    }

    func deleteDeck(id: UUID) {
        decks.removeAll { $0.id == id }
        save()
    }

    func updateDeck(_ deck: Deck) {
        guard let index = decks.firstIndex(where: { $0.id == deck.id }) else { return }
        decks[index] = deck
        save()
    }

    // MARK: – Default deck seeding

    func seedDefaultsIfNeeded() {
        guard !WidgetSettings.defaultsSeeded else { return }
        guard
            let url = Bundle.main.url(forResource: "DefaultDecks", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let imported = try? JSONDecoder().decode([SeedDeck].self, from: data)
        else { return }

        let defaults = imported.map { d in
            Deck(
                name: d.name,
                cards: d.cards.map { Card(phrase: $0.phrase, translation: $0.translation) },
                isDefault: true
            )
        }
        decks.insert(contentsOf: defaults, at: 0)
        save()
        WidgetSettings.defaultsSeeded = true
    }
}

// MARK: – Private helpers for seeding
private struct SeedDeck: Codable {
    let name: String
    let cards: [SeedCard]
}
private struct SeedCard: Codable {
    let phrase: String
    let translation: String
}
