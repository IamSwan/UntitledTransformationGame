local inputBinderModule = {}

local bindRemote = game.ReplicatedStorage.Remotes.BindRemote
local unbindRemote = game.ReplicatedStorage.Remotes.UnbindRemote

function inputBinderModule:BindAction(action: string, keys: { Enum.KeyCode | Enum.UserInputType })
	local contextActionService = game:GetService("ContextActionService")

	local actionCallbackModule = game.ReplicatedStorage.Callbacks:FindFirstChild(action)
	local actionCallback = nil

	if not actionCallbackModule then
		actionCallback = game.ReplicatedStorage.Callbacks.Default
		return
	end
	actionCallback = require(actionCallbackModule)

	contextActionService:BindAction(action, actionCallback, false, table.unpack(keys))
end

function inputBinderModule:RunBindlessAction(action: string, state: Enum.UserInputState)
	local actionCallbackModule = game.ReplicatedStorage.Callbacks:FindFirstChild(action)
	local actionCallback = nil

	if not actionCallbackModule then
		actionCallback = game.ReplicatedStorage.Callbacks.Default
		return
	end
	actionCallback = require(actionCallbackModule)
	actionCallback(action, state)
end

function inputBinderModule:ForceBindFromServer(player: Player, action: string, keys: { Enum.KeyCode | Enum.UserInputType })
	bindRemote:FireClient(player, action, keys)
end

function inputBinderModule:ForceUnbindFromServer(player: Player, action: string)
	unbindRemote:FireClient(player, action)
end

function inputBinderModule:UnbindAction(action: string)
	local contextActionService = game:GetService("ContextActionService")

	contextActionService:UnbindAction(action)
end

local actionIgnoreList = {
	"jumpAction",
	"RbxCameraKeypress",
	"RbxCameraThumbstick",
	"FreecamToggle",
	"MouseLockSwitchAction",
	"moveForwardAction",
	"moveBackwardAction",
	"moveLeftAction",
	"RbxCameraGamepadZoom",
	"moveRightAction",
}

function inputBinderModule:UnbindAllActions()
	local contextActionService = game:GetService("ContextActionService")
	local actionTable = contextActionService:GetAllBoundActionInfo()
	for index, value in pairs(actionTable) do
		if table.find(actionIgnoreList, index) then
			continue
		end
		contextActionService:UnbindAction(index)
	end
end

return inputBinderModule
