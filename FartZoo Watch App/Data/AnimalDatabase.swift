import Foundation

struct AnimalDatabase {
    static let shared = AnimalDatabase()

    let all: [AnimalDefinition] = [
        // FARM - Common/Uncommon
        AnimalDefinition(id: "dog",     name: "Dog",     emoji: "🐕", rarity: .common,   location: .farm,        soundFile: "fart_common_1"),
        AnimalDefinition(id: "cat",     name: "Cat",     emoji: "🐈", rarity: .common,   location: .farm,        soundFile: "fart_common_2"),
        AnimalDefinition(id: "cow",     name: "Cow",     emoji: "🐄", rarity: .common,   location: .farm,        soundFile: "fart_common_3"),
        AnimalDefinition(id: "chicken", name: "Chicken", emoji: "🐔", rarity: .common,   location: .farm,        soundFile: "fart_common_4"),
        AnimalDefinition(id: "pig",     name: "Pig",     emoji: "🐷", rarity: .common,   location: .farm,        soundFile: "fart_common_1"),
        AnimalDefinition(id: "horse",   name: "Horse",   emoji: "🐴", rarity: .uncommon, location: .farm,        soundFile: "fart_uncommon_1"),

        // FOREST - Common/Uncommon/Rare
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
        AnimalDefinition(id: "trex",         name: "T-Rex",        emoji: "🦖",   rarity: .extinct,   location: .prehistoric, soundFile: "fart_extinct_1"),
        AnimalDefinition(id: "triceratops",  name: "Triceratops",  emoji: "🦕",   rarity: .extinct,   location: .prehistoric, soundFile: "fart_extinct_2"),
        AnimalDefinition(id: "velociraptor", name: "Velociraptor", emoji: "🦖",   rarity: .extinct,   location: .prehistoric, soundFile: "fart_extinct_1"),
        AnimalDefinition(id: "mammoth",      name: "Mammoth",      emoji: "🐘",   rarity: .extinct,   location: .prehistoric, soundFile: "fart_extinct_2"),
        AnimalDefinition(id: "dodo",         name: "Dodo",         emoji: "🐦",   rarity: .extinct,   location: .prehistoric, soundFile: "fart_extinct_1"),
        AnimalDefinition(id: "sabretooth",   name: "Sabre-tooth",  emoji: "🐱",   rarity: .extinct,   location: .prehistoric, soundFile: "fart_extinct_2"),
    ]

    func animals(for location: WorldLocation) -> [AnimalDefinition] {
        all.filter { $0.location == location }
    }

    func animal(id: String) -> AnimalDefinition? {
        all.first { $0.id == id }
    }
}
