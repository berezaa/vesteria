local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")

return {
	--> identifying information <--
	id 		= 22;
	
	--> generic information <--
	name 		= "Blue Potion";
	rarity 		= "Common";
	image 		= "rbxassetid://2528903811";
	description = "A magical potion";
	
	customTag = { 
		{text = "Restores"; font = Enum.Font.SourceSans; textColor3 = Color3.fromRGB(160,160,160); textSize = 19; textTransparency = 0};
		{text = "25 MP"; font = Enum.Font.SourceSansBold; textColor3 = Color3.fromRGB(0, 152, 255); textSize = 19; textTransparency = 0};
		{text = "after"; font = Enum.Font.SourceSans; textColor3 = Color3.fromRGB(160,160,160); textSize = 19; textTransparency = 0};
		{text = "1s"; font = Enum.Font.SourceSansBold; textColor3 = Color3.fromRGB(160,160,160); textSize = 19; textTransparency = 0};
	};	
	
	itemType = "potion";
	
	useSound 	= "potion";
	
	--> stats information <--
	activationEffect = function(player)
		if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.mana.Value < player.Character.PrimaryPart.maxMana.Value then
			local success, reason = network:invoke("applyPotionStatusEffectToEntityManifest_server", player.Character.PrimaryPart, nil, 50, "item", 22)			
			
			return success, success and "You feel recharged." or reason
		end
		
		return false, "Character is invalid."
	end;
	
	stackSize = 32;
	
	--> shop information <--
	buyValue = 70;
	sellValue = 30;
	
	--> handling information <--
	canStack 	= true;
	canBeBound 	= true;
	canAwaken 	= false;
	
	--> sorting information <--
	isImportant 	= false;
	category 		= "consumable";
}