local inputBinder = require(game.ReplicatedStorage.Modules.InputBinder)

game.ReplicatedStorage.Remotes.MCREMOTE.OnServerEvent:Connect(function(plr)
	local attr = plr:GetAttribute("Master")
	if not attr then
		attr = false
	end

	plr:SetAttribute("Master", not attr)

	local mcKeybindsUi = plr.PlayerGui:FindFirstChild("McKeybinds")

	if plr:GetAttribute("Master") then
		local proto = plr.Character:FindFirstChild("PrototypeOmnitrix")
		local core = proto:FindFirstChild("Moving core")

		core.CoreButtons.Color = Color3.fromRGB(147, 218, 46)
		core.CoreLines.Color = Color3.fromRGB(147, 218, 46)
		core.CoreNeon.Color = Color3.fromRGB(147, 218, 46)
		proto.MovingButton.Color = Color3.fromRGB(147, 218, 46)
		game.ReplicatedStorage.Remotes.VFXRemote:FireAllClients("PrototypeOmnitrixBlinkMaster", plr.Character.HumanoidRootPart)
		plr.Character:SetAttribute("Battery", 100)
		inputBinder:ForceBindFromServer(plr, "Mc1", { Enum.KeyCode.Z })
		inputBinder:ForceBindFromServer(plr, "Mc2", { Enum.KeyCode.X })
		inputBinder:ForceBindFromServer(plr, "Mc3", { Enum.KeyCode.C })
		inputBinder:ForceBindFromServer(plr, "Mc4", { Enum.KeyCode.B })
		inputBinder:ForceBindFromServer(plr, "Mc5", { Enum.KeyCode.N })
		if mcKeybindsUi then
			mcKeybindsUi.Enabled = true
		end
	else
		inputBinder:ForceUnbindFromServer(plr, "Mc1")
		inputBinder:ForceUnbindFromServer(plr, "Mc2")
		inputBinder:ForceUnbindFromServer(plr, "Mc3")
		inputBinder:ForceUnbindFromServer(plr, "Mc4")
		inputBinder:ForceUnbindFromServer(plr, "Mc5")
		if mcKeybindsUi then
			mcKeybindsUi.Enabled = false
		end
	end
end)
