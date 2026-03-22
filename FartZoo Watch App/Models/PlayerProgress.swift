import SwiftData
import Foundation

@Model
class CollectedAnimal {
    var animalID: String = ""
    var count: Int = 1
    var collectedAt: Date = Date()

    init(animalID: String) {
        self.animalID = animalID
        self.count = 1
        self.collectedAt = Date()
    }
}

@Model
class CollectedHybrid {
    var hybridID: String = ""
    var name: String = ""
    var emoji: String = ""
    var parent1ID: String = ""
    var parent2ID: String = ""
    var count: Int = 1
    var createdAt: Date = Date()

    init(hybridID: String, name: String, emoji: String, parent1ID: String, parent2ID: String) {
        self.hybridID = hybridID
        self.name = name
        self.emoji = emoji
        self.parent1ID = parent1ID
        self.parent2ID = parent2ID
        self.count = 1
        self.createdAt = Date()
    }
}

@Model
class PlayerProgress {
    var coins: Int
    var lastDailyChallengeDate: Date?
    var dailyChallengesCompletedMask: Int  // bitmask: bit i set = challenge i completed today

    init() {
        self.coins = 50
        self.lastDailyChallengeDate = nil
        self.dailyChallengesCompletedMask = 0
    }
}
