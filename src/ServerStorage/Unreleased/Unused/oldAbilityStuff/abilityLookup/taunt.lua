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
	id = 58,
	
	name = "Taunt",
	image = "rbxassetid://3296042264",
	description = "Force nearby enemies to attack you and reduce their damage resistance.",
	mastery = "Larger area, shorter cooldown.",
	layoutOrder = 0;
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			radius = 24,
			statusDuration = 10,
		},
		staggered = {
			cooldown = {first = 30, final = 15, levels = {2, 4, 6, 8, 10}},
			weakness = {first = 10, final = 20, levels = {3, 5, 7, 9}},
		},
		pattern = {
			manaCost = {base = 10, pattern = {3, 4}},
		},
	},
	
	windupTime = 0.5,
	
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

local function lerp(a, b, w)
	return a + (b - a) * w
end

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource)
	if not isAbilitySource then return end
	
	local char = player.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end
	
	local radiusSq = abilityExecutionData["ability-statistics"]["radius"] ^ 2
	local taunted = {}
	
	local function tryTaunting(target)
		local entityType = target:FindFirstChild("entityType")
		if not entityType then return end
		if entityType.Value ~= "monster" then return end
		
		local delta = (target.Position - manifest.Position)
		local distanceSq = delta.X ^ 2 + delta.Z ^ 2
		if distanceSq > radiusSq then return end
		
		network:invoke("setMonsterTargetEntity", target, manifest, "ability", 3)
		
		local stats = abilityExecutionData["ability-statistics"]
		network:invoke(
			"applyStatusEffectToEntityManifest",
			target,
			"taunted",
			{
				duration = stats.statusDuration,
				target = manifest,
				modifierData = {
					damageTakenMulti = (stats.weakness / 100),
				},
			},
			target,
			"ability",
			self.id
		)
		
		table.insert(taunted, target)
	end
	
	local targets = damage.getDamagableTargets(player)
	for _, target in pairs(targets) do
		tryTaunting(target)
	end
	
	network:fireAllClients("abilityFireClientCall", abilityExecutionData, self.id, taunted)
end

function abilityData:execute_client(abilityExecutionData, taunted)
	local castingPlayer = ability_utilities.getCastingPlayer(abilityExecutionData)
	if not castingPlayer then return end
	local char = castingPlayer.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end
	
	local duration = 0.5
	for _, target in pairs(taunted) do
		local sphere = createEffectPart()
		sphere.Shape = Enum.PartType.Ball
		sphere.Size = Vector3.new(4, 4, 4)
		sphere.Color = script.ring.Color
		sphere.Transparency = 0.25
		sphere.Material = Enum.Material.Neon
		sphere.Position = target.Position
		sphere.Parent = entitiesFolder
		
		effects.onHeartbeatFor(duration, function(dt, t, w)
			local w2 = w^2
			sphere.Position = lerp(target.Position, manifest.Position, w2)
			sphere.Transparency = lerp(0.25, 1, w2)
			sphere.Size = lerp(Vector3.new(4, 4, 4), Vector3.new(), w2)
		end)
		debris:AddItem(sphere, duration)
	end
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	
	local track = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations["fist_pump"])
	track:Play()
	
	-- cause the player to stop a moment
	if isAbilitySource then
		network:invoke("setCharacterArrested", true)
		delay(track.Length, function()
			network:invoke("setCharacterArrested", false)
		end)
	end
	
	-- casting sound
	local castSound = script.cast:Clone()
	castSound.Parent = root
	castSound:Play()
	debris:AddItem(castSound, castSound.TimeLength)
	
	wait(self.windupTime)
	
	-- cool sounds
	local hitSound = script.hit:Clone()
	hitSound.Parent = root
	hitSound:Play()
	debris:AddItem(hitSound, hitSound.TimeLength)
	
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