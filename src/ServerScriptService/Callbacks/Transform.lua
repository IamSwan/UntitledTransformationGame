-- Server

local cooldownModule = require(game.ReplicatedStorage.Modules.Cooldown)
local transformModule = require(game.ReplicatedStorage.Modules.TransformModule)
local batteryModule = require(game.ReplicatedStorage.Modules.OmnitrixBatteryModule)
local transformConfig = require(game.ReplicatedStorage.Configs.TransformConfig)
local alienPlaylistManager = require(game.ReplicatedStorage.Modules.AlienPlaylistManager)

function stopCooldown(player: Player, name: string, delay: number)
	task.delay(delay, function()
		cooldownModule:Stop(player, name)
	end)
end

return function(player: Player, alien: string)
	if not cooldownModule:IsFinished(player, "Busy") or not cooldownModule:IsFinished(player, "Transform") then
		print("busy.")
		return
	end
	cooldownModule:Start(player, "Busy", cooldownModule.SharedCooldowns.Transform)
	cooldownModule:Start(player, "Transform", cooldownModule.Cooldowns.Transform)

	local canTransform = (not batteryModule:isTimedOut(player) or player:GetAttribute("Master") ~= nil)
	-- for the canTransform, add more conditions for possible watches evolutions

	if player.Character:GetAttribute("Transformed") then
		if player:GetAttribute("Master") then
			transformModule:transform(player, alien)
		end
		stopCooldown(player, "Busy", cooldownModule.SharedCooldowns.Transform)
		stopCooldown(player, "Transform", cooldownModule.Cooldowns.Transform)
		return
	end

	if not canTransform then
		stopCooldown(player, "Busy", cooldownModule.SharedCooldowns.Transform)
		stopCooldown(player, "Transform", cooldownModule.Cooldowns.Transform)
		return
	end

	local misTransform = math.random() * 100 < transformConfig.MistransformRates[player:GetAttribute("Ability")]

	if player:GetAttribute("Master") or player:GetAttribute("noMistransform") then
		misTransform = false
	end

	if misTransform then
		local randomIndex = math.random(1, #alienPlaylistManager:GetPlaylist(player))
		local randomAlien = alienPlaylistManager:GetAlienAtIndex(player, randomIndex)
		player.Character:SetAttribute("CurrentSelection", randomIndex)
		transformModule:transform(player, randomAlien)
		if randomAlien ~= alien then
			game.ReplicatedStorage.Remotes.CustomChatRemote:FireAllClients(player, `Awww man! I wanted a {alien}, not a {randomAlien}!`)
		end
	else
		transformModule:transform(player, alien)
	end
	stopCooldown(player, "Busy", cooldownModule.SharedCooldowns.Transform)
	stopCooldown(player, "Transform", cooldownModule.Cooldowns.Transform)
end
