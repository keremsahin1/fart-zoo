import Foundation

struct AnimalDatabase {
    static let shared = AnimalDatabase()

    let all: [AnimalDefinition] = [
        // FARM (18)
        AnimalDefinition(id: "dog",       name: "Dog",       emoji: "🐕", rarity: .common,   location: .farm, soundFile: "fart_common_1"),
        AnimalDefinition(id: "cat",       name: "Cat",       emoji: "🐈", rarity: .common,   location: .farm, soundFile: "fart_common_2"),
        AnimalDefinition(id: "cow",       name: "Cow",       emoji: "🐄", rarity: .common,   location: .farm, soundFile: "fart_common_3"),
        AnimalDefinition(id: "chicken",   name: "Chicken",   emoji: "🐔", rarity: .common,   location: .farm, soundFile: "fart_common_4"),
        AnimalDefinition(id: "pig",       name: "Pig",       emoji: "🐷", rarity: .common,   location: .farm, soundFile: "fart_common_1"),
        AnimalDefinition(id: "horse",     name: "Horse",     emoji: "🐴", rarity: .uncommon, location: .farm, soundFile: "fart_uncommon_1"),
        AnimalDefinition(id: "goat",      name: "Goat",      emoji: "🐐", rarity: .common,   location: .farm, soundFile: "fart_common_2"),
        AnimalDefinition(id: "sheep",     name: "Sheep",     emoji: "🐑", rarity: .common,   location: .farm, soundFile: "fart_common_3"),
        AnimalDefinition(id: "donkey",    name: "Donkey",    emoji: "🫏", rarity: .uncommon, location: .farm, soundFile: "fart_uncommon_2"),
        AnimalDefinition(id: "duck",      name: "Duck",      emoji: "🦆", rarity: .common,   location: .farm, soundFile: "fart_common_4"),
        AnimalDefinition(id: "rooster",   name: "Rooster",   emoji: "🐓", rarity: .common,   location: .farm, soundFile: "fart_common_1"),
        AnimalDefinition(id: "mouse",     name: "Mouse",     emoji: "🐭", rarity: .common,   location: .farm, soundFile: "fart_common_2"),
        AnimalDefinition(id: "hamster",   name: "Hamster",   emoji: "🐹", rarity: .common,   location: .farm, soundFile: "fart_common_3"),
        AnimalDefinition(id: "ox",        name: "Ox",        emoji: "🐂", rarity: .uncommon, location: .farm, soundFile: "fart_uncommon_3"),
        AnimalDefinition(id: "poodle",    name: "Poodle",    emoji: "🐩", rarity: .uncommon, location: .farm, soundFile: "fart_uncommon_1"),
        AnimalDefinition(id: "worm",      name: "Worm",      emoji: "🪱", rarity: .common,   location: .farm, soundFile: "fart_common_4"),
        AnimalDefinition(id: "ladybug",   name: "Ladybug",   emoji: "🐞", rarity: .common,   location: .farm, soundFile: "fart_common_1"),
        AnimalDefinition(id: "bee",       name: "Bee",       emoji: "🐝", rarity: .common,   location: .farm, soundFile: "fart_common_2"),

        // FOREST (17)
        AnimalDefinition(id: "rabbit",    name: "Rabbit",    emoji: "🐰", rarity: .common,   location: .forest, soundFile: "fart_common_2"),
        AnimalDefinition(id: "deer",      name: "Deer",      emoji: "🦌", rarity: .uncommon, location: .forest, soundFile: "fart_uncommon_2"),
        AnimalDefinition(id: "fox",       name: "Fox",       emoji: "🦊", rarity: .uncommon, location: .forest, soundFile: "fart_uncommon_3"),
        AnimalDefinition(id: "bear",      name: "Bear",      emoji: "🐻", rarity: .rare,     location: .forest, soundFile: "fart_rare_1"),
        AnimalDefinition(id: "wolf",      name: "Wolf",      emoji: "🐺", rarity: .rare,     location: .forest, soundFile: "fart_rare_2"),
        AnimalDefinition(id: "squirrel",  name: "Squirrel",  emoji: "🐿️", rarity: .common,   location: .forest, soundFile: "fart_common_1"),
        AnimalDefinition(id: "hedgehog",  name: "Hedgehog",  emoji: "🦔", rarity: .uncommon, location: .forest, soundFile: "fart_uncommon_1"),
        AnimalDefinition(id: "moose",     name: "Moose",     emoji: "🫎", rarity: .rare,     location: .forest, soundFile: "fart_rare_3"),
        AnimalDefinition(id: "badger",    name: "Badger",    emoji: "🦡", rarity: .uncommon, location: .forest, soundFile: "fart_uncommon_2"),
        AnimalDefinition(id: "tiger",     name: "Tiger",     emoji: "🐅", rarity: .rare,     location: .forest, soundFile: "fart_rare_1"),
        AnimalDefinition(id: "turkey",    name: "Turkey",    emoji: "🦃", rarity: .uncommon, location: .forest, soundFile: "fart_uncommon_3"),
        AnimalDefinition(id: "dove",      name: "Dove",      emoji: "🕊️", rarity: .common,   location: .forest, soundFile: "fart_common_3"),
        AnimalDefinition(id: "bat",       name: "Bat",       emoji: "🦇", rarity: .uncommon, location: .forest, soundFile: "fart_uncommon_1"),
        AnimalDefinition(id: "skunk",     name: "Skunk",     emoji: "🦨", rarity: .uncommon, location: .forest, soundFile: "fart_uncommon_2"),
        AnimalDefinition(id: "raccoon",   name: "Raccoon",   emoji: "🦝", rarity: .uncommon, location: .forest, soundFile: "fart_uncommon_3"),
        AnimalDefinition(id: "ant",       name: "Ant",       emoji: "🐜", rarity: .common,   location: .forest, soundFile: "fart_common_4"),
        AnimalDefinition(id: "bug",       name: "Bug",       emoji: "🐛", rarity: .common,   location: .forest, soundFile: "fart_common_1"),

        // ARCTIC (5)
        AnimalDefinition(id: "polar_bear",   name: "Polar Bear",   emoji: "🐻‍❄️", rarity: .rare,     location: .arctic, soundFile: "fart_rare_3"),
        AnimalDefinition(id: "arctic_fox",   name: "Arctic Fox",   emoji: "🦊",   rarity: .uncommon, location: .arctic, soundFile: "fart_uncommon_1"),
        AnimalDefinition(id: "snowy_owl",    name: "Snowy Owl",    emoji: "🦉",   rarity: .uncommon, location: .arctic, soundFile: "fart_uncommon_2"),
        AnimalDefinition(id: "penguin",      name: "Penguin",      emoji: "🐧",   rarity: .common,   location: .arctic, soundFile: "fart_common_3"),
        AnimalDefinition(id: "seal",         name: "Seal",         emoji: "🦭",   rarity: .common,   location: .arctic, soundFile: "fart_common_4"),

        // AFRICAN SAVANNA (9)
        AnimalDefinition(id: "lion",         name: "Lion",         emoji: "🦁",   rarity: .rare,      location: .savanna, soundFile: "fart_rare_2"),
        AnimalDefinition(id: "elephant",     name: "Elephant",     emoji: "🐘",   rarity: .rare,      location: .savanna, soundFile: "fart_rare_3"),
        AnimalDefinition(id: "giraffe",      name: "Giraffe",      emoji: "🦒",   rarity: .uncommon,  location: .savanna, soundFile: "fart_uncommon_1"),
        AnimalDefinition(id: "zebra",        name: "Zebra",        emoji: "🦓",   rarity: .uncommon,  location: .savanna, soundFile: "fart_uncommon_2"),
        AnimalDefinition(id: "white_rhino",  name: "White Rhino",  emoji: "🦏",   rarity: .legendary, location: .savanna, soundFile: "fart_legendary_1"),
        AnimalDefinition(id: "cheetah",      name: "Cheetah",      emoji: "🐆",   rarity: .rare,      location: .savanna, soundFile: "fart_rare_1"),
        AnimalDefinition(id: "hippo",        name: "Hippo",        emoji: "🦛",   rarity: .rare,      location: .savanna, soundFile: "fart_rare_2"),
        AnimalDefinition(id: "gorilla",      name: "Gorilla",      emoji: "🦍",   rarity: .rare,      location: .savanna, soundFile: "fart_rare_3"),
        AnimalDefinition(id: "flamingo",     name: "Flamingo",     emoji: "🦩",   rarity: .uncommon,  location: .savanna, soundFile: "fart_uncommon_3"),

        // DEEP OCEAN (10)
        AnimalDefinition(id: "whale_shark",  name: "Whale Shark",  emoji: "🦈",   rarity: .legendary, location: .ocean, soundFile: "fart_legendary_2"),
        AnimalDefinition(id: "great_white",  name: "Great White",  emoji: "🦈",   rarity: .legendary, location: .ocean, soundFile: "fart_legendary_1"),
        AnimalDefinition(id: "blue_whale",   name: "Blue Whale",   emoji: "🐳",   rarity: .legendary, location: .ocean, soundFile: "fart_legendary_3"),
        AnimalDefinition(id: "octopus",      name: "Octopus",      emoji: "🐙",   rarity: .uncommon,  location: .ocean, soundFile: "fart_uncommon_3"),
        AnimalDefinition(id: "dolphin",      name: "Dolphin",      emoji: "🐬",   rarity: .uncommon,  location: .ocean, soundFile: "fart_uncommon_1"),
        AnimalDefinition(id: "jellyfish",    name: "Jellyfish",    emoji: "🪼",   rarity: .common,    location: .ocean, soundFile: "fart_common_1"),
        AnimalDefinition(id: "whale",        name: "Whale",        emoji: "🐋",   rarity: .legendary, location: .ocean, soundFile: "fart_legendary_2"),
        AnimalDefinition(id: "lobster",      name: "Lobster",      emoji: "🦞",   rarity: .uncommon,  location: .ocean, soundFile: "fart_uncommon_2"),
        AnimalDefinition(id: "crab",         name: "Crab",         emoji: "🦀",   rarity: .common,    location: .ocean, soundFile: "fart_common_2"),
        AnimalDefinition(id: "shrimp",       name: "Shrimp",       emoji: "🦐",   rarity: .common,    location: .ocean, soundFile: "fart_common_3"),

        // AMAZON RAINFOREST (10)
        AnimalDefinition(id: "jaguar",       name: "Jaguar",       emoji: "🐆",   rarity: .rare,      location: .rainforest, soundFile: "fart_rare_3"),
        AnimalDefinition(id: "poison_frog",  name: "Poison Frog",  emoji: "🐸",   rarity: .uncommon,  location: .rainforest, soundFile: "fart_uncommon_2"),
        AnimalDefinition(id: "anaconda",     name: "Anaconda",     emoji: "🐍",   rarity: .rare,      location: .rainforest, soundFile: "fart_rare_1"),
        AnimalDefinition(id: "sloth",        name: "Sloth",        emoji: "🦥",   rarity: .uncommon,  location: .rainforest, soundFile: "fart_uncommon_3"),
        AnimalDefinition(id: "parrot",       name: "Parrot",       emoji: "🦜",   rarity: .common,    location: .rainforest, soundFile: "fart_common_2"),
        AnimalDefinition(id: "spider_monkey", name: "Spider Monkey", emoji: "🐒", rarity: .rare,      location: .rainforest, soundFile: "fart_rare_2"),
        AnimalDefinition(id: "monkey",       name: "Monkey",       emoji: "🐵",   rarity: .common,    location: .rainforest, soundFile: "fart_common_3"),
        AnimalDefinition(id: "peacock",      name: "Peacock",      emoji: "🦚",   rarity: .uncommon,  location: .rainforest, soundFile: "fart_uncommon_1"),
        AnimalDefinition(id: "spider",       name: "Spider",       emoji: "🕷️",   rarity: .uncommon,  location: .rainforest, soundFile: "fart_uncommon_2"),
        AnimalDefinition(id: "butterfly",    name: "Butterfly",    emoji: "🦋",   rarity: .common,    location: .rainforest, soundFile: "fart_common_4"),

        // AUSTRALIAN OUTBACK (3)
        AnimalDefinition(id: "kangaroo",     name: "Kangaroo",     emoji: "🦘",   rarity: .common,    location: .outback, soundFile: "fart_common_3"),
        AnimalDefinition(id: "koala",        name: "Koala",        emoji: "🐨",   rarity: .uncommon,  location: .outback, soundFile: "fart_uncommon_3"),
        AnimalDefinition(id: "crocodile",    name: "Crocodile",    emoji: "🐊",   rarity: .rare,      location: .outback, soundFile: "fart_rare_1"),

        // PREHISTORIC WORLD (9)
        AnimalDefinition(id: "trex",          name: "T-Rex",         emoji: "🦖", rarity: .extinct, location: .prehistoric, soundFile: "fart_extinct_1"),
        AnimalDefinition(id: "triceratops",   name: "Triceratops",   emoji: "🦕", rarity: .extinct, location: .prehistoric, soundFile: "fart_extinct_2"),
        AnimalDefinition(id: "velociraptor",  name: "Velociraptor",  emoji: "🦖", rarity: .extinct, location: .prehistoric, soundFile: "fart_extinct_1"),
        AnimalDefinition(id: "mammoth",       name: "Mammoth",       emoji: "🦣", rarity: .extinct, location: .prehistoric, soundFile: "fart_extinct_2"),
        AnimalDefinition(id: "dodo",          name: "Dodo",          emoji: "🦤", rarity: .extinct, location: .prehistoric, soundFile: "fart_extinct_1"),
        AnimalDefinition(id: "stegosaurus",   name: "Stegosaurus",   emoji: "🦕", rarity: .extinct, location: .prehistoric, soundFile: "fart_extinct_1"),
        AnimalDefinition(id: "megalodon",     name: "Megalodon",     emoji: "🦈", rarity: .extinct, location: .prehistoric, soundFile: "fart_extinct_2"),
        AnimalDefinition(id: "dragon",        name: "Dragon",        emoji: "🐉", rarity: .extinct, location: .prehistoric, soundFile: "fart_extinct_1"),
        AnimalDefinition(id: "unicorn",       name: "Unicorn",       emoji: "🦄", rarity: .extinct, location: .prehistoric, soundFile: "fart_extinct_2"),

        // MOUNTAINS (7)
        AnimalDefinition(id: "snow_leopard",  name: "Snow Leopard",  emoji: "🐆", rarity: .legendary, location: .mountains, soundFile: "fart_legendary_1"),
        AnimalDefinition(id: "eagle",         name: "Eagle",         emoji: "🦅", rarity: .uncommon,  location: .mountains, soundFile: "fart_uncommon_2"),
        AnimalDefinition(id: "mountain_goat", name: "Mountain Goat", emoji: "🐐", rarity: .common,    location: .mountains, soundFile: "fart_common_1"),
        AnimalDefinition(id: "panda",         name: "Panda",         emoji: "🐼", rarity: .legendary, location: .mountains, soundFile: "fart_legendary_3"),
        AnimalDefinition(id: "llama",         name: "Llama",         emoji: "🦙", rarity: .common,    location: .mountains, soundFile: "fart_common_2"),
        AnimalDefinition(id: "ram",           name: "Ram",           emoji: "🐏", rarity: .uncommon,  location: .mountains, soundFile: "fart_uncommon_1"),
        AnimalDefinition(id: "bison",         name: "Bison",         emoji: "🦬", rarity: .rare,      location: .mountains, soundFile: "fart_rare_2"),

        // DESERT (6)
        AnimalDefinition(id: "camel",         name: "Camel",         emoji: "🐪", rarity: .common,    location: .desert, soundFile: "fart_common_3"),
        AnimalDefinition(id: "scorpion",      name: "Scorpion",      emoji: "🦂", rarity: .uncommon,  location: .desert, soundFile: "fart_uncommon_2"),
        AnimalDefinition(id: "rattlesnake",   name: "Rattlesnake",   emoji: "🐍", rarity: .rare,      location: .desert, soundFile: "fart_rare_1"),
        AnimalDefinition(id: "fennec_fox",    name: "Fennec Fox",    emoji: "🦊", rarity: .uncommon,  location: .desert, soundFile: "fart_uncommon_3"),
        AnimalDefinition(id: "gila_monster",  name: "Gila Monster",  emoji: "🦎", rarity: .rare,      location: .desert, soundFile: "fart_rare_2"),
        AnimalDefinition(id: "cockroach",     name: "Cockroach",     emoji: "🪳", rarity: .common,    location: .desert, soundFile: "fart_common_4"),

        // SWAMP (11)
        AnimalDefinition(id: "alligator",     name: "Alligator",     emoji: "🐊", rarity: .rare,      location: .swamp, soundFile: "fart_rare_2"),
        AnimalDefinition(id: "frog",          name: "Frog",          emoji: "🐸", rarity: .common,    location: .swamp, soundFile: "fart_common_2"),
        AnimalDefinition(id: "turtle",        name: "Turtle",        emoji: "🐢", rarity: .common,    location: .swamp, soundFile: "fart_common_3"),
        AnimalDefinition(id: "otter",         name: "Otter",         emoji: "🦦", rarity: .uncommon,  location: .swamp, soundFile: "fart_uncommon_3"),
        AnimalDefinition(id: "beaver",        name: "Beaver",        emoji: "🦫", rarity: .uncommon,  location: .swamp, soundFile: "fart_uncommon_2"),
        AnimalDefinition(id: "snapping_turtle", name: "Snapping Turtle", emoji: "🐢", rarity: .rare, location: .swamp, soundFile: "fart_rare_1"),
        AnimalDefinition(id: "swan",          name: "Swan",          emoji: "🦢", rarity: .uncommon,  location: .swamp, soundFile: "fart_uncommon_1"),
        AnimalDefinition(id: "rat",           name: "Rat",           emoji: "🐀", rarity: .common,    location: .swamp, soundFile: "fart_common_4"),
        AnimalDefinition(id: "mosquito",      name: "Mosquito",      emoji: "🦟", rarity: .common,    location: .swamp, soundFile: "fart_common_1"),
        AnimalDefinition(id: "fly",           name: "Fly",           emoji: "🪰", rarity: .common,    location: .swamp, soundFile: "fart_common_2"),
        AnimalDefinition(id: "snail",         name: "Snail",         emoji: "🐌", rarity: .common,    location: .swamp, soundFile: "fart_common_3"),
        AnimalDefinition(id: "water_buffalo", name: "Water Buffalo", emoji: "🐃", rarity: .uncommon,  location: .swamp, soundFile: "fart_uncommon_1"),

        // GALÁPAGOS ISLANDS (5)
        AnimalDefinition(id: "giant_tortoise", name: "Giant Tortoise", emoji: "🐢", rarity: .legendary, location: .galapagos, soundFile: "fart_legendary_2"),
        AnimalDefinition(id: "marine_iguana",  name: "Marine Iguana",  emoji: "🦎", rarity: .rare,      location: .galapagos, soundFile: "fart_rare_1"),
        AnimalDefinition(id: "sea_lion",       name: "Sea Lion",      emoji: "🦭", rarity: .common,    location: .galapagos, soundFile: "fart_common_4"),
        AnimalDefinition(id: "hammerhead",     name: "Hammerhead",    emoji: "🦈", rarity: .rare,      location: .galapagos, soundFile: "fart_rare_3"),
        AnimalDefinition(id: "galapagos_penguin", name: "Galápagos Penguin", emoji: "🐧", rarity: .rare, location: .galapagos, soundFile: "fart_rare_2"),
    ]

    func animals(for location: WorldLocation) -> [AnimalDefinition] {
        all.filter { $0.location == location }
    }

    func animal(id: String) -> AnimalDefinition? {
        all.first { $0.id == id }
    }
}
