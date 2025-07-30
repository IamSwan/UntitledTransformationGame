local ChestPools = {}

ChestPools.RARITIES = {
    "Common",
    "Uncommon",
    "Rare",
    "Epic",
    "Legendary"
}

ChestPools.LOOT_POOLS = {
    Common = {
        ["Gold"] = { odds = 100, min = 10, max = 50 },
        ["Gems"] = { odds = 20, min = 1, max = 5 }
    },
    Uncommon = {
        ["Gold"] = { odds = 100, min = 20, max = 100 },
        ["Gems"] = { odds = 30, min = 2, max = 10 },
        ["Items"] = { odds = 10, min = 1, max = 3 }
    },
    Rare = {
        ["Gold"] = { odds = 100, min = 50, max = 200 },
        ["Gems"] = { odds = 40, min = 5, max = 20 },
        ["Items"] = { odds = 20, min = 1, max = 5 }
    },
    Epic = {
        ["Gold"] = { odds = 100, min = 100, max = 500 },
        ["Gems"] = { odds = 50, min = 10, max = 50 },
        ["Items"] = { odds = 30, min = 1, max = 10 },
        ["Artifacts"] = { odds = 5, min = 1, max = 2 }
    },
    Legendary = {
        ["Gold"] = { odds = 100, min = 200, max = 1000 },
        ["Gems"] = { odds = 60, min = 50, max = 100 },
        ["Items"] = { odds = 40, min = 10, max = 20 },
        ["Artifacts"] = { odds = 20, min = 1, max = 5 }
    }
}

ChestPools.RandomOdds = {
    Legendary = 1,
    Epic = 5,
    Rare = 10,
    Uncommon = 30,
    Common = 100
}

return ChestPools
