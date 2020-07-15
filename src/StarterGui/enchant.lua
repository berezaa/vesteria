--Enchantment ui by berezaa

local module = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network 	= modules.load("network")
		local utilities = modules.load("utilities")
		local mapping 	= modules.load("mapping")
		local enchantment = modules.load("enchantment")
	local abilityLookup = require(replicatedStorage.abilityLookup)

	
function module.dragItem(inventorySlotData)
	
end

local currentBall


function module.init(Modules)

	local frame = frame.gameUI.menu_enchant
	
	local tween = Modules.tween
	local localization = Modules.localization
	
	function module.close()
		frame.Visible = false
		Modules.playerMenu.closeSelected()	
		-- disgusting
		if frame.Parent.Parent.Visible then
			Modules.focus.toggle(frame.Parent.Parent)
		end
	end	
	
	local function emit(n, p, s)

		n = n or 1
		p = p or 1
		for i=1,n do
			
			local s = s or math.random(1,3) == 2 and math.random(2,6)/2 or 1
			
			local sprite = frame.sprite:Clone()
			local start = UDim2.new(math.random(),0,1,0)
			sprite.Position = start 
			
			local lifetime = math.random(40,150)/100 
			
			sprite.Parent = frame.curve.sprites
			
			
			
			sprite.ImageTransparency = 1
			sprite.Size = UDim2.new(0,10,0,10)
			sprite.Visible = true
			
			local endPosition = UDim2.new(start.X.Scale, math.random(-50,50) * lifetime * p, start.Y.Scale, -math.random(20,200) * lifetime * p)
			
			lifetime = lifetime * s
			
			game.Debris:AddItem(sprite, lifetime + 0.1)
			
			tween(sprite, {"Position"}, endPosition, lifetime)
			
			
			
			tween(sprite, {"Size"}, UDim2.new(0,20 * s,0,20 * s), lifetime/2)
			spawn(function()
				wait(lifetime/2)
				tween(sprite, {"Size"}, UDim2.new(0,10,0,10), lifetime/2)
			end)
			
			local transparency = math.random(30,40)/100
			
			tween(sprite, {"ImageTransparency"}, { 1 - (1-transparency) / s^2 }, lifetime/4)
			spawn(function()
				wait(lifetime * 3/4)
				tween(sprite, {"ImageTransparency"}, {1}, lifetime/4)
			end)
		end		
	end	
	
	spawn(function()
		while wait(1) do
			for i=1,15 do
				delay(math.random(), function() emit() end)
			end
		end
	end)
	
	local enchantFrame = script.Parent
	
	local debounce = false
	
	local currentAbilitySlotData
	local enchantItemSlotData	
	local locationView
	


	
	function module.reset()
	
		for i, enchantButton in pairs(enchantFrame.enchantments.contents:GetChildren()) do
			if enchantButton:IsA("GuiObject") then
				enchantButton:Destroy()
			end
		end	
		
		tween(enchantFrame.button, {"ImageColor3"}, {Color3.fromRGB(113, 113, 113)}, 0.5)
		
		enchantFrame.cost.Visible = false
		
		enchantFrame.input.equipItemButton.Image = "rbxassetid://2528902611"
		enchantFrame.input.equipItemButton.ImageTransparency = 0.6
		enchantFrame.input.equipItemButton.ImageColor3 = Color3.new(1,1,1)
		enchantFrame.input.shine.Visible = false
		enchantFrame.input.frame.Visible = false	
