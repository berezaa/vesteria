-- manages items, duh
-- author: Polymorphic
-- editor: berezaa

local module = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
local modules = require(replicatedStorage.modules)
local network = modules.load("network")
local placeSetup = modules.load("placeSetup")
local physics = modules.load("physics")
local utilities = modules.load("utilities")
local configuration = modules.load("configuration")
local economy = modules.load("economy")

local itemLookupContainer = replicatedStorage.itemData

local itemLookup = require(itemLookupContainer)
local monsterLookup = require(replicatedStorage.monsterLookup)
local itemsFolder = placeSetup.getPlaceFolder("items")

local assetFolder = replicatedStorage:FindFirstChild("assets")
local itemManfiests = assetFolder.items
local particleStorage = assetFolder.particles
local entityStorage = assetFolder.entities

local function getItemBaseDataFromItemsPart(itemPart)
	local itemDataModule = itemLookupContainer:FindFirstChild(itemPart.Name)
	if itemDataModule then
		return require(itemDataModule)
	end
end

local IGNORE_LIST = {placeSetup.getPlaceFoldersFolder()}

network:create("itemsRecieved", "RemoteEvent")

-- todo: make important settings like below in a module to be easily sync'd between server and client scripts
local _SERVER_ACQUISITION_RANGE = 10
local itemPickupDebounce 		= {}

local function processPlayerPickUpItem(player, itemPart, isPickUpFromPet)
	if not itemPart or itemPart.Parent ~= itemsFolder then
		return false, "item does not exist"
	elseif itemPickupDebounce[itemPart] then
		return false, "attempt to pick-up an item someone else is picking up"
	elseif not itemPart:FindFirstChild("metadata") then
		return false, "attempt to pick-up an invalid item"
	elseif not utilities.playerCanPickUpItem(player, itemPart, isPickUpFromPet) then
		return false, "can't pick-up this item"
	end

	local itemBaseData = getItemBaseDataFromItemsPart(itemPart)
	if itemBaseData then
		itemPickupDebounce[itemPart] = true

		local metadata

		local success, resultMessage, value
		if not itemBaseData.autoConsume then
			-- request the inventory service to add this item into the inventory
			local success2, returnValue = utilities.safeJSONDecode(itemPart.metadata.Value)

			if success2 then
				metadata = returnValue
				success, resultMessage = network:invoke("tradeItemsBetweenPlayerAndNPC",  player, {}, 0, {returnValue}, 0, nil, {overrideItemsRecieved = true})
			else
				metadata = itemBaseData
				success, resultMessage = false, "failed to decode metadata"
			end
		else
			-- added physical item part to function for gold
			metadata = itemBaseData
			success, resultMessage, value = itemBaseData.activationEffect(player, itemPart)
		end

		-- let the client know if they picked it up
		network:fireClient("notifyPlayerPickUpItem", player, metadata, success, value, nil, resultMessage)

		if success then
			-- fire quest trigger occured
			network:fire("questTriggerOccurred", player, "item-collected", {id = itemBaseData.id; amount = 1})

			-- remove player from owners
			if itemPart:FindFirstChild("owners") then
				if itemPart.owners:FindFirstChild(tostring(player.userId)) then
					itemPart.owners[tostring(player.userId)]:Destroy()
				else
					for i, ownerTag in pairs(itemPart.owners:GetChildren()) do
						if ownerTag.Value == player then
							ownerTag:Destroy()
						end
					end
				end
			end

			if not itemPart:FindFirstChild("pickupBlacklist") then
				local pickupBlacklist 	= Instance.new("Folder")
				pickupBlacklist.Name 	= "pickupBlacklist"
				pickupBlacklist.Parent 	= itemPart
			end

			local blacklistTag 	= Instance.new("BoolValue")
			blacklistTag.Name 	= tostring(player.userId)
			blacklistTag.Value 	= true
			blacklistTag.Parent = itemPart.pickupBlacklist

			-- destroy the itemPart on the server, can no longer be picked up
			if itemPart:FindFirstChild("singleOwnerPickup") or not itemPart:FindFirstChild("owners") or #itemPart.owners:GetChildren() == 0 then
				itemPart:Destroy()
			elseif itemPart:FindFirstChild("created") and (os.time() - itemPart.created.Value) >= configuration.getConfigurationValue("timeForAnyonePickupItem") then
				itemPart:Destroy()
			end
		end

		-- free the item up
		itemPickupDebounce[itemPart] = nil

		return success, resultMessage, value
	end

