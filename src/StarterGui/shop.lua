-- local interface for shop
-- author: not damien


local module = {}


function module.open()
	
end

function module.close()
	script.Parent.Visible = false
end

--[[
	FOR DAMIEN:
	
	to initiate a sell in the shop, set currentItem.Value to the INTERNAL NAME of the item being sold.
	it will be converted to item id when sending to server
	
	set amount.Value to how many items are in the stack. This should be the default sell amount
	
	set slotInfo to whatever you need to, or find the other "for damien:" comment and edit that part of code	
	
	
--]]



-- todo: store in NPC instead of hard-coding
local defaultShopItems = {"health potion", "health potion 2", "wooden club", "wooden sword", "pitchfork", "oak axe"}

local replicatedStorage = game:GetService("ReplicatedStorage")
local itemData = require(replicatedStorage.itemData)

function module.init(Modules)
	local network = Modules.network
	local fx = Modules.fx
	local tween = Modules.tween
	local utilities = Modules.utilities
	local economy = Modules.economy
	
	function module.close(fromInteract)
		script.Parent.Visible = false
		if not fromInteract then
			warn("stop interact")
			Modules.interaction.stopInteract()
		end
	end
	-- ugly hack
	script.Parent.close.Activated:connect(function() module.close() end)
	
	local shopItems
	
	function module.open()
		Modules.focus.toggle(script.Parent)
		if script.Parent.Visible then
			network:fire("localSignal_shopOpened")
		end
	end		
	
	-- Reset the buy/sell frame
	local currentItemData = {}
	local inventoryModule
	
	

	
	-- Update the buy/sell frame
	local function update()
	
		
		
		script.Parent.buy.content.amount.value.Text 	= tostring(script.Parent.amount.Value)
		script.Parent.sell.selling.amount.value.Text 	= tostring(script.Parent.amount.Value)		
		
		if not currentItemData.itemBaseData then 
--			script.Parent.sell.selling.Visible = false
--			script.Parent.sell.empty.Visible = true
			script.Parent.sell.Visible = false
			script.Parent.sell.item.itemThumbnail.Image = ""
			script.Parent.buy.Visible = false
			return
		end
		
		local itemName 	= currentItemData.itemBaseData.module.Name
		
		
			
		for i,shopItem in pairs(script.Parent.curve.contents:GetChildren()) do
			if shopItem:IsA("ImageButton") then

				if shopItem.Name ~= itemName then
					shopItem.ImageColor3 = Color3.fromRGB(30, 30, 30)
					shopItem.frame.Inner.ImageColor3 = Color3.fromRGB(30, 30, 30)
				else 
					shopItem.ImageColor3 = Color3.fromRGB(9, 39, 58)
					shopItem.frame.Inner.ImageColor3 = Color3.fromRGB(9, 39, 58)
				end
			end
		end
	
		if currentItemData.itemBaseData then
		--	script.Parent.sell.empty.Visible = false
			script.Parent.sell.selling.Visible = true
			script.Parent.sell.Visible = true
			
			if currentItemData.itemBaseData.name then
				--local sellValue = currentItemData.itemBaseData.sellValue or 1
				if script.Parent.buy.Visible and currentItemData.itemBaseData.buyValue then
					script.Parent.buy.content.itemName.Text = currentItemData.itemBaseData.name
					script.Parent.buy.item.itemThumbnail.Image = currentItemData.itemBaseData.image or "rbxassetid://2679574493"
--					script.Parent.buy.content.cost.Text 		= currentItemData.itemBaseData.buyValue * script.Parent.amount.Value
					
					if currentItemData.costInfo then
						Modules.money.setLabelAmount(
							script.Parent.buy.content.cost,
							currentItemData.cost * script.Parent.amount.Value,
							currentItemData.costInfo
						)
					else
						local statistics_final 	= network:invoke("getCacheValueByNameTag", "nonSerializeData").statistics_final
						local coinCostReduction = 1 - math.clamp(statistics_final.merchantCostReduction, 0, 1)
						
						Modules.money.setLabelAmount(
							script.Parent.buy.content.cost,
							math.clamp(currentItemData.cost * script.Parent.amount.Value * coinCostReduction, 1, math.huge),
							currentItemData.costInfo
						)
					end

				elseif script.Parent.sell.Visible then
					script.Parent.sell.selling.itemName.Text 	= currentItemData.itemBaseData.name
					script.Parent.sell.item.itemThumbnail.Image = currentItemData.itemBaseData.image or "rbxassetid://2679574493"
					
					local inventorySlotData = currentItemData.inventorySlotData or {}
					
					local titleColor
					if inventorySlotData then
						titleColor = Modules.itemAcquistion.getTitleColorForInventorySlotData(inventorySlotData) 
					end				
					
					script.Parent.sell.selling.itemName.TextColor3 = titleColor or Color3.new(1,1,1)	
					
					local inventoryItem = script.Parent.sell.item.curve
					
					inventoryItem.stars.Visible = false
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
					
