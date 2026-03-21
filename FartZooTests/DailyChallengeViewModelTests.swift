import XCTest
@testable import FartZoo_Watch_App

final class DailyChallengeViewModelTests: XCTestCase {

    private func makeProgress() -> PlayerProgress {
        PlayerProgress()
    }

    func test_init_creates_5_challenges_with_zero_progress() {
        let vm = DailyChallengeViewModel(playerProgress: makeProgress())
        XCTAssertEqual(vm.challenges.count, 5)
        XCTAssertEqual(vm.progressValues.count, 5)
        for i in 0..<5 {
            XCTAssertEqual(vm.progressValues[i], 0)
            XCTAssertFalse(vm.isCompleted(i))
        }
    }

    func test_init_resets_mask_if_last_date_is_not_today() {
        let progress = makeProgress()
        progress.dailyChallengesCompletedMask = 0b11111
        progress.lastDailyChallengeDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let vm = DailyChallengeViewModel(playerProgress: progress)
        XCTAssertEqual(vm.completedMask, 0, "Should reset mask for a new day")
    }

    func test_init_restores_mask_if_last_date_is_today() {
        let progress = makeProgress()
        progress.dailyChallengesCompletedMask = 0b00101
        progress.lastDailyChallengeDate = Date()
        let vm = DailyChallengeViewModel(playerProgress: progress)
        XCTAssertEqual(vm.completedMask, 0b00101, "Should restore today's mask")
    }

    func test_isCompleted_uses_bitmask() {
        let vm = DailyChallengeViewModel(playerProgress: makeProgress())
        vm.completedMask = 0b01010  // challenges 1 and 3 completed
        XCTAssertFalse(vm.isCompleted(0))
        XCTAssertTrue(vm.isCompleted(1))
        XCTAssertFalse(vm.isCompleted(2))
        XCTAssertTrue(vm.isCompleted(3))
        XCTAssertFalse(vm.isCompleted(4))
    }

    func test_allCompleted_true_when_all_5_bits_set() {
        let vm = DailyChallengeViewModel(playerProgress: makeProgress())
        vm.completedMask = 0b11111
        XCTAssertTrue(vm.allCompleted)
    }

    func test_allCompleted_false_when_some_bits_unset() {
        let vm = DailyChallengeViewModel(playerProgress: makeProgress())
        vm.completedMask = 0b11011
        XCTAssertFalse(vm.allCompleted)
    }

    func test_progressFraction_clamped_to_1() {
        let vm = DailyChallengeViewModel(playerProgress: makeProgress())
        vm.progressValues[0] = vm.challenges[0].target + 10
        XCTAssertEqual(vm.progressFraction(for: 0), 1.0, accuracy: 0.001)
    }

    func test_progressFraction_zero_when_no_progress() {
        let vm = DailyChallengeViewModel(playerProgress: makeProgress())
        XCTAssertEqual(vm.progressFraction(for: 0), 0.0, accuracy: 0.001)
    }

    func test_record_increments_matching_challenge_progress() {
        let progress = makeProgress()
        let vm = DailyChallengeViewModel(playerProgress: progress)

        // Find a fart challenge
        if let fartIndex = vm.challenges.firstIndex(where: { $0.type == .fartAnimals }) {
            let before = vm.progressValues[fartIndex]
            vm.recordFart(playerProgress: progress)
            XCTAssertEqual(vm.progressValues[fartIndex], before + 1)
        }
    }

    func test_record_does_not_increment_completed_challenge() {
        let progress = makeProgress()
        let vm = DailyChallengeViewModel(playerProgress: progress)

        // Find a fart challenge and mark it completed
        if let fartIndex = vm.challenges.firstIndex(where: { $0.type == .fartAnimals }) {
            vm.completedMask |= (1 << fartIndex)
            let before = vm.progressValues[fartIndex]
            vm.recordFart(playerProgress: progress)
            XCTAssertEqual(vm.progressValues[fartIndex], before, "Completed challenge should not increment")
        }
    }

