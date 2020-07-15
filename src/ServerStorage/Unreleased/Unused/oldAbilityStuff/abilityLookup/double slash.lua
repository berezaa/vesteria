local metadata = {
	cost = 1;
	
	requirement = function(playerData)
		return true;
	end;
	
	variants = {
		tripleSlash = {
			cost = 2;
			requirement = function(playerData)
				return playerData.nonSerializeData.statistics_final.str >= 10
			end;
		};
	};
}

local ABILITY_ID = 3

local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")

local entityManifestCollectionFolder = placeSetup.awaitPlaceFolder("entityManifestCollection")

local httpService = game:GetService("HttpService")

local doubleSlashData 		= {
	--> identifying information <--
	id 	= ABILITY_ID;
	metadata = metadata;
	passive		= true;	
	name 		= "Double Slash";
	image 		= "rbxassetid://3736597154";
	description = "Upgrades your Basic Attack.";
	statistics = {
		[1] = {
			tier = 1;
		};
	};	
	
	maxRank = 1;
}

local tripleSlashData = {
	--> identifying information <--
	id 	= ABILITY_ID;
	metadata = metadata;
	passive		= true;
	name 		= "Triple Slash";
	image 		= "rbxassetid://3736597264";
	description = "Upgrades your Basic Attack";
	statistics = {
		[1] = {
			tier = 1;
		};
	};	
	maxRank = 1;
}

function generateAbilityData(playerData, abilityExecutionData)
	abilityExecutionData = abilityExecutionData or {}
	if playerData then
		local variant
		for i, ability in pairs(playerData.abilities) do
			if ability.id == ABILITY_ID then
				variant = ability.variant
			end
		end
		abilityExecutionData.variant = variant or "doubleSlash"
	end

	if abilityExecutionData.variant == "tripleSlash" then
		return tripleSlashData
	end
	
	return doubleSlashData
end

return generateAbilityData


