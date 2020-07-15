local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")

local entityManifestCollectionFolder 	= placeSetup.awaitPlaceFolder("entityManifestCollection")
local entityRenderCollectionFolder 		= placeSetup.awaitPlaceFolder("entityRenderCollection")
local entitiesFolder 					= placeSetup.awaitPlaceFolder("entities")

local itemLookup 	= require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))

local httpService = game:GetService("HttpService")

local abilityData = {
	--> identifying information <--
	id 	= 25;
	
	--> generic information <--
	name 		= "Warp";
	image 		= "rbxassetid://2528903781";
	description = "Bring your character to wherever you click.";
		
	--> execution information <--
	animationName 	= {};
	windupTime 		= 0.1;
	maxRank 		= 1;
	
	--> combat stats <--
	statistics = {
		[1] = {
			distance 	= 20;
			cooldown 	= 4;
			manaCost 	= 30;
		};											
	};
	
	dontDisableSprinting = true;
}

function abilityData.__serverValidateMovement(player, previousPosition, currentPosition)
	return true
end

local segmentLength = 4

--							(renderCharacterContainer, 	targetPosition, isAbilitySource, hitNormal, nil, 	guid)
function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	network:invokeServer("abilityExecuteServerCall", abilityExecutionData, abilityData.id, guid)
end

function abilityData:execute_server(castPlayer, abilityExecutionData, isAbilitySource)
	if isAbilitySource and castPlayer.Character and castPlayer.Character.PrimaryPart then
		castPlayer.Character.PrimaryPart.CFrame = CFrame.new(abilityExecutionData["absolute-mouse-world-position"] + Vector3.new(0, 4, 0))
	end
end

return abilityData