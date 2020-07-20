-- manages items, duh
-- author: Polymorphic

local module = {}


local httpService = game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local modules = require(replicatedStorage.modules)
local network = modules.load("network")
local utilities = modules.load("utilities")

local MAX_PARTY_MEMBERS = 6

--[[

	partyMemberData {}
		bool isLeader
		bool isPowerUser

		player player

	partyData {}
		{partyMemberData} members

	partyDataContainer {partyData}
--]]

local partyDataContainer 	= {}
local pendingPartyInvites 	= {}

local function getPartyDataByPlayer(player)
	for _, partyData in pairs(partyDataContainer) do
		for _, partyMemberData in pairs(partyData.members) do
			if partyMemberData.player == player then
				return partyData, partyMemberData
			end
		end
	end

	return nil, nil
end

local function playerRequest_getMyPartyData(player)
	return getPartyDataByPlayer(player)
end

local function getPartyMembersInMyParty(player)
	local partyData = getPartyDataByPlayer(player)

	if partyData then
		return partyData.members
	end

	return nil
end

local function propogatePartyDataChangedToPartyMembers(partyData)

	-- let players know if a new party is created
	if partyData.isNew then
		if partyData.removeIsNewNextPropogate then
			partyData.isNew = false
			partyData.removeIsNewNextPropogate = false
		else
			partyData.removeIsNewNextPropogate = true
		end
	end

	for i, partyPlayerData in pairs(partyData.members) do
		network:fireClient("signal_myPartyDataChanged", partyPlayerData.player, partyData)
	end
end

-- makes `playerInvited` join the party of `playerInviting`
local invitationCD = {}
local function invitePlayerToMyParty(playerInviting, playerInvited)
	local partyData_playerInviting, partyMemberData_playerInviting 	= getPartyDataByPlayer(playerInviting)
	local partyData_playerInvited, 	________________________ 		= getPartyDataByPlayer(playerInvited)

	if playerInviting ~= playerInvited and not partyData_playerInvited then
		if not invitationCD[playerInviting] or (tick() - invitationCD[playerInviting] > 3) then
			invitationCD[playerInviting] = tick()

			local guid 					= httpService:GenerateGUID(false)
			pendingPartyInvites[guid] 	= {
				partyData 		= partyData_playerInviting;
				playerInviting 	= playerInviting;
				player 			= playerInvited;
			}

			network:fireClient("signal_playerInvitedToParty", playerInvited, playerInviting, guid)

			return true, "Invitation sent."
		else
			return false, "Sending invites too fast!"
		end
	end

	return false, "Invalid player."
end

local function isPartyDataValid(partyData)
	for _, _partyData in pairs(partyDataContainer) do
		if partyData == _partyData then
			return true
		end
	end

	return false
end

local function playerRequest_acceptMyPartyInvitation(player, guid)
	local partyData = getPartyDataByPlayer(player)

	if not partyData then
		local partyInvitationData = pendingPartyInvites[guid]

		if partyInvitationData and partyInvitationData.player == player then
			if isPartyDataValid(partyInvitationData.partyData) or partyInvitationData.partyData == nil then

				-- do this instead of reading the party data of the invitation because they mightve invited multiple
				-- people and then had the party made.
				local invitingPlayerPartyData = getPartyDataByPlayer(partyInvitationData.playerInviting)

				if partyInvitationData.playerInviting and partyInvitationData.playerInviting.Parent then
					if invitingPlayerPartyData then
						pendingPartyInvites[guid] = nil

						if #invitingPlayerPartyData.members < MAX_PARTY_MEMBERS then
							-- invalidate the guid

							local partyMemberData = {}
								partyMemberData.isLeader 	= false
								partyMemberData.isPowerUser = false
								partyMemberData.player 		= player

							table.insert(invitingPlayerPartyData.members, partyMemberData)

							invitingPlayerPartyData.newestMember = partyMemberData

							local invitingPlayer = partyInvitationData.playerInviting


							invitingPlayerPartyData.status = {text = player.Name .. " joined the party. (Invited by " .. invitingPlayer.Name .. ")" }


							-- update players
							propogatePartyDataChangedToPartyMembers(invitingPlayerPartyData)

							return true, "Joined party"
						else
							return false, "Party is full"
						end
					else
						local partyData = {}
							partyData.guid 		= httpService:GenerateGUID(false)
							partyData.members 	= {}

						local partyMemberData_player = {}
							partyMemberData_player.isLeader 	= false
							partyMemberData_player.isPowerUser 	= false
							partyMemberData_player.player 		= player

						table.insert(partyData.members, partyMemberData_player)

						partyData.newestMember = partyMemberData_player

						local partyMemberData_playerInviting = {}
							partyMemberData_playerInviting.isLeader 	= true
							partyMemberData_playerInviting.isPowerUser 	= true
							partyMemberData_playerInviting.player 		= partyInvitationData.playerInviting

						table.insert(partyData.members, partyMemberData_playerInviting)
						table.insert(partyDataContainer, partyData)


						partyData.isNew = true
						partyData.status = {text = player.Name .. " joined the party. (Invited by " .. partyInvitationData.playerInviting.Name .. ")" }
						-- update players
						propogatePartyDataChangedToPartyMembers(partyData)

						return true, "Joined party"
					end
				else
					return false, "Invalid leader."
				end
			end
		end
	end

	return nil, "eof"
