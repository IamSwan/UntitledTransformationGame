--|| Services ||--
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")

--|| References ||--
local modules = replicatedStorage.Modules
local statsRemote = replicatedStorage.Remotes.StatsRemote

--|| Modules ||--
local inputBinder = require(modules.InputBinder)
local animationModule = require(modules.AnimationModule)
local aliensStats = require(game.ReplicatedStorage.Configs.AliensStats)
local transformModule = require(modules.TransformModule)

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

statsRemote.OnClientEvent:Connect(function(alien: string)
    if not aliensStats[alien] then
        return
    end
    local hum: Humanoid = character:FindFirstChild("Humanoid")
    if not hum then
        return
    end
    local aStats = aliensStats[alien]
    local walkSpeed = character:GetAttribute("Sprinting") and aStats.RunSpeed or aStats.WalkSpeed
    hum.WalkSpeed = walkSpeed
    hum.JumpHeight = aStats.JumpHeight
    transformModule:applyMoves(player, alien)
end)
