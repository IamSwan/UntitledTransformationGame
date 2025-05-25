export type HitInfo = {
	CanBlock : boolean,
	CanPerfectBlock : boolean,
	CanBlockBreak : boolean,
	CanBypass : boolean,
}

--|| Services ||--

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--|| Variables ||--

local CombatService = {}

--|| Modules ||--

local CombatClassInterface = require(ServerScriptService.Modules.CombatClass)

--|| Config ||--


--|| Functions ||--

--[[
This function checks if the character is valid for a hit, otherwise it'll return nil.
]]
local function IsValid(Character : Model)
	if Character:HasTag("Dead") == false  then
		return CombatClassInterface.FromCharacter(Character)
	end
end

--|| Methods ||--

function CombatService:HitVerification(Attacker : Model,Victim : Model,HitInfo : HitInfo)
	
	--[[
		Sets up the Hit data.
	]]
	local HitData = {Hit = false,Blocked = false,PerfectBlocked = false,BlockBroken = false}
	
	
	--[[
		Checks if both combatants are valid characters
	]]
		
	local AttackerClass : CombatClassInterface.CombatClass = IsValid(Attacker)
	local VictimClass :CombatClassInterface.CombatClass = IsValid(Victim)
	print(AttackerClass,VictimClass)
	if not AttackerClass then
		warn("HERE")
		return HitData
	end
	if not VictimClass then
		return HitData
	end
	if Victim:GetAttribute("PerfectBlock") == true and HitInfo.CanPerfectBlock then
		HitData.PerfectBlocked = true
		
		CombatService:_PerfectBlock(AttackerClass,VictimClass)
		
		return HitData
	end
	
	if Victim:GetAttribute("Blocking") == true and HitInfo.CanBlockBreak then
		HitData.BlockBroken = true
		
		CombatService:_BlockBreak(AttackerClass,VictimClass)
		
		return HitData
	end
	
	if Victim:GetAttribute("Blocking") == true and HitInfo.CanBlock then
		
		CombatService:_Block(AttackerClass,VictimClass)
		
		HitData.Blocked = true
		
		
		return HitData
	end
	
	HitData.Hit = true
	
	warn(`{tostring(AttackerClass)} has hit {tostring(VictimClass)}`)
	
	return HitData
end


--[[
Performs the Block break action
]]
function CombatService:_BlockBreak(AttackerClass : CombatClassInterface.CombatClass,VictimClass : CombatClassInterface.CombatClass)
	warn(`{tostring(AttackerClass)} has block broken {tostring(VictimClass)}`)
end

--[[
Performs the Perfect block action
]]
function CombatService:_PerfectBlock(AttackerClass : CombatClassInterface.CombatClass,VictimClass : CombatClassInterface.CombatClass)
	warn(`{tostring(AttackerClass)} has been perfect blocked by {tostring(VictimClass)}`)
end

--[[
Performs the Block action
]]
function CombatService:_Block(AttackerClass : CombatClassInterface.CombatClass,VictimClass : CombatClassInterface.CombatClass)
	warn(`{tostring(AttackerClass)} has been blocked by {tostring(VictimClass)}`)
end

return CombatService