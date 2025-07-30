local alienPlaylistManager = {}

local playlists = {}

function alienPlaylistManager:AddToPlaylist(player: Player, alien: string)
	if not playlists[player.UserId] then
		playlists[player.UserId] = {}
	end
	if table.find(playlists[player.UserId], alien) ~= nil then
		warn("Alien already in playlist!")
		return
	end
	table.insert(playlists[player.UserId], alien)
	game.ReplicatedStorage.Remotes.PlaylistRemote:FireClient(player, playlists[player.UserId])
end

function alienPlaylistManager:SetPlaylist(player: Player, playlist: {})
	if playlist == nil then
		playlists[player.UserId] = nil
	end
	if typeof(playlist) ~= "table" then
		return
	end
	playlists[player.UserId] = playlist
end

function alienPlaylistManager:RemoveFromPlaylist(player: Player, alien: string)
	if not playlists[player.UserId] then
		playlists[player.UserId] = {}
	else
		table.remove(playlists[player.UserId], table.find(playlists[player.UserId], alien))
	end
end

function alienPlaylistManager:GetPlaylist(player: Player)
	return playlists[player.UserId]
end

function alienPlaylistManager:GetAlienAtIndex(player: Player, index: number)
	return playlists[player.UserId][index]
end

function alienPlaylistManager:GetIndexFromAlien(player: Player, alien: string)
	return table.find(playlists[player.UserId], alien)
end

function alienPlaylistManager:GetFormattedAlienNameFromLower(alien: string)
	local formatted = alien:gsub("(%a)([%w]*)", function(first, rest)
		return first:upper() .. rest:lower()
	end)
	return formatted
end

return alienPlaylistManager
