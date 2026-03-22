# Fart Zoo — Roadmap

## What's Built

### Core Game Loop
- **Teleport** → pick an animal → complete a quest → catch it → it lives in your zoo
- Coins spent on quest attempts; lost on failure, earned on success and daily challenges
- 111 animals across 12 world locations with 5 rarity tiers (Common → Extinct)

### Quest Types
- **TAP** — tap as fast as you can before the timer runs out
- **SPIN** — spin the Digital Crown to fill a progress bar; farts every 20% milestone
- **TIMING** — tap only when the animal is visible; penalty (-1 tap) for tapping during hidden phase
- Difficulty (tap count, spin amount, timing window) scales with animal rarity

### Daily Challenges
Pool of 15 challenges, 5 randomly assigned each day:
- Fart Animals, Teleport, Catch Animals, Make Hybrid (original)
- Spin Catch, Spin Master, Win With Both (spin-specific, added later)

### Fart Chef
- Pick any two unlocked animals → creates a hybrid with a blended name and back-to-back parent fart sounds
- Duplicates increment a count badge instead of creating a new entry

### Persistence
- SwiftData for local storage (`CollectedAnimal`, `CollectedHybrid`, `PlayerProgress`)
- CloudKit sync via `ModelConfiguration(cloudKitDatabase: .private(...))` — syncs automatically using Apple ID, no separate sign-in
- Container: `iCloud.com.fartzoo.watchkitapp`

### Technical
- watchOS 10+, Swift 5.9+, SwiftUI, SwiftData + CloudKit, SceneKit, AVFoundation
- xcodegen (`project.yml`) for project generation — run `xcodegen generate` after adding/removing files
- 3D spinning globe: SceneKit sphere with NASA earth texture, cached as `GlobeSceneCache.scene` (static, pre-warmed at app launch)
- CI/CD: GitHub Actions runs tests on every push, generates a code coverage badge committed back to the repo
- ~175 unit tests across 12 test files

---

## What's Next

### Quest Types (next to implement)
These were designed but not yet built. Follow the existing `QuestType` enum pattern in `QuestViewModel.swift`:

| Quest | Idea |
|-------|------|
| 🎵 Simon Says Fart | Play a sequence of fart sounds, repeat them in the correct order |
| ➕ Quick Math | Solve a simple math problem (kid-friendly) to catch the animal |
| 🪙 Coin Flip Dare | Double or nothing — flip a coin, win 2x coins or lose your bet |

### Game Center
- Leaderboards: most animals caught, highest coin total, most hybrids created
- Achievements: catch your first Extinct animal, create 10 hybrids, complete 30 daily challenges
- Apple's GKLeaderboard API, no extra sign-in (uses Apple ID like CloudKit)

### Quality of Life
- **Onboarding** — first-time tutorial explaining teleport → quest → zoo loop (currently zero explanation)
- **Passive coin earning** — reward for tapping animals in the zoo (encourages returning to the app)
- **Zoo filtering/sorting** — with 111 animals the list gets long; filter by location or rarity

### Bigger Ideas
- **Multiplayer** — Fart Duel (compete on same quest), Trading (send animals to friends), Co-op Teleport
- **Animated sprites** — replace emoji with simple animations
