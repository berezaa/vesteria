local module = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
	local itemData = require(replicatedStorage:WaitForChild("itemData"))
	local itemAttributes = require(replicatedStorage:WaitForChild("itemAttributes"))
	local abilityLookup = require(game.ReplicatedStorage:WaitForChild("abilityLookup"))	

local player = game.Players.LocalPlayer
local header = script.Parent.header
local sortCategoryButtonContainer = header.sorts
local content = script.Parent.content
local ui = script.Parent.Parent
	
local scrollingMask = ui.scrollingMask

local tweenService = game:GetService("TweenService")

-- equipment, consumable, miscellaneous
local currentCategoryTab = "equipment"
local lastInventoryDataReceived = nil
local inventorySlotPairing = {}
local abilityPairing = {}
local tweenAnimations 			= {}

local itemUseDebounce = false
module.isEnchantingEquipment = false
script.Parent.scrollPrompt.Visible = false

local inventorySlotData_enchantment = nil

local lastSelected

local playerData

function module.show()
	script.Parent.Visible = not script.Parent.Visible
end
function module.hide()
	script.Parent.Visible = false
end

script.Parent.close.Activated:connect(module.hide)


-- todo: fix
local animationInterface = require(game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("repo"):WaitForChild("animationInterface"))

function module.init(Modules)
	
	local tradeFrame = ui.menu_trade
	local enchantFrame = ui.menu_enchant
	local shopFrame = ui.menu_shop
	local storageFrame = ui.menu_storage
	local equipFrame = ui.menu_equipment
	 
	local network = Modules.network
	local utilities = Modules.utilities
	local uiCreator = Modules.uiCreator
	local tween = Modules.tween
	local enchantment = Modules.enchantment
	local localization = Modules.localization
	local mapping = Modules.mapping
	
	
	network:create("signal_isEnchantingEquipmentSet", "BindableEvent")
	
	function module.setIsEnchantingEquipment(value, inventorySlotData_enchantment)
		module.isEnchantingEquipment = value
		network:fire("signal_isEnchantingEquipmentSet", value, inventorySlotData_enchantment)
	end
	
	local function burst(n)
		local t = (n ^ (1/3)) / 3.5
		for i=1,n do
			spawn(function()
				wait(t * math.random())
				local icon = script.Parent.currency.ethyr.icon:Clone()
				icon.Name = "iconClone"
				icon.Parent = script.Parent.currency.ethyr
				icon.ImageTransparency = 0
				
				local initialX = math.random(-10,10)
				local initialY = math.random(-10,10)
				icon.Position = UDim2.new(0.5, initialX, 0.5, initialY)
				icon.Visible = true
				
				local s = math.random(60,110)/100
				
				tween(icon, {"ImageTransparency", "Position"}, {1, UDim2.new(0.5, initialX + math.random(-100,100) * t, 0.5, initialY + math.random(-100,100) * t)}, s)
				game.Debris:AddItem(icon, s + 0.1)
			end)
		end
	end
	
	
	game.MarketplaceService.PromptProductPurchaseFinished:Connect(function(playerId, assetId, isPurchased)
		
		if playerId == game.Players.LocalPlayer.userId and isPurchased then
		
			local burstEffect
			local soundEffect
			
			if assetId == 509934399 then
				soundEffect = "ethyr1"
				burstEffect = 7
			elseif assetId == 509935760 then
				soundEffect = "ethyr2"
				burstEffect = 14
			elseif assetId == 509935018 then
				soundEffect = "ethyr3"
				burstEffect = 26
			elseif assetId == 539152241 then
				soundEffect = "ethyr4"
				burstEffect = 46
			end
			
--			if burstEffect then	
--				script.Parent.currency.ethyr.Visible = true
--				
--				burst(burstEffect)
--			end
			if soundEffect then
				utilities.playSound(soundEffect)
			end
		end
	end)
	
	local ethyrCostInfo = {costType = "ethyr", icon = "rbxassetid://31886504632", textColor = Color3.fromRGB(115, 255, 251)}
	
	local globalData = network:invoke("getCacheValueByNameTag", "globalData")
	script.Parent.currency.ethyr.Visible = false
	if globalData then
		Modules.money.setLabelAmount(script.Parent.currency.ethyr.amount, globalData.ethyr or 0, ethyrCostInfo)	
		script.Parent.currency.ethyr.Size = UDim2.new(0, script.Parent.currency.ethyr.amount.amount.AbsoluteSize.X + 95 + 10, 0, 36 + 10)
		script.Parent.currency.ethyr.Visible = (globalData.ethyr and globalData.ethyr > 0)
	end
	

	
	script.Parent.currency.ethyr.buy.Activated:connect(function()
		Modules.products.open()
	end)
	
	local oldEthyr = globalData.ethyr or 0
	
	network:connect("propogationRequestToSelf", "Event", function(key, value)
		if key == "globalData" then
			local newGlobalData = network:invoke("getCacheValueByNameTag", "globalData")
			local newEthyr = newGlobalData.ethyr or 0
			if newEthyr > oldEthyr and newEthyr > 0 then
				local ethyrDiff = newEthyr - oldEthyr
				local burstAmt = math.clamp(ethyrDiff/10, 3, 50)
				burst(burstAmt)
				Modules.money.setLabelAmount(script.Parent.currency.ethyr.amount, value.ethyr or 0, ethyrCostInfo)	
				script.Parent.currency.ethyr.Size = UDim2.new(0, script.Parent.currency.ethyr.amount.amount.AbsoluteSize.X + 95, 0, 36 + 10) 
				script.Parent.currency.ethyr.Visible = (newEthyr > 0)
			end
			oldEthyr = newEthyr
		end
	end)
	

	local function onInventoryItemMouseEnter(inventoryItem)
		lastSelected = inventoryItem
		local abilitySlotData = abilityPairing[inventoryItem]
		if abilitySlotData then
			local abilityBaseData = abilityLookup[abilitySlotData.id](playerData)
			network:invoke("populateItemHoverFrameWithAbility", abilityBaseData, abilitySlotData.rank)
		end
		local inventorySlotData = inventorySlotPairing[inventoryItem]
		if inventorySlotData then
			local itemBaseData = itemData[inventorySlotData.id]
			if itemBaseData then
				network:invoke("populateItemHoverFrame", itemBaseData, "inventory", inventorySlotData)
			end
		end
	end
	
	local function onInventoryItemMouseLeave(inventoryItem)
		if lastSelected == inventoryItem then
			-- clears last selected
			network:invoke("populateItemHoverFrame")
		end
	end
	
	Modules.money.subscribeToPlayerMoney(script.Parent.currency.money)
	
	local inventoryItemTemplate = script:WaitForChild("inventoryItemTemplate")
	
	local function onInventoryItemDoubleClicked(inventoryItem)
		if abilityPairing[inventoryItem] then
			local abilitySlotData = abilityPairing[inventoryItem]

			
			if abilitySlotData then
				
				if enchantFrame.Visible then
					
					Modules.enchant.dragItem(abilitySlotData)				
				else
				
					network:invoke("activateAbilityRequest", abilitySlotData.id)
				end
			end			
		elseif inventorySlotPairing[inventoryItem] then
			
			local inventorySlotData = inventorySlotPairing[inventoryItem]
			
			if tradeFrame.Visible then
				
				Modules.trading.processDoubleClickFromInventory(inventorySlotData)
				
			--elseif enchantFrame.Visible then
				
			--	Modules.enchant.dragItem(inventorySlotData)	
				
			elseif storageFrame.Visible then
				
				network:invokeServer("playerRequest_transferInventoryToStorage", inventorySlotData)
				
			elseif shopFrame.Visible then
				

				network:invoke("shop_setCurrentItem", inventorySlotData, true)				
					
			else
				local itemBaseData = itemData[inventorySlotData.id]
				print("doubleclick", itemBaseData and itemBaseData.name, itemBaseData and itemBaseData.category, itemBaseData and itemBaseData.equipmentPosition)
				if itemBaseData then
					
					if itemBaseData.category == "equipment" then
						
						if itemBaseData.equipmentPosition == mapping.equipmentPosition.arrow then
							-- this is an arrow.. we want to handle this uniquely
							print("arrow hehe")
							local success = network:invokeServer("transferInventoryToEquipment", "equipment", inventorySlotData.position, mapping.equipmentPosition.arrow)
						else
							--equipmentSlot
							local targetName = Modules.mapping.getMappingByValue("equipmentPosition", itemBaseData.equipmentSlot)
							
							if targetName then
								local target = equipFrame.content:FindFirstChild(targetName)
								
								if target and target:FindFirstChild("equipItemButton") then
									Modules.uiCreator.processSwap(inventoryItem, target.equipItemButton)
								end
							end
						end
					elseif itemBaseData.category == "consumable" or itemBaseData.activationEffect ~= nil then
						
						
						
						-- so sad, we have to do this though.
						-- functions use each other :(
						local success, reason = network:invoke("activateItemRequestLocal", inventorySlotData)
					end
				end

			end
		end
	end
	
	local function onInventoryItemMouseButton1Click_isEnchantingEquipment(inventoryItem)

		
		if module.isEnchantingEquipment and inventorySlotData_enchantment then
			local target
			local mode
			if inventoryItem:IsDescendantOf(script.Parent) and inventorySlotPairing[inventoryItem] then
				local inventorySlotData = inventorySlotPairing[inventoryItem]
				if inventorySlotData then
					target = inventorySlotData
				end

			elseif inventoryItem:IsDescendantOf(equipFrame) then
				local equipmentSlotData = network:invoke("getEquipmentSlotDataByEquipmentSlotUI", inventoryItem)
				if equipmentSlotData then
					target = equipmentSlotData
					mode = "equipment"
				end
			end
			
			if inventoryItem.Parent.blocked.Visible then
				return false
			end			
			
			local continue = true
			local definitiveEnchantmentData = inventorySlotData_enchantment
			
			if definitiveEnchantmentData then
				local dyeBaseData = itemData[definitiveEnchantmentData.id]
				
				if target then
					local equipmentBaseData = itemData[target.id]
					
					if dyeBaseData.dye and not Modules.dyePreview.prompt(dyeBaseData, equipmentBaseData) then
						continue = false
					end
				end
			end			
			
			if target and continue then
				
				local enchantmentData = definitiveEnchantmentData
				
				local playerInput = {}
				local itemBaseData_enchantment 	= itemData[enchantmentData.id]
				if itemBaseData_enchantment and itemBaseData_enchantment.playerInputFunction then
					playerInput = itemBaseData_enchantment.playerInputFunction()
				end
				
				local success, scrollApplied, newInventorySlotData, status = network:invokeServer("playerRequest_enchantEquipment", enchantmentData, target, mode, playerInput)
				
				if status then
					spawn(function()
						wait(0.5)
--						game.StarterGui:SetCore("ChatMakeSystemMessage", status)
						network:fire("alert", status)
					end)
				end				
				
				itemUseDebounce = false
--				module.isEnchantingEquipment = false
				module.setIsEnchantingEquipment(false)

				script.Parent.scrollPrompt.Visible = false
				
				inventorySlotData_enchantment = nil
				scrollingMask.ImageTransparency = 1
				network:invoke("populateItemHoverFrame")
				
				if success and scrollApplied and newInventorySlotData then
					spawn(function()
						wait(0.5)
						local ringInfo = {
							color = Modules.itemAcquistion.getTitleColorForInventorySlotData(newInventorySlotData) or Color3.new(1,1,1);
						}
						Modules.fx.ring(ringInfo, inventoryItem.AbsolutePosition + inventoryItem.AbsoluteSize/2)
					end)
				end			
				-- disgusting
				network:invoke("updateInventoryUI")
			end
		end
		
		
	end
		
	module.enchantItem = onInventoryItemMouseButton1Click_isEnchantingEquipment
	
	local abilityData
	
	local function getPlayerDataSpentAP(playerData)
		local spentAP = 0
		for i, abilitySlotData in pairs(playerData.abilities) do
			if abilitySlotData.rank ~= 0 then
				local abilityBaseData = abilityLookup[abilitySlotData.id](playerData)
				if abilityBaseData and abilityBaseData.metadata then
					spentAP = spentAP + abilityBaseData.metadata.cost
				end
				local upgrades = abilitySlotData.rank - 1
				if upgrades > 0 and abilityBaseData.metadata and abilityBaseData.metadata.upgradeCost then
					spentAP = spentAP + abilityBaseData.metadata.upgradeCost * upgrades
				end
				if abilitySlotData.variant then
					local variantData = abilityBaseData.metadata.variants[abilitySlotData.variant]
					spentAP = spentAP + variantData.cost
				end
			end
		end
		return spentAP 
	end	
		
	
	local learnAbilitiesFrame = script.Parent.learnAbilities
	
	local learnableAbilityCount = 0
	
	local function updateLearnableAbilities()
		abilityData = abilityData or network:invoke("getCacheValueByNameTag", "abilities")
		for i, button in pairs(learnAbilitiesFrame.contents:GetChildren()) do
			if button:IsA("GuiObject") then
				button:Destroy()
			end
		end
		-- at this point shouldnt i just change how we store the data ;-;
		local organizedAbilityData = {}
		
		for i, abilitySlotData in pairs(abilityData) do
			organizedAbilityData[abilitySlotData.id] = abilitySlotData
		end
		local learnableAbilities = {}
		for abilityId, isAbility in pairs(abilityLookup:GetAbilityIds()) do
			if isAbility then
				local ability = abilityLookup[abilityId](playerData)
				if ability.metadata and ability.metadata.requirement and ability.metadata.requirement(playerData) then
					if organizedAbilityData[ability.id] == nil or organizedAbilityData[ability.id].rank == 0 then
						table.insert(learnableAbilities, ability)
					end
				end
			end
		end
		learnableAbilityCount = #learnableAbilities
		for i, ability in pairs(learnableAbilities) do
			local template = learnAbilitiesFrame.template:Clone()
			local cost = ability.metadata.cost or 0
			template.item.Image = ability.image
			template.abilityPoints.amount.Text = cost .. " AP"
			template.LayoutOrder = cost
			template.Parent = learnAbilitiesFrame.contents
			template.Visible = true
			local function selected()
				network:invoke("populateItemHoverFrameWithAbility", ability, 0)	
				lastSelected = template			
			end
			local function unselected()
				if lastSelected == template then
					network:invoke("populateItemHoverFrame")
				end
			end
			template.item.MouseEnter:connect(selected)
			template.item.SelectionGained:connect(selected)
			template.item.MouseLeave:connect(unselected)
			template.item.SelectionLost:connect(unselected)
			template.item.Activated:connect(function()
				local str = localization.translate("Are you sure you want to spend %s to learn %s?", learnAbilitiesFrame)
				local abilityName = ability.name and localization.translate(ability.name) or "???"
				local playerConfirmed = network:invoke("promptActionFullscreen",string.format(str, cost .. " AP", abilityName))
				if playerConfirmed then
					local success, err = network:invokeServer("playerRequest_learnAbility", ability.id)
					-- auto-bind new abilities
					if success then
						if not ability.passive then
							local hotbarSlotPairing = network:invoke("getHotbarSlotPairing")
							for i, hotbarSlot in pairs(hotbarSlotPairing) do
								local hotbarButton = hotbarSlot.button
								local hotbarData = hotbarSlot.data
								if (hotbarData == nil or hotbarData.id == nil or hotbarData.id <= 0) then
									
									local num = string.gsub(hotbarButton.Name,"[^.0-9]+","")
									num = tonumber(num)
									
									if num ~= 1 and num ~= 2 then -- 1 and 2 reserved for consumables
										if num == 10 then num = 0 end
										local bindsuccess = network:invokeServer("registerHotbarSlotData", mapping.dataType.ability, ability.id, tonumber(num))		
										if bindsuccess then			
											for i=1,4 do
												local flare = hotbarButton.flare:Clone()
												flare.Name = "flareCopy"
												flare.Parent = hotbarButton
												flare.Visible = true
												flare.Size = UDim2.new(1,4,1,4)
												flare.Position = UDim2.new(0.5,0,1,2)
												flare.AnchorPoint = Vector2.new(0.5,1)
												local y = (180 - 40*i)
												local x = (14 - 2*i)
												local EndPosition = UDim2.new(0.5,0,1,2)
												local EndSize = UDim2.new(1,x,1,y)
												tween(flare,{"Position","Size","ImageTransparency"},{EndPosition, EndSize, 1},0.5*i)
													
											end	
											break								
										end	
									end	
													
								end
							end
						end
						if game.ReplicatedStorage.sounds:FindFirstChild("idolPickup") then
							--game.ReplicatedStorage.sounds.idolPickup:Play()
							utilities.playSound("idolPickup")
						end							
					end
					
				end
			end)
			
		end
		local rows = math.ceil(#learnableAbilities/4)
		local grid = learnAbilitiesFrame.contents.UIGridLayout
		local ySize = grid.CellPadding.Y.Offset + grid.CellSize.Y.Offset
		local xSize = grid.CellPadding.X.Offset + grid.CellSize.X.Offset
		learnAbilitiesFrame.Size = UDim2.new(0, ((rows > 1 and xSize * 4 + 14) or xSize * #learnableAbilities), 0, math.min(rows * ySize, 170))
		learnAbilitiesFrame.contents.CanvasSize = UDim2.new(0, 0, 0, rows * ySize)
		learnAbilitiesFrame.contents.CanvasPosition = Vector2.new()
	end

	local function updateInventory(updateInventoryData)
		if updateInventoryData then
			lastInventoryDataReceived = updateInventoryData
		end
		
		if currentCategoryTab ~= "ability" then
			learnAbilitiesFrame.Visible = false
		end
		
		local currentSelected = game.GuiService.SelectedObject
		local selectionName, selectionParent
		if currentSelected and currentSelected:IsDescendantOf(script.Parent) then
			selectionName = currentSelected.Name
			selectionParent = currentSelected.Parent
		end
		
		if lastInventoryDataReceived then
			inventorySlotPairing = {}
			abilityPairing = {}
			for i, inventoryItem in pairs(content:GetChildren()) do
				if inventoryItem:FindFirstChild("item") then
					inventoryItem:Destroy()
				end
			end
			
			local currCells	= 0
			
			playerData = network:invoke("getLocalPlayerDataCache")
			abilityData = abilityData or network:invoke("getCacheValueByNameTag", "abilities")
			
			local level = network:invoke("getCacheValueByNameTag", "level") or 1
			local abilityPoints = level - 1 
			local unspentAbilityPoints = abilityPoints - getPlayerDataSpentAP(playerData)
			
			
			script.Parent.abilityPoints.Visible = unspentAbilityPoints > 0
			script.Parent.abilityPoints.amount.Text = tostring(unspentAbilityPoints) .. " AP"
			
			
			
			local contents = {}
			local n = 0
			if currentCategoryTab == "ability" then
				for i, abilitySlotData in pairs(abilityData) do
					if abilitySlotData.rank > 0 then
						n = n + 1
						contents[tostring(n)] = abilitySlotData
					end
				end
			else
				for i, inventorySlotData in pairs(lastInventoryDataReceived) do
					local inventoryItemBaseData = itemData[inventorySlotData.id]
								
					if inventoryItemBaseData then
						if inventoryItemBaseData.category == currentCategoryTab then	
							contents[tostring(inventorySlotData.position)] = inventorySlotData
						end	
					end			
				end
			end
			
			
			
			for i = 1, 20 do
				local inventoryItem = script.inventoryItemTemplate:Clone()
				inventoryItem.stars.Visible = false
				inventoryItem.blocked.Visible = false
				inventoryItem.shine.Visible = false
				inventoryItem.locked.Visible = false
				inventoryItem.attribute.Visible = false
				inventoryItem.item.duplicateCount.Text 	= ""
				local item = contents[tostring(i)]
				if item then
					if currentCategoryTab == "ability" then
						-- ability
						local abilitySlotData = item
						local abilityBaseData = abilityLookup[abilitySlotData.id](playerData)
						if not abilityBaseData.passive then
							local tag = Instance.new("BoolValue")
							tag.Name = "bindable"
							tag.Parent = inventoryItem.item
						end		
						inventoryItem.ImageTransparency = 0
						inventoryItem.item.Image = abilityBaseData.image
						inventoryItem.item.ImageColor3 = Color3.new(1,1,1)	
						if abilityBaseData.passive then
							abilitySlotData.passive = true
						end
						abilityPairing[inventoryItem.item] = abilitySlotData
							
						local titleColor, itemTier
						if abilitySlotData then
							if abilitySlotData.rank > 1 then
								itemTier = 2
							end
						end
						
						if abilityBaseData.statistics then
							local abilityStats = Modules.ability_utilities.getAbilityStatisticsForRank(abilityBaseData, abilitySlotData.rank)
							if abilityStats and abilityStats.tier and (itemTier == nil or abilityStats.tier > itemTier) then
								itemTier = abilityStats.tier
							end				
						end	
						
						
						if itemTier and itemTier > 1 then
							titleColor = enchantment.tierColors[itemTier]
						end

						local upgrades = abilitySlotData.rank > 1 and abilitySlotData.rank - 1
						if upgrades then
							for i,child in pairs(inventoryItem.stars:GetChildren()) do
								if child:IsA("ImageLabel") then
									child.ImageColor3 = titleColor or Color3.new(1,1,1)
									child.Visible = false
								elseif child:IsA("TextLabel") then
									child.TextColor3 = titleColor or Color3.new(1,1,1)
									child.Visible = false
								end
							end
							inventoryItem.stars.Visible = true
							if upgrades <= 3 then
								for i,star in pairs(inventoryItem.stars:GetChildren()) do
									local score = tonumber(star.Name) 
									if score then
										star.Visible = score <= upgrades
									end
								end
								inventoryItem.stars.exact.Visible = false
							else
								inventoryItem.stars["1"].Visible = true
								inventoryItem.stars.exact.Visible = true
								inventoryItem.stars.exact.Text = upgrades
							end
							inventoryItem.stars.Visible = true
						end		
						
						inventoryItem.shine.Visible = titleColor ~= nil and itemTier > 1
						inventoryItem.shine.ImageColor3 = titleColor or Color3.fromRGB(179, 178, 185)

					--	local gradient = script.abilityGradient:Clone()
					--	gradient.Parent = inventoryItem.item

						Modules.fx.setFlash(inventoryItem.frame, inventoryItem.shine.Visible)

						inventoryItem.frame.ImageColor3 = (itemTier and itemTier > 1 and titleColor) or Color3.fromRGB(106, 105, 107)										
						
						uiCreator.drag.setIsDragDropFrame(inventoryItem.item)
						uiCreator.setIsDoubleClickFrame(inventoryItem.item, 0.2, onInventoryItemDoubleClicked)																
					else
						-- item
						local inventorySlotData = item
						local inventoryItemBaseData = itemData[inventorySlotData.id]
						if inventoryItemBaseData.canBeBound then
							local tag = Instance.new("BoolValue")
							tag.Name = "bindable"
							tag.Parent = inventoryItem.item
						end	
						inventoryItem.ImageTransparency = 0
						inventoryItem.item.Image = inventoryItemBaseData.image
						inventoryItem.item.ImageColor3 = Color3.new(1,1,1)
						if inventorySlotData.dye then
							inventoryItem.item.ImageColor3 = Color3.fromRGB(inventorySlotData.dye.r, inventorySlotData.dye.g, inventorySlotData.dye.b)
						end
						
						if inventoryItemBaseData.minLevel then
							local level = network:invoke("getCacheValueByNameTag", "level") or 1	
							inventoryItem.locked.Visible = level <	inventoryItemBaseData.minLevel					
						end

						inventoryItem.item.duplicateCount.Text = (inventorySlotData.stacks and inventoryItemBaseData.canStack and inventorySlotData.stacks > 1) and tostring(inventorySlotData.stacks) or ""
						
						inventorySlotPairing[inventoryItem.item] = inventorySlotData
						
						local titleColor, itemTier
						if inventorySlotData then
							titleColor, itemTier = Modules.itemAcquistion.getTitleColorForInventorySlotData(inventorySlotData) 
						end

						if inventorySlotData.attribute then
							local attributeData = itemAttributes[inventorySlotData.attribute]
							if attributeData and attributeData.color then
								inventoryItem.attribute.ImageColor3 = attributeData.color
								inventoryItem.attribute.Visible = true
							end
						end

						local upgrades = inventorySlotData.successfulUpgrades
						if upgrades then
							for i,child in pairs(inventoryItem.stars:GetChildren()) do
								if child:IsA("ImageLabel") then
									child.ImageColor3 = titleColor or Color3.new(1,1,1)
									child.Visible = false
								elseif child:IsA("TextLabel") then
									child.TextColor3 = titleColor or Color3.new(1,1,1)
									child.Visible = false
								end
							end
							inventoryItem.stars.Visible = true
							if upgrades <= 3 then
								for i,star in pairs(inventoryItem.stars:GetChildren()) do
									local score = tonumber(star.Name) 
									if score then
										star.Visible = score <= upgrades
									end
								end
								inventoryItem.stars.exact.Visible = false
							else
								inventoryItem.stars["1"].Visible = true
								inventoryItem.stars.exact.Visible = true
								inventoryItem.stars.exact.Text = upgrades
							end
							inventoryItem.stars.Visible = true
						end
						
						if module.isEnchantingEquipment and inventorySlotData_enchantment then
							local itemBaseData_enchantment = itemData[inventorySlotData_enchantment.id]
							local cost = itemBaseData_enchantment.upgradeCost or 1
							local max = inventoryItemBaseData.maxUpgrades
							local canEnchant, indexToRemove = enchantment.enchantmentCanBeAppliedToItem(inventorySlotData_enchantment, inventorySlotData)
							local blocked = not canEnchant
							inventoryItem.blocked.Visible = blocked
						end
						
						inventoryItem.shine.Visible = titleColor ~= nil and itemTier > 1
						inventoryItem.shine.ImageColor3 = titleColor or Color3.fromRGB(179, 178, 185)

						Modules.fx.setFlash(inventoryItem.frame, inventoryItem.shine.Visible)

						inventoryItem.frame.ImageColor3 = (itemTier and itemTier > 1 and titleColor) or Color3.fromRGB(106, 105, 107)
						
						if not module.isEnchantingEquipment then
							uiCreator.drag.setIsDragDropFrame(inventoryItem.item)
							uiCreator.setIsDoubleClickFrame(inventoryItem.item, 0.2, onInventoryItemDoubleClicked)
						else
							inventoryItem.item.MouseButton1Click:connect(function() onInventoryItemMouseButton1Click_isEnchantingEquipment(inventoryItem.item) end)
						end												
					end		
				else
					inventoryItem.item.Image = ""
					inventoryItem.item.Visible = true
					inventoryItem.frame.Visible = false
					inventoryItem.shine.Visible = false
					inventoryItem.ImageTransparency = 0.5
					if currentCategoryTab == "ability" and i == n + 1 then
						local upgrade = script.upgrade:Clone()
						upgrade.Parent = inventoryItem
						upgrade.Visible = true
						-- todo: make sure there are actually abilities you can earn
						local function updateUpgradeButton()
							if learnAbilitiesFrame.Visible then
								upgrade.ImageColor3 = Color3.fromRGB(243, 37, 52)
								upgrade.text.Text = "x"
								upgrade.Active = true
								local position = inventoryItem.AbsolutePosition - script.Parent.AbsolutePosition
								learnAbilitiesFrame.Position = UDim2.new(0, position.X + inventoryItem.AbsoluteSize.X, 0, position.Y)
							else
								if unspentAbilityPoints > 0 then
									upgrade.ImageColor3 = Color3.fromRGB(255, 182, 12)
									upgrade.text.Text = "+"
									upgrade.Active = true
								else
									upgrade.ImageColor3 = Color3.fromRGB(185, 185, 185)
									upgrade.text.Text = "+"
									upgrade.Active = false
								end								
							end
							updateLearnableAbilities()
							upgrade.Visible = learnableAbilityCount > 0							
						end
						learnAbilitiesFrame.Visible = false
						updateUpgradeButton()
						upgrade.Activated:connect(function()
							if learnAbilitiesFrame.Visible then
								learnAbilitiesFrame.Visible = false
							else
								updateLearnableAbilities()
								learnAbilitiesFrame.Visible = true
							end
							updateUpgradeButton()
						end)
					end					
				end
				
				inventoryItem.item.MouseEnter:connect(function() onInventoryItemMouseEnter(inventoryItem.item) end)
				inventoryItem.item.SelectionGained:connect(function() onInventoryItemMouseEnter(inventoryItem.item) end)
				
				inventoryItem.item.MouseLeave:connect(function() onInventoryItemMouseLeave(inventoryItem.item) end)
				inventoryItem.item.SelectionLost:connect(function() onInventoryItemMouseLeave(inventoryItem.item) end)
								
					
				inventoryItem.Name = tostring(i)
				inventoryItem.LayoutOrder = i
				inventoryItem.Parent = content				
			end			
			
			
			if selectionParent and selectionName then
				local newSelection = selectionParent:FindFirstChild(selectionName)
				if newSelection then
					game.GuiService.SelectedObject = newSelection
				end
			end
		end
	end
	
	local canPlayerUseConsumable = true
	local function onSetCanPlayerUseConsumable(value)
		canPlayerUseConsumable = value
	end
	
	local CONSUMABLE_COOLDOWN_TIME 	= 4
	local lastUseConsumable 		= 0
	local isCurrentlyConsuming 		= false
	local function activateItemRequest(inventorySlotData)
		if itemUseDebounce then	return false end
		if not canPlayerUseConsumable then return false end
		if player.Character.PrimaryPart.health.Value <= 0 then return false end
		if network:invoke("getCharacterMovementStates").isSprinting then return end
		if network:invoke("isCharacterStunned") then return end
		
		itemUseDebounce = true
		
		local itemBaseData = itemData[inventorySlotData.id]
		if itemBaseData then
			if itemBaseData.askForConfirmationBeforeConsume then
				local playerConfirmed = network:invoke("promptActionFullscreen","Are you sure you want to use '" .. itemBaseData.name .. "'?")
				
				if not playerConfirmed then
					itemUseDebounce = false
					
					return false, "denied confirmation"
				end
			end
			
			local consumeTimeReduction = math.clamp(1 - network:invoke("getCacheValueByNameTag", "nonSerializeData").statistics_final.consumeTimeReduction, 0, 1)
			
			if itemBaseData.enchantsEquipment then

								
				
--				module.isEnchantingEquipment = true
				module.setIsEnchantingEquipment(true, inventorySlotData)
				inventorySlotData_enchantment 	= inventorySlotData
				scrollingMask.ImageTransparency = 0
				script.Parent.scrollPrompt.Visible = true
				script.Parent.scrollPrompt.contents.itemIcon.Image = itemBaseData.image
				scrollingMask.Image = itemBaseData.image
				
				network:invoke("populateItemHoverFrame")
				
				-- show equipment tab
				tweenAnimations[currentCategoryTab].mouseLeaveTween:Play()
				currentCategoryTab = "equipment"
				tweenAnimations.equipment.mouseClickTween:Play()
				updateInventory()
				
				itemUseDebounce = false
				return nil
			elseif not isCurrentlyConsuming then
				lastUseConsumable = tick()
				
				local success, errorMessage
				
				local playerInput = itemBaseData.playerInputFunction and itemBaseData.playerInputFunction() or {}

	
				--local remainingCooldown = consumableCooldownPostCDR - (tick() - lastUseConsumable)
				--if remainingCooldown > 0 then
				--	network:invoke("showConsumableCooldown", remainingCooldown)
				--end
				
				local connectionForAnimation
				local timeStart
				
				-- todo: faster consume time for perks
				
				local itemConsumeTime = (itemBaseData.consumeTime or 1) * consumeTimeReduction
				network:invoke("showConsumableCooldown", itemConsumeTime)
				local function onAnimationStopped()
					if connectionForAnimation then
						connectionForAnimation:disconnect()
						connectionForAnimation = nil
					end
					isCurrentlyConsuming = false
					
					if tick() - timeStart < itemConsumeTime * 0.90 then
						-- cancelled early, dont do anything :P
						return
					end
					
					
					--network:invoke("setIsChanneling", true)
					
					success, errorMessage = network:invokeServer("activateItemRequest", itemBaseData.category, inventorySlotData.position, nil, playerInput)
					
					delay(0.5, function()
						--network:invoke("setIsChanneling", false)
					end)
				end
				
				local myClientPlayerCharacterContainer = network:invoke("getMyClientCharacterContainer")

				if myClientPlayerCharacterContainer then
					local animations = animationInterface:getAnimationsForAnimationController(myClientPlayerCharacterContainer.entity.AnimationController)
					
					
					--network:invoke("setCharacterMovementState", "isEmoting", false)
					timeStart = tick()
					isCurrentlyConsuming = true
					animationInterface:replicatePlayerAnimationSequence("movementAnimations", "consume_consumable", nil, {id = itemBaseData.id; ANIMATION_DESIRED_LENGTH = itemConsumeTime})
					
					-- wait to start playing
					while not animations.movementAnimations.consume_loop.IsPlaying do
						wait(0.05)
					end
					
					
					connectionForAnimation = animations.movementAnimations.consume_loop.Stopped:connect(onAnimationStopped)
					
					delay(itemConsumeTime + 1.5, function()
						if connectionForAnimation then
							isCurrentlyConsuming = false
							connectionForAnimation:disconnect()
							connectionForAnimation = nil
						end
					end)
				end
				
				-- wait for this to be over
				while connectionForAnimation do
					wait(0.1)
				end
				itemUseDebounce = false
				
				return success, errorMessage			
			end
		end
		
		itemUseDebounce = false
		
		return false
	end

	network:create("activateItemRequestLocal", "BindableFunction", "OnInvoke", activateItemRequest)
	network:create("getIsCurrentlyConsuming", "BindableFunction", "OnInvoke", function()
		return isCurrentlyConsuming
	end)
	
	local function onPropogationRequestToSelf(propogationNameTag, propogationData)
		if propogationNameTag == "inventory" then
			updateInventory(propogationData)
		elseif propogationNameTag == "abilities" then
			print("abilities updated!")
			abilityData = propogationData
			updateInventory()
		end
	end
	
	local function onStopChannels_cancelConsuming(stateCancel)
		local myClientPlayerCharacterContainer = network:invoke("getMyClientCharacterContainer")

		if myClientPlayerCharacterContainer then
			local animations = animationInterface:getAnimationsForAnimationController(myClientPlayerCharacterContainer.entity.AnimationController)
			
			-- wait to start playing
			if animations and animations.movementAnimations and animations.movementAnimations.consume_loop.IsPlaying then
				animations.movementAnimations.consume_loop:Stop()
			end
		end
	end
	
	-- todo: yuck absorb this into input module
	game:GetService("UserInputService").InputBegan:connect(function(inputObject, absorbed)
		if script.Parent.Visible then
			if inputObject.KeyCode == Enum.KeyCode.ButtonL1 then
				if currentCategoryTab == "consumable" then
					currentCategoryTab = "equipment"
				elseif currentCategoryTab == "miscellaneous" then
					currentCategoryTab = "consumable"
				elseif currentCategoryTab == "equipment" then
					currentCategoryTab = "miscellaneous"
				end
				game.GuiService.SelectedObject = sortCategoryButtonContainer:FindFirstChild(currentCategoryTab)
				updateInventory()
				
			elseif inputObject.KeyCode == Enum.KeyCode.ButtonR1 then
				if currentCategoryTab == "consumable" then
					currentCategoryTab = "miscellaneous"
				elseif currentCategoryTab == "miscellaneous" then
					currentCategoryTab = "equipment"
				elseif currentCategoryTab == "equipment" then
					currentCategoryTab = "consumable"
				end
				game.GuiService.SelectedObject = sortCategoryButtonContainer:FindFirstChild(currentCategoryTab)
				updateInventory()	
				for i, button in pairs(sortCategoryButtonContainer:GetChildren()) do
					if button.Name == currentCategoryTab then
						button.ImageColor3 = Color3.fromRGB(84, 190, 255)
					elseif button:IsA("GuiObject") then
						button.ImageColor3 = Color3.fromRGB(202, 202, 202) 
					end
				end								
			end	
		end		
	end)
	
	network:create("localSignal_shopOpened", "BindableEvent", "Event", function()
		if currentCategoryTab == "ability" then
			currentCategoryTab = "miscellaneous"
			updateInventory()
			for i, button in pairs(sortCategoryButtonContainer:GetChildren()) do
				if button.Name == currentCategoryTab then
					button.ImageColor3 = Color3.fromRGB(84, 190, 255)
				elseif button:IsA("GuiObject") then
					button.ImageColor3 = Color3.fromRGB(202, 202, 202) 
				end
			end
		end
	end)
	
	network:create("localSignal_enchantOpened", "BindableEvent", "Event", function()
		if currentCategoryTab ~= "ability" then
			currentCategoryTab = "ability"
			updateInventory()
			for i, button in pairs(sortCategoryButtonContainer:GetChildren()) do
				if button.Name == currentCategoryTab then
					button.ImageColor3 = Color3.fromRGB(84, 190, 255)
				elseif button:IsA("GuiObject") then
					button.ImageColor3 = Color3.fromRGB(202, 202, 202) 
				end
			end
		end
	end)	
	
	local function setupSortCategoryButtonEffectsAndEvents(sortButton)
		local isHovered = false
		
		local tweenInformation 	= TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)
		
		tweenAnimations[sortButton.Name] 					= {}
		tweenAnimations[sortButton.Name].mouseEnterTween 	= tweenService:Create(sortButton, tweenInformation, {ImageColor3 = Color3.fromRGB(120, 222, 222)})
		tweenAnimations[sortButton.Name].mouseLeaveTween 	= tweenService:Create(sortButton, tweenInformation, {ImageColor3 = Color3.fromRGB(202, 202, 202)})
		tweenAnimations[sortButton.Name].mouseClickTween 	= tweenService:Create(sortButton, tweenInformation, {ImageColor3 = Color3.fromRGB(84, 190, 255)})
		
		sortButton.Activated:connect(function()
			currentCategoryTab = sortButton.Name
			
			-- update the inventory ui to reflect the change
			updateInventory()			
		end)
		
		local function onInputBegan(inputObject)
			if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
				isHovered = true
				
				if currentCategoryTab ~= sortButton.Name then
					tweenAnimations[sortButton.Name].mouseEnterTween:Play()
				end
			elseif inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
				if currentCategoryTab ~= sortButton.Name then
					tweenAnimations[sortButton.Name].mouseClickTween:Play()
					
					if tweenAnimations[currentCategoryTab] then
						tweenAnimations[currentCategoryTab].mouseLeaveTween:Play()
					end
				end
			
			end
		end
		
		local function onInputEnded(inputObject)
			if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
				isHovered = false
				
				if currentCategoryTab ~= sortButton.Name then
					tweenAnimations[sortButton.Name].mouseLeaveTween:Play()
				end

			end
		end
		
		sortButton.InputBegan:connect(onInputBegan)
		sortButton.InputEnded:connect(onInputEnded)
	end
	
	local function onGetInventorySlotDataByInventorySlotUI(inventorySlotUI)
		if inventorySlotUI then
			if inventorySlotPairing[inventorySlotUI] then
				return inventorySlotPairing[inventorySlotUI], "item"
			end
			if abilityPairing[inventorySlotUI] then
				return abilityPairing[inventorySlotUI], "ability"
			end
		end
		
		return nil
	end
	
	local function onGetCurrentInventoryCategory()
		return currentCategoryTab
	end
	
	local function onGetInventorySlotDataWithItemId(itemId)
		if not lastInventoryDataReceived then return end
		
		for i, inventorySlotData in pairs(lastInventoryDataReceived) do
			if inventorySlotData.id == itemId then
				return inventorySlotData
			end
		end
		
		return nil
	end
	
	local function main()
		
		playerData = network:invoke("getLocalPlayerDataCache")

		updateInventory(network:invoke("getCacheValueByNameTag", "inventory"))

		
		for i, sortCategoryButton in pairs(sortCategoryButtonContainer:GetChildren()) do
			if sortCategoryButton:IsA("ImageButton") then
				setupSortCategoryButtonEffectsAndEvents(sortCategoryButton)
			end
		end
		
		network:connect("stopChannels", "Event", onStopChannels_cancelConsuming)
		
		network:create("setCanPlayerUseConsumable", "BindableFunction", "OnInvoke", onSetCanPlayerUseConsumable)
		network:create("getInventorySlotDataByInventorySlotUI", "BindableFunction", "OnInvoke", onGetInventorySlotDataByInventorySlotUI)
		network:create("getCurrentInventoryCategory", "BindableFunction", "OnInvoke", onGetCurrentInventoryCategory)
		network:create("getInventorySlotDataWithItemId", "BindableFunction", "OnInvoke", onGetInventorySlotDataWithItemId)
		
		--network:create("setOngoingPlayerTradeDataForInventoryException")
		network:connect("propogationRequestToSelf", "Event", onPropogationRequestToSelf)
		
		-- allow other scripts to update the inventoryUI
		network:create("updateInventoryUI", "BindableFunction", "OnInvoke", function()
			updateInventory()
		end)
		
		local function onInputChanged(input)
			if module.isEnchantingEquipment then
				if scrollingMask.ImageTransparency ~= 0 then
					scrollingMask.ImageTransparency = 0
				end
		
		
				Modules.tween(scrollingMask,{"Position"},UDim2.new(0, input.Position.X - 40, 0, input.Position.Y + 20),0.2)
				--scrollingMask.Position = UDim2.new(0, input.Position.X - 50, 0, input.Position.Y + 25)
			end
		end
		
		local userInputService = game:GetService("UserInputService")
		userInputService.InputChanged:connect(onInputChanged)
		
		userInputService.InputBegan:connect(function(inputObject)
			if inputObject.UserInputType == Enum.UserInputType.MouseButton1 and module.isEnchantingEquipment then
				wait(0.15)
				itemUseDebounce = false
--				module.isEnchantingEquipment = false
				module.setIsEnchantingEquipment(false)
				script.Parent.scrollPrompt.Visible = false
				inventorySlotData_enchantment = nil
				scrollingMask.ImageTransparency = 1
				
				-- disgusting
				network:invoke("updateInventoryUI")
			end
		end)
	end
	
	delay(1, main)

end

return module