local modules = require(game.ReplicatedStorage.modules)
local network = modules.load("network")
local events = modules.load("events")

network:create("fireEvent", "RemoteEvent", "OnServerEvent", function(player, ...)
	events:fireEventLocal(...)
end)

return {}