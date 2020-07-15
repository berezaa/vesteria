local player = game.Players.LocalPlayer
local humanoid
local animationTrack

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network 		= modules.load("network")
		local utilities 	= modules.load("utilities")
		local detection 	= modules.load("detection")
		local placeSetup 	= modules.load("placeSetup")

local monsterRenderCollection = placeSetup.awaitPlaceFolder("monsterRenderCollection")

local hitDebounceTable 			= {}
local canDamage 				= false
local STICKY_ATTACK_GRANULARITY = 20
		
local function onAnimationStopped()
	hitDebounceTable = {}
	canDamage = false
end

-- destroy 
script.Parent.Handle.Touched:connect(function(Hit)

	if canDamage then

		if (Hit.Parent.Name == "shroom" or Hit.Parent.Name == "Flower") and Hit.Parent:FindFirstChild("Destroyed") == nil then

			local size = Hit.Size
			if size.X * size.Y * size.Z <= 25 then

				local Tag = Instance.new("BoolValue")
				Tag.Name = "Destroyed"
				Tag.Parent = Hit.Parent
				
				for i,Child in pairs(Hit.Parent:GetChildren()) do
					if Child:IsA("BasePart") then
						Child.CanCollide = true
						Child.Anchored = false
						if Child:IsA("MeshPart") and Child.MeshId == "rbxassetid://2007663429" then
							Child.CanCollide = false
						end
					end
				end	
				game.Debris:AddItem(Hit.Parent,5)			
			end
		end
	end
end)

local function onEquipped(mouse)
	if not humanoid and player.Character then
		humanoid = player.Character.Humanoid
		animationTrack = humanoid:LoadAnimation(script.Animation)
		
		animationTrack.Stopped:connect(onAnimationStopped)
	end
	
	mouse.Button1Down:connect(function()
		if not animationTrack.IsPlaying then
			animationTrack:Play()
			canDamage = true
			
			spawn(function()
				
			end)
		end
	end)
end

script.Parent.Equipped:connect(onEquipped)