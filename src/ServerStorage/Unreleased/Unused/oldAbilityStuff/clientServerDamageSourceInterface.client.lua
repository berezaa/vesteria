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

-- defunct
--[[
local function getAbilityStatisticsForRank(abilityId, rank)
	local abilityBaseData = 
	
	if abilityBaseData then
		if not abilityBaseData.statistics[rank - 1] then
			-- is first rank
			return abilityBaseData.statistics[rank], {}
		end
		
		local abilityStatisticsUpToRank = {}
		for i = 1, rank do
			for abilityStatisticName, abilityStatisticValue in pairs(abilityBaseData.statistics[i]) do
				abilityStatisticsUpToRank[abilityStatisticName] = abilityStatisticValue
			end
		end
		
		local abilityStatisticsUpToPreviousRank = {}
		for i = 1, rank - 1 do
			for abilityStatisticName, abilityStatisticValue in pairs(abilityBaseData.statistics[i]) do
				abilityStatisticsUpToPreviousRank[abilityStatisticName] = abilityStatisticValue
			end
		end
		
		local abilityStatisticsDifferencesAtRank = {}
		for abilityStatisticName, abilityStatisticValue in pairs(abilityBaseData.statistics[rank]) do
			if abilityStatisticsUpToPreviousRank[abilityStatisticName] then
				abilityStatisticsDifferencesAtRank[abilityStatisticName] = abilityStatisticValue - abilityStatisticsUpToPreviousRank[abilityStatisticName]
			end
		end
		
		return abilityStatisticsUpToRank, abilityStatisticsDifferencesAtRank
	end
end
]]
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

-- network:invoke("getCacheValueByNameTag", "abilities")
local function canPlayerCastAbility(playerAbilitiesSlotDataCollection, abilityId, abilityExecutionData, playerData)
	if playerAbilitiesSlotDataCollection then
		local equipmentSlotData = getPlayerEquipmentSlotDataForWeapon()
		local itemBaseData 		= equipmentSlotData and itemData[equipmentSlotData.id]
		
		for _, abilitySlotData in pairs(playerAbilitiesSlotDataCollection) do
			if abilitySlotData.id == abilityId and abilitySlotData.rank > 0 then
				local abilityBaseData = abilityLookup[abilitySlotData.id](playerData, abilityExecutionData)
				if abilityBaseData and (not abilityBaseData.equipmentTypeNeeded or (itemBaseData and equipmentMeetsAbilityRequirement(itemBaseData, abilityBaseData.equipmentTypeNeeded))) then
					return true
				end
			end
		end
	end
	
	return false
end

local function getAbilityRankFromPlayerAbilitiesSlotDataCollection(playerAbilitiesSlotDataCollection, abilityId)
	if playerAbilitiesSlotDataCollection then
		local equipmentSlotData = getPlayerEquipmentSlotDataForWeapon()
		local itemBaseData 		= equipmentSlotData and itemData[equipmentSlotData.id]
		
		for _, abilitySlotData in pairs(playerAbilitiesSlotDataCollection) do
			if abilitySlotData.id == abilityId then
				return abilitySlotData.rank, abilitySlotData
			end
		end
	end
	
	return 0, nil
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

local inactiveAbilityExecutionData 		= {id = 0}
local inactiveAbilityExecutionData_json = httpService:JSONEncode(inactiveAbilityExecutionData)

local function changeAbilityState(abilityId, abilityState, abilityExecutionData, guid)
	if abilityState == "end" then
		abilityExecutionData = {id = 0; }
	end
	abilityExecutionData["step"] = (abilityExecutionData["step"] or 0) + 1
	if abilityState == "update" then
		abilityExecutionData["times-updated"] = (abilityExecutionData["times-updated"] or 0) + 1
	end
	
	local success, dataEncoded = utilities.safeJSONEncode(abilityExecutionData)
	if success then
		
		if abilityState == "end" then
			network:fireServer("replicateAbilityStateChangeByPlayer", abilityId, abilityState, nil, guid)	
		else
			network:fireServer("replicateAbilityStateChangeByPlayer", abilityId, abilityState, abilityExecutionData, guid)	
		end	
					
		local localEntity = game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.PrimaryPart
		if localEntity then
			localEntity.activeAbilityExecutionData.Value = dataEncoded
		end
	end
