local module = {}
module.priority = 3

local TeleportService = game:GetService("TeleportService")

local network
local utilities
local configuration

local function preparePlayerToTeleport(player, destination)
	if player:FindFirstChild("DataSaveFailed") then
		network:fireClient("alertPlayerNotification", player, {
			text = "Cannot teleport during a DataStore outage.";
			textColor3 = Color3.fromRGB(255, 57, 60)
		})
		return false
	end
	if player:FindFirstChild("Teleporting") or player:FindFirstChild("teleporting") then
		return false
	end
	if player:FindFirstChild("DataLoaded") == nil then
		return false
	end
	destination = utilities.placeIdForGame(destination)
	local timestamp = network:invoke("saveDataForTeleport", player)
	if timestamp then
		local teleportData = {}
		teleportData.arrivingFrom = game.PlaceId
		teleportData.destination = destination
		teleportData.dataTimestamp = timestamp
		teleportData.dataSlot = player.dataSlot.Value
		teleportData.analyticsSessionId = player.AnalyticsSessionId.Value
		teleportData.joinTime = player.JoinTime.Value
		teleportData.partyData = network:invoke("getPartyDataByPlayer", player)
		return teleportData
	else
		network:fireClient("alertPlayerNotification", player, {
            text = "Failed to save your data. Teleportation canceled.";
            textColor3 = Color3.fromRGB(255, 57, 60)
        })
		return false
	end
end

local function createPartyTeleportData(playersToTeleport, destination, partyLeaderUserId, spawnLocation)

	for _, player in pairs(playersToTeleport) do
		network:fireClient("alertPlayerNotification", player, {text = "Preparing to teleport party...";})
	end
	local groupTeleportData = {}
	groupTeleportData.members = {}

	for _, player in pairs(playersToTeleport) do
		if player:FindFirstChild("teleporting") then
			network:fireClient("alertPlayerNotification", player, {
                text = "Party teleport failed: "..player.Name.." is already teleporting.";
                textColor3 = Color3.fromRGB(255, 57, 60)
            })
			return false
		end
	end

	local playersSuccessfullySaved = {}
	for _, player in pairs(playersToTeleport) do
		local playerTeleportData = preparePlayerToTeleport(player, destination)
		warn(player.Name, "teleport data", game.HttpService:JSONEncode(playerTeleportData))
		if playerTeleportData and playerTeleportData.partyData then
			playerTeleportData.partyData.partyLeaderUserId = partyLeaderUserId
			if spawnLocation then
				playerTeleportData.spawnLocation = spawnLocation
			end

			table.insert(playersSuccessfullySaved, player)
			groupTeleportData.members[player.Name] = playerTeleportData
		else
			for _, oPlayer in pairs(playersToTeleport) do
				network:fireClient("alertPlayerNotification", oPlayer, {
                    text = player.Name.." failed to teleport with the party.";
                    textColor3 = Color3.fromRGB(234, 129, 59)
                })
			end
		end
	end

	if #playersSuccessfullySaved > 0 then
		warn("group data", game.HttpService:JSONEncode(groupTeleportData))

		return playersSuccessfullySaved, groupTeleportData
	else

		return false
	end
end

local function getReserveServerKeyForMirrorDestination(destination)
	destination = utilities.placeIdForGame(destination)
	local reserveServerKey
	local success, err = pcall(function()
		local mwv = configuration.getConfigurationValue("mirrorWorldVersion")
		local mirrorWorldStore = game:GetService("DataStoreService"):GetDataStore("mirrorWorld"..mwv)
		reserveServerKey = mirrorWorldStore:GetAsync(tostring(destination))
		if reserveServerKey == nil then
			reserveServerKey = TeleportService:ReserveServer(destination)
			mirrorWorldStore:SetAsync(tostring(destination), reserveServerKey)
		end
	end)
	return reserveServerKey, success, err
end

