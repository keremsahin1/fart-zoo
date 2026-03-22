# Coin Flip Dare Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a fourth quest type (`coinFlip`) where the player spins the Digital Crown once to flip a coin — pure 50/50 chance to catch the animal, same coin cost/reward structure as all other quests.

**Architecture:** `coinFlip` slots into the existing `QuestType` enum and `QuestViewModel` state machine with minimal additions: a new `isFlipping: Bool` flag drives the two-phase `inProgress` UI (waiting → flipping), and `handleCrownChange` gains a coinFlip branch that fires the async result after 1.5s. The view adds a new `coinFlipQuestView` sub-view mirroring the pattern of `spinQuestView`.

**Tech Stack:** Swift 5.9+, watchOS 10+, SwiftUI, `@Observable`, WatchKit haptics, `DispatchQueue.main.asyncAfter`

---

## File Map

| File | Change |
|------|--------|
| `FartZoo Watch App/ViewModels/QuestViewModel.swift` | Add `.coinFlip` case + properties; add `isFlipping`; update `startQuest`, `handleCrownChange`, `progress`, `progressText`; make `win`/`fail` internal |
| `FartZoo Watch App/Views/QuestView.swift` | Add `coinFlipQuestView`; update `inProgressView` switch; update quest picker layout for 4 items |
| `FartZooTests/QuestViewModelTests.swift` | Update two `allCases.count == 3` assertions → 4; add `makeCoinFlipVM` helper |
| `FartZooTests/QuestTests.swift` | Add 5 new coinFlip tests |

---

## Task 1: Add `.coinFlip` to `QuestType` and fix exhaustive switches

**Files:**
- Modify: `FartZoo Watch App/ViewModels/QuestViewModel.swift`
- Modify: `FartZooTests/QuestViewModelTests.swift`

- [ ] **Step 1: Update the two allCases count assertions (they will fail once we add the case)**

In `FartZooTests/QuestViewModelTests.swift`, change both occurrences of `== 3` to `== 4`:

Line 79 (`test_questType_allCases_count`):
```swift
XCTAssertEqual(QuestType.allCases.count, 4)
```

Line 525 (`test_questType_allCases_includes_timing`):
```swift
XCTAssertEqual(QuestType.allCases.count, 4)
```

- [ ] **Step 2: Run those two tests to verify they fail now**

```bash
xcodebuild test -project FartZoo.xcodeproj -scheme "FartZoo Watch App" \
  -destination 'platform=watchOS Simulator,id=7F7DEDA9-CCDB-494B-A572-B195DCC41C2F' \
  -only-testing:FartZooTests/QuestViewModelTests/test_questType_allCases_count \
  -only-testing:FartZooTests/QuestViewModelTests/test_questType_allCases_includes_timing
```

Expected: both fail with `3 is not equal to 4`.

- [ ] **Step 3: Add `.coinFlip` to `QuestType` in `QuestViewModel.swift`**

In `QuestViewModel.swift`, the `QuestType` enum starts at line 9. Add `case coinFlip` after `case timing`:

```swift
enum QuestType: String, CaseIterable {
    case tap
    case spin
    case timing
    case coinFlip
    ...
}
```

Then add the `coinFlip` branch to each computed property:

`label`:
```swift
case .coinFlip: return "FLIP!"
```

`emoji`:
```swift
case .coinFlip: return "🪙"
```

`hint`:
```swift
case .coinFlip: return "Pure luck — spin to flip!"
```

- [ ] **Step 4: Add `.coinFlip` to `progress` and `progressText`**

`progress` switch (around line 114) — add:
```swift
case .coinFlip: return 0.0
```

`progressText` switch (around line 122) — add:
```swift
case .coinFlip: return ""
```

- [ ] **Step 5: Run the two updated tests to verify they pass**

```bash
xcodebuild test -project FartZoo.xcodeproj -scheme "FartZoo Watch App" \
  -destination 'platform=watchOS Simulator,id=7F7DEDA9-CCDB-494B-A572-B195DCC41C2F' \
  -only-testing:FartZooTests/QuestViewModelTests/test_questType_allCases_count \
  -only-testing:FartZooTests/QuestViewModelTests/test_questType_allCases_includes_timing
```

Expected: both pass.

- [ ] **Step 6: Commit**

```bash
git add "FartZoo Watch App/ViewModels/QuestViewModel.swift" FartZooTests/QuestViewModelTests.swift
git commit -m "feat: add coinFlip case to QuestType enum"
```

---

## Task 2: Add `isFlipping`, update `startQuest`, and make `win`/`fail` internal

