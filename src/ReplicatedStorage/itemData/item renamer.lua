-- prevents requiring the modules outside of runtime
-- a problem for future me to deal with


--local disallowedWhiteSpace = {"\n", "\r", "\t", "\v", "\f"}

--local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
--local network = modules.load("network")

return {
	--> identifying information <--
	id 		= 103;
	
	--> generic information <--
	name 		= "Name Tag";
	nameColor	= Color3.fromRGB(237, 98, 255);
	rarity 		= "Legendary";
	image 		= "rbxassetid://2858147882";
	description = "Give a piece of equipment a special name.";
	
	--> stats information <--
	successRate = 1;
	upgradeCost = 0;
	playerInputFunction = function()
		local playerInput = {}
		playerInput.desiredName = network:invoke("textInputPrompt", {prompt = "Name your item..."})
		return playerInput
	end;
	applyScroll = function(player, itemInventorySlotData, successfullyScrolled, playerInput)
		local itemLookup = require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))
		local itemBaseData = itemLookup[itemInventorySlotData.id]
		
		if not playerInput then 
			return false, "no player input"
		end
		
		if itemBaseData.category == "equipment" then
			if successfullyScrolled then
				local desiredName = playerInput.desiredName

				if not desiredName then
					return false, "desired item name not provided"
				end
				
				if #desiredName > 30 then
					return false, "Item name cannot be longer than 30 characters."
				end

				-- eliminate white space				
				for i,whitespace in pairs(disallowedWhiteSpace) do
					if string.find(desiredName, whitespace) then
						return false, "Item name cannot contain whitespace characters."
					end
				end				
				
				if #desiredName < 3 then
					return false, "Item name must be at least 3 characters long."
				end				
				
				local filteredText
				
				local filterSuccess, filterError = pcall(function()
					filteredText = game.Chat:FilterStringForBroadcast(desiredName, player)
				end)
				
				if not filterSuccess then
					return false, "filter error: "..filterError
				end		
				
				if not filteredText or string.find(filteredText, "#") then
					return false, "Item name rejected by Roblox filter."
				end
				
				-- if we've gotten this far, we must be good
				itemInventorySlotData.customName = filteredText
				return true, "Item renamed"
				
					
			end
		end
		
		return false, "Only equipment can be re-named."
	end;
	
	--> shop information <--
	buyValue = 2000000;
	sellValue = 1000;
	
	--> handling information <--
	canStack 			= false;
	canBeBound 			= false;
	canAwaken 			= false;
	enchantsEquipment 	= true;
	
	--> sorting information <--
	isImportant 	= true;
	category 		= "consumable";
}