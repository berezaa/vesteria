-- Routes all client->server remote event and function calls through a secure channel
-- Author: berezaa
local module = {}

module.priority = 2

local network

local RunService = game:GetService("RunService")

local signal = Instance.new("RemoteEvent")
signal.Name = "signal"
signal.Parent = game.ReplicatedStorage

local playerRequest = Instance.new("RemoteFunction")
playerRequest.Name = "playerRequest"
playerRequest.Parent = game.ReplicatedStorage

local function getServerNetworkLog(player)
	if player:FindFirstChild("developer") then
		return network.log
	end
end

function module.init(Modules)
	network = Modules.network

	signal.OnServerEvent:connect(function(player, eventName, ...)
		local event = game.ServerStorage.serverNetwork:FindFirstChild(eventName)
		if event then
			return event:Fire(player, ...)
		else
			if network then
				if RunService:IsStudio() then
					error("MISSING REMOTE EVENT HIT! WOULD BAN IN PROD. Name: " .. eventName)
				else
					warn(player.Name, "kicked for bad remote event request:", eventName)
					network:invoke("banPlayer", player, 60 * 60 * 24, "Compromised client", "network")
				end
			end
		end
	end)

	playerRequest.OnServerInvoke = function(player, requestName, ...)
		local request = game.ServerStorage.serverNetwork:FindFirstChild(requestName)
		if request then
			return request:Invoke(player, ...)
		else
			if network then
				if RunService:IsStudio() then
					error("MISSING REMOTE FUNCTION HIT! WOULD BAN IN PROD. Name: " .. requestName)
				else
					warn(player.Name, "kicked for bad remote function request:", requestName)
					network:invoke("banPlayer", player, 60 * 60 * 24, "Compromised client", "network")
				end
			end
		end
	end

	network:create("getServerNetworkLog", "RemoteFunction", "OnServerInvoke", getServerNetworkLog)
end

return module