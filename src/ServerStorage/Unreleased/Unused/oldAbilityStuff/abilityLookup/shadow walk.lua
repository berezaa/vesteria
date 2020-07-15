local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local ability_utilities = modules.load("ability_utilities")

local monsterManifestCollectionFolder = placeSetup.awaitPlaceFolder("monsterManifestCollection")
local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local httpService = game:GetService("HttpService")

local abilityData = {
	--> identifying information <--
	id 	= 14;
	
	manaCost	= 5;
	
	--> generic information <--
	name 		= "Shadow Walk";
	image 		= "rbxassetid://4079576254";
	description = "Become invisible, restoring stamina and moving faster. Your first attack immediately after breaking stealth deals extra damage.";
		
	--> execution information <--
	maxRank 		= 10;
	
	statusEffects = {"stealth"; "hitBonus"};
	
	--> combat stats <--
	statistics = ability_utilities.calculateStats{
		maxRank = 10,
		staggered = {
			duration = {first = 2, final = 6, levels = {2, 6, 10}},
			cooldown = {first = 10, final = 6, levels = {3, 7}},
			damageMultiplier = {first = 2, final = 4, levels = {4, 8}},
			speedBonus = {first = 25, final = 50, levels = {5, 9}}
		},
		pattern = {
			manaCost = {base = 5, pattern = {1, 3, 2, 3}}
		}
	},
	
	statusEffectApplicationData = {duration = 8};
	doesNotBreakStealth = true,
}

function abilityData:startAbility_server(sourcePlayer, targetPlayer)
	local abilityStatistics = network:invoke(
		"getAbilityStatisticsForRank",
		abilityData,
		network:invoke(
			"getPlayerAbilityRankByAbilityId",
			sourcePlayer,
			abilityData.id
		)
	)
	
	local wasApplied, reason = network:invoke(
		"applyStatusEffectToEntityManifest",
		sourcePlayer.Character.PrimaryPart,
		"stealth",
		{
			duration = abilityStatistics["duration"],
			damageMultiplier = abilityStatistics["damageMultiplier"],
			modifierData = {
				walkspeed_totalMultiplicative = abilityStatistics["speedBonus"] / 100,
			},
		},
		sourcePlayer.Character.PrimaryPart,
		"ability",
		self.id
	)
	
	network:fireClient("setStamina", sourcePlayer, "max", true)
	
	return wasApplied, reason
end

function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
--	local root = renderCharacterContainer.PrimaryPart
--	if not root then return end
--	
--	local smoke = script.smokePart:Clone()
--	smoke.Position = root.Position
--	smoke.Parent = entitiesFolder
--	smoke.sound:Play()
--	spawn(function()
--		smoke.emitter:Emit(32)
--		wait(smoke.emitter.Lifetime.Max)
--		smoke:Destroy()
--	end)
end

return abilityData