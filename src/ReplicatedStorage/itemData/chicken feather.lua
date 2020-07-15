local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")

item = {
	--> identifying information <--
	id 		= 271;

	--> generic information <--
	name 		= "Chicken Feather";
	rarity 		= "Common";
	image 		= "rbxassetid://4635643200";
	description = "Plucked fresh from the source.";
	
	--> shop information <--	
	sellValue = 15;
	buyValue = 150;
	
	--> handling information <--
	canStack 	= true;
	canBeBound 	= false;
	canAwaken 	= false;
	
	--> sorting information <--
	isImportant 	= false;
	category 		= "miscellaneous";
}

return item