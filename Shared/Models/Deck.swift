import Foundation

struct Deck: Codable, Identifiable, Equatable {
    var id: UUID
    var name: String
    var cards: [Card]

    init(id: UUID = UUID(), name: String, cards: [Card] = []) {
        self.id = id
        self.name = name
        self.cards = cards
    }
}
