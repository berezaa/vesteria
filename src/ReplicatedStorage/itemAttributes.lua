local function stat(itemBaseData, inventorySlotData, multi)
	multi = multi or 1
	local level = itemBaseData.minLevel or 1
	local itemType = itemBaseData.equipmentSlot
	local typeScaleMulti = (itemType == 1 and 0.75) or (itemType == 8 and 1) or 1.5
	return math.ceil((multi * level) / (5 * typeScaleMulti))
end

local attributes = {
	
	-- hats only
	worn = {
		prefix = "Worn";
		color = Color3.fromRGB(148, 148, 148);
		valueMulti = 0.75;
		modifier = function(itemBaseData, inventorySlotData)
			local penalty = -stat(itemBaseData, inventorySlotData, 0.5)
			-- ??
		end;			
	};
	
	-- armor only
	tattered = {
		prefix = "Tattered";
		color = Color3.fromRGB(148, 148, 148);
		valueMulti = 0.75;
		modifier = function(itemBaseData, inventorySlotData)
			return {defense = -(stat(itemBaseData, inventorySlotData)+1)}
		end;			
	};
	
	-- weapons only
	dull = {
		prefix = "Dull";
		color = Color3.fromRGB(148, 148, 148);
		valueMulti = 0.75;
		modifier = function(itemBaseData, inventorySlotData)
			return {baseDamage = -(stat(itemBaseData, inventorySlotData, 0.75)+1)}
		end;		
	};
	
	keen = {
		prefix = "Keen";
		color = Color3.fromRGB(135, 186, 213);
		valueMulti = 1.25;
		modifier = function(itemBaseData, inventorySlotData)
			return {int = stat(itemBaseData, inventorySlotData)}
		end;		
	};
	
	fierce = {
		prefix = "Fierce";
		color = Color3.fromRGB(190, 143, 109);
		valueMulti = 1.25;
		modifier = function(itemBaseData, inventorySlotData)
			return {str = stat(itemBaseData, inventorySlotData)}
		end;				
	};
	
	swift = {
		prefix = "Swift";
		color = Color3.fromRGB(190, 130, 179);
		valueMulti = 1.25;
		modifier = function(itemBaseData, inventorySlotData)
			return {dex = stat(itemBaseData, inventorySlotData)}
		end;		
	};
	
	vibrant = {
		prefix = "Vibrant";
		color = Color3.fromRGB(194, 127, 128);
		valueMulti = 1.25;
		modifier = function(itemBaseData, inventorySlotData)
			return {vit = stat(itemBaseData, inventorySlotData)}
		end;		
	};
	
	pristine = {
		prefix = "Pristine";
		color = Color3.fromRGB(150, 45, 202);
		valueMulti = 1.75;
		modifier = function(itemBaseData, inventorySlotData)
			local itemType = itemBaseData.equipmentSlot
			if itemType == 1 then
				return {
					baseDamage = stat(itemBaseData, inventorySlotData, 0.75 * 0.7);
					wisdom = stat(itemBaseData, inventorySlotData, 0.4)/100;
				}
			elseif itemType == 8 then
				return {
					defense = stat(itemBaseData, inventorySlotData, 0.7);
					wisdom = stat(itemBaseData, inventorySlotData, 0.4)/100;
				}
			end
		end;		
		
	};
	
	legendary = {
		prefix = "Legendary";
		color = Color3.fromRGB(225, 176, 28);
		valueMulti = 3;
		modifier = function(itemBaseData, inventorySlotData)
			local itemType = itemBaseData.equipmentSlot
			if itemType == 1 then
				return {
					baseDamage = stat(itemBaseData, inventorySlotData, 0.75 * 1.2);
					wisdom = stat(itemBaseData, inventorySlotData, 0.6)/100;
				}
			elseif itemType == 8 then
				return {
					defense = stat(itemBaseData, inventorySlotData, 1.2);
					wisdom = stat(itemBaseData, inventorySlotData, 0.6)/100;
				}
			end
		end;			
	};
		
}

return attributes
