-- Client

local cooldownModule = require(game.ReplicatedStorage.Modules.Cooldown)
local inputBinder = require(game.ReplicatedStorage.Modules.InputBinder)
local alienPlaylistManager = require(game.ReplicatedStorage.Modules.AlienPlaylistManager)
local batteryModule = require(game.ReplicatedStorage.Modules.OmnitrixBatteryModule)

local animationModule = require(game.ReplicatedStorage.Modules.AnimationModule)

local replicatedStorage = game:GetService("ReplicatedStorage")

local vfxRemote = replicatedStorage.Remotes.VFXRemote

local player = game.Players.LocalPlayer

local function handleCantTransform(player)
	if not player.Character:GetAttribute("Priming") then
		animationModule:Play("PrototypeOmnitrixPrime", 0.3)
		animationModule:getTrack("PrototypeOmnitrixPrime"):GetMarkerReachedSignal("Trigger"):Wait()
	end
	animationModule:Play("PrototypeOmnitrixSlam")
	task.delay(cooldownModule.SharedCooldowns.Transform, function()
		cooldownModule:Stop(player, "Busy")
	end)
	task.delay(cooldownModule.Cooldowns.Transform, function()
		cooldownModule:Stop(player, "Transform")
	end)
end

local function switchAlien(player)
	local alien = alienPlaylistManager:GetAlienAtIndex(player, player.Character:GetAttribute("CurrentSelection"))
	local gui = player.PlayerGui:WaitForChild("AlienDisplay")

	replicatedStorage.Remotes.ActionRemote:FireServer("Transform", alien)
	inputBinder:UnbindAllActions()
	inputBinder:BindAction("QuickChange", { Enum.KeyCode.U })
	inputBinder:BindAction("Detransform", { Enum.KeyCode.T })
	inputBinder:BindAction("DialLeft", { Enum.KeyCode.Q })
	inputBinder:BindAction("DialRight", { Enum.KeyCode.E })
	inputBinder:BindAction("Sprint", { Enum.KeyCode.LeftShift })
	inputBinder:BindAction("Shiftlock", { Enum.KeyCode.LeftControl })
	gui.Enabled = false
	print("Transforming to: " .. alien)
end

local function randomTransform(player)

	inputBinder:UnbindAllActions()
	inputBinder:BindAction("Sprint", { Enum.KeyCode.LeftShift })
	inputBinder:BindAction("Shiftlock", { Enum.KeyCode.LeftControl })
	inputBinder:BindAction("QuickChange", { Enum.KeyCode.U })
	inputBinder:BindAction("Detransform", { Enum.KeyCode.T })
	local randomIndex = math.random(1, #alienPlaylistManager:GetPlaylist(game.Players.LocalPlayer))
	local randomAlien = alienPlaylistManager:GetAlienAtIndex(game.Players.LocalPlayer, randomIndex)
	local gui = player.PlayerGui:WaitForChild("AlienDisplay")
	gui.AlienSelection.Text = randomAlien
	gui.Enabled = true
	vfxRemote:FireServer("PrototypeOmnitrixLightCore", player.Character.HumanoidRootPart)
	vfxRemote:FireServer("PrototypeOmnitrixPrimeSound", player.Character.HumanoidRootPart)
	animationModule:Play("PrototypeOmnitrixPrime", 0.3)
	animationModule:getTrack("PrototypeOmnitrixPrime"):GetMarkerReachedSignal("Trigger"):Wait()
	animationModule:Play("PrototypeOmnitrixSlam", 0.3)
	animationModule:Stop("PrototypeOmnitrixPrimeIdle", 0.1)
	animationModule:getTrack("PrototypeOmnitrixSlam"):GetMarkerReachedSignal("Trigger"):Wait()
	animationModule:Stop("PrototypeOmnitrixSlam", 0)
	replicatedStorage.Remotes.ActionRemote:FireServer("Transform", randomAlien)
	vfxRemote:FireServer("PrototypeOmnitrixDisableCore", player.Character.HumanoidRootPart)
	game.Players.LocalPlayer.Character:SetAttribute("CurrentSelection", randomIndex)
	gui.Enabled = false
	print("Transforming to: " .. randomAlien)
end

local function normalTransform(player)
	local alien = alienPlaylistManager:GetAlienAtIndex(player, player.Character:GetAttribute("CurrentSelection"))
	local gui = player.PlayerGui:WaitForChild("AlienDisplay")
	animationModule:Stop("PrototypeOmnitrixPrime", 0)
	animationModule:Stop("PrototypeOmnitrixPrimeIdle", 0.1)

	inputBinder:UnbindAllActions()
	inputBinder:BindAction("QuickChange", { Enum.KeyCode.U })
	inputBinder:BindAction("Detransform", { Enum.KeyCode.T })
	inputBinder:BindAction("Sprint", { Enum.KeyCode.LeftShift })
	inputBinder:BindAction("Shiftlock", { Enum.KeyCode.LeftControl })
	if player:GetAttribute("Master") then
		inputBinder:BindAction("DialLeft", { Enum.KeyCode.Q })
		inputBinder:BindAction("DialRight", { Enum.KeyCode.E })
	end

	animationModule:Play("PrototypeOmnitrixSlam")
	animationModule:getTrack("PrototypeOmnitrixSlam"):GetMarkerReachedSignal("Trigger"):Wait()
	animationModule:Stop("PrototypeOmnitrixSlam", 0)
	replicatedStorage.Remotes.ActionRemote:FireServer("Transform", alien)
	gui.Enabled = false
	print("Transforming to: " .. alien)

end

return function(action: string, state: Enum.UserInputState, inputObject: InputObject)
	if state ~= Enum.UserInputState.Begin then
		return
	end
	if not cooldownModule:IsFinished(game.Players.LocalPlayer, "Busy") or not cooldownModule:IsFinished(player, "Transform") then
		print("busy.")
		return
	end
	cooldownModule:Start(game.Players.LocalPlayer, "Busy", 99)
	cooldownModule:Start(game.Players.LocalPlayer, "Transform", 99)

	local canTransform = not batteryModule:isTimedOut(player)

	local currentAlien = player.Character:GetAttribute("CurrentSelection")

	if player.Character:GetAttribute("Transformed") and alienPlaylistManager:GetAlienAtIndex(player, currentAlien) == player.Character:GetAttribute("Alien") then
		-- Stop cooldowns since we're not actually transforming
		cooldownModule:Stop(player, "Busy")
		cooldownModule:Stop(player, "Transform")
		return Enum.ContextActionResult.Sink
	end

	if not canTransform then
		handleCantTransform(player)
	end
	if (player:GetAttribute("Master") or player.Character:GetAttribute("mcTransform")) and not player.Character:GetAttribute("Priming") then
		if canTransform then
			switchAlien(player)
		end
	elseif (not player.Character:GetAttribute("Priming")) and not player.Character:GetAttribute("Transformed") and not player.Character:GetAttribute("mcTransform") then
		if canTransform then
			randomTransform(player)
		else
			vfxRemote:FireServer("PrototypeOmnitrixLightCore", player.Character.HumanoidRootPart)
			animationModule:getTrack("PrototypeOmnitrixSlam").Ended:Wait()
			vfxRemote:FireServer("PrototypeOmnitrixDisableCore", player.Character.HumanoidRootPart)
		end
	elseif canTransform then
		if canTransform then
			normalTransform(player)
		end
	end
	player.Character:SetAttribute("mcTransform", nil)
	return Enum.ContextActionResult.Sink
end
