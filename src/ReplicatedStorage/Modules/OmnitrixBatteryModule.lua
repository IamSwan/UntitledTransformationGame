local batteryConfig = require(game.ReplicatedStorage.Configs.BatteryConfig)

local omnitrixBatteryModule = {}

function omnitrixBatteryModule:getBattery(player: Player)
	return player.Character:GetAttribute("Battery")
end

function omnitrixBatteryModule:setBattery(player: Player, amount: number)
	player.Character:SetAttribute("Battery", amount)
end

function omnitrixBatteryModule:isTimedOut(player: Player): boolean
	if player:GetAttribute("Master") then
		return false
	end
	return player.Character:GetAttribute("Battery") ~= batteryConfig[player:GetAttribute("Ability")].MaxBattery
end

function omnitrixBatteryModule:decrementBattery(player: Player)
	local drainRate = batteryConfig[player:GetAttribute("Ability")].DrainRate
	if not player.Character then
		player.CharacterAdded:Wait()
	end
	task.spawn(function()
		while player.Character:GetAttribute("Battery") > 0 and player.Character:GetAttribute("Transformed") do
			if player:GetAttribute("Master") then
				break
			end
			local result = player.Character:GetAttribute("Battery") - drainRate
			result = math.max(0, result)
			player.Character:SetAttribute("Battery", result)
			task.wait(1)
		end
		if player.Character:GetAttribute("Battery") <= 0 and not player:GetAttribute("Master") then
			game.ServerStorage.CustomEvents.TimeOut:Fire(player)
		end
	end)
end

function omnitrixBatteryModule:rechargeBattery(player: Player)
	local rechargeRate = batteryConfig[player:GetAttribute("Ability")].RechargeRate
	if not player.Character then
		player.CharacterAdded:Wait()
	end
	task.spawn(function()
		while
			player.Character:GetAttribute("Battery") < batteryConfig[player:GetAttribute("Ability")].MaxBattery
			and not player.Character:GetAttribute("Transformed")
		do
			local result = player.Character:GetAttribute("Battery") + rechargeRate
			result = math.min(batteryConfig[player:GetAttribute("Ability")].MaxBattery, result)
			player.Character:SetAttribute("Battery", result)
			if player.Character:GetAttribute("Battery") >= batteryConfig[player:GetAttribute("Ability")].MaxBattery then
				if player:GetAttribute("Ability") == "PrototypeOmnitrix" then
					local proto = player.Character:FindFirstChild("PrototypeOmnitrix")
					local core = proto["Moving core"]
					core.CoreButtons.Color = Color3.fromRGB(147, 218, 46)
					core.CoreLines.Color = Color3.fromRGB(147, 218, 46)
					core.CoreNeon.Color = Color3.fromRGB(147, 218, 46)
					proto.MovingButton.Color = Color3.fromRGB(147, 218, 46)
				end
			end
			task.wait(1)
		end
	end)
end

return omnitrixBatteryModule
