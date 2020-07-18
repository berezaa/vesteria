-- local interface for shop
-- author: not damien


local module = {}
local ui = script.Parent.gameUI.menu_shop

function module.open()

end

function module.close()
	ui.Visible = false
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
		ui.Visible = false
		if not fromInteract then
			warn("stop interact")
			Modules.interaction.stopInteract()
		end
	end
	-- ugly hack
	ui.close.Activated:connect(function() module.close() end)

	local shopItems

	function module.open()
		Modules.focus.toggle(ui)
		if ui.Visible then
			network:fire("localSignal_shopOpened")
		end
	end

	-- Reset the buy/sell frame
	local currentItemData = {}
	local inventoryModule




	-- Update the buy/sell frame
	local function update()



		ui.buy.content.amount.value.Text 	= tostring(ui.amount.Value)
		ui.sell.selling.amount.value.Text 	= tostring(ui.amount.Value)

		if not currentItemData.itemBaseData then
--			ui.sell.selling.Visible = false
--			ui.sell.empty.Visible = true
			ui.sell.Visible = false
			ui.sell.item.itemThumbnail.Image = ""
			ui.buy.Visible = false
			return
		end

		local itemName 	= currentItemData.itemBaseData.module.Name



		for i,shopItem in pairs(ui.curve.contents:GetChildren()) do
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
		--	ui.sell.empty.Visible = false
			ui.sell.selling.Visible = true
			ui.sell.Visible = true

			if currentItemData.itemBaseData.name then
				--local sellValue = currentItemData.itemBaseData.sellValue or 1
				if ui.buy.Visible and currentItemData.itemBaseData.buyValue then
					ui.buy.content.itemName.Text = currentItemData.itemBaseData.name
					ui.buy.item.itemThumbnail.Image = currentItemData.itemBaseData.image or "rbxassetid://2679574493"
--					ui.buy.content.cost.Text 		= currentItemData.itemBaseData.buyValue * ui.amount.Value

					if currentItemData.costInfo then
						Modules.money.setLabelAmount(
							ui.buy.content.cost,
							currentItemData.cost * ui.amount.Value,
							currentItemData.costInfo
						)
					else
						local statistics_final 	= network:invoke("getCacheValueByNameTag", "nonSerializeData").statistics_final
						local coinCostReduction = 1 - math.clamp(statistics_final.merchantCostReduction, 0, 1)

						Modules.money.setLabelAmount(
							ui.buy.content.cost,
							math.clamp(currentItemData.cost * ui.amount.Value * coinCostReduction, 1, math.huge),
							currentItemData.costInfo
						)
					end

				elseif ui.sell.Visible then
					ui.sell.selling.itemName.Text 	= currentItemData.itemBaseData.name
					ui.sell.item.itemThumbnail.Image = currentItemData.itemBaseData.image or "rbxassetid://2679574493"

					local inventorySlotData = currentItemData.inventorySlotData or {}

					local titleColor
					if inventorySlotData then
						titleColor = Modules.itemAcquistion.getTitleColorForInventorySlotData(inventorySlotData)
					end

					ui.sell.selling.itemName.TextColor3 = titleColor or Color3.new(1,1,1)

					local inventoryItem = ui.sell.item.curve

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

--					ui.sell.selling.cost.Text 		= (currentItemData.itemBaseData.sellValue or 1) * ui.amount.Value
					local sellValue = economy.getSellValue(currentItemData.itemBaseData, currentItemData.inventorySlotData)
					Modules.money.setLabelAmount(ui.sell.selling.cost, (sellValue) * ui.amount.Value)
				end
			end
		else
			ui.buy.Visible = false
--			ui.sell.empty.Visible = true
--			ui.sell.selling.Visible = false
			ui.sell.Visible = false
		end
	end

	local function reset()
		currentItemData = {}
		ui.ethyr.Visible = false
		update()
		if Modules.input.mode.Value == "xbox" then
			game.GuiService.SelectedObject = ui.sell.item.itemThumbnail
		end
	end

	reset()

	-- Request to buy the currently selected item
	local function requestBuy()
		if ui.buy.Visible and inventoryModule then
			if currentItemData.itemBaseData then
				if currentItemData.itemBaseData.buyValue then
					-- todo: client-side check of money
					local id = currentItemData.itemBaseData.id
					local amount = ui.amount.Value

					local itemCostInfo = currentItemData.costInfo

					local success, reason = network:invokeServer("playerRequest_buyItemFromShop", {id = id, costInfo = itemCostInfo}, amount, inventoryModule)

					-- todo: feedback for request status
					if success then
						fx.statusRibbon(ui, "Bought "..currentItemData.itemBaseData.name, "success", 3)
					else
						fx.statusRibbon(ui, "Failed to purchase.", "fail", 3)
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

	ui.buy.content.no.MouseButton1Click:connect(reset)
	ui.sell.selling.no.MouseButton1Click:connect(reset)
	ui.amount.Changed:connect(update)


	-- Set the buy frame (disables shop frame)
	local function promptBuyItem(itemName, cost, costInfo)
		ui.sell.Visible = false
		ui.buy.Visible = true

		if Modules.input.mode.Value == "xbox" then
			game.GuiService.SelectedObject = ui.buy.content.no
		end
		--[[
		if costInfo and costInfo.costType and costInfo.costType == "ethyr" then

			ui.ethyr.Visible = true
		else
			ui.ethyr.Visible = false
		end
		]]
		if currentItemData.itemBaseData and currentItemData.itemBaseData.name == itemName and ui.amount.Value == 1 then
			update()
		end

		ui.amount.Value = 1
	end

	local function promptSellItem(itemName)
		ui.sell.Visible 			= true
		ui.sell.selling.Visible 	= true
