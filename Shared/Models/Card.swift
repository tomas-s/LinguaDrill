import Foundation

struct Card: Codable, Identifiable, Equatable {
    var id: UUID
    var phrase: String
    var translation: String

    init(id: UUID = UUID(), phrase: String, translation: String) {
        self.id = id
        self.phrase = phrase
        self.translation = translation
    }
}
