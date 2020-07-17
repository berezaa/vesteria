-- this will act as the medium between all damaging abilities/weapons
-- and the server, everything is routed here then sent out by the server
-- Author: Polymorphic

local assetFolder = script.Parent.Parent:WaitForChild("assets")

local module = {}

local player = game.Players.LocalPlayer

local userInputService = game:GetService("UserInputService")
local collectionService = game:GetService("CollectionService")
local httpService = game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local modules = require(replicatedStorage.modules)
local network = modules.load("network")
local utilities = modules.load("utilities")
local placeSetup = modules.load("placeSetup")
local mapping = modules.load("mapping")
local detection = modules.load("detection")
local damage = modules.load("damage")
local projectile = modules.load("projectile")
local client_utilities = modules.load("client_utilities")
local events = modules.load("events")
local tween = modules.load("tween")
local effects = modules.load("effects")
local ability_utilities	= modules.load("ability_utilities")

local itemData = require(replicatedStorage.itemData)
local abilityLookup = require(replicatedStorage.abilityLookup)

local ResourceController = require(script.Parent.Resources)

local entityRenderCollectionFolder = placeSetup.awaitPlaceFolder("entityRenderCollection")
local entityManifestCollectionFolder = placeSetup.awaitPlaceFolder("entityManifestCollection")
local itemsFolder = placeSetup.awaitPlaceFolder("items")
local entitiesFolder = placeSetup.awaitPlaceFolder("entities")
local assetsFolder = replicatedStorage:WaitForChild("assetsFolder")

local currentlyEquipped
local currentWeaponManifest

local clientCharacterContainer

local canPlayerBasicAttack = true
local isPlayerHoldingDownBasicAttack = false
local isPlayerCastingAbility = false

local function onSetCanPlayerBasicAttack(value)
	canPlayerBasicAttack = value

	if not canPlayerBasicAttack and isPlayerHoldingDownBasicAttack then
		if currentlyEquipped and currentlyEquipped.release then
			isPlayerHoldingDownBasicAttack = false
			currentlyEquipped:release()
		end
	end
end

local function getPlayerEquipmentSlotDataForWeapon()
	local equipment = network:invoke("getCacheValueByNameTag", "equipment")
	if equipment then
		for i, equipmentSlotData in pairs(equipment) do
			if equipmentSlotData.position == 1 then
				return equipmentSlotData
			end
		end
	end

	return nil
end

local function equipmentMeetsAbilityRequirement(equipmentData, abilityRequirement)
	local equipmentType = equipmentData.equipmentType

	if equipmentType == abilityRequirement then
		return true
	end

	if abilityRequirement == "sword" and equipmentType == "greatsword" then
		return true
	end

	local isBowDaggerAbility = (abilityRequirement == "dagger") or (abilityRequirement == "bow")
	local isBowDaggerEquipped = (equipmentType == "dagger") or (equipmentType == "bow")
	if isBowDaggerAbility and isBowDaggerEquipped then
		local renderCharacterContainer = network:invoke("getMyClientCharacterContainer")
		if not  renderCharacterContainer then return false end

		local equipment = network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
		if not equipment then return false end

		local offhand = equipment["11"]
		if (not offhand) or (not offhand.baseData) then return false end

		if offhand.baseData.equipmentType == abilityRequirement then
			network:invokeServer("playerRequest_swapWeapons_yielding")
			return true
		end
	end

	return false
end

local function getServerHitboxFromClientHitbox(clientHitbox)
	if clientHitbox.Parent:FindFirstChild("clientHitboxToServerHitboxReference") then
		return clientHitbox.Parent.clientHitboxToServerHitboxReference.Value
	end
end

local function getClientHitboxFromServerHitbox(serverHitbox)
	for i, clientMonsterContainer in pairs(entityRenderCollectionFolder:GetChildren()) do
		if clientMonsterContainer:FindFirstChild("clientHitboxToServerHitboxReference") and clientMonsterContainer.clientHitboxToServerHitboxReference.Value == serverHitbox then
			return clientMonsterContainer.PrimaryPart
		end
	end
end

-- sourceType = "ability", "item"
local function handleRequestEntityDamageRequest(serverHitbox, damagePosition, sourceType, sourceId, sourceTag, GUID)
	-- todo: do client-side sanity checks

	-- check if is descendant
	if damage.canPlayerDamageTarget(player, serverHitbox) then


		network:fire("monsterDamagedAtPosition", damagePosition)

		network:fireServer("playerRequest_damageEntity", serverHitbox, damagePosition, sourceType, sourceId, sourceTag, GUID)
	end
