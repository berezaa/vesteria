local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")

item = {
	--> identifying information <--
	id 		= 253;

	--> generic information <--
	name 		= "Pear";
	rarity 		= "Common";
	image 		= "rbxassetid://2661683979";
	description = "A ripe pear bustling with flavor.";
	
	itemType = "food";

	useSound 	= "eat_food";
	
	--> stats information <--
	activationEffect = function(player)
		if player.Character then
			local success = network:invoke("applyPotionStatusEffectToEntityManifest_server", player.Character.PrimaryPart, 50, nil, "item", 226)
			local wasApplied, reason = network:invoke("applyStatusEffectToEntityManifest", player.Character.PrimaryPart, "empower", {
				duration = 60;
				
				modifierData = {
					stamina = 1;
				};
			}, player.Character.PrimaryPart, "item", item.id)			
			
			return wasApplied and "You feel refreshed." or "ERRORRRR"
		end
		
		return false, "Character is invalid."
	end;
	
	consumeTime = 1;
	stackSize = 44;
	
	--> shop information <--
	buyValue = 500;
	sellValue = 100;	
	
	--> handling information <--
	canStack 	= true;
	canBeBound 	= true;
	canAwaken 	= false;
	
	--> sorting information <--
	isImportant 	= false;
	category 		= "consumable";
}

return item