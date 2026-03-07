import XCTest
@testable import FartZoo_Watch_App

final class AnimalDatabaseTests: XCTestCase {

    func test_database_has_animals_for_every_location() {
        let db = AnimalDatabase.shared
        for location in WorldLocation.allCases {
            let animals = db.animals(for: location)
            XCTAssertFalse(animals.isEmpty, "No animals for \(location.displayName)")
        }
    }

    func test_database_has_all_rarity_tiers() {
        let db = AnimalDatabase.shared
        for rarity in Rarity.allCases {
            let animals = db.all.filter { $0.rarity == rarity }
            XCTAssertFalse(animals.isEmpty, "No animals for rarity \(rarity)")
        }
    }

    func test_animal_ids_are_unique() {
        let db = AnimalDatabase.shared
        let ids = db.all.map { $0.id }
        XCTAssertEqual(ids.count, Set(ids).count, "Duplicate animal IDs found")
    }

    func test_database_has_at_least_100_animals() {
        XCTAssertGreaterThanOrEqual(AnimalDatabase.shared.all.count, 100)
    }

    func test_prehistoric_animals_are_all_extinct() {
        let db = AnimalDatabase.shared
        let prehistoric = db.animals(for: .prehistoric)
        for animal in prehistoric {
            XCTAssertEqual(animal.rarity, .extinct, "\(animal.name) in prehistoric should be extinct")
        }
    }
}
