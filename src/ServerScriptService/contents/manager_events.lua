local module = {}

local network
local events

function module.init(Modules)
	network = Modules.network
	events = Modules.events
	network:create("fireEvent", "RemoteEvent", "OnServerEvent", function(player, ...)
		events:fireEventLocal(...)
	end)
end

return module