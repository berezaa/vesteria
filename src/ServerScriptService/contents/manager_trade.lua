-- manages trades
-- author: Polymorphic

local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local network
local configuration

local itemLookup = require(ReplicatedStorage.itemData)

--[[
	playerTradeSessionData {}
		instance player
		string state

		int gold
		{inventoryTransferData} inventoryTransferDataCollection

	tradeSessionData {}
		string guid
		string state

		playerTradeSessionData playerTradeSessionData_player1
		playerTradeSessionData playerTradeSessionData_player2
--]]

-- contains tradeSessionData
local tradeSessionDataCollection = {}
local pendingTrade_guids = {}

-- if IFFIsActiveTrade is set, the trade must be ongoing to return the sessionData
local function getTradeSessionDataByPlayer(player)
	for i, tradeSessionData in pairs(tradeSessionDataCollection) do
		if tradeSessionData.playerTradeSessionData_player1.player == player or tradeSessionData.playerTradeSessionData_player2.player == player then
			return tradeSessionData
		end
	end

	return nil
end

local function propogateTradeDataUpdate(tradeSessionData)
	network:fireClient("signal_tradeSessionChanged", tradeSessionData.playerTradeSessionData_player1.player, tradeSessionData)
	network:fireClient("signal_tradeSessionChanged", tradeSessionData.playerTradeSessionData_player2.player, tradeSessionData)
end

local function invalidatePendingTradesForPlayer(player)
	for i, v in pairs(pendingTrade_guids) do
		if v.playerToTradeWith == player or v.tradeRequester == player then
			pendingTrade_guids[i] = nil
		end
	end
end

local invitationCD = {}
local function playerRequest_requestTrade(tradeRequester, playerToTradeWith)
	if not configuration.getConfigurationValue("isTradingEnabled", tradeRequester) or not configuration.getConfigurationValue("isTradingEnabled", playerToTradeWith) then
		return false, "Trading is disabled right now."
	end

	if tradeRequester:FindFirstChild("DataSaveFailed") then
		network:fireClient("alertPlayerNotification", tradeRequester, {text = "Cannot trade during DataStore outage."; textColor3 = Color3.fromRGB(255, 57, 60)})
		return false, "This feature is temporarily disabled"
	end

	if tradeRequester and playerToTradeWith and tradeRequester ~= playerToTradeWith then
		if not getTradeSessionDataByPlayer(tradeRequester) and not getTradeSessionDataByPlayer(playerToTradeWith) then
			if not invitationCD[tradeRequester] or (tick() - invitationCD[tradeRequester] > 3) then
				invitationCD[tradeRequester] = tick()

				local guid = HttpService:GenerateGUID(false)

				pendingTrade_guids[guid] = {
					tradeRequester 		= tradeRequester;
					playerToTradeWith 	= playerToTradeWith;
				}

				network:fireClient("signal_playerTradeRequest", playerToTradeWith, tradeRequester, guid)

				return true
			else
				return false, "stop sending trades so fast."
			end
		end
	elseif tradeRequester == playerToTradeWith then
		return false, "you can't trade with yourself, idiot."
	end

	return false, "player is already trading"
end
-- playerInventoryChanged_server
local function isPlayerInventoryTransferDataValid(player, inventoryTransferDataCollection)
	local playerData = network:invoke("getPlayerData", player)

	local count = 0 do
		for i, inventoryTransferData in pairs(inventoryTransferDataCollection) do
			local itemBaseData = itemLookup[inventoryTransferData.id]
			if itemBaseData.soulbound then
				return false
			end

			if not inventoryTransferData.stacks then
				inventoryTransferData.stacks = 1
			end

			if inventoryTransferData.stacks <= 0 then
				return false
			elseif math.floor(inventoryTransferData.stacks) ~= inventoryTransferData.stacks then
				return false
			end

			count = count + 1
		end
	end

	if playerData then
		local matches = 0
		local trueInventoryTransferDataCollection = {}

		for i, inventorySlotData in pairs(playerData.inventory) do
			for ii, inventoryTransferData in pairs(inventoryTransferDataCollection) do
				if inventorySlotData.position == inventoryTransferData.position and inventorySlotData.id == inventoryTransferData.id and (inventoryTransferData.stacks or 1) <= (inventorySlotData.stacks or 1) then
					if inventorySlotData.soulbound then
						return false
					end

					trueInventoryTransferDataCollection[ii] = inventorySlotData

					matches = matches + 1

					break
				end
			end
		end

		return matches == count, trueInventoryTransferDataCollection
	end
end

local function getTradeSessionDataById(tradeSessionId)
	for i, tradeSessionData in pairs(tradeSessionDataCollection) do
		if tradeSessionData.id == tradeSessionId then
			return tradeSessionData
		end
	end

	return nil
end

