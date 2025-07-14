-- Server

local cooldownModule = require(game.ReplicatedStorage.Modules.Cooldown)
local serverStorage = game:GetService("ServerStorage")
local tweenService = game:GetService("TweenService")
local transformModule = require(game.ReplicatedStorage.Modules.TransformModule)

return function(player: Player, alien: string)
	if not cooldownModule:IsFinished(player, "Busy") or not cooldownModule:IsFinished(player, "Transform") then
		return
	end
	cooldownModule:Start(player, "Busy", cooldownModule.SharedCooldowns.QuickChange)
	cooldownModule:Start(player, "Transform", cooldownModule.Cooldowns.Transform)
	if player.Character:GetAttribute("Transformed") then
		player.Character:SetAttribute("Alien", alien)
		transformModule:transform(player, alien)
	end
	task.delay(cooldownModule.SharedCooldowns.QuickChange, function()
		cooldownModule:Stop(player, "Busy")
	end)
	task.delay(cooldownModule.Cooldowns.Transform, function()
		cooldownModule:Stop(player, "Transform")
	end)
end
