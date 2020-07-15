local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")
local runService = game:GetService("RunService")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")
	local ability_utilities = modules.load("ability_utilities")
	local utilities         = modules.load("utilities")
	local effects           = modules.load("effects")
	local detection 		= modules.load("detection")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 44,
	
	name = "Ranger's Stance",
	image = "rbxassetid://4079577447",
	description = "Toggled ability. Use mana to focus your shots for extra range and damage in single arrows. (Requires bow.)",
	mastery = "",
	
	maxRank = 10,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		static = {
			cooldown = 1,
			manaCost = 0,
		},
		staggered = {
			damageBonus = {first = 2, final = 5, levels = {2, 3, 4, 6, 7, 8, 10}},
			dexAsCrit = {first = 0.1, final = 0.25, levels = {5, 9}}
		},
		pattern = {
			manaPerSecond = {base = 3, pattern = {0.5, 0.5, 0.5, 2}},
		},
	},
	
	securityData = {
	},
	
	equipmentTypeNeeded = "bow",
}

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource)
	if not isAbilitySource then return end
	
	if not player.Character then return end
	local manifest = player.Character.PrimaryPart
	if not manifest then return end
	
	local guid = utilities.getEntityGUIDByEntityManifest(manifest)
	if not guid then return end
	
	local statuses = network:invoke("getStatusEffectsOnEntityManifestByEntityGUID", guid)
	local statusGuid = nil
	
	for _, status in pairs(statuses) do
		if status.statusEffectType == "ranger stance" then
			statusGuid = status.statusEffectGUID
			break
		end
	end

	if statusGuid then
		network:invoke("revokeStatusEffectByStatusEffectGUID", statusGuid)
	else
		local stats = abilityExecutionData["ability-statistics"]
		local manaCost = stats.manaPerSecond
		
		network:fireAllClients("abilityFireClientCall", abilityExecutionData, self.id)
		network:invoke(
			"applyStatusEffectToEntityManifest",
			manifest,
			"ranger stance",
			{
				duration = nil,
				manaCost = manaCost,
				damageBonus = stats.damageBonus,
				modifierData = {
					walkspeed_totalMultiplicative = -0.95,
					criticalStrikeChance = (stats.dexAsCrit * abilityExecutionData["_dex"]) / 100
				},
			},
			manifest,
			"ability",
			self.id
		)
	end
end

function abilityData:execute_client(abilityExecutionData)
	local player = ability_utilities.getCastingPlayer(abilityExecutionData)
	if not player then return end
	local char = player.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end
	local renderCharacterContainer = network:invoke("getPlayerRenderFromManifest", manifest)
	if not renderCharacterContainer then return end
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	
	local sound = script.buff:Clone()
	sound.Parent = root
	sound:Play()
	debris:AddItem(sound, sound.TimeLength)
	
	local sphere = Instance.new("Part")
	sphere.Anchored = true
	sphere.CanCollide = false
	sphere.Shape = Enum.PartType.Ball
	sphere.Material = "Neon"
	sphere.Color = Color3.fromRGB(72, 107, 85)
	sphere.Size = Vector3.new(0, 0, 0)
	sphere.Position = root.Position
	sphere.Parent = entitiesFolder
	
	tween(sphere, {"Size", "Transparency"}, {Vector3.new(8, 8, 8), 1}, 1)
	debris:AddItem(sphere, 1)
end

function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	if isAbilitySource then
		network:invokeServer("abilityInvokeServerCall", abilityExecutionData, self.id)
	end
end

return abilityData