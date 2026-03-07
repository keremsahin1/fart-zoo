import Foundation
import Observation
import WatchKit

enum QuestState {
    case notStarted, inProgress, won, lost, insufficientCoins
}

@Observable
class QuestViewModel {
    let animal: AnimalDefinition
    var state: QuestState = .notStarted
    var tapCount = 0
    var timeRemaining: Double = 0
    private var timer: Timer?

    var tapTarget: Int {
        switch animal.rarity {
        case .common:    return 10
        case .uncommon:  return 20
        case .rare:      return 35
        case .legendary: return 50
        case .extinct:   return 75
        }
    }

    var timeLimit: Double {
        switch animal.rarity {
        case .common:    return 8.0
        case .uncommon:  return 10.0
        case .rare:      return 12.0
        case .legendary: return 15.0
        case .extinct:   return 18.0
        }
    }

    var isTimeWarning: Bool { timeRemaining < 3 && timeRemaining > 0 }

    init(animal: AnimalDefinition) {
        self.animal = animal
    }

    func startQuest(playerProgress: PlayerProgress) {
        guard playerProgress.coins >= animal.rarity.coinCost else {
            state = .insufficientCoins
            return
        }
        playerProgress.coins -= animal.rarity.coinCost
        tapCount = 0
        timeRemaining = timeLimit
        state = .inProgress

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.timeRemaining -= 0.1
            if self.timeRemaining <= 0 {
                self.fail()
            }
        }
    }

    func tap(playerProgress: PlayerProgress) {
        guard state == .inProgress else { return }
        tapCount += 1
        SoundManager.shared.play(soundFile: animal.soundFile)
        WKInterfaceDevice.current().play(.click)

        if tapCount >= tapTarget {
            win(playerProgress: playerProgress)
        }
    }

    private func win(playerProgress: PlayerProgress) {
        timer?.invalidate()
        timer = nil
        state = .won
        playerProgress.coins += animal.rarity.coinReward
        SoundManager.shared.playVictory()
    }

    private func fail() {
        timer?.invalidate()
        timer = nil
        state = .lost
        SoundManager.shared.playFailure()
    }
}
