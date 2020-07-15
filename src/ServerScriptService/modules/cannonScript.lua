return function()
local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
	local network = modules.load("network")
	local utilities = modules.load("utilities")
	local tween = modules.load("tween")
	
local debounceTable = {}	

local animationController = script.Parent.Parent.AnimationController

	local track = animationController:LoadAnimation(script.Parent.Parent.Animation)
	track.Looped = false
	
	local idle = animationController:LoadAnimation(script.Parent.Parent.idle)
	idle:Play()

local lastPlayer 

network:create("signal_playerReadyToBeBOOMEDByTheCannon", "RemoteEvent")
	
function BOOM(player, cannon)
	
	if cannon ~= script.Parent.Parent then
		return false
	end
	
	-- play cannon sounds
	lastPlayer = player
	
	-- animation
	
	
	track.Looped = false
	track:Play()
	
	-- hack
	local connection
	connection = track.KeyframeReached:connect(function(keyframe)
		if keyframe == "finish" then
			track:Stop()
			connection:disconnect()
			connection = nil			
		end
	end)
	--[[
	connection = track.DidLoop:connect(function()
		track:Stop()
		connection:disconnect()
		connection = nil
	end)
	]]
	
	script.Parent.Parent.target.CannonFire:Play()
	
	network:fireClient("signal_playerReadyToBeBOOMEDByTheCannon", player, script.Parent.Parent)
	
	script.Parent.Parent.target.smoke.Enabled = true
	script.Parent.Parent.target.light.Enabled = true
	script.Parent.Parent.target.explode:Emit(100) 
	script.Parent.Parent.target.light.Range = 15 
	for i=5,1,-1 do 
		wait(0.1) 
		script.Parent.Parent.target.explode:Emit(i) 
		if lastPlayer == player then
			script.Parent.Parent.target.light.Range = i * 3
		end
	end 
	wait(0.5)
	if lastPlayer == player then
		script.Parent.Parent.target.smoke.Enabled = false
		script.Parent.Parent.target.light.Enabled = false
	end
	track.Looped = false
	spawn(function()
		wait(5)
		if connection then
			connection:disconnect()
		end
	end)
end


network:create("signal_playerHasDecidedThatTheyWantToUseTheCannon", "RemoteEvent", "OnServerEvent", BOOM)


--network:create("playerRequest_cannonGoBOOM", "RemoteFunction", "OnServerInvoke", BOOM)
end