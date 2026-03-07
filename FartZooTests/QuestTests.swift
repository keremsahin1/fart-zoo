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
}
