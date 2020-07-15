-- manages items, duh
-- author: Polymorphic

local module = {}

local httpService = game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local modules = require(replicatedStorage.modules)
local network = modules.load("network")
local placeSetup = modules.load("placeSetup")
local physics = modules.load("physics")
local utilities = modules.load("utilities")
local ability_utilities = modules.load("ability_utilities")
local events = modules.load("events")
local abilityLookup = require(replicatedStorage.abilityLookup)
	
local inactiveAbilityExecutionData = {id = 0}
local inactiveAbilityExecutionData_json = httpService:JSONEncode(inactiveAbilityExecutionData)

local abilityCooldownLookup = {}

local function int__canPlayerActivateAbility(player, abilityId)
	local playerData = network:invoke("getPlayerData", player)
	
	-- currently commented out by Davidii (who also wrote it) because of a desync between
	-- the client's understanding of status effects and the server's understanding
	-- stuff's pretty wack, yo
	-- guess we can trust the client not to use abilities when stunned... right?
	
--	if network:invoke("getIsManifestStunned", player.Character and player.Character.PrimaryPart) then
--		return false
--	end
	
	if playerData and playerData.abilities then
		for _, abilitySlotData in pairs(playerData.abilities) do
			if abilitySlotData.id == abilityId and abilitySlotData.rank > 0 then
				return true
			end
		end
	end
	
	return false
end

local abilityGUIDs_Valid = {}

local function getIsAbilityDamageGUIDValid(player, abilityId, guid)
	return abilityGUIDs_Valid[player] and abilityGUIDs_Valid[player][abilityId] and abilityGUIDs_Valid[player][abilityId][guid]
end

