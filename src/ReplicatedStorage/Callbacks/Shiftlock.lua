-- Client
local Players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

return function(action: string, state: Enum.UserInputState, inputObject: InputObject)
	if state ~= Enum.UserInputState.Begin then
		return
	end

    if not player.Character:GetAttribute("Shiftlock") then
        player.Character:SetAttribute("Shiftlock", true)
        userInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        userInputService.MouseIconEnabled = false
    else
        player.Character:SetAttribute("Shiftlock", nil)
        userInputService.MouseBehavior = Enum.MouseBehavior.Default
        userInputService.MouseIconEnabled = true
    end

	return Enum.ContextActionResult.Sink
end
