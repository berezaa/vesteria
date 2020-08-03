local module = {}

function module.init(Modules)
	local network = Modules.network
	local events = Modules.events
	network:connect("fireEvent", "OnClientEvent", function(...)
		events:fireEventLocal(...)
	end)
end

return module