end

local curWeaponType
local function int__equipWeapon(weaponData)
	local itemBaseData = itemData[weaponData.id]
	if itemBaseData and itemBaseData.isEquippable and itemBaseData.equipmentType and itemBaseData.equipmentSlot == mapping.equipmentPosition.weapon then
		if not currentlyEquipped and assetFolder.damageInterfaces:FindFirstChild(itemBaseData.equipmentType) then
			curWeaponType = itemBaseData.equipmentType

			-- check for dual swords and sword and shield
			if clientCharacterContainer and clientCharacterContainer:FindFirstChild("entity") then
				local currentEquipment = network:invoke("getCurrentlyEquippedForRenderCharacter", clientCharacterContainer.entity)

				if currentEquipment["1"] and currentEquipment["11"] then
					if currentEquipment["1"].baseData.equipmentType == "sword" and currentEquipment["11"].baseData.equipmentType == "sword" then
						curWeaponType = "dual"
					elseif currentEquipment["1"].baseData.equipmentType == "sword" and currentEquipment["11"].baseData.equipmentType == "shield" then
						curWeaponType = "swordAndShield"
					end
				end
			end
		end

		if curWeaponType then
			currentlyEquipped = require(assetFolder.damageInterfaces[curWeaponType])
			currentlyEquipped:equip()
		end
	end
end

local function int__unequipWeapon()
	if currentlyEquipped then
		currentlyEquipped:unequip()
		currentlyEquipped = nil
		curWeaponType = nil
	end
end

local function int_checkIfEquipWeaponFromEquipment(equipment)
	if equipment then
		local weaponEquipmentData
		for i, equipmentData in pairs(equipment) do
			if equipmentData.position == mapping.equipmentPosition.weapon then
				weaponEquipmentData = equipmentData
			end
		end

		if weaponEquipmentData then
			if currentlyEquipped then
				-- unequip weapon first, then equip the other weapon
				int__unequipWeapon()
			end

			int__equipWeapon(weaponEquipmentData)
		else
			if currentlyEquipped then
				int__unequipWeapon()
			end
		end
	else
	end
end

local function onPropogationRequestToSelf(propogationNameTag, propogationValue)
	if propogationNameTag == "equipment" then
		int_checkIfEquipWeaponFromEquipment(propogationValue)
	end
end

local function onMyClientCharacterWeaponChanged(weaponManifest)
	-- set the weapon stuff
	currentWeaponManifest = weaponManifest

	if weaponManifest:IsA("BasePart") then
		weaponManifest.Touched:Connect(function()
			-- do nothing just have a touch interest I guess
		end)
	end

--	if currentWeaponManifest then
--		local equipmentSlotDataCollection = network:invoke("getCacheValueByNameTag", "equipment")
--
--		if equipmentSlotDataCollection then
--			int_checkIfEquipWeaponFromEquipment(equipmentSlotDataCollection)
--		end
--	end
end

local cooldownLookup = {}
local displayLookup = {}
local castingAnimation

local function onMyClientCharacterContainerChanged(newMyClientCharacterContainer)
	clientCharacterContainer = newMyClientCharacterContainer
	-- wait for humanoid
	local animationController = newMyClientCharacterContainer.entity:WaitForChild("AnimationController")
	while not animationController:IsDescendantOf(workspace) do wait() end

	if currentlyEquipped then
		currentlyEquipped:equip()
	end

	castingAnimation = animationController:LoadAnimation(assetsFolder.abilityAnimations.rock_throw_upper_loop)
end

local function onCharacterAdded(character)
	local equipment = network:invoke("getCacheValueByNameTag", "equipment")

	int_checkIfEquipWeaponFromEquipment(equipment)
end

local weaponDelays = {dual = .15; dagger = .15; sword = .23; staff = .23; --[[bow handles its own attack delay]] bow = 0}
local attackOnCoolDown

local function onInputBegan(input, absorbed)
	if canPlayerBasicAttack and currentlyEquipped and not absorbed and not network:invoke("getIsCurrentlyConsuming") then
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 or input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.ButtonR2 then
			if network:invoke("isCharacterStunned") then return end
			if attackOnCoolDown then return end

			network:invoke("setCharacterMovementState", "isSprinting", false)