**Files:**
- Modify: `FartZoo Watch App/ViewModels/QuestViewModel.swift`
- Modify: `FartZooTests/QuestTests.swift`

- [ ] **Step 1: Write the failing tests in `QuestTests.swift`**

Add a `makeCoinFlipVM` helper and two tests at the bottom of `QuestTests.swift`:

```swift
// MARK: - Coin Flip Quest

private func makeCoinFlipVM(animal: AnimalDefinition? = nil) -> QuestViewModel {
    let vm = QuestViewModel(animal: animal ?? AnimalDefinition(
        id: "test_dog", name: "Dog", emoji: "🐕",
        rarity: .common, location: .farm, soundFile: "fart_common_1"
    ))
    vm.chooseQuest(.coinFlip)
    return vm
}

private func makeProgress(coins: Int = 500) -> PlayerProgress {
    let p = PlayerProgress()
    p.coins = coins
    return p
}

func test_coinFlip_state_becomes_inProgress_after_start() {
    let progress = makeProgress()
    let vm = makeCoinFlipVM()

    vm.startQuest(playerProgress: progress)

    XCTAssertEqual(vm.state, .inProgress)
}

func test_coinFlip_deducts_coins_on_start() {
    let cost = Rarity.common.coinCost
    let progress = makeProgress(coins: cost + 10)
    let vm = makeCoinFlipVM()

    vm.startQuest(playerProgress: progress)

    XCTAssertEqual(progress.coins, 10)
}
```

- [ ] **Step 2: Run the new tests to verify they fail**

```bash
xcodebuild test -project FartZoo.xcodeproj -scheme "FartZoo Watch App" \
  -destination 'platform=watchOS Simulator,id=7F7DEDA9-CCDB-494B-A572-B195DCC41C2F' \
  -only-testing:FartZooTests/QuestTests/test_coinFlip_state_becomes_inProgress_after_start \
  -only-testing:FartZooTests/QuestTests/test_coinFlip_deducts_coins_on_start
```

Expected: compile error (no such method) or test failure.

- [ ] **Step 3: Add `isFlipping` to `QuestViewModel` and update `startQuest`**

Add the property near the top of `QuestViewModel` after `private var visibilityTimer`:
```swift
var isFlipping: Bool = false
```

In `startQuest(playerProgress:)`, add `isFlipping = false` in the reset block alongside `tapCount = 0`, `spinProgress = 0`, etc.:
```swift
isFlipping = false
```

Wrap the existing timer block in a guard so it only runs for non-coinFlip quests. The timer block currently starts with `timer = Timer.scheduledTimer(...)`. Wrap it:
```swift
if questType != .coinFlip {
    timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
        guard let self else { return }
        self.timeRemaining -= 0.1
        if self.timeRemaining <= 0 {
            self.fail()
        }
    }
}
```

- [ ] **Step 4: Make `win(playerProgress:)` and `fail()` internal**

Change `private func win(playerProgress: PlayerProgress)` → `func win(playerProgress: PlayerProgress)`

Change `private func fail()` → `func fail()`

This allows tests to call them directly without driving through async timers. The methods are still internal to the module — `@testable import` in test files gives access.

- [ ] **Step 5: Add coin reward/loss tests**

Add to `QuestTests.swift`:

```swift
func test_coinFlip_awards_coins_on_win() {
    let cost = Rarity.common.coinCost
    let reward = Rarity.common.coinReward
    let progress = makeProgress(coins: cost)
    let vm = makeCoinFlipVM()
    vm.startQuest(playerProgress: progress)
    let coinsAfterStart = progress.coins  // 0

    vm.win(playerProgress: progress)

    XCTAssertEqual(progress.coins, coinsAfterStart + reward)
}

func test_coinFlip_no_refund_on_loss() {
    let cost = Rarity.common.coinCost
    let progress = makeProgress(coins: cost)
    let vm = makeCoinFlipVM()
    vm.startQuest(playerProgress: progress)
    let coinsAfterStart = progress.coins  // 0

    vm.fail()

    XCTAssertEqual(progress.coins, coinsAfterStart, "fail() must not refund the entry cost")
}
```

- [ ] **Step 6: Run all 4 new tests**

```bash
xcodebuild test -project FartZoo.xcodeproj -scheme "FartZoo Watch App" \
  -destination 'platform=watchOS Simulator,id=7F7DEDA9-CCDB-494B-A572-B195DCC41C2F' \
  -only-testing:FartZooTests/QuestTests/test_coinFlip_state_becomes_inProgress_after_start \
  -only-testing:FartZooTests/QuestTests/test_coinFlip_deducts_coins_on_start \
  -only-testing:FartZooTests/QuestTests/test_coinFlip_awards_coins_on_win \
  -only-testing:FartZooTests/QuestTests/test_coinFlip_no_refund_on_loss
```

