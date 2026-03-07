# Fart Zoo — Design Document
*Date: 2026-03-06*

## Overview

Fart Zoo is a standalone Apple Watch game for kids. You teleport around the world, catch farting animals, combine them into silly hybrids, and build the ultimate Fart Zoo. Designed for 8-year-olds and up.

---

## Core Loop

1. Press **Teleport** — Watch vibrates, you land in a random world location
2. Pick an animal to catch — pay coins, complete a quest mini-challenge
3. Win → animal joins your Zoo with a unique fart sound and animation
4. Fail → coins are lost, try again
5. Collect duplicates → use Fart Chef to combine two animals into a silly hybrid
6. Complete Daily Challenges to earn free coins every day

---

## Screens

### The Zoo (Home Screen)
- Grid or list of all collected animals
- Each animal shows: name, fart animation, copy count
- Tap any animal to hear it fart
- Access Teleport, Fart Chef, and Daily Challenge from here

### Teleport
- Press the Teleport button
- Watch vibrates (haptic feedback)
- Random world location is revealed (e.g. Amazon Rainforest, Arctic, Savanna, Deep Ocean, Prehistoric World)
- List of animals native to that location appears
- Tap an animal to see its rarity, coin cost, and start the quest

### Quest (Mini-Challenge)
- Coins are deducted upfront before the challenge starts
- Mini-challenge style scales with rarity (see Rarity Tiers)
- Win → animal added to Zoo, coins rewarded
- Fail → coins lost, option to try again

### Fart Chef
- Select two animals from your collection (must own at least 1 copy of each)
- Crafting consumes 1 copy of each animal
- Result: a silly fantasy hybrid with a made-up name and unique fart sound
- Example combos: dog + fish = Dogfish, cow + elephant = Cowphant, T-Rex + shark = Sharkasaurus
- Hybrids live in the Zoo alongside regular animals

### Daily Challenge
- One new challenge appears every day
- Always free to attempt — no coins required
- Completing it rewards coins
- Examples:
  - "Fart your zoo animals 20 times"
  - "Catch 2 animals today"
  - "Make a hybrid in Fart Chef"
  - "Teleport 5 times"

---

## Rarity Tiers

Rarity is based on how rare an animal is to see in the wild in real life.

| Tier | Examples | Quest Difficulty | Coin Cost |
|------|----------|-----------------|-----------|
| Common | Dog, cow, chicken, cat, rabbit | Simple tap challenge | Low |
| Uncommon | Flamingo, otter, fox, dolphin | Longer sequences | Medium |
| Rare | Snow leopard, narwhal, komodo dragon | Precision + timing | High |
| Legendary | Shark, kakapo, axolotl, white rhino | Multi-step challenges | Very high |
| Extinct | T-Rex, mammoth, dodo, velociraptor | Hardest in the game | Extremely high |

Quest types by difficulty:
- **Easy:** Tap the screen N times fast
- **Medium:** Repeat a fart sound sequence (Simon-style)
- **Hard:** Shake + tap combo, faster timing windows
- **Legendary/Extinct:** Multi-step challenges, precise timing, longer sequences

Every quest ends with a **victory fart animation** on win.

---

## Coin Economy

| Action | Coins |
|--------|-------|
| Complete a Daily Challenge | Earned (free to attempt) |
| Catch an animal | Earned |
| Attempt a quest | Spent upfront |
| Fail a quest | Spent coins are lost |

**No deadlock guaranteed:** Daily Challenges are always free to attempt, so there is always a way to earn coins regardless of current balance.

---

## World Locations (Examples)

Each location has a curated set of native animals across multiple rarity tiers.

- Amazon Rainforest — jaguar, toucan, anaconda, axolotl, poison dart frog
- Arctic — polar bear, arctic fox, narwhal, snowy owl
- African Savanna — lion, elephant, giraffe, cheetah, white rhino
- Deep Ocean — whale shark, anglerfish, giant squid, blue whale
- Australian Outback — kangaroo, koala, platypus, kakapo
- Prehistoric World — T-Rex, triceratops, mammoth, velociraptor, dodo

---

## Animal Collection

- You can own multiple copies of the same animal
- Duplicates are needed to use Fart Chef and keep the original
- Each animal has: name, habitat, rarity tier, fart sound, idle animation
- Goal: collect all animals in the world (common through extinct)

---

## Multiplayer (Future)

Multiplayer features are planned for a future version:
- Fart Duel — two Watches compete head-to-head for the same animal
- Trading — send a copy of an animal to a friend
- Co-op Teleport — two Watches explore the same location together

---

## Platform

- **Target:** Standalone Apple Watch app (no iPhone required)
- **Target audience:** Children aged 8+
- **Visual style:** Cute and cartoony farting animals
- **Interaction:** Tap, shake (haptic), Digital Crown where appropriate