end

local function int__checkIfCleanUpPartyData(givenPartyData)
	for i, partyData in pairs(partyDataContainer) do
		if partyData == givenPartyData then
			if #partyData.members <= 1 then
				if #partyData.members == 1 then
					network:fireClient("signal_myPartyDataChanged", partyData.members[1].player, nil)

					partyData.members[1].player = nil
					partyData.members[1] 		= nil
					partyData.members 			= {}
				end

				table.remove(partyDataContainer, i)
			end
		end
	end
end

local function playerRequest_leaveParty(player, playerToKickOut)
	local partyData_player, partyMemberData_player = getPartyDataByPlayer(player)


	if partyData_player then
		if playerToKickOut and partyMemberData_player and partyMemberData_player.isPowerUser then
			local partyData_playerToKickOut, partyMemberData_playerToKickOut = getPartyDataByPlayer(playerToKickOut)

			if partyData_playerToKickOut == partyData_player and not partyMemberData_playerToKickOut.isLeader then
				for i, partyMemberData in pairs(partyData_player.members) do
					if partyMemberData.player == playerToKickOut then
						table.remove(partyData_player.members, i)

						-- reset newest member
						partyData_player.newestMember = nil

						if player == playerToKickOut then
							partyData_player.status = {text = player.Name .. " left the party." }
						else
							partyData_player.status = {text = playerToKickOut.Name .. " was kicked from the party." }
						end


						-- update players
						propogatePartyDataChangedToPartyMembers(partyData_player)
						network:fireClient("signal_myPartyDataChanged", playerToKickOut, nil)

						int__checkIfCleanUpPartyData(partyData_player)

						return true
					end
				end
			end
		elseif not playerToKickOut then
			for i, partyMemberData in pairs(partyData_player.members) do
				if partyMemberData.player == player then
					table.remove(partyData_player.members, i)

					-- reset newest member
					partyData_player.newestMember = nil

					partyData_player.status = {text = player.Name .. " left the party." }

					-- update players
					propogatePartyDataChangedToPartyMembers(partyData_player)
					network:fireClient("signal_myPartyDataChanged", player, nil)

					int__checkIfCleanUpPartyData(partyData_player)

					return true
				end
			end
		else
		end
	end


	return false
end

