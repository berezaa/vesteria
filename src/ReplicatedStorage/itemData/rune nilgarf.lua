local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")

return {
	--> identifying information <--
	id 		= 149;
	
	--> generic information <--
	name 		= "Nilgarf Rune";
	rarity 		= "Common";
	image 		= "rbxassetid://3185379989";
	description = "A magical gemstone that can be used to return to Nilgarf.";
	
	useSound 	= "fireIgnite";
	
	consumeTime = 0;
	
	--> stats information <--
	askForConfirmationBeforeConsume = true;	
	activationEffect 				= function(player)
		if player:FindFirstChild("teleportRune") == nil  and player:FindFirstChild("teleporting") == nil and player:FindFirstChild("DataSaveFail") == nil then
			
			local tag = Instance.new("BoolValue")
			tag.Name = "teleportRune"
			tag.Parent = player			
			
			if game.GameId == 712031239 then
				-- demo
				delay(0.2, function() network:invoke("teleportPlayer_rune", player, 4042577479) end)
			else
				delay(0.2, function() network:invoke("teleportPlayer_rune", player, 2119298605) end)
			end
			return true, "teleport queued"
		end
		
		return false, "Character is invalid."
	end;	
	
	--> shop information <--
	buyValue = 4000;
	sellValue = 300;
	
	--> handling information <--
	canStack 	= true;
	canBeBound 	= true;
	canAwaken 	= false;
	
	--> sorting information <--
	isImportant 	= false;
	category 		= "consumable";
}