end

network:create("client_changeAbilityState", "BindableFunction", "OnInvoke", changeAbilityState)


local function getAbilityExecutionData(abilityId, existingExecutionData)
	local existingExecutionData = existingExecutionData or {}
	
	local playerData = network:invoke("getLocalPlayerDataCache")
	local ability
	-- have to do this ugly check on my otherwise perfect system because arrows fire without abilityId -ber
	if abilityId then
		ability = abilityLookup[abilityId](playerData, existingExecutionData)
	end
	
	local currentlyFacingManifest = abilityId and network:invoke("getCurrentlyFacingManifest") do
		if ability and ability.disableAutoaim then
			currentlyFacingManifest = nil
		end
	end
	
	local hitPart, hitPosition, hitNormal 	= client_utilities.raycastFromCurrentScreenPoint({entityRenderCollectionFolder; entityRenderCollectionFolder; itemsFolder; entitiesFolder})
	local abilityExecutionData 				= {}
	
	for key, value in pairs(existingExecutionData) do
		abilityExecutionData[key] = value
	end

	-- mouse pos on screen
	abilityExecutionData["mouse-screen-position"] = userInputService:GetMouseLocation()
	
	-- mouse pos in world
	abilityExecutionData["mouse-world-position"] = hitPosition
	
	-- mouse pos in world
	abilityExecutionData["absolute-mouse-world-position"] = hitPosition
	
	-- davidii wants this mouse position
	do
		local part, point, normal = client_utilities.raycastFromCurrentScreenPoint({itemsFolder, entitiesFolder})
		abilityExecutionData["mouse-target-position"] = point
	end

	-- mouse target
	abilityExecutionData["mouse-target"] = hitPart
	
	-- r
	abilityExecutionData["ability-state"] = "begin"
	abilityExecutionData["times-updated"] = abilityExecutionData["times-updated"] or 0
	
	-- weapon casted with
	local weaponSlotData = getPlayerEquipmentSlotDataForWeapon()
	if weaponSlotData then
		abilityExecutionData["cast-weapon-id"] = weaponSlotData.id
	end
	
	if currentlyFacingManifest and player.Character and player.Character.PrimaryPart then
		-- target monster
		abilityExecutionData["target-position"] = currentlyFacingManifest.Position
		
		-- target monster
		abilityExecutionData["target-velocity"] = currentlyFacingManifest.Velocity
		
		-- target monster distance away
		abilityExecutionData["target-distance-away"] = (currentlyFacingManifest.Position - player.Character.PrimaryPart.Position).magnitude
	end
	
	if player.Character and player.Character.PrimaryPart then
		abilityExecutionData["cast-origin"] = player.Character.PrimaryPart.Position
		
		if abilityExecutionData["target-position"] then
			local dir = abilityExecutionData["target-position"] - abilityExecutionData["cast-origin"]
			
			if dir.magnitude > 35 then
				abilityExecutionData["target-position"] 		= abilityExecutionData["cast-origin"] + Vector3.new(dir.X, 0, dir.Z).unit * 35
				abilityExecutionData["target-distance-away"] 	= 35
			end
		end
		
		if abilityExecutionData["mouse-world-position"] then
			local dir = abilityExecutionData["mouse-world-position"] - abilityExecutionData["cast-origin"]
			
			if dir.magnitude > 35 then
				abilityExecutionData["mouse-world-position"] = abilityExecutionData["cast-origin"] + Vector3.new(dir.X, dir.Y, dir.Z).unit * 35
			end
		end
	end
	
	if hitPart then
		local hitPlayer, hitMonster do
			if hitPart:IsDescendantOf(entityManifestCollectionFolder) then
				hitPlayer = game.Players:GetPlayerFromCharacter(hitPart.Parent)
			elseif hitPart:IsDescendantOf(entityManifestCollectionFolder) then
				hitMonster = hitPart
			end
		end
		
		if hitPlayer then
			-- (if valid) mouse target player
			abilityExecutionData["target-player-userId"] = hitPlayer.userId
			
			-- (if valid) mouse target player distance away
			if hitPlayer and hitPlayer.Character and hitPlayer.Character.PrimaryPart and player.Character and player.Character.PrimaryPart then
				abilityExecutionData["target-position"] 		= hitPlayer.Character.PrimaryPart.Position
				abilityExecutionData["target-velocity"] 		= hitPlayer.Character.PrimaryPart.Velocity
				abilityExecutionData["target-distance-away"] = (hitPlayer.Character.PrimaryPart.Position - player.Character.PrimaryPart.Position).magnitude
			end
		elseif hitMonster and not currentlyFacingManifest then
			-- target monster
			abilityExecutionData["target-position"] = hitMonster.Position
			
			-- target monster
			abilityExecutionData["target-velocity"] = hitMonster.Velocity
			
			-- target monster distance away
			if hitMonster and player.Character and player.Character.PrimaryPart then
				abilityExecutionData["target-distance-away"] = (hitMonster.Position - player.Character.PrimaryPart.Position).magnitude
			end
		end
	end
	
	if abilityId then
		if ability and ability.executionData then
			for key, value in pairs(ability.executionData) do
				abilityExecutionData[key] = value
			end		
		end			
		
		local abilitiesSlotDataCollection = network:invoke("getCacheValueByNameTag", "abilities")
	
		local abilityRank = getAbilityRankFromPlayerAbilitiesSlotDataCollection(abilitiesSlotDataCollection, abilityId)
		if abilityRank and abilityRank > 0 then
			--local abilityStatisticsData = getAbilityStatisticsForRank(abilityId, abilityRank)
			local abilityStatisticsData = ability_utilities.getAbilityStatisticsForRank(ability, abilityRank, player, abilityId)
			if abilityStatisticsData then
				abilityExecutionData["ability-statistics"] = abilityExecutionData["ability-statistics"] or abilityStatisticsData
			end
		end
		
		local range = ability.targetingData and ability.targetingData.range or abilityExecutionData["ability-statistics"].range or ability.statistics.range
		if typeof(range) == "string" then
			range = abilityExecutionData["ability-statistics"].range or ability.statistics.range
		elseif typeof(range) == "function" then
			error("Not yet implemented!")
		end		
		
		local part, point, normal = client_utilities.raycastFromCurrentScreenPoint({itemsFolder, entitiesFolder}, range)
		abilityExecutionData["mouse-inrange"] = point		
		
		local abilityBaseData = ability
		
		if abilityBaseData then
			
			local playerDataCache = network:invoke("getLocalPlayerDataCache")
			
			abilityExecutionData["_dex"] = abilityExecutionData["_dex"] or playerDataCache and playerDataCache.nonSerializeData.statistics_final.dex or 0
			abilityExecutionData["_int"] = abilityExecutionData["_int"] or playerDataCache and playerDataCache.nonSerializeData.statistics_final.int or 0
			abilityExecutionData["_vit"] = abilityExecutionData["_vit"] or playerDataCache and playerDataCache.nonSerializeData.statistics_final.vit or 0
			abilityExecutionData["_str"] = abilityExecutionData["_str"] or playerDataCache and playerDataCache.nonSerializeData.statistics_final.str or 0			
			
			if abilityBaseData._abilityExecutionDataCallback then
				
				abilityBaseData._abilityExecutionDataCallback(playerDataCache, abilityExecutionData)
			end
			
			abilityExecutionData.IS_ENHANCED = abilityBaseData._doEnhanceAbility and abilityBaseData._doEnhanceAbility({nonSerializeData = network:invoke("getCacheValueByNameTag", "nonSerializeData")})
		end
	end
	
	-- where was the caster looking?
	abilityExecutionData["camera-cframe"] = workspace.CurrentCamera.CFrame
	
	-- nearest player
	abilityExecutionData["nearest-player"] = nil
		
	-- nearest player distance away
	abilityExecutionData["nearest-player"] = nil
	
	-- abilityId
	abilityExecutionData["id"] = abilityId
	
	-- own player userId
	abilityExecutionData["cast-player-userId"] = player.userId
	
	-- manual-aim
	abilityExecutionData["manual-aim"] = false
	
	return abilityExecutionData
