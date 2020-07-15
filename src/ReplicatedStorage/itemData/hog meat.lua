local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")


item = {
	--> identifying information <--
	id 		= 144;

	--> generic information <--
	name 		= "Hog Meat";
	rarity 		= "Common";
	image 		= "rbxassetid://3164395419";
	description = "Mmm, fresh hog. Restores 70 HP and boosts Attack for 3 minutes.";
	
	itemType = "food";
	
	--> handling information <--
	canStack 	= true;
	canBeBound 	= true;
	canAwaken 	= false;

--> shop information <--	
	sellValue = 200; 
	buyValue  = 2000; 
	
	--> stats information <--
	activationEffect = function(player)
		if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.health.Value > 0 then
			local success = network:invoke("applyPotionStatusEffectToEntityManifest_server", player.Character.PrimaryPart, 70, nil, "item", 6)
			
			if not success then return false, "failed to give health" end
			
			local wasApplied, reason = network:invoke("applyStatusEffectToEntityManifest", player.Character.PrimaryPart, "empower", {
				duration = 3 * 60;
				
				modifierData = {
					equipmentDamage = 5;
				};
			}, player.Character.PrimaryPart, "item", item.id)
			
			return wasApplied, reason
		end
		
		return false, "Character is invalid."
	end;
	
	stackSize = 32;
	
	--> sorting information <--
	isImportant 	= false;
	category 		= "consumable";
}

return item