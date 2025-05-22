-- Server

local cooldownModule = require(game.ReplicatedStorage.Modules.Cooldown)

return function(player: Player)
	if not cooldownModule:IsFinished(player, "Busy") then
		print("busy.")
		return
	end
	cooldownModule:Start(player, "Busy", cooldownModule.SharedCooldowns.Dial)
	local dialSound: Sound = player.Character:FindFirstChild("PrototypeOmnitrix")["Moving core"].Core["Dial"..tostring(math.random(1, 3))]
	if dialSound then
		dialSound:Play()
	end
	task.delay(cooldownModule.SharedCooldowns.Dial, function()
		cooldownModule:Stop(player, "Busy")
	end)
end
