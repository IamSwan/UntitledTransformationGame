-- Client

local cooldownModule = require(game.ReplicatedStorage.Modules.Cooldown)
local inputBinder = require(game.ReplicatedStorage.Modules.InputBinder)

local animationModule = require(game.ReplicatedStorage.Modules.AnimationModule)

local replicatedStorage = game:GetService("ReplicatedStorage")

return function(action: string, state: Enum.UserInputState, inputObject: InputObject)
	if state ~= Enum.UserInputState.Begin then
		return
	end
	if not cooldownModule:IsFinished(game.Players.LocalPlayer, "Busy") or not cooldownModule:IsFinished(game.Players.LocalPlayer, "Transform") then
		print("busy.")
		return
	end
	cooldownModule:Start(game.Players.LocalPlayer, "Busy", 99)
	cooldownModule:Start(game.Players.LocalPlayer, "Transform", 99)

	local player = game.Players.LocalPlayer

	local canDetransform = true -- to be replaced to lock the feature
	if not canDetransform then
		return
	end
	if player.Character:GetAttribute("Transformed") then
		print("Detransforming")
		inputBinder:UnbindAllActions()
		inputBinder:BindAction("Prime", { Enum.KeyCode.R })
		inputBinder:BindAction("Transform", { Enum.KeyCode.T })
		inputBinder:BindAction("Sprint", { Enum.KeyCode.LeftShift })
		inputBinder:BindAction("Shiftlock", { Enum.KeyCode.LeftControl })
		if not player:GetAttribute("Master") and inputObject ~= nil then
			local alienAnimName = player:GetAttribute("Ability")
				.. player.Character:GetAttribute("Alien")
				.. "BadgeSlam"
			local animTrack = animationModule:getTrack(alienAnimName)

			if animTrack then
				animTrack.Looped = false
				animationModule:Play(alienAnimName)
				animationModule:getTrack(alienAnimName):GetMarkerReachedSignal("Trigger"):Wait()
			end
		end
		replicatedStorage.Remotes.ActionRemote:FireServer(action)
	end

	return Enum.ContextActionResult.Sink
end
