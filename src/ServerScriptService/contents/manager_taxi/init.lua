local replicatedStorage = game:GetService("ReplicatedStorage")

local modules = require(replicatedStorage:WaitForChild("modules"))
local network = modules.load("network")
local utilities = modules.load("utilities")


local taximan

local function setUpTaximan()
	taximan = workspace:FindFirstChild("Taximan Dave", true)
	if not taximan then return end
	
	local dialogue = script.dialogue:Clone()
	dialogue.Parent = taximan.UpperTorso
end
network:create("setUpTaximan", "BindableFunction", "OnInvoke", setUpTaximan)

setUpTaximan()

local function playerRequest_taximanDave(player, destination, spawnLocation)
	if not taximan then return end
	if (not player.Character) or (not player.Character.PrimaryPart) then return end
	if (player.Character.PrimaryPart.Position - taximan.PrimaryPart.Position).magnitude >= 100 then return end
	local playerData = network:invoke("getPlayerData", player)
	if not playerData then return false end
	local placeData = playerData.locations[destination]
	if placeData and placeData.spawns and placeData.spawns[spawnLocation] then
		network:invoke("teleportPlayer", player, tonumber(destination), spawnLocation, nil, "taxi")
	end
end

network:create("playerRequest_taximanDave", "RemoteFunction", "OnServerInvoke", playerRequest_taximanDave)

-- old taximan dave code by davidii
-- some cool stuff in there like determining distance between locations
-- maybe we'll use in the future


-- constants that help do math
local silverPerDistance = 5

-- destinations are formatted like so
-- string name = the name of the place as displayed in the dialogue
-- int id = the place id of the destination
-- bool, string condition(player) = a function that returns whether or not a player can travel to that location and a message as to why not
local destinations = {
	portFidelio = {
		name = "Port Fidelio",
		id = 2546689567,
	},
	
	warriorStronghold = {
		name = "Warrior Stronghold",
		id = 2470481225,
	},
	
	treeOfLife = {
		name = "Tree of Life",
		id = 3112029149,
	},
	
	nilgarf = {
		name = "Nilgarf",
		id = 2119298605,
	},
	
	mushtown = {
		name = "Mushtown",
		id = 2064647391,
	},
	
	hog = {
		name = "The Gauntlet",
		id = 3360349837,
		condition = function(player)
			local data = network:invoke("getPlayerData", player)
			if data.flags.completedGauntlet then
				return true
			else
				return false, "Sorry, haven't been able to get up that way since the bandits moved in."
			end
		end,
	},
	
	guildHall = {
		priceOverride = 10,
		
		name = "Guild Hall",
		id = 4653017449,
		condition = function(player)
			local guildId = player:FindFirstChild("guildId")
			if (not guildId) or (guildId.Value == "") then
				return false, "You're not in a guild, silly!"
			end
			guildId = guildId.Value
			
			local guildData = network:invoke("getGuildData", player, guildId)
			if not guildData then
				return false, "Couldn't find your guild data, silly!"
			end
			
			if guildData.level < 3 then
				return false, "Sorry, I don't do work for small-time guilds. Get a level 3 guild, silly!"
			end
			
			if not guildData.hallLocation then
				return false, "Uh, you might want to have a guild hall first, silly!"
			end
			
			return true
		end,
		travelFunction = function(player)
			local guildId = player:FindFirstChild("guildId")
			if not guildId then return end
			guildId = guildId.Value
			if guildId == "" then return end
			
			network:invoke("teleportPlayersToGuildHall", {player}, guildId)
		end,
	},
}

-- connections
-- the system thinks of the game like a network of roads
-- it uses dijkstra's algorithm to find the shortest path
-- and creates the price of the route automatically using
-- the connections created here
local function addConnection(placeA, placeB, distance)
	if not destinations[placeA] then
		error("Invalid connection: "..placeA.." is not a valid destination.")
	end
	if not destinations[placeB] then
		error("Invalid connection: "..placeB.." is not a valid destination.")
	end
	
	local infoA = destinations[placeA]
	if not infoA.connections then
		infoA.connections = {}
	end
	infoA.connections[placeB] = distance
	
	local infoB = destinations[placeB]
	if not infoB.connections then
		infoB.connections = {}
	end
	infoB.connections[placeA] = distance
end

-- here is where the connections get made, two names
-- and a distance between them for price generation
-- no need to do reversals, the system automatically links
-- in both directions
addConnection("nilgarf", "mushtown", 2)
addConnection("nilgarf", "portFidelio", 3)
addConnection("nilgarf", "warriorStronghold", 4)
addConnection("nilgarf", "treeOfLife", 3)
addConnection("nilgarf", "guildHall", 1)
addConnection("portFidelio", "hog", 2)

local function getDestinationById(placeId)
	for id, info in pairs(destinations) do
		if info.id == placeId then
			return id, info
		end
	end
	return nil
end

local function getTaxiInfoForPlayer(player)
	
	local hereId, hereInfo = getDestinationById(utilities.originPlaceId(game.PlaceId))
	if not (hereId and hereInfo) then
		error("Attempted to get taxi data in a place without taxi data.")
	end
	
	local visited = {}
	local taxiInfo = {}
	
	local function addDestination(id, info, distance)
		local enabled = true
		local reason = nil
		if info.condition then
			enabled, reason = info.condition(player)
		end
		
		table.insert(taxiInfo, {
			id = info.id,
			name = info.name,
			price = (hereInfo.priceOverride) or (info.priceOverride) or (distance * silverPerDistance),
			enabled = enabled,
			reason = reason,
			travelFunction = info.travelFunction,
		})
	end
	
	local queue = {
		{id = hereId, distance = 0},
	}
	
	while #queue > 0 do
		local id = queue[1].id
		local info = destinations[id]
		local distance = queue[1].distance
		
		table.remove(queue, 1)
		
		if not visited[id] then
			visited[id] = true
			
			if id ~= hereId then
				addDestination(id, info, distance)
			end
			
			for nextId, nextDistance in pairs(info.connections or {}) do
				table.insert(queue, {id = nextId, distance = distance + nextDistance})
			end
		end
	end
	
	return taxiInfo
end
network:create("getTaxiInfo", "RemoteFunction", "OnServerInvoke", getTaxiInfoForPlayer)
--[[
local function takeTaxiToDestination(player, placeId)
	local taxiInfo = getTaxiInfoForPlayer(player)
	local destinationInfo
	for _, info in pairs(taxiInfo) do
		if info.id == placeId then
			destinationInfo = info
			break
		end
	end
	
	if not destinationInfo.enabled then
		return false, "conditionUnfulfilled", destinationInfo.reason
	end
	
	local success = network:invoke("tradeItemsBetweenPlayerAndNPC", player, {}, destinationInfo.price * 1000, {}, 0, "etc:taxi")
	if success then
		delay(0.2, function()
			if destinationInfo.travelFunction then
				destinationInfo.travelFunction(player)
			else
				network:invoke("teleportPlayer", player, destinationInfo.id, "taxi")
			end
		end)
		
		return true, ""
	else
		return false, "notEnoughMoney"
	end
end
network:create("takeTaxiToDestination", "RemoteFunction", "OnServerInvoke", takeTaxiToDestination)
]]






return {}