local latencyForgiveness = 0.25
local function new__onReplicateAbilityStateChangeByPlayerRequest(player, abilityId, abilityState, abilityExecutionData, guid)
	if player.Character and player.Character.PrimaryPart and utilities.isEntityManifestValid(player.Character.PrimaryPart) then

		local playerData = network:invoke("getPlayerData", player)
		local abilityBaseData = abilityLookup[abilityId](playerData, abilityExecutionData)

		if abilityBaseData and int__canPlayerActivateAbility(player, abilityId) then
			local success, currentAbilityExecutionData = utilities.safeJSONDecode(player.Character.PrimaryPart.activeAbilityExecutionData.Value)
			
			if success then
				if abilityState == "begin" and (currentAbilityExecutionData.id == 0) then
					abilityExecutionData["ability-state"] = abilityState
					abilityExecutionData["ability-guid"] = guid

					
					local abilityStatistics = ability_utilities.getAbilityStatisticsForRank(abilityBaseData, network:invoke("getPlayerAbilityRankByAbilityId", player, abilityId))
					local manaCost = abilityStatistics.manaCost or 20
					local cooldown = (abilityStatistics.cooldown or 5)  * (1 - playerData.nonSerializeData.statistics_final.abilityCDR)
					
					-- ber edit: how were we not doing this before 2/24/20
					abilityExecutionData["ability-statistics"] = abilityStatistics
					
					-- allow abilities to inject executionData via abilityData.executionData
					if abilityBaseData.executionData then
						for key, value in pairs(abilityBaseData.executionData) do
							abilityExecutionData[key] = value
						end
					end
					
					-- fire an event and let it modify the data
					local abilityData = {
						manaCost = manaCost,
						cooldown = cooldown,
						abilityStatistics = abilityStatistics,
						abilityExecutionData = abilityExecutionData,
						abilityBaseData = abilityBaseData,
					}
					events:fireEventLocal("playerWillUseAbility", player, abilityData)
					manaCost = abilityData.manaCost
					cooldown = abilityData.cooldown
					
					if player.Character.PrimaryPart.mana.Value < manaCost then
						return false
					end
					if abilityCooldownLookup[player] and (not abilityCooldownLookup[player][abilityId] or tick() - abilityCooldownLookup[player][abilityId] >= cooldown - latencyForgiveness) then
						-- check if this ability should be enhanced (validation here)
						
						abilityExecutionData["_dex"] = playerData.nonSerializeData.statistics_final.dex or 0
						abilityExecutionData["_int"] = playerData.nonSerializeData.statistics_final.int or 0
						abilityExecutionData["_vit"] = playerData.nonSerializeData.statistics_final.vit or 0
						abilityExecutionData["_str"] = playerData.nonSerializeData.statistics_final.str or 0								
						
						if abilityBaseData._abilityExecutionDataCallback then
							abilityBaseData._abilityExecutionDataCallback(playerData, abilityExecutionData)
						end
						
						abilityExecutionData.IS_ENHANCED = abilityBaseData._doEnhanceAbility and abilityBaseData._doEnhanceAbility(playerData)
						
						local success2, abilityExecutionData_json = utilities.safeJSONEncode(abilityExecutionData)
						
						if not success2 then warn("ability:: failed to encode curr executiondata") return end
						if abilityGUIDs_Valid[player][abilityId] and abilityGUIDs_Valid[player][abilityId][guid] then warn("attempt to begin already valid guid") return false end
						
						abilityCooldownLookup[player][abilityId] = tick()
						
						
						-- open guids table for this ability
						if not abilityGUIDs_Valid[player][abilityId] then
							abilityGUIDs_Valid[player][abilityId] = {}
						end
						
						abilityGUIDs_Valid[player][abilityId][guid] = {
							executionData = abilityExecutionData;
							previousEntityHits = {};
							timestamp = tick();
							lastUpdated = tick();
							player = player;
							timesUpdated = 0;
						}
						
						player.Character.PrimaryPart.mana.Value = player.Character.PrimaryPart.mana.Value - manaCost
						player.Character.PrimaryPart.activeAbilityExecutionData.Value = abilityExecutionData_json
						
						if abilityBaseData.startAbility_server then
							spawn(function()
								abilityBaseData:startAbility_server(player, player, abilityExecutionData)
							end)
						end
						
						spawn(function()
							wait(abilityBaseData.GUID_Invalidation_Time or 10)
							
							if abilityGUIDs_Valid[player] and abilityGUIDs_Valid[player][abilityId] then
								abilityGUIDs_Valid[player][abilityId][guid] = nil
							end
						end)
						
						-- fire an event
						events:fireEventLocal("playerUsedAbility", player, abilityId, abilityExecutionData, guid)
					else
						warn("ability:: invalid cd waittime")
					end
				elseif abilityState == "update" and abilityId == currentAbilityExecutionData.id and abilityGUIDs_Valid[player] and abilityGUIDs_Valid[player][abilityId] and abilityGUIDs_Valid[player][abilityId][guid] then
					abilityExecutionData["ability-state"] = abilityState
					abilityExecutionData["ability-guid"] = guid

					if abilityGUIDs_Valid[player][abilityId][guid].timesUpdated + 1 <= (abilityBaseData.maxUpdateTimes or math.huge) then
						abilityGUIDs_Valid[player][abilityId][guid].timesUpdated = abilityGUIDs_Valid[player][abilityId][guid].timesUpdated + 1
						abilityGUIDs_Valid[player][abilityId][guid].lastUpdated = tick()
						
						abilityExecutionData["times-updated"] = abilityGUIDs_Valid[player][abilityId][guid].timesUpdated
						abilityExecutionData["last-updated"] = abilityGUIDs_Valid[player][abilityId][guid].lastUpdated
						
						local success2, abilityExecutionData_json = utilities.safeJSONEncode(abilityExecutionData)
						if not success2 then return end
						
						player.Character.PrimaryPart.activeAbilityExecutionData.Value = abilityExecutionData_json
					end
				elseif abilityState == "end" and abilityId == currentAbilityExecutionData.id then
					player.Character.PrimaryPart.activeAbilityExecutionData.Value = inactiveAbilityExecutionData_json
				else
					warn("ability:: invalid state data", abilityState, abilityId, currentAbilityExecutionData.id)
				end
			else
				warn("ability:: failed to decode current abilityexecutiondata")
			end
		else
			warn("ability:: invalid ability, cannot activate?", not not abilityBaseData)
		end
	else
		warn("ability:: invalid character")
	end
