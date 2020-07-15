local module = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network 	= modules.load("network")
		local utilities = modules.load("utilities")
	local itemData = require(replicatedStorage.itemData)

-- todo: remove this disgusting absolute reference


local player 						= game.Players.LocalPlayer
local content 						= script.Parent.Frame.content

local lastStorageDataReceived = nil
local storageSlotPairing 		= {}

local lastSelected

-- todo: fix
local animationInterface = require(game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("repo"):WaitForChild("animationInterface"))

function module.init(Modules)
	
	local uiCreator = Modules.uiCreator
	
	local function onStorageItemMouseEnter(storageItem)
		lastSelected = storageItem
		local storageSlotData = storageSlotPairing[storageItem]
		if storageSlotData then
			local itemBaseData = itemData[storageSlotData.id]
			if itemBaseData then
				network:invoke("populateItemHoverFrame", itemBaseData, "storage", storageSlotData)
			end
		end
	end
	
	local function onStorageItemMouseLeave(storageItem)
		if lastSelected == storageItem then
			-- clears last selected
			network:invoke("populateItemHoverFrame")
		end
	end
	
	local storageItemTemplate = script:WaitForChild("storageItemTemplate")
	
	local function onStorageItemDoubleClicked(storageItem)
		if storageSlotPairing[storageItem] then
			-- transfer item back to storage
			local success, reason = network:invokeServer("playerRequest_transferStorageToInventory", storageSlotPairing[storageItem])
			
		end
	end
	
	local function onGetStorageSlotDataFromStorageItem(storageItem)
		return storageSlotPairing[storageItem]
	end
	
	local function updateStorage(storageData)
		if storageData then
			lastStorageDataReceived = storageData
		end
		
		local currentSelected = game.GuiService.SelectedObject
		local selectionName, selectionParent
		if currentSelected and currentSelected:IsDescendantOf(script.Parent) then
			selectionName = currentSelected.Name
			selectionParent = currentSelected.Parent
		end
		
		if lastStorageDataReceived then
			storageSlotPairing = {}
			for i, storageItem in pairs(content:GetChildren()) do
				if storageItem:FindFirstChild("item") then
					storageItem:Destroy()
				end
			end
			
			local currCells	= 0
			
			for i, storageSlotData in pairs(lastStorageDataReceived) do
				
				local storageItemBaseData = itemData[storageSlotData.id]
							
				if storageItemBaseData then

						local storageItem 								= storageItemTemplate:Clone()
						
						if storageItemBaseData.canBeBound then
							local tag = Instance.new("BoolValue")
							tag.Name = "bindable"
							tag.Parent = storageItem
						end				
						
						storageItem.ImageTransparency 					= 0
						storageItem.item.Image 								= storageItemBaseData.image
						storageItem.item.ImageColor3 = Color3.new(1,1,1)
						if storageSlotData.dye then
							storageItem.item.ImageColor3 = Color3.fromRGB(storageSlotData.dye.r, storageSlotData.dye.g, storageSlotData.dye.b)
						end
						storageItem.item:WaitForChild("duplicateCount").Text 	= (storageSlotData.stacks and storageItemBaseData.canStack and storageSlotData.stacks > 1) and tostring(storageSlotData.stacks) or ""
						storageItem.Parent 								= content
						storageItem.LayoutOrder 							= i
						storageItem.Name 									= tostring(i)
						
						local storageDataCopy = utilities.copyTable(storageSlotData)
						storageDataCopy.position = i
						
						storageSlotPairing[storageItem.item] = storageDataCopy
						
						
						local titleColor
						if storageSlotData then
							titleColor = Modules.itemAcquistion.getTitleColorForInventorySlotData(storageSlotData) 
						end
						
						titleColor = titleColor or storageItemBaseData.nameColor
						
						storageItem.frame.ImageColor3 = titleColor or Color3.fromRGB(106, 105, 107)
						storageItem.shine.ImageColor3 = titleColor or Color3.fromRGB(179, 178, 185)
						storageItem.shine.ImageTransparency = titleColor and 0.47 or 0.66
						
						storageItem.item.MouseEnter:connect(function() onStorageItemMouseEnter(storageItem.item) end)
						storageItem.item.SelectionGained:connect(function() onStorageItemMouseEnter(storageItem.item) end)
						
						storageItem.item.MouseLeave:connect(function() onStorageItemMouseLeave(storageItem.item) end)
						storageItem.item.SelectionLost:connect(function() onStorageItemMouseLeave(storageItem.item) end)
						
			
						uiCreator.drag.setIsDragDropFrame(storageItem.item)
						uiCreator.setIsDoubleClickFrame(storageItem.item, 0.2, onStorageItemDoubleClicked)
				
						
						currCells = currCells + 1
			
				end
			end
			
			for i = 1, 20 do
				if not content:FindFirstChild(tostring(i)) then
					local storageItem 				= script.storageItemTemplate:Clone()
					storageItem.item.duplicateCount.Text 	= ""
					storageItem.item.Image = ""
					storageItem.item.Visible = true
					storageItem.frame.Visible = false
					storageItem.shine.Visible = false
					storageItem.ImageTransparency = 0.5
					storageItem.shadow.ImageTransparency = 0.5
					storageItem.Name 					= tostring(i)
					storageItem.LayoutOrder 			= i
					storageItem.Parent 				= content
					
					uiCreator.drag.setIsDragDropFrame(storageItem.item)
				end
			end
			
			content.CanvasSize = UDim2.new(0, 0, 0, math.ceil(math.max(currCells, 20) / 5) * 66)
			
			if selectionParent and selectionName then
				local newSelection = selectionParent:FindFirstChild(selectionName)
				if newSelection then
					game.GuiService.SelectedObject = newSelection
				end
			end
		end
	end
	
	
	function module.open()

		if script.Parent.Visible then
			Modules.playerMenu.closeSelected()
			if script.Parent.Parent.Parent.Visible then
				Modules.focus.toggle(script.Parent.Parent.Parent)
			end			
		else
			--script.Parent.Visible = true
			--[[
			script.Parent.Parent.Parent.UIScale.Scale = (Modules.input.menuScale or 1) * 0.75
			Modules.tween(script.Parent.Parent.Parent.UIScale, {"Scale"}, (Modules.input.menuScale or 1), 1, Enum.EasingStyle.Bounce)
			]]
			local globalData = network:invoke("getCacheValueByNameTag", "globalData")
			if globalData and globalData.itemStorage then
				updateStorage(globalData.itemStorage)
				Modules.playerMenu.selectMenu(script.Parent, Modules[script.Name])
			end
			
		end
	end		
	

	function module.close()
		Modules.playerMenu.closeSelected()
		if script.Parent.Parent.Parent.Visible then
			Modules.focus.toggle(script.Parent.Parent.Parent)
		end			
	end
	

	local function onPropogationRequestToSelf(propogationNameTag, propogationData)
		if propogationNameTag == "globalData" and script.Parent.Visible and propogationData.itemStorage then
			updateStorage(propogationData.itemStorage)
		end
	end
	
	network:connect("propogationRequestToSelf", "Event", onPropogationRequestToSelf)
	
	network:create("getStorageSlotDataFromStorageItem", "BindableFunction", "OnInvoke", onGetStorageSlotDataFromStorageItem)
	
	network:create("openStorage", "BindableFunction", "OnInvoke", function()
		module.open()
	end)
	network:create("closeStorage", "BindableFunction", "OnInvoke", function()
		module.close()
	end)
end

return module