local function playerRequest_cancelTrade(player)
	local tradeSessionData = getTradeSessionDataByPlayer(player)

	if tradeSessionData then
		tradeSessionData.state = "canceled"

		tradeSessionData.playerTradeSessionData_player1.state = "denied"
		tradeSessionData.playerTradeSessionData_player2.state = "denied"
		propogateTradeDataUpdate(tradeSessionData)

		for i, _tradeSessionData in pairs(tradeSessionDataCollection) do
			if _tradeSessionData == tradeSessionData then
				table.remove(tradeSessionDataCollection, i)

				break
			end
		end
	end
end

local processTicketDuplicationValidationQueue = {}
local function playerRequest_updatePlayerTradeSessionData(player, guid, key, value)
	local tradeSessionData = getTradeSessionDataByPlayer(player)
	if not tradeSessionData then return false, "no tradeSessionData found for player" end
	if tradeSessionData.guid ~= guid then return false, "invalid guid for tradeSessionData" end

	local p1 = tradeSessionData.playerTradeSessionData_player1.player
	local p2 = tradeSessionData.playerTradeSessionData_player2.player

	-- stop teleporting while trading
	if p1.Parent == nil or p1:FindFirstChild("teleporting") or p1:FindFirstChild("DataLoaded") == nil then
		return false, "invalid players"
	end

	-- stop teleporting while trading
	if p2.Parent == nil or p2:FindFirstChild("teleporting") or p2:FindFirstChild("DataLoaded") == nil then
		return false, "invalid players"
	end

	local playerData = network:invoke("getPlayerData", player)

	if playerData and tradeSessionData and tradeSessionData.state ~= "completed" and tradeSessionData.state ~= "canceled" then
		local playerTradeSessionData_player = (tradeSessionData.playerTradeSessionData_player1.player == player and tradeSessionData.playerTradeSessionData_player1) or (tradeSessionData.playerTradeSessionData_player2.player == player and tradeSessionData.playerTradeSessionData_player2)
		if key == "state" and (value == "approved" or value == "denied" or value == "none") then

			if value ~= playerTradeSessionData_player.state then
				playerTradeSessionData_player.state = value

				-- prevent players from spamming approve!
				local processTicket 							= HttpService:GenerateGUID(false)
				processTicketDuplicationValidationQueue[guid] 	= processTicket

				if key == "state" and value == "denied" and tradeSessionData.state == "countdown" then
					tradeSessionData.state = "active"
					propogateTradeDataUpdate(tradeSessionData)
					return true
				end

				if tradeSessionData.state ~= "countdown" and tradeSessionData.playerTradeSessionData_player1.state == "approved" and tradeSessionData.playerTradeSessionData_player2.state == "approved" then
					tradeSessionData.state = "countdown"

					propogateTradeDataUpdate(tradeSessionData)

					local startTime = tick()

					while (tick() - startTime) < 6 and (tradeSessionData.playerTradeSessionData_player1.state == "approved" and tradeSessionData.playerTradeSessionData_player2.state == "approved") do
						wait(1 / 4)
					end

					-- stop teleporting while trading
					if p1.Parent ~= game.Players or p1:FindFirstChild("teleporting") or p1:FindFirstChild("DataLoaded") == nil or not network:invoke("getPlayerData", p1) then
						return false, "invalid players call 2"
					end

					-- stop teleporting while trading
					if p2.Parent ~= game.Players or p2:FindFirstChild("teleporting") or p2:FindFirstChild("DataLoaded") == nil or not network:invoke("getPlayerData", p2) then
						return false, "invalid players call 2"
					end

					if not isPlayerInventoryTransferDataValid(p1, tradeSessionData.playerTradeSessionData_player1.inventoryTransferDataCollection) then
						return false, tostring(p1) .. " has invalid trade data"
					end

					if not isPlayerInventoryTransferDataValid(p2, tradeSessionData.playerTradeSessionData_player2.inventoryTransferDataCollection) then
						return false, tostring(p2) .. " has invalid trade data"
					end

					if processTicketDuplicationValidationQueue[guid] == processTicket and (tradeSessionData.playerTradeSessionData_player1.state == "approved" and tradeSessionData.playerTradeSessionData_player2.state == "approved") then
						local success, errMsg = network:invoke("requestTradeBetweenPlayers", tradeSessionData.playerTradeSessionData_player1.player, tradeSessionData.playerTradeSessionData_player1.inventoryTransferDataCollection, tradeSessionData.playerTradeSessionData_player1.gold, tradeSessionData.playerTradeSessionData_player2.player, tradeSessionData.playerTradeSessionData_player2.inventoryTransferDataCollection, tradeSessionData.playerTradeSessionData_player2.gold)
						if success then
							tradeSessionData.state = "completed"

							propogateTradeDataUpdate(tradeSessionData)
						else
							playerRequest_cancelTrade(player)
						end

						-- empty the guid
						processTicketDuplicationValidationQueue[guid] = nil

						for i, v in pairs(tradeSessionDataCollection) do
							if v.guid == guid then
								table.remove(tradeSessionDataCollection, i)
							end
						end

						return success, errMsg
					end
				else
					tradeSessionData.state = "active"

					propogateTradeDataUpdate(tradeSessionData)
				end

				return true
			end
		elseif key == "gold" and (type(value) == "number" and value >= 0) then
			if playerData.gold >= value then
				playerTradeSessionData_player.gold = value

				tradeSessionData.playerTradeSessionData_player1.state = "none"
				tradeSessionData.playerTradeSessionData_player2.state = "none"
				tradeSessionData.state = "active"

				propogateTradeDataUpdate(tradeSessionData)
				return true
			else
				return false, "invalid gold"
			end
		elseif key == "inventoryTransferDataCollection" and (typeof(value) == "table") then
			local playerInventoryTransferDataCollectionIsValid, trueInventoryTransferDataCollection = isPlayerInventoryTransferDataValid(player, value)

			if playerInventoryTransferDataCollectionIsValid then
				tradeSessionData.playerTradeSessionData_player1.state = "none"
				tradeSessionData.playerTradeSessionData_player2.state = "none"
				tradeSessionData.state = "active"

				playerTradeSessionData_player.inventoryTransferDataCollection = trueInventoryTransferDataCollection

				propogateTradeDataUpdate(tradeSessionData)

				return true
			else
				return false, "invalid trade transfer data"
			end
		else
			return false, "invalid key"
		end
	end

	return false, "invalid"
