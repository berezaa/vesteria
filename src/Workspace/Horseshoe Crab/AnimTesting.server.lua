-- Anim Testing
-- Rocky28447
-- April 28, 2020



local anims = {}

local function GetAnims()
	for _, animation in pairs (script.Parent.animations:GetChildren()) do
		anims[animation.Name] = script.Parent.AnimationController:LoadAnimation(animation)
	end
end

-- Pretty convincing death animation
-- Combines scream + death, slowed to half speed
-- Also has screech + floor hit sfx and dust particles
-- Finished
local function TestDeath()
	anims.scream:Play(0, 1, 0.475)
	wait(0.45)
	script.Parent.HumanoidRootPart.Screech:Play()
	wait(1.6)
	anims.death:Play(2, 1, 0.5)
	
	anims.death:GetMarkerReachedSignal("IncreaseSpeed"):Connect(function()
		for i = 0.5, 1.5, 0.1 do
			anims.death:AdjustSpeed(i)
		end
	end)
	
	anims.death:GetMarkerReachedSignal("Particle"):Connect(function()
		script.Parent.HumanoidRootPart.HardImpact:Play()
		for i = 1, 10 do
			script.Parent.LowerTorsoPlating.Particle.WorldOrientation = Vector3.new(0, 0, 0)
			script.Parent.LowerTorsoPlating.Particle.Dust:Emit(4)
			game:GetService("RunService").Stepped:Wait()
		end
	end)
	
	anims.death:GetMarkerReachedSignal("StopHere"):Connect(function()
		anims.death:AdjustSpeed(0)
	end)
end

GetAnims()
TestDeath()