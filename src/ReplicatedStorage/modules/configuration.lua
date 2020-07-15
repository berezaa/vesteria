local module = {}
	
local insertService 	= game:GetService("InsertService")
local httpService 		= game:GetService("HttpService")
local runService 		= game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network = modules.load("network")
-- above means that modules and network cannot require configuration!
-- keep this in mind.

local rawGameConfigurationAssetId = 2553891018
local rawGameConfigurationLatestAssetVersionId

local rawGameConfiguration
local clientGameConfiguration
local serverGameConfiguration
local playerGameConfigurationCache 	= {}

local isRunningOnServer = runService:IsServer()
local isRunningOnClient = runService:IsClient()

local function getGameConfiguration(player)
	if isRunningOnClient then warn("Unable to call `getGameConfiguration` on client") return nil end
	
	local specificGameConfiguration = {}
	
	for configurationName, configurationData in pairs(rawGameConfiguration) do
		if configurationData.overrides then
			local placeOverride = nil
			local playerOverride = nil
			
			for overrideString, overrideValue in pairs(configurationData.overrides) do
				local overrideType, overrideId = string.match(overrideString, "([puid]+):(%d+)")
				
				if overrideType == "pid" and overrideId and game.PlaceId == tonumber(overrideId) then
					placeOverride = overrideValue
				elseif overrideType == "uid" and overrideId and player and player.userId == tonumber(overrideId) then
					playerOverride = overrideValue
				end
			end
			
			if playerOverride ~= nil then
				specificGameConfiguration[configurationName] = playerOverride
			elseif placeOverride ~= nil then
				specificGameConfiguration[configurationName] = placeOverride
			else
				specificGameConfiguration[configurationName] = configurationData.value
			end
		else
			specificGameConfiguration[configurationName] = configurationData.value
		end
	end
	
	return specificGameConfiguration
end

local function updateGameConfiguration()
	if isRunningOnClient then warn("Unable to call `updateGameConfiguration` on client") return nil end
	
	local newRawGameConfiguration
	local success, returnValue = pcall(function()
		return game:GetService("InsertService"):GetLatestAssetVersionAsync(rawGameConfigurationAssetId)
	end)
	
	if success and returnValue then
		if not rawGameConfigurationLatestAssetVersionId or rawGameConfigurationLatestAssetVersionId ~= returnValue then
			local success2, returnValue2 = pcall(function()
				return game:GetService("InsertService"):LoadAssetVersion(returnValue)
			end)
			
			if success2 and returnValue2 and returnValue2:GetChildren()[1] then
				newRawGameConfiguration 					= require(returnValue2:GetChildren()[1])
				rawGameConfigurationLatestAssetVersionId 	= returnValue
			else
				if not rawGameConfiguration then
					warn("ERR2: gameConfiguration failed to load, defaulting to embedded gameConfiguration")
					newRawGameConfiguration = require(game.ServerStorage.gameConfiguration)
				end
			end
		end
	else
		if not rawGameConfiguration then
			warn("ERR1: gameConfiguration failed to load, defaulting to embedded gameConfiguration")
			newRawGameConfiguration = require(game.ServerStorage.gameConfiguration)
		end
	end
	
	-- unload gameConfiguration
	if newRawGameConfiguration then
		rawGameConfiguration = newRawGameConfiguration
		
		local newPlayerGameConfigurationCache = {}
		for i, player in pairs(game.Players:GetPlayers()) do
			newPlayerGameConfigurationCache[player] = getGameConfiguration(player)
			
			-- strip away all server exclusive configurations
			for configurationName, configurationValue in pairs(newPlayerGameConfigurationCache[player]) do
				if configurationName:sub(1, 7) == "server_" then
					newPlayerGameConfigurationCache[player][configurationName] = nil
				end
			end
		end
		
		serverGameConfiguration 		= getGameConfiguration(nil)
		playerGameConfigurationCache 	= newPlayerGameConfigurationCache
		
		for i, player in pairs(game.Players:GetPlayers()) do
			if playerGameConfigurationCache[player] then
				network:fireClient("signal_playerGameConfigurationUpdated", player, playerGameConfigurationCache[player], serverGameConfiguration)
			end
		end
		
		network:fire("gameConfigurationUpdated", serverGameConfiguration)
	end
end

local function playerRequest_getPlayerGameConfiguration(player)
	return playerGameConfigurationCache[player], serverGameConfiguration
end

function module.getConfigurationValue(configurationValueName, invokingPlayer)
	if isRunningOnServer then
		
		-- check for config to exist, and if it doesnt wait!
		if not serverGameConfiguration then
			while not serverGameConfiguration do
				wait(0.1)
			end
		end
		
		if invokingPlayer then
			local resp = playerGameConfigurationCache[invokingPlayer][configurationValueName]
			
			-- make sure serverGameConfiguration isn't nil, might be a
			-- generic configuration!
			if resp == nil then
				return serverGameConfiguration[configurationValueName]
			end
			
			return resp
		else
			return serverGameConfiguration[configurationValueName]
		end
	elseif isRunningOnClient then
		
		-- check for config to exist, and if it doesnt wait!
		if not clientGameConfiguration and not serverGameConfiguration then
			while not clientGameConfiguration and not serverGameConfiguration do
				wait(0.1)
			end
		end
		
		local resp = clientGameConfiguration[configurationValueName]
		
		-- make sure serverGameConfiguration isn't nil, might be a
		-- generic configuration!
		if resp == nil then
			return serverGameConfiguration[configurationValueName]
		end
		
		return resp
	end
end

local function onPlayerAdded(player)
	playerGameConfigurationCache[player] = getGameConfiguration(player)
end

local function onPlayerRemoving(player)
	playerGameConfigurationCache[player] = nil
end

local function main()
	if isRunningOnServer then
		-- used internally to let clients update their configuration
		network:create("playerRequest_getPlayerGameConfiguration", "RemoteFunction", "OnServerInvoke", playerRequest_getPlayerGameConfiguration)
		network:create("signal_playerGameConfigurationUpdated", "RemoteEvent")
		network:create("gameConfigurationUpdated", "BindableEvent")
		
		updateGameConfiguration()
		
		for i, player in pairs(game.Players:GetPlayers()) do
			onPlayerAdded(player)
		end
		
		game.Players.PlayerAdded:connect(onPlayerAdded)
		game.Players.PlayerRemoving:connect(onPlayerRemoving)
				
		while wait(module.getConfigurationValue("gameConfigurationRefreshTimeInSeconds", nil)) do
			updateGameConfiguration()
		end
	elseif isRunningOnClient then
		network:create("gameConfigurationUpdated", "BindableEvent")
		network:connect("signal_playerGameConfigurationUpdated", "OnClientEvent", function(newClientGameConfiguration, newServerGameConfiguration)
			clientGameConfiguration = newClientGameConfiguration
			serverGameConfiguration = newServerGameConfiguration
			
			network:fire("gameConfigurationUpdated", clientGameConfiguration, serverGameConfiguration)
		end)
		
		clientGameConfiguration, serverGameConfiguration = network:invokeServer("playerRequest_getPlayerGameConfiguration")
	end
end

spawn(main)

return module