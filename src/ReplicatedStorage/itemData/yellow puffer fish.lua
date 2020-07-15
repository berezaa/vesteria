local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")

return {
	--> identifying information <--
	id 		= 39;

	--> generic information <--
	name 		= "Yellow Pufferfish";
	rarity 		= "Common";
	image 		= "rbxassetid://2539240983";
	description = "You probably don't want to eat this fish.";
	
	itemType = "fish";
	
	useSound 	= "eat_food";
	
	--> stats information <--
	activationEffect = function(player)
		if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.health.Value > 0 then
			
			player.Character.PrimaryPart.health.Value = player.Character.PrimaryPart.health.Value - 500

			if player.Character.PrimaryPart.health.Value <= 0 then
				local text = "☠ " .. player.Name .. " ate a Yellow Pufferfish ☠"
				network:fireAllClients("signal_alertChatMessage", {
					Text = text,
					Font = Enum.Font.SourceSansBold,
					Color = Color3.fromRGB(255, 130, 100),
				})					
			end
			
			return true, "You feel refreshed."
		end
		
		return false, "Character is invalid."
	end;
	
	--> shop information <--
	buyValue = 1000;
	sellValue = 500;	
	
	--> handling information <--
	canStack 	= true;
	canBeBound 	= true;
	canAwaken 	= false;
	
	--> sorting information <--
	isImportant 	= false;
	category 		= "consumable";
}