    func test_completion_awards_coins() {
        let progress = makeProgress()
        let vm = DailyChallengeViewModel(playerProgress: progress)

        // Find a fart challenge and fill progress to just under target
        if let fartIndex = vm.challenges.firstIndex(where: { $0.type == .fartAnimals }) {
            let target = vm.challenges[fartIndex].target
            let reward = vm.challenges[fartIndex].coinReward
            vm.progressValues[fartIndex] = target - 1

            let coinsBefore = progress.coins
            vm.recordFart(playerProgress: progress)

            XCTAssertTrue(vm.isCompleted(fartIndex), "Challenge should be completed")
            XCTAssertEqual(progress.coins, coinsBefore + reward, "Should award coin reward")
        }
    }

    func test_completion_updates_player_progress_mask_and_date() {
        let progress = makeProgress()
        let vm = DailyChallengeViewModel(playerProgress: progress)

        if let fartIndex = vm.challenges.firstIndex(where: { $0.type == .fartAnimals }) {
            vm.progressValues[fartIndex] = vm.challenges[fartIndex].target - 1
            vm.recordFart(playerProgress: progress)

            XCTAssertNotNil(progress.lastDailyChallengeDate)
            XCTAssertTrue(Calendar.current.isDateInToday(progress.lastDailyChallengeDate!))
            XCTAssertNotEqual(progress.dailyChallengesCompletedMask, 0)
        }
    }

    func test_record_teleport_increments_teleport_challenges() {
        let progress = makeProgress()
        let vm = DailyChallengeViewModel(playerProgress: progress)

        if let teleportIndex = vm.challenges.firstIndex(where: { $0.type == .teleport }) {
            let before = vm.progressValues[teleportIndex]
            vm.recordTeleport(playerProgress: progress)
            XCTAssertEqual(vm.progressValues[teleportIndex], before + 1)
        }
    }

    func test_record_catch_increments_catch_challenges() {
        let progress = makeProgress()
        let vm = DailyChallengeViewModel(playerProgress: progress)

        if let catchIndex = vm.challenges.firstIndex(where: { $0.type == .catchAnimals }) {
            let before = vm.progressValues[catchIndex]
            vm.recordCatch(questType: .tap, playerProgress: progress)
            XCTAssertEqual(vm.progressValues[catchIndex], before + 1)
        }
    }

    func test_record_spin_catch_increments_spin_challenges() {
        let progress = makeProgress()
        let vm = DailyChallengeViewModel(playerProgress: progress)

        if let spinIndex = vm.challenges.firstIndex(where: { $0.type == .spinCatch }) {
            let before = vm.progressValues[spinIndex]
            vm.recordCatch(questType: .spin, playerProgress: progress)
            XCTAssertEqual(vm.progressValues[spinIndex], before + 1)
        }
    }

    func test_tap_catch_does_not_increment_spin_challenges() {
        let progress = makeProgress()
        let vm = DailyChallengeViewModel(playerProgress: progress)

        if let spinIndex = vm.challenges.firstIndex(where: { $0.type == .spinCatch }) {
            let before = vm.progressValues[spinIndex]
            vm.recordCatch(questType: .tap, playerProgress: progress)
            XCTAssertEqual(vm.progressValues[spinIndex], before, "Tap catch should not count toward spin challenges")
        }
    }

    func test_record_spin_attempt_increments_spin_master() {
        let progress = makeProgress()
        let vm = DailyChallengeViewModel(playerProgress: progress)

        if let masterIndex = vm.challenges.firstIndex(where: { $0.type == .spinMaster }) {
            let before = vm.progressValues[masterIndex]
            vm.recordSpinAttempt(playerProgress: progress)
            XCTAssertEqual(vm.progressValues[masterIndex], before + 1)
        }
    }

    func test_record_hybrid_increments_hybrid_challenges() {
        let progress = makeProgress()
        let vm = DailyChallengeViewModel(playerProgress: progress)

        if let hybridIndex = vm.challenges.firstIndex(where: { $0.type == .makeHybrid }) {
            let before = vm.progressValues[hybridIndex]
            vm.recordHybrid(playerProgress: progress)
            XCTAssertEqual(vm.progressValues[hybridIndex], before + 1)
        }
    }
}