end

local function playerRequest_pickUpItem(player, itemPart)

	if player.Character == nil or player.Character.PrimaryPart == nil or player.Character.PrimaryPart:FindFirstChild("state") == nil or player.Character.PrimaryPart.state.Value == "dead" then
		return false, "Invalid player or dead"
	end

	if not itemPart or not utilities.playerCanPickUpItem(player, itemPart) then
		return false, "Unable to pick up"
	end

	if player.Character and player.Character.PrimaryPart and itemPart and typeof(itemPart) == "Instance" and itemPart:IsDescendantOf(itemsFolder) then
		if utilities.magnitude(player.Character.PrimaryPart.Position - itemPart.Position) <= _SERVER_ACQUISITION_RANGE * 1.1 then
			return processPlayerPickUpItem(player, itemPart, false)
		else
			return false, "Too far away"
		end
	end

	return false, "Invalid"
end

local function prepareManifest(physItem)

	if physItem:IsA("BasePart") then
		-- damiens weld thingie
		for _, Child in pairs(physItem:GetChildren()) do
			if Child:IsA("BasePart") then
		        local motor6d = Instance.new("Motor6D")
		        motor6d.Part0 = physItem
		        motor6d.Part1 = Child
		        motor6d.C0 = CFrame.new()
		        motor6d.C1 = Child.CFrame:toObjectSpace(physItem.CFrame)
				motor6d.Parent = Child
				Child.CanCollide = false
				Child.Anchored = false
			end
		end
	elseif physItem:IsA("Model") then
		local primaryPartForPhysItem = physItem.PrimaryPart

		-- transform into the structure we know and love!
		for _, child in pairs(physItem:GetChildren()) do
			if child:IsA("BasePart") and child ~= primaryPartForPhysItem then
		        local motor6d = Instance.new("Motor6D")
		        motor6d.Part0 = primaryPartForPhysItem
		        motor6d.Part1 = child
		        motor6d.C0 = CFrame.new()
		        motor6d.C1 = child.CFrame:toObjectSpace(primaryPartForPhysItem.CFrame)
				motor6d.Parent = child

				child.CanCollide = false
				child.Anchored = false
				child.Parent = primaryPartForPhysItem
			end
		end

		physItem = primaryPartForPhysItem
	end

	return physItem
end

