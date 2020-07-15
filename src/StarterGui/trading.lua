-- local trading ui
-- written by berezaa & polymorphic

local module = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network 		= modules.load("network")
		local utilities 	= modules.load("utilities")
		local mapping 		= modules.load("mapping")
		local configuration = modules.load("configuration")
	local itemLookup = require(replicatedStorage.itemData)

local player = game.Players.LocalPlayer
local tradeFrame = script.Parent

local inventorySlotPairing = {}

function module.postInit(Modules)

	local network = Modules.network
	
		
	local function onInventoryItemMouseEnter(inventoryItem)
		lastSelected = inventoryItem
		local inventorySlotData = inventorySlotPairing[inventoryItem]
		if inventorySlotData then
			local itemBaseData = itemLookup[inventorySlotData.id]
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
	
	for i,guiObject in pairs(script.Parent:GetDescendants()) do
		if guiObject:IsA("GuiObject") and guiObject:FindFirstChild("draggableFrame") then
			guiObject.MouseEnter:connect(function() onInventoryItemMouseEnter(guiObject) end)
			guiObject.MouseLeave:connect(function() onInventoryItemMouseLeave(guiObject) end)
			guiObject.SelectionGained:connect(function() onInventoryItemMouseEnter(guiObject) end)
			guiObject.SelectionLost:connect(function() onInventoryItemMouseLeave(guiObject) end)
		end
	end
end

-- Called after all modules are required
function module.init(Modules)

	local yourTrade 			= tradeFrame.yourTrade
	local theirTrade 			= tradeFrame.theirTrade
	local lastTradeSessionData 	= nil
	
	local lastSelected 
	
	

	
	local myInventoryTransferDataCollection = nil
	
	local function onGoldInputAmountChanged()
		if yourTrade.amount.Visible then 
			if yourTrade.amount.TextBox.Text ~= "" then
				local currentGold = network:invoke("getCacheValueByNameTag", "gold")
				
				-- clamp to your current gold amount
				yourTrade.amount.TextBox.Text = tostring(math.clamp(tonumber(yourTrade.amount.TextBox.Text) or 0, 0, tonumber(currentGold)))
				
				yourTrade.add.ImageColor3 = Color3.new(0, 1, 0)
				yourTrade.add.inner.Text = ">"
			else
				yourTrade.add.ImageColor3 = Color3.new(1, 0, 0)
				yourTrade.add.inner.Text = "-"				
			end
		end
	end
	
	local function onTradeSessionChanged(tradeSessionData)
		
	end
	
	local function onPlayerDragInventoryItemIntoTradeWindow(inventorySlotData)
		if myInventoryTransferDataCollection then
			
		end
	end
	
	local function tradeEnded()
		
	end
	

	
	-- returns my playerTradeData, other player's playerTradeData
	local function getMyPlayerTradeData(tradeSessionData)
		return tradeSessionData.playerTradeSessionData_player1.player == player and tradeSessionData.playerTradeSessionData_player1 or tradeSessionData.playerTradeSessionData_player2, tradeSessionData.playerTradeSessionData_player1.player == player and tradeSessionData.playerTradeSessionData_player2 or tradeSessionData.playerTradeSessionData_player1
	end
	
	-- Modules.trading.startTrade 
	function module.startTrade(tradeSessionData)

		-- we don't know if our client is the trade starter (player1)
		local playerTradeData, otherPlayerTradeData = getMyPlayerTradeData(tradeSessionData)
				
		theirTrade.title.Text 	= otherPlayerTradeData.player.Name
		yourTrade.title.Text 	= "Your offer"
		
		-- show tradeFrame, and set lastTradeSessionData to keep track
		tradeFrame.Visible 		= true
		lastTradeSessionData 	= tradeSessionData
		
		-- reset myInventoryTransferDataCollection
		myInventoryTransferDataCollection = {}
		
		-- hide equipment
		Modules.equipment.hide()
		script.Parent.Visible = true