end
	
network:create("getAbilityExecutionData", "BindableFunction", "OnInvoke", getAbilityExecutionData)
	
local cooldownLookup = {}
local displayLookup = {}

local function onAbilityCooldownReset(abilityId)
	cooldownLookup[abilityId] = nil
	local abilityDisplay = displayLookup[abilityId]
	if abilityDisplay then
		network:invoke("displayAbilityCooldown", abilityDisplay, 0)
	end
end

local function int__canPlayerCastAbility(abilityId, abilityExecutionData, abilityDisplay, playerData)
	if isPlayerCastingAbility then return false end

	local abilityBaseData = abilityLookup[abilityId](playerData, abilityExecutionData)
	if not abilityBaseData then return false end
	
	local abilitiesSlotDataCollection = network:invoke("getCacheValueByNameTag", "abilities")
	
	local abilityRank = getAbilityRankFromPlayerAbilitiesSlotDataCollection(abilitiesSlotDataCollection, abilityId)
	if not abilityRank or abilityRank < 1 then return false end
	
	local abilityStatisticsData = ability_utilities.getAbilityStatisticsForRank(abilityBaseData, abilityRank)	
--	local abilityStatisticsData = getAbilityStatisticsForRank(abilityId, abilityRank)
	
	local manaCost = abilityStatisticsData.manaCost or 20
	if player.Character.PrimaryPart.mana.Value < manaCost then
		return false, "missing-mana" 
	end
	
	if player.Character.PrimaryPart.health.Value <= 0 then return false end
	if player.Character.PrimaryPart.state.Value == "dead" or player.Character.PrimaryPart.state.Value == "gettingUp" then return false end
	
	if network:invoke("isCharacterStunned") then return end
	
	local nonSerializeData = network:invoke("getCacheValueByNameTag", "nonSerializeData")
	if not nonSerializeData then return false end
	
	if not canPlayerCastAbility(abilitiesSlotDataCollection, abilityId, abilityExecutionData, playerData) then return false end
	
	local isOnCooldown = true
	if not cooldownLookup[abilityId] or tick() - cooldownLookup[abilityId] >= (abilityStatisticsData.cooldown or 5) * (1 - nonSerializeData.statistics_final.abilityCDR) then
		isOnCooldown = false
	end
	if isOnCooldown then return false end
	
	return true
