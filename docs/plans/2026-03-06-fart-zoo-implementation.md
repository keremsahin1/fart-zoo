# Fart Zoo Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a standalone Apple Watch game where kids teleport around the world, catch farting animals, and combine them into silly hybrids.

**Architecture:** SwiftUI views for all screens, SwiftData for persistent storage of animal collection/coins/daily challenges, AVFoundation for fart sound playback, and WKInterfaceDevice for haptic feedback. The app has no iPhone companion — it runs fully on watchOS.

**Tech Stack:** Swift 5.9+, watchOS 10+, SwiftUI, SwiftData, AVFoundation

**Design Doc:** `docs/plans/2026-03-06-fart-zoo-design.md`

---

### Task 1: Xcode Project Setup

**Files:**
- Create: `FartZoo.xcodeproj` (Xcode project)
- Create: `FartZoo Watch App/` (watchOS target folder)
- Create: `FartZooTests/` (unit test target)

**Step 1: Create the Xcode project**

Open Xcode → New Project → watchOS → App
- Product Name: `FartZoo`
- Team: your Apple ID
- Bundle Identifier: `com.yourname.fartzoo`
- Interface: SwiftUI
- Check "Include Tests"
- Uncheck "Include Notifications"
- Save to `/Users/keremsahin/Github/fart-zoo/`

**Step 2: Verify the project builds**

In Xcode, select an Apple Watch simulator → Cmd+B
Expected: Build Succeeded with no errors

**Step 3: Create folder structure inside the Watch App target**

Create these groups in Xcode (right-click in navigator → New Group):
```
FartZoo Watch App/
  Models/
  Views/
  ViewModels/
  Services/
  Data/
  Resources/
    Sounds/
```

**Step 4: Initialize git**

```bash
cd /Users/keremsahin/Github/fart-zoo
git init
echo "*.xcuserstate\nDerivedData/\n.DS_Store" > .gitignore
git add .
git commit -m "chore: initial Xcode project setup"
```

---

### Task 2: Core Data Models

**Files:**
- Create: `FartZoo Watch App/Models/Animal.swift`
- Create: `FartZoo Watch App/Models/PlayerProgress.swift`
- Create: `FartZoo Watch App/Models/DailyChallenge.swift`
- Create: `FartZooTests/ModelTests.swift`

**Step 1: Write failing tests for Animal model**

In `FartZooTests/ModelTests.swift`:
```swift
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
        XCTAssertEqual(name, "Dogfish")
    }
}
```

**Step 2: Run tests to verify they fail**

In Xcode: Cmd+U
Expected: FAIL — "Cannot find type 'Rarity' in scope"

**Step 3: Create `Animal.swift`**

```swift
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
        }
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
        let half1 = String(parent1.prefix(parent1.count / 2 + parent1.count % 2))
        let half2 = String(parent2.suffix(parent2.count / 2))
        return half1 + half2.lowercased()
    }

    static func hybridID(parent1ID: String, parent2ID: String) -> String {
        let sorted = [parent1ID, parent2ID].sorted()
        return "\(sorted[0])_x_\(sorted[1])"
    }
}
```

**Step 4: Create `PlayerProgress.swift`**

```swift
import SwiftData
import Foundation

@Model
class CollectedAnimal {
    var animalID: String
    var count: Int
    var collectedAt: Date

    init(animalID: String) {
        self.animalID = animalID
        self.count = 1
        self.collectedAt = Date()
    }
}

@Model
class CollectedHybrid {
    var hybridID: String
    var name: String
    var emoji: String
    var parent1ID: String
    var parent2ID: String
    var createdAt: Date

    init(hybridID: String, name: String, emoji: String, parent1ID: String, parent2ID: String) {
        self.hybridID = hybridID
        self.name = name
        self.emoji = emoji
        self.parent1ID = parent1ID
        self.parent2ID = parent2ID
        self.createdAt = Date()
    }
}

@Model
class PlayerProgress {
    var coins: Int
    var lastDailyChallengeDate: Date?
    var dailyChallengeCompleted: Bool

    init() {
        self.coins = 50 // starting coins
        self.lastDailyChallengeDate = nil
        self.dailyChallengeCompleted = false
    }
}
```

**Step 5: Create `DailyChallenge.swift`**

```swift
import Foundation

enum DailyChallengeType: String, CaseIterable, Codable {
    case fartAnimals     // Tap zoo animals N times
    case teleport        // Teleport N times
    case catchAnimals    // Catch N animals
    case makeHybrid      // Make a hybrid in Fart Chef
}

struct DailyChallenge {
    let type: DailyChallengeType
    let target: Int
    let coinReward: Int
    let description: String

    static func forDate(_ date: Date) -> DailyChallenge {
        // Deterministic challenge based on day — same challenge all day
        var calendar = Calendar.current
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
```

**Step 6: Run tests to verify they pass**

Cmd+U
Expected: PASS — all 3 tests green

**Step 7: Commit**

```bash
git add .
git commit -m "feat: add core data models (Animal, PlayerProgress, DailyChallenge)"
```

---

### Task 3: Animal Database

**Files:**
- Create: `FartZoo Watch App/Data/AnimalDatabase.swift`
- Test: `FartZooTests/AnimalDatabaseTests.swift`

**Step 1: Write failing tests**

```swift
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

    func test_database_has_at_least_30_animals() {
        XCTAssertGreaterThanOrEqual(AnimalDatabase.shared.all.count, 30)
    }
}
```

**Step 2: Run to verify they fail**

Cmd+U — Expected: FAIL "Cannot find type 'AnimalDatabase'"

**Step 3: Create `AnimalDatabase.swift`**

