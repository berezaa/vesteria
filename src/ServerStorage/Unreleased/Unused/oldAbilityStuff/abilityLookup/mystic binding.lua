local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 33,
	
	name = "Mystic Binding",
	image = "rbxassetid://2574315061",
	description = "Entangle a target in a mystic binding, immobilizing them.",
	mastery = "Longer binding.",
	
	maxRank = 1,
	
	statistics = {
		[1] = {
			cooldown = 1,--4,
			range = 16,
			
			manaCost = 0,--20,
			
			duration = 1,
			damageMultiplier = 1.4,
			
			tier = 1,
		},
	},
	
	windupTime = 1,
	
	securityData = {
		playerHitMaxPerTag = 64,
		projectileOrigin = "character",
	},
	
	--equipmentTypeNeeded = "staff",
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
	part.BrickColor = color
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

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource)
	if not player.Character then return end
	local entity = player.Character.PrimaryPart
	if not entity then return end
	
	local position = entity.Position
	local range = abilityExecutionData["ability-statistics"]["range"]
	local duration = abilityExecutionData["ability-statistics"]["duration"]
	local castingPlayer = game.Players:GetPlayerByUserId(abilityExecutionData["cast-player-userId"])
	
	if position and castingPlayer then
		-- acquire all targets in range
		local targets = damage.getDamagableTargets(castingPlayer)
		local targetsInRange = {}
		
		for _, target in pairs(targets) do
			local distance = (target.Position - position).magnitude
			
			if distance <= range then
				network:invoke(
					"applyStatusEffectToEntityManifest",
					target,
					"mystically bound",
					{duration = duration},
					entity,
					"ability",
					self.id
				)
			end
		end
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
	
	-- stop the animation so that awkward foot slides don't happen
	track:Stop(0.25)
	
	castEffect.Enabled = false
	
	-- casting sound
	local castSound = script.cast:Clone()
	castSound.Parent = root
	castSound:Play()
	debris:AddItem(castSound, castSound.TimeLength)
	
	network:invokeServer("abilityExecuteServerCall", abilityExecutionData, self.id, guid)
end

return abilityData