import XCTest
@testable import FartZoo_Watch_App

final class TeleportViewModelTests: XCTestCase {

    // MARK: - Initial State

    func test_initial_state() {
        let vm = TeleportViewModel()
        XCTAssertNil(vm.currentLocation)
        XCTAssertTrue(vm.shuffledAnimals.isEmpty)
        XCTAssertFalse(vm.isAnimating)
        XCTAssertFalse(vm.showAnimalList)
        XCTAssertFalse(vm.showQuest)
        XCTAssertNil(vm.selectedAnimal)
    }

    // MARK: - Select Animal

    func test_selectAnimal_sets_animal_and_shows_quest() {
        let vm = TeleportViewModel()
        let animal = AnimalDatabase.shared.all.first!

        vm.selectAnimal(animal)

        XCTAssertEqual(vm.selectedAnimal?.id, animal.id)
        XCTAssertTrue(vm.showQuest)
    }

    func test_selectAnimal_can_change_selection() {
        let vm = TeleportViewModel()
        let first = AnimalDatabase.shared.all[0]
        let second = AnimalDatabase.shared.all[1]

        vm.selectAnimal(first)
        XCTAssertEqual(vm.selectedAnimal?.id, first.id)

        vm.selectAnimal(second)
        XCTAssertEqual(vm.selectedAnimal?.id, second.id)
    }

    // MARK: - Teleport

    func test_teleport_sets_animating() {
        let vm = TeleportViewModel()
        vm.teleport()
        XCTAssertTrue(vm.isAnimating)
    }

    func test_teleport_completes_after_delay() {
        let vm = TeleportViewModel()
        vm.teleport()

        let expectation = XCTestExpectation(description: "Teleport completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XCTAssertFalse(vm.isAnimating)
            XCTAssertNotNil(vm.currentLocation)
            XCTAssertFalse(vm.shuffledAnimals.isEmpty)
            XCTAssertTrue(vm.showAnimalList)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }

    func test_teleport_populates_animals_for_location() {
        let vm = TeleportViewModel()
        vm.teleport()

        let expectation = XCTestExpectation(description: "Animals populated")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            guard let location = vm.currentLocation else {
                XCTFail("Location should be set")
                return
            }
            let expected = AnimalDatabase.shared.animals(for: location)
            XCTAssertEqual(vm.shuffledAnimals.count, expected.count)
            XCTAssertEqual(
                Set(vm.shuffledAnimals.map(\.id)),
                Set(expected.map(\.id)),
                "Should have same animals, possibly in different order"
            )
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }

    func test_teleport_shuffles_animals() {
        // Run multiple teleports to same location and check that order varies
        var orders: [String] = []
        for _ in 0..<10 {
            let animals = AnimalDatabase.shared.animals(for: .farm).shuffled()
            orders.append(animals.map(\.id).joined(separator: ","))
        }
        let uniqueOrders = Set(orders)
        XCTAssertGreaterThan(uniqueOrders.count, 1, "Shuffling should produce different orders")
    }

    func test_multiple_teleports_can_change_location() {
        var locations: Set<WorldLocation> = []
        for _ in 0..<50 {
            locations.insert(WorldLocation.random())
        }
        XCTAssertGreaterThan(locations.count, 1, "Random teleport should visit different locations")
    }
}