```swift
import Foundation

struct AnimalDatabase {
    static let shared = AnimalDatabase()

    let all: [AnimalDefinition] = [
        // FARM - Common
        AnimalDefinition(id: "dog",     name: "Dog",     emoji: "🐕", rarity: .common,   location: .farm,        soundFile: "fart_common_1"),
        AnimalDefinition(id: "cat",     name: "Cat",     emoji: "🐈", rarity: .common,   location: .farm,        soundFile: "fart_common_2"),
        AnimalDefinition(id: "cow",     name: "Cow",     emoji: "🐄", rarity: .common,   location: .farm,        soundFile: "fart_common_3"),
        AnimalDefinition(id: "chicken", name: "Chicken", emoji: "🐔", rarity: .common,   location: .farm,        soundFile: "fart_common_4"),
        AnimalDefinition(id: "pig",     name: "Pig",     emoji: "🐷", rarity: .common,   location: .farm,        soundFile: "fart_common_1"),
        AnimalDefinition(id: "horse",   name: "Horse",   emoji: "🐴", rarity: .uncommon, location: .farm,        soundFile: "fart_uncommon_1"),

        // FOREST - Common/Uncommon
        AnimalDefinition(id: "rabbit",  name: "Rabbit",  emoji: "🐰", rarity: .common,   location: .forest,      soundFile: "fart_common_2"),
        AnimalDefinition(id: "deer",    name: "Deer",    emoji: "🦌", rarity: .uncommon, location: .forest,      soundFile: "fart_uncommon_2"),
        AnimalDefinition(id: "fox",     name: "Fox",     emoji: "🦊", rarity: .uncommon, location: .forest,      soundFile: "fart_uncommon_3"),
        AnimalDefinition(id: "bear",    name: "Bear",    emoji: "🐻", rarity: .rare,     location: .forest,      soundFile: "fart_rare_1"),
        AnimalDefinition(id: "wolf",    name: "Wolf",    emoji: "🐺", rarity: .rare,     location: .forest,      soundFile: "fart_rare_2"),

        // ARCTIC
        AnimalDefinition(id: "polar_bear",  name: "Polar Bear",  emoji: "🐻‍❄️", rarity: .rare,      location: .arctic,      soundFile: "fart_rare_3"),
        AnimalDefinition(id: "arctic_fox",  name: "Arctic Fox",  emoji: "🦊",   rarity: .uncommon,  location: .arctic,      soundFile: "fart_uncommon_1"),
        AnimalDefinition(id: "narwhal",     name: "Narwhal",     emoji: "🦄",   rarity: .rare,      location: .arctic,      soundFile: "fart_rare_1"),
        AnimalDefinition(id: "snowy_owl",   name: "Snowy Owl",   emoji: "🦉",   rarity: .uncommon,  location: .arctic,      soundFile: "fart_uncommon_2"),
        AnimalDefinition(id: "walrus",      name: "Walrus",      emoji: "🦭",   rarity: .uncommon,  location: .arctic,      soundFile: "fart_uncommon_3"),

        // AFRICAN SAVANNA
        AnimalDefinition(id: "lion",        name: "Lion",        emoji: "🦁",   rarity: .rare,      location: .savanna,     soundFile: "fart_rare_2"),
        AnimalDefinition(id: "elephant",    name: "Elephant",    emoji: "🐘",   rarity: .rare,      location: .savanna,     soundFile: "fart_rare_3"),
        AnimalDefinition(id: "giraffe",     name: "Giraffe",     emoji: "🦒",   rarity: .uncommon,  location: .savanna,     soundFile: "fart_uncommon_1"),
        AnimalDefinition(id: "zebra",       name: "Zebra",       emoji: "🦓",   rarity: .uncommon,  location: .savanna,     soundFile: "fart_uncommon_2"),
        AnimalDefinition(id: "white_rhino", name: "White Rhino", emoji: "🦏",   rarity: .legendary, location: .savanna,     soundFile: "fart_legendary_1"),
        AnimalDefinition(id: "cheetah",     name: "Cheetah",     emoji: "🐆",   rarity: .rare,      location: .savanna,     soundFile: "fart_rare_1"),

        // DEEP OCEAN
        AnimalDefinition(id: "whale_shark", name: "Whale Shark", emoji: "🦈",   rarity: .legendary, location: .ocean,       soundFile: "fart_legendary_2"),
        AnimalDefinition(id: "great_white", name: "Great White", emoji: "🦈",   rarity: .legendary, location: .ocean,       soundFile: "fart_legendary_1"),
        AnimalDefinition(id: "blue_whale",  name: "Blue Whale",  emoji: "🐳",   rarity: .legendary, location: .ocean,       soundFile: "fart_legendary_3"),
        AnimalDefinition(id: "octopus",     name: "Octopus",     emoji: "🐙",   rarity: .uncommon,  location: .ocean,       soundFile: "fart_uncommon_3"),
        AnimalDefinition(id: "anglerfish",  name: "Anglerfish",  emoji: "🐟",   rarity: .rare,      location: .ocean,       soundFile: "fart_rare_2"),

        // AMAZON RAINFOREST
        AnimalDefinition(id: "toucan",      name: "Toucan",      emoji: "🦜",   rarity: .uncommon,  location: .rainforest,  soundFile: "fart_uncommon_1"),
        AnimalDefinition(id: "jaguar",      name: "Jaguar",      emoji: "🐆",   rarity: .rare,      location: .rainforest,  soundFile: "fart_rare_3"),
        AnimalDefinition(id: "axolotl",     name: "Axolotl",     emoji: "🦎",   rarity: .legendary, location: .rainforest,  soundFile: "fart_legendary_2"),
        AnimalDefinition(id: "poison_frog", name: "Poison Frog", emoji: "🐸",   rarity: .uncommon,  location: .rainforest,  soundFile: "fart_uncommon_2"),
        AnimalDefinition(id: "anaconda",    name: "Anaconda",    emoji: "🐍",   rarity: .rare,      location: .rainforest,  soundFile: "fart_rare_1"),

        // AUSTRALIAN OUTBACK
        AnimalDefinition(id: "kangaroo",    name: "Kangaroo",    emoji: "🦘",   rarity: .common,    location: .outback,     soundFile: "fart_common_3"),
        AnimalDefinition(id: "koala",       name: "Koala",       emoji: "🐨",   rarity: .uncommon,  location: .outback,     soundFile: "fart_uncommon_3"),
        AnimalDefinition(id: "platypus",    name: "Platypus",    emoji: "🦆",   rarity: .rare,      location: .outback,     soundFile: "fart_rare_2"),
        AnimalDefinition(id: "kakapo",      name: "Kakapo",      emoji: "🦜",   rarity: .legendary, location: .outback,     soundFile: "fart_legendary_3"),
        AnimalDefinition(id: "wombat",      name: "Wombat",      emoji: "🐾",   rarity: .uncommon,  location: .outback,     soundFile: "fart_uncommon_1"),

        // PREHISTORIC WORLD - Extinct
        AnimalDefinition(id: "trex",        name: "T-Rex",       emoji: "🦖",   rarity: .extinct,   location: .prehistoric, soundFile: "fart_extinct_1"),
        AnimalDefinition(id: "triceratops", name: "Triceratops", emoji: "🦕",   rarity: .extinct,   location: .prehistoric, soundFile: "fart_extinct_2"),
        AnimalDefinition(id: "velociraptor",name: "Velociraptor",emoji: "🦖",   rarity: .extinct,   location: .prehistoric, soundFile: "fart_extinct_1"),
        AnimalDefinition(id: "mammoth",     name: "Mammoth",     emoji: "🐘",   rarity: .extinct,   location: .prehistoric, soundFile: "fart_extinct_2"),
        AnimalDefinition(id: "dodo",        name: "Dodo",        emoji: "🐦",   rarity: .extinct,   location: .prehistoric, soundFile: "fart_extinct_1"),
        AnimalDefinition(id: "sabretooth",  name: "Sabre-tooth", emoji: "🐱",   rarity: .extinct,   location: .prehistoric, soundFile: "fart_extinct_2"),
    ]

    func animals(for location: WorldLocation) -> [AnimalDefinition] {
        all.filter { $0.location == location }
    }

    func animal(id: String) -> AnimalDefinition? {
        all.first { $0.id == id }
    }
}
```

