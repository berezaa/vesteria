local module = {}


local replicatedStorage = game:GetService("ReplicatedStorage")

local modules = require(replicatedStorage.modules)
local network = modules.load("network")
local utilities = modules.load("utilities")
local mapping = modules.load("mapping")
local enchantment = modules.load("enchantment")
local itemData = require(replicatedStorage:WaitForChild("itemData"))
local itemAttributes = require(replicatedStorage:WaitForChild("itemAttributes"))




local content = script.Parent.content
local viewport = script.Parent.character.ViewportFrame
local player = game.Players.LocalPlayer

function module.show()
	script.Parent.Visible = not script.Parent.Visible
end
function module.hide()
	script.Parent.Visible = false
end

script.Parent.close.Activated:connect(module.hide)

local equipmentSlotPairing = {}
local lastSelected

function module.init(Modules)
	local function getInventoryCountLookupTableByItemId()
		local lookupTable = {}
		local inventoryLastGot = network:invoke("getCacheValueByNameTag", "inventory")
		
		for i, inventorySlotData in pairs(inventoryLastGot) do
			if lookupTable[inventorySlotData.id] then
				lookupTable[inventorySlotData.id] = lookupTable[inventorySlotData.id] + (inventorySlotData.stacks or 1)
			else
				lookupTable[inventorySlotData.id] = inventorySlotData.stacks or 1
			end
		end
		
		return lookupTable
	end

	local function onInventoryItemMouseEnter(inventoryItem)
		lastSelected = inventoryItem
		local inventorySlotData = equipmentSlotPairing[inventoryItem]
		if inventorySlotData then
			local itemBaseData = itemData[inventorySlotData.id]
			if itemBaseData then
				network:invoke("populateItemHoverFrame", itemBaseData, "equipment", inventorySlotData)
			end
		end
	end
	
	local function onInventoryItemMouseLeave(inventoryItem)
		if lastSelected == inventoryItem then
			-- clears last selected
			network:invoke("populateItemHoverFrame")
		end
	end
	
	local function getEquipmentDataByEquipmentPosition(equipment, equipmentPosition)
		for i, equipmentData in pairs(equipment) do
			if equipmentData.position == equipmentPosition then
				return equipmentData
			end
		end
	end
	
	local function int__updateEquipmentFrame(equipmentDataCollection)
		equipmentDataCollection = equipmentDataCollection or network:invoke("getCacheValueByNameTag", "equipment")
		
		-- reset the previous slot pairing
		equipmentSlotPairing = {}
		
		-- update current equipment slots
		for i, equipmentSlotData in pairs(equipmentDataCollection) do
			local positionName = mapping.getMappingByValue("equipmentPosition", equipmentSlotData.position)
			if positionName and equipmentSlotData.id and content:FindFirstChild(positionName) then
				local itemBaseData = itemData[equipmentSlotData.id]
				local itemButton = content[positionName].equipItemButton
				
				if itemBaseData then
					itemButton.Image 				= itemBaseData.image
					
					itemButton.ImageColor3 = Color3.new(1,1,1)
					if equipmentSlotData.dye then
						itemButton.ImageColor3 = Color3.fromRGB(equipmentSlotData.dye.r, equipmentSlotData.dye.g, equipmentSlotData.dye.b)
					end
					
					equipmentSlotPairing[itemButton] = equipmentSlotData
					
					itemButton.Parent.frame.Visible = true
					
					
					if itemButton.Parent:FindFirstChild("icon") then
						itemButton.Parent.icon.Visible = false
					end					
					
					itemButton.Parent.ImageTransparency = 0
				--	itemButton.Parent.shadow.ImageTransparency = 0
					itemButton.Parent.title.TextTransparency = 0	
					itemButton.Parent.title.TextStrokeTransparency = 0.2
					
					local titleColor, itemTier
					if equipmentSlotData then
						titleColor, itemTier = Modules.itemAcquistion.getTitleColorForInventorySlotData(equipmentSlotData) 
					end
					
					local inventoryItem = itemButton.Parent
					inventoryItem.attribute.Visible = false
						
					
					if equipmentSlotData.attribute then
						local attributeData = itemAttributes[equipmentSlotData.attribute]
						if attributeData and attributeData.color then
							inventoryItem.attribute.ImageColor3 = attributeData.color
							inventoryItem.attribute.Visible = true
						end
					end					
					
					
					inventoryItem.stars.Visible = false
					local upgrades = equipmentSlotData.successfulUpgrades
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
					
					
					itemButton.Parent.shine.Visible = titleColor ~= nil and itemTier and itemTier > 1 
					Modules.fx.setFlash(itemButton.Parent.frame, itemButton.Parent.shine.Visible)
					itemButton.Parent.frame.ImageColor3 = (itemTier and itemTier > 1 and titleColor) or Color3.fromRGB(106, 105, 107)
					itemButton.Parent.shine.ImageColor3 = titleColor or Color3.fromRGB(179, 178, 185)
						
					
					if equipmentSlotData.position == mapping.equipmentPosition.weapon then
						local arrowEqpData 	= getEquipmentDataByEquipmentPosition(equipmentDataCollection, mapping.equipmentPosition.arrow)
						local weaponEqpData = getEquipmentDataByEquipmentPosition(equipmentDataCollection, mapping.equipmentPosition.weapon)
						
						if weaponEqpData and itemData[weaponEqpData.id].equipmentType == "bow" then
							if arrowEqpData then
								local lut = getInventoryCountLookupTableByItemId()
								
								content.weapon.ammo.amount.Text = tostring(lut[arrowEqpData.id] or 0)
								content.weapon.ammo.icon.Image = itemData[arrowEqpData.id].image
								content.weapon.ammo.Visible = true
							else
								content.weapon.ammo.Visible = false
							end
						else
							content.weapon.ammo.Visible = false
						end
					end
				end
			end
		end
		
		-- reset untouched slots to blank image
		for i, equipmentSlotUI in pairs(content:GetChildren()) do
			if equipmentSlotUI:FindFirstChild("frame") and not equipmentSlotPairing[equipmentSlotUI.equipItemButton] then
				equipmentSlotUI.equipItemButton.Image = ""
				local itemButton = equipmentSlotUI
					itemButton.frame.Visible = false
					itemButton.shine.Visible = false
					
					if itemButton:FindFirstChild("icon") then
						itemButton.icon.Visible = true
					end
					itemButton.stars.Visible = false
					itemButton.attribute.Visible = false
					itemButton.ImageTransparency = 0
			--		itemButton.shadow.ImageTransparency = 0.4
					itemButton.title.TextTransparency = 0.6
					itemButton.title.TextStrokeTransparency = 0.6
			
			end
		end
		
		if viewport:FindFirstChild("entity") then
			viewport.entity:Destroy()
		end
		
		if viewport:FindFirstChild("entity2") then
			viewport.entity2:Destroy()
		end		
		
		local camera = viewport.CurrentCamera
		if camera == nil then
			camera = Instance.new("Camera")
			camera.Parent = viewport
			viewport.CurrentCamera = camera
		end
		
		local client = game.Players.LocalPlayer		
		local character = client.Character		
		local mask = viewport.characterMask
		
		local characterAppearanceData = {}
		characterAppearanceData.equipment 	= network:invoke("getCacheValueByNameTag", "equipment") 
		characterAppearanceData.accessories = network:invoke("getCacheValueByNameTag", "accessories")
				
		local characterRender = network:invoke("createRenderCharacterContainerFromCharacterAppearanceData",mask, characterAppearanceData or {}, client)
		characterRender.Parent = workspace.CurrentCamera
		
		local animationController = characterRender.entity:WaitForChild("AnimationController")
		local currentEquipment = network:invoke("getCurrentlyEquippedForRenderCharacter", characterRender.entity)
		
		local weaponType do
			if currentEquipment["1"] then
				weaponType = currentEquipment["1"].baseData.equipmentType
			end
		end
		
		local track = network:invoke("getMovementAnimationForCharacter", animationController, "idling", weaponType, nil)
		
		if track then

			
			spawn(function()
				
				if characterRender then
					
					local entity 	= characterRender.entity
--					entity.Parent 	= viewport
					
--					characterRender:Destroy()
					
					local focus 	= CFrame.new(entity.PrimaryPart.Position + entity.PrimaryPart.CFrame.lookVector * 6.5, entity.PrimaryPart.Position) * CFrame.new(-1,0,0)
					camera.CFrame 	= CFrame.new(focus.p + Vector3.new(0,1.5,0), entity.PrimaryPart.Position + Vector3.new(0,0.5,0))
				end
				
				if typeof(track) == "Instance" then
					track:Play()
				elseif typeof(track) == "table" then
					for ii, obj in pairs(track) do
						obj:Play()
					end
				end							
			
				while true do
					wait(0.1)
					
					if typeof(track) == "Instance" then
						if track.Length > 0 then
							break
						end
					elseif typeof(track) == "table" then
						local isGood = true
						for ii, obj in pairs(track) do
							if track.Length == 0 then
								isGood = false
							end
						end
						
						if isGood then
							break
						end
					end
				end
				
			
				if characterRender then
					local entity 	= characterRender.entity
					entity.Parent 	= viewport
					
					characterRender:Destroy()
					--[[
					local focus 	= CFrame.new(entity.PrimaryPart.Position + entity.PrimaryPart.CFrame.lookVector * 6.3, entity.PrimaryPart.Position) * CFrame.new(-3,0,0)
					camera.CFrame 	= CFrame.new(focus.p + Vector3.new(0,1.5,0), entity.PrimaryPart.Position + Vector3.new(0,0.5,0))
					]]
				end
				
			end)
		else
			local track = animationController:LoadAnimation(mask.idle)
			track.Looped = true
			track.Priority = Enum.AnimationPriority.Idle
			track:Play()				
		end