--		enchantFrame.input.ImageTransparency = 0.4
		
		enchantFrame.output.equipItemButton.ImageTransparency = 1
		enchantFrame.output.frame.Visible = false	
		enchantFrame.output.shine.Visible = false		
		enchantFrame.output.ImageTransparency = 0.4
		
		currentAbilitySlotData = nil
		enchantItemSlotData = nil
		locationView = nil
	end
	
	local currentButton
	

		
	local playerData
	
	function module.open(ball)
		currentBall = ball
		module.reset()
		Modules.playerMenu.selectMenu(frame, Modules[script.Name])
		network:fire("localSignal_enchantOpened")
	end	
	
	
	local enchantmentPairing = {}
	local selectedEnchantment 
	
	local function fill(itemButton, abilitySlotData)
		
		currentButton = itemButton
		
		enchantmentPairing = {}
		selectedEnchantment = nil
		
		playerData = network:invoke("getLocalPlayerDataCache")
		local abilityBaseData = abilityLookup[abilitySlotData.id](playerData)
		
		-- OPTIONS ! :D
		for i, enchantButton in pairs(enchantFrame.enchantments.contents:GetChildren()) do
			if enchantButton:IsA("GuiObject") then
				enchantButton:Destroy()
			end
		end
		
		itemButton.Image = abilityBaseData.image
		
		itemButton.ImageColor3 = Color3.new(1,1,1)

		itemButton.Parent.frame.Visible = true
		itemButton.Parent.shine.Visible = true
		itemButton.Parent.ImageTransparency = 0
		itemButton.ImageTransparency = 0		
		
		local metadata = abilityBaseData.metadata
		if metadata then
			-- your standard run of the mill upgrade
			if metadata.upgradeCost and metadata.maxRank then
				if abilitySlotData.rank < metadata.maxRank then
					
					local enchantButton = enchantFrame.enchantments.sampleItem:Clone()
					enchantButton.item.itemThumbnail.Image = abilityBaseData.image
					local abilityName = abilityBaseData.name and localization.translate(abilityBaseData.name) or "???"
					enchantButton.itemName.Text = abilityName .. " +" .. abilitySlotData.rank
					enchantButton.locked.Visible = false
					enchantButton.LayoutOrder = 1
					enchantButton.Parent = enchantFrame.enchantments.contents
					enchantButton.abilityPoints.amount.Text = metadata.upgradeCost .. " AP"
					enchantButton.Visible = true
					enchantmentPairing[enchantButton] = {id = abilitySlotData.id; request = "upgrade"}
					
					local function selected()
						if not enchantButton.locked.Visible then
							network:invoke("populateItemHoverFrameWithAbility", 
								abilityBaseData, abilitySlotData.rank, 
								abilityBaseData, abilitySlotData.rank + 1
							)
						end					
					end
					enchantButton.MouseEnter:connect(selected)
					enchantButton.SelectionGained:connect(selected)
					enchantButton.item.itemThumbnail.Active = false
					
				
					local function unselected()
						network:invoke("populateItemHoverFrame")		
					end	
					enchantButton.MouseLeave:connect(unselected)
					enchantButton.SelectionLost:connect(unselected)				
					
				end
			end
			-- variants
			if metadata.variants then
				if abilitySlotData.variant == nil or metadata.variants[abilitySlotData.variant].default then
					for variantName, variant in pairs(metadata.variants) do
						if variant.cost and not variant.default then
							local abilityExecutionData = {variant = variantName}
							local variantBaseData = abilityLookup[abilitySlotData.id](nil, abilityExecutionData)
							if variantBaseData then
								local enchantButton = enchantFrame.enchantments.sampleItem:Clone()
								enchantButton.item.itemThumbnail.Image = variantBaseData.image
								local abilityName = variantBaseData.name and localization.translate(variantBaseData.name) or "???"
								enchantButton.itemName.Text = abilityName .. (abilitySlotData.rank > 1 and (" +" .. (abilitySlotData.rank - 1)) or "")
								enchantButton.abilityPoints.amount.Text = variant.cost .. " AP"
								if variant.requirement and variant.requirement(playerData) then
									enchantButton.locked.Visible = false
									enchantButton.LayoutOrder = 3										
								else
									enchantButton.locked.Visible = true
									enchantButton.LayoutOrder = 5									
								end
								enchantButton.Parent = enchantFrame.enchantments.contents
								enchantButton.Visible = true
								enchantmentPairing[enchantButton] = {id = abilitySlotData.id; request = "variant"; variant = variantName}
								enchantButton.item.itemThumbnail.Active = false
								
								local function selected()
									if not enchantButton.locked.Visible then
										network:invoke("populateItemHoverFrameWithAbility", 
											abilityBaseData, abilitySlotData.rank, 
											variantBaseData, abilitySlotData.rank
										)								
									end					
								end
								enchantButton.MouseEnter:connect(selected)
								enchantButton.SelectionGained:connect(selected)
							
								local function unselected()
									network:invoke("populateItemHoverFrame")		
								end	
								enchantButton.MouseLeave:connect(unselected)
								enchantButton.SelectionLost:connect(unselected)								
							end
						end
					end
				end
			end
		end
		
		for i, enchantButton in pairs(enchantFrame.enchantments.contents:GetChildren()) do
			if enchantButton:IsA("GuiObject") then
				enchantButton.Activated:connect(function()
					selectedEnchantment = enchantButton
					tween(enchantFrame.button, {"ImageColor3"}, {Color3.fromRGB(87, 211, 217)}, 0.5)
				end)
			end
		end		
		
		local titleColor
		
		--[[
		if abilitySlotData then
			titleColor = Modules.itemAcquistion.getTitleColorForInventorySlotData(abilitySlotData) 
		end
		]]
		
		titleColor = titleColor or Color3.new(1,1,1)
		
		itemButton.Parent.frame.ImageColor3 = titleColor or Color3.fromRGB(106, 105, 107)
		itemButton.Parent.shine.ImageColor3 = titleColor or Color3.fromRGB(179, 178, 185)
		itemButton.Parent.shine.ImageTransparency = titleColor and 0.47 or 0.63				
	end
	

	enchantFrame.button.Activated:Connect(function()
		
		if not currentAbilitySlotData then
			return false
		end
		if not selectedEnchantment then
			return false
		end
		local request = enchantmentPairing[selectedEnchantment]
		
		if not debounce then
			debounce = true
			
			local success, reason = network:invokeServer("playerRequest_enchantAbility", currentBall, request)
			if success then
				selectedEnchantment = nil
				enchantFrame.curve.shine.ImageTransparency = 0
				enchantFrame.curve.shine.ImageColor3 = Color3.fromRGB(0, 230, 255)
				emit(70,1.5)
				tween(enchantFrame.curve.shine, {"ImageTransparency", "ImageColor3"}, {0.5, Color3.fromRGB(14, 123, 125)}, 1)
				utilities.playSound("itemEnchanted")
--				fill(currentButton, enchantItemSlotData)
--				module.dragItem(enchantItemSlotData, locationView)
--				module.reset()
				tween(enchantFrame.button, {"ImageColor3"}, {Color3.fromRGB(113, 113, 113)}, 0.5)
			else
				warn("No enchanting allowed"..reason)
			end
			debounce = false
		end
	end)	
	
	function module.dragItem(inventorySlotData, view)
		module.reset()
		enchantFrame.input.equipItemButton.ImageTransparency = 0
		enchantFrame.input.equipItemButton.ImageColor3 = Color3.new(1,1,1)

		locationView = view

		currentAbilitySlotData = inventorySlotData		

		
		fill(enchantFrame.input.equipItemButton, currentAbilitySlotData)
		if enchantItemSlotData then	

		end
								
	
	end
	

	
	local function itemHover()
		if currentAbilitySlotData then
			playerData = network:invoke("getLocalPlayerDataCache")
			local abilityBaseData = abilityLookup[currentAbilitySlotData.id](playerData)
			network:invoke("populateItemHoverFrameWithAbility", abilityBaseData, currentAbilitySlotData.rank)
		end
	end

	
	local function mouseLeave()
		network:invoke("populateItemHoverFrame")		
	end
	
	
	local function abilityDataUpdated(abilities)
		if currentAbilitySlotData then
			for i, abilitySlotData in pairs(abilities) do
				if abilitySlotData.id == currentAbilitySlotData.id then
					currentAbilitySlotData = abilitySlotData
					fill(enchantFrame.input.equipItemButton, abilitySlotData)
					break
				end
			end
		end
	end
	
	local function onPropogationRequestToSelf(propogationNameTag, propogationData)
		if propogationNameTag == "abilities" then
			abilityDataUpdated(propogationData)
		end
	end	
	
	network:connect("propogationRequestToSelf", "Event", onPropogationRequestToSelf)
	
	enchantFrame.input.equipItemButton.MouseEnter:connect(itemHover)
	enchantFrame.input.equipItemButton.SelectionGained:connect(itemHover)
	
	enchantFrame.input.equipItemButton.MouseLeave:connect(mouseLeave)
	

	enchantFrame.output.equipItemButton.MouseLeave:connect(mouseLeave)	
	
end



return module