--		script.Parent.Parent.Visible = true
		if not script.Parent.Parent.Parent.Visible then
			Modules.playerMenu.open()
		end
	end
	
	
	
	function module.endTrade(wasInitiatedByClient)
		tradeFrame.Visible = false
		Modules.equipment.show()
		
		-- if the client is ending the trade, then let the server know we're not interested anymore
		if wasInitiatedByClient and lastTradeSessionData then
			network:invokeServer("playerRequest_cancelTrade", lastTradeSessionData.guid)
		end
		
		-- reset internals
		myInventoryTransferDataCollection 	= nil
		lastTradeSessionData 				= nil
	end	
		
	module.tradeCollection = {}
	
	function module.clearLocalTradeSlot(button)
		inventorySlotPairing[button] = nil
		module.tradeCollection[button.Name] = nil
	end
	
	function module.setLocalTradeSlot(i, inventorySlotData)
		local inventoryReal = itemLookup[inventorySlotData.id]
		
		
		-- check for existing conflicts
		for e, tradeSlotData in pairs(module.tradeCollection) do
			
			if tradeSlotData and tradeSlotData.position == inventorySlotData.position then
				local tradeReal = itemLookup[tradeSlotData.id]
				if inventoryReal and tradeReal then
					if inventoryReal.category == tradeReal.category then
						module.tradeCollection[tostring(e)] = nil
					end
				end
			end	
			
		end
		
		inventorySlotData.stacks = inventorySlotData.stacks or 1
		
		module.tradeCollection[tostring(i)] = inventorySlotData
				
		network:invokeServer("playerRequest_updatePlayerTradeSessionData", lastTradeSessionData.guid, "inventoryTransferDataCollection", module.tradeCollection)
	end	
	
	function module.processDoubleClickFromInventory(inventorySlotData)
		if inventorySlotData then
			local inventoryReal = itemLookup[inventorySlotData.id]
			if inventoryReal then
				
				local takenButtons = {}
				
				for i, tradeSlotData in pairs(module.tradeCollection) do
					if tradeSlotData then
						takenButtons[i] = true
						if tradeSlotData.id == inventorySlotData.id and tradeSlotData.position == inventorySlotData.position then
							-- item already in the trade, remove it.
							module.tradeCollection[i] = nil
							return network:invokeServer("playerRequest_updatePlayerTradeSessionData", lastTradeSessionData.guid, "inventoryTransferDataCollection", module.tradeCollection)
						end
					end
				end
				
				for i,button in pairs(tradeFrame.yourTrade.contents:GetChildren()) do
					if button:IsA("GuiButton") and not takenButtons[button.Name] then
						module.tradeCollection[button.Name] = inventorySlotData
						return network:invokeServer("playerRequest_updatePlayerTradeSessionData", lastTradeSessionData.guid, "inventoryTransferDataCollection", module.tradeCollection)
					end
				end
			end
		end
	end	
	
	function module.swap(button1, button2)
		local button1pairing = inventorySlotPairing[button1]
		local button2pairing = inventorySlotPairing[button2]
		
		module.tradeCollection[button1.Name] = button2pairing
		module.tradeCollection[button2.Name] = button1pairing
		
		network:invokeServer("playerRequest_updatePlayerTradeSessionData", lastTradeSessionData.guid, "inventoryTransferDataCollection", module.tradeCollection)
		
		
	end	
	
	local function onTradeSessionChanged(tradeSessionData)