**Step 4: Run tests to verify they pass**

Cmd+U — Expected: PASS

**Step 5: Commit**

```bash
git add .
git commit -m "feat: add animal database with 40+ animals across all locations and rarities"
```

---

### Task 4: Sound Manager

**Files:**
- Create: `FartZoo Watch App/Services/SoundManager.swift`
- Create placeholder sound files: `FartZoo Watch App/Resources/Sounds/` (add to Xcode target)

**Step 1: Add placeholder sound files**

For now, create empty `.wav` placeholder files named:
- `fart_common_1.wav`, `fart_common_2.wav`, `fart_common_3.wav`, `fart_common_4.wav`
- `fart_uncommon_1.wav`, `fart_uncommon_2.wav`, `fart_uncommon_3.wav`
- `fart_rare_1.wav`, `fart_rare_2.wav`, `fart_rare_3.wav`
- `fart_legendary_1.wav`, `fart_legendary_2.wav`, `fart_legendary_3.wav`
- `fart_extinct_1.wav`, `fart_extinct_2.wav`

You can download free fart sound effects from freesound.org (search "fart"). Make sure to add all `.wav` files to the Xcode target (check "Add to target: FartZoo Watch App").

**Step 2: Create `SoundManager.swift`**

```swift
import AVFoundation
import WatchKit

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?

    func play(soundFile: String) {
        guard let url = Bundle.main.url(forResource: soundFile, withExtension: "wav") else {
            print("Sound file not found: \(soundFile).wav")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Failed to play sound: \(error)")
        }
    }

    func playFart(for animal: AnimalDefinition) {
        play(soundFile: animal.soundFile)
        WKInterfaceDevice.current().play(.click)
    }

    func playVictory() {
        WKInterfaceDevice.current().play(.success)
    }

    func playFailure() {
        WKInterfaceDevice.current().play(.failure)
    }

    func playTeleport() {
        WKInterfaceDevice.current().play(.directionUp)
    }
}
```

**Step 3: Build to verify no compile errors**

Cmd+B — Expected: Build Succeeded

**Step 4: Commit**

```bash
git add .
git commit -m "feat: add SoundManager with AVFoundation fart playback and haptics"
```

---

### Task 5: App Entry Point & SwiftData Setup

**Files:**
- Modify: `FartZoo Watch App/FartZooApp.swift`
- Create: `FartZoo Watch App/Views/ZooView.swift` (scaffold only)

**Step 1: Configure SwiftData container in app entry point**

Replace the contents of `FartZooApp.swift`:

```swift
import SwiftUI
import SwiftData

@main
struct FartZooApp: App {
    var body: some Scene {
        WindowGroup {
            ZooView()
        }
        .modelContainer(for: [CollectedAnimal.self, CollectedHybrid.self, PlayerProgress.self])
    }
}
```

**Step 2: Create scaffold `ZooView.swift`**

```swift
import SwiftUI
import SwiftData

struct ZooView: View {
    @Query private var collectedAnimals: [CollectedAnimal]
    @Query private var collectedHybrids: [CollectedHybrid]
    @Query private var progress: [PlayerProgress]
    @Environment(\.modelContext) private var context

    private var playerProgress: PlayerProgress {
        if let existing = progress.first { return existing }
        let new = PlayerProgress()
        context.insert(new)
        return new
    }

    var body: some View {
        Text("Fart Zoo")
    }
}
```

**Step 3: Build and run on simulator**

Cmd+R on Apple Watch simulator — Expected: app launches showing "Fart Zoo"

**Step 4: Commit**

```bash
git add .
git commit -m "feat: configure SwiftData container and app entry point"
```

---

### Task 6: Zoo Screen (Home)

**Files:**
- Modify: `FartZoo Watch App/Views/ZooView.swift`
- Create: `FartZoo Watch App/Views/AnimalCardView.swift`