Expected: all 4 pass.

- [ ] **Step 7: Run the full test suite to check nothing regressed**

```bash
xcodebuild test -project FartZoo.xcodeproj -scheme "FartZoo Watch App" \
  -destination 'platform=watchOS Simulator,id=7F7DEDA9-CCDB-494B-A572-B195DCC41C2F'
```

Expected: all tests pass.

- [ ] **Step 8: Commit**

```bash
git add "FartZoo Watch App/ViewModels/QuestViewModel.swift" FartZooTests/QuestTests.swift
git commit -m "feat: add isFlipping, update startQuest for coinFlip quest"
```

---

## Task 3: Add `handleCrownChange` coinFlip branch

**Files:**
- Modify: `FartZoo Watch App/ViewModels/QuestViewModel.swift`
- Modify: `FartZooTests/QuestTests.swift`

- [ ] **Step 1: Write the failing test**

Add to `QuestTests.swift`:

```swift
func test_coinFlip_isFlipping_set_on_crown_spin() {
    let progress = makeProgress()
    let vm = makeCoinFlipVM()
    vm.startQuest(playerProgress: progress)
    XCTAssertFalse(vm.isFlipping, "isFlipping should start false")

    let oldValue = vm.crownRotation
    vm.crownRotation = oldValue + 1.0
    vm.handleCrownChange(oldValue: oldValue, newValue: vm.crownRotation, playerProgress: progress)

    XCTAssertTrue(vm.isFlipping, "isFlipping should be true after any crown movement")
}
```

- [ ] **Step 2: Run the test to verify it fails**

```bash
xcodebuild test -project FartZoo.xcodeproj -scheme "FartZoo Watch App" \
  -destination 'platform=watchOS Simulator,id=7F7DEDA9-CCDB-494B-A572-B195DCC41C2F' \
  -only-testing:FartZooTests/QuestTests/test_coinFlip_isFlipping_set_on_crown_spin
```

Expected: FAIL — `isFlipping` stays false because no coinFlip branch exists yet.

- [ ] **Step 3: Add the coinFlip branch to `handleCrownChange`**

The existing method has this structure:
```swift
func handleCrownChange(oldValue: Double, newValue: Double, playerProgress: PlayerProgress) {
    guard state == .inProgress, questType == .spin else { return }
    // ... spin logic
}
```

Replace the guard to allow both `.spin` and `.coinFlip`, then branch:

```swift
func handleCrownChange(oldValue: Double, newValue: Double, playerProgress: PlayerProgress) {
    guard state == .inProgress else { return }

    if questType == .coinFlip {
        guard !isFlipping else { return }
        let delta = abs(newValue - oldValue)
        guard delta > 0.01 else { return }
        isFlipping = true
        WKInterfaceDevice.current().play(.click)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self, self.state == .inProgress else { return }
            if Bool.random() {
                self.win(playerProgress: playerProgress)
            } else {
                self.fail()
            }
        }
        return
    }

    guard questType == .spin else { return }
    // ... existing spin logic unchanged below
```

- [ ] **Step 4: Run the new test**

```bash
xcodebuild test -project FartZoo.xcodeproj -scheme "FartZoo Watch App" \
  -destination 'platform=watchOS Simulator,id=7F7DEDA9-CCDB-494B-A572-B195DCC41C2F' \
  -only-testing:FartZooTests/QuestTests/test_coinFlip_isFlipping_set_on_crown_spin
```

Expected: PASS.

- [ ] **Step 5: Run the full test suite**

```bash
xcodebuild test -project FartZoo.xcodeproj -scheme "FartZoo Watch App" \
  -destination 'platform=watchOS Simulator,id=7F7DEDA9-CCDB-494B-A572-B195DCC41C2F'
```

Expected: all tests pass.

- [ ] **Step 6: Commit**

```bash
git add "FartZoo Watch App/ViewModels/QuestViewModel.swift" FartZooTests/QuestTests.swift
git commit -m "feat: implement coinFlip crown handler with async result"
```

---

## Task 4: Add the coin flip UI to `QuestView`

**Files:**
- Modify: `FartZoo Watch App/Views/QuestView.swift`

No new test file — view code is not unit-tested; verify by building.

