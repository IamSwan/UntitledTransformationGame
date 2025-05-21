--|| Roblox Services ||--
local replicatedStorage = game:GetService("ReplicatedStorage")
local serverScriptService = game:GetService("ServerScriptService")
local serverStorage = game:GetService("ServerStorage")

--|| Remotes ||--
local remotes = replicatedStorage.Remotes
local actionRemote = remotes.ActionRemote
local alienChatRemote = remotes.AlienChatRemote

--|| Custom Events ||--
local customEvents = serverStorage.CustomEvents

--|| Callback ||--
local callbackFolder = serverScriptService.Callbacks

--|| Modules ||--
local alienPlaylistManager = require(game.ReplicatedStorage.Modules.AlienPlaylistManager)

--|| Functions ||--
local function onAction(player: Player, action: string, extra: any)
	local actionCallbackModule = callbackFolder:FindFirstChild(action)
	local apm = require(game.ReplicatedStorage.Modules.AlienPlaylistManager)

	if not actionCallbackModule then
		return
	end

	local actionCallback = require(actionCallbackModule)
	actionCallback(player, extra)
end

--|| Hooks ||--
actionRemote.OnServerEvent:Connect(onAction)
