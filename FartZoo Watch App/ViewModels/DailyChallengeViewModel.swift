import SwiftUI
import Observation

@Observable
class DailyChallengeViewModel {
    let challenges: [DailyChallenge]
    var progressValues: [Int]
    var completedMask: Int

    init(playerProgress: PlayerProgress) {
        self.challenges = DailyChallenge.allForDate(Date())
        self.progressValues = Array(repeating: 0, count: 5)

        // Restore today's completed challenges
        if let lastDate = playerProgress.lastDailyChallengeDate,
           Calendar.current.isDateInToday(lastDate) {
            self.completedMask = playerProgress.dailyChallengesCompletedMask
        } else {
            self.completedMask = 0
        }
    }

    func isCompleted(_ index: Int) -> Bool {
        completedMask & (1 << index) != 0
    }

    var allCompleted: Bool {
        completedMask == (1 << challenges.count) - 1
    }

    func progressFraction(for index: Int) -> Double {
        min(Double(progressValues[index]) / Double(challenges[index].target), 1.0)
    }

    func recordFart(playerProgress: PlayerProgress) {
        record(type: .fartAnimals, playerProgress: playerProgress)
    }

    func recordTeleport(playerProgress: PlayerProgress) {
        record(type: .teleport, playerProgress: playerProgress)
    }

    func recordCatch(questType: QuestType, playerProgress: PlayerProgress) {
        record(type: .catchAnimals, playerProgress: playerProgress)
        if questType == .spin {
            record(type: .spinCatch, playerProgress: playerProgress)
        }
        recordWinWithBoth(questType: questType, playerProgress: playerProgress)
    }

    func recordSpinAttempt(playerProgress: PlayerProgress) {
        record(type: .spinMaster, playerProgress: playerProgress)
    }

    func recordHybrid(playerProgress: PlayerProgress) {
        record(type: .makeHybrid, playerProgress: playerProgress)
    }

    private var hasWonWithTap = false
    private var hasWonWithSpin = false

    private func recordWinWithBoth(questType: QuestType, playerProgress: PlayerProgress) {
        if questType == .tap { hasWonWithTap = true }
        if questType == .spin { hasWonWithSpin = true }
        if hasWonWithTap && hasWonWithSpin {
            record(type: .winWithBoth, playerProgress: playerProgress)
        }
    }

    private func record(type: DailyChallengeType, playerProgress: PlayerProgress) {
        for i in challenges.indices {
            guard challenges[i].type == type && !isCompleted(i) else { continue }
            progressValues[i] += 1
            checkCompletion(index: i, playerProgress: playerProgress)
        }
    }

    private func checkCompletion(index: Int, playerProgress: PlayerProgress) {
        guard progressValues[index] >= challenges[index].target else { return }
        completedMask |= (1 << index)
        playerProgress.coins += challenges[index].coinReward
        playerProgress.dailyChallengesCompletedMask = completedMask
        playerProgress.lastDailyChallengeDate = Date()
        SoundManager.shared.playVictory()
    }
}