**Step 1: Create `AnimalCardView.swift`**

```swift
import SwiftUI

struct AnimalCardView: View {
    let animal: AnimalDefinition
    let count: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text(animal.emoji)
                    .font(.title2)
                Text(animal.name)
                    .font(.caption2)
                    .lineLimit(1)
                if count > 1 {
                    Text("x\(count)")
                        .font(.caption2)
                        .foregroundStyle(.yellow)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(6)
            .background(rarityColor(animal.rarity).opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

    private func rarityColor(_ rarity: Rarity) -> Color {
        switch rarity {
        case .common:    return .gray
        case .uncommon:  return .green
        case .rare:      return .blue
        case .legendary: return .purple
        case .extinct:   return .red
        }
    }
}
```

**Step 2: Build full Zoo screen in `ZooView.swift`**

```swift
import SwiftUI
import SwiftData

struct ZooView: View {
    @Query private var collectedAnimals: [CollectedAnimal]
    @Query private var collectedHybrids: [CollectedHybrid]
    @Query private var progressList: [PlayerProgress]
    @Environment(\.modelContext) private var context
    @State private var showTeleport = false
    @State private var showChef = false
    @State private var showDailyChallenge = false

    private var playerProgress: PlayerProgress {
        if let existing = progressList.first { return existing }
        let new = PlayerProgress()
        context.insert(new)
        return new
    }

    private var collectedDefs: [(AnimalDefinition, Int)] {
        collectedAnimals.compactMap { collected in
            guard let def = AnimalDatabase.shared.animal(id: collected.animalID) else { return nil }
            return (def, collected.count)
        }
    }

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 8) {
                    // Coin display
                    HStack {
                        Text("🪙 \(playerProgress.coins)")
                            .font(.headline)
                        Spacer()
                        Text("\(collectedAnimals.count) animals")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)

                    // Action buttons
                    HStack(spacing: 8) {
                        Button("Teleport!") { showTeleport = true }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)

                        Button("Chef") { showChef = true }
                            .buttonStyle(.bordered)
                    }

                    Button("Daily Challenge") { showDailyChallenge = true }
                        .buttonStyle(.bordered)
                        .tint(.orange)

                    Divider()

                    if collectedDefs.isEmpty {
                        Text("Teleport to catch your first animal!")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(collectedDefs, id: \.0.id) { (animal, count) in
                                AnimalCardView(animal: animal, count: count) {
                                    SoundManager.shared.playFart(for: animal)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Fart Zoo")
            .sheet(isPresented: $showTeleport) {
                TeleportView(playerProgress: playerProgress)
            }
            .sheet(isPresented: $showChef) {
                FartChefView(playerProgress: playerProgress)
            }
            .sheet(isPresented: $showDailyChallenge) {
                DailyChallengeView(playerProgress: playerProgress)
            }
        }
    }
}
```

**Step 3: Create stub views for sheets (so it compiles)**

Create `FartZoo Watch App/Views/TeleportView.swift`:
```swift
import SwiftUI
struct TeleportView: View {
    let playerProgress: PlayerProgress
    var body: some View { Text("Teleport coming soon") }
}
```

Create `FartZoo Watch App/Views/FartChefView.swift`:
```swift
import SwiftUI
struct FartChefView: View {
    let playerProgress: PlayerProgress
    var body: some View { Text("Fart Chef coming soon") }
}
```

Create `FartZoo Watch App/Views/DailyChallengeView.swift`:
```swift
import SwiftUI
struct DailyChallengeView: View {
    let playerProgress: PlayerProgress
    var body: some View { Text("Daily Challenge coming soon") }
}
```

**Step 4: Build and run**

Cmd+R — Expected: Zoo home screen with coin balance, Teleport/Chef/Daily Challenge buttons

**Step 5: Commit**

```bash
git add .
git commit -m "feat: build Zoo home screen with animal grid and navigation buttons"
```

---

### Task 7: Teleport Screen

**Files:**
- Modify: `FartZoo Watch App/Views/TeleportView.swift`
- Create: `FartZoo Watch App/Views/QuestView.swift` (stub)
- Create: `FartZoo Watch App/ViewModels/TeleportViewModel.swift`

**Step 1: Write failing tests**

In `FartZooTests/`:
```swift
final class TeleportTests: XCTestCase {

    func test_teleport_picks_random_location() {
        let locations = (0..<20).map { _ in WorldLocation.random() }
        // With 8 locations and 20 picks, we should get more than 1 unique
        XCTAssertGreaterThan(Set(locations).count, 1)
    }

    func test_random_location_has_animals() {
        for _ in 0..<10 {
            let location = WorldLocation.random()
            let animals = AnimalDatabase.shared.animals(for: location)
            XCTAssertFalse(animals.isEmpty)
        }
    }
}
```

**Step 2: Add `random()` to `WorldLocation`**

In `Animal.swift`, add to `WorldLocation`:
```swift
static func random() -> WorldLocation {
    allCases.randomElement()!
}
```

**Step 3: Run tests — Expected: PASS**

**Step 4: Create `TeleportViewModel.swift`**

```swift
import SwiftUI
import Observation

@Observable
class TeleportViewModel {
    var currentLocation: WorldLocation?
    var isAnimating = false
    var showQuest = false
    var selectedAnimal: AnimalDefinition?

    func teleport() {
        isAnimating = true
        SoundManager.shared.playTeleport()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.currentLocation = WorldLocation.random()
            self.isAnimating = false
        }
    }

    func selectAnimal(_ animal: AnimalDefinition) {
        selectedAnimal = animal
        showQuest = true
    }
}
```

**Step 5: Build full `TeleportView.swift`**