--		local track = animationController:LoadAnimation(mask.idle)
--		track.Looped = true
--		track.Priority = Enum.AnimationPriority.Idle
--		track:Play()
	end
	
	
	
	local function onGetEquipmentSlotDataByEquipmentSlotUI(equipmentSlotUI)
		return equipmentSlotPairing[equipmentSlotUI]
	end
	
	local levels = Modules.levels
	local tween = Modules.tween
	

	
	local function onPropogationRequestToSelf(propogationNameTag, propogationValue)
		if propogationNameTag == "equipment" then
			int__updateEquipmentFrame(propogationValue)
		end
	end
	
	module.update = function(...)
		int__updateEquipmentFrame(...)
	end
	
	local function main()
		
		network:connect("propogationRequestToSelf", "Event", onPropogationRequestToSelf)
		network:create("getEquipmentSlotDataByEquipmentSlotUI", "BindableFunction", "OnInvoke", onGetEquipmentSlotDataByEquipmentSlotUI)
		
		for i,item in pairs(script.Parent.content:GetChildren()) do
			if item:FindFirstChild("equipItemButton") then
				item.equipItemButton.MouseEnter:connect(function() onInventoryItemMouseEnter(item.equipItemButton) end)
				item.equipItemButton.MouseLeave:connect(function() onInventoryItemMouseLeave(item.equipItemButton) end)
				
				item.equipItemButton.SelectionGained:connect(function() onInventoryItemMouseEnter(item.equipItemButton) end)
				item.equipItemButton.SelectionLost:connect(function() onInventoryItemMouseLeave(item.equipItemButton) end)
				
				item.equipItemButton.Activated:connect(function()
					if Modules.inventory.isEnchantingEquipment then
						Modules.inventory.enchantItem(item.equipItemButton)
					end
				end)
			end
		end
	end
	
	main()

end

function module.postInit(Modules)
	module.update()
	local network = Modules.network
	network:connect("signal_isEnchantingEquipmentSet", "Event", function(value, inventorySlotData_enchantment)
		for i, equipmentButton in pairs(script.Parent.content:GetChildren()) do
			if equipmentButton:FindFirstChild("equipItemButton") then
				if value and inventorySlotData_enchantment then
					local equipmentSlotData = equipmentSlotPairing[equipmentButton.equipItemButton]
					if equipmentSlotData then
						equipmentButton.blocked.Visible = false
						local equipmentBaseData = itemData[equipmentSlotData.id]
					
						local itemBaseData_enchantment = itemData[inventorySlotData_enchantment.id]
						local cost = itemBaseData_enchantment.upgradeCost or 1
						local max = equipmentBaseData.maxUpgrades

						
						local canEnchant, indexToRemove = enchantment.enchantmentCanBeAppliedToItem(inventorySlotData_enchantment, equipmentSlotData)
						local blocked = not canEnchant

						equipmentButton.blocked.Visible = blocked
												
					end
				else
					equipmentButton.blocked.Visible = false
				end
			end
			
		end
	end)
end


return module