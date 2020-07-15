local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local detection 		= modules.load("detection")
	local physics			= modules.load("physics")

local httpService 	= game:GetService("HttpService")
local itemLookup 	= require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))

local abilityData = {
	--> identifying information <--
	id 	= 24;
	
	manaCost	= 15;
	
	--> generic information <--
	name 		= "Shadow Shots";
	image 		= "http://www.roblox.com/asset/?id=1879548550";
	description = "Send out pieces of darkness from your shadow.";
		
	--> execution information <--
	animationName 	= {};
	windupTime 		= 0.2;
	maxRank 		= 10;
	
	--> combat stats <--
	statistics = {
		[1] = {
			distance 					= 20;
			cooldown 					= 5;
			manaCost 					= 10;
			damageMultiplier 			= 1.50;
		};
		
		[2] = {
			damageMultiplier 			= 1.55;
		};
		
		[3] = {
			damageMultiplier 			= 1.60;
		};
		
		[4] = {
			damageMultiplier 			= 1.65;
		};
		
		[5] = {
			distance 					= 25;
			damageMultiplier 			= 1.7;
		};
		[6] = {
			damageMultiplier 			= 1.75;
		};
		[7] = {
			damageMultiplier 			= 1.8;
		};
		[8] = {
			damageMultiplier 			= 1.85;
		};
		[9] = {
			damageMultiplier 			= 1.9;
		};
		[10] = {
			distance 					= 30;
			damageMultiplier 			= 2;
		};				
	};
	
	dontDisableSprinting = true;
}

-- network:fireServer("playerRequest_damageEntity", player, serverHitbox, damagePosition, sourceType, sourceId, sourceTag, guid)
function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	return baseDamage, "physical", "direct"
end

function abilityData.__serverValidateMovement(player, previousPosition, currentPosition)
	local abilityStatisticsData = network:invoke("getAbilityStatisticsForRank", abilityData, network:invoke("getPlayerAbilityRankByAbilityId", player, abilityData.id))
	
	return (currentPosition - previousPosition).magnitude <= abilityStatisticsData.distance * 2.5
end

--							(renderCharacterContainer, 	targetPosition, isAbilitySource, hitNormal, nil, 	guid)
function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	if renderCharacterContainer.entity.PrimaryPart then
		local shadowPart = script.shadow:Clone()
	end
end

return abilityData