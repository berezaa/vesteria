-- uiCreator controls most dyanmic ui elements (text labels, item notifcations, etc.) as well as button draggingb between menus

local module = {}
	module.drag = {}	

-- service declarations
local textService = game:GetService("TextService")
local tweenService = game:GetService("TweenService")
local userInputService = game:GetService("UserInputService")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- module requirements
local modules = require(replicatedStorage.modules)
local network = modules.load("network")
local utilities = modules.load("utilities")
local mapping = modules.load("mapping")
local tween	= modules.load("tween")
local localization = modules.load("localization")
		
local itemData = require(replicatedStorage:WaitForChild("itemData"))
local itemAttributes = require(replicatedStorage:WaitForChild("itemAttributes"))
local abilityLookup = require(replicatedStorage.abilityLookup)

local BASE_TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

local interactionPromptCache = {}


local dragDropFrameCollection = {}
local currentDragFrameOriginator = nil

-- ui references
local ui = script.Parent
local menu_inventory = ui.menu_inventory
local menu_trade = ui.menu_trade
local menu_enchant = ui.menu_enchant
local menu_shop = ui.menu_shop
local menu_storage = ui.menu_storage
local menu_equipment = ui.menu_equipment

local interactionPromptsFrame = ui.interactionPrompts
local notifcationsFrame = ui.notifcationsFrame

local dragDropMask = ui.dragDropMask

network:create("setGameUIEnabled", "BindableEvent", "Event", function(enabled)
	ui.Enabled = enabled
end)

local Modules

function module.init(mods)
	Modules = mods
	
	local function inputUpdate()
		if Modules.input.mode.Value == "mobile" then
			script.Parent.interactionPrompts.Position = UDim2.new(1,-110,1,-200)
			script.Parent.interactionPrompts.UIScale.Scale = Modules.input.menuScale or 1
		else
			script.Parent.interactionPrompts.Position = UDim2.new(1,-110,1,-130)
			script.Parent.interactionPrompts.UIScale.Scale = 1
		end
	end
	inputUpdate()
	Modules.input.mode.Changed:connect(inputUpdate)
end


local IS_PROCESSING_INVENTORY_SLOT_SWITCH = false

local lastMoneyUpdateTime

