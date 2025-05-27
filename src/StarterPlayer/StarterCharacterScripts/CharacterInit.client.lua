--|| Services ||--
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")

--|| References ||--
local modules = replicatedStorage.Modules

--|| Modules ||--
local inputBinder = require(modules.InputBinder)
local animationModule = require(modules.AnimationModule)

local player = playersService.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

--|| Default Behavior ||--
userInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
userInputService.MouseIconEnabled = false
character:SetAttribute("CurrentSelection", 1)
character:SetAttribute("Shiftlock", true)

inputBinder:UnbindAllActions()

inputBinder:BindAction("Prime", { Enum.KeyCode.R })
inputBinder:BindAction("Transform", { Enum.KeyCode.T })
inputBinder:BindAction("Sprint", { Enum.KeyCode.LeftShift })
inputBinder:BindAction("Shiftlock", { Enum.KeyCode.LeftControl })

animationModule:refresh()

character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
