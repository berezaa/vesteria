local module = {}

local modules = require(game.ReplicatedStorage.modules)
local network = modules.load("network")

local placeSetup = modules.load("placeSetup")
local utilities = modules.load("utilities")
local ability_utilities = modules.load("ability_utilities")
local enchantment = modules.load("enchantment")

local userInputService 	= game:GetService("UserInputService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local textService = game:GetService("TextService")

local itemsDataFolder = replicatedStorage:WaitForChild("itemData")
local itemLookup = require(itemsDataFolder)
local perkLookup = require(replicatedStorage:WaitForChild("perkLookup"))
local itemAttributes = require(replicatedStorage:WaitForChild("itemAttributes"))

local player = game.Players.LocalPlayer
local playerGui = player.PlayerGui
local itemsFolder = placeSetup.awaitPlaceFolder("items")

local rootFrame = script.Parent.gameUI.itemHoverFrame
local itemHoverFrame = rootFrame.contents
local gameUI = rootFrame.Parent

rootFrame.Visible = false

local uiCreator = require(playerGui.uiCreator)
local currentItemHoverData = nil
--	currentItemHoverData.item 					= nil
--	currentItemHoverData.pickupSizeAnimation 	= nil
--	currentItemHoverData.regularSizeAnimation 	= nil
local ITEM_ACQUISITION_RANGE = 5

local pickupInteractionPromptTable = {
	prompt = uiCreator.createInteractionPrompt({promptId = "pickupInteractionPrompt"},
		{text = "Pick up"}
	);
	item = nil;
}

module.getTitleColorForInventorySlotData = function()

end

local titleTextSize = 20

module.tierColors = enchantment.tierColors

pickupInteractionPromptTable.prompt.manifest.LayoutOrder = 3
pickupInteractionPromptTable.prompt:hide(true)

function module.init(Modules)

	local Mouse = player:GetMouse()

	local function reposition()


		local screensize = workspace.CurrentCamera.ViewportSize

		local x, y

		if Modules.input.mode.Value == "pc" then
			x = Mouse.X + 15
			y = Mouse.Y - 5

			if x + rootFrame.AbsoluteSize.X > screensize.X then
				x = Mouse.X - 15 - rootFrame.AbsoluteSize.X
			end

			local yDisplacement = (y + rootFrame.AbsoluteSize.Y) - (screensize.Y - 36)

			if yDisplacement > -115 then
				y = y - yDisplacement - 115
			end

			local targetPosition = UDim2.new(0, x, 0, y)
			rootFrame.Position = targetPosition
		elseif Modules.input.mode.Value == "xbox" then
			local frame = game.GuiService.SelectedObject
			if frame then
				x = frame.AbsolutePosition.X + frame.AbsoluteSize.X + 15
				if x + rootFrame.AbsoluteSize.X > screensize.X then
					x = frame.AbsolutePosition.X - rootFrame.AbsoluteSize.X - 15
				end

				y = frame.AbsolutePosition.Y + frame.AbsoluteSize.Y/2  - rootFrame.AbsoluteSize.Y/2

				local yDisplacement = (y + rootFrame.AbsoluteSize.Y) - (screensize.Y - 36)

				if yDisplacement > -115 then
					y = y - yDisplacement - 115
				end

				local targetPosition = UDim2.new(0, x, 0, y)
				rootFrame.Position = targetPosition
			end
		end

	end


	game:GetService("RunService").Heartbeat:connect(reposition)

	local localization = Modules.localization

	local function raycastFromScreenPositionForItems(screenPositionX, screenPositionY)
		if player.Character and player.Character.PrimaryPart then
			local cameraRay = workspace.CurrentCamera:ScreenPointToRay(screenPositionX, screenPositionY)

			local ray = Ray.new(cameraRay.Origin, cameraRay.Direction.unit * 50)
			local hitPart, hitPosition = workspace:FindPartOnRayWithWhitelist(ray, {placeSetup.awaitPlaceFolder("items")})

			return hitPart, hitPosition, (hitPart and utilities.magnitude(hitPart.Position - player.Character.PrimaryPart.Position) or nil)
		end
	end

	module.source = "none"

	local function cleanup()
		for i,child in pairs(itemHoverFrame:GetChildren()) do
			if child.Name == "perk" then
				child:Destroy()
			end
		end
		itemHoverFrame.main.thumbnailBG.ImageColor3 = Color3.new(1,1,1)
		itemHoverFrame.soulbound.Visible = false
		itemHoverFrame.enchantments.Visible = false
		itemHoverFrame.notOwned.Visible = false
		rootFrame.UIScale.Scale = 1
	end

	local function getItemInfo(itemBaseData, inventorySlotData)
		local statBonuses = {}
		local totalStats = {}

		if itemBaseData.baseDamage then
			totalStats["baseDamage"] = (totalStats["baseDamage"] or 0) + itemBaseData.baseDamage
		end
		if itemBaseData.attackSpeed then
			totalStats["attackSpeed"] = (totalStats["attackSpeed"] or 0) + itemBaseData.attackSpeed
		end

		if itemBaseData.modifierData then
			for e,modifier in pairs(itemBaseData.modifierData) do
				for statName, statValue in pairs(modifier) do
					totalStats[statName] = (totalStats[statName] or 0) + statValue
				end
			end
		end

		-- cycle thru additional stats, increase totalDamage

		if inventorySlotData and inventorySlotData.modifierData then
			for i, modifierData in pairs(inventorySlotData.modifierData) do
				for statName,statValue in pairs(modifierData) do
					statBonuses[statName] = (statBonuses[statName] or 0) + statValue
					totalStats[statName] = (totalStats[statName] or 0) + statValue
				end
			end
		end

		-- attribute
		-- new: attributes treated as bonus stats

		if inventorySlotData and inventorySlotData.attribute then
			local attributeData = itemAttributes[inventorySlotData.attribute]
			if attributeData and attributeData.modifier then
				local attributeModifierData = attributeData.modifier(itemBaseData, inventorySlotData)
				if attributeModifierData then
					for statName, statValue in pairs(attributeModifierData) do
						statBonuses[statName] = (statBonuses[statName] or 0) + statValue
						totalStats[statName] = (totalStats[statName] or 0) + statValue
					end
				end
			end
		end

		-- cycle thru enchantments
		local statUpgrade = 0
		if inventorySlotData and inventorySlotData.enchantments then
			for i, enchantment in pairs(inventorySlotData.enchantments) do
				local enchantmentBaseData = itemLookup[enchantment.id]
				local enchantState = enchantmentBaseData.enchantments[enchantment.state]
				if enchantState then
					if enchantState.modifierData then
						for statName, statValue in pairs(enchantState.modifierData) do
							statBonuses[statName] = (statBonuses[statName] or 0) + statValue
							totalStats[statName] = (totalStats[statName] or 0) + statValue
						end
					end
					if enchantState.statUpgrade then
						statUpgrade = statUpgrade + enchantState.statUpgrade
					end
				end
			end
		end

		-- statUpgrade from items with variable enhancements (mainly hats!)
		if statUpgrade > 0 and itemBaseData.statUpgrade then
			for statName, baseValue in pairs(itemBaseData.statUpgrade) do
				if baseValue ~= 0 then
					local statValue = baseValue * statUpgrade
					statBonuses[statName] = (statBonuses[statName] or 0) + statValue
					totalStats[statName] = (totalStats[statName] or 0) + statValue
				end
			end
		end

		if itemBaseData.bonusStats then
			-- populate base stats
			for statName, statValue in pairs(itemBaseData.bonusStats) do
				if type(statValue) == "number" then
					totalStats[statName] = (totalStats[statName] or 0) + statValue
				end
			end
		end
		return totalStats, statBonuses
	end

	local function getTitleColorForInventorySlotData(inventorySlotData)
		local itemBaseData = itemLookup[inventorySlotData.id]
		local itemBaseTier = itemBaseData.tier
		local baseModifierData = itemBaseData.modifierData or {}

		local score = 0

		local totalStats, statBonuses = getItemInfo(itemBaseData, inventorySlotData)

		for stat, value in pairs(statBonuses) do
			local adjustedValue = (value < 0 and value * 0.5) or value
			if stat == "baseDamage" or stat == "defense" then
				score = score + adjustedValue
			elseif stat == "maxMana" or stat == "maxHealth" then
				score = score + adjustedValue * 0.05
			elseif stat == "str" or stat == "dex" or stat == "int" or stat == "vit" then
				score = score + adjustedValue * 0.7
			elseif stat == "stamina" then
				score = score + adjustedValue * 2
			elseif stat == "jump" or stat == "walkspeed" then
				score = score + adjustedValue
			elseif stat == "criticalStrikeChance" or stat == "blockChance" then
				score = score + adjustedValue * 50
			end
		end

		local baseMaxUpgrades = (itemBaseData.maxUpgrades or 0)
		local bench = baseMaxUpgrades / 7

		local enchantTier
		if baseMaxUpgrades > 0 and not itemBaseData.notUpgradable then
			if score >= 49*bench then
				enchantTier = 6
			elseif score >= 32*bench then
				enchantTier = 5
			elseif score >= 21*bench then
				enchantTier = 4
			elseif score >= 10*bench then
				enchantTier = 3
			elseif score < 0 then
				enchantTier = -1
			elseif inventorySlotData and inventorySlotData.upgrades and inventorySlotData.upgrades > 0 then
				if inventorySlotData.successfulUpgrades and inventorySlotData.successfulUpgrades > 0 then
					enchantTier = 2
				else
					enchantTier = -1
				end
			end
		end


		local trueTier = itemBaseTier
		if enchantTier then
			if itemBaseTier == nil or enchantTier > itemBaseTier then
				trueTier = enchantTier
			end
		end

		local titleColor = trueTier and module.tierColors[trueTier]

		return titleColor, trueTier
	end

	module.getTitleColorForInventorySlotData = getTitleColorForInventorySlotData

	-- used before reverting to 7 upgrade system
	local function getTitleColorForInventorySlotData_defunct(inventorySlotData)

		local itemBaseData = itemLookup[inventorySlotData.id]
		local itemBaseTier = itemBaseData.tier or 1

		local maxUpgrades = inventorySlotData.maxUpgrades or itemBaseData.maxUpgrades

		local averageEnchantmentTier = 0

		local enchantmentCount = inventorySlotData and inventorySlotData.upgrades or 0
		-- we want to include failed upgrades which are not included in slotData.enchantments
		local enchantments = inventorySlotData.enchantments or {}
		if enchantmentCount > 0 then
			local enchantmentTierTotal = 0
			for i, enchantmentData in pairs(enchantments) do
				local enchantmentBaseData = itemLookup[enchantmentData.id].enchantments[enchantmentData.state]
				local enchantmentTier = enchantmentBaseData.tier
				if enchantmentTier then
					enchantmentTierTotal = enchantmentTierTotal + enchantmentTier
				end
			end
			averageEnchantmentTier = 1 + 0.01 + enchantmentTierTotal / maxUpgrades
		end

		local tier = ((averageEnchantmentTier > itemBaseTier or averageEnchantmentTier == -1) and math.floor(averageEnchantmentTier)) or itemBaseTier

		-- any upgrade will turn an item blue
		if averageEnchantmentTier > 1 and tier < 2 then
			tier = 2
		end

		if tier ~= 1 then
			local titleColor = module.tierColors[tier]
			return titleColor
		end
	end

	local lastTextData


	local function populateItemHoverFrameWithTextData(textData)

		-- dont let text override important stuff
		if itemHoverFrame.Parent.Visible and itemHoverFrame.Visible and itemHoverFrame.main.Visible and itemHoverFrame.main.thumbnail.Visible then
			return false
		end

		itemHoverFrame.header.itemName.Position = UDim2.new(0, 0,0, 3)
		itemHoverFrame.header.itemName.cuteDecor.Visible = false

		if textData == nil or textData.text == nil then
			if textData.source == nil or textData.source == lastTextData.source then
				rootFrame.Visible = false
				rootFrame.contents.Visible = false
			end
			return false
		end

		rootFrame.Size = UDim2.new(0, 320 + 4, 0, 100)

		rootFrame.contents.Visible = false

		lastTextData = textData


		Modules.input.setCurrentFocusFrame(rootFrame)

--		rootFrame.itemType.Visible = false
		cleanup()

		module.source = "text"

		itemHoverFrame.main.Visible = false
		itemHoverFrame.stats.Visible = false

		local txtsrc = textData.text and localization.translate(textData.text, itemHoverFrame.header.itemName)
		itemHoverFrame.header.itemName.Text = txtsrc or "???"



		itemHoverFrame.header.itemName.TextColor3 = textData.textColor3 or Color3.new(1,1,1)
		itemHoverFrame.header.itemName.Font = textData.font or Enum.Font.SourceSansBold

		local itemNameTextSize = textService:GetTextSize(itemHoverFrame.header.itemName.Text, titleTextSize, itemHoverFrame.header.itemName.Font, Vector2.new())

		local maxTextSize = itemNameTextSize

		local numStats = 0

		-- clear previous stats
		for i, obj in pairs(itemHoverFrame.stats.container:GetChildren()) do
			if not obj:IsA("UIListLayout") then
				obj:Destroy()
			end
		end

		if textData.additionalLines then
			for i, line in pairs(textData.additionalLines) do
				uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container, {line})
				local fragmentTextSize = textService:GetTextSize(line.text or "???", line.textSize or 20, line.font or Enum.Font.SourceSansBold, Vector2.new())
				if fragmentTextSize.X > maxTextSize.X then
					maxTextSize = Vector2.new(math.min(320 + 10, fragmentTextSize.X), fragmentTextSize.Y)
				end
				local fragmentYSize = math.ceil(fragmentTextSize.X / (320 + 10))
				numStats = numStats + fragmentYSize
			end
		end

		itemHoverFrame.stats.container.Size = UDim2.new(1, 0, 0, numStats * 20)
		itemHoverFrame.stats.Size 			= UDim2.new(1, 0, 0, numStats * 20)

		itemHoverFrame.stats.Visible = numStats > 0

		local y = 0
		for i,child in pairs(itemHoverFrame:GetChildren()) do
			if child:IsA("GuiObject") and child.Visible then
				y = y + child.AbsoluteSize.Y + itemHoverFrame.UIListLayout.Padding.Offset
			end
		end

		local x = 20 + maxTextSize.X

		local openSize = UDim2.new(0, x + 4, 0, y + 4)
		rootFrame.Size = openSize


		itemHoverFrame.header.itemName.Size = UDim2.new(0, itemNameTextSize.X,0, 18)
		itemHoverFrame.header.itemName.stars.Visible = false
		rootFrame.UIScale.Scale = Modules.input.menuScale
		reposition()

		rootFrame.Visible = true
		rootFrame.contents.Visible = true
	end

	network:create("populateItemHoverFrameWithTextData","BindableFunction","OnInvoke", populateItemHoverFrameWithTextData)

	local function populateItemHoverFrameWithAbility(abilityInfo, level, comparisonInfo, comparisonLevel)
		-- use comparison info for seeing dif between variants and upgrades

		local displayAbilityInfo = comparisonInfo or abilityInfo
		local displayLevel = comparisonLevel or level

		itemHoverFrame.header.itemName.Position = UDim2.new(0, 18,0, 3)
		itemHoverFrame.header.itemName.cuteDecor.Visible = true
		itemHoverFrame.header.itemName.cuteDecor.Image = "rbxassetid://2528902611"

		if abilityInfo == nil then
			rootFrame.Visible = false
			rootFrame.contents.Visible = false
			return false
		end

		rootFrame.Size = UDim2.new(0, 320 + 4, 0, 40 + 4)
		rootFrame.contents.Visible = false

		Modules.input.setCurrentFocusFrame(rootFrame)


		itemHoverFrame.main.thumbnailBG.Visible = false

