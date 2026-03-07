import XCTest
@testable import FartZoo_Watch_App

final class ExtractedLogicTests: XCTestCase {

    // MARK: - Rarity.colorName

    func test_rarity_colorName_common() {
        XCTAssertEqual(Rarity.common.colorName, "gray")
    }

    func test_rarity_colorName_uncommon() {
        XCTAssertEqual(Rarity.uncommon.colorName, "green")
    }

    func test_rarity_colorName_rare() {
        XCTAssertEqual(Rarity.rare.colorName, "blue")
    }

    func test_rarity_colorName_legendary() {
        XCTAssertEqual(Rarity.legendary.colorName, "purple")
    }

    func test_rarity_colorName_extinct() {
        XCTAssertEqual(Rarity.extinct.colorName, "red")
    }

    func test_all_rarities_have_colorName() {
        for rarity in Rarity.allCases {
            XCTAssertFalse(rarity.colorName.isEmpty, "\(rarity) missing colorName")
        }
    }

    // MARK: - DailyChallengeType.emoji

    func test_challengeType_emoji_fartAnimals() {
        XCTAssertEqual(DailyChallengeType.fartAnimals.emoji, "💨")
    }

    func test_challengeType_emoji_teleport() {
        XCTAssertEqual(DailyChallengeType.teleport.emoji, "🌍")
    }

    func test_challengeType_emoji_catchAnimals() {
        XCTAssertEqual(DailyChallengeType.catchAnimals.emoji, "🎯")
    }

    func test_challengeType_emoji_makeHybrid() {
        XCTAssertEqual(DailyChallengeType.makeHybrid.emoji, "🧪")
    }

    func test_all_challengeTypes_have_emoji() {
        for type in DailyChallengeType.allCases {
            XCTAssertFalse(type.emoji.isEmpty, "\(type) missing emoji")
        }
    }

    // MARK: - ProgressColor

    func test_progressColor_green_at_100_percent() {
        XCTAssertEqual(ProgressColor.from(fraction: 1.0), .green)
    }

    func test_progressColor_green_above_100_percent() {
        XCTAssertEqual(ProgressColor.from(fraction: 1.5), .green)
    }

    func test_progressColor_yellow_at_50_percent() {
        XCTAssertEqual(ProgressColor.from(fraction: 0.5), .yellow)
    }

    func test_progressColor_yellow_at_75_percent() {
        XCTAssertEqual(ProgressColor.from(fraction: 0.75), .yellow)
    }

    func test_progressColor_blue_below_50_percent() {
        XCTAssertEqual(ProgressColor.from(fraction: 0.49), .blue)
    }

    func test_progressColor_blue_at_zero() {
        XCTAssertEqual(ProgressColor.from(fraction: 0.0), .blue)
    }

    // MARK: - FartChef.canMix

    func test_canMix_valid_pair() {
        XCTAssertTrue(FartChef.canMix(first: "dog", second: "cat"))
    }

    func test_canMix_empty_first() {
        XCTAssertFalse(FartChef.canMix(first: "", second: "cat"))
    }

    func test_canMix_empty_second() {
        XCTAssertFalse(FartChef.canMix(first: "dog", second: ""))
    }

    func test_canMix_both_empty() {
        XCTAssertFalse(FartChef.canMix(first: "", second: ""))
    }

    func test_canMix_same_animal() {
        XCTAssertFalse(FartChef.canMix(first: "dog", second: "dog"))
    }

    // MARK: - QuestViewModel.isTimeWarning

    func test_isTimeWarning_false_at_start() {
        let animal = AnimalDefinition(id: "dog", name: "Dog", emoji: "🐕",
                                       rarity: .common, location: .farm, soundFile: "fart_common_1")
        let vm = QuestViewModel(animal: animal)
        vm.timeRemaining = 8.0
        XCTAssertFalse(vm.isTimeWarning)
    }

    func test_isTimeWarning_true_below_3_seconds() {
        let animal = AnimalDefinition(id: "dog", name: "Dog", emoji: "🐕",
                                       rarity: .common, location: .farm, soundFile: "fart_common_1")
        let vm = QuestViewModel(animal: animal)
        vm.timeRemaining = 2.5
        XCTAssertTrue(vm.isTimeWarning)
    }

    func test_isTimeWarning_false_at_exactly_3_seconds() {
        let animal = AnimalDefinition(id: "dog", name: "Dog", emoji: "🐕",
                                       rarity: .common, location: .farm, soundFile: "fart_common_1")
        let vm = QuestViewModel(animal: animal)
        vm.timeRemaining = 3.0
        XCTAssertFalse(vm.isTimeWarning)
    }

    func test_isTimeWarning_false_at_zero() {
        let animal = AnimalDefinition(id: "dog", name: "Dog", emoji: "🐕",
                                       rarity: .common, location: .farm, soundFile: "fart_common_1")
        let vm = QuestViewModel(animal: animal)
        vm.timeRemaining = 0.0
        XCTAssertFalse(vm.isTimeWarning)
    }

    func test_isTimeWarning_false_when_negative() {
        let animal = AnimalDefinition(id: "dog", name: "Dog", emoji: "🐕",
                                       rarity: .common, location: .farm, soundFile: "fart_common_1")
        let vm = QuestViewModel(animal: animal)
        vm.timeRemaining = -1.0
        XCTAssertFalse(vm.isTimeWarning)
    }

    // MARK: - WorldLocation.displayName

    func test_all_locations_have_displayName() {
        for location in WorldLocation.allCases {
            XCTAssertFalse(location.displayName.isEmpty, "\(location) missing displayName")
        }
    }

    func test_location_count_is_12() {
        XCTAssertEqual(WorldLocation.allCases.count, 12)
    }
}