local function playerRequest_startGroupTeleport(player, teleportPart)
	local partyData_player, partyMemberData_player = getPartyDataByPlayer(player)

	if partyData_player and partyMemberData_player.isLeader and teleportPart and teleportPart:FindFirstChild("teleportDestination") then
		if partyData_player.teleportState == "none" or partyData_player.teleportState == nil then

			partyData_player.teleportState 			= "pending"
			partyData_player.teleportDestination 	= teleportPart.teleportDestination.Value
			partyData_player.status 				= nil
			partyData_player.teleportPosition		= teleportPart.Position
			partyData_player.teleportPart			= teleportPart

			propogatePartyDataChangedToPartyMembers(partyData_player)

			spawn(function()
				while partyData_player.teleportState == "pending" and player.Parent do
					local canTeleport = true
					for i, partyMemberData in pairs(partyData_player.members) do
						if not partyMemberData.player.Character or not partyMemberData.player.Character.PrimaryPart or utilities.magnitude(partyMemberData.player.Character.PrimaryPart.Position - teleportPart.Position) > 20 then
							canTeleport = false
						end
					end

					if canTeleport then
						partyData_player.teleportState = "teleporting"
						break
					else
						wait(1 / 2)
					end
				end

				if partyData_player.teleportState == "teleporting" then

					propogatePartyDataChangedToPartyMembers(partyData_player)

					local startTime 				= tick()
					local isWaitingForTeleportReady = true

					while tick() - startTime < 15 and isWaitingForTeleportReady do
						isWaitingForTeleportReady = false
						for i, partyMemberData in pairs(partyData_player.members) do
							if not partyMemberData.isReadyToTeleport then
								isWaitingForTeleportReady = true
							end
						end

						if isWaitingForTeleportReady then
							wait(1 / 4)
						end
					end

					local playersToTeleport = {}
					local partyLeaderUserId = 0
					for i, partyMemberData in pairs(partyData_player.members) do
						if partyMemberData.isReadyToTeleport then
							table.insert(playersToTeleport, partyMemberData.player)

							if partyMemberData.isLeader then
								partyLeaderUserId = partyMemberData.player.userId
							end
						end
					end

					-- drop the teleport if anyone in the party is experiencing a DataStore outage
					local teleportFail = false
					local failedPlayers = {}
					for i,player in pairs(playersToTeleport) do
						if player:FindFirstChild("DataSaveFailed") then
							teleportFail = true
							table.insert(failedPlayers, player)
						end
					end

					if teleportFail then
						local errorMsg = "Teleport failed: "
						for i,player in pairs(failedPlayers) do
							errorMsg = errorMsg .. player.Name .. (failedPlayers[i+1] and ", " or "")
						end
						errorMsg = errorMsg .. " " .. (#failedPlayers == 1 and "is" or "are") ..  " experiencing a DataStore outage."

						partyData_player.status = {text = errorMsg; textColor3 = Color3.fromRGB(255, 57, 60)}
						partyData_player.teleportState = "none"
						propogatePartyDataChangedToPartyMembers(partyData_player)
						return false, "Datastore outage."
					end

					if #playersToTeleport > 0 and partyLeaderUserId then
--						teleportService:TeleportPartyAsync(teleportPart.teleportDestination.Value, playersToTeleport)
						local success, message = network:invoke("teleportParty", playersToTeleport, teleportPart.teleportDestination.Value, partyLeaderUserId)
						return success, message
					else
						warn("manager_party::no leader or no one ready")
					end
				end
			end)

			return true
		end
	end

	return false
end

local function getPartyDataByGUID(guid)
	for _, partyData in pairs(partyDataContainer) do
		if partyData.guid == guid then
			return partyData
		end
	end

	return nil
end

local function getPartyLeaderForPartyData(partyData)
	for _, partyMemberData in pairs(partyData.members) do
		if partyMemberData.isLeader then
			return partyMemberData
		end
	end

	return nil
end

-- todo: only accept from JoinData.members
local function playerRequest_acceptMyPartyInvitationByTeleportation(player, guid, partyLeaderUserId)
	if not guid or not partyLeaderUserId then return end

	local partyData_guid = getPartyDataByGUID(guid)

	if not partyData_guid then
		local joinData = player:GetJoinData()
		local partyData = {}
			partyData.guid 				= guid
			partyData.isTeleportParty 	= true
			partyData.partyLeaderUserId = partyLeaderUserId
			partyData.members 			= {}

		local partyMemberData = {}
			partyMemberData.isLeader 	= player.userId == partyLeaderUserId
			partyMemberData.isPowerUser = true
			partyMemberData.player 		= player

		table.insert(partyData.members, partyMemberData)
		table.insert(partyDataContainer, partyData)

		propogatePartyDataChangedToPartyMembers(partyData)
	elseif partyData_guid and partyData_guid.isTeleportParty then
		local partyMemberData = {}
			partyMemberData.isLeader 	= partyData_guid.partyLeaderUserId == player.userId
			partyMemberData.isPowerUser = true
			partyMemberData.player 		= player

		table.insert(partyData_guid.members, partyMemberData)

		propogatePartyDataChangedToPartyMembers(partyData_guid)
	end
end


network:create("resumePartyAfterTeleport", "BindableFunction", "OnInvoke", playerRequest_acceptMyPartyInvitationByTeleportation)
network:create("playerRequest_acceptMyPartyInvitationByTeleportation", "RemoteFunction", "OnServerInvoke", function() warn("playerRequest_acceptMyPartyInvitationByTeleportation has been moved to the server.") end)

local function playerRequest_cancelGroupTeleport(player)
	local partyData_player, partyMemberData_player = getPartyDataByPlayer(player)

	if partyData_player and partyData_player.teleportState == "pending" then
		partyData_player.teleportState = "none"
		propogatePartyDataChangedToPartyMembers(partyData_player)
	end
end

local function signal_playerReadyToGroupTeleport(player)
	local partyData_player, partyMemberData_player = getPartyDataByPlayer(player)

	if partyData_player and partyMemberData_player then
		partyMemberData_player.isReadyToTeleport = true
	end
end

local function onPlayerAdded(player)
	local joinData = player:GetJoinData()
end

local function onPlayerRemoving(player)
	invitationCD[player] = nil

	if player:FindFirstChild("teleporting") == nil then
		local partyData_player, partyMemberData_player = getPartyDataByPlayer(player)

		if partyData_player then
			for i, partyMemberData in pairs(partyData_player.members) do
				if partyMemberData.player == player then
					table.remove(partyData_player.members, i)

					-- reassign leader if leaver was leader
					if partyMemberData.isLeader then
						if partyData_player.members[1] then
							partyData_player.members[1].isLeader = true
						end
					end

					-- reset newest member
					partyData_player.newestMember = nil

					partyData_player.status = {text = player.Name .. " left the party." }
					-- update players
					propogatePartyDataChangedToPartyMembers(partyData_player)

					int__checkIfCleanUpPartyData(partyData_player)

					return true
				end
			end
		end
	end
end

local function main()
	game.Players.PlayerAdded:connect(onPlayerAdded)
	for i,player in pairs(game.Players:GetPlayers()) do
		onPlayerAdded(player)
	end
	game.Players.PlayerRemoving:connect(onPlayerRemoving)

	network:create("playerRequest_getPartyMembersInMyParty", "RemoteFunction", "OnServerInvoke", getPartyMembersInMyParty)
	network:create("playerRequest_getMyPartyData", "RemoteFunction", "OnServerInvoke", playerRequest_getMyPartyData)
	network:create("playerRequest_invitePlayerToMyParty", "RemoteFunction", "OnServerInvoke", invitePlayerToMyParty)

	network:create("playerRequest_acceptMyPartyInvitation", "RemoteFunction", "OnServerInvoke", playerRequest_acceptMyPartyInvitation)
	network:create("playerRequest_leaveParty", "RemoteFunction", "OnServerInvoke", playerRequest_leaveParty)

	network:create("playerRequest_startGroupTeleport", "RemoteFunction", "OnServerInvoke", playerRequest_startGroupTeleport)
	network:create("playerRequest_cancelGroupTeleport", "RemoteFunction", "OnServerInvoke", playerRequest_cancelGroupTeleport)
	network:create("signal_playerReadyToGroupTeleport", "RemoteEvent", "OnServerEvent", signal_playerReadyToGroupTeleport)

	network:create("getPartyDataByPlayer", "BindableFunction", "OnInvoke", getPartyDataByPlayer)

	network:create("signal_playerInvitedToParty", "RemoteEvent")
	network:create("signal_myPartyDataChanged", "RemoteEvent")
end

main()

return module