local function generateItemManifest(itemDropData, physItem)
	local itemBaseData = itemLookup[itemDropData.id]

	local itemAsset = itemManfiests:FindFirstChild(itemBaseData.module.Name)
	assert(itemAsset, "Item manifest not found for " .. itemBaseData.module.Name)

	if physItem then
		physItem = prepareManifest(physItem)
	else
		if itemBaseData.equipmentType == "arrow" then
			-- arrows get special treatment
			if itemDropData.stacks == 1 then
				physItem = itemAsset.manifest:Clone()
				physItem.CanCollide = false
				physItem.Anchored = false
			else
				-- todo: how to do multiple quivers?
				physItem = assetFolder.entities.ArrowUpperTorso2.quiver:Clone()
				physItem.Anchored = false
				physItem.CanCollide = false

				local arrows = itemDropData.stacks or 0
				local arrowParts = math.clamp(math.floor(arrows / configuration.getConfigurationValue("arrowsPerArrowPartVisualization")) + 1, 0, configuration.getConfigurationValue("maxArrowPartsVisualization"))
				local degPerRot = 360 / configuration.getConfigurationValue("maxArrowPartsVisualization")
				for ai = 1, arrowParts do
					local arrow = itemAsset.manifest:Clone()
					arrow.CanCollide = false
					arrow.Anchored = false
					arrow.Parent = physItem

					local xRan, yRan = math.random() * 2 - 1, math.random() * 2 - 1

					local arrowWeld = Instance.new("Motor6D", physItem)
					arrowWeld.Name = "projectionWeld"
					arrowWeld.Part0 = physItem
					arrowWeld.Part1 = arrow
					arrowWeld.C0 = physItem.Attachment.CFrame
					arrowWeld.C1 = CFrame.Angles(xRan * math.rad(15), 0, yRan * math.rad(15))-- * CFrame.Angles(0.25 * math.rad(degPerRot * ai), 0, 0.25 * math.rad(degPerRot * ai))
				end
			end
		elseif itemAsset:FindFirstChild("manifest", true) then
			physItem = itemAsset:FindFirstChild("manifest", true):Clone()
			physItem = prepareManifest(physItem)
		elseif itemAsset:FindFirstChild("container") then
			local primaryPart = itemAsset.container.PrimaryPart

			physItem = primaryPart:Clone()
			physItem:ClearAllChildren()

			for _, vv in pairs(primaryPart:GetChildren()) do
				if vv:IsA("BasePart") then
					local part = vv:Clone()

					local motor6d = Instance.new("Motor6D")
				        motor6d.Part0 = part
				        motor6d.Part1 = physItem
				        motor6d.C0 = CFrame.new()
				        motor6d.C1 = primaryPart.CFrame:toObjectSpace(vv.CFrame)
						motor6d.Parent = part

					part.Anchored = false
					part.CanCollide = false

					part.Parent = physItem
				end
			end

			for _, v in pairs(itemAsset.container:GetChildren()) do
				if v ~= primaryPart then
					local part = v:Clone()

					local motor6d = Instance.new("Motor6D")
				        motor6d.Part0 = physItem
				        motor6d.Part1 = part
				        motor6d.C0 = CFrame.new()
				        motor6d.C1 = v.CFrame:toObjectSpace(primaryPart.CFrame)
						motor6d.Parent = physItem

					part.Anchored = false
					part.CanCollide = false

					for _, vv in pairs(part:GetChildren()) do
						if vv:IsA("BasePart") then
					        local motor6d = Instance.new("Motor6D")
					        motor6d.Part0 = part
					        motor6d.Part1 = vv
					        motor6d.C0 = CFrame.new()
					        motor6d.C1 = vv.CFrame:toObjectSpace(part.CFrame)
							motor6d.Parent = vv

							vv.CanCollide = false
							vv.Anchored = false
						end
					end

					part.Parent = physItem
				end
			end
		else
			error("attempt to drop item with invalid drop format")
		end
	end

	physItem.Name = itemBaseData.module.Name
	physItem.Anchored = false
	physItem.CanCollide = false

	if itemDropData.id == 1 then
		if itemDropData.value >= 1000 then
			physItem.Color = Color3.fromRGB(160,160,160)
		end
	end

	local itemMask = assetFolder.entities.itemMask:Clone()

	itemMask.Name = "HumanoidRootPart"
	itemMask.RootPriority = 100
	itemMask.CustomPhysicalProperties = PhysicalProperties.new(5, 1, 0.7)

	itemMask.Parent = physItem
	itemMask.Size = Vector3.new(physItem.Size.X * 1.1, physItem.Size.Y * 1.1, physItem.Size.Z * 1.1)

	local weld = Instance.new("Motor6D")
	weld.Part0 = physItem
	weld.Part1 = itemMask
	weld.Parent = physItem
	weld.Name = "MASK_MOTOR"

	local dye = itemDropData.dye

	if dye then
		physItem.Color = Color3.new(physItem.Color.r * dye.r/255, physItem.Color.g * dye.g/255, physItem.Color.b * dye.b/255)
		for _, v in pairs(physItem:GetDescendants()) do
			if v:IsA("BasePart") then
				if dye then
					v.Color = Color3.new(v.Color.r * dye.r/255, v.Color.g * dye.g/255, v.Color.b * dye.b/255)
				end
			end
		end
	end

	local size = (math.sqrt(physItem.Size.X * physItem.Size.Y) + math.sqrt(physItem.Size.Z, physItem.Size.Y))

	if not itemDropData.isNotDropping then
		local itemInfo = itemBaseData
		if (itemInfo.rarity and itemInfo.rarity == "Rare") or (itemInfo.category and itemInfo.category == "equipment") then
			itemInfo.soulboundDrop = true
			--[[
			local attach = script.rareItem.Attachment:Clone()
			attach.Parent = physItem
			]]
			for _, child in pairs(entityStorage.rareItem:GetChildren()) do
				child:Clone().Parent = physItem
			end
		else
			local rays = particleStorage.Rays:Clone()
			local attach = Instance.new("Attachment")
			attach.Axis = Vector3.new(1,0,0)
			attach.SecondaryAxis = Vector3.new(0,1,0)
			rays.Parent = attach
			attach.Parent = physItem
			rays.Size = NumberSequence.new(size * 1.3)

			local sparkles = particleStorage.Sparkles:Clone()
			sparkles.Parent = attach
		end

		local light = Instance.new("PointLight")
		light.Brightness = 1.5
		light.Range = 8
		light.Parent = itemMask

		local attachmentTarget

		if physItem:IsA("BasePart") then
			attachmentTarget = physItem
		elseif physItem:IsA("Model") and (physItem.PrimaryPart or physItem:FindFirstChild("HumanoidRootPart")) then
			local primaryPart = physItem.PrimaryPart or physItem:FindFirstChild("HumanoidRootPart")
			if primaryPart then
				attachmentTarget = primaryPart
			end
		end

		local topAttachment = Instance.new("Attachment", physItem)
			topAttachment.Position = Vector3.new(0, itemMask.Size.Y / 2, 0)

		local bottomAttachment = Instance.new("Attachment", physItem)
			bottomAttachment.Position = Vector3.new(0, -itemMask.Size.Y / 2, 0)

		local trail = assetFolder.misc.Trail:Clone()
		trail.Attachment0 = topAttachment
		trail.Attachment1 = bottomAttachment
		trail.Enabled = true
		trail.Parent = physItem

	end

	physItem.Anchored = false

	return physItem
