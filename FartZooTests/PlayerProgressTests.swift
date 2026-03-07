import XCTest
@testable import FartZoo_Watch_App

final class PlayerProgressTests: XCTestCase {

    func test_initial_coins_is_50() {
        let progress = PlayerProgress()
        XCTAssertEqual(progress.coins, 50)
    }

    func test_initial_daily_challenge_date_is_nil() {
        let progress = PlayerProgress()
        XCTAssertNil(progress.lastDailyChallengeDate)
    }

    func test_initial_daily_challenge_mask_is_zero() {
        let progress = PlayerProgress()
        XCTAssertEqual(progress.dailyChallengesCompletedMask, 0)
    }

    func test_coins_can_be_modified() {
        let progress = PlayerProgress()
        progress.coins += 100
        XCTAssertEqual(progress.coins, 150)
        progress.coins -= 30
        XCTAssertEqual(progress.coins, 120)
    }

    func test_collected_animal_starts_with_count_1() {
        let animal = CollectedAnimal(animalID: "dog")
        XCTAssertEqual(animal.count, 1)
        XCTAssertEqual(animal.animalID, "dog")
    }

    func test_collected_animal_count_is_incrementable() {
        let animal = CollectedAnimal(animalID: "cat")
        animal.count += 1
        XCTAssertEqual(animal.count, 2)
    }

    func test_collected_hybrid_starts_with_count_1() {
        let hybrid = CollectedHybrid(
            hybridID: "cat_x_dog", name: "Catog", emoji: "🐈🐕",
            parent1ID: "cat", parent2ID: "dog"
        )
        XCTAssertEqual(hybrid.count, 1)
    }

    func test_collected_hybrid_stores_parent_ids() {
        let hybrid = CollectedHybrid(
            hybridID: "cat_x_dog", name: "Catog", emoji: "🐈🐕",
            parent1ID: "cat", parent2ID: "dog"
        )
        XCTAssertEqual(hybrid.parent1ID, "cat")
        XCTAssertEqual(hybrid.parent2ID, "dog")
    }

    func test_bitmask_individual_bits() {
        let progress = PlayerProgress()
        progress.dailyChallengesCompletedMask = 0

        // Set bit 2
        progress.dailyChallengesCompletedMask |= (1 << 2)
        XCTAssertEqual(progress.dailyChallengesCompletedMask & (1 << 2), 4)
        XCTAssertEqual(progress.dailyChallengesCompletedMask & (1 << 0), 0)

        // Set bit 0
        progress.dailyChallengesCompletedMask |= (1 << 0)
        XCTAssertEqual(progress.dailyChallengesCompletedMask & (1 << 0), 1)
        XCTAssertEqual(progress.dailyChallengesCompletedMask & (1 << 2), 4)
    }

    func test_all_5_bits_set() {
        let progress = PlayerProgress()
        progress.dailyChallengesCompletedMask = 0b11111
        for i in 0..<5 {
            XCTAssertNotEqual(progress.dailyChallengesCompletedMask & (1 << i), 0,
                              "Bit \(i) should be set")
        }
    }
}
