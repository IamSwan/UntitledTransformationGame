local alienStats = require(game.ReplicatedStorage.Configs.AliensStats)

return function(action: string, state: Enum.UserInputState, inputObject: InputObject)
	if state == Enum.UserInputState.Begin then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = alienStats[game.Players.LocalPlayer.Character:GetAttribute("Alien")].RunSpeed
    elseif state == Enum.UserInputState.End then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = alienStats[game.Players.LocalPlayer.Character:GetAttribute("Alien")].WalkSpeed
	end

	game.ReplicatedStorage.Remotes.ActionRemote:FireServer(action, state)
end
