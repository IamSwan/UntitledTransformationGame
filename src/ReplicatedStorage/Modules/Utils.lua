local utils = {}

-- split a string
function utils:Split(str, delimiter)
	local result = {}
	local from = 1
	local delim_from, delim_to = string.find(str, delimiter, from)
	while delim_from do
		table.insert(result, string.sub(str, from, delim_from - 1))
		from = delim_to + 1
		delim_from, delim_to = string.find(str, delimiter, from)
	end
	table.insert(result, string.sub(str, from))
	return result
end

function utils:Kick(player: Player, code: number)
	player:Kick("Code " .. code .. " - If you think this is a false claim, please contact a moderator.")
end

-- Check if a value is in a table
function utils:IsValueInTable(table: {}, value: any): boolean
	for i = 0, #table, 1 do
		if table[i] == value then
			return true, i
		end
	end
	return false, 0
end

return utils
