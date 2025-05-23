local alienStats = require(game.ReplicatedStorage.Configs.AliensStats)

return function(action: string, state: Enum.UserInputState, inputObject: InputObject)
    local alien = game.Players.LocalPlayer.Character:GetAttribute("Alien")
    if not alien then
        alien = "Human"
    end

	if state == Enum.UserInputState.Begin then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = alienStats[alien].RunSpeed
    elseif state == Enum.UserInputState.End then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = alienStats[alien].WalkSpeed
	end

	game.ReplicatedStorage.Remotes.ActionRemote:FireServer(action, state)
end
