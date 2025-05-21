-- Server

local cooldownModule = require(game.ReplicatedStorage.Modules.Cooldown)
local serverStorage = game:GetService("ServerStorage")
local tweenService = game:GetService("TweenService")
local transformModule = require(game.ReplicatedStorage.Modules.TransformModule)
local batteryModule = require(game.ReplicatedStorage.Modules.OmnitrixBatteryModule)

local vfxRemote = game.ReplicatedStorage.Remotes.VFXRemote

return function(player: Player)
	if not cooldownModule:IsFinished(player, "Busy") then
		print("busy.")
		return
	end
	cooldownModule:Start(player, "Busy", cooldownModule.SharedCooldowns.Transform)

	local canDetransform = true -- to be replaced to lock the feature

	if player.Character:GetAttribute("Transformed") and canDetransform then
		vfxRemote:FireAllClients("PrototypeOmnitrixDisableCore", player.Character.HumanoidRootPart)
		transformModule:detransform(player)
	end
	task.delay(cooldownModule.SharedCooldowns.Transform, function()
		cooldownModule:Stop(player, "Busy")
	end)
end