end

local rand = Random.new(os.time())

-- todo: special effects!
local httpService = game:GetService("HttpService")
local function spawnItemOnGround(lootDrop, dropPosition, owners, physItem)
	if itemLookup[lootDrop.id] then
		-- todo: refactor

		physItem = generateItemManifest(lootDrop, physItem)

		local hitPart, hitPosition
		local tries = 0

		local success, val = utilities.safeJSONEncode(lootDrop or {})

		local metadataTag 	= Instance.new("StringValue", physItem)
		metadataTag.Name 	= "metadata"
		metadataTag.Value 	= val

		physics:setWholeCollisionGroup(physItem, "items")

		while not hitPart and tries < 5 do
			tries = tries + 1

			local ray = Ray.new(
				(CFrame.new(dropPosition)
				* CFrame.Angles(0, math.rad(math.random(1, 360)), 0)
				* CFrame.Angles(0, 0, math.rad(20))
				* CFrame.new(0, 0, -math.random() * 3)).p,
				Vector3.new(0, -5, 0)
			)

			hitPart, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, IGNORE_LIST)
		end

		if not hitPosition then
			hitPosition = dropPosition
		end

		physItem.CFrame 					= CFrame.new(hitPosition) + Vector3.new(0,0.5,0)
		physItem.HumanoidRootPart.CFrame 	= CFrame.new(hitPosition) + Vector3.new(0,0.5,0)

		if owners and #owners > 0 then
			local ownersFolder = Instance.new("Folder")
			ownersFolder.Name = "owners"

			for _, owner in pairs(owners) do
				if owner and owner.Parent == game.Players then
					local ownerTag = Instance.new("ObjectValue")
					ownerTag.Name = tostring(owner.userId)
					ownerTag.Value = owner
					ownerTag.Parent = ownersFolder
				end
			end

			ownersFolder.Parent = physItem
		end

		local creationTimeTag 	= Instance.new("IntValue")
		creationTimeTag.Name 	= "created"
		creationTimeTag.Value 	= os.time()
		creationTimeTag.Parent 	= physItem

		if itemLookup[lootDrop.id].petsIgnore then
			local petsIgnoreTag 	= Instance.new("BoolValue")
			petsIgnoreTag.Name 		= "petsIgnore"
			petsIgnoreTag.Value 	= true
			petsIgnoreTag.Parent 	= physItem
		end

		-- 4 minute despawn
		game.Debris:AddItem(physItem, 4 * 60)

		-- apply value to numbered items like gold
		if lootDrop.value then
			local valueTag = Instance.new("IntValue")
			valueTag.Name = "itemValue"
			valueTag.Value = lootDrop.value
			valueTag.Parent = physItem
		end

		if lootDrop.source then
			local sourceTag = Instance.new("StringValue")
			sourceTag.Name = "itemSource"
			sourceTag.Value = lootDrop.source
			sourceTag.Parent = physItem
		end

		physItem.Parent = itemsFolder

		return physItem
	end
end

network:create("spawnItemOnGround", "BindableFunction", "OnInvoke", spawnItemOnGround)

