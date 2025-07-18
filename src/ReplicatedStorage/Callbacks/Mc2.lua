-- Client
local player = game.Players.LocalPlayer
local inputBinder = require(game.ReplicatedStorage.Modules.InputBinder)
local alienPlaylistManager = require(game.ReplicatedStorage.Modules.AlienPlaylistManager)
local cooldownModule = require(game.ReplicatedStorage.Modules.Cooldown)

return function(action: string, state: Enum.UserInputState, object: InputObject)
    if state ~= Enum.UserInputState.Begin then return end
    if not player:GetAttribute("Master") then return end
    if not cooldownModule:IsFinished(player, "Busy") or not cooldownModule:IsFinished(player, "Transform") then
        print("busy.")
        return
    end
    local alien = player:GetAttribute("Mc2")
    if not alien then
        warn("No alien selected for Mc2 action.")
        return
    end
    local alienIndex = alienPlaylistManager:GetIndexFromAlien(player, alien)
    if not alienIndex then
        warn("Alien not found in playlist.")
        return
    end
    player.Character:SetAttribute("CurrentSelection", alienIndex)
    inputBinder:RunBindlessAction("Transform", state)
end