--		rootFrame.itemType.Visible = false


		itemHoverFrame.header.itemName.AutoLocalize = false

		itemHoverFrame.main.Visible = true
		itemHoverFrame.main.thumbnail.Image = displayAbilityInfo.image
		local abilityName = displayAbilityInfo.name and localization.translate(displayAbilityInfo.name, itemHoverFrame.header.itemName) or "???"
		local unlearnedString = "(" .. localization.translate("Unlearned", itemHoverFrame.header.itemName) .. ")"
		itemHoverFrame.header.itemName.Text = abilityName .. " " .. ((displayLevel > 1 and "+"..(displayLevel-1)) or (displayLevel == 0 and unlearnedString) or "")

		cleanup()
		module.source = "ability"

		local levelToUse = (level > 0 and level) or 1

		local abilityStats
		if abilityInfo.statistics then
			abilityStats = ability_utilities.getAbilityStatisticsForRank(abilityInfo, levelToUse)
		end
		local tier = -1

		if displayLevel > 0 then
			tier = 1
			if displayLevel > 1 then
				tier = 2
			end
		end

		local comparisonStats
		if comparisonInfo and comparisonLevel then
			comparisonStats = ability_utilities.getAbilityStatisticsForRank(comparisonInfo, comparisonLevel)
		end

		if displayLevel ~= 0 and abilityStats and abilityStats.tier and abilityStats.tier > tier then
			tier = abilityStats.tier
		end

		if displayLevel ~= 0 and comparisonStats and comparisonStats.tier and comparisonStats.tier > tier then
			tier = comparisonStats.tier
		end

		local titleColor = module.tierColors[tier]

		local desc = displayAbilityInfo.description and localization.translate(displayAbilityInfo.description, itemHoverFrame.main.mainContents.itemDescription)
		itemHoverFrame.main.mainContents.itemDescription.Text = desc or "???"

		itemHoverFrame.main.mainContents.equippableClasses.Visible = false
		itemHoverFrame.main.mainContents.abilityInfo.Visible = false



		-- clear previous stats
		for i, obj in pairs(itemHoverFrame.stats.container:GetChildren()) do
			if not obj:IsA("UIListLayout") then
				obj:Destroy()
			end
		end

		local numStats = 0



		if abilityInfo.statistics then

			if comparisonStats then
				for stat,value in pairs(comparisonStats) do
					if not abilityStats[stat] then
						abilityStats[stat] = 0
					end
				end
			end

			for stat,value in pairs(abilityStats) do
				if stat ~= "tier" and string.sub(stat, 1, 1) ~= "_" and not ((stat == "manaCost" or stat == "cost") and value == 0) then

					local prefix = stat
					local displayValueFunction

					local statTextColor = Color3.fromRGB(255,255,255)
					local statPriority = 5
					local operator = ":"

					if stat == "damageMultiplier" then
						prefix = "Power"
						displayValueFunction = function(displayValue)
							return displayValue * 100
						end
						statPriority = 1
					elseif stat == "healing" then
						statPriority = 2
					elseif stat == "walkspeed" then
						prefix = "Movement Speed"
						operator = " +"
					elseif stat == "staminaRecovery" then
						prefix = "Stamina Recovery"
						displayValueFunction = function(displayValue)
							return displayValue * 100 .. "%"
						end
						operator = " +"
					elseif stat == "manaRestored" then
						prefix = "MP Restored"
					elseif stat == "cooldown" then
						displayValueFunction = function(displayValue)
							return displayValue .. "s"
						end
						statTextColor = Color3.fromRGB(160,160,160)
						statPriority = 6
					elseif stat == "range" then
						displayValueFunction = function(displayValue)
							return displayValue .. "m"
						end
						statPriority = 3
					elseif stat == "cost" or stat == "manaCost" then
						prefix = "MP"
						statTextColor = Color3.fromRGB(0, 152, 255)
						statPriority = 7
					elseif stat == "healthCost" then
						prefix = "HP"
						statTextColor = Color3.fromRGB(226, 34, 40)
						statPriority = 7
					end

					prefix = string.upper(string.sub(prefix,1,1)) .. string.sub(prefix,2)

					local nextLevelString

					if comparisonStats and (comparisonStats[stat] == nil or comparisonStats[stat] ~= value) then
						local comparisonValue = comparisonStats[stat] or 0
						local comparisonDisplayValue = displayValueFunction and displayValueFunction(comparisonValue) or comparisonValue
						nextLevelString = {
							text = "→ " .. comparisonDisplayValue;
							textColor3 = Color3.fromRGB(220, 181, 25);
							font = Enum.Font.SourceSansBold;
							textSize = 23;
						}
					end

					local displayValue = displayValueFunction and displayValueFunction(value) or value

					local fragment = uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container,{

						--[[
						{text = (statValue >= 0 and "+" or "") .. statValue .. (statName:find("Percent") and "%" or "")},
						{text = statName:gsub("Percent", ""):gsub("Flat", "")}
						]]
						{text = prefix..operator, textColor3 = statTextColor; textSize = 19;},
						{text = tostring(displayValue); font = Enum.Font.SourceSansBold, textColor3 = statTextColor; textSize = 23;},
						nextLevelString
					})
					numStats = numStats + 1
					fragment.LayoutOrder = statPriority
				end
			end
		end

		local itemNameTextSize 			= textService:GetTextSize(itemHoverFrame.header.itemName.Text, titleTextSize, itemHoverFrame.header.itemName.Font, Vector2.new())

		local itemDescriptionTextSize 	= textService:GetTextSize(itemHoverFrame.main.mainContents.itemDescription.Text, itemHoverFrame.main.mainContents.itemDescription.TextSize, itemHoverFrame.main.mainContents.itemDescription.Font, Vector2.new())

		local itemNameLines 		= 1 -- math.ceil(itemNameTextSize.X / itemHoverFrame.header.itemName.AbsoluteSize.X)
		local itemDescriptionLines 	= math.ceil(itemDescriptionTextSize.X / itemHoverFrame.main.mainContents.itemDescription.AbsoluteSize.X)
		--[[
		local headerYSize = itemNameTextSize.Y * itemNameLines + itemHoverFrame.header.itemType.TextBounds.Y + 5

		itemHoverFrame.header.Size 			= UDim2.new(1, -10, 0, headerYSize)
		itemHoverFrame.header.itemName.Size = UDim2.new(1, -5, 0, itemNameTextSize.Y * itemNameLines)
		itemHoverFrame.stats.container.Size = UDim2.new(1, 0, 0, numStats * 18)
		itemHoverFrame.stats.Size 			= UDim2.new(1, 0, 0, numStats * 18 + 20)
		itemHoverFrame.main.mainContents.itemDescription.Size = UDim2.new(1, 0, 0, itemDescriptionTextSize.Y * itemDescriptionLines + 10)

		--local y = headerYSize + itemDescriptionTextSize.Y * itemDescriptionLines + 20 + numStats * 18 + 30 + 10
		local y = headerYSize + itemHoverFrame.main.mainContents.AbsoluteSize.Y + numStats * 18 + 20	+ (numStats > 0 and 20 or 0)


		]]


		local headerYSize = itemNameTextSize.Y * itemNameLines

		itemHoverFrame.header.Size 			= UDim2.new(1, 0, 0, headerYSize)
		itemHoverFrame.header.itemName.Size = UDim2.new(0, itemNameTextSize.X, 0, itemNameTextSize.Y * itemNameLines)
		itemHoverFrame.header.itemName.stars.Visible = false
		itemHoverFrame.stats.container.Size = UDim2.new(1, 0, 0, numStats * 19)
		itemHoverFrame.stats.Size 			= UDim2.new(1, 0, 0, numStats * 19)

		itemHoverFrame.stats.Visible = numStats > 0

		itemHoverFrame.main.mainContents.itemDescription.Size = UDim2.new(1, 0, 0, itemDescriptionTextSize.Y * itemDescriptionLines + 10)


		local y = 16
		for i,child in pairs(itemHoverFrame:GetChildren()) do
			if child:IsA("GuiObject") and child.Visible then
				y = y + child.AbsoluteSize.Y + itemHoverFrame.UIListLayout.Padding.Offset
			end
		end

		local openSize = UDim2.new(0, 320 + 4, 0, y + 4)

		rootFrame.Size = openSize


		itemHoverFrame.header.itemName.TextColor3 = titleColor
		itemHoverFrame.header.itemName.cuteDecor.ImageColor3 = titleColor
		itemHoverFrame.main.thumbnail.BorderColor3 = titleColor
		rootFrame.UIScale.Scale = Modules.input.menuScale
		reposition()
		rootFrame.Visible = true
		rootFrame.UIScale.Scale = Modules.input.menuScale
		rootFrame.contents.Visible = true

	end





	network:create("populateItemHoverFrameWithAbility","BindableFunction","OnInvoke", populateItemHoverFrameWithAbility)

	local function populateItemHoverFrame(itemBaseData, newSource, inventorySlotData, additionalInfo)

		itemHoverFrame.header.itemName.Position = UDim2.new(0, 18,0, 3)
		itemHoverFrame.header.itemName.cuteDecor.Visible = true
		itemHoverFrame.header.itemName.cuteDecor.Image = "rbxassetid://2528902611"

