-- manages items, duh
-- author: Polymorphic

-- >>> BIGGGG REALIZATION!!! Do not let the client tell you what status effect
-- to apply. The server will decide to apply a status effect as it receives
-- requests from the client to use an item or use an ability!
-- ie, in manager_ability when activeAbilityId is set, determine if there
-- is an associated status effect with the activation of the ability and
-- if so, channel it through manager_statusEffect

local module = {}

local httpService 		= game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")
		local placeSetup 	= modules.load("placeSetup")
		local physics 		= modules.load("physics")
		local utilities 	= modules.load("utilities")
		local configuration = modules.load("configuration")
		local terrainUtil   = modules.load("terrainUtil")
	
local statusEffectLookup = require(replicatedStorage.statusEffectLookup)
local activeStatusEffectsCollectionContainer = {}

--[[
	activeStatusEffect {}
		int sourceType["ability"; "entity"; "consumable"]
		int sourceId
		
		string statusEffectType
		statusEffectData_intermediate statusEffectData
			int 
		
		string sourceEntityGUID
--]]

local function updatePlayerStatusEffects(player)
	
end

local function onGetStatusEffectsOnEntityManifestByEntityGUID(entityGUID)
	local statusEffects = {}
	
	for i, activeStatusEffectData in pairs(activeStatusEffectsCollectionContainer) do
		if activeStatusEffectData.affecteeEntityGUID == entityGUID then
			table.insert(statusEffects, activeStatusEffectData)
		end
	end
	
	return statusEffects
end

local function doesEntityManifestHaveStatusEffectBySourceType(entityManifest, sourceType)
	local entityGUID = utilities.getEntityGUIDByEntityManifest(entityManifest)
	
	if entityGUID then
		for i, activeStatusEffectData in pairs(activeStatusEffectsCollectionContainer) do
			if activeStatusEffectData.affecteeEntityGUID == entityGUID and activeStatusEffectData.sourceType == sourceType then
				return true
			end
		end
	end
	
	return false
end

local function removeStatusEffectByIndex(index)
	local activeStatusEffectData = activeStatusEffectsCollectionContainer[index]
	table.remove(activeStatusEffectsCollectionContainer, index)
	
	-- potentially call an on-ended status effect thing
	local statusEffectBaseData = statusEffectLookup[activeStatusEffectData.statusEffectType]
	if statusEffectBaseData and statusEffectBaseData.onEnded_server then
		local entityManifest = utilities.getEntityManifestByEntityGUID(activeStatusEffectData.affecteeEntityGUID)
		if entityManifest then
			statusEffectBaseData.onEnded_server(activeStatusEffectData, entityManifest)
		end
	end
end

local function updateStatusEffectsForEntityManifestByEntityGUID(entityGUID)
	local statusEffects 	= onGetStatusEffectsOnEntityManifestByEntityGUID(entityGUID)
	local entityManifest 	= utilities.getEntityManifestByEntityGUID(entityGUID)
	
	if entityManifest and entityManifest:FindFirstChild("statusEffectsV2") then
		local success, returnValue = utilities.safeJSONEncode(statusEffects)
		
		if success then
			entityManifest.statusEffectsV2.Value = returnValue
			
			if entityManifest.Parent then
				local player = game.Players:GetPlayerFromCharacter(entityManifest.Parent)
				
				if player then
					local playerData = network:invoke("getPlayerData", player)
					
					if playerData then
						playerData.nonSerializeData.playerDataChanged:Fire("statusEffects")
					end
				end
			end
		end
	end
end

local function removeStatusEffectFromEntityManifestBySourceType(entityManifest, sourceType)
	local entityGUID = utilities.getEntityGUIDByEntityManifest(entityManifest)
	
	if entityGUID then
		for i = #activeStatusEffectsCollectionContainer, 1, -1 do
			local activeStatusEffectData = activeStatusEffectsCollectionContainer[i]
			if activeStatusEffectData.affecteeEntityGUID == entityGUID and activeStatusEffectData.sourceType == sourceType then
				local statusEffectBaseData = statusEffectLookup[activeStatusEffectData.statusEffectType]

				if statusEffectBaseData._serverCleanupFunction then
					statusEffectBaseData._serverCleanupFunction(activeStatusEffectData, entityManifest)
				end
				
				removeStatusEffectByIndex(i)
				updateStatusEffectsForEntityManifestByEntityGUID(entityGUID)
			end
		end
	end
	
	return false
