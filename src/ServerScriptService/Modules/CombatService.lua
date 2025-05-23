--|| Services ||--

local ReplicatedStorage = game:GetService("ReplicatedStorage")

--|| Variables ||--

local CombatService = {}

--|| Modules ||--


--|| Config ||--


--|| Functions ||--

local function IsValid(Character : Model)
	return Character:GetAttribute("Character") == true and Character:GetAttribute("Dead") == false
end

--|| Methods ||--

function CombatService:HitVerification(Attacker : Model,Victim : Model)
	
	--[[
		Sets up the Hit data.
	]]
	local HitData = {Hit = false,Blocked = false,PerfectBlocked = false,BlockBroken = false}
	
	
		--[[
		Checks if both combatants are valid characters
	]]
		
	if not IsValid(Victim) then
		return HitData
	end
	if not IsValid(Attacker) then
		return HitData
	end
	
	HitData.Hit = true
	
	return HitData
end

return CombatService