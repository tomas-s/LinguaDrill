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

    func updateDeck(_ deck: Deck) {
        guard let index = decks.firstIndex(where: { $0.id == deck.id }) else { return }
        decks[index] = deck
        save()
    }
}
