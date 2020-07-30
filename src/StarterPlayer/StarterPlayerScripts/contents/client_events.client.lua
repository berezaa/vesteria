local rs = game:GetService("ReplicatedStorage")
local modules = require(rs:WaitForChild("modules"))
local network = modules.load("network")
local events = modules.load("events")

network:connect("fireEvent", "OnClientEvent", function(...)
	events:fireEventLocal(...)
end)
