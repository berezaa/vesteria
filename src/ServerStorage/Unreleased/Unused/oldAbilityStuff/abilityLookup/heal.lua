local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")
	local effects           = modules.load("effects")
	local ability_utilities = modules.load("ability_utilities")
	local utilities         = modules.load("utilities")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 38,
	
	name = "Heal",
	image = "rbxassetid://4079577292",
	description = "Heal yourself and nearby party members. (Requires staff.)",
	mastery = "More healing.",
	layoutOrder = 0;
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			cooldown = 4,
		},
		staggered = {
			healing = {first = 200, final = 500, levels = {2, 3, 5, 6, 8, 9}},
			radius = {first = 16, final = 20, levels = {4, 7, 10}},
		},
		pattern = {
			manaCost = {base = 10, pattern = {2, 2, 4}}
		},
	},
	
	windupTime = 0.25,
	
	securityData = {
		playerHitMaxPerTag = 64,
		projectileOrigin = "character",
	},
	
	equipmentTypeNeeded = "staff",
	disableAutoaim = true,
}

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource)
	if not isAbilitySource then return end
		
	local function healEntity(entity)
		local healing = abilityExecutionData["ability-statistics"]["healing"]
		utilities.healEntity(player.Character.PrimaryPart, entity, healing)
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
			healEntity(friendly)
			table.insert(affected, friendly)
		end
	end
	
	network:fireAllClients("abilityFireClientCall", abilityExecutionData, self.id, affected)
end

function abilityData:execute_client(abilityExecutionData, affected)
	local duration = 1
	
	for _, target in pairs(affected) do
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
	end
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
	
	local track = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations["mage_circle_quick"])
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
	
	-- gather some stats
	local radius = abilityExecutionData["ability-statistics"]["radius"]
	
	-- effects!
	do
		local growTime = 0.2
		local fadeTime = 0.8
		
		local ring = script.ring:Clone()
		ring.CFrame = CFrame.new(root.Position)
		ring.Parent = entitiesFolder
		tween(ring, {"Size"}, Vector3.new(radius * 2, 1, radius * 2), growTime)
		
		local spark = script.spark:Clone()
		spark.CFrame =
			CFrame.new(root.Position) *
			CFrame.Angles(math.pi * 2 * math.random(), 0, math.pi * 2 * math.random())
		spark.Parent = entitiesFolder
		tween(spark, {"Size"}, spark.Size * 3, growTime)
		
		delay(growTime, function()
			tween(ring, {"Transparency"}, 1, fadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			tween(spark, {"Transparency"}, 1, fadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			
			wait(fadeTime)
			
			ring:Destroy()
			spark:Destroy()
		end)
	end
	
	-- logic!
	if isAbilitySource then
		network:fireServer("abilityFireServerCall", abilityExecutionData, self.id)
	end
end

return abilityData