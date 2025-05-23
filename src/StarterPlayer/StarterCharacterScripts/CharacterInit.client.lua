--|| Services ||--
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

--|| References ||--
local modules = replicatedStorage.Modules

--|| Modules ||--
local vfxModule = require(modules.VfxModule)
local inputBinder = require(modules.InputBinder)
local animationModule = require(modules.AnimationModule)

local player = playersService.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

--|| Default Behavior ||--
--userInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
--userInputService.MouseIconEnabled = false
character:SetAttribute("CurrentSelection", 1)

inputBinder:UnbindAllActions()

inputBinder:BindAction("Prime", { Enum.KeyCode.R })
inputBinder:BindAction("Transform", { Enum.KeyCode.T })
inputBinder:BindAction("Sprint", { Enum.KeyCode.LeftShift })

animationModule:refresh()

character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
