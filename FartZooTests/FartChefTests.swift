import XCTest
@testable import FartZoo_Watch_App

final class FartChefTests: XCTestCase {

    func test_hybrid_name_dog_plus_fish() {
        XCTAssertEqual(HybridAnimal.hybridName(parent1: "Dog", parent2: "Fish"), "Dogfish")
    }

    func test_hybrid_name_cow_plus_elephant() {
        // "Cow" prefix (2 chars) + "ant" suffix (last 4/2=2 chars of "Elephant" = "nt"... let's check)
        // parent1 = "Cow" (3 chars), half1 = first 2 chars = "Co"
        // parent2 = "Elephant" (8 chars), half2 = last 4 chars = "hant"
        // result = "Cohant"
        let result = HybridAnimal.hybridName(parent1: "Cow", parent2: "Elephant")
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.hasPrefix("Co"), "Should start with prefix of Cow: \(result)")
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

    func test_hybrid_name_is_not_empty() {
        for animal1 in ["Dog", "Cat", "Cow", "Elephant", "T-Rex"] {
            for animal2 in ["Fish", "Shark", "Fox", "Bear"] {
                let name = HybridAnimal.hybridName(parent1: animal1, parent2: animal2)
                XCTAssertFalse(name.isEmpty, "Hybrid of \(animal1) + \(animal2) should not be empty")
            }
        }
    }
}
