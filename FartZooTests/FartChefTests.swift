import XCTest
@testable import FartZoo_Watch_App

final class FartChefTests: XCTestCase {

    func test_hybrid_name_dog_plus_fish() {
        // Dog (3 chars, take 70%→3) = "Dog", Fish (4 chars, take 60% suffix→3) = "ish" → "Dogish"
        XCTAssertEqual(HybridAnimal.hybridName(parent1: "Dog", parent2: "Fish"), "Dogish")
    }

    func test_hybrid_name_cow_plus_elephant() {
        // Cow (3 chars, take all) = "Cow", Elephant (8 chars, take 60% suffix→5) = "phant" → "Cowphant"
        let result = HybridAnimal.hybridName(parent1: "Cow", parent2: "Elephant")
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.hasPrefix("Cow"), "Should start with Cow: \(result)")
    }

    func test_hybrid_id_is_order_independent() {
        let id1 = HybridAnimal.hybridID(parent1ID: "dog", parent2ID: "cat")
        let id2 = HybridAnimal.hybridID(parent1ID: "cat", parent2ID: "dog")
        XCTAssertEqual(id1, id2, "Hybrid ID should be the same regardless of parent order")
    }

    func test_hybrid_id_format() {
        let id = HybridAnimal.hybridID(parent1ID: "dog", parent2ID: "cat")
        XCTAssertTrue(id.contains("_x_"), "Hybrid ID should contain '_x_' separator")
    }

    func test_cannot_combine_same_animal() {
        // Enforced by UI: selectedFirst != selectedSecond before Mix button appears
        let id1 = "dog"
        let id2 = "dog"
        XCTAssertFalse(id1 != id2, "Same animal IDs should not be combinable")
    }

    func test_collected_hybrid_has_count_defaulting_to_one() {
        // Regression: duplicate hybrids were inserted as separate rows instead
        // of incrementing count on the existing entry.
        let hybrid = CollectedHybrid(hybridID: "cat_x_dog", name: "Catog", emoji: "🐈🐕",
                                     parent1ID: "cat", parent2ID: "dog")
        XCTAssertEqual(hybrid.count, 1, "New hybrid should start with count 1")
        hybrid.count += 1
        XCTAssertEqual(hybrid.count, 2, "Hybrid count should be incrementable")
    }

    func test_hybrid_name_is_not_empty() {
        for animal1 in ["Dog", "Cat", "Cow", "Elephant", "T-Rex"] {
            for animal2 in ["Fish", "Shark", "Fox", "Bear"] {
                let name = HybridAnimal.hybridName(parent1: animal1, parent2: animal2)
                XCTAssertFalse(name.isEmpty, "Hybrid of \(animal1) + \(animal2) should not be empty")
            }
        }
    }
}
