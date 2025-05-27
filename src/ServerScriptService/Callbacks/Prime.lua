-- Server

local cooldownModule = require(game.ReplicatedStorage.Modules.Cooldown)
local vfxRemote = game.ReplicatedStorage.Remotes.VFXRemote

return function(player: Player)
	if not cooldownModule:IsFinished(player, "Busy") or not cooldownModule:IsFinished(player, "Prime") then
		print("busy.")
		return
	end
	cooldownModule:Start(player, "Busy", cooldownModule.SharedCooldowns.Prime)
	cooldownModule:Stop(player, "Prime", cooldownModule.Cooldowns.Prime)

	local proto = player.Character:FindFirstChild("PrototypeOmnitrix")
	local core = proto["Moving core"]

	if not player.Character:GetAttribute("Priming") then
		player.Character:SetAttribute("Priming", true)
		vfxRemote:FireAllClients( "PrototypeOmnitrixLightCore", player.Character.HumanoidRootPart)
		local primeSound: Sound = core.Core["Prime1"]
		if primeSound then
			primeSound:Play()
		end
		primeSound.Ended:Wait()
		if player.Character:GetAttribute("Priming") then
			local primedLoop = core.Core["PrimedLoop"]
			if primedLoop then
				primedLoop:Play()
			end
		end
		task.delay(cooldownModule.SharedCooldowns.Prime, function()
			cooldownModule:Stop(player, "Busy")
		end)
		return
	end
	local primedLoop: Sound = core.Core["PrimedLoop"]
	if primedLoop then
		primedLoop:Stop()
	end
	vfxRemote:FireAllClients("PrototypeOmnitrixDisableCore", player.Character.HumanoidRootPart)
	player.Character:SetAttribute("Priming", nil)
	task.delay(cooldownModule.SharedCooldowns.Prime, function()
		cooldownModule:Stop(player, "Busy")
	end)
end
