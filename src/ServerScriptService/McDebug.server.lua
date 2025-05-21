game.ReplicatedStorage.Remotes.MCREMOTE.OnServerEvent:Connect(function(plr)
	local attr = plr:GetAttribute("Master")
	if not attr then
		attr = false
	end

	plr:SetAttribute("Master", not attr)

	if plr:GetAttribute("Master") then
		local proto = plr.Character:FindFirstChild("PrototypeOmnitrix")
		local core = proto:FindFirstChild("Moving core")

		core.CoreButtons.Color = Color3.fromRGB(147, 218, 46)
		core.CoreLines.Color = Color3.fromRGB(147, 218, 46)
		core.CoreNeon.Color = Color3.fromRGB(147, 218, 46)
		proto.MovingButton.Color = Color3.fromRGB(147, 218, 46)
		game.ReplicatedStorage.Remotes.VFXRemote:FireAllClients("PrototypeOmnitrixBlinkMaster", plr.Character.HumanoidRootPart)
	end
end)
