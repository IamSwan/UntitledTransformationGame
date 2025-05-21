-- Server

local cooldownModule = require(game.ReplicatedStorage.Modules.Cooldown)

return function(player: Player)
	if not cooldownModule:IsFinished(player, "Busy") then
		print("busy.")
		return
	end
	cooldownModule:Start(player, "Busy", cooldownModule.SharedCooldowns.Dial)
	task.delay(cooldownModule.SharedCooldowns.Dial, function()
		cooldownModule:Stop(player, "Busy")
	end)
end
