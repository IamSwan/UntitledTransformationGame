-- Client

local cooldownModule = require(game.ReplicatedStorage.Modules.Cooldown)
local alienPlaylistManager = require(game.ReplicatedStorage.Modules.AlienPlaylistManager)
local animationModule = require(game.ReplicatedStorage.Modules.AnimationModule)
local transformModule = require(game.ReplicatedStorage.Modules.TransformModule)
local inputBinder = require(game.ReplicatedStorage.Modules.InputBinder)

local player = game.Players.LocalPlayer

return function(action: string, state: Enum.UserInputState, inputObject: InputObject)
	if state ~= Enum.UserInputState.Begin then
		return
	end
	if not cooldownModule:IsFinished(game.Players.LocalPlayer, "Busy") then
		print("busy.")
		return
	end

	if player.Character:GetAttribute("Transformed") and player:GetAttribute("Master") then
		cooldownModule:Start(game.Players.LocalPlayer, "Busy", cooldownModule.SharedCooldowns.Prime)

		local currentSelection = player.Character:GetAttribute("CurrentSelection")
		local targetSelection = currentSelection + 1
		if targetSelection > #alienPlaylistManager:GetPlaylist(player) then
			targetSelection = 1
		end
		player.Character:SetAttribute("CurrentSelection", targetSelection)
		game.ReplicatedStorage.Remotes.ActionRemote:FireServer("Transform", alienPlaylistManager:GetAlienAtIndex(player, targetSelection))
		inputBinder:UnbindAllActions()
		inputBinder:BindAction("QuickChange", { Enum.KeyCode.U })
		inputBinder:BindAction("Detransform", { Enum.KeyCode.T })
		inputBinder:BindAction("Sprint", { Enum.KeyCode.LeftShift })
		inputBinder:BindAction("Shiftlock", { Enum.KeyCode.LeftControl })
		if player:GetAttribute("Master") then
			inputBinder:BindAction("DialLeft", { Enum.KeyCode.Q })
			inputBinder:BindAction("DialRight", { Enum.KeyCode.E })
		end
		transformModule:applyMoves(player, alienPlaylistManager:GetAlienAtIndex(player, targetSelection))
		print("Transforming to: " .. alienPlaylistManager:GetAlienAtIndex(player, targetSelection))
		return Enum.ContextActionResult.Sink
	end

	if not player.Character:GetAttribute("Priming") then
		return
	end
	cooldownModule:Start(game.Players.LocalPlayer, "Busy", cooldownModule.SharedCooldowns.Prime)
	game.ReplicatedStorage.Remotes.ActionRemote:FireServer(action)

	local currentSelection = player.Character:GetAttribute("CurrentSelection") or 1
	if currentSelection + 1 > #alienPlaylistManager:GetPlaylist(player) then
		currentSelection = 0
	end
	local gui = player.PlayerGui:WaitForChild("AlienDisplay")
	animationModule:Play("PrototypeOmnitrixDialRight")
	player.Character:SetAttribute("CurrentSelection", currentSelection + 1)
	gui.AlienSelection.Text = alienPlaylistManager:GetAlienAtIndex(player, currentSelection + 1)

	print("Dial to: " .. alienPlaylistManager:GetAlienAtIndex(player, currentSelection + 1))

	return Enum.ContextActionResult.Sink
end
