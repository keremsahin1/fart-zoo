# Fart Zoo

![Tests](https://github.com/keremsahin1/fart-zoo/actions/workflows/test.yml/badge.svg)
![Coverage](https://raw.githubusercontent.com/keremsahin1/fart-zoo/main/coverage-badge.svg)

A standalone Apple Watch game where kids teleport around the world, catch farting animals, and combine them into silly hybrids.

Built by a father-son duo for maximum laughs.

## How to Play

1. **Teleport** — Spin the 3D globe and land in a random location (Amazon Rainforest, Arctic, Galápagos Islands, and more)
2. **Catch** — Pick an animal, pay coins, and choose your quest type to catch it
3. **Collect** — Build your zoo with 111 animals across 5 rarity tiers
4. **Mix** — Use the Fart Chef to combine two animals into a silly hybrid (Dog + Fish = Dogish)
5. **Challenge** — Complete 5 rotating daily challenges to earn free coins

## Rarity Tiers

| Tier | Examples | Difficulty |
|------|----------|-----------|
| Common | Dog, Cow, Penguin, Camel | Easy |
| Uncommon | Fox, Koala, Scorpion, Otter | Medium |
| Rare | Snow Leopard, Narwhal, Lion, Alligator | Hard |
| Legendary | Panda, Axolotl, White Rhino, Giant Tortoise | Very Hard |
| Extinct | T-Rex, Mammoth, Megalodon, Pterodactyl | Hardest |

The rarer an animal is in real life, the harder the quest to catch it.

## Quest Types

Each animal catch is a mini-challenge. Choose your style before spending coins:

| Quest | How to Play |
|-------|-------------|
| 🫵 TAP | Tap as fast as you can before time runs out |
| 🌀 SPIN | Spin the Digital Crown to fill the progress bar |
| ⏱️ TIMING | Tap only when the animal is visible — penalty for tapping when hidden |

Harder animals (Rare, Legendary, Extinct) require more taps, more spins, and tighter timing windows.

## Features

- **Fart Zoo** — Tap any collected animal or hybrid to hear it fart
- **3D Spinning Globe** — Realistic Earth with NASA texture during teleport animation
- **Teleport** — 12 world locations with native animals
- **3 Quest Types** — TAP, SPIN, and TIMING challenges that scale with rarity
- **Fart Chef** — Mix any two unlocked animals into a hybrid with a unique name and combined fart sound
- **Daily Challenges** — 5 free challenges per day from a rotating pool of 15, including spin-based challenges
- **Coin Economy** — Earn coins by catching animals and completing challenges; spend coins to attempt quests
- **iCloud Sync** — Progress, animals, and coins sync automatically via iCloud across devices

## Tech Stack

- Swift 5.9+ / watchOS 10+
- SwiftUI
- SwiftData + CloudKit (persistence & iCloud sync)
- SceneKit (3D spinning globe)
- AVFoundation (sound playback)
- xcodegen (project generation)

## Getting Started

```bash
# Clone the repo
git clone https://github.com/keremsahin1/fart-zoo.git
cd fart-zoo

# Generate the Xcode project (requires xcodegen)
brew install xcodegen
xcodegen generate

# Open in Xcode
open FartZoo.xcodeproj
```

Select an Apple Watch simulator and press Cmd+R to run.

### Sound Files

Sound effects sourced from [freesound.org](https://freesound.org) are included in `FartZoo Watch App/Resources/Sounds/`.

## Future Plans

- Multiplayer (Fart Duel, Trading, Co-op Teleport)
- More quest types (Simon Says Fart, Quick Math, Coin Flip Dare)
- Game Center leaderboards
- Animated animal sprites
