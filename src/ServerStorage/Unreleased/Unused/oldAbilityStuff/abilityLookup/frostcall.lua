local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")
local runService = game:GetService("RunService")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")
	local ability_utilities = modules.load("ability_utilities")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 37,
	
	name = "Frostcall",
	image = "rbxassetid://4079577683",
	description = "Unleash a line of falling icicles before you, damaging enemies. (Requires staff.)",
	mastery = "More icicles.",
	layoutOrder = 0;
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			cooldown = 2,
			manaCost = 10,
			damageMultiplier = 1.5,
		},
		staggered = {
			icicles = {first = 4, final = 12, levels = {3, 5, 7, 9}, integer = true},
			damageMultiplier = {first = 1.25, final = 1.875, levels = {2, 4, 6, 8, 10}},
		},
		pattern = {
			manaCost = {base = 5, pattern = {3, 2}},
		},
		
	},
	
	windupTime = 0.3,
	
	securityData = {
		playerHitMaxPerTag = 64,
		isDamageContained = true,
		projectileOrigin = "character",
	},
	
	equipmentTypeNeeded = "staff",
	disableAutoaim = true,
	
	targetingData = {
		targetingType = "line",
		
		width = function(executionData)
			local explosionRadius = 8
			local icicles = executionData["ability-statistics"]["icicles"]
			if icicles <= 6 then
				return explosionRadius
			elseif icicles <= 10 then
				return explosionRadius * 1.7
			else
				return explosionRadius * 1.9
			end
		end,
		
		length = function(executionData)
			local explosionRadius = 8
			local icicles = executionData["ability-statistics"]["icicles"]
			if icicles <= 6 then
				return icicles * explosionRadius
			elseif icicles <= 10 then
				return icicles * explosionRadius * 0.65
			else
				return icicles * explosionRadius * 0.55
			end
		end,
		
		onStarted = function(entityContainer, executionData)
			local attachment = network:invoke("getCurrentlyEquippedForRenderCharacter", entityContainer.entity)["1"].manifest.magic
			
			local emitter = script.icicle.emitter:Clone()
			emitter.Lifetime = NumberRange.new(0.5)
			emitter.Parent = attachment
			
			local light = Instance.new("PointLight")
			light.Color = BrickColor.new("Electric blue").Color
			light.Parent = attachment
			
			return {emitter = emitter, light = light, projectionPart = attachment}
		end,
		
		onEnded = function(entityContainer, executionData, data)
			data.emitter.Enabled = false
			game:GetService("Debris"):AddItem(data.emitter, data.emitter.Lifetime.Max)
			
			data.light:Destroy()
		end
	},
}