--		itemHoverFrame.main.thumbnail.BackgroundTransparency = 0.2

		itemHoverFrame.main.thumbnailBG.Visible = true

		Modules.input.setCurrentFocusFrame(rootFrame)

		itemHoverFrame.main.mainContents.abilityInfo.Visible = false

		itemHoverFrame.main.Visible = true

		newSource = newSource or "pickup"
		module.source = newSource

		if itemBaseData == nil then
			rootFrame.Visible = false
			rootFrame.contents.Visible = false
			module.source = "none"
			return false
		end

		rootFrame.Size = UDim2.new(0, 320 + 4, 0, 40 + 4)

		if not rootFrame.Visible then
			rootFrame.contents.Visible = false
		end


		itemHoverFrame.header.itemName.AutoLocalize = false

		if inventorySlotData and inventorySlotData.customName then
			itemHoverFrame.header.itemName.Font = Enum.Font.SourceSansItalic
--			itemHoverFrame.header.itemName.AutoLocalize = false
		else
			itemHoverFrame.header.itemName.Font = Enum.Font.SourceSansBold
--			itemHoverFrame.header.itemName.AutoLocalize = true
		end

		cleanup()

		local itemBaseName = itemBaseData.name and localization.translate(itemBaseData.name, itemHoverFrame.header.itemName)
		local itemname = inventorySlotData and inventorySlotData.customName or itemBaseName or "???"

		local attribute = inventorySlotData.attribute
		if attribute then
			local attributeData = itemAttributes[attribute]
			if attributeData then
				if attributeData.color then
					itemHoverFrame.main.thumbnailBG.ImageColor3 = attributeData.color
				end
				if attributeData.prefix and not inventorySlotData.customName then
					local attributeName = localization.translate(attributeData.prefix, itemHoverFrame.header.itemName)
					itemname = attributeName .. " " .. itemname
				end
			end
		end

		itemname = itemname .. ((inventorySlotData and inventorySlotData.upgrades and inventorySlotData.upgrades > 0 and " +"..(inventorySlotData.successfulUpgrades or 0)) or "")

		itemHoverFrame.header.itemName.Text 	= itemname

		itemHoverFrame.main.mainContents.itemDescription.AutoLocalize = false
		local desc = itemBaseData.description and localization.translate(itemBaseData.description, itemHoverFrame.main.mainContents.itemDescription)
		itemHoverFrame.main.mainContents.itemDescription.Text 	= desc or "Unknown"
		itemHoverFrame.header.itemType.Text 	= itemBaseData.category and string.upper(itemBaseData.category:sub(1, 1)) .. itemBaseData.category:sub(2) or "Unknown"

		--[[
		local itemNameTextSize 			= textService:GetTextSize(itemBaseData.name, 20, Enum.Font.SourceSansBold, Vector2.new())
		local itemDescriptionTextSize 	= textService:GetTextSize(itemBaseData.description, 14, Enum.Font.SourceSansItalic, Vector2.new())
		]]
		local itemNameTextSize 			= textService:GetTextSize(itemHoverFrame.header.itemName.Text, titleTextSize, itemHoverFrame.header.itemName.Font, Vector2.new())
		local itemDescriptionTextSize 	= textService:GetTextSize(itemHoverFrame.main.mainContents.itemDescription.Text, itemHoverFrame.main.mainContents.itemDescription.TextSize, itemHoverFrame.main.mainContents.itemDescription.Font, Vector2.new())



		local push = 0

		-- old scrolls indicator (defunct)
		--[[
		if inventorySlotData.enchantments and #inventorySlotData.enchantments > 0 then
			for i, child in pairs(itemHoverFrame.enchantments:GetChildren()) do
				if child:IsA("GuiObject") then
					child:Destroy()
				end
			end
			for i, enchantment in pairs(inventorySlotData.enchantments) do
				local enchantmentBaseData = itemLookup[enchantment.id]
				local enchantment = enchantmentBaseData.enchantments[enchantment.state]
				local frame = script.enchantment:Clone()
				local tierColor = module.tierColors[enchantment.tier + 1]
				frame.frame.ImageColor3 = tierColor
				frame.shine.ImageColor3 = tierColor
				frame.item.Image = enchantmentBaseData.image
				frame.LayoutOrder = 10-(enchantment.tier)
				frame.Parent = itemHoverFrame.enchantments
				Modules.fx.setFlash(frame.frame, enchantment.tier >= 1)
			end
			itemHoverFrame.enchantments.Visible = true
			push = push + 36
		end
		]]

		if (inventorySlotData and inventorySlotData.soulbound) or itemBaseData.soulbound then
			itemHoverFrame.soulbound.Visible = true
			push = push + 24
		end

		if itemBaseData.perks then
			for perkName, active in pairs(itemBaseData.perks) do
				if active then
					local perkData = perkLookup[perkName]
					if perkData then
						local perk = script.perk:Clone()
						perk.title.Text = perkData.title
						perk.description.Text = perkData.description
						if perkData.color then
							perk.ImageColor3 = perkData.color
						end
						perk.Visible = true
						perk.Parent = itemHoverFrame
						push = push + 46
					end
				end
			end
		end

		if additionalInfo and additionalInfo.notOwned then
			itemHoverFrame.notOwned.Visible = true
			push = push + 24
		end


		local itemNameLines = 1
