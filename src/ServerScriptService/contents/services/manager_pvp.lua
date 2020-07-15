local module = {}

-- from Player Manager, needs to be set up

local function int__tickForPVP()
	if #pvpZoneCollectionFolder:GetChildren() == 0 and not replicatedStorage:FindFirstChild("isPVPGloballyEnabled") then return end
	
	while not shuttingDown do
		for player, playerData in pairs(playerDataContainer) do
			local currentPVPValue = playerData.nonSerializeData.isGlobalPVPEnabled
			
			if replicatedStorage:FindFirstChild("isPVPGloballyEnabled") and replicatedStorage.isPVPGloballyEnabled.Value then
				if currentPVPValue == false then
					playerData.nonSerializeData.isGlobalPVPEnabled = true
					playerData.nonSerializeData.playerDataChanged:Fire("nonSerializeData")
					network:fireClient("alertPlayerNotification", player, 
						{text = "Entered global pvp map."; id = "pvp"},
						nil,
						"pvp"
					)	
				end
			else
				local isInPVPZone = false
				local isPVPZoneUnsafe = false
				
				for i, pvpZone in pairs(pvpZoneCollectionFolder:GetChildren()) do
					if isPlayerInPVPZone(pvpZone, player) then
						isInPVPZone = true
						
						if pvpZone.Name == "unsafe" then
							isPVPZoneUnsafe = true
						end
						
						break
					end
				end
				
				if currentPVPValue ~= isInPVPZone then
					playerData.nonSerializeData.isGlobalPVPEnabled 	= isInPVPZone
					playerData.nonSerializeData.isPVPZoneUnsafe 	= isPVPZoneUnsafe
					playerData.nonSerializeData.playerDataChanged:Fire("nonSerializeData")
					if isInPVPZone then
						if isPVPZoneUnsafe then
							network:fireClient("alertPlayerNotification", player, 
							{text = "Entered unsafe global PVP zone."; id="pvp"},nil,"pvp")	
						else
							network:fireClient("alertPlayerNotification", player, 
							{text = "Entered safe global PVP zone."; id="pvp"},nil,"pvp")	
						end					
					end
				end
			end
		end
		
		wait(1 / 3)
	end
end

local function isPlayerPVPWhitelisted(player, playerToCheck)
	local playerData = playerDataContainer[player]
	
	if playerData then
		for i, whitelistPlayer in pairs(playerData.nonSerializeData.whitelistPVPEnabled) do
			if whitelistPlayer == playerToCheck then
				return true, i
			end
		end
	end
end

local function requestPVPWhitelistPlayer_server(player, playerToWhitelist)
	local playerData = playerDataContainer[player]
	
	if playerData then
		local isPVPWhitelisted, index = isPlayerPVPWhitelisted(player, playerToWhitelist)
		if not isPVPWhitelisted then
			table.insert(playerData.nonSerializeData.whitelistPVPEnabled, playerToWhitelist)
			
			playerData.nonSerializeData.playerDataChanged:Fire("nonSerializeData")
		end
	end
end

local function revokePVPWhitelistPlayer_server(player, playerToRevokeWhitelist)
	local playerData = playerDataContainer[player]
	
	if playerData then
		local isPVPWhitelisted, index = isPlayerPVPWhitelisted(player, playerToRevokeWhitelist)
		if isPVPWhitelisted then
			table.remove(playerData.nonSerializeData.whitelistPVPEnabled, index)
			
			playerData.nonSerializeData.playerDataChanged:Fire("nonSerializeData")
		end
	end
end

network:create("requestPVPWhitelistPlayer_server", "BindableFunction", "OnInvoke", requestPVPWhitelistPlayer_server)
network:create("revokePVPWhitelistPlayer_server", "BindableFunction", "OnInvoke", revokePVPWhitelistPlayer_server)

return module