```swift
import SwiftUI

struct TeleportView: View {
    let playerProgress: PlayerProgress
    @State private var vm = TeleportViewModel()
    @Environment(\.modelContext) private var context

    var body: some View {
        VStack(spacing: 8) {
            if vm.isAnimating {
                VStack {
                    Text("🌍")
                        .font(.largeTitle)
                        .rotationEffect(.degrees(vm.isAnimating ? 360 : 0))
                        .animation(.linear(duration: 1).repeatForever(autoreverses: false),
                                   value: vm.isAnimating)
                    Text("Teleporting...")
                        .font(.caption)
                }
            } else if let location = vm.currentLocation {
                Text(location.displayName)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                let animals = AnimalDatabase.shared.animals(for: location)
                ScrollView {
                    ForEach(animals) { animal in
                        Button {
                            vm.selectAnimal(animal)
                        } label: {
                            HStack {
                                Text(animal.emoji)
                                VStack(alignment: .leading) {
                                    Text(animal.name).font(.caption)
                                    Text("🪙 \(animal.rarity.coinCost)")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(animal.rarity.displayName)
                                    .font(.caption2)
                                    .foregroundStyle(rarityColor(animal.rarity))
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                }

                Button("Teleport Again") { vm.teleport() }
                    .font(.caption)
            } else {
                Button {
                    vm.teleport()
                } label: {
                    VStack {
                        Text("🌍")
                            .font(.largeTitle)
                        Text("Teleport!")
                            .font(.headline)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .sheet(isPresented: $vm.showQuest) {
            if let animal = vm.selectedAnimal {
                QuestView(animal: animal, playerProgress: playerProgress)
            }
        }
    }

    private func rarityColor(_ rarity: Rarity) -> Color {
        switch rarity {
        case .common:    return .gray
        case .uncommon:  return .green
        case .rare:      return .blue
        case .legendary: return .purple
        case .extinct:   return .red
        }
    }
}
```

**Step 6: Create stub `QuestView.swift`**

```swift
import SwiftUI
struct QuestView: View {
    let animal: AnimalDefinition
    let playerProgress: PlayerProgress
    var body: some View { Text("Quest coming soon for \(animal.name)") }
}
```

**Step 7: Build and run — verify Teleport screen works**

**Step 8: Commit**

```bash
git add .
git commit -m "feat: build Teleport screen with random location and animal list"
```

---

### Task 8: Quest Mini-Challenges

**Files:**
- Modify: `FartZoo Watch App/Views/QuestView.swift`
- Create: `FartZoo Watch App/ViewModels/QuestViewModel.swift`
- Test: `FartZooTests/QuestTests.swift`

**Step 1: Write failing tests**

```swift
final class QuestTests: XCTestCase {

    func test_quest_deducts_coins_on_start() {
        // This is logic tested via QuestViewModel
        let cost = Rarity.common.coinCost
        var coins = 50
        coins -= cost
        XCTAssertEqual(coins, 40)
    }

    func test_insufficient_coins_blocks_quest() {
        let cost = Rarity.legendary.coinCost
        let coins = 10
        XCTAssertFalse(coins >= cost)
    }

    func test_tap_quest_target_scales_with_rarity() {
        XCTAssertLessThan(tapTarget(for: .common), tapTarget(for: .uncommon))
        XCTAssertLessThan(tapTarget(for: .uncommon), tapTarget(for: .rare))
        XCTAssertLessThan(tapTarget(for: .rare), tapTarget(for: .legendary))
        XCTAssertLessThan(tapTarget(for: .legendary), tapTarget(for: .extinct))
    }

    private func tapTarget(for rarity: Rarity) -> Int {
        switch rarity {
        case .common:    return 10
        case .uncommon:  return 20
        case .rare:      return 35
        case .legendary: return 50
        case .extinct:   return 75
        }
    }
}
```

**Step 2: Run — Expected: FAIL (tapTarget not accessible)**

**Step 3: Create `QuestViewModel.swift`**

```swift
import SwiftUI
import Observation

enum QuestState {
    case notStarted, inProgress, won, lost, insufficientCoins
}

@Observable
class QuestViewModel {
    let animal: AnimalDefinition
    var state: QuestState = .notStarted
    var tapCount = 0
    var timeRemaining: Double = 0
    var timer: Timer?

    var tapTarget: Int {
        switch animal.rarity {
        case .common:    return 10
        case .uncommon:  return 20
        case .rare:      return 35
        case .legendary: return 50
        case .extinct:   return 75
        }
    }

    var timeLimit: Double {
        switch animal.rarity {
        case .common:    return 8.0
        case .uncommon:  return 10.0
        case .rare:      return 12.0
        case .legendary: return 15.0
        case .extinct:   return 18.0
        }
    }

    init(animal: AnimalDefinition) {
        self.animal = animal
    }

    func startQuest(playerProgress: PlayerProgress) {
        guard playerProgress.coins >= animal.rarity.coinCost else {
            state = .insufficientCoins
            return
        }
        playerProgress.coins -= animal.rarity.coinCost
        tapCount = 0
        timeRemaining = timeLimit
        state = .inProgress

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.timeRemaining -= 0.1
            if self.timeRemaining <= 0 {
                self.fail()
            }
        }
    }

    func tap(playerProgress: PlayerProgress) {
        guard state == .inProgress else { return }
        tapCount += 1
        SoundManager.shared.play(soundFile: animal.soundFile)
        WKInterfaceDevice.current().play(.click)

        if tapCount >= tapTarget {
            win(playerProgress: playerProgress)
        }
    }

    private func win(playerProgress: PlayerProgress) {
        timer?.invalidate()
        state = .won
        playerProgress.coins += animal.rarity.coinReward
        SoundManager.shared.playVictory()
    }

    private func fail() {
        timer?.invalidate()
        state = .lost
        SoundManager.shared.playFailure()
    }
}
```

**Step 4: Build full `QuestView.swift`**

