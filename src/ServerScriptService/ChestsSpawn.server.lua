local chestsModule = require(game.ReplicatedStorage.Classes.Chests)
local chestPools = require(game.ReplicatedStorage.Configs.ChestsPools)

local chestFolder = workspace:FindFirstChild("Chests")

local odds = chestPools.RandomOdds

local SPAWN_INTERVAL = 10

while true do
    local rarity = nil

    local randomValue = math.random(1, 100)

    local rarityOrder = {"Legendary", "Epic", "Rare", "Uncommon", "Common"}

    for _, rarityName in ipairs(rarityOrder) do
        local probability = odds[rarityName]
        if probability then
            if randomValue <= probability then
                rarity = rarityName
                break
            end
        end
    end

    if not rarity then
        rarity = "Common" -- Default to Common if no rarity is determined
    end
    local chestSpawns = workspace:FindFirstChild("ChestSpawns")
    if chestSpawns then
        local spawnPoints = chestSpawns:GetChildren()
        if #spawnPoints > 0 then
            local randomSpawn = spawnPoints[math.random(1, #spawnPoints)]
            local chestName = randomSpawn.Name
            local chestCFrame = randomSpawn.CFrame
            if chestFolder:FindFirstChild(chestName) then
                warn("Chest spawn skipped: location already occupied")
                continue
            end
            local chest = chestsModule.new(rarity)
            chest:CreateChest(chestName, chestCFrame)
            print("Spawned a " .. rarity .. " chest at " .. tostring(chestCFrame.Position))
        end
    end
    task.wait(SPAWN_INTERVAL)
end
