# Coin Flip Dare — Design Spec

**Date:** 2026-03-22
**Status:** Approved

---

## Overview

Coin Flip Dare is a fourth quest type that replaces skill-based mechanics with pure 50/50 chance. The player pays the normal coin cost for their animal's rarity, spins the Digital Crown once to flip a coin, and either catches the animal (win) or doesn't (lose) — no tapping, no timing, no spinning to fill a bar.

Same cost/reward structure as all other quests: `rarity.coinCost` to enter, `rarity.coinReward` on win, no refund on loss.

---

## Quest Type & State Machine

`coinFlip` is added to the existing `QuestType` enum alongside `tap`, `spin`, and `timing`.

State flow — identical to other quests:

```
choosingQuest → notStarted → inProgress → won / lost
```

The `inProgress` phase has two sub-states driven by a new `isFlipping: Bool` flag on `QuestViewModel`:
- `isFlipping == false`: waiting for the player to spin the crown
- `isFlipping == true`: flip animation playing (1.5s), then result revealed

No countdown timer runs during a coinFlip quest.

---

## ViewModel Changes (`QuestViewModel`)

**New property:**
```swift
var isFlipping: Bool = false
```

**`startQuest` — two additional changes:**
- Reset `isFlipping = false` alongside the existing resets (`tapCount`, `spinProgress`, etc.)
- Skip the countdown timer: wrap the existing `timer = Timer.scheduledTimer(...)` block in `if questType != .coinFlip { ... }`

**`handleCrownChange` — new branch:**
When `questType == .coinFlip` and `state == .inProgress` and `!isFlipping`, any crown delta above the existing `> 0.01` threshold triggers:
1. Set `isFlipping = true`
2. Play haptic: `WKInterfaceDevice.current().play(.click)`
3. After 1.5s delay (via `DispatchQueue.main.asyncAfter(deadline:execute:)`), capture `playerProgress` from the function parameter. Inside the closure, guard `state == .inProgress`, then call `win(playerProgress: playerProgress)` or `fail()` based on `Bool.random()`

**`progress` and `progressText` — add coinFlip case:**
Both computed properties are exhaustive switches on `questType`. Add `.coinFlip` returning `0.0` and `""` respectively.

**Daily challenges:**
coinFlip catches call the existing `recordCatch(questType:playerProgress:)` unchanged. They count toward `.catchAnimals` challenges only. No new `DailyChallengeType` case is introduced.

**`QuestType` additions:**
```swift
case coinFlip

var label: String  // "FLIP!"
var emoji: String  // "🪙"
var hint: String   // "Pure luck — spin to flip!"
```

---

## View Changes (`QuestView`)

`QuestView` already branches on `questType` for `inProgress`. The coinFlip branch shows three distinct screens:

### Screen 1 — Ready to flip (`inProgress`, `isFlipping == false`)
- Animal emoji + name at top
- Large 🎲 emoji center screen
- `"Spin the crown once!"` instruction
- No progress bar, no timer
- Crown focus wiring (mirroring the spin quest): `.focusable()`, `.focused($isCrownFocused)`, `.digitalCrownRotation(detent:)` binding `vm.crownRotation`, and `.onAppear { isCrownFocused = true }`

### Screen 2 — Flipping (`inProgress`, `isFlipping == true`)
- 🪙 emoji with continuous `rotationEffect` animation (`.linear(duration: 0.15).repeatForever()`)
- `"Flipping..."` label

### Screen 3 — Result (`won` / `lost`)
- Reuses existing result screens unchanged (green CAUGHT / red MISSED)

### `inProgressView` switch (`QuestView`)
- The existing `switch vm.questType` in `inProgressView` handles `.tap`, `.spin`, `.timing` — add a `.coinFlip` branch showing Screens 1 and 2 above (branching on `vm.isFlipping`)

### Quest picker (`choosingQuest`)
- coinFlip appears as a 4th option: `"🪙 FLIP!"` with hint `"Pure luck — spin to flip!"`
- The picker uses `ForEach(QuestType.allCases, ...)` so the new case appears automatically. With 4 items the existing horizontal `HStack` layout may be tight on a 42mm watch face — switch to a 2×2 grid or wrap layout if the buttons overflow

---

## Tests (`FartZooTests/QuestTests.swift`)

| Test | What it checks |
|------|---------------|
| `test_coinFlip_deducts_coins_on_start` | Coins reduced by `rarity.coinCost` when quest starts |
| `test_coinFlip_awards_coins_on_win` | Coins increased by `coinReward` after a win |
| `test_coinFlip_no_refund_on_loss` | Coins stay reduced after a loss |
| `test_coinFlip_state_becomes_inProgress_after_start` | State is `.inProgress` after `startQuest` |
| `test_coinFlip_isFlipping_set_on_crown_spin` | Any crown delta > 0.01 sets `isFlipping = true` |
| `test_questType_allCases_count` (update) | Assert `QuestType.allCases.count == 4` — update both occurrences in `QuestViewModelTests.swift` (`test_questType_allCases_count` and `test_questType_allCases_includes_timing`) |

`Bool.random()` outcomes are non-deterministic; tests cover state transitions and coin math, not win/loss results.
