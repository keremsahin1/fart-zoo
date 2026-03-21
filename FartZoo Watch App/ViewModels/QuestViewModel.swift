import Foundation
import Observation
import WatchKit

enum QuestState: Equatable {
    case choosingQuest, notStarted, inProgress, won, lost, insufficientCoins
}

enum QuestType: String, CaseIterable {
    case tap
    case spin
    case timing

    var label: String {
        switch self {
        case .tap:    return "TAP!"
        case .spin:   return "SPIN!"
        case .timing: return "TIME!"
        }
    }

    var emoji: String {
        switch self {
        case .tap:    return "👆"
        case .spin:   return "🌀"
        case .timing: return "👀"
        }
    }

    var hint: String {
        switch self {
        case .tap:    return "Tap as fast as you can!"
        case .spin:   return "Spin the Digital Crown!"
        case .timing: return "Tap the animal!\nDon't tap the fart cloud!"
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
    var isAnimalVisible = true
    private var timer: Timer?
    private var visibilityTimer: Timer?

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
        case .common:    return 500
        case .uncommon:  return 1000
        case .rare:      return 1750
        case .legendary: return 2500
        case .extinct:   return 4000
        }
    }

    var timingTarget: Int {
        switch animal.rarity {
        case .common:    return 5
        case .uncommon:  return 8
        case .rare:      return 12
        case .legendary: return 16
        case .extinct:   return 20
        }
    }

    var visibleDuration: Double {
        switch animal.rarity {
        case .common:    return 1.2
        case .uncommon:  return 1.0
        case .rare:      return 0.8
        case .legendary: return 0.7
        case .extinct:   return 0.6
        }
    }

    var hiddenDuration: Double {
        switch animal.rarity {
        case .common:    return 0.8
        case .uncommon:  return 1.0
        case .rare:      return 1.2
        case .legendary: return 1.3
        case .extinct:   return 1.4
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
        case .tap:    return Double(tapCount) / Double(tapTarget)
        case .spin:   return spinProgress / spinTarget
        case .timing: return Double(tapCount) / Double(timingTarget)
        }
    }

    var progressText: String {
        switch questType {
        case .tap:    return "\(tapCount) / \(tapTarget)"
        case .spin:   return "\(Int(spinProgress)) / \(Int(spinTarget))"
        case .timing: return "\(tapCount) / \(timingTarget)"
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
        lastFartThreshold = 0
        isAnimalVisible = true
        timeRemaining = timeLimit
        state = .inProgress

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.timeRemaining -= 0.1
            if self.timeRemaining <= 0 {
                self.fail()
            }
        }

        if questType == .timing {
            startVisibilityCycle()
        }
    }

    // MARK: - Tap Quest

    func tap(playerProgress: PlayerProgress) {
        guard state == .inProgress, questType == .tap else { return }
        tapCount += 1
        SoundManager.shared.play(soundFile: animal.soundFile)
        WKInterfaceDevice.current().play(.click)

        if tapCount >= tapTarget {
            win(playerProgress: playerProgress)
        }
    }

    // MARK: - Spin Quest

    private var lastFartThreshold: Int = 0

    var spinFartInterval: Double { spinTarget / 5 }

    func handleCrownChange(oldValue: Double, newValue: Double, playerProgress: PlayerProgress) {
        guard state == .inProgress, questType == .spin else { return }
        let delta = abs(newValue - oldValue)
        guard delta > 0.01 else { return }
        spinProgress += delta
        WKInterfaceDevice.current().play(.click)

        let currentThreshold = Int(spinProgress / spinFartInterval)
        if currentThreshold > lastFartThreshold {
            lastFartThreshold = currentThreshold
            SoundManager.shared.play(soundFile: animal.soundFile)
        }

        if spinProgress >= spinTarget {
            win(playerProgress: playerProgress)
        }
    }

    // MARK: - Timing Quest

    func timingTap(playerProgress: PlayerProgress) {
        guard state == .inProgress, questType == .timing else { return }

        if isAnimalVisible {
            tapCount += 1
            SoundManager.shared.play(soundFile: animal.soundFile)
            WKInterfaceDevice.current().play(.click)

            if tapCount >= timingTarget {
                win(playerProgress: playerProgress)
            }
        } else {
            tapCount = max(0, tapCount - 1)
            WKInterfaceDevice.current().play(.failure)
        }
    }

    private func startVisibilityCycle() {
        scheduleHide()
    }

    private func scheduleHide() {
        visibilityTimer?.invalidate()
        visibilityTimer = Timer.scheduledTimer(withTimeInterval: visibleDuration, repeats: false) { [weak self] _ in
            guard let self, self.state == .inProgress else { return }
            self.isAnimalVisible = false
            self.scheduleShow()
        }
    }

    private func scheduleShow() {
        visibilityTimer?.invalidate()
        visibilityTimer = Timer.scheduledTimer(withTimeInterval: hiddenDuration, repeats: false) { [weak self] _ in
            guard let self, self.state == .inProgress else { return }
            self.isAnimalVisible = true
            self.scheduleHide()
        }
    }

    // MARK: - Win / Fail

    private func win(playerProgress: PlayerProgress) {
        timer?.invalidate()
        timer = nil
        visibilityTimer?.invalidate()
        visibilityTimer = nil
        state = .won
        playerProgress.coins += animal.rarity.coinReward
        SoundManager.shared.playVictory()
    }

    private func fail() {
        timer?.invalidate()
        timer = nil
        visibilityTimer?.invalidate()
        visibilityTimer = nil
        state = .lost
        SoundManager.shared.playFailure()
    }
}
