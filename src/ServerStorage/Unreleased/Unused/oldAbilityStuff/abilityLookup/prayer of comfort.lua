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
	id = 54,
	
	name = "Prayer of Comfort",
	image = "rbxassetid://4465750327",
	description = "May they be at ease under the light of Vesra.",
	mastery = "More healing.",
	layoutOrder = 0;
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			cooldown = 60 * 5,
			radius = 36,
		},
		staggered = {
			duration = {first = 60 * 2.5, final = 60 * 5, levels = {2, 3, 5, 6, 8, 9}},
			healing = {first = 6, final = 12, levels = {4, 7, 10}},
		},
		pattern = {
			manaCost = {base = 50, pattern = {2.5, 2.5, 5}},
		},
	},
	
	windupTime = 1.5,
	
	securityData = {
	},
}

local function createEffectPart()
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.CastShadow = false
	return part
end

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource)
	if not isAbilitySource then return end
	
	local char = player.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end
	
	local function buffTarget(target)
		local stats = abilityExecutionData["ability-statistics"]
		network:invoke(
			"applyStatusEffectToEntityManifest",
			target,
			"regenerate",
			{
				duration = stats.duration,
				healthToHeal = stats.healing * stats.duration,
			},
			manifest,
			"ability",
			self.id
		)
	end
	
--	local friendlies = damage.getFriendlies(player)
	local friendlies = damage.getNeutrals(player)
	local position = abilityExecutionData["cast-origin"]
	local radius = abilityExecutionData["ability-statistics"]["radius"]
	local radiusSq = radius * radius
	local affected = {}
	for _, friendly in pairs(friendlies) do
		local delta = (friendly.Position - position)
		local distanceSq = delta.X * delta.X + delta.Z * delta.Z
		if distanceSq <= radiusSq then
			table.insert(affected, friendly)
			buffTarget(friendly)
		end
	end
	
	network:fireAllClients("abilityFireClientCall", abilityExecutionData, self.id, affected)
end

function abilityData:execute_client(abilityExecutionData, affected)
	for _, target in pairs(affected) do
		-- create a few lights
		local lights = {}
		local lightCount = 3
		local rotStep = math.pi * 2 / lightCount
		for lightNumber = 1, lightCount do
			local light = script.light:Clone()
			light.Parent = entitiesFolder
			
			table.insert(lights, {
				part = light,
				rotOffset = rotStep * (lightNumber - 1),
			})
		end
		
		-- do a neat spiral thing
		local rot = 0
		local rotSpeed = math.pi * 2
		local rise = -2
		local riseSpeed = 4
		local radius = 3
		local duration = 2
		
		effects.onHeartbeatFor(duration, function(dt, t, w)
			rot = rot + rotSpeed * dt
			rise = rise + riseSpeed * dt
			
			for _, light in pairs(lights) do
				if w < 1 then
					local lightRot = rot + light.rotOffset
					local dx = math.cos(lightRot) * radius
					local dy = rise
					local dz = math.sin(lightRot) * radius
					
					light.part.CFrame =
						CFrame.new(target.Position) +
						Vector3.new(dx, dy, dz)
				
				elseif w == 1 then
					tween(light.part, {"Transparency"}, 1, light.part.trail.Lifetime)
					light.part.trail.Enabled = false
					debris:AddItem(light.part, light.part.trail.Lifetime)
				end
			end
		end)
	end
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	
	local showWeapons = effects.hideWeapons(renderCharacterContainer.entity)
	
	local track = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations["prayer"])
	track:Play()
	
	-- cause the player to stop a moment
	if isAbilitySource then
		network:invoke("setCharacterArrested", true)
		delay(track.Length, function()
			network:invoke("setCharacterArrested", false)
			showWeapons()
		end)
	end
	
	-- casting sound
	local castSound = script.cast:Clone()
	castSound.Parent = root
	castSound:Play()
	debris:AddItem(castSound, castSound.TimeLength)
	
	wait(self.windupTime)
	
	-- gracefully end effects
	track:Stop(0.5)
	
	-- cool sounds
	local prayerSound = script.prayer:Clone()
	prayerSound.Parent = root
	prayerSound:Play()
	debris:AddItem(prayerSound, prayerSound.TimeLength)
	
	-- gather some stats
	local radius = abilityExecutionData["ability-statistics"]["radius"]
	local diameter = radius * 2
	
	-- effects!
	do
		local growDuration = 0.25
		local fadeDuration = 1
		
		local ring = script.ring:Clone()
		ring.Position = root.Position
		ring.Parent = entitiesFolder
		tween(ring, {"Size"}, Vector3.new(diameter, 2, diameter), growDuration)
		tween(ring, {"Transparency"}, 1, fadeDuration)
		debris:AddItem(ring, fadeDuration)
	end
	
	-- logic!
	if isAbilitySource then
		network:fireServer("abilityFireServerCall", abilityExecutionData, self.id)
	end
end

return abilityData