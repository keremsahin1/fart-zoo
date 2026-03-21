import Foundation
import Observation
import WatchKit

enum QuestState: Equatable {
    case choosingQuest, notStarted, inProgress, won, lost, insufficientCoins
}

enum QuestType: String, CaseIterable {
    case tap
    case spin

    var label: String {
        switch self {
        case .tap:  return "TAP!"
        case .spin: return "SPIN!"
        }
    }

    var emoji: String {
        switch self {
        case .tap:  return "👆"
        case .spin: return "🌀"
        }
    }
}

@Observable
class QuestViewModel {
    let animal: AnimalDefinition
    var questType: QuestType = .tap
    var state: QuestState = .choosingQuest
    var tapCount = 0
    var spinProgress: Double = 0
    var crownRotation: Double = 0
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

    var spinTarget: Double {
        switch animal.rarity {
        case .common:    return 50
        case .uncommon:  return 100
        case .rare:      return 175
        case .legendary: return 250
        case .extinct:   return 400
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

    var progress: Double {
        switch questType {
        case .tap:  return Double(tapCount) / Double(tapTarget)
        case .spin: return spinProgress / spinTarget
        }
    }

    var progressText: String {
        switch questType {
        case .tap:  return "\(tapCount) / \(tapTarget)"
        case .spin: return "\(Int(spinProgress)) / \(Int(spinTarget))"
        }
    }

    init(animal: AnimalDefinition) {
        self.animal = animal
    }

    func chooseQuest(_ type: QuestType) {
        questType = type
        state = .notStarted
    }

    func startQuest(playerProgress: PlayerProgress) {
        guard playerProgress.coins >= animal.rarity.coinCost else {
            state = .insufficientCoins
            return
        }
        playerProgress.coins -= animal.rarity.coinCost
        tapCount = 0
        spinProgress = 0
        crownRotation = 0
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
        guard state == .inProgress, questType == .tap else { return }
        tapCount += 1
        SoundManager.shared.play(soundFile: animal.soundFile)
        WKInterfaceDevice.current().play(.click)

        if tapCount >= tapTarget {
            win(playerProgress: playerProgress)
        }
    }

    func handleCrownChange(oldValue: Double, newValue: Double, playerProgress: PlayerProgress) {
        guard state == .inProgress, questType == .spin else { return }
        let delta = abs(newValue - oldValue)
        guard delta > 0.01 else { return }
        spinProgress += delta
        WKInterfaceDevice.current().play(.click)

        if spinProgress >= spinTarget {
            SoundManager.shared.play(soundFile: animal.soundFile)
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
