local Players = game:GetService("Players")
local chatService = game:GetService("TextChatService")
local alienChatRemote = game.ReplicatedStorage.Remotes.AlienChatRemote

local alienPlaylistManager = require(game.ReplicatedStorage.Modules.AlienPlaylistManager)
local inputBinder = require(game.ReplicatedStorage.Modules.InputBinder)

chatService.OnIncomingMessage = function(message: TextChatMessage)
	if message.Status ~= Enum.TextChatMessageStatus.Sending then
		return
	end
	if not game.Players.LocalPlayer:GetAttribute("Master") or game.Players.LocalPlayer.Character:GetAttribute("Priming") then
		return
	end

	for i, v in pairs(alienPlaylistManager:GetPlaylist(game.Players.LocalPlayer)) do
		if string.lower(message.Text) == string.lower(v) then
			local formattedName = alienPlaylistManager:GetFormattedAlienNameFromLower(message.Text)
			local alienIndex = alienPlaylistManager:GetIndexFromAlien(game.Players.LocalPlayer, formattedName)
			game.Players.LocalPlayer.Character:SetAttribute("CurrentSelection", alienIndex)
			game.Players.LocalPlayer.Character:SetAttribute("mcTransform", true)
			inputBinder:RunBindlessAction("Transform", Enum.UserInputState.Begin)
		end
	end
end
