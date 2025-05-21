--|| Roblox Services ||--
local RunService = game:GetService("RunService")

--|| Constructor ||--
local hitboxClass = {}
hitboxClass.__index = hitboxClass

hitboxClass.HitboxTypes = table.freeze({
	["Melee"] = 1,
	["Projectile"] = 2,
	["Default"] = 1,
})

hitboxClass.WeaponTypes = table.freeze({
	["Fists"] = "Melee",
})

function hitboxClass.new(SourceCharacter: Model, Weapon: string)
	local self = setmetatable({}, hitboxClass)

	self.__sourceCharacter = SourceCharacter or nil
	self.__hitboxType = self.HitboxTypes[self.WeaponTypes[Weapon]]
	self.__weapon = Weapon

	return self
end

--|| Getters ||--
function hitboxClass:GetSourceCharacter()
	return self.__sourceCharacter
end

function hitboxClass:GetType()
	return self.__hitboxType
end

function hitboxClass:GetWeapon()
	return self.__weapon
end

--|| Private Methods ||--
local function castMelee(sourceCharacter: Model, weapon: string)
	local currentTransformation = sourceCharacter:GetAttribute("CurrentTransformation") or "Human"
	local weaponsProperties = game.ReplicatedStorage.Infos:FindFirstChild(currentTransformation .. "WeaponsProperties")
	weaponsProperties = require(weaponsProperties)
	local properties = weaponsProperties[weapon] or { BaseDamage = 2, HitDuration = 0.15, Range = 4 }
	local hitboxSize = properties.Range
	local offset = CFrame.new(0, 0, -properties.Range.Z / 2) -- Vers l’avant du personnage
	local hitboxCFrame = sourceCharacter.HumanoidRootPart.CFrame:ToWorldSpace(offset)

	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { sourceCharacter }
	params.MaxParts = 50

	local hitParts = workspace:GetPartBoundsInBox(hitboxCFrame, hitboxSize, params)

	if RunService:IsStudio() then
		local debugBox = Instance.new("Part")
		debugBox.Anchored = true
		debugBox.CanCollide = false
		debugBox.Transparency = 0.6
		debugBox.Material = Enum.Material.Neon
		debugBox.Size = hitboxSize
		debugBox.CFrame = hitboxCFrame
		debugBox.Parent = workspace
		game.Debris:AddItem(debugBox, 0.1)

		if RunService:IsClient() then
			debugBox.BrickColor = BrickColor.Blue()
		else
			debugBox.BrickColor = BrickColor.Green()
		end
	end

	for _, part in hitParts do
		if part.Name ~= "Collider" then
			continue
		end
		if part:GetAttribute("hit") then
			continue
		end
		if part:GetAttribute("iframes") then
			continue
		end

		part:SetAttribute("hit", true)
		local humanoid: Humanoid = part.Parent:FindFirstChild("Humanoid")
		if humanoid then
			humanoid:TakeDamage(properties.BaseDamage)
		end
		task.delay(0.18, function()
			part:SetAttribute("hit", nil)
		end)
	end
end

local function castProj(sourceCharacter: Model, weapon: string, alreadyHit: { [Instance]: boolean })
	print("Projectile " .. sourceCharacter.Name, weapon, alreadyHit)
end

--|| Methods ||--
function hitboxClass:Start()
	local elapsed = 0
	local lastTime = tick()

	local connection
	connection = RunService.Heartbeat:Connect(function()
		local now = tick()
		local delta = now - lastTime
		lastTime = now
		elapsed += delta

		self:Cast()
		local currentTransformation = self.__sourceCharacter:GetAttribute("CurrentTransformation") or "Human"
		local weaponsProperties =
			game.ReplicatedStorage.Infos:FindFirstChild(currentTransformation .. "WeaponsProperties")
		weaponsProperties = require(weaponsProperties)
		local properties = weaponsProperties[self.__weapon] or { BaseDamage = 2, HitDuration = 0.15, Range = 4 }

		if elapsed >= properties.HitDuration then
			connection:Disconnect()
		end
	end)
end

function hitboxClass:Cast()
	local hitboxesCallbacks = { castMelee, castProj }
	local callback = hitboxesCallbacks[self:GetType()]

	if not callback then
		return
	end

	callback(self:GetSourceCharacter(), self.__weapon)
end

return hitboxClass
