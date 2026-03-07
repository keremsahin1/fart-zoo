import Foundation

enum Rarity: String, CaseIterable, Codable {
    case common, uncommon, rare, legendary, extinct

    var coinCost: Int {
        switch self {
        case .common:    return 10
        case .uncommon:  return 30
        case .rare:      return 75
        case .legendary: return 150
        case .extinct:   return 300
        }
    }

    var coinReward: Int { coinCost / 2 }

    var displayName: String { rawValue.capitalized }
}

enum WorldLocation: String, CaseIterable, Codable {
    case farm, forest, arctic, savanna, ocean, rainforest, outback, prehistoric
    case mountains, desert, swamp, galapagos

    var displayName: String {
        switch self {
        case .farm:        return "Farm"
        case .forest:      return "Forest"
        case .arctic:      return "Arctic"
        case .savanna:     return "African Savanna"
        case .ocean:       return "Deep Ocean"
        case .rainforest:  return "Amazon Rainforest"
        case .outback:     return "Australian Outback"
        case .prehistoric: return "Prehistoric World"
        case .mountains:   return "Mountains"
        case .desert:      return "Desert"
        case .swamp:       return "Swamp"
        case .galapagos:   return "Galápagos Islands"
        }
    }

    static func random() -> WorldLocation {
        allCases.randomElement()!
    }
}

struct AnimalDefinition: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let emoji: String
    let rarity: Rarity
    let location: WorldLocation
    let soundFile: String
}

struct HybridAnimal: Identifiable, Codable {
    let id: String
    let name: String
    let emoji: String
    let parent1ID: String
    let parent2ID: String
    let soundFile: String

    static func hybridName(parent1: String, parent2: String) -> String {
        let take1 = max(2, Int(ceil(Double(parent1.count) * 0.7)))
        let take2 = max(2, Int(ceil(Double(parent2.count) * 0.6)))
        let half1 = String(parent1.prefix(take1))
        let half2 = String(parent2.suffix(take2))
        return half1 + half2.lowercased()
    }

    static func hybridID(parent1ID: String, parent2ID: String) -> String {
        let sorted = [parent1ID, parent2ID].sorted()
        return "\(sorted[0])_x_\(sorted[1])"
    }
}
