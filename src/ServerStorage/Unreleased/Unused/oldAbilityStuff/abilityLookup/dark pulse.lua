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
	id = 59,
	
	name = "Dark Pulse",
	image = "rbxassetid://124874141",
	description = "Damage and slow nearby enemies.",
	mastery = "More damage and harsher slow.",
	layoutOrder = 0;
	maxRank = 5,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 5,
		static = {
			cooldown = 8,
			duration = 2,
			radius = 12,
		},
		staggered = {
			damageMultiplier = {first = 1.5, final = 2.25, levels = {2, 4}},
			slow = {first = 15, final = 45, levels = {3, 5}},
		},
		pattern = {
			manaCost = {base = 10, pattern = {2, 3}},
		},
	},
	
	windupTime = 0.5,
	
	securityData = {
		playerHitMaxPerTag = 64,
		isDamageContained = true,
		projectileOrigin = "character",
	},
}

local FOLDER_NAME = "warlockSimulacrumData"

local function hasSimulacrum(player)
	local folder = player:FindFirstChild(FOLDER_NAME)
	if folder then
		return #folder:GetChildren() > 0
	end
	return false
end

local function getSimulacrum(abilityExecutionData)
	local castingPlayer = ability_utilities.getCastingPlayer(abilityExecutionData)
	if not castingPlayer then return end
	
	local folder = castingPlayer:FindFirstChild(FOLDER_NAME)
	if not folder then return end
	
	local sims = folder:GetChildren()
	if #sims == 0 then return end
	
	local sim = sims[1]
	if not sim then return end
	
	local ref = sim:FindFirstChild("modelRef")
	if not ref then return end
	
	return ref.Value
end

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "pulse" then
		return baseDamage, "magical", "aoe"
	end
end

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource, guid)
	if not isAbilitySource then return end
	
	local char = player.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end
	
	local function affectTarget(target)
		local stats = abilityExecutionData["ability-statistics"]
		network:invoke(
			"applyStatusEffectToEntityManifest",
			target,
			"empower",
			{
				duration = stats.duration,
				modifierData = {
					walkspeed_totalMultiplicative = -stats.slow / 100,
				},
			},
			manifest,
			"ability",
			self.id
		)
		network:fire("playerRequest_damageEntity_server", player, target, target.Position, "ability", self.id, "pulse", guid)
	end
	
	local targets = damage.getDamagableTargets(player)
	local radius = abilityExecutionData["ability-statistics"]["radius"]
	local radiusSq = radius * radius
	local affected = {}
	
	local function pulse(position)
		for _, target in pairs(targets) do
			local delta = (target.Position - position)
			local distanceSq = delta.X * delta.X + delta.Z * delta.Z
			if distanceSq <= radiusSq then
				table.insert(affected, target)
				affectTarget(target)
			end
		end
	end
	
	pulse(abilityExecutionData["cast-origin"])
	if hasSimulacrum(player) then
		pulse(player[FOLDER_NAME]:GetChildren()[1].cframe.Value.Position)
	end
	
	network:fireAllClients("abilityFireClientCall", abilityExecutionData, self.id, affected)
end

function abilityData:execute_client(abilityExecutionData, affected)
	
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	
	local track = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations["mage_cast_pulse"])
	track:Play()
	
	local sim = getSimulacrum(abilityExecutionData)
	if sim then
		local animator = sim:FindFirstChild("animationController")
		if animator then
			animator:LoadAnimation(abilityAnimations["mage_cast_pulse"]):Play()
		end
	end
	
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
	
	-- cool sound
	local hitSound = script.hit:Clone()
	hitSound.Parent = root
	hitSound:Play()
	debris:AddItem(hitSound, hitSound.TimeLength)
	
	-- gather some stats
	local radius = abilityExecutionData["ability-statistics"]["radius"]
	local diameter = radius * 2
	
	-- effects!
	local function ringEffect(position)
		local growDuration = 0.25
		local fadeDuration = 1
		
		local ring = script.ring:Clone()
		ring.Position = position
		ring.Parent = entitiesFolder
		tween(ring, {"Size"}, Vector3.new(diameter, 2, diameter), growDuration)
		tween(ring, {"Transparency"}, 1, fadeDuration)
		debris:AddItem(ring, fadeDuration)
	end
	
	ringEffect(root.Position)
	if sim then
		ringEffect(sim.PrimaryPart.Position)
	end
	
	-- logic!
	if isAbilitySource then
		network:fireServer("abilityFireServerCall", abilityExecutionData, self.id, guid)
	end
end

return abilityData