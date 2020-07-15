local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local utilities         = modules.load("utilities")

local monsterManifestCollectionFolder = placeSetup.awaitPlaceFolder("monsterManifestCollection")

local httpService = game:GetService("HttpService")

local statusEffectData = {
	--> identifying information <--
	id 	= 3;
	
	--> generic information <--
	name 				= "Poisoned";
	activeEffectName 	= "Poisoned";
	styleText 			= "Poisoned and taking damage over time.";
	description 		= "";
	image 				= "rbxassetid://2528902271";
}

--function statusEffectData.execute_old(playerStatusEffectData, targetEntity, ticksPerSecond)
--	local healthLost 	= playerStatusEffectData.statusEffectModifier.healthLost or 10
--	local duration 		= playerStatusEffectData.statusEffectModifier.duration or 5
--	
--	if targetEntity:FindFirstChild("health") and targetEntity:FindFirstChild("maxHealth") then
--		targetEntity.health.Value = math.clamp(targetEntity.health.Value - healthLost / duration / ticksPerSecond, 0, targetEntity.maxHealth.Value)
--	end
--end

function statusEffectData.execute(activeStatusEffectData, entityManifest, ticksPerSecond)
	local totalDamage = activeStatusEffectData.statusEffectModifier.healthLost
	local duration = activeStatusEffectData.statusEffectModifier.duration
	local dps = totalDamage / duration
	local damage = dps / ticksPerSecond
	
	local entityType = entityManifest:FindFirstChild("entityType")
	if not entityType then return end
	entityType = entityType.Value
	
	local sourceGuid = activeStatusEffectData.sourceEntityGUID
	if not sourceGuid then return end
	local source = utilities.getEntityManifestByEntityGUID(sourceGuid)
	if not source then return end
	local sourceType = source:FindFirstChild("entityType")
	if not sourceType then return end
	sourceType = sourceType.Value
	if sourceType ~= "character" then
		return
	end
	local char = source.Parent
	local player = game.Players:GetPlayerFromCharacter(char)
	if not player then return end
	
	local damageData = {
		damage = damage,
		sourceType = "status",
		sourceId = statusEffectData.id,
		damageType = "magical",
		sourcePlayerId = player.UserId,
	}
	
	if entityType == "monster" then
		network:invoke("monsterDamageRequest_server", player, entityManifest, damageData)
	else
		network:invoke("playerDamageRequest_server", player, entityManifest, damageData)
	end
end

function statusEffectData.__clientApplyStatusEffectOnCharacter(renderCharacterContainer)
	if not renderCharacterContainer or not renderCharacterContainer:FindFirstChild("entity") then return false end
		
	
end

function statusEffectData.__clientRemoveStatusEffectOnCharacter(renderCharacterContainer)
	
end

return statusEffectData