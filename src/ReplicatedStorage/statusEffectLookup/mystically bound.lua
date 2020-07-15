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
	id 	= 6;
	
	--> generic information <--
	name 				= "Mystically Bound";
	activeEffectName 	= "Mystically Bound";
	styleText 			= "Mystically bound in place.";
	description 		= "";
	image 				= "rbxassetid://2528902271";
}

--							(renderCharacterContainer, 	targetPosition, isAbilitySource, hitNormal, nil, 	guid)
function statusEffectData.execute(activeStatusEffectData, entityManifest, activeStatusEffectTickTimePerSecond)
	
end

function statusEffectData.onStarted_server(activeStatusEffectData, entityManifest)
	local binding = Instance.new("BodyPosition")
	binding.Name = "MysticallyBoundBindingForce"
	binding.Position = entityManifest.Position + Vector3.new(0, 8, 0)
	binding.MaxForce = Vector3.new(1e9, 1e9, 1e9)
	binding.Parent = entityManifest
	
	activeStatusEffectData.__binding = binding
end

function statusEffectData.onEnded_server(activeStatusEffectData, entityManifest)
	if not activeStatusEffectData.__binding then
		warn("CRITICAL ERROR WITH MYSTICALLY BOUND\nCouldn't find binding force!")
		return
	end
	
	activeStatusEffectData.__binding:Destroy()
end

return statusEffectData