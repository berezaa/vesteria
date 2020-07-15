local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 35,
	
	name = "DESPACITO",
	image = "http://www.roblox.com/asset/?id=2620812359",
	description = "Yeetus McBeetus commit self deletus",
	mastery = "Slowdown.",
	
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

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource)
	if not player.Character then return end
	local entity = player.Character.PrimaryPart
	if not entity then return end

	network:invoke(
		"applyStatusEffectToEntityManifest",
		entity,
		"ablaze",
		{
			percent = 0.1,
			duration = 8,
		},
		entity,
		"environment",
		0
	)
	
	network:fireAllClients("abilityFireClientCall", abilityExecutionData, self.id)
end

function abilityData:execute_client(abilityExecutionData)
	
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	network:invokeServer("abilityInvokeServerCall", abilityExecutionData, self.id)
end

return abilityData