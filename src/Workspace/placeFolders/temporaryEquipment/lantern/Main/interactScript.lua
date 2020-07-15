local module = {}
	module.interactPrompt 	= "EQUIP" -- prompt text
	module.instant = true



local player = game.Players.LocalPlayer
local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
	local network = modules.load("network")
	
local lanternModel = script.Parent.Parent

function module.init()
	-- run this code on interaction
	local success = network:invokeServer("playerRequest_equipTemporaryEquipment", lanternModel)
	
	if success then
		lanternModel:Destroy()
	end
end

function module.close()
	-- this does nothing but i need to keep it here so my mom doesnt ground me
end


return module