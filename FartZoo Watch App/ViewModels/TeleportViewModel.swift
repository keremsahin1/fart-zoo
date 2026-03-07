import SwiftUI
import Observation

@Observable
class TeleportViewModel {
    var currentLocation: WorldLocation?
    var shuffledAnimals: [AnimalDefinition] = []
    var isAnimating = false
    var showQuest = false
    var selectedAnimal: AnimalDefinition?

    func teleport() {
        isAnimating = true
        SoundManager.shared.playTeleport()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let location = WorldLocation.random()
            self.currentLocation = location
            self.shuffledAnimals = AnimalDatabase.shared.animals(for: location).shuffled()
            self.isAnimating = false
        }
    }

    func selectAnimal(_ animal: AnimalDefinition) {
        selectedAnimal = animal
        showQuest = true
    }
}
