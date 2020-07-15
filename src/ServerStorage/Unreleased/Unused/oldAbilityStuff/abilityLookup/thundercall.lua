local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local metadata = {
	cost = 4;
	upgradeCost = 2;
	maxRank = 8;
	layoutOrder = 3;
	
	requirement = function(playerData)
		return playerData.class == "Mage";
	end;
}

local abilityData = {
	id = 12,
	metadata = metadata;
	name = "Thundercall",
	image = "rbxassetid://2574315061",
	description = "Strike nearby foes with a bout of lightning.",
	description_key = "abilityDescription_thundercall";
	mastery = "More bolts.",
	layoutOrder = 3;
	maxRank = 10,
		
	
	prerequisite = {{id = 4; rank = 3}};
	
	statistics = {
		[1] = {
			damageMultiplier = 2.0,
			range = 20,
			bolts = 4,
			cooldown = 12,
			manaCost = 17,
		},
		[2] = {
			damageMultiplier = 2.2,
			manaCost = 19,
		},
		[3] = {
			damageMultiplier = 2.4,
			manaCost = 21,
		},
		[4] = {
			damageMultiplier = 2.6,
			manaCost = 23,
		},
		[5] = {
			bolts = 8,
			manaCost = 30;
			tier = 3;
		},
		[6] = {
			damageMultiplier = 2.9,
			manaCost = 33,
		},
		[7] = {
			damageMultiplier = 3.2,
			manaCost = 36,
		},
		[8] = {
			bolts = 12,
			manaCost = 43;
			tier = 4;
		},
		
	},
	
	windupTime = 0.75,
	
	securityData = {
		playerHitMaxPerTag = 64,
		isDamageContained = true,
		projectileOrigin = "character",
	},
	
	targetingData = {
		range = 70;
	},
	
	equipmentTypeNeeded = "staff",
	disableAutoaim = true,
}



function createEffectPart()
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	return part
end

function lightningSegment(a, b, color)
	local duration = 0.5
	
	local part = createEffectPart()
	part.Color = color
	part.Material = Enum.Material.Neon
	
	local distance = (b - a).magnitude
	local midpoint = (a + b) / 2
	
	part.Size = Vector3.new(0.25, 0.25, distance)
	part.CFrame = CFrame.new(midpoint, b)
	part.Parent = entitiesFolder
	
	tween(
		part,
		{"Transparency"},
		1,
		duration
	)
	debris:AddItem(part, duration)
end


function abilityData._abilityExecutionDataCallback(playerData, ref_abilityExecutionData)
	local doHolyMagic = playerData and playerData.nonSerializeData.statistics_final.activePerks["holymagic"]
	ref_abilityExecutionData["holymagic"] = doHolyMagic;
