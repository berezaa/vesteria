local module = {}
	module.isActive = false
	

	module.interactPrompt = "ESCAPE"

 -- prompt text

module.instant = true

local player = game.Players.LocalPlayer
local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
	local network = modules.load("network")

local function getTargetDoor()
	return script.Parent.Parent.Target
end

function module.init()
	
	local target = getTargetDoor()
	if target and player.Character and player.Character.PrimaryPart then
		if game.ReplicatedStorage.sounds:FindFirstChild("ladder") then
			game.ReplicatedStorage.sounds.ladder:Play()
		end
		--player.Character:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame - player.Character.PrimaryPart.Position + target.Position)
		network:fireServer("playerRequest_activateEscapeRope", script.Parent)
	end
	
end


function module.close()
	
end

return module
--