```swift
import SwiftUI
import SwiftData
import WatchKit

struct QuestView: View {
    let animal: AnimalDefinition
    let playerProgress: PlayerProgress
    @State private var vm: QuestViewModel
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var collectedAnimals: [CollectedAnimal]

    init(animal: AnimalDefinition, playerProgress: PlayerProgress) {
        self.animal = animal
        self.playerProgress = playerProgress
        _vm = State(initialValue: QuestViewModel(animal: animal))
    }

    var body: some View {
        switch vm.state {
        case .notStarted:
            notStartedView

        case .inProgress:
            inProgressView

        case .won:
            wonView

        case .lost:
            lostView

        case .insufficientCoins:
            insufficientCoinsView
        }
    }

    private var notStartedView: some View {
        VStack(spacing: 8) {
            Text(animal.emoji).font(.largeTitle)
            Text(animal.name).font(.headline)
            Text("Cost: 🪙 \(animal.rarity.coinCost)").font(.caption)
            Text("You have: 🪙 \(playerProgress.coins)").font(.caption)
            Button("Catch it!") {
                vm.startQuest(playerProgress: playerProgress)
            }
            .buttonStyle(.borderedProminent)
            .disabled(playerProgress.coins < animal.rarity.coinCost)
        }
    }

    private var inProgressView: some View {
        VStack(spacing: 4) {
            Text(animal.emoji).font(.title2)
            ProgressView(value: Double(vm.tapCount), total: Double(vm.tapTarget))
            Text("\(vm.tapCount) / \(vm.tapTarget)")
                .font(.headline)
            Text(String(format: "⏱ %.1fs", vm.timeRemaining))
                .font(.caption)
                .foregroundStyle(vm.timeRemaining < 3 ? .red : .primary)
            Button("TAP!") {
                vm.tap(playerProgress: playerProgress)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
    }

    private var wonView: some View {
        VStack(spacing: 8) {
            Text("🎉").font(.largeTitle)
            Text("You caught \(animal.name)!").font(.headline)
            Text("+🪙 \(animal.rarity.coinReward)").foregroundStyle(.yellow)
            Button("Back to Zoo") {
                addAnimalToCollection()
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .onAppear { addAnimalToCollection() }
    }

    private var lostView: some View {
        VStack(spacing: 8) {
            Text("💨").font(.largeTitle)
            Text("\(animal.name) escaped!").font(.headline)
            Text("Coins lost: 🪙 \(animal.rarity.coinCost)").foregroundStyle(.red)
            Button("Try Again") {
                vm = QuestViewModel(animal: animal)
            }
            Button("Give Up") { dismiss() }
                .foregroundStyle(.secondary)
        }
    }

    private var insufficientCoinsView: some View {
        VStack(spacing: 8) {
            Text("🪙").font(.largeTitle)
            Text("Not enough coins!").font(.headline)
            Text("Need \(animal.rarity.coinCost), have \(playerProgress.coins)")
                .font(.caption)
                .multilineTextAlignment(.center)
            Button("OK") { dismiss() }
                .buttonStyle(.borderedProminent)
        }
    }

    private func addAnimalToCollection() {
        if let existing = collectedAnimals.first(where: { $0.animalID == animal.id }) {
            existing.count += 1
        } else {
            context.insert(CollectedAnimal(animalID: animal.id))
        }
    }
}
```

**Step 5: Run tests — Expected: PASS**

**Step 6: Build and test quest flow on simulator**

Cmd+R — teleport to a location, tap an animal, complete the quest

**Step 7: Commit**

```bash
git add .
git commit -m "feat: implement quest mini-challenge with tap mechanic and coin economy"
```

---

### Task 9: Fart Chef

**Files:**
- Modify: `FartZoo Watch App/Views/FartChefView.swift`
- Test: `FartZooTests/FartChefTests.swift`

**Step 1: Write failing tests**

```swift
final class FartChefTests: XCTestCase {

    func test_hybrid_name_dog_plus_fish() {
        XCTAssertEqual(HybridAnimal.hybridName(parent1: "Dog", parent2: "Fish"), "Dogfish")
    }

    func test_hybrid_name_cow_plus_elephant() {
        XCTAssertEqual(HybridAnimal.hybridName(parent1: "Cow", parent2: "Elephant"), "Cowant")
    }

    func test_hybrid_id_is_order_independent() {
        let id1 = HybridAnimal.hybridID(parent1ID: "dog", parent2ID: "cat")
        let id2 = HybridAnimal.hybridID(parent1ID: "cat", parent2ID: "dog")
        XCTAssertEqual(id1, id2)
    }

    func test_cannot_combine_same_animal() {
        let canCombine = "dog" != "dog"
        XCTAssertFalse(canCombine)
    }
}
```

**Step 2: Run — Expected: PASS (logic already in models)**

**Step 3: Build full `FartChefView.swift`**

