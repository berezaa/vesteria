local module = {}

local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
network = modules.load("network")

local resetBind = Instance.new("BindableEvent")
resetBind.Event:connect(function()
	local success = true
	if not game.ReplicatedStorage:FindFirstChild("safeZone") then
		success = network:invoke("promptActionFullscreen","Are you sure you wish to kill your character?")
	end
	if success then
		network:invokeServer("playerRequest_respawnMyCharacter")
	end
end)

game.StarterGui:SetCore("ResetButtonCallback",resetBind)

return module
