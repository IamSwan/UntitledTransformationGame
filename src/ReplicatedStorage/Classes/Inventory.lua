--|| Roblox Services ||--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--|| Dependencies ||--
local Items = require(script.Parent.Items)
local ValidItems = require(script.Parent.Parent.Configs.ValidItems)

--|| Module ||--
local inventory = {}
inventory.__index = inventory

--|| Private Attributes ||--
local playersData = {}

-- Cleanup player data when they leave the game
Players.PlayerRemoving:Connect(function(player)
    playersData[player.UserId] = nil
end)

--|| Constructor ||--
function inventory.new(player: Player)
    local self = setmetatable({}, inventory)

    self.Player = player
    self.Items = {}
    playersData[player.UserId] = self
    return self
end

--|| Public Methods ||--
function inventory:AddItem(item: Items.Item, amount: number): boolean
    if not item or not item.Name or not item.Description or not item.MaxStack then
        return false
    end
    if not table.find(ValidItems, item.Name) then
        return false
    end
    local currentAmount = self.Items[item.Name] and self.Items[item.Name].Amount or 0

    if currentAmount + amount > item.MaxStack then
        return false
    end

    self.Items[item.Name] = {
        Item = item,
        Amount = currentAmount + amount
    }

    return true
end

function inventory:RemoveItem(item: string, amount: number): boolean
    local currentAmount = self.Items[item] and self.Items[item].Amount or 0

    if currentAmount - amount < 0 then
        self.Items[item] = nil
        return false
    end

    self.Items[item].Amount = currentAmount - amount

    return true
end

function inventory:GetItems(): { [string]: { Item: Items.Item, Amount: number } }
    return self.Items
end

function inventory:GetItemCount(itemName: string): number
    if self.Items[itemName] then
        return self.Items[itemName].Amount
    end
    return 0
end

function inventory:ClearInventory()
    self.Items = {}
end

function inventory.GetPlayerInventory(player: Player)
    return playersData[player.UserId]
end

return inventory