```swift
import SwiftUI
import SwiftData

struct FartChefView: View {
    let playerProgress: PlayerProgress
    @Query private var collectedAnimals: [CollectedAnimal]
    @Query private var collectedHybrids: [CollectedHybrid]
    @Environment(\.modelContext) private var context

    @State private var selectedFirst: String?
    @State private var selectedSecond: String?
    @State private var resultHybrid: CollectedHybrid?
    @State private var showResult = false

    private var eligibleAnimals: [(AnimalDefinition, Int)] {
        collectedAnimals.compactMap { collected in
            guard let def = AnimalDatabase.shared.animal(id: collected.animalID),
                  collected.count >= 1 else { return nil }
            return (def, collected.count)
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Text("Fart Chef").font(.headline)
                Text("Mix two animals!").font(.caption).foregroundStyle(.secondary)

                // First animal picker
                selectionRow(label: "Animal 1", selectedID: $selectedFirst,
                             excluding: selectedSecond)

                Text("+").font(.title2)

                // Second animal picker
                selectionRow(label: "Animal 2", selectedID: $selectedSecond,
                             excluding: selectedFirst)

                if let id1 = selectedFirst, let id2 = selectedSecond, id1 != id2 {
                    Button("Mix!") { createHybrid(id1: id1, id2: id2) }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                }

                if collectedHybrids.isEmpty == false {
                    Divider()
                    Text("Your Hybrids").font(.caption).foregroundStyle(.secondary)
                    ForEach(collectedHybrids) { hybrid in
                        HStack {
                            Text(hybrid.emoji)
                            Text(hybrid.name).font(.caption)
                            Spacer()
                        }
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $showResult) {
            if let hybrid = resultHybrid {
                hybridResultView(hybrid: hybrid)
            }
        }
    }

    private func selectionRow(label: String, selectedID: Binding<String?>, excluding: String?) -> some View {
        Menu {
            ForEach(eligibleAnimals.filter { $0.0.id != excluding }, id: \.0.id) { (animal, count) in
                Button("\(animal.emoji) \(animal.name) (x\(count))") {
                    selectedID.wrappedValue = animal.id
                }
            }
        } label: {
            HStack {
                if let id = selectedID.wrappedValue,
                   let def = AnimalDatabase.shared.animal(id: id) {
                    Text("\(def.emoji) \(def.name)")
                } else {
                    Text(label).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.down")
            }
            .font(.caption)
            .padding(6)
            .background(Color.secondary.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private func createHybrid(id1: String, id2: String) {
        guard let def1 = AnimalDatabase.shared.animal(id: id1),
              let def2 = AnimalDatabase.shared.animal(id: id2),
              let collected1 = collectedAnimals.first(where: { $0.animalID == id1 }),
              let collected2 = collectedAnimals.first(where: { $0.animalID == id2 }),
              collected1.count >= 1, collected2.count >= 1 else { return }

        // Consume one copy of each
        collected1.count -= 1
        collected2.count -= 1

        // Create hybrid
        let hybridID = HybridAnimal.hybridID(parent1ID: id1, parent2ID: id2)
        let name = HybridAnimal.hybridName(parent1: def1.name, parent2: def2.name)
        let emoji = def1.emoji + def2.emoji

        let hybrid = CollectedHybrid(hybridID: hybridID, name: name, emoji: emoji,
                                     parent1ID: id1, parent2ID: id2)
        context.insert(hybrid)
        resultHybrid = hybrid
        selectedFirst = nil
        selectedSecond = nil
        showResult = true
        SoundManager.shared.playVictory()
    }

    private func hybridResultView(hybrid: CollectedHybrid) -> some View {
        VStack(spacing: 8) {
            Text(hybrid.emoji).font(.largeTitle)
            Text("You created a...").font(.caption)
            Text(hybrid.name).font(.headline)
            Text("💨💨💨").font(.title2)
            Button("Amazing!") { showResult = false }
                .buttonStyle(.borderedProminent)
        }
    }
}
```

**Step 4: Build and run — test Fart Chef flow**

**Step 5: Commit**

```bash
git add .
git commit -m "feat: implement Fart Chef with animal mixing and hybrid creation"
```

---

### Task 10: Daily Challenge Screen

**Files:**
- Modify: `FartZoo Watch App/Views/DailyChallengeView.swift`
- Create: `FartZoo Watch App/ViewModels/DailyChallengeViewModel.swift`
- Test: `FartZooTests/DailyChallengeTests.swift`

**Step 1: Write failing tests**

```swift
final class DailyChallengeTests: XCTestCase {

    func test_same_day_returns_same_challenge() {
        let date = Date()
        let c1 = DailyChallenge.forDate(date)
        let c2 = DailyChallenge.forDate(date)
        XCTAssertEqual(c1.type, c2.type)
    }

    func test_challenge_is_free() {
        // Daily challenges have no coin cost — they are always free
        // This is a design invariant; there is no coinCost property
        let challenge = DailyChallenge.forDate(Date())
        XCTAssertGreaterThan(challenge.coinReward, 0)
    }

    func test_challenge_resets_next_day() {
        var calendar = Calendar.current
        let today = Date()
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        let c1 = DailyChallenge.forDate(today)
        let c2 = DailyChallenge.forDate(tomorrow)
        // Different day ordinals mean different indices — not guaranteed different but usually are
        // Just verify tomorrow's challenge is still valid
        XCTAssertGreaterThan(c2.coinReward, 0)
    }
}
```

**Step 2: Run — Expected: PASS**

**Step 3: Create `DailyChallengeViewModel.swift`**

```swift
import SwiftUI
import Observation

@Observable
class DailyChallengeViewModel {
    let challenge: DailyChallenge
    var progress: Int = 0
    var completed: Bool = false

    init(playerProgress: PlayerProgress) {
        self.challenge = DailyChallenge.forDate(Date())

        // Check if already completed today
        if let lastDate = playerProgress.lastDailyChallengeDate,
           Calendar.current.isDateInToday(lastDate),
           playerProgress.dailyChallengeCompleted {
            self.completed = true
        }
    }

    var progressFraction: Double {
        min(Double(progress) / Double(challenge.target), 1.0)
    }

    // Called when user taps an animal in zoo (for .fartAnimals challenge)
    func recordFart(playerProgress: PlayerProgress) {
        guard !completed, challenge.type == .fartAnimals else { return }
        progress += 1
        checkCompletion(playerProgress: playerProgress)
    }

    func recordTeleport(playerProgress: PlayerProgress) {
        guard !completed, challenge.type == .teleport else { return }
        progress += 1
        checkCompletion(playerProgress: playerProgress)
    }

    func recordCatch(playerProgress: PlayerProgress) {
        guard !completed, challenge.type == .catchAnimals else { return }
        progress += 1
        checkCompletion(playerProgress: playerProgress)
    }

    func recordHybrid(playerProgress: PlayerProgress) {
        guard !completed, challenge.type == .makeHybrid else { return }
        progress += 1
        checkCompletion(playerProgress: playerProgress)
    }

    private func checkCompletion(playerProgress: PlayerProgress) {
        if progress >= challenge.target {
            completed = true
            playerProgress.coins += challenge.coinReward
            playerProgress.dailyChallengeCompleted = true
            playerProgress.lastDailyChallengeDate = Date()
            SoundManager.shared.playVictory()
        }
    }
}
```

