local module = {}
	module.isActive = false

	
if script.Parent.Name == "exit" then
	module.interactPrompt = "Exit"
else
	module.interactPrompt = "Enter"
end	
 -- prompt text

module.instant = true

local player = game.Players.LocalPlayer
local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
	local network = modules.load("network")
	local utilities = modules.load("utilities")

local function getTargetDoor()
	for i,door in pairs(game.CollectionService:GetTagged("door")) do
		if door ~= script.Parent and door.Parent and door.Parent.Name == script.Parent.Parent.Name then
			return door
		end
	end
end

function module.init()
	
	local target = getTargetDoor()
	if target and player.Character and player.Character.PrimaryPart then
		if game.ReplicatedStorage.sounds:FindFirstChild("door") then
			utilities.playSound("door", player.Character.PrimaryPart)
		end
		player.Character:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame - player.Character.PrimaryPart.Position + target.Position + target.CFrame.lookVector * 8)
	end
	
end


function module.close()
	
end

return module
--