local function teleportPlayersToReserveServer(players, destination, spawnLocation, realm, teleportType, reserveServerKey)
	destination = utilities.placeIdForGame(destination)
	teleportType = teleportType or "default"

	reserveServerKey = reserveServerKey or TeleportService:ReserveServer(destination)

	for _, player in pairs(players) do
		spawn(function()
			if player:FindFirstChild("teleporting") then
				return false
			end

			if player:FindFirstChild("dataLoaded") == nil or os.time() - player.dataLoaded.Value <= 5 then
				return false, "Please wait before teleporting"
			end

			network:fireClient("signal_teleport", player, destination)

			local teleportData = preparePlayerToTeleport(player, destination)

			if teleportData then
				if spawnLocation then
					teleportData.spawnLocation = spawnLocation
				end
				teleportData.teleportType = teleportType

				if game.ReplicatedStorage:FindFirstChild("mirrorWorld") or realm == "mirror" then
					local reserveServerKey = getReserveServerKeyForMirrorDestination(destination)
					if reserveServerKey then
						TeleportService:TeleportToPrivateServer(destination, reserveServerKey, {player}, nil, teleportData)
					else
						return false, "Failed to find mirror world reserve server key"
					end
				else
					TeleportService:TeleportToPrivateServer(destination, reserveServerKey, {player}, nil, teleportData)
				end
			end

			return false, "Failed to prepare teleportData"
		end)
	end
end

local function teleportParty(playersToTeleport, destination, partyLeaderUserId, spawnLocation)
	destination = utilities.placeIdForGame(destination)
	local playersSuccessfullySaved, groupTeleportData = createPartyTeleportData(playersToTeleport, destination, partyLeaderUserId, spawnLocation)
	if playersSuccessfullySaved and groupTeleportData then

		local playerstring = ""
		local n = #playersToTeleport
		for i,player in pairs(playersToTeleport) do
			playerstring = playerstring .. player.Name
			if n > 1 and i == n-1 then
				playerstring = playerstring .. " & "
			elseif i < n then
				playerstring = playerstring .. ","
			end
		end

		if game.ReplicatedStorage:FindFirstChild("mirrorWorld") then
			local reserveServerKey = getReserveServerKeyForMirrorDestination(destination)
			if reserveServerKey then
				TeleportService:TeleportToPrivateServer(destination, reserveServerKey, playersSuccessfullySaved, nil, groupTeleportData)
			else
				return false, "Failed to find key for mirror world teleport"
			end
		else
			TeleportService:TeleportPartyAsync(destination, playersSuccessfullySaved, groupTeleportData --[[, replicatedStorage.teleportUI]])
		end

		spawn(function()

			network:fireAllClients("signal_alertChatMessage", {
				Text = playerstring .. " departed towards " .. utilities.getPlaceName(destination) .. ".";
				Font = Enum.Font.SourceSansBold;
				Color = Color3.fromRGB(45, 87, 255)
			})

		end)
		return true, "Teleporting"
	end
	return false, "Failed to teleport"
end

local function teleportPlayerToJobId(player, destination, jobId, spawnLocation)
	destination = utilities.placeIdForGame(destination)
	local teleportType = "serverBrowser"
	if player:FindFirstChild("teleporting") then
		return false
	end

	if player:FindFirstChild("dataLoaded") == nil or os.time() - player.dataLoaded.Value <= 5 then
		return false, "Please wait before teleporting"
	end

	network:fireClient("signal_teleport", player, destination)

	local teleportData = preparePlayerToTeleport(player, destination)

	if teleportData then
		if spawnLocation then
			teleportData.spawnLocation = spawnLocation
		end
		teleportData.teleportType = teleportType


		spawn(function()
			TeleportService:TeleportToPlaceInstance(destination, jobId, player, nil, teleportData)
		end)
		return true, "teleporting"

	end

	return false, "failed to prepare teleportdata"
end