local CONSUMABLE_COOLDOWN_TIME 		= 1
local playerConsumeCooldownTable 	= {}

local function onActivateItemRequestReceived(player, category, inventorySlotPosition, _itemId, playerInput)
	local playerData = network:invoke("getPlayerData", player)
	local inventorySlotData = network:invoke(
		"getPlayerInventorySlotDataByInventorySlotPosition",
		player,
		category,
		inventorySlotPosition
	)
	if playerData and inventorySlotData and (not _itemId or inventorySlotData.id == _itemId) then
		local itemBaseData = itemLookup[inventorySlotData.id]
		if itemBaseData.category == "consumable" or itemBaseData.activationEffect ~= nil then
			if network:invoke("getIsManifestStunned", player.Character and player.Character.PrimaryPart) then
				return false, "User is stunned."
			end
			local stats = playerData.nonSerializeData.statistics_final
			local cooldown = CONSUMABLE_COOLDOWN_TIME * math.clamp(1 - stats.consumeTimeReduction, 0, 1)
			if tick() - (playerConsumeCooldownTable[player] or 0) >= cooldown then
				playerConsumeCooldownTable[player] = tick()

				-- item is consumable -- get rid of a stack of the item then activate it
				local worked, status = itemBaseData.activationEffect(player, playerInput)
				if worked then

					local source = "item:"..itemBaseData.module.Name

					if itemBaseData.category ~= "miscellaneous" then
						network:invoke(
							"tradeItemsBetweenPlayerAndNPC",
							player,
							{{id = inventorySlotData.id; position = inventorySlotData.position; stacks = 1}},
							0,
							{},
							0,
							source
						)
					end

				else
					network:fireClient(
						"signal_alertChatMessage",
						player,
						{
							Text = "Failed to use item: "..status or "no error.";
							Font = Enum.Font.SourceSans;
							Color = Color3.fromRGB(216, 161, 107)
						}
					)
				end

				return worked, status
			end

			return false, "consume on cooldown"
		end

		return false, "Item is not activatable."
	end

	return false, "Failed to activate item."
end

