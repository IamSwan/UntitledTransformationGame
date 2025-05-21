-- Client

local cooldownModule = require(game.ReplicatedStorage.Modules.Cooldown)
local alienPlaylistManager = require(game.ReplicatedStorage.Modules.AlienPlaylistManager)
local animationModule = require(game.ReplicatedStorage.Modules.AnimationModule)

local player = game.Players.LocalPlayer

return function(action: string, state: Enum.UserInputState, inputObject: InputObject)
	if state ~= Enum.UserInputState.Begin then
		return
	end
	if not cooldownModule:IsFinished(game.Players.LocalPlayer, "Busy") then
		print("busy.")
		return
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
	animationModule:Play("PrototypeOmnitrixDialRight")
	player.Character:SetAttribute("CurrentSelection", currentSelection + 1)
	print("Dial to: " .. alienPlaylistManager:GetAlienAtIndex(player, currentSelection + 1))

	return Enum.ContextActionResult.Sink
end
