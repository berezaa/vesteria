local module = {}
	module.isActive = false
	
module.interactPrompt = "Open" -- prompt text

local player = game.Players.LocalPlayer
local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
	local network = modules.load("network")
	local utilities = modules.load("utilities")
	local tween = modules.load("tween")

local safe = script.Parent.Parent

local controller = safe.AnimationController
local animation = safe.Open
local track = controller:LoadAnimation(animation)

local loaded

function module.init()
	if not loaded then
		game.ContentProvider:PreloadAsync({track})
		loaded = true
	end
	track:Stop()
	track:Play()
	track:AdjustSpeed(1.5)
	delay(2.75, function()
		if track.IsPlaying then
			track:AdjustSpeed(0)
		end
	end)
end

function module.close()
	track:AdjustSpeed(1.5)
	game.CollectionService:RemoveTag(script.Parent, "interact")
	delay(1.5, function()
		game.CollectionService:AddTag(script.Parent, "interact")
	end)
end

return module