-- todo: sanity check to make sure player is near shop!
local function onPlayerRequest_buyItemFromShop(player, inventorySlotData, stacksBeingRequested, inventoryModule)
	if not inventoryModule then warn("Failed to supply inventoryModule") return false end
	if not inventoryModule.Parent:IsA("BasePart") then warn("inventoryModule.Parent is not BasePart") return false end

	local playerData = network:invoke("getPlayerData", player)
	if not playerData then return false end
	-- validate the inventory of the shopkeeper to what is trying to be purchased

	local costInfo = inventorySlotData.costInfo

	local confirmedItemInfo

	local itemCost

	local shopkeeperInventory = require(inventoryModule) do
		local isMatched = false

		for _, shopkeeperItemInfo in pairs(shopkeeperInventory) do

			local v
			local shopCostData
			if typeof(shopkeeperItemInfo) == "string" then
				v = shopkeeperItemInfo
			elseif typeof(shopkeeperItemInfo) == "table" then
				v = shopkeeperItemInfo.itemName
				shopCostData = shopkeeperItemInfo
			end

			if itemLookup[v] == itemLookup[inventorySlotData.id] then
				if costInfo and costInfo.costType then
					if shopCostData and costInfo.costType == shopCostData.costInfo.costType then
						itemCost = shopkeeperItemInfo.cost
						confirmedItemInfo = shopkeeperItemInfo
						isMatched = true
					end
				elseif not (shopCostData and shopCostData.costInfo and shopCostData.costInfo.costType) then

					isMatched = true
				end

			end
		end

		if not isMatched then
			return false, "could not find item in shop inventory!"
		end
	end

	if typeof(inventorySlotData) ~= "table" or not inventorySlotData.id then return false end

	local itemBaseData = itemLookup[inventorySlotData.id]
	local clamp_stacksBeingRequested = math.clamp(math.floor(stacksBeingRequested or 1), 1, (itemBaseData.stackSize or 99) * 20)

	if player and inventorySlotData and typeof(inventorySlotData) == "table" and stacksBeingRequested and type(stacksBeingRequested) == "number" and stacksBeingRequested >= 1 and stacksBeingRequested == clamp_stacksBeingRequested then
		stacksBeingRequested = clamp_stacksBeingRequested

		-- kill switch in case we decide we need one
		if not itemBaseData or itemBaseData.cantBuy then
			return false
		end

		-- edit: jesus don't put "stacks" in the amount removed.
		local source = "shop:"..itemBaseData.module.Name

		local success, reason

		local confirmedCostInfo

		local itemBeingBought = {id = inventorySlotData.id}

		if confirmedItemInfo then
			confirmedCostInfo = confirmedItemInfo.costInfo
			if confirmedItemInfo.attributes then
				for attribute, value in pairs(confirmedItemInfo.attributes) do
					if not itemBeingBought[attribute] then
						itemBeingBought[attribute] = value
					end
				end
			end
		end

		if confirmedItemInfo and confirmedCostInfo and confirmedCostInfo.costType and itemCost then
			if confirmedCostInfo.costType == "item" then
				local stacksBeingBought = math.clamp(stacksBeingRequested, 1, itemBaseData.stackSize or 99)
				itemBeingBought.stacks 	= stacksBeingBought

				success, reason = network:invoke(
					"tradeItemsBetweenPlayerAndNPC",
					player,
					{{id = confirmedCostInfo.costId; stacks = itemCost * stacksBeingRequested}},
					0,
					{itemBeingBought},
					0,
					source
				)
				return success, reason
			elseif confirmedCostInfo.costType == "ethyr" then
				local globalData 		= playerData.globalData
				local stacksBeingBought = math.clamp(stacksBeingRequested, 1, itemBaseData.stackSize or 99)

				if globalData.ethyr and globalData.ethyr >= itemCost * stacksBeingBought then
					itemBeingBought.stacks = stacksBeingBought
					success, reason = network:invoke("tradeItemsBetweenPlayerAndNPC",  player, {}, 0, {itemBeingBought}, 0, source)
					if success then
						globalData.ethyr = globalData.ethyr - itemCost * stacksBeingRequested
						playerData.nonSerializeData.setPlayerData("globalData", globalData)
						spawn(function()
							network:invoke("reportCurrency", player, "ethyr", - itemCost * stacksBeingRequested, source)
						end)
					end
				end
				return success, reason
			end
		end

		local coinCostReduction = 1 - math.clamp(playerData.nonSerializeData.statistics_final.merchantCostReduction, 0, 1)

		itemBeingBought.stacks = stacksBeingRequested
		success, reason = network:invoke(
			"tradeItemsBetweenPlayerAndNPC",
			player,
			{},
			math.clamp((itemCost or itemBaseData.buyValue or 1) * coinCostReduction, 1, math.huge) * stacksBeingRequested,
			{itemBeingBought},
			0,
			source
		)


		return success, reason
	end

	return false, "Failed to purchase item."
end

-- only will sell up to the stack size of an item
local function onPlayerRequest_sellItem(player, unsafeInventorySlotData, stacksToRemove)
	if not player then return false end

	local playerData = network:invoke("getPlayerData", player)
	if not playerData then return false end

	local inventorySlotData = nil
	for _, slotData in pairs(playerData.inventory) do
		if
			slotData.position == unsafeInventorySlotData.position and
			slotData.id == unsafeInventorySlotData.id
		then
			inventorySlotData = slotData
			break
		end
	end

	if inventorySlotData and typeof(inventorySlotData) == "table" and stacksToRemove == stacksToRemove and stacksToRemove and type(stacksToRemove) == "number" then
		stacksToRemove = math.floor(math.clamp(stacksToRemove or 1, 1, 999))

		local itemBaseData 	= itemLookup[inventorySlotData.id]

		-- kill switch in case we decide we need one
		if not itemBaseData or itemBaseData.cantSell then
			return false
		elseif itemBaseData and not itemBaseData.canStack then
			stacksToRemove = 1
		end

		-- edit: jesus don't put "stacks" in the amount removed.
		local source = "shop:"..itemBaseData.module.Name
		local sellValue = economy.getSellValue(itemBaseData, inventorySlotData)
		local success = network:invoke(
			"tradeItemsBetweenPlayerAndNPC",
			player,
			{{
				id = inventorySlotData.id;
				position = inventorySlotData.position;
				stacks = stacksToRemove
			}},
			0,
			{},
			(sellValue) * stacksToRemove,
			source
		)

		if success and inventorySlotData.id == 138  then
			-- xero's tablet. fail treasure hunt quest
			network:fire("playerFailedQuest", player, 10)
		end
		return success
	end

	return false, "Failed to sell item."
