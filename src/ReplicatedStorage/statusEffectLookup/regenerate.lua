local modules = require(game.ReplicatedStorage.modules)
local network = modules.load("network")

local statusEffectData = {
	--> identifying information <--
	id 	= 1;
	
	--> generic information <--
	name 				= "Regeneration";
	activeEffectName 	= "Regenerating";
	styleText 			= "Regenerating health.";
	description 		= "";
	image 				= "rbxassetid://2528902271";
}

function statusEffectData.execute(activeStatusEffectData, entityManifest, activeStatusEffectTickTimePerSecond)
	local healthHealed = activeStatusEffectData.statusEffectModifier.healthToHeal or 10
	local duration = activeStatusEffectData.statusEffectModifier.duration or 5
	
	local health = entityManifest:FindFirstChild("health")
	local maxHealth = entityManifest:FindFirstChild("maxHealth")
	if health and maxHealth then
		health.Value = math.clamp(health.Value + healthHealed / duration / activeStatusEffectTickTimePerSecond, 0, maxHealth.Value)
	end
end

return statusEffectData