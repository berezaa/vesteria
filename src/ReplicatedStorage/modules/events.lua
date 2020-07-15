local module = {}

local registrationsByGuid = {}
local registrationGuidsByEventName = {}

local httpService = game:GetService("HttpService")
local runService = game:GetService("RunService")

local modules = require(game.ReplicatedStorage.modules)
local network = modules.load("network")

function module:registerForEvent(eventName, callback)
	local guid = httpService:GenerateGUID()
	
	local registration = {
		callback = callback,
		guid = guid,
		eventName = eventName,
	}
	
	registrationsByGuid[guid] = registration
	
	if not registrationGuidsByEventName[eventName] then
		registrationGuidsByEventName[eventName] = {}
	end
	
	table.insert(registrationGuidsByEventName[eventName], guid)
	
	return guid
end

function module:deregisterEventByGuid(guid)
	if not registrationsByGuid[guid] then return end
	
	local eventName = registrationsByGuid[guid].eventName
	registrationsByGuid[guid] = nil
	
	local registrationGuids = registrationGuidsByEventName[eventName]
	if not registrationGuids then return end
	
	for index = #registrationGuids, 1, -1 do
		local registrationGuid = registrationGuids[index]
		if registrationGuid == guid then
			table.remove(registrationGuids, index)
		end
	end
end
module.deregisterFromEvent = module.deregisterEventByGuid

function module:__invokeCallbacks(eventName, ...)
	local registrationGuids = registrationGuidsByEventName[eventName]
	if not registrationGuids then return end
	
	for _, registrationGuid in pairs(registrationGuids) do
		local registration = registrationsByGuid[registrationGuid]
		if registration then
			registration.callback(...)
		end
	end
end

function module:fireEventAll(eventName, ...)
	self:__invokeCallbacks(eventName, ...)
	
	local network = require(script.Parent).load("network")
	
	if runService:IsServer() then
		network:fireAllClients("fireEvent", eventName, ...)
	else
		network:fireServer("fireEvent", eventName, ...)
	end
end

function module:fireEventLocal(eventName, ...)
	self:__invokeCallbacks(eventName, ...)
end

function module:fireEventPlayer(eventName, player, ...)
	if not runService:IsServer() then
		error("events:fireEventPlayer can only be called from the server.")
	end
	
	self:__invokeCallbacks(eventName, player, ...)
	
	local network = require(script.Parent).load("network")
	network:fireClient("fireEvent", player, eventName, ...)
end

function module:fireEventPlayers(eventName, players, ...)
	if not runService:IsServer() then
		error("events:fireEventPlayers can only be called from the server.")
	end
	
	self:__invokeCallbacks(eventName, players, ...)
	
	local network = require(script.Parent).load("network")
	for _, player in pairs(players) do
		network:fireClient("fireEvent", player, eventName, ...)
	end
end

function module:fireEventExcluding(eventName, playerExcluded, ...)
	if not runService:IsServer() then
		error("events:fireEventExcluding can only be called from the server.")
	end
	
	self:__invokeCallbacks(eventName, playerExcluded, ...)
	
	local network = require(script.Parent).load("network")
	local players = game:GetService("Players"):GetPlayers()
	for _, player in pairs(players) do
		if player ~= playerExcluded then
			network:fireClient("fireEvent", player, eventName, ...)
		end
	end
end

return module