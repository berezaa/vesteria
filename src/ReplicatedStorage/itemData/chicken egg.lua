local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")

item = {
	--> identifying information <--
	id 		= 270;

	--> generic information <--
	name 		= "Chicken Egg";
	rarity 		= "Common";
	image 		= "rbxassetid://4635646183";
	description = "Makes for a great breakfast.";
	
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