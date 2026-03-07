import XCTest
@testable import FartZoo_Watch_App

final class QuestViewModelTests: XCTestCase {

    private let commonAnimal = AnimalDefinition(
        id: "test_dog", name: "Dog", emoji: "🐕",
        rarity: .common, location: .farm, soundFile: "fart_common_1"
    )

    private let legendaryAnimal = AnimalDefinition(
        id: "test_whale", name: "Whale", emoji: "🐋",
        rarity: .legendary, location: .ocean, soundFile: "fart_legendary_1"
    )

    private let extinctAnimal = AnimalDefinition(
        id: "test_trex", name: "T-Rex", emoji: "🦖",
        rarity: .extinct, location: .prehistoric, soundFile: "fart_extinct_1"
    )

    private func makeProgress(coins: Int = 500) -> PlayerProgress {
        let p = PlayerProgress()
        p.coins = coins
        return p
    }

    // MARK: - Initial State

    func test_initial_state_is_notStarted() {
        let vm = QuestViewModel(animal: commonAnimal)
        XCTAssertEqual(vm.state, .notStarted)
        XCTAssertEqual(vm.tapCount, 0)
    }

    // MARK: - Tap Targets

    func test_tap_target_common_is_10() {
        let vm = QuestViewModel(animal: commonAnimal)
        XCTAssertEqual(vm.tapTarget, 10)
    }

    func test_tap_target_legendary_is_50() {
        let vm = QuestViewModel(animal: legendaryAnimal)
        XCTAssertEqual(vm.tapTarget, 50)
    }

    func test_tap_target_extinct_is_75() {
        let vm = QuestViewModel(animal: extinctAnimal)
        XCTAssertEqual(vm.tapTarget, 75)
    }

    // MARK: - Time Limits

    func test_time_limit_common_is_8() {
        let vm = QuestViewModel(animal: commonAnimal)
        XCTAssertEqual(vm.timeLimit, 8.0)
    }

    func test_time_limit_legendary_is_15() {
        let vm = QuestViewModel(animal: legendaryAnimal)
        XCTAssertEqual(vm.timeLimit, 15.0)
    }

    // MARK: - Start Quest

    func test_start_quest_deducts_coins() {
        let progress = makeProgress(coins: 100)
        let vm = QuestViewModel(animal: commonAnimal)
        let cost = commonAnimal.rarity.coinCost

        vm.startQuest(playerProgress: progress)

        XCTAssertEqual(progress.coins, 100 - cost)
        XCTAssertEqual(vm.state, .inProgress)
    }

    func test_start_quest_sets_time_remaining() {
        let progress = makeProgress()
        let vm = QuestViewModel(animal: commonAnimal)

        vm.startQuest(playerProgress: progress)

        XCTAssertEqual(vm.timeRemaining, vm.timeLimit, accuracy: 0.01)
    }

    func test_start_quest_resets_tap_count() {
        let progress = makeProgress()
        let vm = QuestViewModel(animal: commonAnimal)
        vm.tapCount = 5

        vm.startQuest(playerProgress: progress)

        XCTAssertEqual(vm.tapCount, 0)
    }

    func test_insufficient_coins_blocks_quest() {
        let progress = makeProgress(coins: 0)
        let vm = QuestViewModel(animal: commonAnimal)

        vm.startQuest(playerProgress: progress)

        XCTAssertEqual(vm.state, .insufficientCoins)
        XCTAssertEqual(progress.coins, 0, "Should not deduct coins")
    }

    func test_insufficient_coins_exact_boundary() {
        let cost = commonAnimal.rarity.coinCost
        let progress = makeProgress(coins: cost - 1)
        let vm = QuestViewModel(animal: commonAnimal)

        vm.startQuest(playerProgress: progress)

        XCTAssertEqual(vm.state, .insufficientCoins)
    }

    func test_exact_coins_allows_quest() {
        let cost = commonAnimal.rarity.coinCost
        let progress = makeProgress(coins: cost)
        let vm = QuestViewModel(animal: commonAnimal)

        vm.startQuest(playerProgress: progress)

        XCTAssertEqual(vm.state, .inProgress)
        XCTAssertEqual(progress.coins, 0)
    }

    // MARK: - Tapping

    func test_tap_increments_count() {
        let progress = makeProgress()
        let vm = QuestViewModel(animal: commonAnimal)
        vm.startQuest(playerProgress: progress)

        vm.tap(playerProgress: progress)
        XCTAssertEqual(vm.tapCount, 1)

        vm.tap(playerProgress: progress)
        XCTAssertEqual(vm.tapCount, 2)
    }

    func test_tap_ignored_when_not_in_progress() {
        let progress = makeProgress()
        let vm = QuestViewModel(animal: commonAnimal)
        // state is .notStarted
        vm.tap(playerProgress: progress)
        XCTAssertEqual(vm.tapCount, 0, "Tap should be ignored when not in progress")
    }

    func test_reaching_tap_target_wins() {
        let progress = makeProgress()
        let vm = QuestViewModel(animal: commonAnimal)
        vm.startQuest(playerProgress: progress)

        let coinsAfterStart = progress.coins
        for _ in 0..<vm.tapTarget {
            vm.tap(playerProgress: progress)
        }

        XCTAssertEqual(vm.state, .won)
        XCTAssertEqual(progress.coins, coinsAfterStart + commonAnimal.rarity.coinReward)
    }

    func test_winning_awards_coin_reward() {
        let progress = makeProgress(coins: 500)
        let vm = QuestViewModel(animal: commonAnimal)
        vm.startQuest(playerProgress: progress)

        let coinsAfterStart = progress.coins
        for _ in 0..<vm.tapTarget {
            vm.tap(playerProgress: progress)
        }

        XCTAssertEqual(progress.coins, coinsAfterStart + commonAnimal.rarity.coinReward)
    }

    func test_taps_after_winning_are_ignored() {
        let progress = makeProgress()
        let vm = QuestViewModel(animal: commonAnimal)
        vm.startQuest(playerProgress: progress)

        for _ in 0..<vm.tapTarget {
            vm.tap(playerProgress: progress)
        }
        XCTAssertEqual(vm.state, .won)

        let tapCountAtWin = vm.tapCount
        vm.tap(playerProgress: progress)
        XCTAssertEqual(vm.tapCount, tapCountAtWin, "Taps after winning should be ignored")
    }

    // MARK: - Rarity Scaling

    func test_higher_rarity_costs_more_coins() {
        let commonCost = Rarity.common.coinCost
        let legendaryCost = Rarity.legendary.coinCost
        let extinctCost = Rarity.extinct.coinCost

        XCTAssertLessThan(commonCost, legendaryCost)
        XCTAssertLessThan(legendaryCost, extinctCost)
    }

    func test_higher_rarity_needs_more_taps() {
        let commonVM = QuestViewModel(animal: commonAnimal)
        let legendaryVM = QuestViewModel(animal: legendaryAnimal)
        let extinctVM = QuestViewModel(animal: extinctAnimal)

        XCTAssertLessThan(commonVM.tapTarget, legendaryVM.tapTarget)
        XCTAssertLessThan(legendaryVM.tapTarget, extinctVM.tapTarget)
    }

    func test_higher_rarity_has_more_time() {
        let commonVM = QuestViewModel(animal: commonAnimal)
        let legendaryVM = QuestViewModel(animal: legendaryAnimal)
        let extinctVM = QuestViewModel(animal: extinctAnimal)

        XCTAssertLessThan(commonVM.timeLimit, legendaryVM.timeLimit)
        XCTAssertLessThan(legendaryVM.timeLimit, extinctVM.timeLimit)
    }
}
