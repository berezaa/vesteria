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

-- local abilityData = {
-- 	--> Identifying Information <--
-- 	id = 0;

-- 	--> Generic Information <--
-- 	name = "Test Ability";
-- 	image = "rbxassetid://2528903781";
-- 	description = "This is just a test";

-- 	--> Execution Information <--

-- 	execution = {
-- 		windupTime = 0;

-- 		animationName = "";
-- 	};

-- 	--> Combat Information <--
-- 	statistics = {
-- 		abilityType = "";
-- 		abilityTypeData = {};

-- 		damaging = false;
-- 		damage = 0;

-- 		maxLevel = 0;

-- 		manaCost = 0;
-- 		cooldown = 0;

-- 		increasingStat = "";
-- 		increaseExponent = 0;
-- 	};

-- 	--> Requirement Information <--
-- 	prerequisites = {
-- 		playerLevel = 0;
-- 		playerClass = "";

-- 		classRestriction = false;
-- 		developerOnly = false;

-- 		abilities = {};
-- 	};
-- }

-- local playerAbilityData = {
-- 	level = 1;
-- 	experience = 0;
-- }

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

-- Transplanted from player manager, needs to be integrated
local function getPlayerAbilitySlotDataById(player, abilityId)
	local playerData = playerDataContainer[player]

	if playerData then
		for i, abilitySlotData in pairs(playerData.abilities) do
			if abilitySlotData.id == abilityId then
				return abilitySlotData
			end
		end
	end

	return nil
end

local function getAbilityBookAbilityDataById(abilityBookName, abilityId)
	local abilityBookData = abilityBookLookup[abilityBookName]

	if abilityBookData then
		for i, abilityBookAbilityData in pairs(abilityBookData.abilities) do
			if abilityBookAbilityData.id == abilityId then
				return abilityBookAbilityData
			end
		end
	end

	return nil
end

local function canPlayerIncrementAbility(player, abilityId)

	local playerData = playerDataContainer[player]
	local abilityBaseData = abilityLookup[abilityId](playerData)


	if playerData and abilityBaseData then
		if abilityBaseData.prerequisite then
			local metPrerequisites = 0

			for i, abilityPrerequisiteData in pairs(abilityBaseData.prerequisite) do
				if onGetPlayerAbilityRankByAbilityId(player, abilityPrerequisiteData.id) >= abilityPrerequisiteData.rank then
					metPrerequisites = metPrerequisites + 1
				end
			end

			-- ez pz
			return metPrerequisites == #abilityBaseData.prerequisite
		else
			-- ability doesnt have any prerequisites, keep it juicy and let it go
			return true
		end
	end

	return false
end

local function incrementPlayerAbilityRank(player, abilityBookName, abilityId)
	local playerData = playerDataContainer[player]

	if playerData then
		if playerData.abilityBooks[abilityBookName] then
			local abilitySlotData = getPlayerAbilitySlotDataById(player, abilityId)
			if not abilitySlotData then
				local abilityBookAbilityData = getAbilityBookAbilityDataById(abilityBookName, abilityId)

				if abilityBookAbilityData then
					abilitySlotData = {id = abilityId; rank = 0}

					table.insert(playerData.abilities, abilitySlotData)
				else
					return false, "this should never happen"
				end
			end

			if abilitySlotData then
				local abilityBaseData = abilityLookup[abilityId](playerData)
				if canPlayerIncrementAbility(player, abilityId) then
					if (abilityBaseData.maxRank or 1) > abilitySlotData.rank then
						local remainingPoints = ability_utilities.getUnusedAbilityBookPoints(abilityBookName, playerData.level, playerData.abilityBooks[abilityBookName].pointsAssigned)

						if remainingPoints > 0 then
							playerData.abilityBooks[abilityBookName].pointsAssigned = playerData.abilityBooks[abilityBookName].pointsAssigned + 1
							abilitySlotData.rank 									= abilitySlotData.rank + 1

							playerData.nonSerializeData.playerDataChanged:Fire("abilityBooks")
							playerData.nonSerializeData.playerDataChanged:Fire("abilities")

							return true, "successfully assigned points"
						else
							return false, "not enough points"
						end
					else
						return false, "ability is max rank"
					end
				else
					return false, "ability preq not met"
				end
			else
				return false, "invalid ability"
			end
		else
			return false, "invalid ability book"
		end
	end

	return false, "invalid playerData"
end

local function getPlayerDataSpentAP(playerData)
	local spentAP = 0
	for i, abilitySlotData in pairs(playerData.abilities) do
		if abilitySlotData.rank ~= 0 then
			local abilityBaseData = abilityLookup[abilitySlotData.id](playerData)
			if abilityBaseData and abilityBaseData.metadata then
				spentAP = spentAP + abilityBaseData.metadata.cost
			end
			local upgrades = abilitySlotData.rank - 1
			if upgrades > 0 and abilityBaseData.metadata and abilityBaseData.metadata.upgradeCost then
				spentAP = spentAP + abilityBaseData.metadata.upgradeCost * upgrades
			end
			if abilitySlotData.variant then
				local variantData = abilityBaseData.metadata.variants[abilitySlotData.variant]
				spentAP = spentAP + variantData.cost
			end
		end
	end
	return spentAP
end


-- NEW ABILITY LEARNING TECHNOLOGY CHANGES THE GAME
function playerRequest_learnAbility(player, abilityId)
	local playerData = playerDataContainer[player]
	if playerData then
		local abilitySlotEntry

		for i, abilitySlotData in pairs(playerData.abilities) do
			if abilitySlotData.id == abilityId then
				-- abilitySlotData entry exists but is 0
				if abilitySlotData.rank == 0 or abilitySlotData.rank == nil then
					abilitySlotEntry = abilitySlotData
				else
					return false, "ability already learned"
				end
			end
		end

		local ability = abilityLookup[abilityId](playerData)
		if ability and ability.metadata and ability.metadata.requirement and ability.metadata.requirement(playerData) then
			local AP = playerData.level - 1
			if ability.metadata.cost <= AP - getPlayerDataSpentAP(playerData) then
				if abilitySlotEntry == nil then
					abilitySlotEntry = {id = abilityId; rank = 1}
					table.insert(playerData.abilities, abilitySlotEntry)
				end
				abilitySlotEntry.rank = 1
				playerData.nonSerializeData.playerDataChanged:Fire("abilities")
				return true, "ability learned"
			end
			return false, "not enough AP to learn"
		end
		return false, "ability cannot be learned"

	end
	return false, "invalid playerData"
end

Network:create("playerRequest_learnAbility", "RemoteFunction", "OnServerInvoke", playerRequest_learnAbility)

return module