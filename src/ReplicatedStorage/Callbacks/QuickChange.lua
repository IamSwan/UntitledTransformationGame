-- Client

local cooldownModule = require(game.ReplicatedStorage.Modules.Cooldown)
local inputBinder = require(game.ReplicatedStorage.Modules.InputBinder)
local alienPlaylistManager = require(game.ReplicatedStorage.Modules.AlienPlaylistManager)
local transformModule = require(game.ReplicatedStorage.Modules.TransformModule)

local animationModule = require(game.ReplicatedStorage.Modules.AnimationModule)

return function(action: string, state: Enum.UserInputState, inputObject: InputObject)
	if state ~= Enum.UserInputState.Begin then
		return
	end
	if
		not cooldownModule:IsFinished(game.Players.LocalPlayer, "Busy")
		or not cooldownModule:IsFinished(game.Players.LocalPlayer, "QuickChange")
	then
		return
	end
	cooldownModule:Start(game.Players.LocalPlayer, "Busy", cooldownModule.SharedCooldowns["QuickChange"])
	cooldownModule:Start(game.Players.LocalPlayer, "QuickChange", cooldownModule.Cooldowns["Transform"])

	if not game.Players.LocalPlayer.Character:GetAttribute("Transformed") then
		return
	end

	local player = game.Players.LocalPlayer
	if not player:GetAttribute("Master") then
		local alienAnimName = player:GetAttribute("Ability") .. player.Character:GetAttribute("Alien") .. "BadgeSlam"
		local animTrack = animationModule:getTrack(alienAnimName)

		if animTrack then
			animTrack.Looped = false
			animationModule:Play(alienAnimName)
			animationModule:getTrack(alienAnimName):GetMarkerReachedSignal("Trigger"):Wait()
		end
	end

	local randomSelect = math.random(1, #alienPlaylistManager:GetPlaylist(game.Players.LocalPlayer))
	game.ReplicatedStorage.Remotes.ActionRemote:FireServer(
		action,
		alienPlaylistManager:GetAlienAtIndex(game.Players.LocalPlayer, randomSelect)
	)
	game.Players.LocalPlayer.Character:SetAttribute("CurrentSelection", randomSelect)
	print("Transforming to: " .. alienPlaylistManager:GetAlienAtIndex(game.Players.LocalPlayer, randomSelect))
	return Enum.ContextActionResult.Sink
end
