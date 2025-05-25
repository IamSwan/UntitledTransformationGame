-- Server

local cooldownModule = require(game.ReplicatedStorage.Modules.Cooldown)

return function(player: Player)
	if player.Character:GetAttribute("Flying") then
        player.Character:SetAttribute("Flying", nil)
		return
	end

	if not cooldownModule:IsFinished(player, "Busy") then
		print("busy.")
		return
	end
	player.Character:SetAttribute("Flying", true)
end
