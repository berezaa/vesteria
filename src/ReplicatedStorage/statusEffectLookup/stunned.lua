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
	id = 13;
	
	--> generic information <--
	name 				= "Stunned";
	activeEffectName 	= "Stunned";
	styleText 			= "Stunned.";
	description 		= "";
	image 				= "rbxassetid://2528902271";
}

function statusEffectData:execute()
	
end

return statusEffectData