end

local function resetAbilityCooldown(player, abilityId)
	local cooldowns = abilityCooldownLookup[player]
	if not cooldowns then return end
	
	cooldowns[abilityId] = nil
	network:fireClient("abilityCooldownReset", player, abilityId)
end

local function onPlayerKilledMonster(player, monster, sourceType, sourceId)
	
	if sourceType == "ability" and abilityCooldownLookup[player] then
		local playerData = network:invoke("getPlayerData", player)
		
		-- if this causes problems figure out how to get abilityExecutionData after playerData
		local abilityBaseData = abilityLookup[sourceId](playerData)
		
		if not abilityBaseData then return end
		
		if abilityBaseData.onPlayerKilledMonster_server then
			abilityBaseData.onPlayerKilledMonster_server(player, monster)
		end
		
		if abilityBaseData.resetCooldownOnKill then
			resetAbilityCooldown(player, sourceId)
		end
	end
end

local function onPlayerAdded(player)
	abilityCooldownLookup[player] = {}
	abilityGUIDs_Valid[player] = {}
end

local function onPlayerRemoving(player)
	abilityCooldownLookup[player] = nil
	abilityGUIDs_Valid[player] = nil
end

local function getCurrentlyActiveAbilityGUIDsForPlayer(player)
	local currentlyActiveAbilityGUIDs = {}
	
	if abilityGUIDs_Valid[player] then
		for abilityId, activeAbilityGUIDsCollection in pairs(abilityGUIDs_Valid[player]) do
			for guid, isActive in pairs(activeAbilityGUIDsCollection) do
				if isActive then
					table.insert(currentlyActiveAbilityGUIDs, abilityId)
					
					break
				end
			end
		end
	end
	
	return currentlyActiveAbilityGUIDs
end

local function onAbilityExecuteServerCall(player, abilityExecutionData, abilityId, ...)
	local castPlayerUserId = abilityExecutionData["cast-player-userId"]
	local castPlayer = abilityExecutionData["cast-player-userId"] and game.Players:GetPlayerByUserId(abilityExecutionData["cast-player-userId"])
	if castPlayer then
		if castPlayer.Character and castPlayer.Character.PrimaryPart then
			local successAAED, activeAbilityExecutionData = utilities.safeJSONDecode(castPlayer.Character.PrimaryPart.activeAbilityExecutionData.Value)
			if successAAED then
				local playerData = network:invoke("getPlayerData", player)
				local ability = abilityLookup[abilityId](playerData, activeAbilityExecutionData)
				if activeAbilityExecutionData.id == abilityId and ability and ability.execute_server then
					return ability:execute_server(castPlayer, activeAbilityExecutionData, castPlayer == player, ...)
				end
			end
		end
	end
end

local function onAbilityExecuteServerCall_server()
	
end

local function onAbilityDealtDamageToEntity(player, abilityId, guid, entityManifest, sourceTag)
	if abilityGUIDs_Valid[player] and abilityGUIDs_Valid[player][abilityId] and abilityGUIDs_Valid[player][abilityId][guid] then
		local previousData do
			for i, data in pairs(abilityGUIDs_Valid[player][abilityId][guid].previousEntityHits) do
				if data.entityManifest == entityManifest then
					previousData = data
				end
			end
		end
		
		if previousData then
			table.insert(previousData.hitData, {
				hitPosition = entityManifest.Position;
				sourceTag = sourceTag;
			})
		else
			table.insert(abilityGUIDs_Valid[player][abilityId][guid].previousEntityHits, {
				entityManifest = entityManifest;
				hitData = {
					{
						hitPosition = entityManifest.Position;
						sourceTag = sourceTag;
					}
				}
			})
		end
	end
end

local function onInvalidateAbilityGUID(player, abilityId, guid)
	if abilityGUIDs_Valid[player] and abilityGUIDs_Valid[player][abilityId] and abilityGUIDs_Valid[player][abilityId][guid] then
		abilityGUIDs_Valid[player][abilityId][guid] = nil
	end
