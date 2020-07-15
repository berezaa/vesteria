local module = {}
	module.isActive = false
	
module.interactPrompt = "Ignite" -- prompt text

module.instant = true

local player = game.Players.LocalPlayer
local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
	local network = modules.load("network")

function module.init()
	network:fireServer("igniteFirePit",script.Parent)	
end


function module.close()
	
end

return module
--