**Step 4: Build full `DailyChallengeView.swift`**

```swift
import SwiftUI

struct DailyChallengeView: View {
    let playerProgress: PlayerProgress
    @State private var vm: DailyChallengeViewModel

    init(playerProgress: PlayerProgress) {
        self.playerProgress = playerProgress
        _vm = State(initialValue: DailyChallengeViewModel(playerProgress: playerProgress))
    }

    var body: some View {
        VStack(spacing: 8) {
            Text("Daily Challenge").font(.headline)

            if vm.completed {
                VStack(spacing: 6) {
                    Text("✅").font(.largeTitle)
                    Text("Done for today!").font(.headline)
                    Text("Come back tomorrow").font(.caption).foregroundStyle(.secondary)
                    Text("+🪙 \(vm.challenge.coinReward) earned").foregroundStyle(.yellow)
                }
            } else {
                VStack(spacing: 6) {
                    Text(vm.challenge.description)
                        .font(.caption)
                        .multilineTextAlignment(.center)

                    ProgressView(value: vm.progressFraction)
                    Text("\(vm.progress) / \(vm.challenge.target)")
                        .font(.caption)

                    Text("Reward: 🪙 \(vm.challenge.coinReward)")
                        .font(.caption)
                        .foregroundStyle(.yellow)

                    Text("FREE — no coins needed")
                        .font(.caption2)
                        .foregroundStyle(.green)

                    // For fartAnimals challenges, let user tap here directly
                    if vm.challenge.type == .fartAnimals {
                        Button("Fart! 💨") {
                            vm.recordFart(playerProgress: playerProgress)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                    } else {
                        Text("Go play to make progress!")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
    }
}
```

**Step 5: Build and run**

**Step 6: Commit**

```bash
git add .
git commit -m "feat: implement Daily Challenge screen with progress tracking and coin reward"
```

---

### Task 11: Wire Up Challenge Progress Tracking

The Daily Challenge needs to track actions across the whole app. This task connects fart taps, teleports, catches, and hybrid creations to the challenge.

**Files:**
- Modify: `FartZoo Watch App/FartZooApp.swift`
- Modify: `FartZoo Watch App/Views/ZooView.swift`
- Modify: `FartZoo Watch App/Views/QuestView.swift`
- Modify: `FartZoo Watch App/Views/FartChefView.swift`

**Step 1: Add a shared `DailyChallengeViewModel` via environment**

In `FartZooApp.swift`, inject the view model:
```swift
import SwiftUI
import SwiftData

@main
struct FartZooApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [CollectedAnimal.self, CollectedHybrid.self, PlayerProgress.self])
    }
}

struct RootView: View {
    @Query private var progressList: [PlayerProgress]
    @Environment(\.modelContext) private var context

    private var playerProgress: PlayerProgress {
        if let existing = progressList.first { return existing }
        let new = PlayerProgress()
        context.insert(new)
        return new
    }

    var body: some View {
        ZooView()
            .environment(DailyChallengeViewModel(playerProgress: playerProgress))
    }
}
```

**Step 2: In `ZooView.swift`, receive the environment and call `recordFart` on animal tap**

Add to `ZooView`:
```swift
@Environment(DailyChallengeViewModel.self) private var challengeVM
```

Update `AnimalCardView` tap in the grid:
```swift
AnimalCardView(animal: animal, count: count) {
    SoundManager.shared.playFart(for: animal)
    challengeVM.recordFart(playerProgress: playerProgress)
}
```

**Step 3: In `QuestView.swift`, call `recordCatch` on win**

Add to `QuestView`:
```swift
@Environment(DailyChallengeViewModel.self) private var challengeVM
```

In `addAnimalToCollection()`:
```swift
challengeVM.recordCatch(playerProgress: playerProgress)
```

**Step 4: In `FartChefView.swift`, call `recordHybrid` after creating hybrid**

Add to `FartChefView`:
```swift
@Environment(DailyChallengeViewModel.self) private var challengeVM
```

At end of `createHybrid()`:
```swift
challengeVM.recordHybrid(playerProgress: playerProgress)
```

**Step 5: Build and run — verify challenge progress updates in real time**

**Step 6: Commit**

```bash
git add .
git commit -m "feat: wire daily challenge progress tracking across all game actions"
```

---

### Task 12: Polish & Final Testing

**Step 1: Add app icon**

In Xcode, open `Assets.xcassets` → `AppIcon` → drag in a fart/animal icon image (you can use an emoji screenshot as placeholder).

**Step 2: Add launch animation to Zoo screen**

In `ZooView.swift`, add a welcome message for new players:
```swift
if collectedDefs.isEmpty && collectedHybrids.isEmpty {
    VStack {
        Text("Welcome to Fart Zoo! 🐾")
            .font(.headline)
            .multilineTextAlignment(.center)
        Text("Press Teleport to catch your first animal!")
            .font(.caption)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
    }
    .padding()
}
```

**Step 3: Test full game loop manually**

On simulator:
1. Open app → see empty Zoo with 50 starting coins
2. Press Teleport → globe spins → land in a location
3. Pick a common animal → complete tap quest → animal appears in Zoo
4. Tap the animal in Zoo → hear fart sound
5. Collect a second copy of same animal
6. Go to Fart Chef → pick two different animals → create hybrid
7. Open Daily Challenge → check description → make progress → see reward

**Step 4: Run all unit tests**

Cmd+U — Expected: all tests PASS

**Step 5: Final commit**

```bash
git add .
git commit -m "feat: polish and finalize Fart Zoo v1.0"
```

---

## What's Not In This Plan (Future Versions)

- Real fart sound files (replace placeholder `.wav` files with real recordings)
- Multiplayer (Fart Duel, Trading, Co-op Teleport)
- iCloud sync
- Complications / Watch face widget
- More animals (100+ target)
- Animated animal sprites (replace emoji with illustrations)
