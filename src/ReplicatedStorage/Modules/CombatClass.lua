--|| Services ||--

local ReplicatedStorage = game:GetService("ReplicatedStorage")

--|| Modules ||--

local Modules = ReplicatedStorage:WaitForChild("Modules")
local Configs = ReplicatedStorage:WaitForChild("Configs")


local Trove = require(Modules:WaitForChild("Trove"))

local AlienStats = require(Configs:WaitForChild("AliensStats"))

--|| Variables ||--

local CharacterAttributes = {
	"Blocking",
	"Attacking",
	"Stunned",
	"PerfectBlock",
	"BlockBroken",
	"Staggered",
}

local SpeedDebuffAttributes = {
	"Stunned",
	"Staggered",
	"BlockBroken",
}

local CombatClass = {}

--|| Config ||--

CombatClass.__index = CombatClass

--|| Functions ||--


--|| Methods ||--

function CombatClass.new(Character : Model) : typeof(CombatClass)
	local self : typeof(CombatClass) = setmetatable({},CombatClass)

	self:_Construct(Character)

	warn(`Character Class successfully created for {Character.Name}`)

	return self
end

function CombatClass._Construct(self : typeof(CombatClass),Character : Model)
	local Maid = Trove.new()

	local function SetStates()
		for _ : number,Attribute : string in CharacterAttributes do
			Character:SetAttribute(Attribute,false)
		end
		Maid:Add(function()
			for _ : number,Attribute : string in CharacterAttributes do
				Character:SetAttribute(Attribute,nil)
			end
		end)
	end

	local function StateActions()

		local StunConnection = Character:GetAttributeChangedSignal("Stunned"):Connect(function(...: any)
			self:Stun(Character:GetAttribute("Stunned"))
		end)

		local Died = self.Humanoid.Died:Once(function()
			Character:AddTag("Died")
		end)

		Maid:Add(StunConnection)
		Maid:Add(Died)
	end

	self._Maid = Maid

	self.Character = Character

	self.Humanoid = Character:FindFirstChildWhichIsA("Humanoid")

	Maid:AttachToInstance(Character)
	SetStates()
	StateActions()

	Character:AddTag("Character")
end

function CombatClass.Stun(self : typeof(CombatClass),Value : boolean)
	if Value == true then
		self.Humanoid.WalkSpeed = 4
		self.Humanoid.JumpHeight = 0
	else
		for i : number,DebuffAttribute : string in SpeedDebuffAttributes do
			if self.Character:GetAttribute(DebuffAttribute) == true then
				break
			end
			if i == #SpeedDebuffAttributes then
				local CharacterConfigs : AlienStats.Template

				CharacterConfigs = AlienStats[self.Character:GetAttribute("Alien")]

				self.Humanoid.WalkSpeed = CharacterConfigs.WalkSpeed
				self.Humanoid.JumpHeight = CharacterConfigs.JumpHeight
			end
		end
	end
end


return CombatClass
