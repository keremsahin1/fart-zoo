import XCTest
@testable import FartZoo_Watch_App

final class ModelTests: XCTestCase {

    func test_animal_rarity_coinCost_increases_with_rarity() {
        XCTAssertLessThan(Rarity.common.coinCost, Rarity.uncommon.coinCost)
        XCTAssertLessThan(Rarity.uncommon.coinCost, Rarity.rare.coinCost)
        XCTAssertLessThan(Rarity.rare.coinCost, Rarity.legendary.coinCost)
        XCTAssertLessThan(Rarity.legendary.coinCost, Rarity.extinct.coinCost)
    }

    func test_animal_has_required_properties() {
        let animal = AnimalDefinition(
            id: "dog",
            name: "Dog",
            emoji: "🐕",
            rarity: .common,
            location: .farm,
            soundFile: "fart_common_1"
        )
        XCTAssertEqual(animal.id, "dog")
        XCTAssertEqual(animal.rarity.coinCost, Rarity.common.coinCost)
    }

    func test_hybrid_name_combines_parent_names() {
        let name = HybridAnimal.hybridName(parent1: "Dog", parent2: "Fish")
        XCTAssertEqual(name, "Dogish")
    }

    func test_daily_challenge_returns_valid_challenges() {
        let challenges = DailyChallenge.allForDate(Date())
        XCTAssertEqual(challenges.count, 5)
        for challenge in challenges {
            XCTAssertGreaterThan(challenge.coinReward, 0)
            XCTAssertGreaterThan(challenge.target, 0)
            XCTAssertFalse(challenge.description.isEmpty)
        }
    }

    func test_world_location_random_returns_valid_location() {
        for _ in 0..<10 {
            let location = WorldLocation.random()
            XCTAssertTrue(WorldLocation.allCases.contains(location))
        }
    }
}
