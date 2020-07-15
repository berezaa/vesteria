local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local utilities         = modules.load("utilities")

local debris = game:GetService("Debris")

local httpService = game:GetService("HttpService")

local statusEffectData = {
	--> identifying information <--
	id = 19;
	
	--> generic information <--
	name 				= "Refreshed";
	activeEffectName 	= "Refreshed";
	styleText 			= "Hydrated and refreshed.";
	description 		= "";
	image 				= "rbxassetid://3298789929";
	
	notSavedToPlayerData = true,
}

function statusEffectData.execute(activeStatusEffectData, entityManifest, ticksPerSecond)
	
end

return statusEffectData