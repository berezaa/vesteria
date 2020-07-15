local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")

return {
	--> identifying information <--
	id 		= 30;

	--> generic information <--
	name 		= "Fresh Fish";
	rarity 		= "Common";
	image 		= "rbxassetid://2528901664";
	description = "A tasty freshly-caught fish that restores 100 HP & MP.";
	
	itemType = "fish";
	
	useSound 	= "eat_food";
	
	--> stats information <--
	activationEffect = function(player)
		if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.health.Value > 0 then
			if (player.Character.PrimaryPart.mana.Value < player.Character.PrimaryPart.maxMana.Value or player.Character.PrimaryPart.health.Value < player.Character.PrimaryPart.maxHealth.Value) then
				network:invoke("applyPotionStatusEffectToEntityManifest_server", player.Character.PrimaryPart, 100, 100, "item", 6)
			end
			
			return true, "You feel refreshed."
		end
		
		return false, "Character is invalid."
	end;
	
	--> shop information <--
	buyValue = 300;
	sellValue = 80;	
	
	--> handling information <--
	canStack 	= true;
	canBeBound 	= true;
	canAwaken 	= false;
	
	--> sorting information <--
	isImportant 	= false;
	category 		= "consumable";
}