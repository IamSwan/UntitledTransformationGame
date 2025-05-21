return function(action: string, state: Enum.UserInputState, inputObject: InputObject)
	if state ~= Enum.UserInputState.Begin then
		return
	end
	game.ReplicatedStorage.Remotes.ActionRemote:FireServer(action, state)
end
