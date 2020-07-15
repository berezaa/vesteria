--[[
	itemData {}
		--> identifying information <--
		int id
		
		--> generic information <--
		string name
		string rarity
		string image
		string description
		
		--> tool information <--
		CFrame grip
		
		--> stats information <--
		number baseDamage
		bonusStats {}
			int str = 0
			int sta = 0
			int dex = 0
			int int = 0
			
			number cdrPercentage 	= 0
			number cdrFlat 			= 0
			
			number dmgPercent 	= 0
			number dmgFlat 		= 0
			
			number hpPercent 	= 0;
			number hpFlat 		= 0;
			
			number expPercent 	= 0;
			number expFlat 		= 0;
			
			number defenseFlat = nil;
		
		--> handling information <--
		bool canStack 	= true
		bool canBeBound = false
		bool canAwaken 	= false
		
		--> sorting information <--
		bool isImportant 	= false
		string category 	= "miscellaneous" ["equipment", "consumable", "miscellaneous"]
--]]

local collectionService = game:GetService("CollectionService")

-- doing a direct require here to avoid a circular require problem
local levels = require(game.ReplicatedStorage:WaitForChild("modules"):WaitForChild("levels"))

local highest = 0
local lookupTable = {} do
	for i, itemDataModule in pairs(script:GetChildren()) do
		
		-- automatically fix up bad items
		if itemDataModule:FindFirstChild("container") then
			for i, part in pairs(itemDataModule.container:GetChildren()) do
				if part:IsA("BasePart") then
					if part.Name == "Head" then
						part.Transparency = 1
					else
						part.Material = "Glass"
						part.Transparency = 0.5
						part.Reflectance = 0.2
						part.Color = Color3.new(1,1,1)						
					end

					if collectionService:HasTag(part, "interact") then
						collectionService:RemoveTag(part, "interact")
					end
				end
			end
		end
			
		local itemData = require(itemDataModule)
		
		if itemData.category == "equipment" then
			
			-- determine the amount of an upgrades an item can have based on its rarity and time
			local maxUpgrades = 0
			if itemData.equipmentSlot == 1 or itemData.equipmentSlot == 8 then
				maxUpgrades = 7
			elseif itemData.equipmentSlot == 2 then
				maxUpgrades = 3
			end
			
			if itemData.equipmentType == "greatsword" then
--				itemData.minimumClass = "paladin"
			elseif itemData.equipmentType == "shield" then
--				itemData.minimumClass = "knight"
			end
			--[[
			local equipInfo = levels.getEquipmentInfo(itemData)		
			if equipInfo then	
				if equipInfo.cost then
					itemData.buyValue = itemData.cost or math.ceil(equipInfo.cost * (itemData.valueMulti or 1))
					itemData.sellValue = itemData.cost and itemData.cost * 0.2 or math.ceil(equipInfo.cost * 0.2)
				end
				if equipInfo.damage then
					itemData.baseDamage = math.ceil(equipInfo.damage * (itemData.damageMulti or 1))
				end
				if equipInfo.defense then
					itemData.modifierData = itemData.modifierData or {{}}
					itemData.modifierData[1] = itemData.modifierData[1] or {}
					itemData.modifierData[1].defense = (itemData.modifierData[1].defense or 0) + math.ceil(equipInfo.defense * (itemData.defenseMulti or 1))
				end
				if equipInfo.modifierData then
					itemData.modifierData = itemData.modifierData or {}
					table.insert(itemData.modifierData, equipInfo.modifierData)
				end
				if equipInfo.statUpgrade then
					itemData.statUpgrade = itemData.statUpgrade or equipInfo.statUpgrade
				end
			end
			
			if itemData.perks then
				-- items with perks get blue tier by default
				itemData.tier = itemData.tier or 2
			end
			]]
			itemData.maxUpgrades = itemData.maxUpgrades or maxUpgrades
		end
		
		-- item categorization for icons
		local itemType = "misc"
		if itemData.category == "equipment" then
			if itemData.equipmentSlot == 1 then
				itemType = itemData.equipmentType or "sword"
			end
		elseif itemData.category == "consumable" then
			if itemData.applyScroll then
				itemType = "scroll"
			end
		end
		itemData.itemType = itemData.itemType or itemType
		
		
		
		
		
--		if itemData.category == "equipment" and itemData.canStack then
--			error(itemDataModule.Name .. " should not be allowed to stack")
--		end
		
		if itemDataModule:FindFirstChild("container") and not itemDataModule.container.PrimaryPart then
			itemDataModule.container.PrimaryPart = itemDataModule.container:FindFirstChildWhichIsA("BasePart")
		end
		
		-- internal stuff
		itemData.module = itemDataModule
		
		-- hook ups, check for conflicts..
		if lookupTable[itemData.id] then
			warn("CONFLICT OF ITEM IDS @", itemData.id, itemData.name, lookupTable[itemData.id].name)
		end
		
		lookupTable[itemData.id] 			= itemData
		lookupTable[itemDataModule.Name] 	= itemData
		
		if itemData.id > highest then
			highest = itemData.id
		end
		
	end
end
		
print("HIGHEST ID >>>", highest)

return lookupTable