- [ ] **Step 1: Add `.coinFlip` branch to `inProgressView` (placeholder first)**

In `QuestView.swift`, the `inProgressView` computed property is around line 82:

```swift
private var inProgressView: some View {
    Group {
        switch vm.questType {
        case .tap:    tapQuestView
        case .spin:   spinQuestView
        case .timing: timingQuestView
        case .coinFlip: coinFlipQuestView
        }
    }
}
```

Add a stub so it compiles:

```swift
private var coinFlipQuestView: some View {
    Text("Coin Flip")
}
```

- [ ] **Step 2: Build to confirm it compiles**

```bash
xcodebuild build -project FartZoo.xcodeproj -scheme "FartZoo Watch App" \
  -destination 'platform=watchOS Simulator,id=7F7DEDA9-CCDB-494B-A572-B195DCC41C2F'
```

Expected: build succeeds.

- [ ] **Step 3: Add `flipRotation` as a stored property on `QuestView`**

`@State` must be a stored property on the struct — it cannot go inside a computed property body. Add it near the top of `QuestView` alongside the other `@State` properties (e.g., after `@State private var vm`):

```swift
@State private var flipRotation: Double = 0
```

- [ ] **Step 4: Implement `coinFlipQuestView` — Screens 1 and 2**

Replace the stub with the real implementation. Screen 1 shows when `!vm.isFlipping`, Screen 2 when `vm.isFlipping`:

```swift
private var coinFlipQuestView: some View {
    Group {
        if vm.isFlipping {
            coinFlipFlippingView
        } else {
            coinFlipReadyView
        }
    }
    .focusable()
    .focused($isCrownFocused)
    .digitalCrownRotation(
        $vm.crownRotation,
        from: -100000, through: 100000,
        sensitivity: .high,
        isContinuous: true
    )
    .onChange(of: vm.crownRotation) { oldValue, newValue in
        vm.handleCrownChange(oldValue: oldValue, newValue: newValue, playerProgress: playerProgress)
    }
    .onAppear {
        isCrownFocused = true
    }
}

private var coinFlipReadyView: some View {
    VStack(spacing: 6) {
        Text(animal.emoji).font(.title2)
        Text(animal.name).font(.headline)
        Text("🎲").font(.system(size: 44))
        Text("Spin the crown once!")
            .font(.caption)
            .foregroundStyle(.yellow)
            .fontWeight(.bold)
    }
}

private var coinFlipFlippingView: some View {
    VStack(spacing: 8) {
        Text("🪙")
            .font(.system(size: 48))
            .rotationEffect(.degrees(flipRotation))
            .onAppear {
                withAnimation(.linear(duration: 0.15).repeatForever(autoreverses: false)) {
                    flipRotation = 360
                }
            }
        Text("Flipping...")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}
```

- [ ] **Step 5: Update the quest picker layout for 4 items**

The current `choosingQuestView` (around line 38) uses an `HStack` with `ForEach(QuestType.allCases, ...)`. With 4 items this can overflow the 42mm watch face. Replace the `HStack` with a `LazyVGrid` (2 columns):

```swift
private var choosingQuestView: some View {
    VStack(spacing: 8) {
        Text(animal.emoji).font(.largeTitle)
        Text(animal.name).font(.headline)
        Text("Choose your quest:").font(.caption).foregroundStyle(.secondary)
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
            ForEach(QuestType.allCases, id: \.self) { type in
                Button {
                    vm.chooseQuest(type)
                } label: {
                    VStack(spacing: 2) {
                        Text(type.emoji).font(.title3)
                        Text(type.label).font(.caption2)
                    }
                }
                .buttonStyle(.bordered)
            }
        }
    }
}
```

- [ ] **Step 6: Build and verify**

```bash
xcodebuild build -project FartZoo.xcodeproj -scheme "FartZoo Watch App" \
  -destination 'platform=watchOS Simulator,id=7F7DEDA9-CCDB-494B-A572-B195DCC41C2F'
```

Expected: build succeeds with no warnings.

- [ ] **Step 7: Run the full test suite one final time**

```bash
xcodebuild test -project FartZoo.xcodeproj -scheme "FartZoo Watch App" \
  -destination 'platform=watchOS Simulator,id=7F7DEDA9-CCDB-494B-A572-B195DCC41C2F'
```

Expected: all tests pass.

- [ ] **Step 8: Commit**

```bash
git add "FartZoo Watch App/Views/QuestView.swift"
git commit -m "feat: add Coin Flip Dare UI to QuestView"
```

---

## Task 5: Push

- [ ] **Push to main**

```bash
git push
```
