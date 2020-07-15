local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")

local entityManifestCollectionFolder = placeSetup.awaitPlaceFolder("entityManifestCollection")

local metadata = {
	cost = 1;
	maxRank = 1;
	layoutOrder = 3;
	
	requirement = function(playerData)
		return playerData.class == "Hunter";
	end;
}


local abilityData = {
	--> identifying information <--
	id 	= 7;
	metadata = metadata;
	passive		= true;
	layoutOrder = 0;	
	--> generic information <--
	name 		= "Double Jump";
	image 		= "rbxassetid://3736597758";
	description = "Grants you the ability to jump in mid-air!";
	statistics = {
		[1] = {
			tier = 1;
		};
	};		
	maxRank = 1;
}

return abilityData