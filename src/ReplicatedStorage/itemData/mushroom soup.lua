local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")

return {
	--> identifying information <--
	id 		= 131;

	--> generic information <--
	name 		= "Mushroom Soup";
	rarity 		= "Common";
	image 		= "rbxassetid://3164341819";
	description = "A hearty bowl of delicious mushroom soup. Fully recovers all HP and MP.";
	
	itemType = "food";
	
	useSound 	= "potion";
	tier=3;
	
	--> stats information <--
	activationEffect = function(player)
		if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.health.Value > 0  then
			local success = network:invoke("applyPotionStatusEffectToEntityManifest_server", player.Character.PrimaryPart,
				 player.Character.PrimaryPart.maxHealth.Value - player.Character.PrimaryPart.health.Value, 
				 player.Character.PrimaryPart.maxMana.Value - player.Character.PrimaryPart.mana.Value, 
				"item", 6)
			
			return success, "You feel refreshed."
		end
		
		return false, "Character is invalid."
	end;
	
	--> shop information <--
	buyValue = 50000;
	sellValue = 5000;	
	
	stackSize = 8;
	
	--> handling information <--
	canStack 	= true;
	canBeBound 	= true;
	canAwaken 	= false;
	
	--> sorting information <--
	isImportant 	= false;
	category 		= "consumable";
}