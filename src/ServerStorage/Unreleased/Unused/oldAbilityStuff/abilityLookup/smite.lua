local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")
local runService = game:GetService("RunService")
local players = game:GetService("Players")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")
	local ability_utilities = modules.load("ability_utilities")
	local effects           = modules.load("effects")
	local projectile        = modules.load("projectile")
	local detection         = modules.load("detection")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 48,
	
	name = "Smite",
	image = "rbxassetid://4079576639",
	description = "Send forth a crescent of holy light to damage foes.",
	mastery = "",
	
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			range = 24,
		},
		staggered = {
			width = {first = 10, final = 22, levels = {2, 5, 8}},
			cooldown = {first = 6, final = 3, levels = {3, 6, 9}},
			damageMultiplier = {first = 2, final = 3, levels = {4, 7, 10}},
		},
		pattern = {
			manaCost = {base = 22, pattern = {3, 0, 5}},
		},
	},
	
	securityData = {
		playerHitMaxPerTag = 64,
		isDamageContained = true,
		projectileOrigin = "character",
	},
	
	equipmentTypeNeeded = "sword",
}

local PROJECTILE_SPEED = 32

function createEffectPart()
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	return part
end

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "smite" then
		return baseDamage, "magical", "projectile"
	end
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	-- assurances
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	local entity = renderCharacterContainer:FindFirstChild("entity")
	if not entity then return end
	local player = ability_utilities.getCastingPlayer(abilityExecutionData)
	if not player then return end
	
	-- animation
	local track = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations["basic_slash"])
	track:Play()
	
	wait(0.3)
	
	-- casting sound
	local castSound = script.cast:Clone()
	castSound.Parent = root
	castSound:Play()
	debris:AddItem(castSound, castSound.TimeLength)
	
	-- create a "projectile"
	local targetPosition = abilityExecutionData["mouse-world-position"]
	local here = root.Position
	local there = Vector3.new(
		targetPosition.X,
		here.Y,
		targetPosition.Z
	)
	local stats = abilityExecutionData["ability-statistics"]
	
	local smite = script.crescent:Clone()
	local emitter = smite.emitter
	smite.Size = Vector3.new(0, 0, 0)
	smite.CFrame = CFrame.new(here, there)
	smite.Parent = entitiesFolder
	
	-- have it appear all cool like
	tween(smite, {"Size"}, Vector3.new(stats.width, 0.05, stats.width / 2), 0.25)
	
	-- fade it out at the end
	local duration = stats.range / PROJECTILE_SPEED
	local fadeDuration = 0.25
	delay(duration - fadeDuration, function()
		tween(smite, {"Transparency"}, 1, fadeDuration)
	end)
	
	-- function for hit effects
	local function hitEffects(target)
		-- sound
		local hitSound = script.hit:Clone()
		hitSound.Parent = target
		hitSound:Play()
		debris:AddItem(hitSound, hitSound.TimeLength)
		
		-- visual
		local spark = script.spark:Clone()
		spark.Size = Vector3.new()
		spark.Parent = entitiesFolder
		
		local duration = 0.5
		tween(spark, {"Size", "Transparency"}, {Vector3.new(1, 1, 1) * 12, 1}, duration)
		local spin = CFrame.Angles(
			math.pi * 2 * math.random(),
			0,
			math.pi * 2 * math.random()
		)
		effects.onHeartbeatFor(duration, function(dt, t, w)
			spark.CFrame = CFrame.new(target.Position) * spin
			if w == 1 then
				spark:Destroy()
			end
		end)
	end
	
	-- shoot the "projectile"
	local victims = {}
	effects.onHeartbeatFor(duration, function(dt, t, w)
		-- calculate movement
		local delta = smite.CFrame.LookVector * PROJECTILE_SPEED * dt
		local nextPosition = smite.Position + delta
		
		-- deal damage
		local hitboxCFrame = CFrame.new(
			(smite.Position + nextPosition) / 2,
			nextPosition
		)
		local hitboxSize = Vector3.new(stats.width, stats.width, delta.Magnitude)
		local hits = detection.boxcast_all(damage.getDamagableTargets(player), hitboxCFrame, hitboxSize)
		for _, hit in pairs(hits) do
			if not victims[hit] then
				victims[hit] = true
				
				-- special effects
				hitEffects(hit)
				
				if isAbilitySource then
					network:fire("requestEntityDamageDealt", hit, hit.Position, "ability", self.id, "smite", guid)
				end
			end
		end
		
		-- apply movement
		smite.CFrame = smite.CFrame + delta
		
		-- get rid of the thing if we're done
		if w == 1 then
			emitter.Enabled = false
			wait(emitter.Lifetime.Max)
			smite:Destroy()
		end
	end)
end

return abilityData