end

local function playerRequest_acceptTradeRequest(player, guid)

	if player:FindFirstChild("DataSaveFailed") then
		network:fireClient("alertPlayerNotification", player, {text = "Cannot trade during DataStore outage."; textColor3 = Color3.fromRGB(255, 57, 60)})
		return false, "This feature is temporarily disabled"
	end

	if pendingTrade_guids[guid] then
		-- cancel all current trades involving player except for this trade.
		local pendingTradeData = pendingTrade_guids[guid]

		invalidatePendingTradesForPlayer(pendingTradeData.tradeRequester)
		invalidatePendingTradesForPlayer(pendingTradeData.playerToTradeWith)


		if not pendingTradeData.tradeRequester.Parent or not pendingTradeData.playerToTradeWith.Parent then return false end

	--[[
	playerTradeSessionData {}
		instance player
		string state

		int gold
		{inventoryTransferData} inventoryTransferDataCollection

	tradeSessionData {}
		string guid
		string state

		playerTradeSessionData playerTradeSessionData_player1
		playerTradeSessionData playerTradeSessionData_player2
	--]]

		local tradeSessionData = {}
			tradeSessionData.guid 	= guid
			tradeSessionData.state 	= "active"

			tradeSessionData.playerTradeSessionData_player1 = {}
				tradeSessionData.playerTradeSessionData_player1.player 							= pendingTradeData.tradeRequester
				tradeSessionData.playerTradeSessionData_player1.state 							= "pending"
				tradeSessionData.playerTradeSessionData_player1.gold 							= 0
				tradeSessionData.playerTradeSessionData_player1.inventoryTransferDataCollection = {}

			tradeSessionData.playerTradeSessionData_player2 = {}
				tradeSessionData.playerTradeSessionData_player2.player 							= pendingTradeData.playerToTradeWith
				tradeSessionData.playerTradeSessionData_player2.state 							= "pending"
				tradeSessionData.playerTradeSessionData_player2.gold 							= 0
				tradeSessionData.playerTradeSessionData_player2.inventoryTransferDataCollection = {}

		-- register this trade :]
		table.insert(tradeSessionDataCollection, tradeSessionData)

		propogateTradeDataUpdate(tradeSessionData)

		return true
	end

	return false, "invalid or inactive guid"
end

local function onPlayerInventoryChanged_server(player)
	local tradeSessionData = getTradeSessionDataByPlayer(player)

	if tradeSessionData then
		tradeSessionData.playerTradeSessionData_player1.state 	= "none"
		tradeSessionData.playerTradeSessionData_player2.state 	= "none"
		tradeSessionData.state 									= "active"
	end
end

local function onPlayerRemoving(player)
	invitationCD[player] = nil
end

function module.init(Modules)

	network = Modules.network
	configuration = Modules.configuration

	game.Players.PlayerRemoving:connect(onPlayerRemoving)

	network:create("playerRequest_cancelTrade", "RemoteFunction", "OnServerInvoke", playerRequest_cancelTrade)
	network:create("playerRequest_requestTrade", "RemoteFunction", "OnServerInvoke", playerRequest_requestTrade)
	network:create("playerRequest_acceptTradeRequest", "RemoteFunction", "OnServerInvoke", playerRequest_acceptTradeRequest)
	network:create("playerRequest_updatePlayerTradeSessionData", "RemoteFunction", "OnServerInvoke", playerRequest_updatePlayerTradeSessionData)

	network:create("signal_playerTradeRequest", "RemoteEvent")
	network:create("signal_tradeSessionChanged", "RemoteEvent")

	network:connect("playerInventoryChanged_server", "Event", onPlayerInventoryChanged_server)
end

return module