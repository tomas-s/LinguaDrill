import Foundation

struct Deck: Codable, Identifiable, Equatable {
    var id: UUID
    var name: String
    var cards: [Card]
    var isDefault: Bool

    init(id: UUID = UUID(), name: String, cards: [Card] = [], isDefault: Bool = false) {
        self.id = id
        self.name = name
        self.cards = cards
        self.isDefault = isDefault
    }

    // Backward-compatible: existing stored decks without isDefault load fine.
    enum CodingKeys: String, CodingKey {
        case id, name, cards, isDefault
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id        = try c.decode(UUID.self,    forKey: .id)
        name      = try c.decode(String.self,  forKey: .name)
        cards     = try c.decode([Card].self,  forKey: .cards)
        isDefault = try c.decodeIfPresent(Bool.self, forKey: .isDefault) ?? false
    }
}