--			isPlayerHoldingDownBasicAttack = true

			events:fireEventAll("playerWillUseBasicAttack", player)
			currentlyEquipped:attack(input)

			network:fire("stopChannels", "attack")
			network:fire("signalBasicAttacking", true)

--			attackOnCoolDown = true
			local stats = network:invoke("getCacheValueByNameTag", "nonSerializeData").statistics_final
			local attackDelay = .25

			if weaponDelays[curWeaponType] then
				attackDelay = weaponDelays[curWeaponType] / (1 + stats.attackSpeed)
			end
		end
	end
end

local function onInputEnded(input, absorbed)
	if isPlayerHoldingDownBasicAttack and currentlyEquipped and not absorbed and currentlyEquipped.release then -- bows
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.ButtonR2 then
			currentlyEquipped:release()

			isPlayerHoldingDownBasicAttack = false
		end
	elseif isPlayerHoldingDownBasicAttack and currentlyEquipped then -- swords
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.ButtonR2 then
			isPlayerHoldingDownBasicAttack = false
			network:fire("signalBasicAttacking", false)
		end

	end
end

local function onAttackInteractionSoundPlayed(position, soundName)
	if not position then
		position = player.Character.PrimaryPart.Position
	end

	utilities.playSound(soundName, position)
end
network:connect("attackInteractionSoundPlayed", "OnClientEvent", onAttackInteractionSoundPlayed)

local function onAttackInteractionAttackableAttacked(attackingPlayer, part, hitPosition)
	local module = part:FindFirstChild("attackableScript")
	if not module then return end

	-- hit effects
	network:fire("monsterDamagedAtPosition", hitPosition, attackingPlayer ~= player)

	module = require(module)
	module.onAttackedClient(attackingPlayer)
end
network:connect("attackInteractionAttackableAttacked", "OnClientEvent", onAttackInteractionAttackableAttacked)


local function shake(model)
	if model and model:IsA("Model") then
		if model.PrimaryPart then
			local originalCFrameValue = model:FindFirstChild("originalCFrame")
			if originalCFrameValue == nil then
				originalCFrameValue = Instance.new("CFrameValue")
				originalCFrameValue.Name = "originalCFrame"
				originalCFrameValue.Value = model.PrimaryPart.CFrame
				originalCFrameValue.Parent = model
			end
			local originalCFrame = originalCFrameValue.Value
			local primaryPart = model.PrimaryPart
			local rootCFrame =	originalCFrame * CFrame.new(0, -primaryPart.Size.Y/2, 0) * CFrame.Angles(0, math.pi * 2 * math.random(), 0)
			local offset = rootCFrame:ToObjectSpace(originalCFrame)

			local dummyPart = Instance.new("Part")
			dummyPart.CFrame = rootCFrame

			local shakeTime = 0.2
			local easingStyle = Enum.EasingStyle.Quad
			tween(dummyPart, {"CFrame"}, rootCFrame * CFrame.Angles(0.075, 0, 0), shakeTime, easingStyle, Enum.EasingDirection.Out)
			delay(shakeTime, function()
				tween(dummyPart, {"CFrame"}, rootCFrame, shakeTime, easingStyle, Enum.EasingDirection.In)
			end)

			effects.onHeartbeatFor(shakeTime * 2, function()
				model:SetPrimaryPartCFrame(dummyPart.CFrame:ToWorldSpace(offset))
			end)
		end
	end
end

local hitInteractions = {}
local function attackInteraction(interaction, part)
	local name = part.Name:lower()

	-- leafy boy
	if (name == "grass") or (name == "leaf") or (name == "bush") or (name == "green") then
		if not interaction["strikeFoliage"] then
			local soundName = "bush" .. math.random(1,3)
			onAttackInteractionSoundPlayed(part.Position, soundName)
			network:fireServer("attackInteractionSoundPlayed", part, soundName)

			shake(part.Parent)
		end
	end

	-- stumpy dude
	if (name == "stump") or (name == "log") or (name == "wood") then
		shake(part.Parent)
	end

	--attackable interactable ableables!
	if collectionService:HasTag(part, "attackable") then
		if part.Parent:IsA("Model") and part.Parent.Parent.Name == "Nodes" and part:IsDescendantOf(placeSetup.getPlaceFolder("resourceNodes")) then
			local nodeModel = part:FindFirstAncestorWhichIsA("Model")
			local dropPoint = network:invokeServer("HarvestResource", nodeModel)
			shake(nodeModel)
		else
			local hitPosition = detection.projection_Box(part.CFrame, part.Size, currentWeaponManifest.Position)
			onAttackInteractionAttackableAttacked(player, part, hitPosition)
			network:fireServer("attackInteractionAttackableAttacked", part, hitPosition)
		end

	end
