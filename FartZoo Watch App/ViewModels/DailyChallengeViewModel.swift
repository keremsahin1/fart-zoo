import SwiftUI
import Observation

@Observable
class DailyChallengeViewModel {
    let challenge: DailyChallenge
    var progress: Int = 0
    var completed: Bool = false

    init(playerProgress: PlayerProgress) {
        self.challenge = DailyChallenge.forDate(Date())

        if let lastDate = playerProgress.lastDailyChallengeDate,
           Calendar.current.isDateInToday(lastDate),
           playerProgress.dailyChallengeCompleted {
            self.completed = true
        }
    }

    var progressFraction: Double {
        min(Double(progress) / Double(challenge.target), 1.0)
    }

    func recordFart(playerProgress: PlayerProgress) {
        guard !completed, challenge.type == .fartAnimals else { return }
        progress += 1
        checkCompletion(playerProgress: playerProgress)
    }

    func recordTeleport(playerProgress: PlayerProgress) {
        guard !completed, challenge.type == .teleport else { return }
        progress += 1
        checkCompletion(playerProgress: playerProgress)
    }

    func recordCatch(playerProgress: PlayerProgress) {
        guard !completed, challenge.type == .catchAnimals else { return }
        progress += 1
        checkCompletion(playerProgress: playerProgress)
    }

    func recordHybrid(playerProgress: PlayerProgress) {
        guard !completed, challenge.type == .makeHybrid else { return }
        progress += 1
        checkCompletion(playerProgress: playerProgress)
    }

    private func checkCompletion(playerProgress: PlayerProgress) {
        if progress >= challenge.target {
            completed = true
            playerProgress.coins += challenge.coinReward
            playerProgress.dailyChallengeCompleted = true
            playerProgress.lastDailyChallengeDate = Date()
            SoundManager.shared.playVictory()
        }
    }
}