function createEffectPart()
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	return part
end

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "iceExplosion" then
		return baseDamage, "magical", "aoe"
	end
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	local entity = renderCharacterContainer:FindFirstChild("entity")
	if not entity then return end
	local animator = entity:FindFirstChild("AnimationController")
	if not animator then return end
	
	-- acquire the weapon for some fancy animations
	local weapons = network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local weaponManifest = weapons["1"] and weapons["1"].manifest
	if not weaponManifest then return end
	local weaponMagic = weaponManifest:FindFirstChild("magic")
	if not weaponMagic then return end
	local castEffect = weaponMagic:FindFirstChild("castEffect")
	if not castEffect then return end
	
	-- activate particles and wind up the attack
	castEffect.Enabled = true
	
	for _, trackName in pairs{"mage_thrust_top", "mage_thrust_bot"} do
		local track = animator:LoadAnimation(abilityAnimations[trackName])
		track:Play()
	end
	
	wait(self.windupTime)
	
	-- casting sound
	local castSound = script.castSound:Clone()
	castSound.Parent = root
	castSound:Play()
	debris:AddItem(castSound, castSound.TimeLength / castSound.PlaybackSpeed)
	
	castEffect.Enabled = false
	
	-- basic constants
	local explosionRadius = 8
	local explosionRadiusSq = explosionRadius * explosionRadius
	
	-- dealing damage
	local function aoeDamageAt(position)
		if isAbilitySource then
			local targets = damage.getDamagableTargets(game.Players.LocalPlayer)
				
			for _, target in pairs(targets) do
				local delta = (target.Position - position)
				local distanceSq = delta.X * delta.X + delta.Z * delta.Z
				
				if distanceSq <= explosionRadiusSq then
					network:fire("requestEntityDamageDealt", target, target.position, "ability", self.id, "iceExplosion", guid)
				end
			end
		end
	end
	
	-- ice explosion function
	local function iceExplosion(position)
		local duration = 1
		
		local sphere = createEffectPart()
		sphere.Material = Enum.Material.Foil
		sphere.Color = Color3.fromRGB(184, 240, 255)
		sphere.CFrame = CFrame.new(position)
		sphere.Size = Vector3.new(0, 0, 0)
		sphere.Shape = Enum.PartType.Ball
		sphere.Parent = entitiesFolder
		
		local sound = script.shatterSound:Clone()
		sound.Parent = sphere
		sound:Play()
		
		tween(
			sphere,
			{"Size", "Transparency"},
			{Vector3.new(2, 2, 2) * explosionRadius, 1},
			duration
		)
		
		delay(duration, function()
			sphere:Destroy()
		end)
		
		-- deal damage
		aoeDamageAt(position)
	end
	
	local function bonusIce(position, spin, fadeTime)
		local ice = script.icicle:Clone()
		ice.emitter:Destroy()
		
		local minTilt = math.pi / 4
		local maxTilt = math.pi / 3
		
		ice.CFrame =
			CFrame.new(position) *
			CFrame.Angles(0, spin, 0) *
			CFrame.Angles(minTilt + (maxTilt - minTilt) * math.random(), 0, 0)
		
		local goalCFrame = ice.CFrame * CFrame.new(0, 2, 0)
		local goalSize = Vector3.new(
			ice.Size.X * 5,
			ice.Size.Y * 2,
			ice.Size.Z * 5
		)
		
		tween(ice, {"CFrame", "Size"}, {goalCFrame, goalSize}, 1, Enum.EasingStyle.Linear)
		tween(ice, {"Transparency"}, 1, fadeTime, Enum.EasingStyle.Linear)
		debris:AddItem(ice, fadeTime)
		
		ice.Parent = entitiesFolder
	end
	
	-- drop icicle function
	local function dropIcicle(position)
		local fallSpeed = 128
		local fallDistance = 32
		local fallTime = fallDistance / fallSpeed
		local activationTime = fallTime * 0.4
		
		local startCFrame =
			CFrame.new(position) *
			CFrame.Angles(0, math.pi * 2 * math.random(), 0) *
			CFrame.Angles(math.pi / 8 * math.random(), 0, 0) *
			CFrame.new(0, fallDistance, 0)
		
		local icicle = script.icicle:Clone()
		local emitter = icicle.emitter
		
		icicle.CFrame = startCFrame
		
		local fallStart = tick()
		
		local heartbeatConnection do
			local function onImpact(part)
				local since = tick() - fallStart
				if since < activationTime then return end
				
				heartbeatConnection:Disconnect()
							
				-- housekeeping
				emitter.Enabled = false
				
				-- fade out
				local fadeDuration = emitter.Lifetime.Max + 1
				tween(icicle, {"Transparency"}, 1, fadeDuration, Enum.EasingStyle.Linear)
				debris:AddItem(icicle, fadeDuration)
				
				-- bonus ice spikes visual
				local bonusIcePosition = icicle.Position--(icicle.CFrame * CFrame.new(0, -icicle.Size.Y * 0.3, 0)).Position
				local bonusIceSpin = math.pi * 2 * math.random()
				local bonusIceCount = 3
				for bonusIceNumber = 1, bonusIceCount do
					local spin = math.pi * 2 * (bonusIceNumber / bonusIceCount)
					bonusIce(bonusIcePosition, bonusIceSpin + spin, fadeDuration)
				end
				
				-- impact sound effect
				local sound = script["shatterSound"..math.random(1, 5)]:Clone()
				sound.Parent = icicle
				sound:Play()
				
				-- deal damage
				aoeDamageAt(icicle.Position)
			end
		
			local function onHeartbeat(dt)
				local origin = icicle.Position
				local direction = -icicle.CFrame.UpVector * fallSpeed * dt
				local part, point = ability_utilities.raycastMap(Ray.new(origin, direction))
				icicle.Position = point
				if part then
					onImpact()
				end
			end
			
			heartbeatConnection = runService.Heartbeat:Connect(onHeartbeat)
		end
		
		icicle.Parent = entitiesFolder
		
		local goalSize = Vector3.new(
			icicle.Size.X * 8,
			icicle.Size.Y * 3,
			icicle.Size.Z * 8
		)
		tween(icicle, {"Size"}, goalSize, 1, Enum.EasingStyle.Linear)
	end
	
	-- get the position of the character's foot
	local here = root.Position + Vector3.new(0, -2.5, 0)
	local there = abilityExecutionData["mouse-world-position"]
	there = Vector3.new(there.X, here.Y, there.Z)
	local direction = (there - here).Unit
	
	local icicles = abilityExecutionData["ability-statistics"]["icicles"]
	
	local cframe = CFrame.new(Vector3.new(), direction)
	
	for icicleNumber = 1, icicles do
		local delta
		
		if icicles <= 6 then
			delta = direction * icicleNumber * explosionRadius
			
		elseif icicles <= 10 then
			local backAndForth = (icicleNumber % 2 == 0) and -1 or 1
			delta = cframe * CFrame.new(backAndForth * explosionRadius * 0.35, 0, -icicleNumber * explosionRadius * 0.65)
			delta = delta.Position
			
		else
			local xMult = (icicleNumber % 3) - 1
			delta = cframe * CFrame.new(xMult * explosionRadius * 0.45, 0, -icicleNumber * explosionRadius * 0.55)
			delta = delta.Position
		end
		
		dropIcicle(here + delta)
		wait(0.1)
	end
end

return abilityData