--		local itemNameLines 		= math.ceil(itemNameTextSize.X / itemHoverFrame.header.itemName.AbsoluteSize.X)
		local itemDescriptionLines 	= math.ceil(itemDescriptionTextSize.X / itemHoverFrame.main.mainContents.itemDescription.AbsoluteSize.X)





		itemHoverFrame.main.thumbnail.Image 			= itemBaseData.image

		itemHoverFrame.main.mainContents.equippableClasses.Visible = itemBaseData.category and itemBaseData.category == "equipment"
		itemHoverFrame.main.mainContents.equippableClasses.requirements.reqLevel.Visible = false
--		itemHoverFrame.main.mainContents.equippableClasses.requirements.reqLevel
		if itemBaseData.minLevel then
			itemHoverFrame.main.mainContents.equippableClasses.requirements.reqLevel.Visible = true
			itemHoverFrame.main.mainContents.equippableClasses.requirements.reqLevel.Text = "REQ Lvl. "..itemBaseData.minLevel or 0
			local level = network:invoke("getCacheValueByNameTag", "level") or 1
			itemHoverFrame.main.mainContents.equippableClasses.requirements.reqLevel.TextColor3 = Color3.fromRGB(203, 203, 203)
			if itemBaseData.minLevel > level then
				itemHoverFrame.main.mainContents.equippableClasses.requirements.reqLevel.TextColor3 = Color3.fromRGB(203, 69, 71)
			end
		end

		local canEquipClass = false

		local class = itemBaseData.minimumClass or "adventurer"
		class = class:lower()

		if class == "adventurer" then
			canEquipClass = true
		elseif network:invoke("getCacheValueByNameTag", "class"):lower() == class then
			canEquipClass = true
		else
			local abilityBooks = network:invoke("getCacheValueByNameTag", "abilityBooks")
			canEquipClass = abilityBooks[class] ~= nil
		end

		local classTree = {
			["hunter"] = "hunter";
			["assassin"] = "hunter";
			["trickster"] = "hunter";
			["ranger"] = "hunter";
			["mage"] = "mage";
			["sorcerer"] = "mage";
			["warlock"] = "mage";
			["cleric"] = "mage";
			["warrior"] = "warrior";
			["paladin"] = "warrior";
			["knight"] = "warrior";
			["berserker"] = "warrior";
		}

		local classRoot = classTree[class]
		classRoot = classRoot or class

		for i,obj in pairs(itemHoverFrame.main.mainContents.equippableClasses:GetChildren()) do
			if obj:IsA("ImageLabel") then
				if classRoot and classRoot == obj.Name then
					obj.ImageTransparency = 0
					obj.Image = "rbxgameasset://Images/emblem_"..class
				else
					obj.ImageTransparency = 0.7
					obj.Image = "rbxgameasset://Images/emblem_"..obj.Name
				end

				if canEquipClass then
					obj.ImageColor3 = Color3.fromRGB(173, 173, 173)
				else
					obj.ImageColor3 = Color3.fromRGB(203, 69, 71)
				end
			end
		end

		-- clear previous stats
		for i, obj in pairs(itemHoverFrame.stats.container:GetChildren()) do
			if not obj:IsA("UIListLayout") then
				obj:Destroy()
			end
		end


		local numStats = 0

		local totalStats, statBonuses = getItemInfo(itemBaseData, inventorySlotData)

		local equippedStats

		local equipped = network:invoke("getCacheValueByNameTag", "equipment")

		-- look for an equipped item to compare this to
		local correspendingEquipmentInventoryData
		for i,equipment in pairs(equipped) do
			if itemBaseData.equipmentSlot and equipment.position and itemBaseData.equipmentSlot == equipment.position then
				correspendingEquipmentInventoryData = equipment
				break
			end
		end
		if newSource ~= "equipment" then
			if correspendingEquipmentInventoryData then
				local correspondingEquipmentBaseData = itemLookup[correspendingEquipmentInventoryData.id]
				if correspondingEquipmentBaseData then
					equippedStats = getItemInfo(correspondingEquipmentBaseData,correspendingEquipmentInventoryData)
				end
			end
		end

		for statName,statValue in pairs(totalStats) do
			if statValue ~= 0 then

				local statDisplayName = #statName <=3 and statName:upper() or statName:sub(1,1):upper() .. statName:sub(2)

				local statDisplayValue
				local statTextColor = Color3.new(160,160,160)

				local statPriority = 5
				local statValueSize = 24

				if statName == "baseDamage" then
					statDisplayName = "Weapon Attack"
					statPriority = 1
				elseif statName == "defense" then
					statPriority = 1
				elseif statName == "woodcutting" then
					statPriority = 2
					statDisplayName = "Woodcutting Power"
				elseif statName == "mining" then
					statPriority = 2
					statDisplayName = "Mining Power"
				elseif statName == "damageTakenMulti" then
					statDisplayName = "Damage Taken"
					statPriority = 3
					statDisplayValue = statValue * 100 .. "%" .. (statBonuses[statName] and statBonuses[statName] > 0 and " (+" .. statBonuses[statName] * 100 .. "%)" or "")
				elseif statName == "damageGivenMulti" then
					statDisplayName = "Damage Given"
					statPriority = 3
					statDisplayValue = statValue * 100 .. "%" .. (statBonuses[statName] and statBonuses[statName] > 0 and " (+" .. statBonuses[statName] * 100 .. "%)" or "")
				elseif statName == "magicalDamage" then
					statDisplayName = "Magic Attack"
					statPriority = 3
				elseif statName == "rangedDamage" then
					statDisplayName = "Ranged Attack"
					statPriority = 3
				elseif statName == "physicalDamage" then
					statDisplayName = "Physical Attack"
					statPriority = 3
				elseif statName == "magicalDefense" then
					statDisplayName = "Magic Defense"
					statPriority = 3
				elseif statName == "rangedDefense" then
					statDisplayName = "Projectile Defense"
					statPriority = 3
				elseif statName == "physicalDefense" then
					statDisplayName = "Physical Defense"
					statPriority = 3
				elseif statName == "maxMana" then
					statDisplayName = "Max MP"
					statPriority = 4
				elseif statName == "maxHealth" then
					statDisplayName = "Max HP"
					statPriority = 4
				elseif statName == "healthRegen" then
					statDisplayName = "HP Recovery"
					statPriority = 5
					statDisplayValue = statValue .. "%" .. (statBonuses[statName] and statBonuses[statName] > 0 and " (+" .. statBonuses[statName] .. "%)" or "")
				elseif statName == "manaRegen" then
					statDisplayName = "MP Recovery"
					statPriority = 5
					statDisplayValue = statValue .. "%" .. (statBonuses[statName] and statBonuses[statName] > 0 and " (+" .. statBonuses[statName] .. "%)" or "")
				elseif statName == "criticalStrikeChance" then
					statDisplayName = "Critical Hits"
					statDisplayValue = statValue * 100 .. "%" .. (statBonuses[statName] and statBonuses[statName] > 0 and " (+" .. statBonuses[statName] * 100 .. "%)" or "")
					statPriority = 5
				elseif statName == "blockChance" then
					statDisplayName = "Block Chance"
					statDisplayValue = statValue * 100 .. "%" .. (statBonuses[statName] and statBonuses[statName] > 0 and " (+" .. statBonuses[statName] * 100 .. "%)" or "")
					statPriority = 5

				elseif statName == "greed" then
					statDisplayName = "Greed"
					statPriority = 6
					statDisplayValue = statValue * 100 .. "%" .. (statBonuses[statName] and statBonuses[statName] > 0 and " (+" .. statBonuses[statName] * 100 .. "%)" or "")
				elseif statName == "wisdom" then
					statDisplayName = "XP"
					statPriority = 6
					statDisplayValue = statValue * 100 .. "%" .. (statBonuses[statName] and statBonuses[statName] > 0 and " (+" .. statBonuses[statName] * 100 .. "%)" or "")
				elseif statName:find("_totalMultiplicative") then
					statDisplayName = statName:gsub("_totalMultiplicative", "")
					statDisplayName = statDisplayName:sub(1, 1):upper()..statDisplayName:sub(2)
					statPriority = 7
					statDisplayValue = (statValue * 100).."%"
				elseif statName == "attackSpeed" then
					statDisplayName = "Attack Speed"
					statPriority = 10
					statValueSize = 19
					statDisplayValue = ({"Very slow", "Slow", "Normal", "Fast", "Very fast"})[statValue] or statValue
				end

				-- if a name isn't right, just change it here
				local replacements = {
					["Walkspeed"] = "Movement Speed",
				}
				statDisplayName = replacements[statDisplayName] or statDisplayName

				if not statDisplayValue then
					statDisplayValue = (statValue .. (statBonuses[statName] and
						((statBonuses[statName] > 0 and " (+" .. statBonuses[statName] .. ")" ) or
						(statBonuses[statName] < 0 and " (" .. statBonuses[statName] .. ")"))
						or ""))
				end

				local comparisonExtension

				if equippedStats and equippedStats[statName] and equippedStats[statName] ~= 0 then

					local difference = ((statValue - equippedStats[statName]) / equippedStats[statName])
					if statName == "damageTakenMulti" then
						difference = -difference
					end
					if difference == difference then
						local comparisonText
						local comparisonColor
						if statValue == equippedStats[statName] or math.abs(difference) <= 0.01 then
							--comparisonText = "="
						elseif difference >= 0 then
							comparisonText = "↑"
							comparisonColor = Color3.fromRGB(150,255,150)
							--[[
							if difference >= 1 then
								comparisonText = "↑↑↑"
							elseif difference >= 0.25 then
								comparisonText = "↑↑"
							end
							]]
						else
							comparisonText = "↓"
							comparisonColor = Color3.fromRGB(255,150,150)
							--[[
							if difference <= -0.5 then
								comparisonText = "↓↓↓"
							elseif difference <= -0.2 then
								comparisonText = "↓↓"
							end
							]]
						end
						if comparisonText then
							comparisonExtension = {text = comparisonText; textSize=20; font=Enum.Font.SourceSansBold; textColor3 = comparisonColor or Color3.new(0.6,0.6,0.6), autoLocalize = false}
						end
					end
				end

				if statValue > 0 then
					statDisplayValue = statDisplayValue
				end
				statDisplayName = localization.translate(statDisplayName, itemHoverFrame.stats.container) .. ": "

				local textContainer = uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container, {

					--[[
					{text = (statValue >= 0 and "+" or "") .. statValue .. (statName:find("Percent") and "%" or "")},
					{text = statName:gsub("Percent", ""):gsub("Flat", "")}
					]]
					{text = statDisplayName, textColor3 = statTextColor, textSize = 19, autoLocalize = false},
					{text = statDisplayValue, font = Enum.Font.SourceSansBold, textSize = statValueSize, textColor3 = statTextColor, autoLocalize = false},
					comparisonExtension
				})
				textContainer.LayoutOrder = statPriority
				numStats = numStats + 1
				if statBonuses[statName] and statBonuses[statName] > 0 then
					if statName == "baseDamage" then
						local totalDamage = totalStats["baseDamage"] or 0.1
						local modifierBaseDamage = statBonuses["baseDamage"] or 0
						local difference = totalDamage / (totalDamage - modifierBaseDamage)
					end
				end
			end
		end

		if inventorySlotData and inventorySlotData.upgrades then
			local maxUpgrades = (itemBaseData.maxUpgrades or 0) + (inventorySlotData.bonusUpgrades or 0)

			local upgradesLeft = maxUpgrades - inventorySlotData.upgrades
			local suffix = upgradesLeft == 1 and "upgrade attempt remaining" or "upgrade attempts remaining"

			local label = uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container, {
				{text = (tostring(upgradesLeft).." "..suffix); font = Enum.Font.SourceSans; textColor3 = Color3.new(1,1,1); textTransparency = 0.5; autoLocalize = true}
			})
			label.LayoutOrder = 7
			numStats = numStats + 1

		end
		--[[
		rootFrame.itemType.Visible = true

		for i,itemTypeLabel in pairs(rootFrame.itemType:GetChildren()) do
			if itemBaseData.category and itemBaseData.category == itemTypeLabel.Name then
				itemTypeLabel.Visible = true
			else
				itemTypeLabel.Visible = false
			end
		end
		]]


		local titleColor
		if inventorySlotData then
			titleColor = getTitleColorForInventorySlotData(inventorySlotData)
		end

		titleColor = titleColor or itemBaseData.nameColor or Color3.new(1,1,1)


		itemHoverFrame.header.itemName.TextColor3 = titleColor
		itemHoverFrame.header.itemName.cuteDecor.ImageColor3 = titleColor

		local itemType = itemBaseData.itemType
		itemHoverFrame.header.itemName.cuteDecor.Image = "rbxgameasset://Images/category_"..itemType

		local maxUpgrades = itemBaseData.maxUpgrades or 0
		-- stars next to item name (defunct)
		--[[
		for i,star in pairs(itemHoverFrame.header.itemName.stars:GetChildren()) do
			if star:IsA("ImageLabel") then
				local n = tonumber(star.Name)
				star.ImageColor3 = Color3.fromRGB(255, 255, 255)
				star.ImageTransparency = 0.9
				star.LayoutOrder = 12
				star.Visible = n <= maxUpgrades
				star.Image = "rbxassetid://3763830087"
			end
		end
		local n = 0
		if inventorySlotData.enchantments then
			for i, enchantmentData in pairs(inventorySlotData.enchantments) do
				local enchantmentBaseData = itemLookup[enchantmentData.id].enchantments[enchantmentData.state]
				local star = itemHoverFrame.header.itemName.stars:FindFirstChild(tostring(i))
				star.ImageTransparency = 0
				local tier = enchantmentBaseData.tier or 0
--				star.ImageColor3 = module.tierColors[tier]
				star.ImageColor3 = titleColor
				star.LayoutOrder = 10 - tier
				star.Visible = true
				n = n + 1
			end
		end
		local fails = math.clamp((inventorySlotData.upgrades or 0) - (inventorySlotData.successfulUpgrades or 0), 0, maxUpgrades)
		for i=1,fails do
			local star = itemHoverFrame.header.itemName.stars:FindFirstChild(tostring(n+i))
			if star then
				star.LayoutOrder = 11
				star.ImageTransparency = 0
				star.ImageColor3 = module.tierColors[-1]
				star.Image = "rbxassetid://3799648173"
			end
		end
		]]

		itemHoverFrame.main.thumbnailBG.frame.ImageColor3 = titleColor
		itemHoverFrame.main.thumbnailBG.shine.ImageColor3 = titleColor


		itemHoverFrame.main.thumbnail.BorderColor3 = titleColor


		--inventorySlotData and inventorySlotData.upgrades


		itemHoverFrame.main.thumbnail.ImageColor3 = Color3.new(1,1,1)

		local customTag = (inventorySlotData and inventorySlotData.customTag) or (itemBaseData and itemBaseData.customTag)

		if customTag then

			local label = uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container,customTag)
			label.LayoutOrder = 12
			numStats = numStats + 1
		end

		local perks = {}
		if itemBaseData.perkData then
			table.insert(perks, itemBaseData.perkData)
		end
		if inventorySlotData.perkData then
			table.insert(perks, inventorySlotData.perkData)
		end
		for i,perkData in pairs(perks) do
			local label = uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container, {
				{text = itemBaseData.perkData.title; font = Enum.Font.SourceSansBold; textColor3 = module.tierColors[perkData.tier or 1]; textTransparency = 0; autoLocalize = true}
			})
			label.LayoutOrder = 9
			numStats = numStats + 1
		end

		if inventorySlotData and inventorySlotData.dye then
			itemHoverFrame.main.thumbnail.ImageColor3 = Color3.fromRGB(inventorySlotData.dye.r, inventorySlotData.dye.g, inventorySlotData.dye.b)
			local label = uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container, {
				{text = "Dyed"; font = Enum.Font.SourceSansBold; textColor3 = Color3.fromRGB(inventorySlotData.dye.r, inventorySlotData.dye.g, inventorySlotData.dye.b); textTransparency = 0}
			})
			label.LayoutOrder = 10
			numStats = numStats + 1
		end


		if inventorySlotData and inventorySlotData.customStory then
			local label = uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container, {
				{text = ""; font = Enum.Font.SourceSans; textTransparency = 1; autoLocalize = false;}
			})
			label.LayoutOrder = 11
			local label = uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container, {
				{text = "\""..inventorySlotData.customStory.."\""; font = Enum.Font.Antique; textColor3 = Color3.new(1, 1, 1); textTransparency = 0.2; autoLocalize = false;}
			})
			label.LayoutOrder = 11
			numStats = numStats + 2
		end

		local headerYSize = itemNameTextSize.Y * itemNameLines

		itemHoverFrame.header.Size 			= UDim2.new(1, 0, 0, headerYSize)
		itemHoverFrame.header.itemName.Size = UDim2.new(0, itemNameTextSize.X, 0, itemNameTextSize.Y * itemNameLines)
