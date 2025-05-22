local remote = game.ReplicatedStorage.Remotes.MCREMOTE

local button = script.Parent

button.Visible = true

button.MouseButton1Click:Connect(function()
	remote:FireServer()
end)