end

local function onPlayerRemovingPackageStatusEffects(player)
	if not player:FindFirstChild("entityGUID") then warn("FAILED TO FIND PLAYER ENTITYGUID FOR STATUS EFFECTS PACKAGING") return false end
	
	local playerEntityGUID 	= player.entityGUID.Value
	local statusEffects 	= {}
	
	for i = #activeStatusEffectsCollectionContainer, 1, -1 do
		local activeStatusEffectData 	= activeStatusEffectsCollectionContainer[i]
		
		local statusBaseData = statusEffectLookup[activeStatusEffectData.statusEffectType]
		local doNotSave =
			(activeStatusEffectData.DO_NOT_SAVE) or
			(statusBaseData and statusBaseData.notSavedToPlayerData)
		
		if activeStatusEffectData.affecteeEntityGUID == playerEntityGUID and not doNotSave then
			removeStatusEffectByIndex(i)
			table.insert(statusEffects, activeStatusEffectData)
		end
	end
	
	return statusEffects
end

local function onPlayerAddedContinuePackageStatusEffects(player, packageStatusEffects)
	if not player:FindFirstChild("entityGUID") then warn("FAILED TO FIND PLAYER ENTITYGUID") return false end
	
	for i, activeStatusEffectData in pairs(packageStatusEffects) do
		-- update to current player
		activeStatusEffectData.affecteeEntityGUID = player.entityGUID.Value
		
		-- pop to be updated
		table.insert(activeStatusEffectsCollectionContainer, activeStatusEffectData)
	end
end

local function int__startTickingAbilities()
	local activeStatusEffectTickTimePerSecond = configuration.getConfigurationValue("activeStatusEffectTickTimePerSecond")
	
	local function tickStatusEffects()
		local requiresUpdate 						= {}
		local indicesToRemove = {}
				
		-- index in reverse so we can table.remove just fine, remove finished statusEffects
		for i = #activeStatusEffectsCollectionContainer, 1, -1 do
			local activeStatusEffectData 	= activeStatusEffectsCollectionContainer[i]
			local entityManifest, isInWorld = utilities.getEntityManifestByEntityGUID(activeStatusEffectData.affecteeEntityGUID)
			
			local shouldUpdateEntity = false
			
			if entityManifest then
				local statusEffectBaseData = statusEffectLookup[activeStatusEffectData.statusEffectType]
				
				if statusEffectBaseData and statusEffectBaseData.execute then
					statusEffectBaseData.execute(activeStatusEffectData, entityManifest, activeStatusEffectTickTimePerSecond)
				end
				
				if activeStatusEffectData.ticksMade then
					activeStatusEffectData.ticksMade = activeStatusEffectData.ticksMade + 1
	
					if activeStatusEffectData.ticksMade >= activeStatusEffectData.ticksNeeded then
						removeStatusEffectByIndex(i)
					end
					
					shouldUpdateEntity = true
				end
			elseif not isInWorld then
				-- pop it
				
				shouldUpdateEntity = true
				removeStatusEffectByIndex(i)
			end
			
			if shouldUpdateEntity then
				local guid = activeStatusEffectData.affecteeEntityGUID
				if guid and not requiresUpdate[guid] then
					requiresUpdate[guid] = true
				end
			end
		end
		
		-- update everything
		for guid, _ in pairs(requiresUpdate) do
			updateStatusEffectsForEntityManifestByEntityGUID(guid)
		end
	end
	
	local savedTime = 0
	local tickDuration = 1 / activeStatusEffectTickTimePerSecond
	
	local function onHeartbeat(dt)
		savedTime = savedTime + dt
		while savedTime > tickDuration do
			savedTime = savedTime - tickDuration
			tickStatusEffects()
		end
	end
	
	game:GetService("RunService").Heartbeat:Connect(onHeartbeat)
