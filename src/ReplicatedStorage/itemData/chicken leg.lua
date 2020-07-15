local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")

item = {
	--> identifying information <--
	id 		= 277;

	--> generic information <--
	name 		= "Chicken Leg";
	rarity 		= "Common";
	image 		= "rbxassetid://5048073993";
	description = "A rare treat.";
	
	itemType = "food";
	
	useSound 	= "eat_food";
	
	--> stats information <--
	activationEffect = function(player)
		if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.health.Value > 0 and player.Character.PrimaryPart.health.Value < player.Character.PrimaryPart.maxHealth.Value then
			local success = network:invoke("applyPotionStatusEffectToEntityManifest_server", player.Character.PrimaryPart, 30, nil, "item", 277)
			
			return success, success and "You feel refreshed." or "ERRORRRR"
		end
		
		return false, "Character is invalid."
	end;
	
	consumeTime = 3;
	stackSize = 16;	
	
	--> shop information <--	
	buyValue = 1000;
	sellValue = 250;	
	
	--> handling information <--
	canStack 	= true;
	canBeBound 	= false;
	canAwaken 	= false;
	
	--> sorting information <--
	isImportant 	= false;
	category 		= "consumable";
}

return item