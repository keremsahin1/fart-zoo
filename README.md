# Fart Zoo

A standalone Apple Watch game where kids teleport around the world, catch farting animals, and combine them into silly hybrids.

Built by a father-son duo for maximum laughs.

## How to Play

1. **Teleport** — Spin the globe and land in a random location (Amazon Rainforest, Arctic, Galápagos Islands, and more)
2. **Catch** — Pick an animal, pay coins, and tap as fast as you can to catch it before time runs out
3. **Collect** — Build your zoo with 107 animals across 5 rarity tiers
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

## Features

- **Fart Zoo** — Tap any collected animal or hybrid to hear it fart
- **Teleport** — 12 world locations with native animals
- **Quest Mini-Challenges** — Tap-based challenges that scale with rarity
- **Fart Chef** — Mix any two unlocked animals to create hybrid creatures with unique names and combined fart sounds
- **Daily Challenges** — 5 free challenges per day that rotate from a pool of 10
- **Coin Economy** — Earn coins by catching animals and completing challenges; spend coins to attempt quests (lost on failure)

## Tech Stack

- Swift 5.9+ / watchOS 10+
- SwiftUI
- SwiftData (persistence)
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
- More quest mini-challenge types
- Animated animal sprites
- iCloud sync