end

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage, _, _, player)
	local playerData = network:invoke("getPlayerData", player)
	local damageMulti = 1
	if playerData and playerData.nonSerializeData.statistics_final.activePerks["holymagic"] then
		damageMulti = damageMulti * 1.1
	end
	if sourceTag == "strike" then
		return baseDamage * damageMulti, "magical", "aoe"
	end
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	
	local targetPosition = abilityExecutionData["mouse-inrange"]
	warn("$", targetPosition)
	if not targetPosition then return end	
	
	local function lightningStrike(startPoint, impactEnabled, tier, color)
		local pointCount = 14
		local segmentDeltaY = 4
		local maxStutter = 4
		local duration = 0.5
		color = color or BrickColor.new("Electric blue").Color
		
		-- create a column of points above the spot
		-- and move them randomly around a circle
		-- to create a jagged line like lightning
		-- don't bother storing the points, we don't
		-- need to do that, we only need the previous
		for bolt = 1, tier do
			local cframe = CFrame.new(startPoint)
			
			if tier > 1 then
				local spin = CFrame.Angles(0, math.pi * 2 * math.random(), 0)
				local tilt = CFrame.Angles(math.pi / 8 * math.random(), 0, 0)
				cframe = cframe * spin * tilt
			end
			
			-- start at 2 because the target point is a point, too
			for pointNumber = 2, pointCount do
				local theta = math.pi * 2 * math.random()
				local dx = math.cos(theta) * maxStutter * math.random()
				local dy = (pointNumber - 1) * segmentDeltaY
				local dz = math.sin(theta) * maxStutter * math.random()
				
				local nextCFrame = cframe * CFrame.new(dx, dy, dz)
				
				lightningSegment(cframe.Position, nextCFrame.Position, color)
				cframe = nextCFrame
			end
		end
		
		-- create an expanding sphere at the base of the strike
		if impactEnabled then
			local sphere = createEffectPart()
			sphere.Position = startPoint
			sphere.Material = Enum.Material.Neon
			sphere.Color = color
			sphere.Size = Vector3.new(1, 1, 1)
			sphere.Shape = "Ball"
			sphere.Parent = entitiesFolder

			-- hit sound
			local hitSound = script.hit:Clone()
			hitSound.Parent = sphere
			hitSound:Play()
									
			tween(
				sphere,
				{"Transparency", "Size"},
				{1, Vector3.new(10, 10, 10)},
				duration
			)
			debris:AddItem(sphere, 5)

			local ring = script.ring:Clone()
			ring.Position = startPoint - Vector3.new(0,2,0)
			ring.Parent = entitiesFolder
			
			tween(
				ring,
				{"Transparency", "Size"},
				{1, ring.size * 8},
				duration*0.7
			)
			debris:AddItem(ring, 5)			
									
			if isAbilitySource then
			--	network:fire("requestEntityDamageDealt", target, target.position, "ability", self.id, "strike", guid)
			
				for i, target in pairs(damage.getDamagableTargets(game.Players.LocalPlayer)) do
					local vSize = (target.Size.X + target.Size.Y + target.Size.Z)/3
					if (target.Position - startPoint).magnitude <= 5 then
						spawn(function()
							wait(0.1)
							network:fire("requestEntityDamageDealt", target, target.Position, "ability", self.id, "strike", guid)
						end)
					end
				end			
			
			end		
			
		end
	end
	
	
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
	
	local track = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations["mage_holdInFront"])
	track:Play()
	
	-- cause the player to stop a moment
	if isAbilitySource then
		network:invoke("setCharacterArrested", true)
	end
	
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
	
	-- collect target information
	local targetsInRange = {}
	
	local position = targetPosition -- root.Position
	local range = abilityExecutionData["ability-statistics"]["range"]
	local castingPlayer = game.Players:GetPlayerByUserId(abilityExecutionData["cast-player-userId"])
	
	if position and castingPlayer then
		-- acquire all targets in range
		local targets = damage.getDamagableTargets(castingPlayer)
		
		for _, target in pairs(targets) do
			local delta = (target.Position - position)
			local distance = math.sqrt(delta.X * delta.X + delta.Z * delta.Z)
			
			if (distance <= range) and (math.abs(delta.Y) <= range) then
				table.insert(targetsInRange, {
					target = target,
					distance = distance,
				})
			end
		end
	end
	
	-- we're only gonna do this if we have folks to hit

	-- cause lightning to shoot up from the staff
	local bolts = abilityExecutionData["ability-statistics"]["bolts"]
	local tier = math.floor(bolts/2)
	
	local color
	if abilityExecutionData["holymagic"] then
		color = Color3.fromRGB(255, 234, 110)
	end
	
	lightningStrike(weaponMagic.WorldPosition, false, tier, color)
	
	-- pause again briefly so it appears as though
	-- lightning has gone up and come down on enemies
	wait(0.5)
	
	-- sort targets in range by distance
	table.sort(targetsInRange, function(a, b)
		return a.distance < b.distance
	end)
		
		

	-- actually strike the targets with lightning
	local remainingBolts = bolts
	
	remainingBolts = remainingBolts - 1
	lightningStrike(targetPosition, true, tier, color)
	
	for i, targetInRange in pairs(targetsInRange) do
		local target = targetInRange.target
		delay(i/6, function()
			lightningStrike(target.position, true, tier, color)
		end)
		-- break the loop if we have no lightning bolts left
		remainingBolts = remainingBolts - 1
		if remainingBolts <= 0 then
			break
		end
	end
	

end

return abilityData