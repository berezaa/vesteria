local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network = modules.load("network")

return {
	--> identifying information <--
	id 		= 1;
	
	--> generic information <--
	name 		= "Mushcoin";
	rarity 		= "Common";
	image 		= "rbxassetid://2535600080";
	description = "The main currency of Vesteria";
	
	useSound 	= "coins";	
	--> stats information <--
	activationEffect = function(player, physItem)
		local value = physItem:FindFirstChild("itemValue") and physItem.itemValue.Value or 1
		local source = physItem:FindFirstChild("itemSource") and physItem.itemSource.Value
		local playerData = network:invoke("getPlayerData", player)
		if playerData then
			
			local totalStats = network:invoke("getPlayerData", player).nonSerializeData.statistics_final
			local greed = totalStats and totalStats.greed or 1			
			
			local amount = math.floor(value * greed)
			
			playerData.nonSerializeData.incrementPlayerData("gold", amount, source)
			
			return true, "Successfully gained "..value.." coins!", amount
		end
		
		return false, "Can't consume this right now", 0
	end;
	
	--> handling information <--
	canStack 	= true;
	canBeBound 	= false;
	canAwaken 	= false;
	autoConsume = true;
	
	--> sorting information <--
	isImportant 	= false;
	category 		= "consumable";
}