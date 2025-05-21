--|| Constructor ||--
local Cooldown = {}

Cooldown.SharedCooldowns = {
	["Prime"] = 0.3,
	["Transform"] = 1,
	["Dial"] = 0.1,
	["QuickChange"] = 1,
}

Cooldown.Cooldowns = {
	["Transform"] = 2,
	["Prime"] = 1,
}

function Cooldown:Start(player: Player, action: string, duration: number)
	if player:GetAttribute(action .. "_admin") then
		duration = 0.01
	end
	local t = DateTime.now()
	player:SetAttribute(action, t.UnixTimestampMillis + (duration * 1000))
end

function Cooldown:Stop(player: Player, action: string)
	player:SetAttribute(action, nil)
end

function Cooldown:IsFinished(player: Player, action: string)
	if not player:GetAttribute(action) then
		return true
	end
	if player:GetAttribute(action) == 0 then
		return false
	end
	if DateTime.now().UnixTimestampMillis >= player:GetAttribute(action) then
		return true
	end
	return false
end

return Cooldown
