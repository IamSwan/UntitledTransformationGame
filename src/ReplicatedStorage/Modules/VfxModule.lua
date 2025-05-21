local vfx = {}

local transformConfig = require(game.ReplicatedStorage.Configs.TransformConfig)

vfx.PrototypeOmnitrixTransform = function(origin: CFrame | Part)
	local vfx = game.ReplicatedStorage.Assets.VFX:FindFirstChild("PrototypeTransformationEffect"):Clone()
	vfx.Parent = origin
	local weld = Instance.new("Weld")
	weld.Parent = vfx
	weld.Part0 = origin
	weld.Part1 = vfx

	local highlight = Instance.new("Highlight")
	highlight.Parent = origin.Parent
	highlight.OutlineColor = Color3.fromRGB(147, 218, 46)
	highlight.FillColor = Color3.fromRGB(147, 218, 46)
	highlight.FillTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded

	for _, child in vfx:GetDescendants() do
		if child:IsA("ParticleEmitter") then
			child:Emit(20)
			task.delay(transformConfig.TransformDuration, function()
				game:GetService("Debris"):AddItem(highlight, 0.1)
				game:GetService("Debris"):AddItem(vfx.Attachment.PointLight, 0.35)
				game:GetService("Debris"):AddItem(vfx, 2)
			end)
		end
	end
end

vfx.PrototypeOmnitrixDetransform = function(origin: CFrame | Part)
	local vfx = nil
	local highlight = Instance.new("Highlight")
	highlight.Parent = origin.Parent
	highlight.FillTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded

	if not game.Players.LocalPlayer:GetAttribute("Master") then
		vfx = game.ReplicatedStorage.Assets.VFX:FindFirstChild("PrototypeDetransformationEffect"):Clone()
		highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
		highlight.FillColor = Color3.fromRGB(255, 0, 0)
	else
		vfx = game.ReplicatedStorage.Assets.VFX:FindFirstChild("PrototypeTransformationEffect"):Clone()
		highlight.OutlineColor = Color3.fromRGB(147, 218, 46)
		highlight.FillColor = Color3.fromRGB(147, 218, 46)
	end

	vfx.Parent = origin
	local weld = Instance.new("Weld")
	weld.Parent = vfx
	weld.Part0 = origin
	weld.Part1 = vfx

	for _, child in vfx:GetDescendants() do
		if child:IsA("ParticleEmitter") then
			child:Emit(20)
			task.delay(transformConfig.TransformDuration, function()
				game:GetService("Debris"):AddItem(highlight, 0.1)
				game:GetService("Debris"):AddItem(vfx.Attachment.PointLight, 0.35)
				game:GetService("Debris"):AddItem(vfx, 2)
			end)
		end
	end
end

vfx.PrototypeOmnitrixLightCore = function(origin: CFrame | Part)
	local character: Model = origin.Parent

	local proto = character:FindFirstChild("PrototypeOmnitrix")
	local core = proto["Moving core"]

	core.CoreButtons.Material = Enum.Material.Neon
	core.CoreLines.Material = Enum.Material.Neon
	core.CoreNeon.Material = Enum.Material.Neon
	proto.MovingButton.Material = Enum.Material.Neon
end

vfx.PrototypeOmnitrixDisableCore = function(origin: CFrame | Part)
	local character: Model = origin.Parent

	local proto = character:FindFirstChild("PrototypeOmnitrix")
	local core = proto["Moving core"]

	core.CoreButtons.Material = Enum.Material.SmoothPlastic
	core.CoreLines.Material = Enum.Material.SmoothPlastic
	core.CoreNeon.Material = Enum.Material.SmoothPlastic
	proto.MovingButton.Material = Enum.Material.SmoothPlastic
end

vfx.PrototypeOmnitrixBlinkMaster = function(origin: CFrame | Part)
	local character: Model = origin.Parent

	local proto = character:FindFirstChild("PrototypeOmnitrix")
	local core = proto["Moving core"]

	local i = 2

	repeat
		core.CoreButtons.Material = Enum.Material.Neon
		core.CoreLines.Material = Enum.Material.Neon
		core.CoreNeon.Material = Enum.Material.Neon
		proto.MovingButton.Material = Enum.Material.Neon
		task.wait(.4)
		core.CoreButtons.Material = Enum.Material.SmoothPlastic
		core.CoreLines.Material = Enum.Material.SmoothPlastic
		core.CoreNeon.Material = Enum.Material.SmoothPlastic
		proto.MovingButton.Material = Enum.Material.SmoothPlastic
		i -= 1
		task.wait(.4)
	until i == 0
end

function vfx:RequestVFX(vfxName: string, origin: CFrame | Part)
	game.ReplicatedStorage.Remotes.VFXRemote:FireServer(vfxName, origin)
end

return vfx
