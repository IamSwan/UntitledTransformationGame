local Players = game:GetService("Players")

-- Name(s) of Enum.KeyCode items separated by commas
local KEYS = "LeftControl,RightControl"

local mouseLockController = Players.LocalPlayer
	.PlayerScripts
	:WaitForChild("PlayerModule")
	:WaitForChild("CameraModule")
	:WaitForChild("MouseLockController")

local obj = mouseLockController:FindFirstChild("BoundKeys")
if obj then
	obj.Value = KEYS
else
	obj = Instance.new("StringValue")
	obj.Name = "BoundKeys"
	obj.Value = KEYS
	obj.Parent = mouseLockController
end
