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