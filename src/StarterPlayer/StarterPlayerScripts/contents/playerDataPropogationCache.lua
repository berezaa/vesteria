local module = {}

-- this is the service that will handle data propogation between client and server, effectively acting as the gatekeeper for data
-- leaving the client to the server, and entering the client from the server.
-- IMPORTANT! This can all be editted by the client, never assume the player's client cache data to be true. This will only have negative
-- implications on players that do edit the cache (ie, a malicious player COULD edit their client cache inventory to include
-- any items they dont own, and they could initiate a trade with the item appearing in the trade *ON THEIR SIDE*. The server will
-- validate and reject this when it sees they're attempting to trade an item they don't own, so IMO it's not a huge issue)

-- btw: I'm doing this so that we don't /need/ ten different connection listeners throughout the client, especially if, say,
-- for a trade window we want to just get the inventory. allows us to skip requesting for the information, and as long as the
-- player isn't being malicious then there will be no issues. players who maliciouslly edit their cache will be faced with a server
-- rejection message, have their cache flushed, and then need to wait for the client to fetch the cache again. no fun for them!

-- Author: Polymorphic

local cache = {}

local network
local utilities

-- this runs when the server sends information to the client, store it.
-- server will not spam this.
local function onPropogateCacheDataRequestToClientReceived(propogationNameTag, propogationData)
	cache[propogationNameTag] = propogationData

	network:fire("propogationRequestToSelf", propogationNameTag, propogationData)
end

local function onFlushPropogationCache(propogationCacheLookupTable)
	for propogationNameTag, propogationData in pairs(propogationCacheLookupTable) do
		onPropogateCacheDataRequestToClientReceived(propogationNameTag, propogationData)
	end
end

local function __impFlushPropogationCache()
	local propogationCacheLookupTable = network:invokeServer("getPropogationCacheLookupTable")
	onFlushPropogationCache(propogationCacheLookupTable)
end

-- todo: client spam limit?
function module:flushPropogationCache()
	__impFlushPropogationCache()
end

function module:getByPropogationNameTag(propogationNameTag)
	if cache[propogationNameTag] then
		if type(cache[propogationNameTag]) == "table" then
			return utilities.copyTable(cache[propogationNameTag])
		else
			return cache[propogationNameTag]
		end
	end

	return nil
end

function module.init(Modules)

	network = Modules.network
	utilities = Modules.utilities
	network:create("propogationRequestToSelf", "BindableEvent")
	network:create("propogationRequestReceived", "BindableEvent")
	network:connect("propogateCacheDataRequest", "OnClientEvent", onPropogateCacheDataRequestToClientReceived)
	network:connect("clientFlushPropogationCache", "OnClientEvent", onFlushPropogationCache)
	spawn(function()
		module:flushPropogationCache()
	end)
	network:create("getLocalPlayerDataCache", "BindableFunction", "OnInvoke", function()
		return cache
	end)
	network:create("getCacheValueByNameTag", "BindableFunction", "OnInvoke", function(nameTag)
		return module:getByPropogationNameTag(nameTag)
	end)
end


return module