end

local function int__activateAbility(abilityId, abilityExecutionData, abilityDisplay)
	local playerData = network:invoke("getLocalPlayerDataCache")
	if not int__canPlayerCastAbility(abilityId, abilityExecutionData, abilityDisplay, playerData) then return end
	
	local abilityBaseData = abilityLookup[abilityId](playerData, abilityExecutionData)
	
	local abilitiesSlotDataCollection = network:invoke("getCacheValueByNameTag", "abilities")
	local abilityRank = getAbilityRankFromPlayerAbilitiesSlotDataCollection(abilitiesSlotDataCollection, abilityId)
	local abilityStatisticsData = ability_utilities.getAbilityStatisticsForRank(abilityBaseData, abilityRank)
	local nonSerializeData = network:invoke("getCacheValueByNameTag", "nonSerializeData")

	cooldownLookup[abilityId] = tick()
	displayLookup[abilityId] = abilityDisplay
	
	network:invoke("displayAbilityCooldown", abilityDisplay, abilityStatisticsData.cooldown * (1 - nonSerializeData.statistics_final.abilityCDR))

	local renderCharacter = network:invoke("getMyClientCharacterContainer")
	if renderCharacter then
		local guid = httpService:GenerateGUID(false)
		abilityExecutionData["ability-guid"] = guid
		
		local isSuccessfullyEncoded, encodeValue = utilities.safeJSONEncode(abilityExecutionData)
		if not isSuccessfullyEncoded then return false end
		
		-- disable some stuff while player is casting
		isPlayerCastingAbility = true
		onSetCanPlayerBasicAttack(false)
		
		network:invoke("setCanPlayerUseConsumable", false)
		network:invoke("setIsJumpEnabled", false)
		
		if not abilityBaseData.dontDisableSprinting then
			network:invoke("setIsSprintingEnabled", false)
			network:invoke("setCharacterMovementState", "isSprinting", false)
			
		end

		if abilityBaseData.faceTowardsCastingDirection and abilityExecutionData.castingDirection then
			network:invoke("setIsCastingSpell", true, abilityExecutionData.castingDirection)
		end
		
		-- (player, abilityId, isAbilityActive, targetPosition, targetPlayer, guid)
		--player.Character.PrimaryPart.activeAbilityExecutionData.Value = encodeValue
		network:invoke("client_changeAbilityState", abilityId, true, abilityExecutionData, guid)
		
		
		-- all this commented out so entityRenderer can take over the initial execute, so the .step chain is maintened
		
		-- execute the ability
		--[[
		local executionSuccess, returnValue = pcall(function()
			return abilityBaseData:execute(renderCharacter, abilityExecutionData, true, guid)
		end)
		
		
		if not executionSuccess then
		end
		
		-- todo: convert all ::execute to return true, figure out nicer way to
		-- handle this situation..
		if executionSuccess and returnValue == false then 
			onAbilityCooldownReset(abilityId)
		end
		
		]]
			
		-- minimum time to ensure some level of replication and ensure that
		--wait(1 / 12)
	
		--[[
		if not abilityBaseData.abilityDecidesEnd then
			network:invoke("client_changeAbilityState", abilityId, false, abilityExecutionData, guid)
		end
		
		if abilityBaseData.abilityDecidesEnd then
			repeat wait() until not isPlayerCastingAbility
		end
		]]
		
		repeat wait() until not isPlayerCastingAbility
		
		onSetCanPlayerBasicAttack(true)
		network:invoke("setCanPlayerUseConsumable", true)
		network:invoke("setIsJumpEnabled", true)
		network:invoke("setIsSprintingEnabled", true)
	
		if abilityBaseData.faceTowardsCastingDirection then
			network:invoke("setIsCastingSpell", false)
		end
		
		return true
	end
