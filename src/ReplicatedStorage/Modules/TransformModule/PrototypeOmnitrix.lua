local prototypeOmnitrix = {}

local alienPlaylistManager = require(game.ReplicatedStorage.Modules.AlienPlaylistManager)
local tweenService = game:GetService("TweenService")
local config = require(game.ReplicatedStorage.Configs.TransformConfig)

local function hidePrototypeOmni(player: Player, active: boolean)
	if not player.Character then
		return
	end
	local proto = player.Character:FindFirstChild("PrototypeOmnitrix")
	if not proto then
		return
	end
	for i, v in proto:GetDescendants() do
		if v:IsA("BasePart") then
			v.Transparency = active and 1 or 0
		end
	end
end

function prototypeOmnitrix:transform(player: Player, alien: string)
	local alienFolder = game.ReplicatedStorage.Assets.Models.Aliens.PrototypeOmnitrix
	local alienModel: Model = alienFolder:FindFirstChild(alien):Clone()

	if not alienModel then
		return
	end

	local transformSound: Sound = player.Character:FindFirstChild("PrototypeOmnitrix")["Moving core"].Core.Transform
	local primedLoop: Sound = player.Character:FindFirstChild("PrototypeOmnitrix")["Moving core"].Core.PrimedLoop

	if primedLoop then
		primedLoop:Stop()
	end

	if transformSound then
		transformSound:Stop()
	end
	transformSound:Play()

	local proto = player.Character:FindFirstChild("PrototypeOmnitrix")
	local core = proto["Moving core"]

	core.CoreButtons.Material = Enum.Material.SmoothPlastic
	core.CoreLines.Material = Enum.Material.SmoothPlastic
	core.CoreNeon.Material = Enum.Material.SmoothPlastic
	proto.MovingButton.Material = Enum.Material.SmoothPlastic

	if player.Character:GetAttribute("Transformed") then
		local badge = player.Character:FindFirstChild("Alien"):FindFirstChild("Badge"):FindFirstChild("Core")
		badge.Color = Color3.fromRGB(147, 218, 46)
		badge.Material = Enum.Material.Neon
		task.wait(0.2)
		player.Character:FindFirstChild("Alien"):Destroy()
		local oldWeld = player.Character:FindFirstChild("Weld")
		if oldWeld then
			oldWeld:Destroy()
		end
	end

	game.ReplicatedStorage.Remotes.VFXRemote:FireAllClients(
		"PrototypeOmnitrixTransform",
		player.Character.HumanoidRootPart
	)

	alienModel.Name = "Alien"
	alienModel.Parent = player.Character
	local weld = Instance.new("Weld")

	alienModel.PrimaryPart.CFrame = player.Character.PrimaryPart.CFrame

	alienModel:FindFirstChild("Humanoid"):Destroy()
	weld.Part0 = player.Character:FindFirstChild("HumanoidRootPart")
	weld.Part1 = alienModel:FindFirstChild("HumanoidRootPart")
	weld.Parent = player.Character
	hidePrototypeOmni(player, true)
end

function prototypeOmnitrix:timeout(player: Player)
	local alienModel = player.Character:FindFirstChild("Alien")
	local timeout: Sound = player.Character:FindFirstChild("PrototypeOmnitrix")["Moving core"].Core.Timeout

	if not timeout.Playing then
		timeout:Stop()
	end
	if alienModel then
		timeout:Play()
		local badge = alienModel:FindFirstChild("Badge")
		if badge then
			for i = 1, 4, 1 do
				tweenService
					:Create(
						badge.Core,
						TweenInfo.new(config.PrototypeTimeoutInterval),
						{ Color = Color3.fromRGB(255, 0, 0) }
					)
					:Play()
				badge.Core.Material = Enum.Material.Neon
				task.wait(config.PrototypeTimeoutInterval)
				tweenService
					:Create(
						badge.Core,
						TweenInfo.new(config.PrototypeTimeoutInterval),
						{ Color = Color3.fromRGB(248, 248, 248) }
					)
					:Play()
				badge.Core.Material = Enum.Material.SmoothPlastic
				task.wait(config.PrototypeTimeoutInterval)
			end
		end
	end
end

function prototypeOmnitrix:detransform(player: Player)
	local alienModel = player.Character:FindFirstChild("Alien")
	if not alienModel then
		return
	end

	local detransformSound: Sound = player.Character:FindFirstChild("PrototypeOmnitrix")["Moving core"].Core.Detransform
	local transformSound: Sound = player.Character:FindFirstChild("PrototypeOmnitrix")["Moving core"].Core.Transform

	local badge = alienModel:FindFirstChild("Badge"):FindFirstChild("Core")
	if not player:GetAttribute("Master") then
		badge.Color = Color3.fromRGB(255, 0, 0)
		local proto = player.Character:FindFirstChild("PrototypeOmnitrix")
		local core = proto["Moving core"]
		core.CoreButtons.Color = Color3.fromRGB(255, 0, 0)
		core.CoreLines.Color = Color3.fromRGB(255, 0, 0)
		core.CoreNeon.Color = Color3.fromRGB(255, 0, 0)
		proto.MovingButton.Color = Color3.fromRGB(255, 0, 0)
		if detransformSound then
			detransformSound:Play()
		end
	else
		if transformSound then
			transformSound:Play()
		end
		badge.Color = Color3.fromRGB(147, 218, 46)
	end
	badge.Material = Enum.Material.Neon
	task.wait(0.2)

	game.ReplicatedStorage.Remotes.VFXRemote:FireAllClients(
		"PrototypeOmnitrixDetransform",
		player.Character.HumanoidRootPart
	)
	alienModel:Destroy()
	local weld = player.Character:FindFirstChild("Weld")
	if weld then
		weld:Destroy()
	end
	hidePrototypeOmni(player, false)
end

return prototypeOmnitrix
