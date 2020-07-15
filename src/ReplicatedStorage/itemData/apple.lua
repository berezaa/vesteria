local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")

item = {
	--> identifying information <--
	id 		= 226;

	--> generic information <--
	name 		= "Red Apple";
	rarity 		= "Common";
	image 		= "rbxassetid://4574376530";
	description = "A crisp apple fresh from the tree.";
	
	itemType = "food";

	useSound 	= "eat_food";
	
	--> stats information <--
	activationEffect = function(player)
		if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.health.Value > 0 and player.Character.PrimaryPart.health.Value < player.Character.PrimaryPart.maxHealth.Value then
			local success = network:invoke("applyPotionStatusEffectToEntityManifest_server", player.Character.PrimaryPart, 30, nil, "item", 226)
			
			return success, success and "You feel refreshed." or "ERRORRRR"
		end
		
		return false, "Character is invalid."
	end;
	
	consumeTime = 1;
	stackSize = 44;
	
	--> shop information <--
	buyValue = 200;
	sellValue = 50;	
	
	--> handling information <--
	canStack 	= true;
	canBeBound 	= true;
	canAwaken 	= false;
	
	--> sorting information <--
	isImportant 	= false;
	category 		= "consumable";
}

return item