end

-- "applyStatusEffectToEntityManifest", player.Character.PrimaryPart, "regenerate", {health = 25; duration = 5}, {sourceId = item}

local function onApplyStatusEffectToEntityManifest(entityManifest, statusEffectType, statusEffectModifierData, sourceEntityManifest, sourceType, sourceId, variant)
	print("APPLYING AN EFFECT")
	if not statusEffectLookup[statusEffectType] then
		return false, "invalid status effect"
	end
	
	local activeStatusEffectTickTimePerSecond 	= configuration.getConfigurationValue("activeStatusEffectTickTimePerSecond")
	local sourceEntityGUID 						= utilities.getEntityGUIDByEntityManifest(sourceEntityManifest)
	local affecteeEntityGUID 					= utilities.getEntityGUIDByEntityManifest(entityManifest)
	local statusEffectBaseData 					= statusEffectLookup[statusEffectType]
	local activeStatusEffectData 				= {}
		-- help us decipher where this statusEffect came from
		activeStatusEffectData.sourceType 		= sourceType
		activeStatusEffectData.sourceId 		= sourceId
		if variant then
			activeStatusEffectData.variant			= variant
		end
		activeStatusEffectData.sourceEntityGUID = sourceEntityGUID
		
		-- what kind of status effect is this?
		activeStatusEffectData.statusEffectType 	= statusEffectType
		activeStatusEffectData.statusEffectModifier = statusEffectModifierData
		activeStatusEffectData.statusEffectGUID 	= httpService:GenerateGUID(false)
		
		-- who does this affect?
		activeStatusEffectData.affecteeEntityGUID 	= affecteeEntityGUID
		activeStatusEffectData.timestamp 			= tick()
	
	-- handle internal stuff here --
	if activeStatusEffectData.statusEffectModifier.duration then
		activeStatusEffectData.ticksMade 	= 0
		activeStatusEffectData.ticksNeeded 	= activeStatusEffectData.statusEffectModifier.duration * activeStatusEffectTickTimePerSecond
	else
		activeStatusEffectData.isPermanent = true
	end
	
	if statusEffectBaseData.hideInStatusBar then
		activeStatusEffectData.hideInStatusBar = true
	end
	
	if activeStatusEffectData.statusEffectModifier.DO_NOT_SAVE then
		activeStatusEffectData.DO_NOT_SAVE = true
	end
	
	if activeStatusEffectData.statusEffectModifier.icon then
		activeStatusEffectData.icon = activeStatusEffectData.statusEffectModifier.icon
	else
		if (sourceType ~= "item") and (sourceType ~= "ability") then
			activeStatusEffectData.icon = statusEffectBaseData.image
		end
	end
	
	-- pop duplicate statusEffects out
	for i = #activeStatusEffectsCollectionContainer, 1, -1 do
		local _statusEffectData = activeStatusEffectsCollectionContainer[i]
		
		local sameType = _statusEffectData.sourceType == sourceType
		local sameSource = _statusEffectData.sourceId == sourceId
		local sameAffectee = _statusEffectData.affecteeEntityGUID == affecteeEntityGUID
		
		if sameType and sameSource and sameAffectee then
			removeStatusEffectByIndex(i)
		end
	end
	
	if statusEffectBaseData._serverExecutionFunction then
		statusEffectBaseData._serverExecutionFunction(activeStatusEffectData, entityManifest)
	end
	
	if statusEffectBaseData.onStarted_server then
		statusEffectBaseData.onStarted_server(activeStatusEffectData, entityManifest)
	end
	
	table.insert(activeStatusEffectsCollectionContainer, activeStatusEffectData)
	
	-- update status effects
	updateStatusEffectsForEntityManifestByEntityGUID(affecteeEntityGUID)
	
	if sourceId == "item" then
		utilities.playSound("item_buff", entityManifest)
	end
	
	return true, activeStatusEffectData.statusEffectGUID
end