end

local function doAttackInteractions(guid)
	local interaction = hitInteractions[guid]
	if not interaction then
		interaction = {}

		-- save this interaction for a bit, then
		-- get rid of it to avoid memory leaks
		hitInteractions[guid] = interaction
		delay(5, function()
			hitInteractions[guid] = nil
		end)
	end

	for _, part in pairs(currentWeaponManifest:GetTouchingParts()) do
		if not interaction[part] then
			interaction[part] = true
			attackInteraction(interaction, part)
		end
	end
end

local hitDebounceTable = {}
local function performClientDamageCycle(sourceType, sourceId, guid)
	if (sourceType == "equipment" and currentWeaponManifest) then
		if not hitDebounceTable[guid] then
			hitDebounceTable[guid] = {}

			-- invalidate this GUID in 5 seconds
			-- if an exploiter messes with this, oh well. have fun with a memory leak.
			delay(5, function()
				hitDebounceTable[guid] = nil
			end)
		end

		doAttackInteractions(guid)

		local sizeIncrease = 1 + network:invoke("getCacheValueByNameTag", "nonSerializeData").statistics_final.attackRangeIncrease

		for i, entityManifest in pairs(utilities.getEntities()) do
			if entityManifest ~= player.Character.PrimaryPart then
				if not hitDebounceTable[guid][entityManifest] then
					local boxcastOriginCF 	= currentWeaponManifest.CFrame
					local boxProjection_serverHitbox = detection.projection_Box(entityManifest.CFrame, entityManifest.Size, boxcastOriginCF.p)

					if detection.boxcast_singleTarget(boxcastOriginCF, currentWeaponManifest.Size * Vector3.new(3 + sizeIncrease, 2 + sizeIncrease, 3 + sizeIncrease), boxProjection_serverHitbox) then
						hitDebounceTable[guid][entityManifest] = true

						network:fire("requestEntityDamageDealt", entityManifest, boxProjection_serverHitbox, sourceType, sourceId, guid)
					end
				end
			end
		end
	else
		-- do nothing
	end
end

local function int_getCurrentlyEquippedEquipmentType()
	local weaponData = getPlayerEquipmentSlotDataForWeapon()

	return itemData[weaponData.id].equipmentType
end

-- invoke the client call on an ability
-- and return the stuff that we might need
-- who knows? it might come in handy
-- returns to NOTHING if we use an event

local function main()
	network:create("getCurrentlyEquippedEquipmentType", "BindableFunction", "OnInvoke", int_getCurrentlyEquippedEquipmentType)
	network:create("setCanPlayerBasicAttack", "BindableFunction", "OnInvoke", onSetCanPlayerBasicAttack)
	network:create("requestEntityDamageDealt", "BindableEvent", "Event", handleRequestEntityDamageRequest)

	network:create("performClientDamageCycle", "BindableFunction", "OnInvoke", performClientDamageCycle)
	network:connect("propogationRequestToSelf", "Event", onPropogationRequestToSelf)

	currentWeaponManifest = network:invoke("getCurrentWeaponManifest")

	network:connect("myClientCharacterWeaponChanged", "Event", onMyClientCharacterWeaponChanged)

	local equipment = network:invoke("getCacheValueByNameTag", "equipment")

	-- render character listener --
	local newMyClientCharacterContainer = network:invoke("getMyClientCharacterContainer")
	if newMyClientCharacterContainer then
		onMyClientCharacterContainerChanged(newMyClientCharacterContainer)
	end

	network:connect("myClientCharacterContainerChanged", "Event", onMyClientCharacterContainerChanged)

	-- get player character --
	if player.Character then
		onCharacterAdded(player.Character)
	end

	player.CharacterAdded:connect(onCharacterAdded)

	userInputService.InputBegan:connect(onInputBegan)
	userInputService.InputEnded:connect(onInputEnded)
end

main()

return module