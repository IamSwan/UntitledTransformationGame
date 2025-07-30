--|| Module ||--
local ChestsModule = {}
ChestsModule.__index = ChestsModule

--|| Dependencies ||--
local ChestPools = require(game.ReplicatedStorage.Configs.ChestsPools)

--|| Variables ||--
local chestFolder = workspace:FindFirstChild("Chests")
if not chestFolder then
    chestFolder = Instance.new("Folder")
    chestFolder.Name = "Chests"
    chestFolder.Parent = workspace
end

--|| Constants ||--
local CHEST_RARITIES = ChestPools.RARITIES
local CHEST_LOOT_POOLS = ChestPools.LOOT_POOLS

--|| Constructor ||--
function ChestsModule.new(rarity: string?)
    if not rarity or not table.find(CHEST_RARITIES, rarity) then
        rarity = "Common" -- Default to Common if no valid rarity is provided
    end
    local self = setmetatable({}, ChestsModule)
    self._rarity = rarity
    self._items = {}
    return self
end

--|| Private Methods ||--
function ChestsModule:GenerateLoot()
    local lootPool = CHEST_LOOT_POOLS[self._rarity]
    for itemType, data in pairs(lootPool) do
        if math.random(100) <= data.odds then
            local amount = math.random(data.min, data.max)
            self._items[itemType] = (self._items[itemType] or 0) + amount
        end
    end
end

--|| Public Methods ||--
function ChestsModule:GetRarity()
    return self._rarity
end

function ChestsModule:GetItems()
    return self._items
end

function ChestsModule:CreateChest(name: string, Cframe: CFrame)
    if not name or not Cframe then
        error("Name and CFrame are required to create a chest.")
    end
    local chest = game.ServerStorage.Chests:FindFirstChild(self._rarity):Clone()
    chest.Name = name
    chest.PrimaryPart.CFrame = Cframe
    chest.PrimaryPart.Anchored = true
    chest.PrimaryPart.CanCollide = false
    chest.Parent = chestFolder

    local proxPrompt = chest:FindFirstChild("ProximityPrompt")
    if not proxPrompt then
        proxPrompt = Instance.new("ProximityPrompt")
        proxPrompt.ActionText = "Open Chest"
        proxPrompt.ObjectText = name
        proxPrompt.RequiresLineOfSight = false
        proxPrompt.MaxActivationDistance = 10
        proxPrompt.Parent = chest
    end

    proxPrompt.Triggered:Once(function(player)
        self:OpenChest(player, chest)
    end)

    --placeholder color
    chest.PrimaryPart.BrickColor = BrickColor.Random()
    return chest
end

function ChestsModule:OpenChest(sourcePlayer: Player, chest: Model)
    if not sourcePlayer or not sourcePlayer:IsA("Player") then
        error("Invalid player provided.")
    end
    if not chest or not chest:IsA("Model") then
        error("Invalid chest provided.")
    end

    self:GenerateLoot()
    local items = self:GetItems()

    -- Debug print
    for itemType, amount in pairs(items) do
        print(string.format("Received %d %s from %s chest.", amount, itemType, self._rarity))
    end
    -- end of debug print

    chest:Destroy()
end

return ChestsModule