end

-- the ability thats currently being primed (smart cast)
local currentAbilityCastData = {}
currentAbilityCastData.executionData = nil
currentAbilityCastData.id = nil

local castingAnimation

local function handleActivateAbilityRequest(abilityId, abilityDisplay, abilityExecutionData)
	if not network:invoke("getIsCurrentlyConsuming") then
		
		abilityExecutionData = abilityExecutionData 
		
		local playerData = network:invoke("getLocalPlayerDataCache")
		local abilityData = abilityLookup[abilityId](playerData, abilityExecutionData)
		
		abilityExecutionData = abilityExecutionData or getAbilityExecutionData(abilityId)
		
		if abilityData then	
			if abilityExecutionData["manual-aim"] then
				abilityExecutionData["target-casting-position"] = abilityExecutionData["mouse-world-position"]
			end
			
			return int__activateAbility(abilityId, abilityExecutionData, abilityDisplay)
		end
	end
end

local function handleCancelAbilityActivationRequest(abilityId)
	
end

local function onMyClientCharacterContainerChanged(newMyClientCharacterContainer)
	clientCharacterContainer = newMyClientCharacterContainer
	-- wait for humanoid
	local animationController = newMyClientCharacterContainer.entity:WaitForChild("AnimationController")
	while not animationController:IsDescendantOf(workspace) do wait() end
	
	if currentlyEquipped then
		currentlyEquipped:equip()
	end
	
	castingAnimation = animationController:LoadAnimation(game.ReplicatedStorage.abilityAnimations.rock_throw_upper_loop)
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
		if part:IsDescendantOf(placeSetup.getPlaceFolder("resourceNodes")) then
			local nodeModel = part:FindFirstAncestorWhichIsA("Model")
			shake(nodeModel)
			local dropPoint = network:invokeServer("HarvestResource", nodeModel)
			ResourceController:DoEffect(nodeModel, "Harvest")
			if dropPoint then
				dropPoint.Transparency = 1
			end
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