--		ui.sell.empty.Visible = false
		ui.buy.Visible 			= true

		if currentItemData.itemBaseData and currentItemData.itemBaseData.name == itemName and ui.amount.Value == 1 then
			update()
		end

		-- for damien: make this the amount you need
		ui.amount.Value = 1
	end

	local function int__setCurrentItem(inventorySlotData, isSelling, cost, costInfo)

		local itemId = inventorySlotData.id

		local inventorySlotDataPosition = inventorySlotData.position

		-- default to the size of the selected stack
		local quantity = inventorySlotData.stacks or 1
		ui.amount.Value = quantity



		currentItemData = { id = itemId; inventorySlotDataPosition = inventorySlotDataPosition; inventorySlotData = inventorySlotData; itemBaseData = itemData[itemId]; cost = cost; costInfo = costInfo; }

		-- toggle
		ui.buy.Visible 	= not isSelling
		ui.sell.Visible 	= not not isSelling

		update()
	end


	network:create("shop_setCurrentItem", "BindableFunction", "OnInvoke", int__setCurrentItem)

	-- Request to sell the currently selected item
	local function requestSell()
		if ui.sell.Visible and ui.sell.selling.Visible then
			if not currentItemData.itemBaseData then reset() return end

			local itemName = currentItemData.itemBaseData.name

			if currentItemData.itemBaseData then
				if currentItemData.itemBaseData.cantSell then
					return false
				end

				local itemName = currentItemData.itemBaseData.name

				local id = currentItemData.id
				local amount = ui.amount.Value
				-- for damien: may need to change this
				local category = network:invoke("getCurrentInventoryCategory")
				local success = network:invokeServer("playerRequest_sellItemToShop", {id = id; position = currentItemData.inventorySlotDataPosition}, amount)

				if success then
					fx.statusRibbon(ui, "Sold "..itemName, "gold", 3)
				else
					fx.statusRibbon(ui, "'fraid you can't do that :/", "fail", 3)
				end
				reset()

			end
		end
	end

	ui.buy.content.yes.MouseButton1Click:connect(requestBuy)
	ui.sell.selling.yes.MouseButton1Click:connect(requestSell)

	-- todo: exponential increase/decrease
	local function increase()
		if ui.amount.Value < 999 then
			ui.amount.Value = ui.amount.Value + 1
		end
	end
	local function decrease()
		if ui.amount.Value > 1 then
			ui.amount.Value = ui.amount.Value - 1
		end
	end

	local function buyAmountValueChanged()
		local buyAmount = tonumber(ui.buy.content.amount.value.Text)

		if buyAmount then
			ui.amount.Value = buyAmount

			update()
		end
	end

	local function sellAmountValueChanged()
		local sellAmount = tonumber(ui.sell.selling.amount.value.Text)

		if sellAmount then
			ui.amount.Value = sellAmount

			update()
		end
	end

	ui.buy.content.amount.increase.MouseButton1Click:connect(increase)
	ui.buy.content.amount.decrease.MouseButton1Click:connect(decrease)

	ui.sell.selling.amount.increase.MouseButton1Click:connect(increase)
	ui.sell.selling.amount.decrease.MouseButton1Click:connect(decrease)

	ui.buy.content.amount.value.FocusLost:connect(buyAmountValueChanged)
	ui.sell.selling.amount.value.FocusLost:connect(sellAmountValueChanged)

	-- Setup

	local lastSelected

	local sample = ui.curve.contents:WaitForChild("sampleItem")
	sample.Visible = false
	sample.Parent = script

	local function refreshShopInventory()

		ui.ethyr.Visible = false

		for i,existingItem in pairs(ui.curve.contents:GetChildren()) do
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

			--		ui.ethyr.Visible = true

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

					shopItem.Parent = ui.curve.contents
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

		ui.curve.contents.CanvasSize = UDim2.new(0, 0, 0, 20 + math.ceil(actualShopItems) * (70 + 5))
	end

	function module.open(shopObject)
		reset()
		ui.curve.contents.CanvasPosition = Vector2.new()
		if ui.Visible then
			ui.Visible = not ui.Visible
		else
			network:fire("localSignal_shopOpened")
			--ui.Visible = true
--			ui.Parent.Parent.UIScale.Scale = (Modules.input.menuScale or 1) * 0.75
--			Modules.tween(ui.Parent.Parent.UIScale, {"Scale"}, (Modules.input.menuScale or 1), 1, Enum.EasingStyle.Bounce)

			if shopObject then
				if shopObject:FindFirstChild("inventory") then
					inventoryModule = shopObject.inventory
					shopItems 		= require(shopObject.inventory)
					if inventoryModule:FindFirstChild("shopName") then
						ui.header.itemType.Text = inventoryModule:FindFirstChild("shopName").Value
					else
						ui.header.itemType.Text = "Merchant"
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

--			Modules.playerMenu.selectMenu(ui, Modules[script.Name])
			ui.Visible = true
			--[[
			ui.Visible = true
			if ui.Parent.tradeFrame.Visible then
				ui.Parent.tradeFrame.Visible = false
				Modules.trading.endTrade(true)
			end
			ui.Parent.equipFrame.Visible = false
			ui.Parent.Parent.Visible = true
			Modules.focus.change(ui.Parent.Parent)
			]]
		end
	end
	network:create("openShop","BindableFunction","OnInvoke", module.open)

end

return module
