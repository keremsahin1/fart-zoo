import XCTest
@testable import FartZoo_Watch_App

final class TeleportTests: XCTestCase {

    func test_teleport_random_location_is_valid() {
        for _ in 0..<20 {
            let location = WorldLocation.random()
            XCTAssertTrue(WorldLocation.allCases.contains(location))
        }
    }

    func test_random_location_has_animals() {
        for _ in 0..<10 {
            let location = WorldLocation.random()
            let animals = AnimalDatabase.shared.animals(for: location)
            XCTAssertFalse(animals.isEmpty, "Location \(location.displayName) has no animals")
        }
    }

    func test_teleport_produces_different_locations_over_time() {
        let locations = (0..<20).map { _ in WorldLocation.random() }
        XCTAssertGreaterThan(Set(locations).count, 1,
            "20 teleports should produce more than 1 unique location")
    }
}
