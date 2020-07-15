-- scrambler proxy for commands that need to be accessed from non-central sources
local proxy = {}

local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
local network = modules.load("network")

function proxy.openShop(...)
	network:invoke("openShop", ...)
end

return proxy