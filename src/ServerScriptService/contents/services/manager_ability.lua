local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = require(ReplicatedStorage.modules)
local Network = Modules.load("network")
local Utilities = Modules.load("utilities")
local AbilityUtilities = Modules.load("ability_utilities")
local AbilityLookup = require(ReplicatedStorage.abilityLookup)

local abilityCooldownLookup = {}
local castedAbilityGUIDs = {}
--local cachedPlayerAbilityData = {}

local latencyForgiveness = 0.25
local maximumAbilityRenderDistance = 100

-------------------------------------------------
---------------@ Core Functions @----------------
-------------------------------------------------

local function onPlayerAdded(player)
	if player.userId then
		abilityCooldownLookup[player] = {}
	end
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

-------------------------------------------------
-------------@ Bindable Functions @--------------
-------------------------------------------------


-------------------------------------------------
--------------@ Remote Functions @---------------
-------------------------------------------------

--onUpdate Event
local function changeAbilityState(casterContainer, requestedState, executionData)
	local serverExecuteTick = tick()
	if not casterContainer or not casterContainer.PrimaryPart or not Utilities.isEntityManifestValid(casterContainer.PrimaryPart) then return "invalid_character" end

	local casterData = nil

	local player = game.Players:GetPlayerFromCharacter(casterContainer)
	if player then
		casterData = Network:invoke("getPlayerData", player)
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

			local increasingStat, calculatedStat = AbilityUtilities.calculateStats(casterData, abilityId)
			if increasingStat and calculatedStat then
				executionData["abilityData"][increasingStat] = calculatedStat
			end

			if player.Character.PrimaryPart.mana.Value < manaCost then return false, "lacking_mana" end
			if abilityCooldownLookup[player] and (not abilityCooldownLookup[player][abilityId] or (tick() - abilityCooldownLookup[player][abilityId]) >= (cooldown - latencyForgiveness)) then return false, "on_cooldown" end

			if castedAbilityGUIDs[player][abilityId] and castedAbilityGUIDs[player][abilityId][guid] then return false, "already_begun" end

			----@ ABILITY CAN BE CASTED @----

			--Remove ManaCost from Players Mana
			player.Character.PrimaryPart.mana.Value = (player.Character.PrimaryPart.mana.Value - manaCost)

			--Calculate Cooldown Tick from Server vs Client
			local clientTick = executionData.castTick()
			abilityCooldownLookup[player][abilityId] = serverExecuteTick

			-- Cast Ability Server Side
			abilityData:execute_server()

			--Send Ability Cast to Clients
			local nearbyPlayers = Utilities.returnNearbyPlayers(player.Character.PrimaryPart.CFrame, maximumAbilityRenderDistance)
			if nearbyPlayers then
				Network:fireClients("replicateAbilityLocally", nearbyPlayers, executionData, false)
			end

			--@ ABILITY BEGIN ENDED @--
		else
			warn("Ability already casted, player is attempting to re-cast from remote. Possible Exploiter or False Positive")
		end

	----@ UPDATE STATE @----
	elseif requestedState == "update" then
		if validateAbilityGUID(player, abilityId, guid) then
			executionData["abilityData"] = abilityData

			local increasingStat, calculatedStat = AbilityUtilities.calculateStats(casterData, abilityId)
			if increasingStat and calculatedStat then
				executionData["abilityData"][increasingStat] = calculatedStat
			end

			-- Cast Ability Server Side
			abilityData:execute_server_update()

			--Send Ability Cast to Clients
			local nearbyPlayers = Utilities.returnNearbyPlayers(player.Character.PrimaryPart.CFrame, maximumAbilityRenderDistance)
			if nearbyPlayers then
				Network:fireClients("replicateAbilityUpdateLocally", nearbyPlayers, executionData, false)
			end
		else
			return false, "invalid_guid"
		end

	----@ END STATE @----
	elseif requestedState == "end" then
		if castedAbilityGUIDs[player][abilityId][guid] ~= nil then
			castedAbilityGUIDs[player][abilityId][guid] = nil
		end
	end
end
-------------------------------------------------
----------------@ Main Function @----------------
-------------------------------------------------

local function main()
	--Register Player Added and Remove Functions Defined Above
	game.Players.PlayerAdded:Connect(onPlayerAdded)
	game.Players.PlayerRemoving:Connect(onPlayerRemoving)

	--Register all functions as network events/functions
	Network:create("requestAbilityStateUpdate", "RemoteEvent", "OnServerEvent", changeAbilityState)
	Network:create("validateAbilityGUID", "RemoteFunction", "OnServerInvoke", validateAbilityGUID)
	Network:create("resetAbilityCooldown", "BindableEvent", "Event", resetAbilityCooldown)
end

spawn(main)

return module