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

animationModule:addAnimation("PrototypeOmnitrixPrime", "rbxassetid://86194510644371", false, Enum.AnimationPriority.Action)
animationModule:addAnimation("PrototypeOmnitrixPrimeIdle", "rbxassetid://108076675377207", true, Enum.AnimationPriority.Action)
animationModule:addAnimation("PrototypeOmnitrixEndPrime", "rbxassetid://84401605769725", false, Enum.AnimationPriority.Action)
animationModule:addAnimation("PrototypeOmnitrixSlam", "rbxassetid://137164749424703", false, Enum.AnimationPriority.Action)
animationModule:addAnimation("PrototypeOmnitrixDialLeft", "rbxassetid://121350484402164", false, Enum.AnimationPriority.Action)
animationModule:addAnimation("PrototypeOmnitrixDialRight", "rbxassetid://130279441291065", false, Enum.AnimationPriority.Action)
animationModule:addAnimation("PrototypeOmnitrixKineceleranBadgeSlam", "rbxassetid://92711182354921", false, Enum.AnimationPriority.Action)
animationModule:addAnimation("PrototypeOmnitrixPetrosapienBadgeSlam", "rbxassetid://77952464903736", false, Enum.AnimationPriority.Action)
animationModule:addAnimation("PrototypeOmnitrixEctonuriteBadgeSlam", "rbxassetid://81787939428214", false, Enum.AnimationPriority.Action)
animationModule:addAnimation("PrototypeOmnitrixPyroniteBadgeSlam", "rbxassetid://98203716823315", false, Enum.AnimationPriority.Action)
animationModule:addAnimation("Idle", "rbxassetid://12416056158", true, Enum.AnimationPriority.Movement)
animationModule:addAnimation("Walk", "rbxassetid://130096611519120", true, Enum.AnimationPriority.Movement)
animationModule:addAnimation("Run", "rbxassetid://12032017076", true, Enum.AnimationPriority.Movement)

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
