

return {
	--> identifying information <--
	id 		= 61;
	
	--> generic information <--
	name 		= "Basic Headgear Scroll (100%)";
	rarity 		= "Rare";
	image 		= "rbxassetid://2528903584";
	description = "A magical scroll that has the ability to increase a headgear's stats.";
	
	enchantments = {
		[1] = {modifierData = {}; statUpgrade = 1; selectionWeight = 1; tier = 1};
	};	
	tier = 2;	
	
	--> stats information <--
	successRate = 1;
	
	validation = function(itemBaseData, inventorySlotData)
		if itemBaseData.category == "equipment" and itemBaseData.equipmentSlot == 2 then			
			return true
		end		
		return false		
	end;	
	
	applyScroll = function(player, itemInventorySlotData, successfullyScrolled)
		local itemLookup = require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))
		local itemBaseData = itemLookup[itemInventorySlotData.id]		
		if itemBaseData.category == "equipment" and itemBaseData.equipmentSlot == 2 then			
			return true
		end		
		return false
	end;	
	
	
	--> shop information <--
	buyValue = 10000;
	sellValue = 700;
	
	--> handling information <--
	canStack 			= false;
	canBeBound 			= false;
	canAwaken 			= false;
	enchantsEquipment 	= true;
	
	--> sorting information <--
	isImportant 	= true;
	category 		= "consumable";
}