--|| Config ||--
local alienStats = require(game.ReplicatedStorage.Configs.AliensStats)
local aliensAnims = require(game.ReplicatedStorage.Configs.AliensAnims)
local aliensMoves = require(game.ReplicatedStorage.Configs.AliensMoves)

--|| Dependencies ||--
local batteryModule = require(game.ReplicatedStorage.Modules.OmnitrixBatteryModule)
local animationModule = require(game.ReplicatedStorage.Modules.AnimationModule)
local inputBinder = require(game.ReplicatedStorage.Modules.InputBinder)
local keybinds = require(game.ReplicatedStorage.Configs.Keybinds)

--|| Module ||--
local transformModule = {}

--|| Private functions ||--
local function applyAlienStats(player: Player, alien: string)
	local aStats = alienStats[alien]
	if not aStats then
		return
	end
	local hum: Humanoid = player.Character:FindFirstChild("Humanoid")
	local currentMaxHealth = hum.MaxHealth
	local ratio = hum.Health / currentMaxHealth
	hum.MaxHealth = aStats.MaxHealth
	hum.Health = math.clamp(aStats.MaxHealth * ratio, 0, aStats.MaxHealth)

	game.ReplicatedStorage.Remotes.StatsRemote:FireClient(player, alien)

	local alienAnimations = aliensAnims[alien]
	if alienAnimations then
		animationModule:setNewId("Idle", aliensAnims[alien]["Idle"], player)
		animationModule:setNewId("Walk", aliensAnims[alien]["Walk"], player)
		animationModule:setNewId("Run", aliensAnims[alien]["Run"], player)
		if aliensAnims[alien]["FlyIdle"] then
		animationModule:setNewId("FlyIdle", aliensAnims[alien]["FlyIdle"], player)
		else
			animationModule:setNewId("FlyIdle", "", player)
		end
		if aliensAnims[alien]["FlyForward"] then
			animationModule:setNewId("FlyForward", aliensAnims[alien]["FlyForward"], player)
		else
			animationModule:setNewId("FlyForward", "", player)
		end
	else
		animationModule:setNewId("Idle", aliensAnims["Human"]["Idle"], player)
		animationModule:setNewId("Walk", aliensAnims["Human"]["Walk"], player)
		animationModule:setNewId("Run", aliensAnims["Human"]["Run"], player)
		animationModule:setNewId("FlyIdle", "", player)
		animationModule:setNewId("FlyForward", "", player)
	end

	if player.Character:GetAttribute("Flying") then
		if not aStats.FlySpeed then
			game.ReplicatedStorage.Remotes.ActionRemote:FireClient(player, "Fly", Enum.UserInputState.Begin)
			return
		end
		game.ReplicatedStorage.Remotes.BindRemote:FireClient(player, "FlyUp", {Enum.KeyCode.Space})
		game.ReplicatedStorage.Remotes.BindRemote:FireClient(player, "FlyDown", {Enum.KeyCode.LeftAlt})
	end
end

--|| Public functions ||--
function transformModule:applyMoves(player, alien)
	local moves = aliensMoves[alien]
	if not moves then return end
	for index, value in pairs(moves) do
		if keybinds[index] then
			inputBinder:BindAction(value, keybinds[index])
		end
	end
end

function transformModule:setBodyScale(character: Model, alien: string)
	if not game:GetService("RunService"):IsServer() then
		return
	end
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local tweenService = game:GetService("TweenService")
	local model = replicatedStorage.Assets.Models.Aliens.PrototypeOmnitrix:FindFirstChild(alien)
		or replicatedStorage.Assets.Models.Aliens:FindFirstChild(alien)
	if not model then
		return
	end

	local destBodyScales = model:FindFirstChild("BodyScale")

	if not destBodyScales then
		return
	end

	for index, alienScale in pairs(destBodyScales:GetChildren()) do
		local humanoid = character:FindFirstChild("Humanoid")
		local scale = humanoid:FindFirstChild(alienScale.Name)

		tweenService
			:Create(humanoid:FindFirstChild(alienScale.Name), TweenInfo.new(0.5), { Value = alienScale.Value })
			:Play()
	end