--		if lastTradeSessionData == nil or lastTradeSessionData.guid ~= tradeSessionData.guid then
		if lastTradeSessionData ~= tradeSessionData then
			module.startTrade(tradeSessionData)
		end
		
		-- wooo!!!
		-- todo: make this do something pretty
		if tradeSessionData.state == "canceled" or tradeSessionData.state == "completed" then
			module.tradeCollection = {}
			module.endTrade()
		end
		
		tradeFrame.countdown.Visible = false
		
		if tradeSessionData.state == "countdown" then
			tradeFrame.countdown.Text = "6"
			tradeFrame.countdown.Visible = true
			spawn(function()
				local count = 6
				while lastTradeSessionData.state == "countdown" and tradeFrame.countdown.Text == tostring(count) and count > 0 do
					count = count - 1
					tradeFrame.countdown.Text = tostring(count)
					wait(1)
				end
				if count <= 0 then
					tradeFrame.countdown.Visible = false
				end
			end)
		end
		
		local yourPlayerTradeSessionData = (tradeSessionData.playerTradeSessionData_player1.player == player and tradeSessionData.playerTradeSessionData_player1) or (tradeSessionData.playerTradeSessionData_player2.player == player and tradeSessionData.playerTradeSessionData_player2) or {}
		local theirPlayerTradeSessionData = (tradeSessionData.playerTradeSessionData_player1.player == player and tradeSessionData.playerTradeSessionData_player2) or (tradeSessionData.playerTradeSessionData_player2.player == player and tradeSessionData.playerTradeSessionData_player1) or {}
		
		-- gold
--		tradeFrame.yourTrade.gold.Text = yourPlayerTradeSessionData.gold or 0
--		tradeFrame.theirTrade.gold.Text = theirPlayerTradeSessionData.gold or 0

		Modules.money.setLabelAmount(tradeFrame.yourTrade.gold, yourPlayerTradeSessionData.gold or 0)
		Modules.money.setLabelAmount(tradeFrame.theirTrade.gold, theirPlayerTradeSessionData.gold or 0)
		
		-- trade state
		tradeFrame.yourTrade.approved.Visible = false
		tradeFrame.yourTrade.denied.Visible = false
		tradeFrame.theirTrade.approved.Visible = false
		tradeFrame.theirTrade.denied.Visible = false
		
		tradeFrame.yourTrade.ImageColor3 = Color3.fromRGB(189, 189, 189)
		tradeFrame.theirTrade.ImageColor3 = Color3.fromRGB(139, 139, 139)
		
		if theirPlayerTradeSessionData.state == "approved" then
			tradeFrame.theirTrade.approved.Visible = true
			tradeFrame.theirTrade.ImageColor3 = Color3.fromRGB(136, 192, 132)
		elseif theirPlayerTradeSessionData.state == "denied" then
			tradeFrame.theirTrade.denied.Visible = true
			tradeFrame.theirTrade.ImageColor3 = Color3.fromRGB(188, 109, 111)
		end
		
		if yourPlayerTradeSessionData.state == "approved" then
			tradeFrame.yourTrade.approved.Visible = true
			tradeFrame.yourTrade.ImageColor3 = Color3.fromRGB(97, 141, 98)
		elseif yourPlayerTradeSessionData.state == "denied" then
			tradeFrame.yourTrade.denied.Visible = true
			tradeFrame.yourTrade.ImageColor3 = Color3.fromRGB(138, 87, 88)
		end		
		
		local yourCollection = yourPlayerTradeSessionData.inventoryTransferDataCollection or {}
		local theirCollection = theirPlayerTradeSessionData.inventoryTransferDataCollection or {}
		
		module.tradeCollection = yourCollection
		
		local yourButtons = tradeFrame.yourTrade.contents:GetChildren()
		
		for i, button in pairs(yourButtons) do
			if button:IsA("ImageButton") then
				button.Image = ""
				inventorySlotPairing[button] = nil
				button.duplicateCount.Visible = false
				local buttonItemData = yourCollection[button.Name] or {}
				if buttonItemData then
					local itemBaseData = itemLookup[buttonItemData.id]
					if itemBaseData then
						button.Image = itemBaseData.image
						button.ImageColor3 = Color3.new(1,1,1)
						if buttonItemData.dye then
							button.ImageColor3 = Color3.fromRGB(buttonItemData.dye.r, buttonItemData.dye.g, buttonItemData.dye.b)
						end
						inventorySlotPairing[button] = buttonItemData
					end
					if buttonItemData.stacks and buttonItemData.stacks > 1 then
						button.duplicateCount.Text = tostring(buttonItemData.stacks)
						button.duplicateCount.Visible = true
					end
				end
			end
		end
		
		local theirButtons = tradeFrame.theirTrade.contents:GetChildren()
		
		for i, button in pairs(theirButtons) do
			if button:IsA("ImageButton") then
				button.Image = ""
				inventorySlotPairing[button] = nil
				button.duplicateCount.Visible = false
				local buttonItemData = theirCollection[button.Name] or {}
				if buttonItemData then
					local itemBaseData = itemLookup[buttonItemData.id]
					if itemBaseData then
						button.Image = itemBaseData.image
						button.ImageColor3 = Color3.new(1,1,1)
						if buttonItemData.dye then
							button.ImageColor3 = Color3.fromRGB(buttonItemData.dye.r, buttonItemData.dye.g, buttonItemData.dye.b)
						end						
						inventorySlotPairing[button] = buttonItemData
					end
					if buttonItemData.stacks and buttonItemData.stacks > 1 then
						button.duplicateCount.Text = tostring(buttonItemData.stacks)
						button.duplicateCount.Visible = true
					end
				end
			end
		end		
	end

	
	
	local function setYourGoldAmount(amount)
