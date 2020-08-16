local module = {}

local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network = modules.load("network")
		local itemLookup = require(game.ReplicatedStorage:WaitForChild("itemData"))

module.tierColors = {
	[-1] = Color3.new(0.7,0.7,0.7);
	[1] = Color3.new(1,1,1);
	[2] = Color3.fromRGB(112, 241, 255);
	[3] = Color3.fromRGB(165, 55, 255);
	[4] = Color3.fromRGB(235, 42, 87);
	[5] = Color3.fromRGB(255, 238, 0);
	[6] = Color3.fromRGB(0, 255, 0);
}

function module.enchantmentCanBeAppliedToItem(enchantmentSlotData, equipmentSlotData)
	-- returns bool canEnchant, int enchantmentIndexToRemove
	local enchantmentBaseData = itemLookup[enchantmentSlotData.id]
	local equipmentBaseData = itemLookup[equipmentSlotData.id]

	if equipmentSlotData.notUpgradable or equipmentBaseData.notUpgradable then
		return false
	end

	if enchantmentBaseData.validation then
		if not enchantmentBaseData.validation(equipmentBaseData, equipmentSlotData) then
			-- blocked by scroll validation function
			return false
		end
	end

	local upgradeCost = enchantmentBaseData.upgradeCost or 1
	local maxUpgrades = (equipmentBaseData.maxUpgrades or 0) + (equipmentSlotData.bonusUpgrades or 0)

	local enchantments = equipmentSlotData.enchantments or {}

	local existingUpgrades = equipmentSlotData.upgrades or 0
	if existingUpgrades + upgradeCost <= maxUpgrades then
		return true
	--[[
	else

		-- allow higher-tier scrolls to override weaker upgrades
		local lowestTier = 999
		local index
		for i,enchantment in pairs(enchantments) do
			local existingEnchantmentBaseData = itemLookup[enchantment.id]
			local tier = existingEnchantmentBaseData.enchantments[enchantment.state].tier or 1
			if tier < lowestTier then
				lowestTier = tier
				index = i
			end
		end
		if (enchantmentBaseData.tier - 1) > lowestTier then
			return true, index
		end
	]]
	end
end



-- everything below this is pretty much defunct







	local costMulti = {2/3, 3/2, 3, 5, 8, 10, 15}

	module.enchantmentPrice = function(itemInventorySlotData)
		if not itemInventorySlotData then
			return false
		end

		local previousEnchants = itemInventorySlotData.enchantments or 0
		local itemLookup = require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))
		local itemBaseData = itemLookup[itemInventorySlotData.id]

		if itemInventorySlotData.upgrades and itemInventorySlotData.upgrades >= 7 then
			return false
		end

		if not itemBaseData.buyValue then
			return false
		end

		if itemBaseData.category == "equipment" then
			return math.ceil(itemBaseData.buyValue * costMulti [(itemInventorySlotData.upgrades or 0) + 1])
		end
	end


	module.applyEnchantment = function(itemInventorySlotData)
		local itemLookup = require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))
		local itemBaseData = itemLookup[itemInventorySlotData.id]

		if itemInventorySlotData.upgrades and itemInventorySlotData.upgrades >= 7 then
			return false
		end

		if itemBaseData.category == "equipment" then

			if not itemInventorySlotData.modifierData then
				itemInventorySlotData.modifierData = {}
			end

			if not itemBaseData.buyValue then
				return false
			end

			local modifierData = itemBaseData.modifierData and itemBaseData.modifierData[1] or {}

			local upgrades = {}


			local doBlessItem = itemInventorySlotData.enchantments and (itemInventorySlotData.enchantments + 1) == 7

			if not itemInventorySlotData.modifierData then
				itemInventorySlotData.modifierData = {}
			end



			if itemBaseData.equipmentSlot == 1 then

				local modifierData = itemBaseData.modifierData and itemBaseData.modifierData[1] or {}
				local damage = (itemBaseData.baseDamage and itemBaseData.baseDamage > 0 and itemBaseData.baseDamage or 1)
									+ (modifierData.rangedDamage or 0) * 0.65
									+ (modifierData.magicalDamage or 0) * 0.65
									+ (modifierData.physicalDamage or 0) * 0.65


				local multi = 0.06

				if doBlessItem and not itemBaseData.blessedUpgrade then
					itemInventorySlotData.blessed = true
					multi = 0.09
				end

				local damageBuff = math.clamp(math.floor((damage or 1) * multi), 1, math.huge)


				upgrades["baseDamage"] = damageBuff;

			elseif itemBaseData.equipmentSlot == 2 or itemBaseData.equipmentSlot == 8 or itemBaseData.equipmentSlot == 9 then

				local modifierData = itemBaseData.modifierData and itemBaseData.modifierData[1] or {}

				local baseDefense = (modifierData.defense and modifierData.defense > 0 and modifierData.defense or 1)
									+ (modifierData.rangedDefense or 0) * 0.65
									+ (modifierData.magicalDefense or 0) * 0.65
									+ (modifierData.physicalDefense or 0) * 0.65

									+ (modifierData.rangedDamage or 0) * 0.55
									+ (modifierData.magicalDamage or 0) * 0.55
									+ (modifierData.physicalDamage or 0) * 0.55
									+ (modifierData.equipmentDamage or 0) * 0.75

				local multi = 0.06

				if doBlessItem and not itemBaseData.blessedUpgrade then
					itemInventorySlotData.blessed = true
					multi = 0.09
				end

				local defensebuff = math.clamp(math.floor((baseDefense or 1) * multi), 1, math.huge)


				upgrades["defense"] = defensebuff;


			else
				return false
			end

			if doBlessItem and itemBaseData.blessedUpgrade then
				for upgradeName, upgradeValue in pairs(itemBaseData.blessedUpgrade) do
					upgrades[upgradeName] = (upgrades[upgradeName] or 0) + upgradeValue
				end
				itemInventorySlotData.blessed = true
			end






			--[[
			local baseDefense = (modifierData.defense and modifierData.defense > 0 and modifierData.defense or 1)
								+ (modifierData.rangedDefense or 0) * 0.65
								+ (modifierData.magicalDefense or 0) * 0.65
								+ (modifierData.physicalDefense or 0) * 0.65

								+ (modifierData.rangedDamage or 0) * 0.55
								+ (modifierData.magicalDamage or 0) * 0.55
								+ (modifierData.physicalDamage or 0) * 0.55
								+ (modifierData.equipmentDamage or 0) * 0.75
			]]
			--[[
			table.insert(itemInventorySlotData.modifierData, {
				defense = math.clamp(math.floor((baseDefense or 1) * 0.05), 1, math.huge)
			})
			]]

			table.insert(itemInventorySlotData.modifierData, upgrades)

						itemInventorySlotData.upgrades = (itemInventorySlotData.upgrades or 0) + 1
						itemInventorySlotData.successfulUpgrades = (itemInventorySlotData.successfulUpgrades or 0) + 1
						itemInventorySlotData.enchantments = (itemInventorySlotData.enchantments or 0) + 1

			return itemInventorySlotData
		end

		return nil
	end;

return module