end

local function onPlayerRequestAbilityHitEntity(player, abilityId, abilityGUID, entityManifestHit, sourceTag)
	local playerData = network:invoke("getPlayerData", player)
	
	-- if this causes problems, add abilityExecutionData after playerData
	local abilityBaseData = abilityLookup[abilityId](playerData)
	
	if abilityBaseData and int__canPlayerActivateAbility(player, abilityId) then
		local abilityStatistics = ability_utilities.getAbilityStatisticsForRank(abilityBaseData, network:invoke("getPlayerAbilityRankByAbilityId", player, abilityId))
		if abilityBaseData._serverProcessAbilityHit then
			abilityBaseData._serverProcessAbilityHit(player, abilityStatistics, abilityGUID, entityManifestHit, sourceTag)
		else
			network:fire("playerRequest_damageEntity_server", player, entityManifestHit, nil, "ability", abilityId, sourceTag, abilityGUID)
		end
	end
end

local function main()
	for i, player in pairs(game.Players:GetPlayers()) do
		onPlayerAdded(player)
	end
	
	game.Players.PlayerAdded:connect(onPlayerAdded)
	game.Players.PlayerRemoving:connect(onPlayerRemoving)
	
	network:create("playerRequest_abilityHitEntity", "RemoteEvent", "OnServerEvent", onPlayerRequestAbilityHitEntity)
	
	network:create("replicateAbilityStateChangeByPlayer", "RemoteEvent", "OnServerEvent", function(player, abilityId, abilityState, abilityExecutionData, guid)
		if typeof(abilityState) == "boolean" then
			new__onReplicateAbilityStateChangeByPlayerRequest(player, abilityId, abilityState and "begin" or "end", abilityExecutionData, guid)
		elseif typeof(abilityState) == "string" then
			new__onReplicateAbilityStateChangeByPlayerRequest(player, abilityId, abilityState, abilityExecutionData, guid)
		end
	end)

	network:create("getIsAbilityDamageGUIDValid", "BindableFunction", "OnInvoke", getIsAbilityDamageGUIDValid)
	network:create("getAbilityStatisticsForRank", "BindableFunction", "OnInvoke", ability_utilities.getAbilityStatisticsForRank)
	network:create("getCurrentlyActiveAbilityGUIDsForPlayer", "BindableFunction", "OnInvoke", getCurrentlyActiveAbilityGUIDsForPlayer)
	network:create("abilityCooldownReset", "RemoteEvent")
	network:create("abilityCooldownReset_server", "BindableFunction", "OnInvoke", resetAbilityCooldown)
	network:create("abilityDealtDamageToEntity", "BindableEvent", "Event", onAbilityDealtDamageToEntity)
	network:create("invalidateAbilityGUID", "BindableFunction", "OnInvoke", onInvalidateAbilityGUID)
	network:connect("playerKilledMonster", "Event", onPlayerKilledMonster)
	
	network:create("abilityExecuteServerCall", "RemoteFunction", "OnServerInvoke", onAbilityExecuteServerCall)
	network:create("abilityExecuteServerCall_server", "RemoteFunction", "OnServerInvoke", onAbilityExecuteServerCall_server)
	
	network:create("abilityInvokeServerCall", "RemoteFunction", "OnServerInvoke", onAbilityExecuteServerCall)
	network:create("abilityFireServerCall", "RemoteEvent", "OnServerEvent", onAbilityExecuteServerCall)
	network:create("abilityInvokeClientCall", "RemoteFunction")
	network:create("abilityFireClientCall", "RemoteEvent")
	
	network:create("abilityTargetingSequenceStarted", "RemoteEvent", "OnServerEvent", function(player, ...)
		network:fireAllClientsExcludingPlayer("abilityTargetingSequenceStarted", player, ...)
	end)
	
	network:create("abilityTargetingSequenceEnded", "RemoteEvent", "OnServerEvent", function(player, ...)
		network:fireAllClientsExcludingPlayer("abilityTargetingSequenceEnded", player, ...)
	end)
end

spawn(main)

return module