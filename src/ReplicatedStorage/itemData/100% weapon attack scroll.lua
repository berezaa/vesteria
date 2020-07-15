return {
	--> identifying information <--
	id 		= 14;
	
	--> generic information <--
	name 		= "Basic Weapon ATK Scroll (100%)";
	rarity 		= "Rare";
	image 		= "rbxassetid://2528903584";
	description = "A magical scroll that has the ability to increase a weapon's attack power.";
	
	enchantments = {
		[1] = {modifierData = {baseDamage = 1}; selectionWeight = 1; tier = 1};
	};
	
	tier = 2;
	
	validation = function(itemBaseData, inventorySlotData)
		if itemBaseData.category == "equipment" and itemBaseData.equipmentSlot == 1 then				
			return true
		end		
		return false		
	end;	
	
	--> stats information <--
	successRate = 1;
	applyScroll = function(player, itemInventorySlotData, successfullyScrolled, playerInput, _scrData)
		local itemLookup 	= require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))
		local itemBaseData 	= itemLookup[itemInventorySlotData.id]
		if itemBaseData.category == "equipment" and itemBaseData.equipmentSlot == 1 then			
			return true
		end
		return false
	end;
	
	--> shop information <--
	buyValue = 15000;
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