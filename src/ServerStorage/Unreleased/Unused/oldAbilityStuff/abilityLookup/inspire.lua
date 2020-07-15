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
	id = 46,
	
	name = "Inspire",
	image = "rbxassetid://4079576394",
	description = "Grant a defense buff to yourself and nearby party members.",
	mastery = "Bigger buff.",
	layoutOrder = 0;
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			cooldown = 60 * 5,
			radius = 32,
		},
		staggered = {
			duration = {first = 60 * 2.5, final = 60 * 5, levels = {2, 3, 5, 6, 8, 9}},
			buff = {first = 5, final = 15, levels = {4, 7, 10}},
		},
		pattern = {
			manaCost = {base = 50, pattern = {2.5, 2.5, 5}},
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
			"empower",
			{
				duration = stats.duration,
				modifierData = {
					damageTakenMulti = -stats.buff / 100,
				},
			},
			manifest,
			"ability",
			self.id
		)
	end
	
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
	local fadeDuration = 4
	
	for _, target in pairs(affected) do
		-- rotating shield
		local shield = script.shield:Clone()
		
		local size = shield.Size
		shield.Size = Vector3.new()
		tween(shield, {"Size"}, size, 0.5)
		
		effects.onHeartbeatFor(fadeDuration, function(dt, t, w)
			shield.CFrame =
				CFrame.new(target.Position) *
				CFrame.new(0, 6, 0) *
				CFrame.Angles(0, t * 6, 0)
			shield.Transparency = w
			if w == 1 then
				shield:Destroy()
			end
		end)
		
		shield.Parent = entitiesFolder
		
		-- emitter!
		local emitterPart = createEffectPart()
		emitterPart.Size = Vector3.new(4, 1, 4)
		emitterPart.Transparency = 1
		
		local emitter = script.emitter:Clone()
		emitter.Parent = emitterPart
		
		effects.onHeartbeatFor(1, function(dt, t, w)
			emitterPart.CFrame =
				CFrame.new(target.Position) *
				CFrame.new(0, -2, 0)
			
			if w == 1 then
				emitter.Enabled = false
				wait(emitter.Lifetime.Max)
				emitterPart:Destroy()
			end
		end)
		
		emitterPart.Parent = entitiesFolder
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
	for number = 0, 2 do
		delay(number / 3, function()
			local hitSound = script.hit:Clone()
			hitSound.Parent = root
			hitSound:Play()
			debris:AddItem(hitSound, hitSound.TimeLength)
		end)
	end
	
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