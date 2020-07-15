local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")
	local utilities         = modules.load("utilities")
	local ability_utilities = modules.load("ability_utilities")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 36,
	
	name = "Hail of Arrows",
	image = "rbxassetid://4079577793",
	description = "Rain arrows down upon a targeted area. (Requires bow.)",
	mastery = "Longer duration.",
	layoutOrder = 0;
	
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			cooldown = 15,
			radius = 16
		},
		staggered = {
			radius = {first = 12, final = 20, levels = {4, 7, 10}},
			duration = {first = 4, final = 8, levels = {3, 6, 9}},
			damageMultiplier = {first = 2, final = 4, levels = {2, 5, 8}},
		},
		pattern = {
			manaCost = {base = 5, pattern = {2, 3, 4}}
		},
	},
	
	windupTime = 0.4,
	
	securityData = {
		playerHitMaxPerTag = 64,
		isDamageContained = true,
		projectileOrigin = "character",
	},
	
	equipmentTypeNeeded = "bow",
	disableAutoaim = true,
	
	targetingData = {
		targetingType = "directCylinder",
		radius = "radius",
		range = 35,
		
		onStarted = function(entityContainer)
			local track = entityContainer.entity.AnimationController:LoadAnimation(abilityAnimations.bow_targeting_sequence)
			track:Play()
			
			return {track = track}
		end,
		
		onEnded = function(entityContainer, executionData, data)
			data.track:Stop()
		end
	}
}

local ARROW_DY = 64
local ARROW_LIFETIME = 1

function createEffectPart()
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	return part
end

local function shootArrowDownFrom(position)
	local arrow = script.arrow:Clone()
	local mover = arrow.mover
	local trail = arrow.Trail
	
	local timeToGround = ARROW_LIFETIME / 2
	local speed = ARROW_DY / timeToGround
	
	arrow.CFrame = CFrame.new(position) * CFrame.Angles(0, math.pi * 2 * math.random(), 0)
	mover.Velocity = Vector3.new(0, -speed, 0)
	arrow.Parent = entitiesFolder
	
	debris:AddItem(arrow, ARROW_LIFETIME)
end

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "quarterSecondDamage" then
		return baseDamage / 4, "physical", "aoe"
	end
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	
	-- acquire the weapon for some fancy animations
	local weapons = network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local weaponManifest = weapons["1"] and weapons["1"].manifest
	if not weaponManifest then return end
	local weaponAnimator = weaponManifest:FindFirstChild("AnimationController")
	if not weaponAnimator then return end
	
	local position = abilityExecutionData["mouse-world-position"]
	local radius = abilityExecutionData["ability-statistics"]["radius"]
	local castingPlayer = game.Players:GetPlayerByUserId(abilityExecutionData["cast-player-userId"])
	if (not position) or (not castingPlayer) then return end
	
	-- animations, windup, and more!
	local charTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations["bow_skyshot"])
	local bowTrack = weaponAnimator:LoadAnimation(abilityAnimations["bow_tripleshot"])
	
	-- create an arrow
	local arrow = script.animationArrow:Clone()
	arrow.Parent = entitiesFolder
	
	-- snap the arrow to the BOI
	local arrowHolder = weaponManifest.slackRopeRepresentation.arrowHolder
	arrowHolder.C0 = CFrame.Angles(-math.pi / 2, 0, 0) * CFrame.new(0, -arrow.Size.Y / 2 - 0.2, 0)
	arrowHolder.Part1 = arrow
	
	-- destroy the arrow when it gets shot
	delay(0.45, function()
		arrow:Destroy()
	end)
	
	-- play the animations
	charTrack:Play()
	bowTrack:Play()
	
	-- stretchy sound
	utilities.playSound("bowDraw", root)
	
	-- hold the character
	if isAbilitySource then
		network:invoke("setCharacterArrested", true)
	end
	
	wait(self.windupTime)
	
	-- shooty sound
	utilities.playSound("bowFire", root)
	
	-- stop holding the character
	if isAbilitySource then
		network:invoke("setCharacterArrested", false)
	end
	
	-- collect some statistics that everyone needs
	local duration = abilityExecutionData["ability-statistics"]["duration"]
	
	-- play a sound there
	do
		local soundPart = Instance.new("Part")
		soundPart.Size = Vector3.new()
		soundPart.Anchored = true
		soundPart.CanCollide = false
		soundPart.Transparency = 1
		soundPart.Position = position
		
		local sound = script.rain:Clone()
		sound.Parent = soundPart
		sound:Play()
		
		soundPart.Parent = entitiesFolder
		
		debris:AddItem(soundPart, duration)
	end
	
	-- shoot cool arrows at the ground
	spawn(function()
		local arrowsPerSecond = 16
		local secondsPerArrow = 1 / arrowsPerSecond
		local totalArrows = duration * arrowsPerSecond
		
		for _ = 1, totalArrows do
			local theta = math.pi * 2 * math.random()
			local r = radius * math.random()
			
			local dx = math.cos(theta) * r
			local dy = ARROW_DY
			local dz = math.sin(theta) * r
			
			shootArrowDownFrom(position + Vector3.new(dx, dy, dz))
			
			wait(secondsPerArrow)
		end
	end)
	
	-- wait a second for the arrows to start falling
	wait(0.5)

	-- deal damage to all targets near that position over time
	if isAbilitySource then
		local ticks = duration * 4
		
		local radiusSq = radius * radius
		
		spawn(function()
			for _ = 1, ticks do
				local targets = damage.getDamagableTargets(castingPlayer)
			
				for _, target in pairs(targets) do
					local delta = (target.Position - position)
					local distanceSq = delta.X * delta.X + delta.Z * delta.Z
					
					if distanceSq <= radiusSq then
						network:fire("requestEntityDamageDealt", target, target.position, "ability", self.id, "quarterSecondDamage", guid)
					end
				end
				
				wait(0.25)
			end
		end)
	end
end

return abilityData