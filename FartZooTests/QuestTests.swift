import XCTest
@testable import FartZoo_Watch_App

final class QuestTests: XCTestCase {

    func test_tap_target_increases_with_rarity() {
        let targets: [Rarity: Int] = [
            .common: 10, .uncommon: 20, .rare: 35, .legendary: 50, .extinct: 75
        ]
        XCTAssertLessThan(targets[.common]!, targets[.uncommon]!)
        XCTAssertLessThan(targets[.uncommon]!, targets[.rare]!)
        XCTAssertLessThan(targets[.rare]!, targets[.legendary]!)
        XCTAssertLessThan(targets[.legendary]!, targets[.extinct]!)
    }

    func test_time_limit_increases_with_rarity() {
        let limits: [Rarity: Double] = [
            .common: 8.0, .uncommon: 10.0, .rare: 12.0, .legendary: 15.0, .extinct: 18.0
        ]
        XCTAssertLessThan(limits[.common]!, limits[.uncommon]!)
        XCTAssertLessThan(limits[.uncommon]!, limits[.rare]!)
        XCTAssertLessThan(limits[.rare]!, limits[.legendary]!)
        XCTAssertLessThan(limits[.legendary]!, limits[.extinct]!)
    }

    func test_coin_cost_is_deducted_on_start() {
        let initialCoins = 50
        let cost = Rarity.common.coinCost  // 10
        let remaining = initialCoins - cost
        XCTAssertEqual(remaining, 40)
    }

    func test_insufficient_coins_blocks_quest() {
        let playerCoins = 5
        let cost = Rarity.common.coinCost  // 10
        XCTAssertFalse(playerCoins >= cost)
    }

    func test_coin_reward_is_half_of_cost() {
        for rarity in Rarity.allCases {
            XCTAssertEqual(rarity.coinReward, rarity.coinCost / 2,
                "\(rarity) coinReward should be half of coinCost")
        }
    }

    // MARK: - Coin Flip Quest

    private func makeCoinFlipVM(animal: AnimalDefinition? = nil) -> QuestViewModel {
        let vm = QuestViewModel(animal: animal ?? AnimalDefinition(
            id: "test_dog", name: "Dog", emoji: "🐕",
            rarity: .common, location: .farm, soundFile: "fart_common_1"
        ))
        vm.chooseQuest(.coinFlip)
        return vm
    }

    private func makeProgress(coins: Int = 500) -> PlayerProgress {
        let p = PlayerProgress()
        p.coins = coins
        return p
    }

    func test_coinFlip_state_becomes_inProgress_after_start() {
        let progress = makeProgress()
        let vm = makeCoinFlipVM()

        vm.startQuest(playerProgress: progress)

        XCTAssertEqual(vm.state, .inProgress)
    }

    func test_coinFlip_deducts_coins_on_start() {
        let cost = Rarity.common.coinCost
        let progress = makeProgress(coins: cost + 10)
        let vm = makeCoinFlipVM()

        vm.startQuest(playerProgress: progress)

        XCTAssertEqual(progress.coins, 10)
    }

    func test_coinFlip_awards_coins_on_win() {
        let cost = Rarity.common.coinCost
        let reward = Rarity.common.coinReward
        let progress = makeProgress(coins: cost)
        let vm = makeCoinFlipVM()
        vm.startQuest(playerProgress: progress)
        let coinsAfterStart = progress.coins  // 0

        vm.win(playerProgress: progress)

        XCTAssertEqual(progress.coins, coinsAfterStart + reward)
    }

    func test_coinFlip_no_refund_on_loss() {
        let cost = Rarity.common.coinCost
        let progress = makeProgress(coins: cost)
        let vm = makeCoinFlipVM()
        vm.startQuest(playerProgress: progress)
        let coinsAfterStart = progress.coins  // 0

        vm.fail()

        XCTAssertEqual(progress.coins, coinsAfterStart, "fail() must not refund the entry cost")
    }

    func test_coinFlip_isFlipping_set_on_crown_spin() {
        let progress = makeProgress()
        let vm = makeCoinFlipVM()
        vm.startQuest(playerProgress: progress)
        XCTAssertFalse(vm.isFlipping, "isFlipping should start false")

        let oldValue = vm.crownRotation
        vm.crownRotation = oldValue + 1.0
        vm.handleCrownChange(oldValue: oldValue, newValue: vm.crownRotation, playerProgress: progress)

        XCTAssertTrue(vm.isFlipping, "isFlipping should be true after any crown movement")
    }

    func test_coinFlip_isFlipping_reset_on_startQuest() {
        let progress = makeProgress()
        let vm = makeCoinFlipVM()
        vm.startQuest(playerProgress: progress)
        vm.isFlipping = true

        let progress2 = makeProgress()
        vm.chooseQuest(.coinFlip)
        vm.startQuest(playerProgress: progress2)

        XCTAssertFalse(vm.isFlipping, "isFlipping must be reset to false when a new quest starts")
    }
}
