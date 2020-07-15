local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")

local monsterManifestCollectionFolder = placeSetup.awaitPlaceFolder("monsterManifestCollection")

local httpService = game:GetService("HttpService")

local statusEffectData = {
	--> identifying information <--
	id = 4;
	
	--> generic information <--
	name 				= "Empowered";
	activeEffectName 	= "Empowered";
	styleText 			= "This unit is empowered.";
	description 		= "";
	image 				= "rbxassetid://2528902271";
}

--							(renderCharacterContainer, 	targetPosition, isAbilitySource, hitNormal, nil, 	guid)
function statusEffectData:execute()
	
end

return statusEffectData