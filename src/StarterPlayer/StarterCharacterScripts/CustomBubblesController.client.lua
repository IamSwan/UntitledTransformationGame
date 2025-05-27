local customChatRemote = game.ReplicatedStorage.Remotes.CustomChatRemote
local chatService = game:GetService("TextChatService")

local function onBubble(player, message)
    chatService:DisplayBubble(player.Character, message)
end

customChatRemote.OnClientEvent:Connect(function(player, message)
    if player and player.Character and message then
        onBubble(player, message)
    end
end)
