local modules = require(game.ReplicatedStorage.modules)
local network = modules.load("network")

local statusEffectData = {
	--> identifying information <--
	id = 16;

	--> generic information <--
	name 				= "Taunted";
	activeEffectName 	= "Taunted";
	styleText 			= "Taunted and less resilient.";
	description 		= "";
	image 				= "rbxassetid://2528902271";
}

function statusEffectData.execute(activeStatusEffectData, entityManifest, ticksPerSecond)
	local target = activeStatusEffectData.statusEffectModifier.target
	network:invoke("setMonsterTargetEntity", entityManifest, target, "status", 3)
end

return statusEffectData