--					script.Parent.sell.selling.cost.Text 		= (currentItemData.itemBaseData.sellValue or 1) * script.Parent.amount.Value
					local sellValue = economy.getSellValue(currentItemData.itemBaseData, currentItemData.inventorySlotData)
					Modules.money.setLabelAmount(script.Parent.sell.selling.cost, (sellValue) * script.Parent.amount.Value)
				end
			end
		else
			script.Parent.buy.Visible = false
--			script.Parent.sell.empty.Visible = true
--			script.Parent.sell.selling.Visible = false
			script.Parent.sell.Visible = false
		end
	end
	
	local function reset()
		currentItemData = {}
		script.Parent.ethyr.Visible = false
		update()
		if Modules.input.mode.Value == "xbox" then
			game.GuiService.SelectedObject = script.Parent.sell.item.itemThumbnail
		end
	end
	
	reset()
	
	-- Request to buy the currently selected item
	local function requestBuy()
		if script.Parent.buy.Visible and inventoryModule then
			if currentItemData.itemBaseData then
				if currentItemData.itemBaseData.buyValue then
					-- todo: client-side check of money
					local id = currentItemData.itemBaseData.id
					local amount = script.Parent.amount.Value
					
					local itemCostInfo = currentItemData.costInfo
					
					local success, reason = network:invokeServer("playerRequest_buyItemFromShop", {id = id, costInfo = itemCostInfo}, amount, inventoryModule)
					
					-- todo: feedback for request status
					if success then
						fx.statusRibbon(script.Parent, "Bought "..currentItemData.itemBaseData.name, "success", 3)
					else
						fx.statusRibbon(script.Parent, "Failed to purchase.", "fail", 3)
						warn(reason)
						if itemCostInfo.costType == "ethyr" then
							Modules.products.open()
						end				
					end
					reset()
				end
			end
		end
	end	
	
	script.Parent.buy.content.no.MouseButton1Click:connect(reset)
	script.Parent.sell.selling.no.MouseButton1Click:connect(reset)	
	script.Parent.amount.Changed:connect(update)
	
	
	-- Set the buy frame (disables shop frame)
	local function promptBuyItem(itemName, cost, costInfo)
		script.Parent.sell.Visible = false				
		script.Parent.buy.Visible = true
		
		if Modules.input.mode.Value == "xbox" then
			game.GuiService.SelectedObject = script.Parent.buy.content.no
		end
		--[[
		if costInfo and costInfo.costType and costInfo.costType == "ethyr" then
		
			script.Parent.ethyr.Visible = true	
		else		
			script.Parent.ethyr.Visible = false
		end		
		]]
		if currentItemData.itemBaseData and currentItemData.itemBaseData.name == itemName and script.Parent.amount.Value == 1 then
			update()
		end								
		
		script.Parent.amount.Value = 1
	end
	
	local function promptSellItem(itemName)
		script.Parent.sell.Visible 			= true
		script.Parent.sell.selling.Visible 	= true
