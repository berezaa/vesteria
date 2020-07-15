local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")
	local effects           = modules.load("effects")
	local ability_utilities = modules.load("ability_utilities")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 50,
	
	name = "Flare",
	image = "rbxassetid://4079575823",
	description = "Release a large blast of Light magic, damaging enemies and healing allies. (Requires staff.)",
	mastery = "More damage and healing.",
	layoutOrder = 0;
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			radius = 64,
			cooldown = 30,
		},
		staggered = {
			damageMultiplier = {first = 1, final = 2, levels = {2, 4, 6, 8, 10}},
			healing = {first = 100, final = 200, levels = {3, 5, 7, 9}},
		},
		pattern = {
			manaCost = {base = 20, pattern = {3, 4}},
		},
	},
	
	windupTime = 0.9,
	
	securityData = {
		playerHitMaxPerTag = 256,
		isDamageContained = true,
	},
	
	equipmentTypeNeeded = "staff",
	disableAutoaim = true,
}

local TIME_BETWEEN_HITS = 0.05

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "flare" then
		return baseDamage, "magical", "aoe"
	end
end

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource, guid)
	if not isAbilitySource then return end
		
	local function healEntity(entity)
		local healing = abilityExecutionData["ability-statistics"]["healing"]
		
		local health = entity:FindFirstChild("health")
		if not health then return end
		local maxHealth = entity:FindFirstChild("maxHealth")
		if not maxHealth then return end
		
		health.Value = math.min(health.Value + healing, maxHealth.Value)
	end
	
	local function damageEntity(entity)
		network:fire("playerRequest_damageEntity_server", player, entity, entity.Position, "ability", self.id, "flare", guid)
	end
	
	local position = abilityExecutionData["cast-origin"]
	local radius = abilityExecutionData["ability-statistics"]["radius"]
	local radiusSq = radius * radius
	

	
	local enemies = damage.getDamagableTargets(player)
	local enemiesHit = {}
	for _, enemy in pairs(enemies) do
		local delta = (enemy.Position - position)
		local distanceSq = delta.X * delta.X + delta.Z * delta.Z
		if distanceSq <= radiusSq then
			table.insert(enemiesHit, {enemy = enemy, distanceSq = distanceSq})
		end
	end
	
--	local friendlies = damage.getFriendlies(player)
	local friendlies = damage.getNeutrals(player)
	for _, friendly in pairs(friendlies) do
		local delta = (friendly.Position - position)
		local distanceSq = delta.X * delta.X + delta.Z * delta.Z
		if distanceSq <= radiusSq then
			healEntity(friendly)
		end
	end	
	
	table.sort(enemiesHit, function(a, b)
		return a.distanceSq < b.distanceSq
	end)
	
	spawn(function()
		for _, enemyHit in pairs(enemiesHit) do
			damageEntity(enemyHit.enemy)
			wait(TIME_BETWEEN_HITS)
		end
	end)
	
	network:fireAllClients("abilityFireClientCall", abilityExecutionData, self.id, enemiesHit)
end

function abilityData:execute_client(abilityExecutionData, enemiesHit)
	local duration = 1
	
	spawn(function()
		for _, enemyHit in pairs(enemiesHit) do
			local target = enemyHit.enemy
			
			local spark = script.spark:Clone()
			spark.Transparency = 1
			spark.Size = spark.Size * 3
			spark.CFrame =
				CFrame.new(target.Position) *
				CFrame.Angles(math.pi * 2 * math.random(), 0, math.pi * 2 * math.random())
			spark.Parent = entitiesFolder
			
			tween(spark, {"Transparency", "Size"}, {0, Vector3.new(0, 0, 0)}, duration)
			effects.onHeartbeatFor(duration, function()
				local delta = target.Position - spark.Position
				spark.CFrame = spark.CFrame + delta
			end)
			debris:AddItem(spark, duration)
			
			wait(TIME_BETWEEN_HITS)
		end
	end)
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	
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
	
	local track = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations["mage_strike_down"])
	track:Play()
	
	-- cause the player to stop a moment
	if isAbilitySource then
		network:invoke("setCharacterArrested", true)
	end
	
	-- channeling sound
	local channelSound = script.channel:Clone()
	channelSound.Parent = root
	channelSound:Play()
	debris:AddItem(channelSound, channelSound.TimeLength)
	
	-- create a neat charging effect
	do
		local charge = script.flare:Clone()
		local chargeEmitter = charge.emitter
		charge.Parent = entitiesFolder
		tween(charge, {"Size", "Transparency"}, {Vector3.new(4, 4, 4), 1}, self.windupTime)
		
		local beam = script.beam:Clone()
		beam.Size = Vector3.new(128, 1, 1)
		beam.Parent = entitiesFolder
		tween(beam, {"Transparency"}, 1, self.windupTime)
		
		effects.onHeartbeatFor(self.windupTime, function(dt, t, w)
			charge.CFrame = weaponMagic.WorldCFrame
			beam.CFrame =
				CFrame.new(weaponMagic.WorldPosition + Vector3.new(0, 64, 0)) *
				CFrame.Angles(0, 0, math.pi / 2)
			
			if w == 1 then
				beam:Destroy()
				chargeEmitter.Enabled = false
				wait(chargeEmitter.Lifetime.Max)
				charge:Destroy()
			end
		end)
	end
	
	-- wait the windup
	wait(self.windupTime)
	
	-- free up the character
	if isAbilitySource then
		network:invoke("setCharacterArrested", false)
	end
	
	-- disable ongoing effects gracefully
	track:Stop(0.25)
	castEffect.Enabled = false
	
	-- casting sound
	local castSound = script.cast:Clone()
	castSound.Parent = root
	castSound:Play()
	debris:AddItem(castSound, castSound.TimeLength)
	
	-- gather some stats
	local radius = abilityExecutionData["ability-statistics"]["radius"]
	
	-- flare to indicate range
	do
		local growTime = 0.25
		local fadeTime = 0.75
		
		local radiusFlare = script.flare:Clone()
		local radiusFlareEmitter = radiusFlare.emitter
		radiusFlare.Position = root.Position
		radiusFlare.Transparency = 0.75
		radiusFlare.Parent = entitiesFolder
		
		tween(radiusFlare, {"Size"}, Vector3.new(1, 1, 1) * radius * 2, growTime)
		
		delay(growTime, function()
			tween(radiusFlare, {"Transparency"}, 1, fadeTime)
			wait(fadeTime)
			radiusFlareEmitter.Enabled = false
			wait(radiusFlareEmitter.Lifetime.Max)
			radiusFlare:Destroy()
		end)
	end
	
	-- logic!
	if isAbilitySource then
		network:fireServer("abilityFireServerCall", abilityExecutionData, self.id, guid)
	end
end

return abilityData