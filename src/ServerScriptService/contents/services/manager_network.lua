-- Routes all client->server remote event and function calls through a secure channel
-- Author: berezaa



local module = {}

local signal = Instance.new("RemoteEvent")
signal.Name = "signal"

local modules, network

signal.OnServerEvent:connect(function(player, eventName, ...)
	local event = game.ServerStorage.serverNetwork:FindFirstChild(eventName)
	if event then
		return event:Fire(player, ...)
	else
		if network then
			network:invoke("banPlayer", player, 60 * 60 * 24, "Compromised client", "network")
		end
	end
end)

signal.Parent = game.ReplicatedStorage

local playerRequest = Instance.new("RemoteFunction")
playerRequest.Name = "playerRequest"


playerRequest.OnServerInvoke = function(player, requestName, ...)
	local request = game.ServerStorage.serverNetwork:FindFirstChild(requestName)
	if request then
		return request:Invoke(player, ...)
	else
		if network then
			network:invoke("banPlayer", player, 60 * 60 * 24, "Compromised client", "network")
		end
	end
end

playerRequest.Parent = game.ReplicatedStorage

modules = require(game.ReplicatedStorage.modules)
network = modules.load("network")

network:create("getServerNetworkLog", "RemoteFunction", "OnServerInvoke", function(player)
	if player:FindFirstChild("developer") then
		return network.log
	end
end)

return {}