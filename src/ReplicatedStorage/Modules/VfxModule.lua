local vfx = {}

local transformConfig = require(game.ReplicatedStorage.Configs.TransformConfig)

local tweenService = game:GetService("TweenService")

vfx.PrototypeOmnitrixTransform = function(origin: CFrame | Part)
	local vfx = game.ReplicatedStorage.Assets.VFX:FindFirstChild("PrototypeTransformationEffect"):Clone()
	vfx.Parent = origin
	local weld = Instance.new("Weld")
	weld.Parent = vfx
	weld.Part0 = origin
	weld.Part1 = vfx

	local ti = TweenInfo.new(2)
	local tween = tweenService:Create(vfx.Attachment.PointLight, ti, {Brightness = 0})

	for _, child in vfx:GetDescendants() do
		if child:IsA("ParticleEmitter") then

			child:Emit(20)
			task.delay(transformConfig.TransformDuration, function()
				game:GetService("Debris"):AddItem(vfx.Attachment.PointLight, 0.35)
				game:GetService("Debris"):AddItem(vfx, 2)
			end)
		end
	end
	tween:Play()
end

vfx.PrototypeOmnitrixDetransform = function(origin: CFrame | Part)
	local vfx = nil
	local player = game.Players:GetPlayerFromCharacter(origin.Parent)

	if not player:GetAttribute("Master") then
		vfx = game.ReplicatedStorage.Assets.VFX:FindFirstChild("PrototypeDetransformationEffect"):Clone()
	else
		vfx = game.ReplicatedStorage.Assets.VFX:FindFirstChild("PrototypeTransformationEffect"):Clone()
	end

	vfx.Parent = origin
	local weld = Instance.new("Weld")
	weld.Parent = vfx
	weld.Part0 = origin
	weld.Part1 = vfx

	local ti = TweenInfo.new(2)
	local tween = tweenService:Create(vfx.Attachment.PointLight, ti, {Brightness = 0})

	for _, child in vfx:GetDescendants() do
		if child:IsA("ParticleEmitter") then
			child:Emit(20)
			task.delay(transformConfig.TransformDuration, function()
				game:GetService("Debris"):AddItem(vfx.Attachment.PointLight, 0.35)
				game:GetService("Debris"):AddItem(vfx, 2)
			end)
		end
	end
	tween:Play()
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
