import Foundation

extension String {
    func lowercasingFirstLetter() -> String {
        guard let first = first else { return self }
        return first.lowercased() + dropFirst()
    }
}

struct Card: Codable, Identifiable, Equatable {
    var id: UUID
    var phrase: String
    var translation: String

    init(id: UUID = UUID(), phrase: String, translation: String) {
        self.id = id
        self.phrase = phrase.lowercasingFirstLetter()
        self.translation = translation.lowercasingFirstLetter()
    }
}
