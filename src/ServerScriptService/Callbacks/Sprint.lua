-- Server

local cooldownModule = require(game.ReplicatedStorage.Modules.Cooldown)
local transformModule = require(game.ReplicatedStorage.Modules.TransformModule)

return function(player: Player, state: Enum.UserInputState)
    if state == Enum.UserInputState.Begin then
        player.Character:SetAttribute("Sprinting", true)
    elseif state == Enum.UserInputState.End then
        player.Character:SetAttribute("Sprinting", nil)
    end
end
