function getIdentity(source)
	local identifier = nil
	for k,v in pairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len("license:")) == "license:" then
			identifier = v
		end
	end
	identifier = identifier:gsub("%license:", "")
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			group = identity['group']
		}
	else
		return nil
	end
end

RegisterCommand('setgroup', function(source, args)
    local src = getIdentity(source)
	local msgSrc = "Server"
	local msgCol = {255, 0, 0 }
	local msgSep = ": "

	if source == tonumber(args[1]) then
		TriggerClientEvent('chatMessage', source, msgSrc .. msgSep, msgCol, "You cannot change your own group!")
	else
		if src.group == 'superadmin' then
			local found = false
			for _, playerId in ipairs(GetPlayers()) do
				if (tonumber(playerId) == tonumber(args[1])  and found == false) then
					found = true
					local trg = getIdentity(tonumber(args[1]))
					if args[2] == 'user' then
						MySQL.Async.execute("UPDATE users SET `group`='user' WHERE `identifier`=@identifier", {identifier = trg.identifier})
						TriggerClientEvent('chatMessage', source, msgSrc .. msgSep, msgCol, "Set group for player " ..GetPlayerName(playerId).. " to user")
						TriggerClientEvent('chatMessage', playerId, msgSrc .. msgSep, msgCol, "Your group has been set to user")
					elseif args[2] == 'mod' then
						MySQL.Async.execute("UPDATE users SET `group`='mod' WHERE `identifier`=@identifier", {identifier = trg.identifier})
						TriggerClientEvent('chatMessage', source, msgSrc .. msgSep, msgCol, "Set group for player " ..GetPlayerName(playerId).. " to mod")
						TriggerClientEvent('chatMessage', playerId, msgSrc .. msgSep, msgCol, "Your group has been set to mod")
					elseif args[2] == 'admin' then
						MySQL.Async.execute("UPDATE users SET `group`='admin' WHERE `identifier`=@identifier", {identifier = trg.identifier})
						TriggerClientEvent('chatMessage', source, msgSrc .. msgSep, msgCol, "Set group for player " ..GetPlayerName(playerId).. " to admin")
						TriggerClientEvent('chatMessage', playerId, msgSrc .. msgSep, msgCol, "Your group has been set to admin")
					elseif args[2] == 'superadmin' then
						MySQL.Async.execute("UPDATE users SET `group`='superadmin' WHERE `identifier`=@identifier", {identifier = trg.identifier})
						TriggerClientEvent('chatMessage', source, msgSrc .. msgSep, msgCol, "Set group for player " ..GetPlayerName(playerId).. " to superadmin")
						TriggerClientEvent('chatMessage', playerId, msgSrc .. msgSep, msgCol, "Your group has been set to superadmin")
					else
						TriggerClientEvent('chatMessage', source, msgSrc .. msgSep, msgCol, "Wrong group!")
					end
				end
			end

			if found == false then
				TriggerClientEvent('chatMessage', source, msgSrc .. msgSep, msgCol, "There is no player with ID " .. args[1] .. " on the server")
			end
		else
			TriggerClientEvent('chatMessage', source, msgSrc .. msgSep, msgCol, "You are not superadmin!")
		end
	end
end)
