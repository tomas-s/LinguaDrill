import WidgetKit
import Foundation

struct FlashEntry: TimelineEntry {
    let date: Date
    let phrase: String
    let translation: String
    let isEmpty: Bool
}

struct FlashProvider: TimelineProvider {
    func placeholder(in context: Context) -> FlashEntry {
        FlashEntry(date: .now, phrase: "hands-on", translation: "praktický", isEmpty: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (FlashEntry) -> Void) {
        completion(entry(for: .now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<FlashEntry>) -> Void) {
        let cards = activeCards()
        let intervalSeconds = WidgetSettings.interval.timeInterval

        guard !cards.isEmpty else {
            let empty = FlashEntry(date: .now, phrase: "", translation: "", isEmpty: true)
            completion(Timeline(entries: [empty], policy: .never))
            return
        }

        let startIndex = WidgetSettings.currentCardIndex % cards.count
        var entries: [FlashEntry] = []
        var date = Date.now

        for i in 0..<cards.count {
            let card = cards[(startIndex + i) % cards.count]
            entries.append(FlashEntry(date: date, phrase: card.phrase, translation: card.translation, isEmpty: false))
            date = date.addingTimeInterval(intervalSeconds)
        }

        // After a full cycle, reset to card 0 and reload
        WidgetSettings.currentCardIndex = 0
        completion(Timeline(entries: entries, policy: .after(date)))
    }

    private func activeCards() -> [Card] {
        guard let deckId = WidgetSettings.selectedDeckId else { return [] }
        return DeckStore().decks.first { $0.id == deckId }?.cards ?? []
    }

    private func entry(for date: Date) -> FlashEntry {
        let cards = activeCards()
        guard !cards.isEmpty else {
            return FlashEntry(date: date, phrase: "", translation: "", isEmpty: true)
        }
        let card = cards[WidgetSettings.currentCardIndex % cards.count]
        return FlashEntry(date: date, phrase: card.phrase, translation: card.translation, isEmpty: false)
    }
}
