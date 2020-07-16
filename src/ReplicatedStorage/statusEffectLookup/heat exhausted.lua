local statusEffectData = {
	--> identifying information <--
	id = 18;

	--> generic information <--
	name 				= "Heat Exhausted";
	activeEffectName 	= "Heat Exhausted";
	styleText 			= "Suffering from heat exhaustion.";
	description 		= "";
	image 				= "rbxassetid://334869557";

	hideInStatusBar = true,
	notSavedToPlayerData = true,
}

function statusEffectData.execute(activeStatusEffectData, entityManifest, ticksPerSecond)
	-- purely handled by the client
end

return statusEffectData