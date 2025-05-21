-- Server

local cooldownModule = require(game.ReplicatedStorage.Modules.Cooldown)
local transformModule = require(game.ReplicatedStorage.Modules.TransformModule)
local batteryModule = require(game.ReplicatedStorage.Modules.OmnitrixBatteryModule)
local transformConfig = require(game.ReplicatedStorage.Configs.TransformConfig)
local alienPlaylistManager = require(game.ReplicatedStorage.Modules.AlienPlaylistManager)

local chatService = game:GetService"TextChatService"

local vfxRemote = game.ReplicatedStorage.Remotes.VFXRemote


return function(player: Player, alien: string)
	if not cooldownModule:IsFinished(player, "Busy") then
		print("busy.")
		return
	end
	cooldownModule:Start(player, "Busy", cooldownModule.SharedCooldowns.Transform)

	local canTransform = (not batteryModule:isTimedOut(player) or player:GetAttribute("Master") ~= nil)
	-- for the canTransform, add more conditions for possible watches evolutions

	if player.Character:GetAttribute("Transformed") then
		if player:GetAttribute("Master") then
			transformModule:transform(player, alien)
		end
		task.delay(cooldownModule.SharedCooldowns.Transform, function()
			cooldownModule:Stop(player, "Busy")
		end)
		return
	end

	if not canTransform then
		task.delay(cooldownModule.SharedCooldowns.Transform, function()
			cooldownModule:Stop(player, "Busy")
		end)
		return
	end

	local misTransform = math.random() * 100 < transformConfig.MistransformRates[player:GetAttribute("Ability")]

	if player:GetAttribute("Master") or player:GetAttribute("noMistransform") then
		misTransform = false
	end

	if misTransform then
		local randomIndex = math.random(1, #alienPlaylistManager:GetPlaylist(player))
		local randomAlien = alienPlaylistManager:GetAlienAtIndex(player, randomIndex)
		chatService:DisplayBubble(player.Character, randomAlien.."?! This watch never listens..")
		player.Character:SetAttribute("CurrentSelection", randomIndex)
		transformModule:transform(player, randomAlien)
		print("mistransform")
	else
		transformModule:transform(player, alien)
	end

	task.delay(cooldownModule.SharedCooldowns.Transform, function()
		cooldownModule:Stop(player, "Busy")
	end)
end