end

local function applyPotionStatusEffectToEntityManifest_server(entityManifest, healthToRestore, manaToRestore, sourceType, sourceId)
	if healthToRestore and healthToRestore > 0 then
		utilities.healEntity(entityManifest, entityManifest, healthToRestore)
		utilities.playSound("item_heal", entityManifest)
	end
	if manaToRestore and manaToRestore > 0 then
		entityManifest.mana.Value = math.min(entityManifest.mana.Value + manaToRestore, entityManifest.maxMana.Value)
		utilities.playSound("item_mana", entityManifest)
	end

	return true
end

network:create("applyPotionStatusEffectToEntityManifest_server", "BindableFunction", "OnInvoke", applyPotionStatusEffectToEntityManifest_server)

local function onPlayerAdded(player)
	playerConsumeCooldownTable[player] = 0
end

local function onPlayerRemoving(player)
	playerConsumeCooldownTable[player] = nil
end


local function playerRequest_dropItem(player, inventorySlotData)
	local playerData = network:invoke("getPlayerData", player)

	if player:FindFirstChild("DataSaveFailed") then
		network:fireClient("alertPlayerNotification", player, {
			text = "Cannot drop items during DataStore outage.";
			textColor3 = Color3.fromRGB(255, 57, 60)
		})
		return false, "This feature is temporarily disabled"
	end

	if player:FindFirstChild("DataLoaded") == nil then
		return false
	end

	if not configuration.getConfigurationValue("isTradingEnabled", player) then
		return false
	end

	if playerData and player and player.Character and player.Character.PrimaryPart then
		local isInInventory, pos = false, nil
		for i, trueInventorySlotData in pairs(playerData.inventory) do
			if trueInventorySlotData.id == inventorySlotData.id and trueInventorySlotData.position == inventorySlotData.position then
				isInInventory = true
				pos = i
			end
		end

		if isInInventory then
			local trueMetadata = table.remove(playerData.inventory, pos)

			local itemBaseData = itemLookup[trueMetadata.id]

			local drop
			if not (trueMetadata.soulbound or itemBaseData.soulbound) then
				drop = network:invoke(
					"spawnItemOnGround",
					trueMetadata,
					player.Character.PrimaryPart.Position + player.Character.PrimaryPart.CFrame.lookVector * 5,
					nil
				)
			end

			if drop then
				local playerDropSource = Instance.new("NumberValue")
				playerDropSource.Name = "playerDropSource"
				playerDropSource.Value = player.userId
				playerDropSource.Parent = drop
			else
				table.insert(playerData.inventory, trueMetadata)
			end

			playerData.nonSerializeData.setPlayerData("inventory", playerData.inventory)
		end
	end

	return false, "invalid player data"
end

local function main()
	game.Players.PlayerAdded:connect(onPlayerAdded)
	for _, player in pairs(game.Players:GetPlayers()) do
		onPlayerAdded(player)
	end
	game.Players.PlayerRemoving:connect(onPlayerRemoving)

	network:create("generateItemManifest_server", "BindableFunction", "OnInvoke", generateItemManifest)

	network:create("activateItemRequest", "RemoteFunction", "OnServerInvoke", onActivateItemRequestReceived)
	network:create("playerRequest_activateItem", "RemoteFunction", "OnServerInvoke", onActivateItemRequestReceived)

	-- buy from or sell to shop
	network:create("playerRequest_buyItemFromShop", "RemoteFunction", "OnServerInvoke", onPlayerRequest_buyItemFromShop)
	network:create("playerRequest_sellItemToShop", "RemoteFunction", "OnServerInvoke", onPlayerRequest_sellItem)

	network:create("pickUpItemRequest", "RemoteFunction", "OnServerInvoke", playerRequest_pickUpItem)
	network:create("playerRequest_pickUpItem", "RemoteFunction", "OnServerInvoke", playerRequest_pickUpItem)

	network:create("pickUpItemForPlayer_server", "BindableFunction", "OnInvoke", processPlayerPickUpItem)

	network:create("playerRequest_dropItem", "RemoteFunction", "OnServerInvoke", playerRequest_dropItem)
	network:create("notifyPlayerPickUpItem", "RemoteEvent")

	-- todo: snip snip
	network:create("onMonsterDeath", "BindableEvent", "Event", function() end)
end

main()

-- Offshoot from player manager, needs to be integrated

return module