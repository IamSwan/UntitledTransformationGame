--|| Services ||--
local userInputService = game:GetService("UserInputService")
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

--|| References ||--
local modules = replicatedStorage.Modules
local remotes = replicatedStorage.Remotes

--|| Variables ||--
local alienPlaylistManager = require(modules.AlienPlaylistManager)

--|| Modules ||--
local vfxModule = require(modules.VfxModule)
local inputBinder = require(modules.InputBinder)
local animationModule = require(modules.AnimationModule)

local character = playersService.LocalPlayer.Character or playersService.LocalPlayer.CharacterAdded:Wait()

animationModule:addAnimation("PrototypeOmnitrixPrime", "rbxassetid://86194510644371", false)
animationModule:addAnimation("PrototypeOmnitrixPrimeIdle", "rbxassetid://108076675377207")
animationModule:addAnimation("PrototypeOmnitrixEndPrime", "rbxassetid://84401605769725", false)
animationModule:addAnimation("PrototypeOmnitrixSlam", "rbxassetid://137164749424703", false)
animationModule:addAnimation("PrototypeOmnitrixDialLeft", "rbxassetid://121350484402164", false)
animationModule:addAnimation("PrototypeOmnitrixDialRight", "rbxassetid://130279441291065", false)
animationModule:addAnimation("PrototypeOmnitrixKineceleranBadgeSlam", "rbxassetid://92711182354921", false)
animationModule:addAnimation("PrototypeOmnitrixPetrosapienBadgeSlam", "rbxassetid://77952464903736", false)

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
