--|| Roblox Services ||--
local playerService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local serverStorage = game:GetService("ServerStorage")
local alienPlaylistManager = require(replicatedStorage.Modules.AlienPlaylistManager)

local transformModule = require(replicatedStorage.Modules.TransformModule)
local batteryModule = require(replicatedStorage.Modules.OmnitrixBatteryModule)

local batteryConfig = require(replicatedStorage.Configs.BatteryConfig)

--|| Functions ||--
local function onPlayerDied(player: Player)
	transformModule:detransform(player)
end

local function onPlayerAdded(player: Player)
	-- load data
	local PLACEHOLDER_PLAYLIST = { "Pyronite", "Kineceleran", "Petrosapien", "Ectonurite", "Dummian" }

	alienPlaylistManager:SetPlaylist(player, PLACEHOLDER_PLAYLIST)
	replicatedStorage.Remotes.PlaylistRemote:FireClient(player, PLACEHOLDER_PLAYLIST)
	player:SetAttribute("Ability", "PrototypeOmnitrix")

	player.CharacterAdded:Connect(function(character: Model)
		local humanoid: Humanoid = character:FindFirstChild("Humanoid")
		transformModule:setBodyScale(character, "Human")
		humanoid.BreakJointsOnDeath = false
		if player:GetAttribute("Ability") == "PrototypeOmnitrix" then
			batteryModule:setBattery(player, batteryConfig[player:GetAttribute("Ability")].MaxBattery)
			local omniModel = replicatedStorage.Assets.Models.Watches.PrototypeOmnitrix:Clone()
			omniModel.Parent = character
			local motor = Instance.new("Motor6D")
			motor.Name = "Handle"
			motor.Part0 = character.LeftLowerArm
			motor.Part1 = omniModel.Body.Handle
			motor.C0 = CFrame.new(0.008, -0.184, -0.004) * CFrame.Angles(0, 0, math.rad(90))
			motor.Parent = character.LeftLowerArm
		end
		humanoid.Died:Connect(function()
			onPlayerDied(player)
		end)
	end)
end

local function onPlayerRemoved(player: Player)
	alienPlaylistManager:SetPlaylist(player, nil)
end

--|| Hooks ||--
playerService.PlayerAdded:Connect(onPlayerAdded)