--		script.Parent.sell.empty.Visible = false
		script.Parent.buy.Visible 			= true
		
		if currentItemData.itemBaseData and currentItemData.itemBaseData.name == itemName and script.Parent.amount.Value == 1 then
			update()
		end								
		
		-- for damien: make this the amount you need
		script.Parent.amount.Value = 1		
	end
	
	local function int__setCurrentItem(inventorySlotData, isSelling, cost, costInfo)
		
		local itemId = inventorySlotData.id
		
		local inventorySlotDataPosition = inventorySlotData.position
		
		-- default to the size of the selected stack
		local quantity = inventorySlotData.stacks or 1
		script.Parent.amount.Value = quantity
		
		
		
		currentItemData = { id = itemId; inventorySlotDataPosition = inventorySlotDataPosition; inventorySlotData = inventorySlotData; itemBaseData = itemData[itemId]; cost = cost; costInfo = costInfo; }
		
		-- toggle
		script.Parent.buy.Visible 	= not isSelling
		script.Parent.sell.Visible 	= not not isSelling
		
		update()
	end
	
	
	network:create("shop_setCurrentItem", "BindableFunction", "OnInvoke", int__setCurrentItem)
	
	-- Request to sell the currently selected item
	local function requestSell()
		if script.Parent.sell.Visible and script.Parent.sell.selling.Visible then
			if not currentItemData.itemBaseData then reset() return end
			
			local itemName = currentItemData.itemBaseData.name
			
			if currentItemData.itemBaseData then
				if currentItemData.itemBaseData.cantSell then
					return false
				end
				
				local itemName = currentItemData.itemBaseData.name				
				
				local id = currentItemData.id
				local amount = script.Parent.amount.Value
				-- for damien: may need to change this
				local category = network:invoke("getCurrentInventoryCategory")
				local success = network:invokeServer("playerRequest_sellItemToShop", {id = id; position = currentItemData.inventorySlotDataPosition}, amount)

				if success then
					fx.statusRibbon(script.Parent, "Sold "..itemName, "gold", 3)
				else
					fx.statusRibbon(script.Parent, "'fraid you can't do that :/", "fail", 3)						
				end
				reset()

			end
		end
	end
	
	script.Parent.buy.content.yes.MouseButton1Click:connect(requestBuy)
	script.Parent.sell.selling.yes.MouseButton1Click:connect(requestSell)
	
	-- todo: exponential increase/decrease
	local function increase()
		if script.Parent.amount.Value < 999 then
			script.Parent.amount.Value = script.Parent.amount.Value + 1
		end
	end
	local function decrease()
		if script.Parent.amount.Value > 1 then
			script.Parent.amount.Value = script.Parent.amount.Value - 1
		end
	end
	
	local function buyAmountValueChanged()
		local buyAmount = tonumber(script.Parent.buy.content.amount.value.Text)
		
		if buyAmount then
			script.Parent.amount.Value = buyAmount
			
			update()
		end
	end
	
	local function sellAmountValueChanged()
		local sellAmount = tonumber(script.Parent.sell.selling.amount.value.Text)
		
		if sellAmount then
			script.Parent.amount.Value = sellAmount
			
			update()
		end
	end
	
	script.Parent.buy.content.amount.increase.MouseButton1Click:connect(increase)
	script.Parent.buy.content.amount.decrease.MouseButton1Click:connect(decrease)
	
	script.Parent.sell.selling.amount.increase.MouseButton1Click:connect(increase)
	script.Parent.sell.selling.amount.decrease.MouseButton1Click:connect(decrease)
	
	script.Parent.buy.content.amount.value.FocusLost:connect(buyAmountValueChanged)
	script.Parent.sell.selling.amount.value.FocusLost:connect(sellAmountValueChanged)
	
	-- Setup
	
	local lastSelected	
	
	local sample = script.Parent.curve.contents:WaitForChild("sampleItem")
	sample.Visible = false
	sample.Parent = script
	
	local function refreshShopInventory()
		
		script.Parent.ethyr.Visible = false
		
		for i,existingItem in pairs(script.Parent.curve.contents:GetChildren()) do
			if existingItem:IsA("GuiObject") and existingItem:FindFirstChild("itemName") then
				existingItem:Destroy()
			end
		end
		
		local actualShopItems = 0
		
		for i,shopItemInfo in pairs(shopItems) do
			
			local shopItemName
			local costInfo
			local cost
			
			if typeof(shopItemInfo) == "string" then
				shopItemName = shopItemInfo
				costInfo = {}
			elseif typeof(shopItemInfo) == "table" then
				shopItemName = shopItemInfo.itemName
				costInfo = shopItemInfo.costInfo
				if costInfo and costInfo.costType and costInfo.costType == "ethyr" then
				
			--		script.Parent.ethyr.Visible = true			
					
				end
				cost = shopItemInfo.cost
			else
				error("Invalid shopItemInfo type. Failed to refresh shop inventory.")
			end
			
			
			
			local itemBaseData = itemData[shopItemName]
			if itemBaseData and itemBaseData.name then
				
				local costType = costInfo and costInfo.costType or "money"
				cost = cost or itemBaseData.buyValue
				
				if cost and costType then
				
					local shopItem = sample:Clone()
					shopItem.Name = shopItemName
					shopItem.itemName.Text = itemBaseData.name
					
					local itemType = itemBaseData.itemType 
					shopItem.itemName.cuteDecor.Image = "rbxgameasset://Images/category_"..itemType					
					
					
					shopItem.item.itemThumbnail.Image = itemBaseData.image or "rbxassetid://2679574493"				
	
