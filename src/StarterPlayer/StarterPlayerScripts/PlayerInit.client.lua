--|| Services ||--
local replicatedStorage = game:GetService("ReplicatedStorage")
local starterGui = game:GetService("StarterGui")

--|| References ||--
local modules = replicatedStorage.Modules
local remotes = replicatedStorage.Remotes

--|| Variables ||--
local alienPlaylistManager = require(modules.AlienPlaylistManager)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

--|| Modules ||--
local vfxModule = require(modules.VfxModule)
local inputBinder = require(modules.InputBinder)
local animationModule = require(modules.AnimationModule)

animationModule:addAnimation("PrototypeOmnitrixPrime", "rbxassetid://100630483792767", false, Enum.AnimationPriority.Action)
animationModule:addAnimation("PrototypeOmnitrixPrimeIdle", "rbxassetid://104060800612986", true, Enum.AnimationPriority.Action)
animationModule:addAnimation("PrototypeOmnitrixEndPrime", "rbxassetid://112005504872741", false, Enum.AnimationPriority.Action)
animationModule:addAnimation("PrototypeOmnitrixSlam", "rbxassetid://92999302234569", false, Enum.AnimationPriority.Action)
animationModule:addAnimation("PrototypeOmnitrixDialLeft", "rbxassetid://109720974860390", false, Enum.AnimationPriority.Action)
animationModule:addAnimation("PrototypeOmnitrixDialRight", "rbxassetid://80463665560563", false, Enum.AnimationPriority.Action)
animationModule:addAnimation("PrototypeOmnitrixKineceleranBadgeSlam", "rbxassetid://130680117539560", false, Enum.AnimationPriority.Action)
animationModule:addAnimation("PrototypeOmnitrixPetrosapienBadgeSlam", "rbxassetid://120115352460800", false, Enum.AnimationPriority.Action)
animationModule:addAnimation("PrototypeOmnitrixEctonuriteBadgeSlam", "rbxassetid://123188040286481", false, Enum.AnimationPriority.Action)
animationModule:addAnimation("PrototypeOmnitrixPyroniteBadgeSlam", "rbxassetid://82029487639569", false, Enum.AnimationPriority.Action)
animationModule:addAnimation("Idle", "rbxassetid://98465599437952", true, Enum.AnimationPriority.Movement)
animationModule:addAnimation("Walk", "rbxassetid://77435289083145", true, Enum.AnimationPriority.Movement)
animationModule:addAnimation("Run", "rbxassetid://137189635411566", true, Enum.AnimationPriority.Movement)

--|| Aliens Animations ||--


--|| Functions ||--
local function onPlaylistReceived(playlist: {})
	alienPlaylistManager:SetPlaylist(game.Players.LocalPlayer, playlist)
end

local function onVfxRequest(vfx: string, origin: CFrame | Part)
	local vfxToPlay = vfxModule[vfx]
	if not vfxToPlay then
		return
	end
	vfxToPlay(origin)
end

local function onForceAction(action: string, state: Enum.UserInputState)
	inputBinder:RunBindlessAction(action, state)
end

--|| Hooks ||--
remotes.PlaylistRemote.OnClientEvent:Connect(onPlaylistReceived)
remotes.VFXRemote.OnClientEvent:Connect(onVfxRequest)
remotes.ActionRemote.OnClientEvent:Connect(onForceAction)
starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
-- starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
