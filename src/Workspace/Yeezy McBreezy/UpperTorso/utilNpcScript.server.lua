local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")

local function playerRequestChangeClass(player, class)
	return network:invoke("changePlayerClass", player, class)
end
network:create("utilNpcClassChange", "RemoteFunction", "OnServerInvoke", playerRequestChangeClass)

local function playerRequestLevelBoost(player, level)
	-- should probably have some security here
	local playerData = network:invoke("getPlayerData", player)
	playerData.nonSerializeData.setPlayerData("level", level)
	playerData.nonSerializeData.setPlayerData("exp", 0)
	
	return true, nil
end
network:create("utilNpcLevelBoost", "RemoteFunction", "OnServerInvoke", playerRequestLevelBoost)