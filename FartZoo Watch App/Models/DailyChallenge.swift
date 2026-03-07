import Foundation

enum DailyChallengeType: String, CaseIterable, Codable {
    case fartAnimals
    case teleport
    case catchAnimals
    case makeHybrid
}

struct DailyChallenge {
    let type: DailyChallengeType
    let target: Int
    let coinReward: Int
    let description: String

    static func forDate(_ date: Date) -> DailyChallenge {
        let calendar = Calendar.current
        let day = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let types = DailyChallengeType.allCases
        let type = types[day % types.count]

        switch type {
        case .fartAnimals:
            return DailyChallenge(type: type, target: 20, coinReward: 25,
                description: "Fart your zoo animals 20 times")
        case .teleport:
            return DailyChallenge(type: type, target: 5, coinReward: 20,
                description: "Teleport 5 times")
        case .catchAnimals:
            return DailyChallenge(type: type, target: 2, coinReward: 30,
                description: "Catch 2 animals")
        case .makeHybrid:
            return DailyChallenge(type: type, target: 1, coinReward: 35,
                description: "Make a hybrid in Fart Chef")
        }
    }
}