end

function transformModule:setInvisible(character: Model, active: boolean)
	for _, elem in character:GetChildren() do
		if elem:IsA("BasePart") and elem.Name ~= "HumanoidRootPart" then
			elem.Transparency = active and 1 or 0
		end
		if elem:IsA("Accessory") then
			elem:FindFirstChild("Handle").Transparency = active and 1 or 0
		end
	end
	for _, elem in character.Head:GetChildren() do
		if elem:IsA("Decal") then
			elem.Transparency = active and 1 or 0
		end
	end
end

function transformModule:setCameraOffset(alien: string)
	local runService = game:GetService("RunService")
	if not runService:IsClient() then
		return
	end

	local replicatedStorage = game:GetService("ReplicatedStorage")

	local model = replicatedStorage.Assets.Models.Aliens.PrototypeOmnitrix:FindFirstChild(alien)
		or replicatedStorage.Assets.Models.Aliens:FindFirstChild(alien)
	if not model then
		return
	end

	local cameraZoom = model:FindFirstChild("CameraOffset")
	if not cameraZoom then
		return
	end

	local player = game.Players.LocalPlayer
	local character = player.Character
	local humanoid: Humanoid = character:FindFirstChild("Humanoid")

	game:GetService("TweenService"):Create(humanoid, TweenInfo.new(0.5), { CameraOffset = cameraZoom.Value }):Play()
end

function transformModule:displayAlienBadge(player: Player, active: boolean)
	local alien = player.Character:FindFirstChild(player.Character:GetAttribute("Alien"))
	if not alien then
		return
	end
	local badge = alien:FindFirstChild("Badge")
	if not badge then
		return
	end

	for i, v in badge:GetChildren() do
		if v:IsA("BasePart") then
			v.Transparency = active and 0 or 1
		end
	end
end
-- main methods
function transformModule:transform(player: Player, alien: string)
	local abilityModule = script:FindFirstChild(player:GetAttribute("Ability"))
	if not abilityModule then
		error("Ability not found.")
		return
	end
	abilityModule = require(abilityModule)

	player.Character:SetAttribute("Priming", nil)

	abilityModule:transform(player, alien)
	transformModule:setInvisible(player.Character, true)
	transformModule:setBodyScale(player.Character, alien)

	player.Character:SetAttribute("Alien", alien)
	transformModule:displayAlienBadge(player, true)

	applyAlienStats(player, alien)

	if not player.Character:GetAttribute("Transformed") then
		player.Character:SetAttribute("Transformed", true)
		batteryModule:decrementBattery(player)
	end
end

function transformModule:timeout(player: Player)
	local abilityModule = script:FindFirstChild(player:GetAttribute("Ability"))
	if not abilityModule then
		error("Ability not found.")
		return
	end
	abilityModule = require(abilityModule)

	abilityModule:timeout(player)
	game.ReplicatedStorage.Remotes.ActionRemote:FireClient(player, "Detransform", Enum.UserInputState.Begin)
end

function transformModule:detransform(player: Player)
	local abilityModule = script:FindFirstChild(player:GetAttribute("Ability"))
	if not abilityModule then
		error("Ability not found.")
		return
	end
	abilityModule = require(abilityModule)
	player.Character:SetAttribute("Transformed", nil)
	abilityModule:detransform(player)
	transformModule:setInvisible(player.Character, false)
	transformModule:setBodyScale(player.Character, "Human")
	batteryModule:rechargeBattery(player)
	player.Character:SetAttribute("Alien", nil)
	applyAlienStats(player, "Human")
	if player.Character:GetAttribute("Flying") then
		game.ReplicatedStorage.Remotes.ActionRemote:FireClient(player, "Fly", Enum.UserInputState.Begin)
	end
end

if game:GetService("RunService"):IsServer() then
	game.ServerStorage:WaitForChild("CustomEvents").TimeOut.Event:Connect(function(player: Player)
		transformModule:timeout(player)
	end)
end

return transformModule
