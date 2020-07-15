-- Anim Viewer
-- Rocky28447
-- April 29, 2020



local anims = {}
local currentAnim = 1

local function Footstep(leg, magnitude)
	local stomps = script.Parent.sfx.Stomp:GetChildren()
	local stomp = stomps[math.random(1, #stomps)]:Clone()
	stomp.Parent = script.Parent[leg].Bottom
	stomp.Volume = stomp.Volume * magnitude
	stomp:Play()
	
	script.Parent[leg].Bottom.Dust:Emit(20 * magnitude)
	game:GetService("Debris"):AddItem(stomp, 4)
end


local function GetAnims()
	for _, animation in pairs (script.Parent.animations:GetChildren()) do
		local track = script.Parent.AnimationController:LoadAnimation(animation)
		anims[#anims + 1] = track
		
		if (animation.Name == "walking") then
			track:GetMarkerReachedSignal("Footstep"):Connect(function(leg)
				Footstep(leg, 1)
			end)
		elseif (animation.Name == "screeching") then
			track:GetMarkerReachedSignal("ScreechStart"):Connect(function()
				script.Parent.Head.SpiderBoss_Shriek_01:Play()
				script.Parent.Head.Particle.ScreechEffect.Enabled = true
				track:GetMarkerReachedSignal("ScreechStop"):Wait()
				script.Parent.Head.Particle.ScreechEffect.Enabled = false
			end)
			track:GetMarkerReachedSignal("Footstep"):Connect(function(leg)
				Footstep(leg, 1)
			end)
		elseif (animation.Name == "jabbing") then
			track:GetMarkerReachedSignal("Footstep"):Connect(function(leg)
				Footstep(leg, 0.75)
			end)
			track:GetMarkerReachedSignal("Trail"):Connect(function(enabled)
				script.Parent["1LLEG2"].Trail.Enabled = (enabled == "true" and true or false)
				script.Parent["1RLEG2"].Trail.Enabled = (enabled == "true" and true or false)
			end)
		end
	end
end

local function playAnim(new, prev)
	if (prev) then anims[prev]:Stop() end
	anims[new]:Play()
	print(anims[new])
end

script.Cycle:GetPropertyChangedSignal("Value"):Connect(function()
	if (script.Cycle.Value) then
		script.Cycle.Value = false
		local new = currentAnim % #anims + 1
		playAnim(new, currentAnim)
		currentAnim = new
	end
end)

script.Repeat:GetPropertyChangedSignal("Value"):Connect(function()
	if (script.Repeat.Value) then
		script.Repeat.Value = false
		playAnim(currentAnim)
	end
end)

GetAnims()