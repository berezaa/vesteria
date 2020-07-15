local module = {}
	module.isActive = false
	
module.interactPrompt = "FIRE!" -- prompt text

module.instant = true

local player = game.Players.LocalPlayer
local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
	local network = modules.load("network")
	local utilities = modules.load("utilities")
	local tween = modules.load("tween")

function module.init()

	
	network:invoke("setCharacterArrested", true, script.Parent.Parent.target.CFrame * CFrame.Angles(-math.pi/2, 0, 0))
	-- ssss sounds
	network:fireServer("signal_playerHasDecidedThatTheyWantToUseTheCannon", script.Parent.Parent)

	
end


network:connect("signal_playerReadyToBeBOOMEDByTheCannon", "OnClientEvent", function(cannon)
	if cannon == script.Parent.Parent then
		network:invoke("setCharacterArrested", false)
		network:fire("applyJoltVelocityToCharacter", script.Parent.Parent.target.CFrame.LookVector * 280)
	
	end
end)

function module.close()
	
end

return module