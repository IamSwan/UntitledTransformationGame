-- Client

local player = game.Players.LocalPlayer

return function(action: string, state: Enum.UserInputState, inputObject: InputObject)
	if state == Enum.UserInputState.Begin then
        player.Character:SetAttribute("FlyDown", true)
    elseif state == Enum.UserInputState.End then
        player.Character:SetAttribute("FlyDown", nil)
	end

	return Enum.ContextActionResult.Pass
end
