local module = {}
module.isActive = false
module.interactPrompt = "Pull"
module.instant = true

local lever = script.Parent.Parent
local puzzle = lever.Parent.Parent

function module.init()
	puzzle.remotes.leverToggled:FireServer(lever)
end

function module.close()
	
end

return module