--		itemHoverFrame.header.itemName.stars.Visible = true
		itemHoverFrame.stats.container.Size = UDim2.new(1, 0, 0, numStats * 20)
		itemHoverFrame.stats.Size 			= UDim2.new(1, 0, 0, numStats * 20)

		itemHoverFrame.stats.Visible = numStats > 0

		itemHoverFrame.main.mainContents.itemDescription.Size = UDim2.new(1, 0, 0, itemDescriptionTextSize.Y * itemDescriptionLines + 10)

		--local y = headerYSize + itemDescriptionTextSize.Y * itemDescriptionLines + 20 + numStats * 18 + 30 + 10



--		local y = headerYSize + mainContentsSize + numStats * 18 + (numStats > 0 and 20 or 0) + push

		local y = 10
		for i,child in pairs(itemHoverFrame:GetChildren()) do
			if child:IsA("GuiObject") and child.Visible then
				y = y + child.AbsoluteSize.Y + itemHoverFrame.UIListLayout.Padding.Offset
			end
		end


		local openSize = UDim2.new(0, 320 + 4, 0, y + 4)

		rootFrame.Size = openSize
		rootFrame.contents.Visible = true

		if module.source ~= "pickup" and module.source ~= "none" then
			rootFrame.UIScale.Scale = Modules.input.menuScale
			reposition()
			rootFrame.Visible = true
		end

		--rootFrame.Size = openSize

		-- returns the
		--return
		--	tweenService:Create(itemHoverFrame, BASIC_TWEEN_INFO, {Size = openSize}),
		--	tweenService:Create(itemHoverFrame, BASIC_TWEEN_INFO, {Size = UDim2.new(0, 195, 0, headerYSize + itemDescriptionTextSize.Y * itemDescriptionLines + 15 + (18 + 5) + 5)})
	end

	network:create("populateItemHoverFrame","BindableFunction","OnInvoke",populateItemHoverFrame)

	local function getItemBaseDataFromItemsPart(itemPart)
		local itemDataModule = itemsDataFolder:FindFirstChild(itemPart.Name)
		if itemDataModule then
			local itemBaseData 			= require(itemDataModule)
			itemBaseData.physItemName 	= itemPart.Name

			return itemBaseData
		end
	end

	local function getClosestItem()
		if player.Character and player.Character.PrimaryPart then
			local closestItem, closestItemDistance = nil, ITEM_ACQUISITION_RANGE
			for i, item in pairs(itemsFolder:GetChildren()) do
				local distanceAway = utilities.magnitude(player.Character.PrimaryPart.Position - item.Position)
				if (not closestItem and distanceAway <= closestItemDistance) or (closestItem and distanceAway < closestItemDistance) then
					if utilities.playerCanPickUpItem(player, item) then
						closestItem 		= item
						closestItemDistance = distanceAway
					end
				end
			end

			return closestItem, closestItemDistance
		end
	end


	--game:GetService("RunService"):BindToRenderStep("itemHoverRepos",Enum.RenderPriority.Camera - 5,reposition)



	local function onInputChanged(inputObject)
		if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
			local hitPart, hitPosition, distanceAway = raycastFromScreenPositionForItems(inputObject.Position.X, inputObject.Position.Y)

			if hitPart then

				local item = (hitPart.Parent == itemsFolder and hitPart) or (hitPart.Parent.Parent == itemsFolder and hitPart.Parent) or (hitPart.Parent.Parent.Parent == itemsFolder and hitPart.Parent.Parent)

				local itemBaseData = getItemBaseDataFromItemsPart(item)

				local isOwner = utilities.playerCanPickUpItem(player, item)
				local additionalInfo = {}

				if not isOwner then
					additionalInfo.notOwned = true
				end

				if itemBaseData then
					if not currentItemHoverData or currentItemHoverData.item ~= item then
						if item:FindFirstChild("metadata") and item.metadata.Value ~= "" then
							local regularSizeAnimation, pickupSizeAnimation = populateItemHoverFrame(itemBaseData, "pickup", game:GetService("HttpService"):JSONDecode(item.metadata.Value), additionalInfo)
						else
							local regularSizeAnimation, pickupSizeAnimation = populateItemHoverFrame(itemBaseData, "pickup", nil, additionalInfo)
						end

						--[[
						currentItemHoverData = {
							item 					= hitPart;
							itemBaseData 			= itemBaseData;
							regularSizeAnimation 	= regularSizeAnimation;
							pickupSizeAnimation 	= pickupSizeAnimation;

						}
						]]
					end

					--if distanceAway <= ITEM_ACQUISITION_RANGE then
					--	currentItemHoverData.pickupSizeAnimation:Play()
					--else
					--	currentItemHoverData.regularSizeAnimation:Play()
					--end

					if not rootFrame.Visible then
						module.source = "pickup"
						rootFrame.UIScale.Scale = Modules.input.menuScale
						reposition()
						rootFrame.Visible = true

					end

					--[[

					local targetPosition = UDim2.new(0, inputObject.Position.X + 20, 0, inputObject.Position.Y + 10)

					-- clamp Y axis to bottom side of the screen
					if targetPosition.Y.Offset + rootFrame.AbsoluteSize.Y > gameUI.AbsoluteSize.Y then
						targetPosition = UDim2.new(0, targetPosition.X.Offset, 0, gameUI.AbsoluteSize.Y - rootFrame.AbsoluteSize.Y)
					end

					-- clamp X axis to right side of the screen
					if targetPosition.X.Offset + rootFrame.AbsoluteSize.X > gameUI.AbsoluteSize.X then
						targetPosition = UDim2.new(0, gameUI.AbsoluteSize.X - rootFrame.AbsoluteSize.X, 0, targetPosition.Y.Offset)
					end

					rootFrame.Position = targetPosition
					]]
				else
					if rootFrame.Visible and module.source == "pickup" then
						rootFrame.Visible = false
					end
				end
			else
				currentItemHoverData = nil

				if rootFrame.Visible and module.source == "pickup" then
					rootFrame.Visible = false
				end
			end
		end
	end

	local itemBackup

	local function outQuad(t, d)
		local b = 0
		local c = 1
		t = t / d
		return -c * t * (t - 2) + b
	end

	local RunService = game:GetService("RunService")

	local function attract(representation)

		local startpos = representation.CFrame
		local start = tick()
		local duration = 0.5
		while tick() - start <= duration do
			RunService.Heartbeat:wait()
			if representation then
				if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.PrimaryPart then
					representation.CFrame = startpos:lerp(game.Players.LocalPlayer.Character.PrimaryPart.CFrame, outQuad(tick()-start,duration))
				else
					break
				end
			end
		end
	end


	local function onPickUpItemRequestFromServer(metadata, success, value, representationOverride, resultMessage)
		-- bere edit: show display name
		local realItem = itemLookup[metadata.id]


		if success then
			if realItem.id == 1 then
				--[[
				local prompt = uiCreator.createInteractionPrompt(nil,
					{text = "Obtained"; textColor3 = Color3.fromRGB(120,120,120)},
					{text = (value or 0).." gold"; textColor3 = Color3.fromRGB(255, 255, 0)}
				)

				prompt:setBackgroundColor3(Color3.fromRGB(190, 190, 190))
				prompt:setExpireTime(1.5)
				]]
				uiCreator.showCurrency(value)
			elseif realItem.autoConsume and resultMessage then
				local prompt = uiCreator.createInteractionPrompt(nil,
					{text = resultMessage; textColor3 = Color3.fromRGB(70,70,70)}
				)

				prompt:setBackgroundColor3(Color3.fromRGB(190, 190, 190))
				prompt:setExpireTime(5)

				if realItem.useSound then
					utilities.playSound(realItem.useSound)
				end
			else
				uiCreator.showItemPickup(realItem, value, metadata)
			end

			local Character = game.Players.LocalPlayer.Character
			if itemBackup and Character and Character.PrimaryPart and not representationOverride then
				local representation = itemBackup:Clone()

				itemBackup:Destroy()
				itemBackup = nil

				representation.Parent = workspace.CurrentCamera
				representation.Anchored = true
				representation.CanCollide = false

				local sound
				if representation.Name == "monster idol" then
					sound = utilities.playSound("idolPickup")
				elseif representation:FindFirstChild("Legendary") and representation.Legendary.Enabled then
					sound = utilities.playSound("legendaryItemPickup")
				elseif representation:FindFirstChild("Rare") and representation.Rare.Enabled then
					sound = utilities.playSound("rareItemPickup")
				else
					sound = utilities.playSound("pickup")
				end


				if representation:IsA("BasePart") then
					representation.CanCollide = false
				end
				for _, descend in pairs(representation:GetDescendants()) do
					if descend:IsA("BasePart") then
						descend.CanCollide = false
					end
				end

				attract(representation)

				if sound then
					pcall(function() -- ahhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
						sound.Parent = workspace.CurrentCamera
						game.Debris:AddItem(sound, 2)
					end)
				end
				representation:Destroy()

			end
		else
			if resultMessage == "full-inventory" then
				network:fire("alert", {text = "Your inventory is full for this item's category."})
				warn("inventory full?")
			end
		end
	end

	local function itemsRecieved(items, money)
		if money and money > 0 then
			table.insert(items, {id = 1; value = money})
		end
		for i,item in pairs(items) do
			local realItem = itemLookup[item.id or item.id]
			if realItem then
				onPickUpItemRequestFromServer(item, true, (item.value or item.stacks), true)
				if (realItem.rarity and realItem.rarity == "Legendary") then
					utilities.playSound("legendaryItemPickup")
				elseif (realItem.rarity and realItem.rarity == "Rare") or (realItem.category and realItem.category == "equipment") then
					utilities.playSound("rareItemPickup")
				end
			end
		end
	end

	network:create("displayRewards", "BindableFunction", "OnInvoke", itemsRecieved)



	network:connect("itemsRecieved","OnClientEvent",itemsRecieved)

	local itemPickupData = {}

	local function processPickupKeyDown(id)
		if id == "pickup" and pickupInteractionPromptTable.item then
			itemBackup = pickupInteractionPromptTable.item
			local success, returnValue = network:invokeServer("pickUpItemRequest", pickupInteractionPromptTable.item)

			if not success then
				network:fire("alert", {id = pickupInteractionPromptTable.item; text = "Pick-up failed: " .. returnValue})
			end

			pickupInteractionPromptTable.item = nil
		end
	end

	local keyDown = false

	local inputObject

	local function inputGained(newInputObject)
		inputObject = newInputObject
		if inputObject and inputObject.UserInputState == Enum.UserInputState.Begin then
			keyDown = true
			processPickupKeyDown("pickup")
		else
			keyDown = false
		end
	end

	module.pickupInputGained = inputGained

	network:invoke("addInputAction", "pick up", inputGained, "F")

	local function main()
		userInputService.InputChanged:connect(onInputChanged)
		--network:connect("pickUpItemRequest", "OnClientEvent", onPickUpItemRequestFromServer)--onPickUpItemRequestFromServer)
		network:connect("notifyPlayerPickUpItem", "OnClientEvent", onPickUpItemRequestFromServer)

		-- todo: make it so this isn't always running somehow?
		while wait(1 / 15) do
			if inputObject and inputObject.UserInputState == Enum.UserInputState.Begin then
				keyDown = true
			else
				keyDown = false
			end

			local actionObject = Modules.input.actions["pick up"]
			local keybind = actionObject and actionObject.bindedTo or "F"
			module.closestItem = getClosestItem()
			if not currentItemHoverData then
				if module.closestItem then
					if pickupInteractionPromptTable.item ~= module.closestItem then
						if not pickupInteractionPromptTable.itemBaseData or pickupInteractionPromptTable.itemBaseData.physItemName ~= module.closestItem.Name then
							local itemBaseData = getItemBaseDataFromItemsPart(module.closestItem)
							if itemBaseData then
								pickupInteractionPromptTable.itemBaseData = itemBaseData
							end
						end

						pickupInteractionPromptTable.item = module.closestItem

						pickupInteractionPromptTable.prompt:updateTextFragments(false,
							{text = "Pick up"},
							{text = pickupInteractionPromptTable.itemBaseData and pickupInteractionPromptTable.itemBaseData.name or module.closestItem.Name; textColor3 = Color3.fromRGB(143, 120, 255)}
						)

						if keyDown and pickupInteractionPromptTable.item then
							processPickupKeyDown("pickup")
						end
					end
				else
					if not pickupInteractionPromptTable.prompt.isHiding then
						pickupInteractionPromptTable.prompt:hide()

						pickupInteractionPromptTable.item 			= nil
						pickupInteractionPromptTable.itemBaseData 	= nil
					end
				end
			else
				if pickupInteractionPromptTable.item ~= currentItemHoverData.item then
					pickupInteractionPromptTable.item 			= currentItemHoverData.item
					pickupInteractionPromptTable.itemBaseData 	= currentItemHoverData.itemBaseData

					pickupInteractionPromptTable.prompt:updateTextFragments(false,
						{text = "Pick up"},
						{text = pickupInteractionPromptTable.itemBaseData and pickupInteractionPromptTable.itemBaseData.name or module.closestItem.Name; textColor3 = Color3.fromRGB(143, 120, 255)}
					)


					if keyDown and pickupInteractionPromptTable.item then
						processPickupKeyDown("pickup")
					end
				end
			end
		end
	end

	spawn(main)

end


--


return module
