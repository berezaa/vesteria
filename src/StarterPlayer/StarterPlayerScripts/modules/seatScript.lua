local module = {}
	module.interactPrompt 	= "SIT" -- prompt text
	module.leavePrompt 		= "GET UP" -- end interaction text
	module.leaveMask 		= true -- display LEAVE as a screen UI instead of a billboard
	module.isActive 		= false

local player = game.Players.LocalPlayer
local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
	local network = modules.load("network")

function module.init()
	if not player or not player.Character or not player.Character.PrimaryPart then return end
	
	player.Character.PrimaryPart.CFrame 	= script.Parent.CFrame + Vector3.new(0, 0.5, 0)
	player.Character.PrimaryPart.Anchored 	= true
	
	network:invoke("setCharacterMovementState", "isSitting", true, script.Parent)
end

function module.close()
	if not player then return end
	
	player.Character.PrimaryPart.Anchored = false
	
	network:invoke("setCharacterMovementState", "isSitting", false, script.Parent)
end

return module
--