local function onAbilityInvokeClientCall(abilityExecutionData, abilityId, ...)
	local playerData = network:invoke("getLocalPlayerDataCache")
	local ability = abilityLookup[abilityId](playerData, abilityExecutionData)
	if not ability then return nil end
	if not ability.execute_client then return nil end
	
	return ability:execute_client(abilityExecutionData, ...)
end

local function main()
	network:create("getCurrentlyEquippedEquipmentType", "BindableFunction", "OnInvoke", int_getCurrentlyEquippedEquipmentType)
	network:create("setCanPlayerBasicAttack", "BindableFunction", "OnInvoke", onSetCanPlayerBasicAttack)
	network:create("requestEntityDamageDealt", "BindableEvent", "Event", handleRequestEntityDamageRequest)
	network:create("activateAbilityRequest", "BindableFunction", "OnInvoke", handleActivateAbilityRequest)
	network:create("canActivateAbility", "BindableFunction", "OnInvoke", function(abilityId, abilityDisplay, abilityExecutionData)
		abilityExecutionData = abilityExecutionData or getAbilityExecutionData(abilityId)
		local playerData = network:invoke("getLocalPlayerDataCache")
		return int__canPlayerCastAbility(abilityId, abilityExecutionData, abilityDisplay, playerData)
	end)
	network:create("performClientDamageCycle", "BindableFunction", "OnInvoke", performClientDamageCycle)
	network:connect("propogationRequestToSelf", "Event", onPropogationRequestToSelf)
	
	network:create("cancelAbilityActivationRequest", "BindableEvent", "Event", handleCancelAbilityActivationRequest)
	
	currentWeaponManifest = network:invoke("getCurrentWeaponManifest")
	
	network:connect("myClientCharacterWeaponChanged", "Event", onMyClientCharacterWeaponChanged)
	
	local equipment = network:invoke("getCacheValueByNameTag", "equipment")
	
	-- render character listener --
	local newMyClientCharacterContainer = network:invoke("getMyClientCharacterContainer")
	if newMyClientCharacterContainer then
		onMyClientCharacterContainerChanged(newMyClientCharacterContainer)
	end
	
	network:connect("myClientCharacterContainerChanged", "Event", onMyClientCharacterContainerChanged)
	network:connect("abilityCooldownReset", "OnClientEvent", onAbilityCooldownReset)
	
	network:connect("abilityInvokeClientCall", "OnClientInvoke", onAbilityInvokeClientCall)
	network:connect("abilityFireClientCall", "OnClientEvent", onAbilityInvokeClientCall)
	
	network:create("getIsPlayerCastingAbility", "BindableFunction", "OnInvoke", function()
		return isPlayerCastingAbility
	end)
	
	network:create("setIsPlayerCastingAbility", "BindableEvent", "Event", function(value)
		isPlayerCastingAbility = value
	end)
	
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