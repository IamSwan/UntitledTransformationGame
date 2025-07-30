-- Client

local cooldownModule = require(game.ReplicatedStorage.Modules.Cooldown)
local inputBinder = require(game.ReplicatedStorage.Modules.InputBinder)

local player = game.Players.LocalPlayer

local animationModule = require(game.ReplicatedStorage.Modules.AnimationModule)
local alienPlaylistManager = require(game.ReplicatedStorage.Modules.AlienPlaylistManager)

return function(action: string, state: Enum.UserInputState, inputObject: InputObject)
	if state ~= Enum.UserInputState.Begin then
		return
	end
	if not cooldownModule:IsFinished(player, "Busy") or not cooldownModule:IsFinished(player, "Prime") then
		print("busy.")
		return
	end
	cooldownModule:Start(player, "Busy", 99)
	cooldownModule:Start(player, "Prime", 99)
	local gui = player.PlayerGui:WaitForChild("AlienDisplay")


	if player.Character:GetAttribute("Priming") then
		print("Unpriming")
		inputBinder:UnbindAction("DialRight")
		inputBinder:UnbindAction("DialLeft")
		gui.Enabled = false
		animationModule:Stop("PrototypeOmnitrixPrime", 0)
		animationModule:Stop("PrototypeOmnitrixPrimeIdle", 0.2)
		animationModule:Play("PrototypeOmnitrixEndPrime", 0.2, 0.4)
		game.ReplicatedStorage.Remotes.ActionRemote:FireServer(action)
	else
		print("Priming")
		animationModule:Play("PrototypeOmnitrixPrime", 0.2)
		game.ReplicatedStorage.Remotes.ActionRemote:FireServer(action)
		gui.Enabled = true
		gui.AlienSelection.Text = alienPlaylistManager:GetAlienAtIndex(player, player.Character:GetAttribute("CurrentSelection") or 1)
		animationModule:getTrack("PrototypeOmnitrixPrime"):GetMarkerReachedSignal("Trigger"):Wait()
		animationModule:Play("PrototypeOmnitrixPrimeIdle")
		inputBinder:BindAction("DialRight", { Enum.KeyCode.E })
		inputBinder:BindAction("DialLeft", { Enum.KeyCode.Q })
	end

	return Enum.ContextActionResult.Sink
end