local function teleportPlayer(player, destination, spawnLocation, realm, teleportType)
	destination = utilities.placeIdForGame(destination)

	local playerName = player.Name
	teleportType = teleportType or "default"

	if player:FindFirstChild("teleporting") then
		return false
	end

	if player:FindFirstChild("dataLoaded") == nil or os.time() - player.dataLoaded.Value <= 5 then
		return false, "Please wait before teleporting"
	end

	network:fireClient("signal_teleport", player, destination, teleportType)

	local teleportData = preparePlayerToTeleport(player, destination)

	if teleportData then
		if spawnLocation then
			teleportData.spawnLocation = spawnLocation
		end
		teleportData.teleportType = teleportType

		if game.ReplicatedStorage:FindFirstChild("mirrorWorld") or realm == "mirror" then
			local reserveServerKey = getReserveServerKeyForMirrorDestination(destination)
			if reserveServerKey then
				TeleportService:TeleportToPrivateServer(destination, reserveServerKey, {player}, nil, teleportData)
				return true, "teleporting"
			else
				return false, "Failed to find key for mirror world teleport"
			end
		else
			spawn(function()
				TeleportService:Teleport(destination, player, teleportData)
			end)
			if teleportType == "death" and not player:FindFirstChild("disconnected") then
				network:fireAllClients("signal_alertChatMessage", {
					Text = playerName .. " escaped to " .. utilities.getPlaceName(destination) .. ".";
					Font = Enum.Font.SourceSansBold;
					Color = Color3.fromRGB(45, 87, 255)
				})
			end
			return true, "teleporting"
		end


	end

	return false, "failed to prepare teleportdata"
end

local function teleportPlayer_rune(player, destination)
	destination = utilities.placeIdForGame(destination)
	local playerName = player.Name
	local success, reason = teleportPlayer(player, destination, nil, nil, "rune")
	if success then
		spawn(function()

			network:fireAllClients("signal_alertChatMessage", {
				Text = playerName .. " departed towards " .. utilities.getPlaceName(destination) .. " using a magical rune.";
				Font = Enum.Font.SourceSansBold;
				Color = Color3.fromRGB(45, 87, 255)
			})

		end)
	end
	return success, reason

end

local function playerRequest_useTeleporter(player, teleporter)
	if teleporter and teleporter:IsA("BasePart") and game.CollectionService:HasTag(teleporter, "teleportPart") and teleporter:FindFirstChild("teleportDestination") then
		if player.Character and player.Character.PrimaryPart and player:DistanceFromCharacter(teleporter.Position) <= 50 then
			local playerName = player.Name
			local success, reason = teleportPlayer(player, teleporter.teleportDestination.Value)
			if success then
				spawn(function()

					network:fireAllClients("signal_alertChatMessage", {
						Text = playerName .. " departed towards " .. utilities.getPlaceName(teleporter.teleportDestination.Value) .. ".";
						Font = Enum.Font.SourceSansBold;
						Color = Color3.fromRGB(45, 87, 255)
					})

				end)
			end
			return success, reason
		end
	end
	return false
end

function module.init(Modules)

	network = Modules.network
	utilities = Modules.utilities
	configuration = Modules.configuration

	network:create("getPlayerTeleportData", "BindableFunction", "OnInvoke", preparePlayerToTeleport)
	network:create("teleportPlayersToReserveServer", "BindableFunction", "OnInvoke", teleportPlayersToReserveServer)
	network:create("createPartyTeleportData", "BindableFunction", "OnInvoke", createPartyTeleportData)
	network:create("teleportParty", "BindableFunction", "OnInvoke", teleportParty)
	network:create("teleportPlayerToJobId", "BindableFunction", "OnInvoke", teleportPlayerToJobId)
	network:create("teleportPlayer", "BindableFunction", "OnInvoke", teleportPlayer)
	network:create("teleportPlayer_rune", "BindableFunction", "OnInvoke", teleportPlayer_rune)
	network:create("playerRequest_useTeleporter", "RemoteFunction", "OnServerInvoke", playerRequest_useTeleporter)
	network:create("signal_teleport", "RemoteEvent")
end


return module