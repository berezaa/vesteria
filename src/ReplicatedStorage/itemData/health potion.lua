local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")

return {
	--> identifying information <--
	id 		= 6;
	
	--> generic information <--
	name 		= "Red Potion";
	rarity 		= "Common";
	image 		= "rbxassetid://2528902180";
	description = "A vibrant potion";
	
	customTag = { 
		{text = "Restores"; font = Enum.Font.SourceSans; textColor3 = Color3.fromRGB(160,160,160); textSize = 19; textTransparency = 0};
		{text = "25 HP"; font = Enum.Font.SourceSansBold; textColor3 = Color3.fromRGB(226,34,40); textSize = 19; textTransparency = 0};
		{text = "after"; font = Enum.Font.SourceSans; textColor3 = Color3.fromRGB(160,160,160); textSize = 19; textTransparency = 0};
		{text = "1s"; font = Enum.Font.SourceSansBold; textColor3 = Color3.fromRGB(160,160,160); textSize = 19; textTransparency = 0};
	};
	
	itemType = "potion";
	
	useSound 	= "potion";
	
	--> stats information <--
	activationEffect = function(player)
		print(
			player.Character,
			player.Character.PrimaryPart,
			player.Character.PrimaryPart.health.Value, 
			player.Character.PrimaryPart.maxHealth.Value
		)

		if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.health.Value > 0 and player.Character.PrimaryPart.health.Value < player.Character.PrimaryPart.maxHealth.Value then
			local success = network:invoke("applyPotionStatusEffectToEntityManifest_server", player.Character.PrimaryPart, 25, nil, "item", 6)
			
			return success, success and "You feel refreshed." or "ERRORRRR"
		end
		
		return false, "Character is invalid."
	end;
	
	stackSize = 32;
	
	--> shop information <--
	buyValue = 50;
	sellValue = 20;
	
	--> handling information <--
	canStack 	= true;
	canBeBound 	= true;
	canAwaken 	= false;
	
	--> sorting information <--
	isImportant 	= false;
	category 		= "consumable";
}