network:create("applyStatusEffectToEntityManifest", "BindableFunction", "OnInvoke", onApplyStatusEffectToEntityManifest)

local function revokeStatusEffectByStatusEffectGUID(statusEffectGUID)
	for i = #activeStatusEffectsCollectionContainer, 1, -1 do
		local status = activeStatusEffectsCollectionContainer[i]
		if status.statusEffectGUID == statusEffectGUID then
			removeStatusEffectByIndex(i)
			updateStatusEffectsForEntityManifestByEntityGUID(status.affecteeEntityGUID)
			
			return true
		end
	end
	
	return false
end

network:create("revokeStatusEffectByStatusEffectGUID", "BindableFunction", "OnInvoke", revokeStatusEffectByStatusEffectGUID)

-- when a player enters water, certain status effects should be wiped
local function onPlayerEnteredWater(player, clientPosition)
	local char = player.Character
	if not char then return end
	local root = char.PrimaryPart
	if not root then return end
	local guid = utilities.getEntityGUIDByEntityManifest(root)
	if not guid then return end
	if not terrainUtil.isPointUnderwater(clientPosition) then return end
	local sanityRangeSq = 6 ^ 2
	local delta = clientPosition - root.Position
	local distanceSq = delta.X ^ 2 + delta.Y ^ 2 + delta.Z ^ 2
	if distanceSq > sanityRangeSq then return end
	
	local updateRequired = false
	
	for index = #activeStatusEffectsCollectionContainer, 1, -1 do
		local activeStatusEffectData = activeStatusEffectsCollectionContainer[index]
		
		if activeStatusEffectData.affecteeEntityGUID == guid then
			-- here is where we determine if a status must be removed
			if activeStatusEffectData.statusEffectType == "ablaze" then
				removeStatusEffectByIndex(index)
				updateRequired = true
			end
		end
	end
	
	if updateRequired then
		updateStatusEffectsForEntityManifestByEntityGUID(guid)
	end
end
network:create("onPlayerEnteredWater", "RemoteEvent", "OnServerEvent", onPlayerEnteredWater)

local function main()
	
	network:create("removeStatusEffectFromEntityManifestBySourceType", "BindableFunction", "OnInvoke", removeStatusEffectFromEntityManifestBySourceType)
	network:create("doesEntityManifestHaveStatusEffectBySourceType", "BindableFunction", "OnInvoke", doesEntityManifestHaveStatusEffectBySourceType)
	
	network:create("doesEntityHaveStatusEffect", "BindableFunction", "OnInvoke", function(manifest, effectType)
		if not manifest then return false end
		local guid = utilities.getEntityGUIDByEntityManifest(manifest)
		if not guid then return false end
		
		local statuses = network:invoke("getStatusEffectsOnEntityManifestByEntityGUID", guid)
		
		for _, status in pairs(statuses) do
			if status.statusEffectType == effectType then
				return true, status
			end
		end
		
		return false
	end)
	
	network:create("updateStatusEffectsForEntityManifestByEntityGUID", "BindableFunction", "OnInvoke", updateStatusEffectsForEntityManifestByEntityGUID)
	
	network:create("playerRemovingPackageStatusEffects", "BindableFunction", "OnInvoke", onPlayerRemovingPackageStatusEffects)
	network:create("playerAddedContinuePackageStatusEffects", "BindableFunction", "OnInvoke", onPlayerAddedContinuePackageStatusEffects)
	
	network:create("getStatusEffectsOnEntityManifestByEntityGUID", "BindableFunction", "OnInvoke", onGetStatusEffectsOnEntityManifestByEntityGUID)
	
	network:create("getIsManifestStunned", "BindableFunction", "OnInvoke", function(manifest)
		if not manifest then return false end
		local guid = utilities.getEntityGUIDByEntityManifest(manifest)
		if not guid then return false end
		
		local statuses = network:invoke("getStatusEffectsOnEntityManifestByEntityGUID", guid)
		
		for _, status in pairs(statuses) do
			if status.statusEffectType == "stunned" then
				return true
			end
		end
		
		return false
	end)
	
	spawn(int__startTickingAbilities)
end

main()

return module