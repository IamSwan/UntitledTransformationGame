-- Client

local cooldownModule = require(game.ReplicatedStorage.Modules.Cooldown)
local inputBinder = require(game.ReplicatedStorage.Modules.InputBinder)
local alienPlaylistManager = require(game.ReplicatedStorage.Modules.AlienPlaylistManager)
local batteryModule = require(game.ReplicatedStorage.Modules.OmnitrixBatteryModule)

local animationModule = require(game.ReplicatedStorage.Modules.AnimationModule)
local aliensAnims = require(game.ReplicatedStorage.Configs.AliensAnims)

local replicatedStorage = game:GetService("ReplicatedStorage")

local vfxRemote = replicatedStorage.Remotes.VFXRemote

local function handleCantTransform(player)
	if not player.Character:GetAttribute("Priming") then
		animationModule:Play("PrototypeOmnitrixPrime", 0.3)
		animationModule:getTrack("PrototypeOmnitrixPrime"):GetMarkerReachedSignal("Trigger"):Wait()
	end
	animationModule:Play("PrototypeOmnitrixSlam")
end

local function switchAlien(player)
	local alien = alienPlaylistManager:GetAlienAtIndex(player, player.Character:GetAttribute("CurrentSelection"))

	replicatedStorage.Remotes.ActionRemote:FireServer("Transform", alien)
	if not player.Character:GetAttribute("Transformed") then
		inputBinder:UnbindAction("Prime")
		inputBinder:BindAction("QuickChange", { Enum.KeyCode.U })
		inputBinder:BindAction("Detransform", { Enum.KeyCode.T })
	end
	print("Transforming to: " .. alien)
end

local function randomTransform(player)
	inputBinder:UnbindAction("Prime")
	inputBinder:BindAction("QuickChange", { Enum.KeyCode.U })
	inputBinder:BindAction("Detransform", { Enum.KeyCode.T })
	local randomIndex = math.random(1, #alienPlaylistManager:GetPlaylist(game.Players.LocalPlayer))
	local randomAlien = alienPlaylistManager:GetAlienAtIndex(game.Players.LocalPlayer, randomIndex)
	animationModule:Play("PrototypeOmnitrixPrime", 0.3)
	animationModule:getTrack("PrototypeOmnitrixPrime"):GetMarkerReachedSignal("Trigger"):Wait()
	vfxRemote:FireServer("PrototypeOmnitrixLightCore", player.Character.HumanoidRootPart)
	animationModule:Play("PrototypeOmnitrixSlam", 0.3)
	animationModule:Stop("PrototypeOmnitrixPrimeIdle", 0.1)
	animationModule:getTrack("PrototypeOmnitrixSlam"):GetMarkerReachedSignal("Trigger"):Wait()
	animationModule:Stop("PrototypeOmnitrixSlam", 0)
	replicatedStorage.Remotes.ActionRemote:FireServer("Transform", randomAlien)
	vfxRemote:FireServer("PrototypeOmnitrixDisableCore", player.Character.HumanoidRootPart)
	game.Players.LocalPlayer.Character:SetAttribute("CurrentSelection", randomIndex)
	print("Transforming to: " .. randomAlien)
end

local function normalTransform(player)
	local alien = alienPlaylistManager:GetAlienAtIndex(player, player.Character:GetAttribute("CurrentSelection"))

	animationModule:Stop("PrototypeOmnitrixPrime", 0)
	animationModule:Stop("PrototypeOmnitrixPrimeIdle", 0.1)

	inputBinder:UnbindAction("Prime")
	inputBinder:BindAction("QuickChange", { Enum.KeyCode.U })
	inputBinder:BindAction("Detransform", { Enum.KeyCode.T })

	animationModule:Play("PrototypeOmnitrixSlam")
	animationModule:getTrack("PrototypeOmnitrixSlam"):GetMarkerReachedSignal("Trigger"):Wait()
	animationModule:Stop("PrototypeOmnitrixSlam", 0)
	replicatedStorage.Remotes.ActionRemote:FireServer("Transform", alien)
	print("Transforming to: " .. alien)

end

return function(action: string, state: Enum.UserInputState, inputObject: InputObject)
	if state ~= Enum.UserInputState.Begin then
		return
	end
	if not cooldownModule:IsFinished(game.Players.LocalPlayer, "Busy") then
		print("busy.")
		return
	end
	cooldownModule:Start(game.Players.LocalPlayer, "Busy", cooldownModule.SharedCooldowns["Transform"])

	local player = game.Players.LocalPlayer

	local canTransform = not batteryModule:isTimedOut(player)

	local currentAlien = player.Character:GetAttribute("CurrentSelection")

	if player.Character:GetAttribute("Transformed") and alienPlaylistManager:GetAlienAtIndex(player, currentAlien) == player.Character:GetAttribute("Alien") then
		return Enum.ContextActionResult.Sink
	end

	if not canTransform then
		handleCantTransform(player)
	end
	if (player:GetAttribute("Master") or player.Character:GetAttribute("mcTransform")) and not player.Character:GetAttribute("Priming") then
		if canTransform then
			switchAlien(player)
			animationModule:setNewId("Idle", aliensAnims[alienPlaylistManager:GetAlienAtIndex(player, currentAlien)]["Idle"])
			animationModule:setNewId("Walk", aliensAnims[alienPlaylistManager:GetAlienAtIndex(player, currentAlien)]["Walk"])
			animationModule:setNewId("Run", aliensAnims[alienPlaylistManager:GetAlienAtIndex(player, currentAlien)]["Run"])
		end
	elseif (not player.Character:GetAttribute("Priming")) and not player.Character:GetAttribute("Transformed") and not player.Character:GetAttribute("mcTransform") then
		if canTransform then
			randomTransform(player)
			animationModule:setNewId("Idle", aliensAnims[alienPlaylistManager:GetAlienAtIndex(player, currentAlien)]["Idle"])
			animationModule:setNewId("Walk", aliensAnims[alienPlaylistManager:GetAlienAtIndex(player, currentAlien)]["Walk"])
			animationModule:setNewId("Run", aliensAnims[alienPlaylistManager:GetAlienAtIndex(player, currentAlien)]["Run"])
		else
			vfxRemote:FireServer("PrototypeOmnitrixLightCore", player.Character.HumanoidRootPart)
			animationModule:getTrack("PrototypeOmnitrixSlam").Ended:Wait()
			vfxRemote:FireServer("PrototypeOmnitrixDisableCore", player.Character.HumanoidRootPart)
		end
	elseif canTransform then
		if canTransform then
			normalTransform(player)
			animationModule:setNewId("Idle", aliensAnims[alienPlaylistManager:GetAlienAtIndex(player, currentAlien)]["Idle"])
			animationModule:setNewId("Walk", aliensAnims[alienPlaylistManager:GetAlienAtIndex(player, currentAlien)]["Walk"])
			animationModule:setNewId("Run", aliensAnims[alienPlaylistManager:GetAlienAtIndex(player, currentAlien)]["Run"])
		end
	end
	player.Character:SetAttribute("mcTransform", nil)
	return Enum.ContextActionResult.Sink
end
