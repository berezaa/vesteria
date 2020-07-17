local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = require(ReplicatedStorage.modules)
local Network = Modules.load("network")

local numberGenerator_enchantment = Random.new()
-- item location view is either "inventory" or "equipment"
local function onEnchantEquipmentRequestReceived(player, enchantmentInventorySlotDataFromPlayer, equipmentInventorySlotDataFromPlayer, itemLocationView, playerInput)
	itemLocationView = itemLocationView or "inventory"

	local playerData = network:invoke("getPlayerData", player)
	if playerData and equipmentInventorySlotDataFromPlayer.id and (itemLocationView == "inventory" or itemLocationView == "equipment") then
		local itemLocationViewSlot_equipment, itemLocationViewSlotData_equipment do
			if (itemLocationView == "inventory") then
				itemLocationViewSlot_equipment, itemLocationViewSlotData_equipment = getTrueInventorySlotDataByInventorySlotDataFromPlayer(player, equipmentInventorySlotDataFromPlayer)
			elseif (itemLocationView == "equipment") then
				itemLocationViewSlot_equipment, itemLocationViewSlotData_equipment = getTrueEquipmentSlotDataByEquipmentSlotDataFromPlayer(player, equipmentInventorySlotDataFromPlayer)
			end
		end

		if not itemLocationViewSlotData_equipment then
			return false, "could not find equipment to encahnt"
		end

		if typeof(enchantmentInventorySlotDataFromPlayer) == "Instance" and enchantmentInventorySlotDataFromPlayer:FindFirstChild("itemEnchanted") then
			-- enchant menu
			local itemBaseData_equipment = itemLookup[itemLocationViewSlotData_equipment.id]
			local cost = enchantment.enchantmentPrice(itemLocationViewSlotData_equipment)

			if not cost then
				return false, "invalid enchantment item"
			end

			if not (playerData.gold >= cost) then -- structured this way to prevent nonsense with NaN
				return false, "not enough monies"
			end

			if (itemLocationViewSlotData_equipment.upgrades or 0) >= (itemLocationViewSlotData_equipment.maxUpgrades or 7) then
				return false, "max upgraded"
			end

			local success = enchantment.applyEnchantment(itemLocationViewSlotData_equipment)

			if success then
				local wasSpent = network:invoke("tradeItemsBetweenPlayerAndNPC", player, {}, cost, {}, 0, "etc:enchant")
				if not wasSpent then
					Network:invoke("reportError", player, "error", "Enchantment went through but money wasn't spent??")
				end
				if itemLocationView == "equipment" then
					playerData.nonSerializeData.playerDataChanged:Fire("equipment")
				else
					playerData.nonSerializeData.playerDataChanged:Fire("inventory")
				end


				enchantmentInventorySlotDataFromPlayer.itemEnchanted:Play()
				if enchantmentInventorySlotDataFromPlayer:FindFirstChild("steady") then
					enchantmentInventorySlotDataFromPlayer.steady:Emit(50)
				end

				if itemLocationViewSlotData_equipment.blessed then
					Network:fireAllClients("signal_alertChatMessage", {Text = player.Name .. "'s ".. (itemBaseData_equipment.name or "equipment") .." is blessed by The Orb."; Font = Enum.Font.SourceSansBold; Color = Color3.fromRGB(0, 81, 255)}	)
				end

				return true
			end

			return false, "idk what went wrong"
		elseif enchantmentInventorySlotDataFromPlayer.id then
			-- scroll item
			local itemBaseData_enchantment = itemLookup[enchantmentInventorySlotDataFromPlayer.id]
			local itemBaseData_equipment = itemLookup[equipmentInventorySlotDataFromPlayer.id]

			if not itemLocationViewSlotData_equipment.enchantments then
				itemLocationViewSlotData_equipment.enchantments = {}
			end

			if itemBaseData_enchantment and itemBaseData_enchantment.enchantsEquipment and itemBaseData_enchantment.applyScroll and itemBaseData_equipment then
				local trueInventorySlot_enchantment, inventorySlotData_enchantment = getTrueInventorySlotDataByInventorySlotDataFromPlayer(player, enchantmentInventorySlotDataFromPlayer)

				if inventorySlotData_enchantment and itemLocationViewSlotData_equipment then
					local upgradeCost = itemBaseData_enchantment.upgradeCost or 1
					local canEnchant, indexToRemove = enchantment.enchantmentCanBeAppliedToItem(inventorySlotData_enchantment, itemLocationViewSlotData_equipment)

					if canEnchant then
						local successfullyApplyScroll = numberGenerator_enchantment:NextNumber() <= itemBaseData_enchantment.successRate
						-- .applyScroll is still used on state scrolls to determine if the equipment matches
						local success, statusText, additionalInfo = itemBaseData_enchantment.applyScroll(player, itemLocationViewSlotData_equipment, successfullyApplyScroll, playerInput, itemBaseData_enchantment)

						additionalInfo = additionalInfo or {}

						if additionalInfo.successfullyApplied ~= nil then
							successfullyApplyScroll =  additionalInfo.successfullyApplied
						end

						local status

						if success then
							table.remove(playerData.inventory, trueInventorySlot_enchantment)

							local itemDestroyed

							if successfullyApplyScroll then
								if itemBaseData_enchantment.enchantments then
									local enchantmentWeightTable = {}
									for i, enchantment in pairs(itemBaseData_enchantment.enchantments) do
										if enchantment.selectionWeight and enchantment.selectionWeight > 0 then
											if not enchantment.manual then
												table.insert(enchantmentWeightTable, enchantment)
											end
										end
									end

									local selection, index = utilities.selectFromWeightTable(enchantmentWeightTable)

									local trueIndex
									for i, enchantment in pairs(itemBaseData_enchantment.enchantments) do
										if enchantment == selection then
											trueIndex = i
										end
									end

									if selection and trueIndex then

										--local upgradeTier = itemBaseData_enchantment.enchantments[index].tier or 1
										--local tierColor = enchantment.tierColors[upgradeTier + 1]
										local tierColor = Color3.fromRGB(112, 241, 255)
										status = {Text = "The magic scroll lights up and its power is transferred to your equipment."; Color = additionalInfo.textColor3 or tierColor; Font = Enum.Font.SourceSansBold}


										-- if a weaker upgrade is overridden
										-- (this no longer occurs)
										if indexToRemove then
											status = {Text = "The scroll lights up and its power replaces an existing upgrade on your equipment."; Color = additionalInfo.textColor3 or tierColor; Font = Enum.Font.SourceSansBold}
											table.remove(itemLocationViewSlotData_equipment.enchantments, indexToRemove)
										end

										table.insert(itemLocationViewSlotData_equipment.enchantments, {
											id 		= itemBaseData_enchantment.id;
											state 	= trueIndex;
										})
									else
										error("Enchantment data state not found!")
									end
								end
							else
								-- scroll failed and it wants to destroy the item
								if itemBaseData_enchantment.destroyItemOnFail and numberGenerator_enchantment:NextNumber() <= (itemBaseData_enchantment.destroyItemRate or 1) then
									-- update position
									if (itemLocationView == "inventory") then
										itemLocationViewSlot_equipment, itemLocationViewSlotData_equipment = getTrueInventorySlotDataByInventorySlotDataFromPlayer(player, equipmentInventorySlotDataFromPlayer)
									elseif (itemLocationView == "equipment") then
										itemLocationViewSlot_equipment, itemLocationViewSlotData_equipment = getTrueEquipmentSlotDataByEquipmentSlotDataFromPlayer(player, equipmentInventorySlotDataFromPlayer)
									end

									status = {Text = "The magic scroll's curse destroys your equipment."; Color = additionalInfo.textColor3 or Color3.fromRGB(255, 96, 99); Font = Enum.Font.SourceSansBold}
									if itemLocationView == "inventory" then
										table.remove(playerData.inventory, itemLocationViewSlot_equipment)
									elseif itemLocationView == "equipment" then
										table.remove(playerData.equipment, itemLocationViewSlot_equipment)
									end
									itemDestroyed = true
								else
									-- let a state of -1 indicate a failed upgrade
									if itemBaseData_enchantment.enchantments then
										table.insert(itemLocationViewSlotData_equipment.enchantments, {
											id 		= itemBaseData_enchantment.id;
											state 	= -1;
										})
									end
									status = {Text = "The magic scroll lights up and explodes into tiny shreds."; Color = additionalInfo.textColor3 or Color3.fromRGB(167, 167, 167); Font = Enum.Font.SourceSansBold}
								end
							end

							if not itemDestroyed then
								-- update the upgrades on the item
								local upgrades = 0
								local successfulUpgrades = 0
								for i, enchantmentData in pairs(itemLocationViewSlotData_equipment.enchantments or {}) do
									local enchantmentSource = itemLookup[enchantmentData.id]
									local upgradeCost = enchantmentSource.upgradeCost or 1
									local enchant = enchantmentSource.enchantments[enchantmentData.state]
									if enchant and enchant.manual then
										upgradeCost = 0
									end
									upgrades = upgrades + upgradeCost
									-- state less than 0 indicates a failed upgrade
									if enchantmentData.state >= 0 then
										successfulUpgrades = successfulUpgrades + upgradeCost
									end
								end
								itemLocationViewSlotData_equipment.upgrades = upgrades
								itemLocationViewSlotData_equipment.successfulUpgrades = successfulUpgrades
							end

							if statusText then
								status = {Text = statusText; Color = additionalInfo.textColor3 or Color3.fromRGB(190,190,190); Font = Enum.Font.SourceSansBold}
							end

							playerData.nonSerializeData.playerDataChanged:Fire("inventory")

							-- update item stats if it was equipment
							if itemLocationView == "equipment" then
								playerData.nonSerializeData.playerDataChanged:Fire("equipment")
							end

							Network:fireAllClients("playerAppliedScroll", player, itemBaseData_enchantment.id, successfullyApplyScroll)

							return true, successfullyApplyScroll, itemLocationViewSlotData_equipment, status
						end

						if statusText then
							status = {Text = statusText; Color = additionalInfo.textColor3 or Color3.fromRGB(255, 60, 60); Font = Enum.Font.SourceSansBold}
							return false, false, nil, status
						end

						return false
					end
				end
			end
		end
	end

	return false
end

Network:create("playerRequest_enchantEquipment", "RemoteFunction", "OnServerInvoke", onEnchantEquipmentRequestReceived)

return module