function module.showCurrency(amount)
	if not Modules then
		return false
	end
		
	
	utilities.playSound("coins")
	
	local template = --[[interactionPromptsFrame:FindFirstChild("moneyObtained") or]] script.moneyObtained:Clone()
	
	local count = template:FindFirstChild("count")
	
	if count then
		template.backdrop.UIScale.Scale = 1.15 + math.clamp(count.Value/150,0,0.75)
		tween(template.backdrop.UIScale, {"Scale"}, 1, 0.5)		
	else
		template.Size = UDim2.new(0,0,0,42)
		count = Instance.new("IntValue")
		count.Name = "count"
		count.Value = 0
		count.Parent = template
	end	
	
	-- display coin effect
	local iconImage = "rbxassetid://2535600080"
	local iconAmount = 1
	if amount >= 1e6 then
		iconImage = "rbxassetid://2536432897"	
		if amount >= 5e8 then
			iconAmount = 4
		elseif amount >= 1e8 then
			iconAmount = 3
		elseif amount >= 1e7 then
			iconAmount = 2
		end				
	elseif amount >= 1e3 then
		-- silver
		iconImage = "rbxassetid://2535600034"
		if amount >= 5e5 then
			iconAmount = 4
		elseif amount >= 1e5 then
			iconAmount = 3
		elseif amount >= 1e4 then
			iconAmount = 2
		end
	else
		-- bronze
		iconImage = "rbxassetid://2535600080"
		if amount >= 5e2 then
			iconAmount = 4
		elseif amount >= 1e2 then
			iconAmount = 3
		elseif amount >= 1e1 then
			iconAmount = 2
		end
	end	
	for i=1, iconAmount do
		local coin = script.coin:Clone()
		local finalPosition = UDim2.new(0.5, math.random(-100,100), 0.5, math.random(-50,50))
		coin.Parent = template
		coin.Visible = true
		coin.Image = iconImage
		coin.ImageTransparency = 1
		coin.Size = UDim2.new(0,20,0,20)
		tween(coin, {"Position", "ImageTransparency", "Size"}, {finalPosition, 0, UDim2.new(0,32,0,32)}, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		delay(1, function()
			if coin and coin.Parent then
				tween(coin, {"ImageTransparency"}, {1}, 0.5)
				game.Debris:AddItem(coin, 0.5)
			end
		end)
	end	
	

	
	count.Value = count.Value + 1
	
	local moneyUpdateTime = tick()
	lastMoneyUpdateTime = moneyUpdateTime
	
	template.amount.Value = template.amount.Value + amount	
	
	local totalAmount = template.amount.Value
	
	Modules.money.setLabelAmount(template.backdrop.money, totalAmount)
	
	local xSize = template.backdrop.money.amount.AbsoluteSize.X + 32 + 16
	template.backdrop.money.Size = UDim2.new(0, xSize, template.backdrop.money.Size.Y.Scale, template.backdrop.money.Size.Y.Offset)
	
	template.Visible = true
	template.Parent = interactionPromptsFrame
	local duration = 5
	
	local goalSize = UDim2.new(0, xSize + 35, 0, 42)
	
	tween(template,{"Size"},goalSize,0.5)
	spawn(function()
		wait(duration)
		
	--	if lastMoneyUpdateTime == moneyUpdateTime then
			tween(template,{"Size"},UDim2.new(0,0,0,42),0.5)
			wait(0.5)
			if lastMoneyUpdateTime == moneyUpdateTime then
				template:Destroy()		
			end	
	--	end
		

	end)	
end

function module.showLootUnlock(monsterViewport, realItem, tabColor, flareColor)
	flareColor = flareColor or tabColor
	local template = script.monsterBook:Clone()
	template.backdrop.contents.thumbnail.Image = realItem.image
	template.backdrop.contents.holder:ClearAllChildren()
	monsterViewport:Clone().Parent = template.backdrop.contents.holder
	template.backdrop.ImageColor3 = tabColor
	template.flare.ImageColor3 = flareColor
	local goalSize = template.Size	
	
	template.Visible = true
	template.Parent = interactionPromptsFrame
	
	local indicator = template:WaitForChild("flare"):clone()
	indicator.Parent = template
	indicator.Size = UDim2.new(1,6,1,0)
	indicator.Position = UDim2.new(1,0,0.5,0)
	indicator.Visible = true
	for i=1,4 do
		local flare = template:WaitForChild("flare"):clone()
		flare.Parent = template
		flare.Visible = true
		flare.Size = UDim2.new(1,4,1,4)
		flare.Position = UDim2.new(0.5,0,0.5,0)
		flare.AnchorPoint = Vector2.new(0.5,0.5)
		local x = (260 - 40*i)
		local y = (14 - 2*i)

		local EndSize = UDim2.new(1,x,1,y)
		tween(flare,{"Size","ImageTransparency"},{EndSize, 1},0.7*i)
	end	
	
	tween(template,{"Size"},goalSize,0.5)
	spawn(function()
		wait(10)
		tween(template,{"Size"},UDim2.new(0,0,0,60),0.5)
		wait(0.5)
		template:Destroy()
	end)	
end

function module.showItemPickup(realItem, amount, metadata)
	
	amount = metadata.stacks or amount or 1
	
	
	local itemname = realItem.name .. ((metadata and metadata.upgrades and metadata.upgrades > 0 and " +"..(metadata.successfulUpgrades or 0)) or "") or "Unknown"
	
	metadata = metadata or {}
	metadata.id = metadata.id or realItem.id
	
	local attributeColor 
	if metadata.attribute then
		local attribute = itemAttributes[metadata.attribute]
		if attribute then
			attributeColor = attribute.color
			if attribute.prefix then
				itemname = attribute.prefix .. " " .. itemname
			end
		end
	end		
	
	local frameExisted
	local template --= interactionPromptsFrame:FindFirstChild(itemname) 
	if template then
		frameExisted = true
	else
		template = script.itemObtained:Clone()
		template.Size = UDim2.new(0,0,0,60)
	end
	
	template.Name = itemname
	
	template.backdrop.contents.item.attribute.Visible = false
	
	if attributeColor then
		template.backdrop.contents.item.attribute.ImageColor3 = attributeColor
		template.backdrop.contents.item.attribute.Visible = true		
	end

	template.backdrop.contents.title.Text = itemname 
--	template.backdrop.contents.thumbnail.Image = realItem.image
	template.backdrop.contents.item.thumbnail.Image = realItem.image
	
	template.amount.Value = template.amount.Value + amount
	local currentAmount = template.amount.Value 
	template.backdrop.contents.item.thumbnail.duplicateCount.Text = currentAmount
	template.backdrop.contents.item.thumbnail.duplicateCount.Visible = currentAmount > 1
	
	if frameExisted then
		template.backdrop.UIScale.Scale = 1.15 + math.clamp(currentAmount/150,0,0.75)
		tween(template.backdrop.UIScale, {"Scale"}, 1, 0.5)			
	end

	
	local titleColor, itemTier
	if itemData then
		titleColor, itemTier = Modules.itemAcquistion.getTitleColorForInventorySlotData(metadata) 
	end
						
	template.backdrop.contents.item.shine.Visible = titleColor ~= nil and itemTier and itemTier > 1
	template.backdrop.contents.item.shine.ImageColor3 = titleColor or Color3.fromRGB(179, 178, 185)
	template.backdrop.contents.item.frame.ImageColor3 = (itemTier and itemTier > 1 and titleColor) or Color3.fromRGB(106, 105, 107)
	template.backdrop.contents.item.shine.ImageColor3 = titleColor or Color3.fromRGB(179, 178, 185)	
	
	template.backdrop.contents.title.TextColor3 = titleColor or Color3.new(1,1,1)				
		
	template.backdrop.contents.item.thumbnail.ImageColor3 = Color3.new(1,1,1)
	
	local dye = metadata and metadata.dye
	if dye then
		template.backdrop.contents.item.thumbnail.ImageColor3 = Color3.fromRGB(dye.r, dye.g, dye.b)
	end
	
	template.Visible = true
	template.Parent = interactionPromptsFrame
	
	Modules.fx.setFlash(template.backdrop.contents.item.frame, template.backdrop.contents.item.shine.Visible)
	
	local extents = game.TextService:GetTextSize(template.backdrop.contents.title.Text,18,Enum.Font.SourceSansBold,Vector2.new(90,36))
	local goalSize = UDim2.new(0,125+extents.X,0,60)
	
	template.backdrop.contents.title.Size = UDim2.new(0,extents.X+40,1,0)
	
	local indicator
	
	local duration = 2
	if (realItem.rarity and realItem.rarity == "Legendary") then
		duration = duration + 2.5
		indicator = template:WaitForChild("flare"):clone()
		indicator.Parent = template
		indicator.Size = UDim2.new(1,8,1,0)
		indicator.AnchorPoint = Vector2.new(0.5,0.5)
		indicator.Position = UDim2.new(0.5,0,0.5,0)
		indicator.ImageColor3 = Color3.fromRGB(174, 34, 234)
		indicator.Visible = true
		for i=1,6 do
			local flare = template:WaitForChild("flare"):clone()
			flare.Parent = template
			flare.Visible = true
			flare.ImageColor3 = Color3.fromRGB(174, 34, 234)
			flare.Size = UDim2.new(1,4,1,4)
			flare.Position = UDim2.new(0.5,0,0.5,0)
			flare.AnchorPoint = Vector2.new(0.5,0.5)
			local x = (1000 - 53*i)
			local y = (28 - 3*i)
			local EndPosition = UDim2.new(1,y/2,0.5,0)
			local EndSize = UDim2.new(1,x,1,y)
			tween(flare,{"Size","ImageTransparency"},{EndSize, 1},0.7*i)
		end		
	elseif (realItem.rarity and realItem.rarity == "Rare") or (realItem.category and realItem.category == "equipment") then
		duration = duration + 1.5
		indicator = template:WaitForChild("flare"):clone()
		indicator.Parent = template
		indicator.Size = UDim2.new(1,8,1,0)
		indicator.AnchorPoint = Vector2.new(0.5,0.5)
		indicator.Position = UDim2.new(0.5,0,0.5,0)
		indicator.Visible = true
		for i=1,4 do
			local flare = template:WaitForChild("flare"):clone()
			flare.Parent = template
			flare.Visible = true
			flare.Size = UDim2.new(1,4,1,4)
			flare.Position = UDim2.new(0.5,0,0.5,0)
			flare.AnchorPoint = Vector2.new(0.5,0.5)
			local x = (500 - 40*i)
			local y = (14 - 2*i)

			local EndSize = UDim2.new(1,x,1,y)
			tween(flare,{"Size","ImageTransparency"},{EndSize, 1},0.7*i)
		end
	
	end
	if not frameExisted then
		tween(template,{"Size"},goalSize,0.5)
	end
	spawn(function()
		wait(duration)
		if indicator then
			tween(indicator, {"ImageTransparency"}, 1, 0.5)
		end
		if template.Parent and currentAmount == template.amount.Value then
			tween(template,{"Size"},UDim2.new(0,0,0,60),0.5)
			if template.Parent and currentAmount == template.amount.Value then
				wait(0.5)
				template:Destroy()
			end
		end
	end)
end

local interactionPromptTextLabelTemplate = script:WaitForChild("interactionPromptTextLabel")

function module.createTextFragmentLabels(parent, textFragments)
	local textOffsetX 	= 0
	local textOffsetY 	= 0
	
	local originalTextSize
	
	local container 	= Instance.new("Frame")
	local textYSize 	= 0
	
	local originalTextFragmentSize
	
	local lines = 1
	
	for i, textFragmentData in ipairs(textFragments) do
		
		local textColor = textFragmentData.textColor3 or Color3.fromRGB(15,15,15)
		local font = textFragmentData.font or Enum.Font.SourceSans
--		local autoLocalize = (textFragmentData.autoLocalize == nil and true) or textFragmentData.autoLocalize
		local autoLocalize = false
		-- automatically pull from localization module
		if textFragmentData.autoLocalize == nil or textFragmentData.autoLocalize then
			textFragmentData.text = localization.translate(textFragmentData.text, parent) 
		end
		local textTransparency = textFragmentData.textTransparency or 0
		
		local textSize = textFragmentData.textSize or 18
		
		local textFragmentSize = textService:GetTextSize(textFragmentData.text, textSize, font, Vector2.new())
		-- standardize Y size so you can have big-text effects without offsetting the text /ber
		local standardTextYSize 
		if originalTextFragmentSize then
			textFragmentSize = Vector2.new(textFragmentSize.X, originalTextFragmentSize.Y)
		else
			originalTextFragmentSize = textFragmentSize
		end
		standardTextYSize = textSize
		-- multi-line support
		if textOffsetX + textFragmentSize.X + 3 > parent.AbsoluteSize.X then
			-- split the fragment's text into smaller pieces by word
			local fragmentFragments = {}
			for word in string.gmatch(textFragmentData.text, "%S+") do
				table.insert(fragmentFragments, word)
			end
			
			
			
			local currentFragmentQueue = {}
			local currentFragmentQueueXSize = 0
			for i, word in pairs(fragmentFragments) do
				local wordSize = textService:GetTextSize(word, textSize, font, Vector2.new())
				
				if textOffsetX + currentFragmentQueueXSize + wordSize.X + 3 > parent.AbsoluteSize.X then
					-- exceeded line!
					-- dump the queue into a text label, then push this word into next queue
					lines = lines + 1
					if #currentFragmentQueue > 0 then
						local putTogetherFragment = ""
						for ii, wordFragment in pairs(currentFragmentQueue) do
							putTogetherFragment = putTogetherFragment .. wordFragment
							
							if ii ~= #currentFragmentQueue then
								putTogetherFragment = putTogetherFragment .. " "
							end
						end
						
						local textFragmentTextLabel = interactionPromptTextLabelTemplate:Clone()

						
						
						textFragmentTextLabel.AutoLocalize	= autoLocalize
						textFragmentTextLabel.TextSize		= textSize
						textFragmentTextLabel.TextColor3 	= textColor
						textFragmentTextLabel.Position 		= UDim2.new(0, textOffsetX, 0, textOffsetY)
						textFragmentTextLabel.Size 			= UDim2.new(0, currentFragmentQueueXSize, 0, standardTextYSize )
						textFragmentTextLabel.Text 			= putTogetherFragment
						textFragmentTextLabel.Font			= font
						textFragmentTextLabel.Parent 		= container
						textFragmentTextLabel.TextTransparency = textTransparency
						
					end
					
					textOffsetY 				= textOffsetY + standardTextYSize 
					textOffsetX 				= 0
					currentFragmentQueue 		= {}
					currentFragmentQueueXSize 	= wordSize.X
					
					table.insert(currentFragmentQueue, word)
				else
					currentFragmentQueueXSize = currentFragmentQueueXSize + wordSize.X + 3
					
					table.insert(currentFragmentQueue, word)
				end
			end
				
			if #currentFragmentQueue > 0 then
				local putTogetherFragment = ""
				for ii, wordFragment in pairs(currentFragmentQueue) do
					putTogetherFragment = putTogetherFragment .. wordFragment
					
					if ii ~= #currentFragmentQueue then
						putTogetherFragment = putTogetherFragment .. " "
					end
				end
				
				local textFragmentTextLabel 		= interactionPromptTextLabelTemplate:Clone()
				textFragmentTextLabel.TextSize		= textSize
				textFragmentTextLabel.TextColor3 	= textColor
				textFragmentTextLabel.Position 		= UDim2.new(0, textOffsetX, 0, textOffsetY)

				textFragmentTextLabel.Size 			= UDim2.new(0, currentFragmentQueueXSize, 0, standardTextYSize)
				textFragmentTextLabel.Text 			= putTogetherFragment
				textFragmentTextLabel.Font			= font
				textFragmentTextLabel.Parent 		= container
				textFragmentTextLabel.TextTransparency = textTransparency
				
				textOffsetX = textOffsetX + currentFragmentQueueXSize + 3
				
				
			end
			if textYSize <= 0 then
				textYSize = standardTextYSize 
			end
						
		else
			
			if textYSize <= 0 then
				textYSize = standardTextYSize 
			end			
			
			local textFragmentTextLabel 		= interactionPromptTextLabelTemplate:Clone()
			textFragmentTextLabel.TextSize		= textSize
			textFragmentTextLabel.TextColor3 	= textColor
			-- ugly hack for item tooltip stats im sorry
			textFragmentTextLabel.Position 		= UDim2.new(0, textOffsetX, textYSize ~= standardTextYSize and 0.5 or 0, textOffsetY)
			textFragmentTextLabel.AnchorPoint	= Vector2.new(0,textYSize ~= standardTextYSize and 0.5 or 0)
			textFragmentTextLabel.Size 			= UDim2.new(0, textFragmentSize.X, 0, standardTextYSize )
			textFragmentTextLabel.Text 			= textFragmentData.text
			textFragmentTextLabel.Font			= font
			textFragmentTextLabel.Parent 		= container
			textFragmentTextLabel.TextTransparency = textTransparency

						

			if #textFragments > 1 then
				textOffsetX = textOffsetX + textFragmentSize.X + 3
			else
				textOffsetX = textOffsetX + textFragmentSize.X
			end
		end
	end


	
	container.Size 						= UDim2.new(1, 0, 0, textYSize * lines)
	container.BackgroundTransparency 	= 1
	container.Parent 					= parent
	
	return container, textOffsetY, textOffsetX
end
	
network:create("createTextFragmentLabels", "BindableFunction", "OnInvoke", module.createTextFragmentLabels)

local function buildInteractionPromptText(promptInteractionInterface, textFragments, eventsData, eventSignal, noAnimation)
	local textOffsetX = 0
	local textOffsetY = 0
	
	local interactionPromptCopy = promptInteractionInterface.manifest 
	
	-- clear previous ui in here
	for i, v in pairs(interactionPromptCopy.curve.contents:GetChildren()) do
		if not v:isA("UIPadding") then
			v:Destroy()
		end
	end
	
	if interactionPromptCopy["pick up"].Visible then
		textOffsetX = 10
		interactionPromptCopy.curve.Size = UDim2.new(1,-25,0,28)
		interactionPromptCopy.curve.Position = UDim2.new(0.5,25,0.5,0)
		interactionPromptCopy.LayoutOrder = 10
	else
		interactionPromptCopy.curve.Size = UDim2.new(1,0,0,28)
		interactionPromptCopy.curve.Position = UDim2.new(0.5,0,0.5,0)
	end
	
	for i, textFragmentData in pairs(textFragments) do
		local textFragmentSize = textService:GetTextSize(textFragmentData.text, interactionPromptTextLabelTemplate.TextSize, interactionPromptTextLabelTemplate.Font, Vector2.new())
		local textColor = textFragmentData.textColor3 or Color3.fromRGB(170, 170, 170)
		local text = textFragmentData.text or ""
		
		if not textFragmentData.eventType or (textFragmentData.eventType == "key" and textFragmentData.id) then
			local textFragmentTextLabel 		= interactionPromptTextLabelTemplate:Clone()
			textFragmentTextLabel.TextColor3 	= textColor
			textFragmentTextLabel.Position 		= UDim2.new(0, textOffsetX, 0, textOffsetY)
			textFragmentTextLabel.Size 			= UDim2.new(0, textFragmentSize.X, 0, textFragmentSize.Y)
			textFragmentTextLabel.Text 			= text
			textFragmentTextLabel.Parent 		= interactionPromptCopy.curve.contents
			
			if textFragmentData.eventType == "key" and textFragmentData.id and textFragmentData.keyCode and not eventsData[textFragmentData.id] then
				eventsData[textFragmentData.id] = userInputService.InputBegan:connect(function(inputObject)
					if inputObject.UserInputType == Enum.UserInputType.Keyboard and inputObject.KeyCode == textFragmentData.keyCode then
						if eventSignal then
							eventSignal:Fire(textFragmentData.id)
						end
					end
				end)
			end
			
			if #textFragments > 1 then
				textOffsetX = textOffsetX + textFragmentSize.X + 3
			else
				textOffsetX = textOffsetX + textFragmentSize.X
			end
		end
	end
	
	
	
	if not noAnimation or promptInteractionInterface.isHiding then
		promptInteractionInterface.isHiding = false

		local y = 18 + 10
		
		if interactionPromptCopy["pick up"].Visible then
			textOffsetX = textOffsetX + 40
			interactionPromptCopy.LayoutOrder = 10
			y = 40
		end
		
		if noAnimation then
			

			
			interactionPromptCopy.Size = UDim2.new(0, textOffsetX + 15, 0, y)
		else
			
			local y = 18 + 10
			
			if interactionPromptCopy["pick up"].Visible then
				interactionPromptCopy.Parent = interactionPromptsFrame
				interactionPromptCopy.LayoutOrder = 10
				y = 40
			else
				interactionPromptCopy.Parent = interactionPromptsFrame
			end			
			
			local openAnimation = tweenService:Create(interactionPromptCopy, BASE_TWEEN_INFO, {Size = UDim2.new(0, textOffsetX + 15, 0, y)})
			openAnimation:Play()
		end
	end
end

local interactionPromptTemplate = script:WaitForChild("interactionPrompt")
function module.createInteractionPrompt(properties, ...)
	properties = properties or {}
	local promptId = properties.itemName or properties.promptId
	local value = properties.value 
	
	--" x"..tostring(value) or ""
	
	local textFragments = {...}
	
	local textDisplayedTime = tick()
	
	
	local interactionPromptCopy, eventsData, eventSignal, doShowNoAnimation
	if promptId and interactionPromptCache[promptId] then
		interactionPromptCopy 	= interactionPromptCache[promptId].interactionPromptCopy
		eventsData 				= interactionPromptCache[promptId].eventsData
		eventSignal 			= interactionPromptCache[promptId].eventSignal
		interactionPromptCache[promptId].textDisplayedTime	= textDisplayedTime
		
		if properties.itemName and value then
			local existingValue = interactionPromptCache[promptId].value or 0
			value = value + existingValue
			interactionPromptCache[promptId].value = value
			interactionPromptCopy.curve.UIScale.Scale = 1.15 + math.clamp(value/150,0,0.75)
			tween(interactionPromptCopy.curve.UIScale, {"Scale"}, 1, 0.5)						
		end
	else
		interactionPromptCopy 	= interactionPromptTemplate:Clone()
		eventsData 				= {}
		eventSignal 			= Instance.new("BindableEvent")
		doShowNoAnimation 		= false
		
		if promptId and not interactionPromptCache[promptId] then
			interactionPromptCache[promptId] = {}
				interactionPromptCache[promptId].interactionPromptCopy 	= interactionPromptCopy
				interactionPromptCache[promptId].eventsData 			= eventsData
				interactionPromptCache[promptId].eventSignal 			= eventSignal
				interactionPromptCache[promptId].value					= value
				interactionPromptCache[promptId].textDisplayedTime		= textDisplayedTime
		end
	end
	
	if value and value ~= 1 then
		table.insert(textFragments,{text = "x"..tostring(value); textColor3 = Color3.fromRGB(120,120,120)})
	end
	
	
	local promptInteractionInterface = {} do
		promptInteractionInterface.manifest 	= interactionPromptCopy
		promptInteractionInterface.eventSignal 	= eventSignal
		promptInteractionInterface.isHiding 	= false
		
		local function __intCleanup()
			if promptId == nil or interactionPromptCache[promptId].textDisplayedTime == textDisplayedTime then
				-- wipe connections
				if eventsData then
					for i, v in pairs(eventsData) do
						v:disconnect()
					end
					
					eventsData = nil
				end
				
				if eventSignal then
					eventSignal:Destroy()
					eventSignal = nil
				end
				
				-- delete the actual ui
				if interactionPromptCopy then
					interactionPromptCopy:Destroy()
					interactionPromptCopy = nil
				end
				
				if promptId then
					interactionPromptCache[promptId] = nil
				end
			end
		end
		
		local y = 18 + 10
		interactionPromptCopy["pick up"].Visible = false
		interactionPromptCopy.mobilePrompt.Visible = false
		if properties.promptId then
			y = 40
			interactionPromptCopy.LayoutOrder = 10
			interactionPromptCopy["pick up"].Visible = true
			interactionPromptCopy.mobilePrompt.Visible = true
		end
			
		function promptInteractionInterface:close(noAnimation)
			if promptId == nil or interactionPromptCache[promptId].textDisplayedTime == textDisplayedTime then
				if not noAnimation and interactionPromptCopy then
					local closeAnimation = tweenService:Create(interactionPromptCopy, BASE_TWEEN_INFO, {Size = UDim2.new(0, 0, 0, y)})
					
					closeAnimation.Completed:connect(function()
						
						__intCleanup()
					
					end)
					
					closeAnimation:Play()
				elseif noAnimation then
					__intCleanup()
				end
			end
		end
		
		function promptInteractionInterface:hide(noAnimation)
			promptInteractionInterface.isHiding = true
			
			local closeAnimation = tweenService:Create(interactionPromptCopy, BASE_TWEEN_INFO, {Size = UDim2.new(0, 0, 0, y)})
			closeAnimation:Play()
		end
		
		function promptInteractionInterface:setExpireTime(timeToExpire, hideInstead, noAnimation)
			delay(timeToExpire, function()
				if promptId == nil or interactionPromptCache[promptId].textDisplayedTime == textDisplayedTime then
					if not hideInstead then
						promptInteractionInterface:close(noAnimation)
					else
						promptInteractionInterface:hide(noAnimation)
					end
				end
			end)
		end
		
		function promptInteractionInterface:setBackgroundColor3(backgroundColor3)
			if interactionPromptCopy then
				interactionPromptCopy.curve.ImageColor3 = backgroundColor3
			end
		end
		
		function promptInteractionInterface:updateTextFragments(doShowNoAnimation, ...)
			if interactionPromptCopy then
				buildInteractionPromptText(promptInteractionInterface, {...}, eventsData, eventSignal, doShowNoAnimation)
			end
		end
	end
	
	-- eventTypes -- 'key', 'click'
	-- todo: implement multiple lines
	buildInteractionPromptText(promptInteractionInterface, textFragments, eventsData, eventSignal, doShowNoAnimation)	
	
	return promptInteractionInterface
end

function module.showEtcItemPickup(realItem, value, metadata)
	local prompt = module.createInteractionPrompt({itemName = realItem.name; value = metadata.stacks or 1;},
		{text = "Obtained"; textColor3 = Color3.fromRGB(120,120,120)},
		{text = realItem.name; textColor3 = Color3.fromRGB(143, 120, 255)}
	)
	
	prompt:setBackgroundColor3(Color3.fromRGB(190, 190, 190))
	prompt:setExpireTime(4)	
end

local function isPositionInsideFrame(absPosition, frame)
	local relative = (frame.AbsolutePosition - absPosition) / frame.AbsoluteSize
		
	return
		relative.X >= -0.55 and relative.X <= 0.55
		and relative.Y >= -0.55 and relative.Y <= 0.55
end

local function processSwap(buttonFrom, buttonTo, isRightClickTrigger, extraData)
	if IS_PROCESSING_INVENTORY_SLOT_SWITCH then return false end
	if not buttonFrom then return false end
	if (buttonTo == buttonFrom and not (extraData and extraData.originSlotData)) then return false end
--	if buttonFrom.Image == "" then return false end
	
	IS_PROCESSING_INVENTORY_SLOT_SWITCH = true
	if buttonFrom:IsDescendantOf(menu_trade.yourTrade) then
		if buttonTo:IsDescendantOf(menu_trade.yourTrade) then
			Modules.trading.swap(buttonFrom, buttonTo)
		else
			Modules.trading.clearLocalTradeSlot(buttonFrom)
		end
	elseif buttonFrom:IsDescendantOf(menu_storage) then
		if buttonTo and buttonTo:IsDescendantOf(menu_inventory) then
			local buttonFromStorageSlotData = network:invoke("getStorageSlotDataFromStorageItem", buttonFrom)
			
			if buttonFromStorageSlotData then
				local success, reason = network:invokeServer("playerRequest_transferStorageToInventory", buttonFromStorageSlotData)
			end
		end
	elseif buttonFrom:IsDescendantOf(menu_inventory) then
		if buttonTo then
			if buttonTo:IsDescendantOf(menu_enchant) then
				local buttonFromInventorySlot, buttonFromType = network:invoke("getInventorySlotDataByInventorySlotUI", buttonFrom)
				if buttonFromInventorySlot and buttonFromType == "ability" then
					Modules.enchant.dragItem(buttonFromInventorySlot)
				end
			elseif buttonTo:IsDescendantOf(menu_storage) then
				local buttonFromInventorySlot, buttonFromType = network:invoke("getInventorySlotDataByInventorySlotUI", buttonFrom)
				if buttonFromInventorySlot and buttonFromType == "item" then
					local success, reason = network:invokeServer("playerRequest_transferInventoryToStorage", buttonFromInventorySlot)
				end
			elseif buttonTo:IsDescendantOf(menu_inventory) then
				local buttonFromInventorySlot, buttonFromType = network:invoke("getInventorySlotDataByInventorySlotUI", buttonFrom)
				local buttonToInventorySlot, buttonToType = network:invoke("getInventorySlotDataByInventorySlotUI", buttonTo)
				
				if buttonFromInventorySlot and buttonFromType == "item" then
					local fromBaseItemData 	= itemData[buttonFromInventorySlot.id]
					local toBaseItemData 	= buttonToInventorySlot and itemData[buttonToInventorySlot.id] or nil
					
					if fromBaseItemData then
						if toBaseItemData then
							if fromBaseItemData.category ~= "equipment" and toBaseItemData.category ~= "equipment" and fromBaseItemData.id == toBaseItemData.id then
								-- from and to are same item, merge stacks
								local currentCategory 	= network:invoke("getCurrentInventoryCategory")
								local success 			= network:invokeServer("requestSplitInventorySlotDataStack", currentCategory, buttonFromInventorySlot.position, buttonToInventorySlot.position, buttonFromInventorySlot.stacks)
							else
								-- from and to are different items, swap them
								local buttonFrom_image 	= buttonFrom.Image
								local buttonFrom_stacks = buttonFrom.duplicateCount.Text
								
								buttonFrom.Image 				= buttonTo.Image
								buttonFrom.duplicateCount.Text 	= buttonTo.duplicateCount.Text
								
								buttonTo.Image 					= buttonFrom_image
								buttonTo.duplicateCount.Text 	= buttonFrom_stacks
								local currentCategory 	= network:invoke("getCurrentInventoryCategory")
								local success 			= network:invokeServer("switchInventorySlotData", currentCategory, buttonFromInventorySlot.position, buttonToInventorySlot.position)
							end
						else
							if isRightClickTrigger and fromBaseItemData.canStack then
								local currentCategory 	= network:invoke("getCurrentInventoryCategory")
								local success 			= network:invokeServer("requestSplitInventorySlotDataStack", currentCategory, buttonFromInventorySlot.position, tonumber(buttonTo.Parent.Name), 1)
							else
								-- to is empty
								local buttonFrom_image 	= buttonFrom.Image
								local buttonFrom_stacks = buttonFrom.duplicateCount.Text
								
								buttonFrom.Image 				= ""
								buttonFrom.duplicateCount.Text 	= ""
								
								buttonTo.Image 					= buttonFrom_image
								buttonTo.duplicateCount.Text 	= buttonFrom_stacks
								
								-- switching item with blank
								local currentCategory 	= network:invoke("getCurrentInventoryCategory")
								local success 			= network:invokeServer("switchInventorySlotData", currentCategory, buttonFromInventorySlot.position, tonumber(buttonTo.Parent.Name))
							end
						end
					else
						-- from is empty, no thanks.
					end
				end
			elseif buttonTo:IsDescendantOf(ui.bottomRight.hotbarFrame) then
				-- inventory to hotbarFrame
				
				local inventorySlotData, buttonFromType = network:invoke("getInventorySlotDataByInventorySlotUI", buttonFrom)
				if inventorySlotData then
					if buttonFromType == "item" then
						local inventoryItemBaseData = itemData[inventorySlotData.id]
						if inventoryItemBaseData and inventoryItemBaseData.category == "consumable" and inventoryItemBaseData.canBeBound then
							local num = string.gsub(buttonTo.Name,"[^.0-9]+","")
							if tonumber(num) == 10 then num = 0 end
							network:invokeServer("registerHotbarSlotData", mapping.dataType.item, inventorySlotData.id, tonumber(num))
						end
					elseif buttonFromType == "ability" and not inventorySlotData.passive then
						if inventorySlotData.id then
							local num = string.gsub(buttonTo.Name,"[^.0-9]+","")
							if tonumber(num) == 10 then num = 0 end					
							network:invokeServer("registerHotbarSlotData", mapping.dataType.ability, inventorySlotData.id, tonumber(num))
						end						
					end
				end
			elseif buttonTo:IsDescendantOf(menu_equipment) then
				-- inventory to equip
				local inventorySlotData, buttonFromType = network:invoke("getInventorySlotDataByInventorySlotUI", buttonFrom)
				local equipmentSlotData = network:invoke("getEquipmentSlotDataByEquipmentSlotUI", buttonTo)
				
				if inventorySlotData and buttonFromType == "item" then
					if equipmentSlotData then
						-- check if item is valid
						local itemFromBaseData = itemData[inventorySlotData.id]
						
						-- part of the following check is commented out by Davdiii
						-- i think we can trust the server to do this validation, can't we?
						-- i'm not altogether too concerned about the moment it'll take for
						-- the server to tell us off if we're wrong, besides we wait anyway
						if itemFromBaseData and itemFromBaseData.isEquippable --[[and buttonTo.Parent.Name == mapping.getMappingByValue("equipmentPosition", itemFromBaseData.equipmentSlot)]] then
							-- instantly update client frame, server will force refresh if it was wrong.
							-- this rewards good behaviour, and punishes bad behaviour with delays
							local buttonFrom_image 	= buttonFrom.Image
										

							
												
							local currentCategory = network:invoke("getCurrentInventoryCategory")
							local success = network:invokeServer("transferInventoryToEquipment", currentCategory, inventorySlotData.position, mapping.equipmentPosition[buttonTo.Parent.Name])
							
							if success then
								buttonFrom.Image 	= buttonTo.Image
								buttonTo.Image 		= buttonFrom_image									
							end
							
						elseif itemFromBaseData.applyScroll then
							
							local itemBaseData_enchantment 	= itemData[inventorySlotData.id]
						
							local continue = true
						
							if itemBaseData_enchantment.dye then
								
								local equipmentBaseData = itemData[equipmentSlotData.id]
								
								if not Modules.dyePreview.prompt(itemBaseData_enchantment, equipmentBaseData) then
									continue = false
								end
							end
							
							if continue then
								local pos = buttonTo.AbsolutePosition + buttonTo.AbsoluteSize/2
								
								local playerInput = {}
								
								if itemBaseData_enchantment and itemBaseData_enchantment.playerInputFunction then
									playerInput = itemBaseData_enchantment.playerInputFunction()
								end							
								
								local success, scrollApplied, newInventorySlotData, status = network:invokeServer("playerRequest_enchantEquipment", inventorySlotData, equipmentSlotData, "equipment", playerInput)
								
								
								if status then
									spawn(function()
										wait(0.5)
--										game.StarterGui:SetCore("ChatMakeSystemMessage", status)
										network:fire("alert", status)
									end)
								end
								
								if success and scrollApplied and newInventorySlotData then
									spawn(function()
										wait(0.5)
										
	
										
										local ringInfo = {
											color = Modules.itemAcquistion.getTitleColorForInventorySlotData(newInventorySlotData) or Color3.new(1,1,1);
										}
										Modules.fx.ring(ringInfo, pos)
									end)
								end	
							end	
				
						end
					else
						local inventoryItemBaseData = itemData[inventorySlotData.id]
						
						-- as expressed above, Davidii commented out part of this check
						-- let the server do this validation! what's the big deal?
						if inventoryItemBaseData.isEquippable --[[and buttonTo.Parent.Name == mapping.getMappingByValue("equipmentPosition", inventoryItemBaseData.equipmentSlot)]] then
							-- inventory slot is empty
							local currentCategory = network:invoke("getCurrentInventoryCategory")
							
							local success = network:invokeServer("transferInventoryToEquipment", currentCategory, tonumber(buttonFrom.Parent.Name), mapping.equipmentPosition[buttonTo.Parent.Name])		
						end
					end
				end
			elseif buttonTo:IsDescendantOf(menu_shop) then
				local inventorySlotData, buttonFromType = network:invoke("getInventorySlotDataByInventorySlotUI", buttonFrom)
				if inventorySlotData and buttonFromType == "item" then
					local inventoryItemBaseData = itemData[inventorySlotData.id]
					if inventoryItemBaseData then
						network:invoke("shop_setCurrentItem", inventorySlotData, true)
					end
				end
			elseif buttonTo:IsDescendantOf(menu_trade.yourTrade) then
					
						
				local inventorySlotData, buttonFromType = network:invoke("getInventorySlotDataByInventorySlotUI", buttonFrom)
				if inventorySlotData and buttonFromType == "item" then
					
					Modules.trading.setLocalTradeSlot(buttonTo.Name, inventorySlotData)
				end
			end
		else
			-- buttonTo is nil, dragged onto overworld
			local inventorySlotData, buttonFromType = network:invoke("getInventorySlotDataByInventorySlotUI", buttonFrom)
			if inventorySlotData and buttonFromType == "item" then
				local inventoryReal = itemData[inventorySlotData.id] or {name = "...wait what????????"}
				local message = "Are you sure you want to drop your "..inventoryReal.name.."?"
				
				
				if inventoryReal.soulbound then
					message = "DESTROY your "..inventoryReal.name.."?"
				end
				
				
				
				local accepted = Modules.prompting_Fullscreen.prompt(message)
				if accepted then
					
					if inventoryReal.soulbound and not Modules.prompting_Fullscreen.prompt("⚠ ARE YOU SURE you want to DESTROY your " ..inventoryReal.name.."? This action cannot be undone! ⚠") then
						return false
					end
					
					
					local success, errorMessage = network:invokeServer("playerRequest_dropItem", inventorySlotData)
					
				end
			end
		end
	elseif buttonFrom:IsDescendantOf(ui.bottomRight.hotbarFrame) then
		if buttonTo then
			if buttonTo:IsDescendantOf(ui.bottomRight.hotbarFrame) then
				
				local fromData = (extraData and extraData.originSlotData) or network:invoke("getHotbarSlotDataByHotbarSlotUI", buttonFrom)
				local toData = network:invoke("getHotbarSlotDataByHotbarSlotUI", buttonTo)
					
				local toNum = string.gsub(buttonTo.Name,"[^.0-9]+","")	
				if tonumber(toNum) == 10 then toNum = 0 end
					
				network:invokeServer("registerHotbarSlotData", fromData.dataType, fromData.id, tonumber(toNum))
				
				local fromNum = string.gsub(buttonFrom.Name,"[^.0-9]+","")	
				if tonumber(fromNum) == 10 then fromNum = 0 end
				
				if buttonTo ~= buttonFrom then
					if toData then		
						network:invokeServer("registerHotbarSlotData", toData.dataType, toData.id, tonumber(fromNum))
					else
						network:invokeServer("registerHotbarSlotData", nil, nil, tonumber(fromNum))
					end
				end
				
			end
		else
			local hotbarSlotData = network:invoke("getHotbarSlotDataByHotbarSlotUI", buttonFrom)
			if hotbarSlotData then
				-- dragged into overworld
				network:invokeServer("registerHotbarSlotData", nil, nil, hotbarSlotData.position)
			end
		end
	elseif buttonFrom:IsDescendantOf(menu_equipment) then
		if buttonTo then
			
			if buttonTo:IsDescendantOf(menu_enchant) then
				local equipmentSlotData = network:invoke("getEquipmentSlotDataByEquipmentSlotUI", buttonFrom)
				if equipmentSlotData then
					Modules.enchant.dragItem(equipmentSlotData, "equipment")
				end
	
			elseif buttonTo:IsDescendantOf(menu_inventory) then
				-- equip to inventory
				local inventorySlotData, buttonToType = network:invoke("getInventorySlotDataByInventorySlotUI", buttonTo)
				local equipmentSlotData = network:invoke("getEquipmentSlotDataByEquipmentSlotUI", buttonFrom)
				
				if inventorySlotData and buttonToType == "item" then
					if equipmentSlotData then
						-- check if item is valid
						local itemFromBaseData = itemData[inventorySlotData.id]
						if itemFromBaseData and itemFromBaseData.isEquippable and buttonFrom.Parent.Name == mapping.getMappingByValue("equipmentPosition", itemFromBaseData.equipmentSlot) then
							-- instantly update client frame, server will force refresh if it was wrong.
							-- this rewards good behaviour, and punishes bad behaviour with delays
							local buttonTo_image = buttonTo.Image
							
							buttonTo.Image 		= buttonFrom.Image
							buttonFrom.Image 	= buttonTo_image	
												
							local currentCategory = network:invoke("getCurrentInventoryCategory")
							local success = network:invokeServer("transferInventoryToEquipment", currentCategory, inventorySlotData.position, mapping.equipmentPosition[buttonFrom.Parent.Name])
						end
					end
				else
					local equipmentItemBaseData = itemData[equipmentSlotData.id]
					local currentCategory = network:invoke("getCurrentInventoryCategory")
					
					local success = network:invokeServer("transferInventoryToEquipment", currentCategory, tonumber(buttonTo.Parent.Name), mapping.equipmentPosition[buttonFrom.Parent.Name])		
				end
			end
		else
			-- dragged into overworld
		end
	elseif buttonFrom:IsDescendantOf(menu_enchant) then
		if buttonTo == nil or not buttonFrom:IsDescendantOf(menu_enchant) then
			Modules.enchant.reset()
		end
	end
	
	IS_PROCESSING_INVENTORY_SLOT_SWITCH = false
end

module.processSwap = processSwap

local function getDropTarget(exclusion)
	local targetDrop
	
	local function recur(guiObject)
		if guiObject:IsA("GuiObject") and guiObject.Visible then
			
			if guiObject:FindFirstChild("draggableFrame") and guiObject ~= exclusion and isPositionInsideFrame(dragDropMask.AbsolutePosition, guiObject) then
				targetDrop = guiObject
			end
			for i, gui in pairs(guiObject:GetChildren()) do
				recur(gui)
			end			
		end
	end
	
	for i, gui in pairs(script.Parent:GetChildren()) do
		recur(gui)
	end	
	
	return targetDrop
end

local function isDragDropFrame(frame)
	for i, _frame in pairs(dragDropFrameCollection) do
		if _frame == frame then
			return true
		end
	end
	
	return false
end

local runService = game:GetService("RunService")


local function update(input)
	if currentDragFrameOriginator then
		if dragDropMask.ImageTransparency ~= 0 then
			currentDragFrameOriginator.ImageTransparency = 0.6
			if currentDragFrameOriginator:IsDescendantOf(menu_inventory) then
				currentDragFrameOriginator.duplicateCount.Visible = false
			end
			
			dragDropMask.Image 				= currentDragFrameOriginator.Image
			dragDropMask.ImageTransparency 	= 0
		end

		dragDropMask.Position = UDim2.new(0, input.Position.X - 25, 0, input.Position.Y - 25)
	end
end


function module.drag.setIsDragDropFrame(frame)
	if not frame:IsA("ImageLabel") and not frame:IsA("ImageButton") then error("Only ImageButtons and ImageLabels can be DragDropFrames") return end
	if isDragDropFrame(frame) then return end
	
	
	local function onInputBegan_UI(inputObject)
		
		if not frame.Active then
			return false
		end		
		
		if (inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch) and inputObject.UserInputState == Enum.UserInputState.Begin then
										
			
			if frame.ImageTransparency < 1 then
				
				
				local extraData = {}
				currentDragFrameOriginator = frame

				
				local startTime = tick()
				local startPosition = inputObject.Position
				
				repeat runService.RenderStepped:wait() 	
					
					if inputObject.UserInputType == Enum.UserInputType.Touch then
						update(inputObject)
					end
					
					
					
					-- input ended naturally
					if inputObject.UserInputState == Enum.UserInputState.End then
						if currentDragFrameOriginator == frame then
			
							local finalPosition = inputObject.Position
							if tick() - startTime > 0.1 and utilities.magnitude(startPosition - finalPosition) > 26 then
--								local dropTarget = getDropTarget(frame)
								local dropTarget = getDropTarget()
											
								spawn(function()			
									if processSwap(frame, dropTarget, nil, extraData) then
										-- was accepted by client ???
									else
										-- was denied by client ???
									end
								end)
							end

						end
					end		
			
				until inputObject.UserInputState == Enum.UserInputState.End or inputObject.UserInputState == Enum.UserInputState.Cancel
				
				if currentDragFrameOriginator == frame then
					currentDragFrameOriginator = nil

					if frame:IsDescendantOf(menu_inventory) then
						frame.duplicateCount.Visible = true
					end							
					
					-- reset stuff!
					dragDropMask.ImageTransparency 	= 1
					dragDropMask.Position 			= UDim2.new(-1, -100, -1, -100)
					frame.ImageTransparency 		= 0					
				end
			end
		end
	end
	
	frame.InputBegan:connect(onInputBegan_UI)
	
	table.insert(dragDropFrameCollection, frame)
end

function module.setIsDoubleClickFrame(imageButton, timePeriod, callback)
	local timeOfLastClick
	imageButton.MouseButton1Click:connect(function() network:invoke("populateItemHoverFrame") callback(imageButton) end)
	
	if imageButton and imageButton.Parent then
	
		local mouseEnterScale = Instance.new("UIScale")
		mouseEnterScale.Parent = imageButton
		
		local z = imageButton.Parent.ZIndex
		
		local bc
		
		if imageButton.Parent:IsA("ImageLabel") or imageButton.Parent:IsA("ImageButton") then
			bc = imageButton.Parent.ImageColor3
		end
		
		local shine
		
		if imageButton.Parent:FindFirstChild("shine") then
			shine = imageButton.Parent.shine.ImageTransparency
		end
		
		imageButton.MouseEnter:connect(function() 
			imageButton.Parent.ZIndex = z + 1 
			tween(mouseEnterScale, {"Scale"}, {1.1}, 0.4) 
			if bc then
				tween(imageButton.Parent, {"ImageColor3"}, {Color3.new(bc.r * 0.65, bc.g * 0.65, bc.b * 0.65)}, 0.6) 
			end
			if shine then
				tween(imageButton.Parent.shine, {"ImageTransparency"}, {shine/1.5}, 0.6)
			end
		end)
		
		imageButton.MouseLeave:connect(function() 
			imageButton.Parent.ZIndex = z 
			tween(mouseEnterScale, {"Scale"}, {1.0}, 0.4) 
			if bc then
				tween(imageButton.Parent, {"ImageColor3"}, {bc}, 0.6)
			end 		
			if shine then
				tween(imageButton.Parent.shine, {"ImageTransparency"}, {shine}, 0.6)
			end				
		end)
	
	end
end

local isEnchanting = false
function module.setIsEnchantingFrame(imageButton, callback)
	local timeOfLastClick
	local isEnchanting = false
	
	local function onInputBegan_ButtonClicked()
		-- register first click!
		if not timeOfLastClick then
			timeOfLastClick = tick()
			
			-- exit
			return
		end
		
		-- calculate time since last click
		local timeSinceLastClick = tick() - timeOfLastClick
		if timeSinceLastClick < 0.1 then
			-- double clicked
			isEnchanting = true
		end
		
		-- reset time since last click
		timeOfLastClick = nil
	end
	
	imageButton.MouseButton1Click:connect(onInputBegan_ButtonClicked)
end



local function onInputChanged(inputObject)
	if currentDragFrameOriginator and inputObject.UserInputType == Enum.UserInputType.MouseMovement then
		update(inputObject)
	end
end

local function onInputBegan(inputObject)
	if currentDragFrameOriginator and inputObject.UserInputType == Enum.UserInputType.MouseButton2 then
		local dropTarget = getDropTarget(currentDragFrameOriginator)
		if dropTarget then
			processSwap(currentDragFrameOriginator, dropTarget, true)
		end
	end
end
	

userInputService.InputChanged:connect(onInputChanged)
userInputService.InputBegan:connect(onInputBegan)

for i, obj in pairs(ui:GetDescendants()) do
	if obj.Name == "draggableFrame" then
		
		module.drag.setIsDragDropFrame(obj.Parent)
	end
end


return module