--					shopItem.cost.Text = "$"..itemBaseData.buyValue
					Modules.money.setLabelAmount(shopItem.cost, cost, costInfo)
					--[[	
					if costInfo.textColor then
						shopItem.cost.amount.TextColor3 = costInfo.textColor
					end
					if costInfo.icon then
						shopItem.cost.icon.Image = costInfo.icon
					end
					
					if costType ~= "money" and cost > 999 then
						shopItem.cost.amount.Text = cost
					end
					]]
						
					shopItem.Parent = script.Parent.curve.contents
					shopItem.LayoutOrder = i
					shopItem.Visible = true
					
					shopItem.MouseButton1Click:connect(function()
						int__setCurrentItem(itemBaseData, nil, cost, costInfo)
						promptBuyItem(shopItemName, cost, costInfo)
					end)
					shopItem.item.itemThumbnail.MouseButton1Click:connect(function()
						int__setCurrentItem(itemBaseData, nil, cost, costInfo)
						promptBuyItem(shopItemName, cost, costInfo)
					end)
					
					local inventorySlotData = {id = itemBaseData.id}
					
					if shopItemInfo.attributes then
						for attribute, value in pairs(shopItemInfo.attributes) do
							if not inventorySlotData[attribute] then
								inventorySlotData[attribute] = value
							end
						end
					end
					
					local function selected()
						network:invoke("populateItemHoverFrame", itemBaseData, "shop", inventorySlotData)
						lastSelected = shopItem
					end
					
					local function deselected()
						if lastSelected == shopItem then
							network:invoke("populateItemHoverFrame")
						end
					end
					
					shopItem.item.itemThumbnail.MouseEnter:connect(selected)
					shopItem.item.itemThumbnail.MouseLeave:connect(deselected)
					
					shopItem.SelectionGained:connect(selected)
					shopItem.SelectionLost:connect(deselected)
					
					local titleColor
					if itemBaseData then
						titleColor = Modules.itemAcquistion.getTitleColorForInventorySlotData(inventorySlotData) 
	--						titleColor = Modules.itemAcquistion.getTitleColorForInventorySlotData(itemBaseData) 
					end
					
--					titleColor = titleColor or itemBaseData.nameColor

					shopItem.shine.Visible = titleColor ~= nil
					shopItem.shine.ImageColor3 = titleColor or Color3.fromRGB(179, 178, 185)
					shopItem.frame.ImageColor3 = titleColor or Color3.fromRGB(106, 105, 107)
					shopItem.shine.ImageColor3 = titleColor or Color3.fromRGB(179, 178, 185)
					shopItem.itemName.TextColor3 = titleColor or Color3.new(1,1,1)

					Modules.fx.setFlash(shopItem.frame, shopItem.shine.Visible)	
	
					
					

			
					
					
					
					
					actualShopItems = actualShopItems + 1
				end
			end
		end
		
		script.Parent.curve.contents.CanvasSize = UDim2.new(0, 0, 0, 20 + math.ceil(actualShopItems) * (70 + 5))
	end
	
	function module.open(shopObject)
		reset()
		script.Parent.curve.contents.CanvasPosition = Vector2.new()
		if script.Parent.Visible then
			script.Parent.Visible = not script.Parent.Visible		
		else
			network:fire("localSignal_shopOpened")
			--script.Parent.Visible = true
--			script.Parent.Parent.Parent.UIScale.Scale = (Modules.input.menuScale or 1) * 0.75
--			Modules.tween(script.Parent.Parent.Parent.UIScale, {"Scale"}, (Modules.input.menuScale or 1), 1, Enum.EasingStyle.Bounce)
			
			if shopObject then
				if shopObject:FindFirstChild("inventory") then
					inventoryModule = shopObject.inventory
					shopItems 		= require(shopObject.inventory)
					if inventoryModule:FindFirstChild("shopName") then
						script.Parent.header.itemType.Text = inventoryModule:FindFirstChild("shopName").Value
					else
						script.Parent.header.itemType.Text = "Merchant"
					end
					
				else
					inventoryModule = nil
					shopItems 		= {}
				end
				
				if shopObject:IsA("BasePart") then
					--local cf = shopObject.CFrame:ToWorldSpace(camCf)
					--network:invoke("lockCameraPosition",cf)
				end
			end
			refreshShopInventory()
			
--			Modules.playerMenu.selectMenu(script.Parent, Modules[script.Name])
			script.Parent.Visible = true		
			--[[
			script.Parent.Visible = true
			if script.Parent.Parent.tradeFrame.Visible then
				script.Parent.Parent.tradeFrame.Visible = false
				Modules.trading.endTrade(true)
			end
			script.Parent.Parent.equipFrame.Visible = false
			script.Parent.Parent.Parent.Visible = true
			Modules.focus.change(script.Parent.Parent.Parent)
			]]
		end
	end	
	network:create("openShop","BindableFunction","OnInvoke", module.open)

end

return module
