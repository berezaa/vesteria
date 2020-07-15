local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local detection 		= modules.load("detection")

local entitiesFolder = placeSetup.getPlaceFolder("entities")

local httpService = game:GetService("HttpService")

local abilityData = {
	--> identifying information <--
	id 	= 30;
	
	--> generic information <--
	name 		= "Triple Slash";
	image 		= "rbxassetid://3736597264";
	description = "Unlocks the ability to triple slash with your sword.";
	
	damageType = "physical";
	
	prerequisite = {{id = 3; rank = 1}};

	layoutOrder = -1;
		
	--> execution information <--
	windupTime 		= 0.1;
	maxRank 		= 5;
	cooldown 		= 3;
	cost 			= 10;
	
	passive		= true;
	
	--> combat stats <--
	statistics = {
		[1] = {
			damageMultiplier = 1.500;
		}; [2] = {
			damageMultiplier = 1.550;
		}; [3] = {
			damageMultiplier = 1.6;
		}; [4] = {
			damageMultiplier = 1.65;
		}; [5] = {
			damageMultiplier = 1.7;
		};																	
		
	};
	
	--- ehhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
	damage 		= 30;
	maxRange 	= 30;
	equipmentTypeNeeded = "sword";
}

return abilityData