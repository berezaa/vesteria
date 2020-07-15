
local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")

local abilityData = {
	--> identifying information <--
	id 	= 1;
	
	--> generic information <--
	name 			= "Fishing";
	image 			= "rbxassetid://2585107511";
	color 			= Color3.fromRGB(9, 79, 113);
	description 	= "Catch some fish";
	
	
	
	

}

return abilityData