--		yourTrade.gold.Text = "$"..tostring(amount)

		Modules.money.setLabelAmount(tradeFrame.yourTrade.gold, tonumber(amount))
		-- >>> network: communicate trade change to server
		
		network:invokeServer("playerRequest_updatePlayerTradeSessionData", lastTradeSessionData.guid, "gold", tonumber(amount))
	end
	
	local function onMouseButton1Click_addMoneyButton()
		if yourTrade.amount.Visible then
			-- change the amount of money you are giving
			if yourTrade.amount.TextBox.Text ~= "" then
				local currentGold = network:invoke("getCacheValueByNameTag", "gold")
				
				-- clamp to your current gold amount
				local amount = tostring(math.clamp(tonumber(yourTrade.amount.TextBox.Text) or 0, 0, tonumber(currentGold)))
				
				if amount then
					setYourGoldAmount(amount)
				end							
			end
			
			yourTrade.amount.Visible = false
			yourTrade.add.ImageColor3 = Color3.new(1,1,0)
			yourTrade.add.inner.Text = "+"
		else
			-- open the change money input
			yourTrade.amount.TextBox.Text = ""
			yourTrade.amount.Visible = true
			yourTrade.add.ImageColor3 = Color3.new(1,0,0)
			yourTrade.add.inner.Text = "-"
		end
	end
	
	local function onPlayerRequest_requestOpenTradeWithPlayerReceived(playerTradeInitiator, tradeSessionId)
		local success = network:invoke("promptAction", playerTradeInitiator.Name .. " wants to trade! Would you like to trade with them?")
		
		if success then
			network:invokeServer("playerRequest_acceptTradeRequest", tradeSessionId)
		end
	end
	
	tradeFrame.buttons.leave.Activated:connect(function()
		module.endTrade(true)
	end)
	
	tradeFrame.buttons.accept.Activated:connect(function()
		network:invokeServer("playerRequest_updatePlayerTradeSessionData", lastTradeSessionData.guid, "state", "approved")
	end)
	
	tradeFrame.buttons.deny.Activated:connect(function()
		network:invokeServer("playerRequest_updatePlayerTradeSessionData", lastTradeSessionData.guid, "state", "denied")
	end)	
	
	yourTrade.add.MouseButton1Click:connect(onMouseButton1Click_addMoneyButton)
	yourTrade.amount.TextBox:GetPropertyChangedSignal("Text"):connect(onGoldInputAmountChanged)
	
	network:connect("signal_playerTradeRequest", "OnClientEvent", onPlayerRequest_requestOpenTradeWithPlayerReceived)
	network:connect("signal_tradeSessionChanged", "OnClientEvent", onTradeSessionChanged)
end

return module