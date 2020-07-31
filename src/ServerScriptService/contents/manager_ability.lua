local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AbilityLookup = require(ReplicatedStorage.abilityLookup)

local abilityCooldownLookup = {}
local castedAbilityGUIDs = {}
--local cachedPlayerAbilityData = {}

local latencyForgiveness = 0.25
local maximumAbilityRenderDistance = 100

local network
local utilities
local abilityUtilities


-------------------------------------------------
---------------@ Core Functions @----------------
-------------------------------------------------

local function onPlayerAdded(player)
	abilityCooldownLookup[player] = {}
	castedAbilityGUIDs[player] = {}

	local playerData = network:invoke("getPlayerData", player)
	playerData.abilities[1] = {
		level = 1;
		experience = 0;
		id = 1;
	}

	playerData.abilities[2] = {
		level = 1;
		experience = 0;
		id = 2;
	}

	playerData.nonSerializeData.setPlayerData("abilities", playerData.abilities)
end

local function onPlayerRemoving(player)
	abilityCooldownLookup[player] = nil
end

local function validateAbilityGUID(player, abilityID, guid)
	if castedAbilityGUIDs[player] and castedAbilityGUIDs[player][abilityID] and castedAbilityGUIDs[player][abilityID][guid] then
		return castedAbilityGUIDs[player][abilityID][guid]
	end

	return false
end

local function resetAbilityCooldown(player, abilityID)
	if abilityCooldownLookup[player] ~= nil and abilityCooldownLookup[player][abilityID] ~= nil then
		abilityCooldownLookup[player][abilityID] = nil
	end
end

local function returnAbilityCooldown(player, abilityID)
	if not abilityCooldownLookup[player] then return nil end
	if not abilityCooldownLookup[player][abilityID] then return nil end

	return abilityCooldownLookup[player][abilityID]
end

-------------------------------------------------
-------------@ Bindable Functions @--------------
-------------------------------------------------


-------------------------------------------------
--------------@ Remote Functions @---------------
-------------------------------------------------

--onUpdate Event
local function changeAbilityState(caster, requestedState, executionData)
	local casterContainer = executionData.casterCharacter
	if not casterContainer or not casterContainer.PrimaryPart or not utilities.isEntityManifestValid(casterContainer.PrimaryPart) then return "invalid_character" end

	local serverExecuteTick = tick()
	local casterData = nil

	local player = game.Players:GetPlayerFromCharacter(casterContainer)
	if player then
		casterData = network:invoke("getPlayerData", player)
	else
		--Get Monsters Data Here
	end

	local abilityId = executionData.abilityId
	local guid = executionData.abilityGuid
	local abilityData = AbilityLookup[abilityId]

	if not casterData or not abilityData then return "failed" end

	----@ BEGIN STATE @----
	if requestedState == "begin" then
		if castedAbilityGUIDs[player][abilityId] == nil then
			executionData["state"] = requestedState
			executionData["guid"] = guid

			local manaCost = abilityData.statistics.manaCost
			local cooldown = abilityData.statistics.cooldown

			--Get player level, add the exponent and calculate ability modifier TODO
			executionData["abilityData"] = abilityData

			local increasingStat, calculatedStat = abilityUtilities.calculateStats(casterData, abilityId)
			if increasingStat and calculatedStat then
				executionData["abilityData"][increasingStat] = calculatedStat
			end

			local canCast, error = abilityUtilities.canPlayerCast(player, casterData, abilityId)
			if not canCast then
				return canCast, error
			end

			if castedAbilityGUIDs[player][abilityId] and castedAbilityGUIDs[player][abilityId][guid] then return false, "already_begun" end
			castedAbilityGUIDs[player][abilityId] = {}
			castedAbilityGUIDs[player][abilityId][guid] = true

			----@ ABILITY CAN BE CASTED @----

			--Remove ManaCost from Players Mana
			player.Character.PrimaryPart.mana.Value = (player.Character.PrimaryPart.mana.Value - manaCost)

			--Calculate Cooldown Tick from Server vs Client
			local clientTick = executionData.castTick
			abilityCooldownLookup[player][abilityId] = serverExecuteTick

			-- Cast Ability Server Side
			abilityData:execute_server()

			--Send Ability Cast to Clients
			local nearbyPlayers = abilityUtilities.returnNearbyPlayers(player.Character.PrimaryPart.CFrame, maximumAbilityRenderDistance)
			if nearbyPlayers then
				network:fireClients("replicateAbilityLocally", nearbyPlayers, executionData, false)
			end

			--@ ABILITY BEGIN ENDED @--
		else
			warn("Ability already casted, player is attempting to re-cast from remote. Possible Exploiter or False Positive")
		end

	----@ UPDATE STATE @----
	elseif requestedState == "update" then
		if validateAbilityGUID(player, abilityId, guid) then
			executionData["abilityData"] = abilityData

			local increasingStat, calculatedStat = abilityUtilities.calculateStats(casterData, abilityId)
			if increasingStat and calculatedStat then
				executionData["abilityData"][increasingStat] = calculatedStat
			end

			-- Cast Ability Server Side
			abilityData:execute_server_update()

			--Send Ability Cast to Clients
			local nearbyPlayers = utilities.returnNearbyPlayers(player.Character.PrimaryPart.CFrame, maximumAbilityRenderDistance)
			if nearbyPlayers then
				network:fireClients("replicateAbilityUpdateLocally", nearbyPlayers, executionData, false)
			end
		else
			return false, "invalid_guid"
		end

	----@ END STATE @----
	elseif requestedState == "end" then
		if castedAbilityGUIDs[player][abilityId] ~= nil and castedAbilityGUIDs[player][abilityId][guid] ~= nil then
			castedAbilityGUIDs[player][abilityId] = nil
		end
	end
end
-------------------------------------------------
----------------@ Main Function @----------------
-------------------------------------------------

function module.init(Modules)
	network = Modules.network
	utilities = Modules.utilities
	abilityUtilities = Modules.abilityUtilities

	--Register Player Added and Remove Functions Defined Above
	network:connect("playerDataLoaded", "Event", onPlayerAdded)
	game.Players.PlayerRemoving:Connect(onPlayerRemoving)

	--Register all functions as network events/functions
	network:create("requestAbilityStateUpdate", "RemoteEvent", "OnServerEvent", changeAbilityState)
	network:create("validateAbilityGUID", "BindableFunction", "OnInvoke", validateAbilityGUID)
	network:create("resetAbilityCooldown", "BindableEvent", "Event", resetAbilityCooldown)
	network:create("requestAbilityCooldown", "RemoteFunction", "OnServerInvoke", returnAbilityCooldown)
	network:create("returnAbilityCooldown", "BindableFunction", "OnInvoke", returnAbilityCooldown)
end

return module