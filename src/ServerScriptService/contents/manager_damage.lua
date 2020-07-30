local module = {}

local debris = game:GetService("Debris")
local httpService = game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local modules = require(replicatedStorage.modules)
local network = modules.load("network")
local placeSetup = modules.load("placeSetup")
local physics = modules.load("physics")
local utilities = modules.load("utilities")
local mapping = modules.load("mapping")
local levels = modules.load("levels")
local damage = modules.load("damage")
local detection = modules.load("detection")
local configuration = modules.load("configuration")
local projectile = modules.load("projectile")
local events = modules.load("events")

local serverStorage 		= game:GetService("ServerStorage")
local itemLookupContainer 	= replicatedStorage.itemData
local itemLookup 			= require(itemLookupContainer)
local itemFolderLookup = replicatedStorage.assets:WaitForChild("items")
local perkLookup			= require(replicatedStorage.perkLookup)
local abilityLookup 		= require(replicatedStorage.abilityLookup)
local monsterLookup 		= require(replicatedStorage.monsterLookup)

local entityManifestCollectionFolder = placeSetup.getPlaceFolder("entityManifestCollection")

local rand 				= Random.new()
local critChanceRandom 	= Random.new()
local dodgeChanceRandom = Random.new()

local monsterDamageValidationData 	= {}
local weaponValidationData 			= {}
local playerDamageAnimationState 	= {}
local arrowsShotByPlayers 			= {}
local playerAbilityHitData 			= {}
local magicBallsByPlayer 			= {}

local WEAPON_TYPES_TO_SCAN 	= {"dagger"; "staff"; "sword"; "greatsword"; "dual"; "swordAndShield"}
local SAMPLE_POINTS_TO_TAKE = 5

-- how long client has to call for damage of an arrow
-- note: lifetime of projectile is 3 sec, but allow some latency!
local ARROW_DATA_MAX_LIFETIME = 3.5

-- time players have to chain another slash
local SLASH_CHAIN_WINDOW 	= 0.3

-- 125 ms forgiveness
local DAMAGE_ANIMATION_REQUEST_MISMATCH_LATENCY_FORGIVENESS = 0.125

local CRIT_DAMAGE_MULTIPLIER = 2

-- base value to decide how effective defensive stats are (VIT + DEX)
local DEFENSE_MODULATOR = 100

local getDamageMitigationByVIT do
	-- note for the future: THIS MUST BE IN ORDER (INDEX WISE) BY ORDER OF THRESHOLDS FROM GREATEST TO LEAST!!!!
	local thresholds = {
		{threshold = 1.0; value = 0.0 / 3};
		{threshold = 0.4; value = 0.5 / 3};
		{threshold = 0.2; value = 1.0 / 3};
		{threshold = 0.1; value = 2.0 / 3}
	}

	local function getThresholdForRatio(ratio)
		local currThreshold
		for i, mitigationData in ipairs(thresholds) do
			if not currThreshold or ratio <= mitigationData.threshold then
				currThreshold 	= mitigationData.threshold
			else
				break
			end
		end

		return currThreshold
	end

	local function getNextThreshold(threshold)
		for i, mitigationData in ipairs(thresholds) do
			if mitigationData.threshold == threshold then
				return thresholds[i + 1] and thresholds[i + 1].threshold
			end
		end

		return nil
	end

	local function getPreviousThreshold(threshold)
		for i, mitigationData in ipairs(thresholds) do
			if mitigationData.threshold == threshold then
				return thresholds[i - 1] and thresholds[i - 1].threshold
			end
		end

		return nil
	end

	function getDamageMitigationByVIT(currentHealth, maxHealth, damageBeingDone, vit)
		local startRatio = math.clamp(currentHealth / maxHealth, 0, 1)
			local startRatioThreshold = getThresholdForRatio(startRatio)
		local damageRatio = math.clamp((currentHealth - damageBeingDone) / maxHealth, 0, 1)
			local damageRatioThreshold = getThresholdForRatio(damageRatio)

		local healthAfterDamage = math.clamp(currentHealth - damageBeingDone, 0, maxHealth)

		local thresholdsPassed = {}
		for i, mitigationData in ipairs(thresholds) do
			if mitigationData.threshold <= startRatioThreshold and mitigationData.threshold >= damageRatioThreshold then
				table.insert(thresholdsPassed, {threshold = mitigationData.threshold; damageMarker = mitigationData.threshold * maxHealth; value = mitigationData.value})
			end
		end

		local healthRemaining 	= currentHealth
		local damageRemaining 	= damageBeingDone
		local damageMitigation 	= 0
		local vitRemaining 		= vit

		for i = #thresholdsPassed, 1, -1 do
			local mitigationData = thresholdsPassed[i]

			if vitRemaining > 0 then
				if i == #thresholdsPassed then
					-- this is processed first since we're doing it reverse order
					local healthInThisThreshold = math.abs(maxHealth * mitigationData.threshold - (currentHealth - damageBeingDone))
					local vitConsumed = math.clamp(healthInThisThreshold / mitigationData.value, 0, vitRemaining)

					vitRemaining 		= vitRemaining - vitConsumed
					damageMitigation 	= damageMitigation + vitConsumed * mitigationData.value
				elseif i == 1 then
					-- this is processed last since we're doing reverse order
					local nextThreshold = getNextThreshold(mitigationData.threshold)
					local healthInThisThreshold = currentHealth - maxHealth * nextThreshold
					local vitConsumed = math.clamp(healthInThisThreshold / mitigationData.value, 0, vitRemaining)

					vitRemaining 		= vitRemaining - vitConsumed
					damageMitigation 	= damageMitigation + vitConsumed * mitigationData.value
				else
					local nextThreshold = getNextThreshold(mitigationData.threshold)
					local healthInThisThreshold = mitigationData.threshold * maxHealth - nextThreshold * maxHealth
					local vitConsumed = math.clamp(healthInThisThreshold / mitigationData.value, 0, vitRemaining)

					vitRemaining 		= vitRemaining - vitConsumed
					damageMitigation 	= damageMitigation + vitConsumed * mitigationData.value
				end
			end
		end

		local damageBeingDonePostMitigation = math.clamp(damageBeingDone - damageMitigation, 0, math.huge)

		return damageMitigation
	end
end

local perksMaid = {} do
	function perksMaid:isEquipmentPerkActivable(playerData, id)

	end

	function perksMaid:flagPerkAsActivated(player, id)

	end
end

network:create("playerKilledByPlayer", "BindableEvent")
network:create("signal_playerKilledByPlayer", "RemoteEvent")

-- called when killing damage is applied to any entity
local function processEntityKillingBlow(serverHitbox, killer, damageData)
	print("X_X")
	local killedMonster
	local killedPlayer
	if serverHitbox.entityType.Value == "monster" then
		killedMonster = network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox)
	elseif serverHitbox.entityType.Value == "character" then
		killedPlayer = game.Players:GetPlayerFromCharacter(serverHitbox.Parent)
	end

	if killer == nil then
		return
	end

	local sourcePlayer
	if killer.entityType.Value == "character" then
		sourcePlayer = game.Players:GetPlayerFromCharacter(killer.Parent)
	end

	local sendNotification = true

	if killedPlayer or (killedMonster and (killedMonster.boss or killedMonster.resilient or killedMonster.giant or killedMonster.superGiant or killedMonster.gigaGiant)) then

		local possibleVerbs = {"defeated", "felled", "purged", "vanquished", "ended", "wiped", "finished"}
		if serverHitbox and serverHitbox:FindFirstChild("maxHealth") and damageData.damage >= serverHitbox.maxHealth.Value * 0.5 then
			possibleVerbs = {"absolutely obliterated", "completely demolished", "undeniably destroyed", "OOF`d"}
		elseif damageData.damageType == "magical" then
			possibleVerbs = {"disintegrated", "melted", "burned to a crisp", "blasted", "vaporized"}
		elseif damageData.damageType == "ranged" then
			possibleVerbs = {"sniped", "popped", "silenced", "struck"}
		end

		local verb = possibleVerbs[rand:NextInteger(1,#possibleVerbs)]
		verb = verb or "defeated"

		if damageData.isCritical then
			verb = "critically "..verb
		end

		if killer then
			local killerName = "???"
			if killer.entityType.Value == "character" then
				killerName = killer.Parent.Name
			elseif killer.entityType.Value == "monster" then
				killerName = killer.Name
				local monster = network:invoke("getMonsterDataByMonsterManifest_server", killer)

				if not monster then
					return
				end

				if monster.specialName then
					killerName = monster.specialName
				end
				if monster.gigaGiant then
					killerName = "Colossal " .. killerName
				elseif monster.superGiant then
					killerName = "Super Giant " .. killerName
				elseif monster.giant then
					killerName = "Giant " .. killerName
				end
			end

			if killer.state.Value == "dead" or killer.health.Value <= 0 or killer.Parent == nil then
				killerName = "the late " .. killerName
			end

			local killedName
			if killedPlayer then
				killedName = killedPlayer.Name
			elseif killedMonster then
				killedName = serverHitbox.Name
				if killedMonster.specialName then
					killedName = killedMonster.specialName
				end
				if killedMonster.gigaGiant then
					killedName = "Colossal " .. killedName
				elseif killedMonster.superGiant then
					killedName = "Super Giant " .. killedName
				elseif killedMonster.giant then
					killedName = "Giant " .. killedName
				end
			end

			local text = "☠ " .. killedName .. " was " .. verb .. " by "..killerName.." ☠"

			-- i just killed myself... should i be doing something different?
			if sourcePlayer and killedPlayer and sourcePlayer == killedPlayer then
				local deathTrapKillMessage = sourcePlayer:FindFirstChild("deathTrapKillMessage")
				if deathTrapKillMessage then
					sendNotification = false

					text = deathTrapKillMessage.Value
					deathTrapKillMessage:Destroy()
				end
			end

			network:fireAllClients("signal_alertChatMessage", {
				Text = text,
				Font = Enum.Font.SourceSansBold,
				Color = killedPlayer and Color3.fromRGB(255, 130, 100) or Color3.fromRGB(0, 255, 170),
			})
		end

		if sendNotification and killer.entityType.Value == "character" and killedPlayer then
			network:fire("playerKilledByPlayer", killedPlayer, sourcePlayer, damageData)
			if game.PlaceId == 2103419922 then
				-- level up on kill (Fight to survive!)
				local killedData = network:invoke("getPlayerData", killedPlayer)
				local gold = (killedData and killedData.gold or 0) + (killedData and killedData.level or 1) * 100
				local playerData = network:invoke("getPlayerData", sourcePlayer)
				local expForNextLevel = levels.getEXPToNextLevel(playerData.level)
				playerData.nonSerializeData.incrementPlayerData("exp", expForNextLevel + 1)
				pcall(function()
					if playerData.level == 10 then

						game.BadgeService:AwardBadge(sourcePlayer.userId, 2124528259)

						network:fireAllClients("signal_alertChatMessage", {
							Text = sourcePlayer.Name .. " is in purgatory.",
							Font = Enum.Font.SourceSansBold,
							Color = Color3.fromRGB(200, 200, 100),
						})
					elseif playerData.level == 100 then
						game.BadgeService:AwardBadge(sourcePlayer.userId, 2124528261)

						network:fireAllClients("signal_alertChatMessage", {
							Text = sourcePlayer.Name .. " is ALIVE!",
							Font = Enum.Font.SourceSansBold,
							Color = Color3.fromRGB(150, 255, 30),
						})
						sourcePlayer:Kick("YOU ARE ALIVE!")
					end
				end)
				playerData.nonSerializeData.incrementPlayerData("gold", gold)
			end
			network:fireAllClients("signal_playerKilledByPlayer", killedPlayer, sourcePlayer, damageData, verb)
		end
	end
end

network:create("entityKillingBlow", "BindableEvent", "Event", processEntityKillingBlow)

-- monster is dealing damage to a player
-- player is dealing damage to a player
-- monster is dealing damage to a monster
-- todo: clean this up, doesnt make sense what this handles.
local function playerDamageRequest_server(sourcePlayer, serverHitbox, damageData)
	if not serverHitbox:FindFirstChild("health") or not serverHitbox:FindFirstChild("maxHealth") then return false end

	-- sourcePlayer, serverHitbox, damageToDeal, sourceType, sourceId
	if serverHitbox.health.Value > 0 and serverHitbox:FindFirstChild("killingBlow") == nil then
		local player = game.Players:GetPlayerFromCharacter(serverHitbox.Parent)
		if player then
			events:fireEventLocal("playerWillTakeDamage", player, damageData)
		end

		events:fireEventLocal("entityWillDealDamage", sourcePlayer, serverHitbox, damageData)

		local newHealth = serverHitbox.health.Value - damageData.damage

		if newHealth <= 0 then

			local killerGUID = damageData.sourceEntityGUID
--			print("$",killerGUID)
			local killer = utilities.getEntityManifestByEntityGUID(killerGUID)
--			print("$", killer)

			local killingBlowTag 	= Instance.new("StringValue")
			killingBlowTag.Name 	= "killingBlow"
			killingBlowTag.Value 	= "damage"

			local killingBlowSource = Instance.new("ObjectValue")
			killingBlowSource.Name 	= "source"
			killingBlowSource.Value = killer
			killingBlowSource.Parent = killingBlowTag

			killingBlowTag.Parent = serverHitbox
			processEntityKillingBlow(serverHitbox, killer, damageData)
		end

		serverHitbox.health.Value = newHealth

		if serverHitbox.health.Value <= 0 then
			events:fireEventLocal("entityDiedTakingDamage", sourcePlayer, serverHitbox, damageData)


		end

		network:fireAllClients("signal_damage", serverHitbox, damageData)
	end

	return true
end

local function isWithinBounds(value, b1, b2, atkspd)
	atkspd = atkspd or 1

	return value / atkspd >= b1 / atkspd and value / atkspd <= b2 / atkspd
end

-- handles the processing for damageRequests made by non-bow weapons

-- ber: removed for causing issues with fast attack speeds
-- TODO: calculate a rolling average of damage requests and punish if its too high

local function isPlayerEquipmentDamageRequestWithinAnimationDamageSequence(player, serverHitbox)
	return true
	--[[
	local currentPlayerDamageAnimationState = playerDamageAnimationState[player]
	local playerData = network:invoke("getPlayerData", player)

	if currentPlayerDamageAnimationState then
		if weaponValidationData[currentPlayerDamageAnimationState.weaponType] then
			if not currentPlayerDamageAnimationState.damageBlacklist[serverHitbox] then
				local success = isWithinBounds(
					tick() - currentPlayerDamageAnimationState.timestamp,
					weaponValidationData[currentPlayerDamageAnimationState.weaponType][currentPlayerDamageAnimationState.state .. "_startDamageSequence_time"] - DAMAGE_ANIMATION_REQUEST_MISMATCH_LATENCY_FORGIVENESS,
					weaponValidationData[currentPlayerDamageAnimationState.weaponType][currentPlayerDamageAnimationState.state .. "_stopDamageSequence_time"] + DAMAGE_ANIMATION_REQUEST_MISMATCH_LATENCY_FORGIVENESS,
					1 + playerData.nonSerializeData.statistics_final.attackSpeed
				)

				-- blacklist damaging this hitbox
				if success then
					currentPlayerDamageAnimationState.damageBlacklist[serverHitbox] = true
				end

				return success
			end
		end
	else
		return true
	end
	return false
	]]
end

local function isMagicBallDataUsableForDamageRequest(magicBallData, playerPositionAtDamageRequestTime, targetPositionAtDamageRequestTime)
	if tick() - magicBallData.timestamp >= ARROW_DATA_MAX_LIFETIME then return false end

	local playerPositionFromServerAtFiring = magicBallData.serverCharacterPosition
	local playerPositionFromClientAtFiring = magicBallData.executionData["cast-origin"]

	local unitDirection, targetPositionFromClientPredictive = projectile.getUnitVelocityToImpact_predictiveByAbilityExecutionData(
		playerPositionFromClientAtFiring,
		magicBallData.sourceWeaponBaseData.projectileSeeed or 50,
		magicBallData.executionData,
		0.0001
	)

	local degreesOffPredictedCourse = math.deg(math.acos(((targetPositionAtDamageRequestTime - playerPositionFromClientAtFiring).unit):Dot(unitDirection.unit)))
	local degreesOffPredictedCourse2 = math.deg(math.acos(((targetPositionFromClientPredictive - playerPositionFromClientAtFiring).unit):Dot(unitDirection.unit)))
	local degreesOffPredictedCourse3 = math.deg(math.acos(((targetPositionFromClientPredictive * Vector3.new(1, 0, 1) - playerPositionFromClientAtFiring * Vector3.new(1, 0, 1)).unit):Dot((unitDirection * Vector3.new(1, 0, 1)).unit)))

	-- accept if its within 7 degrees off of perfect
	return degreesOffPredictedCourse2 <= 7
end

local function isArrowDataUsableForDamageRequest(arrowData, playerPositionAtDamageRequestTime, targetPositionAtDamageRequestTime)
	if tick() - arrowData.timestamp >= ARROW_DATA_MAX_LIFETIME then return false end

	local playerPositionFromServerAtFiring = arrowData.serverCharacterPosition
	local playerPositionFromClientAtFiring = arrowData.executionData["cast-origin"]

	local unitDirection, targetPositionFromClientPredictive = projectile.getUnitVelocityToImpact_predictiveByAbilityExecutionData(
		playerPositionFromClientAtFiring,
		(arrowData.sourceWeaponBaseData.projectileSeeed or 200) * math.clamp(arrowData.executionData.bowChargeTime / configuration.getConfigurationValue("maxBowChargeTime"), 0.1, 1),
		arrowData.executionData,
		false
	)

	local degreesOffPredictedCourse = math.deg(math.acos(((targetPositionAtDamageRequestTime - playerPositionFromClientAtFiring).unit):Dot(unitDirection.unit)))
	local degreesOffPredictedCourse2 = math.deg(math.acos(((targetPositionFromClientPredictive - playerPositionFromClientAtFiring).unit):Dot(unitDirection.unit)))
	local degreesOffPredictedCourse3 = math.deg(math.acos(((targetPositionFromClientPredictive * Vector3.new(1, 0, 1) - playerPositionFromClientAtFiring * Vector3.new(1, 0, 1)).unit):Dot((unitDirection * Vector3.new(1, 0, 1)).unit)))

	-- accept if its within 7 degrees off of perfect
	return degreesOffPredictedCourse2 <= 7
end

local function calculatePlayerDamage(player, damageType, targetLevel, isTargetPlayer)
	local playerData = network:invoke("getPlayerData", player)

	local levelDifference 		= (playerData.level or 0) - targetLevel
	local levelMulti 			= math.clamp((10 + (levelDifference/2)) / 10,0.2,2)
	local damageRangeMultiplier = rand:NextInteger(95, 105) / 100
	local stats 				= playerData.nonSerializeData.statistics_final

	-- pvp has no level difference multiplier
	-- very unfair with level differences otherwise.
	if isTargetPlayer and configuration.getConfigurationValue("doNotApplyLevelMultiToPVP", player) then
		levelMulti = 1
	end

	local damage = stats[damageType .. "Damage"]

	return math.ceil(damage * levelMulti * damageRangeMultiplier)

	--local damageToDealToMonster = math.floor((stats.equipmentDamage or 1) * levelMulti * damageRangeMultiplier) + stats.str
end

local arrowMultiHitCache = {}

local function playerRequest_damageEntity(player, serverHitbox, damagePosition, sourceType, sourceId, sourceTag, guid)
	local playerData = network:invoke("getPlayerData", player)
	if not playerData then
		return false
	end
	local stats = playerData.nonSerializeData.statistics_final
	if player.Character and player.Character.PrimaryPart and playerData and serverHitbox and (serverHitbox:IsDescendantOf(entityManifestCollectionFolder) or serverHitbox:IsDescendantOf(entityManifestCollectionFolder)) then
		-- can this person even attack the target...?
		if sourceType ~= "monster" and not damage.canPlayerDamageTarget(player, serverHitbox) then
			return false
		end

		if serverHitbox:FindFirstChild("isDamageImmune") and serverHitbox.isDamageImmune.Value then
			return false
		end
		local damageData, attackerStats, defenderStats
		local isServerHitboxPlayer = (serverHitbox.entityType.Value == "character")
		local abilityDamageMulti = 1
		local hitsDoneToEntityManifestBySourceTag = 0

		local isPlayerAttacker

		if sourceType == "ability" or sourceType == "equipment" then
			isPlayerAttacker = true
			if sourceType == "ability" then
				local abilityDamageGUIDData = network:invoke("validateAbilityGUID", player, sourceId, guid)
				-- if guid is valid then player casted ability properly
				if abilityDamageGUIDData then
					print("2")
					-- if this causes problems add abilityExecutionData after playerData
					local abilityBaseData = abilityLookup[sourceId]
					local abilityDamageType = "physical"

					attackerStats = playerData.nonSerializeData.statistics_final
					attackerStats.level = playerData.level

					local health, maxHealth, targetLevel, targetDefense, defenderDex, defenderVit, targetPlayer, targetPlayerData = 0, 0, 0, 0, 0.1, 0.1, nil, nil do
						if isServerHitboxPlayer then
							health 	= serverHitbox.health.Value
							maxHealth = serverHitbox.maxHealth.Value
							targetPlayer = game.Players:GetPlayerFromCharacter(serverHitbox.Parent)

							if targetPlayer then
								targetPlayerData = network:invoke("getPlayerData", targetPlayer)

								if targetPlayerData then
--									targetDefense = targetPlayerData.nonSerializeData.statistics_final[abilityDamageType .. "Defense"]
									defenderStats = targetPlayerData.nonSerializeData.statistics_final
									defenderStats.level = targetPlayerData.level
								end
								targetLevel = targetPlayer.level.Value
							end
						else
							health = network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "health")
							maxHealth = network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "maxHealth")
							targetLevel = serverHitbox.level.Value

							defenderStats = {
								level = serverHitbox.level.Value;
								dex = network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "dex") or 0;
								vit = network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "vit") or 0;
								str = network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "str") or 0;
								int = network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "int") or 0;
								defense = network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "defense") or 0;
								physicalDefense = network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "defense") or 0;
								magicalDefense = network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "defense") or 0;
							}
						end
					end
					abilityDamageMulti  = 1
					-- note: this stuff does literally nothing with the dmg changes
					local baseDamage = calculatePlayerDamage(player, abilityDamageType, targetLevel, isServerHitboxPlayer)
					local abilityDamage = math.ceil(baseDamage * abilityDamageMulti)

					local damageCategory = "direct"
					local firstHitDataForSourceTag
					--[[local WEIRD_BLOCK do
						for i, v in pairs(abilityDamageGUIDData.previousEntityHits) do
							if abilityBaseData.securityData and abilityBaseData.securityData.isDamageContained then
								-- use any first hit
								firstHitDataForSourceTag = v.hitData[1]
							end

							if v.entityManifest == serverHitbox then
								for _, hitData in pairs(v.hitData) do
									if hitData.sourceTag == sourceTag then
										hitsDoneToEntityManifestBySourceTag = hitsDoneToEntityManifestBySourceTag + 1
									end
								end

								break
							end
						end
					end]]

					-- todo: turn this into something more elegant.
					if configuration.getConfigurationValue("doUseAbilitySecurityData", player) then
						if abilityBaseData.securityData then
							local adjustServerHitboxPosition = detection.projection_Box(serverHitbox.CFrame, serverHitbox.Size, player.Character.PrimaryPart.Position)

							if abilityBaseData.securityData.maxHitLockout then
								local sumHits = 0 do
									for i, v in pairs(abilityDamageGUIDData.previousEntityHits) do
										sumHits = sumHits + #v.hitData
									end
								end

								if sumHits >= abilityBaseData.securityData.maxHitLockout then
									warn(player, abilityBaseData.name, "hit maxHitLockout")

									return false
								end
							end

							if abilityBaseData.projectileSpeed and abilityBaseData.securityData.projectileOrigin then
								local posDiff = 0 do
									if abilityBaseData.securityData.projectileOrigin == "character" then
										posDiff = (adjustServerHitboxPosition - player.Character.PrimaryPart.Position).magnitude
									end
								end

								if posDiff > 3 * abilityBaseData.projectileSpeed * (tick() - abilityDamageGUIDData.timestamp) then
									warn(player, abilityBaseData.name, "projectile hit way too fast")

									return false
								end
							end

							if (abilityBaseData.securityData.playerHitMaxPerTag or math.huge) <= hitsDoneToEntityManifestBySourceTag then
								warn(player, abilityBaseData.name, "hit same entity too many times")

								return false
							end

							if abilityBaseData.securityData.isDamageContained and firstHitDataForSourceTag then
								local posDiff 		= (adjustServerHitboxPosition - firstHitDataForSourceTag.hitPosition).magnitude
								local containRadius = abilityStatistics["blast radius"] or abilityStatistics["range"] or abilityStatistics["radius"] or abilityStatistics["distance"] or 20

								if posDiff > (containRadius) * 3 then
									warn(player, abilityBaseData.name, "hit entity outside of containDamage")

									return false
								end
							end
						end
					end

					--[[for statsName, statsValue in pairs(abilityStatistics) do
						local scalingStat = string.match(statsName, "(%w+)_scaling")
						if scalingStat and playerData.nonSerializeData.statistics_final[scalingStat] then
							abilityDamage = abilityDamage + playerData.nonSerializeData.statistics_final[scalingStat] * statsValue
						elseif statsName == "enemy_missing_health" then
							abilityDamage = abilityDamage + (maxHealth - health) * statsValue
						elseif statsName == "enemy_current_health" then
							abilityDamage = abilityDamage + health * statsValue
						elseif statsName == "enemy_max_health" then
							abilityDamage = abilityDamage + maxHealth * statsValue
						elseif statsName == "user_missing_health" then
							warn(statsName .. " not yet implemented.")
						elseif statsName == "user_current_health" then
							warn(statsName .. " not yet implemented.")
						elseif statsName == "user_max_health" then
							warn(statsName .. " not yet implemented.")
						end
					end]]

					damageData = {}
					damageData.damage = abilityDamage
					damageData.sourceType = sourceType
					damageData.sourceId = sourceId
					damageData.damageType = abilityDamageType
					damageData.isDamageDirect = false
					damageData.sourcePlayerId = player.userId
					damageData.damageTime = os.time()
					damageData.category = damageCategory
					damageData.sourceEntityGUID = utilities.getEntityGUIDByEntityManifest(player.Character.PrimaryPart)
				end
			elseif sourceType == "equipment" then
				local equipmentData = network:invoke("getPlayerEquipmentDataByEquipmentPosition", player, mapping.equipmentPosition.weapon)
				if equipmentData then
					local weaponBaseData = itemLookup[equipmentData.id]
					local weaponManfiestFolder = itemFolderLookup[weaponBaseData.module.Name]
					if weaponBaseData and weaponBaseData.module then

						local DAMAGE_TYPE_OVERRIDE

						local passesSecurityCheck, securityData = false, {} do
							if weaponBaseData.equipmentType == "bow" then
								if arrowsShotByPlayers[player] and #arrowsShotByPlayers[player] > 0 then
									local playerPositionAtDamageRequestTime = player.Character.PrimaryPart.Position
									local targetPositionAtDamageRequestTime = serverHitbox.Position

									for i, arrowData in pairs(arrowsShotByPlayers[player]) do
										if isArrowDataUsableForDamageRequest(arrowData, playerPositionAtDamageRequestTime, targetPositionAtDamageRequestTime) then
											passesSecurityCheck = true
											securityData 		= arrowData
											if not arrowData.canAOE then
												if arrowData.piercesRemaining <= 0  then
													table.remove(arrowsShotByPlayers[player], i)
												else
													arrowData.piercesRemaining = arrowData.piercesRemaining - 1
												end
											else
												DAMAGE_TYPE_OVERRIDE = "magical"
											end

											if (tick() - arrowData.timestamp) > 5 then -- lived too long
												table.remove(arrowsShotByPlayers[player], i)
											end

											break
										end
									end
								end
							elseif weaponBaseData.equipmentType == "staff" and sourceTag == "magic-ball" then
								if magicBallsByPlayer[player] and #magicBallsByPlayer[player] > 0 then
									local playerPositionAtDamageRequestTime = player.Character.PrimaryPart.Position
									local targetPositionAtDamageRequestTime = serverHitbox.Position

									for i, magicBallData in pairs(magicBallsByPlayer[player]) do
										if isMagicBallDataUsableForDamageRequest(magicBallData, playerPositionAtDamageRequestTime, targetPositionAtDamageRequestTime) then
											passesSecurityCheck = true
											securityData 		= magicBallData

											table.remove(magicBallsByPlayer[player], i)

											break
										end
									end
								end
							else
								local manifest = weaponManfiestFolder:FindFirstChild("manifest")
								if not manifest and weaponManfiestFolder:FindFirstChild("container") then
									local container = weaponManfiestFolder.container:FindFirstChild("RightHand") or weaponManfiestFolder.container:FindFirstChild("LeftHand")
									if container then
										manifest = container:FindFirstChild("manifest") or container.PrimaryPart
									end
								end
								if manifest then
									local diameter 			= math.max(manifest.Size.X, manifest.Size.Y, manifest.Size.Z) + 6 -- add 6 to pad for laggy players
									local adjusted_position = detection.projection_Box(serverHitbox.CFrame, serverHitbox.Size, player.Character.PrimaryPart.Position)
									local distFromMonster 	= (adjusted_position - player.Character.PrimaryPart.Position).magnitude

									if distFromMonster <= diameter * (1.75 + playerData.nonSerializeData.statistics_final.attackRangeIncrease) and isPlayerEquipmentDamageRequestWithinAnimationDamageSequence(player, serverHitbox) then
										passesSecurityCheck = true
									end
								end
							end
						end
						if passesSecurityCheck then
							local EQUIPMENT_DAMAGE_TYPE = DAMAGE_TYPE_OVERRIDE or "physical"

							local targetLevel, targetDefense, targetPlayer, targetPlayerData = 0, 0, nil do
								if isServerHitboxPlayer then
									-- temporarily no difference when attacking players!

									targetPlayer = game.Players:GetPlayerFromCharacter(serverHitbox.Parent)
									if targetPlayer then
										targetPlayerData = network:invoke("getPlayerData", targetPlayer)

										if targetPlayerData then
											targetDefense = targetPlayerData.nonSerializeData.statistics_final["defense"]
											defenderStats = targetPlayerData.nonSerializeData.statistics_final
											defenderStats.level = targetPlayerData.level
										end

										targetLevel = targetPlayer.level.Value
									end

									-- targetLevel = playerData.level
								else
									targetLevel 	= serverHitbox.level.Value
									defenderStats 	= {
										level	= serverHitbox.level.Value;
										dex 	= network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "dex") or 0;
										vit 	= network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "vit") or 0;
										str 	= network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "str") or 0;
										int 	= network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "int") or 0;
										defense = network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "defense") or 0;
										physicalDefense = network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "defense") or 0;
										magicalDefense = network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "defense") or 0;
									}
								end
							end

							local levelDifference 	= playerData.level - targetLevel
							local stats 			= playerData.nonSerializeData.statistics_final
							attackerStats 			= stats
							attackerStats.level		= playerData.level

							damageData = {}
								damageData.damage 			= 0 -- gets overwritten later
								damageData.damageType 		= sourceTag == "magic-ball" and "magical" or EQUIPMENT_DAMAGE_TYPE
								damageData.sourceType 		= sourceType
								damageData.sourceId 		= sourceId
								damageData.sourcePlayerId	= player.userId
								damageData.damageTime		= os.time()
								damageData.category 		= weaponBaseData.equipmentType == "bow" and "projectile" or "direct"
								damageData.sourceEntityGUID = utilities.getEntityGUIDByEntityManifest(player.Character.PrimaryPart)
								damageData.equipmentType    = weaponBaseData.equipmentType
						end


					end
				end
			end
		elseif sourceType == "monster" then
			if player.Character.PrimaryPart.health.Value > 0 then
				local stats = playerData.nonSerializeData.statistics_final

				defenderStats = stats
				defenderStats.level = playerData.level

				local damage = network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "damage")

				attackerStats = {
					level	= serverHitbox.level.Value;
					dex 	= network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "dex") or 0;
					vit 	= network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "vit") or 0;
					str 	= network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "str") or 0;
					int 	= network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "int") or 0;
					defense = network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "defense") or 0;
					damage 	= network:invoke("getMonsterDataByMonsterManifest_server", serverHitbox, "damage") or 0;
					damageMulti = 1;
					magicalDamage 	= nil;--monsterDamage;
					physicalDamage 	= nil;--monsterDamage;
				}

				damageData = {}
					damageData.damage 				= attackerStats.damage
					damageData.sourceType 			= "monster"
					damageData.sourceId 			= sourceId
					damageData.damageType 			= nil;--damageType
					damageData.category 			= nil;--damageCategory
					damageData.sourceEntityGUID 	= utilities.getEntityGUIDByEntityManifest(serverHitbox)
				--[[
					damageData.damage 			= damageToDeal
					damageData.sourceType 		= sourceType
					damageData.sourceId 		= sourceId
					damageData.sourcePlayerId	= player.userId
					damageData.damageTime		= os.time()
				--]]
			end
		end
		-- damageData, attackerStats, defenderStats
		if damageData then
			local ATK = attackerStats.damage--(damageData.damageType == "magical" and attackerStats.magicalDamage) or attackerStats.physicalDamage
			local DEF = defenderStats.defense--(damageData.damageType == "magical" and defenderStats.magicalDefense) or defenderStats.physicalDefense

			local coeffecient = 1
			--[[
			if isPlayerAttacker then
				local level = playerData.level or 0
				coeffecient = coeffecient * (1 + .02*level)
			end
			]]

--			local levelBonusDamageMulti = 1 --(1 + .02*attackerStats.level)
--			coeffecient = coeffecient * levelBonusDamageMulti

--			local levelDifference 		= (attackerStats.level or 0) - (defenderStats.level or 0)
--			local levelMulti 			= math.clamp((10 + (levelDifference/2)) / 10,0.2,2)
--			coeffecient = coeffecient * levelMulti

			if attackerStats.damageMulti then
				coeffecient = coeffecient * attackerStats.damageMulti
			end



--			damageData.damage = coeffecient * ATK*(1/(1+2.718281828459^(-((ATK-DEF)/ (0.1*DEF) )) ))

			damageData.damage = math.max(0, math.floor(coeffecient * (ATK - DEF)))
	--		damageData.damage = coeffecient * (ATK ^ 2) / (ATK + DEF)
	--		damageData.damage = coeffecient * ((1.87*ATK)^4)/((1.87*ATK+DEF)^3)

			-- stuff for monsters idk --
			if sourceType == "monster" then
				local monsterDamage, damageType, damageCategory do
					if monsterLookup[serverHitbox.Name] then
						local statesData = monsterLookup[serverHitbox.Name].statesData

						if statesData.processDamageRequest then
							monsterDamage, damageType, damageCategory = statesData.processDamageRequest(sourceId, damageData.damage)
						end
					end
				end

				if monsterDamage then
					damageData.damage 			= monsterDamage
					damageData.damageType 		= damageType;--damageType
					damageData.category 		= damageCategory;--damageCategory
				else
					damageData.damageType 		= "physical";--damageType
					damageData.category 		= "direct";--damageCategory
				end
			elseif sourceType == "ability" then

				-- if this causes problems add abilityExecutionData after playerData
				local abilityBaseData = abilityLookup[sourceId]

				if abilityBaseData._serverProcessDamageRequest then
					local abilityDamage, abilityDamageType, abilityDamageCategory = abilityBaseData._serverProcessDamageRequest(sourceTag, damageData.damage, serverHitbox, hitsDoneToEntityManifestBySourceTag, player)

					if not abilityDamage then
						warn("FAILED TO PASS VALID SOURCE-TAG")

						return false
					else
						damageData.damage = abilityDamage;
						damageData.damageType = abilityDamageType;
						damageData.category = abilityDamageCategory;
					end
				end
			end
			damageData.position = damagePosition

			-- ranged damage bonus?
			if sourceType == "equipment" then
				local equipmentData = network:invoke("getPlayerEquipmentDataByEquipmentPosition", player, mapping.equipmentPosition.weapon)
				if equipmentData then
					local weaponBaseData = itemLookup[equipmentData.id]
					if weaponBaseData and weaponBaseData.equipmentType == "bow" then
						damageData.damage = damageData.damage + (attackerStats.rangedDamage or 0)
					end
				end
			end
			-- CRIT!
			if attackerStats.criticalStrikeChance and attackerStats.criticalStrikeChance > 0 and attackerStats.criticalStrikeChance >= critChanceRandom:NextNumber() then
				damageData.damage 		= damageData.damage * CRIT_DAMAGE_MULTIPLIER
				damageData.isCritical 	= true
			end

			-- ABILITY DMG
			if abilityDamageMulti then
				damageData.damage = damageData.damage * abilityDamageMulti
			end

			-- BLOCKED!
			if damageData.damageType ~= "magical" then
				if defenderStats.blockChance and dodgeChanceRandom:NextNumber() <= defenderStats.blockChance then
					damageData.damage = damageData.damage * 0.25
					damageData.supressed = true
					network:fireAllClients("replicatePlayerAnimationSequence", player, "emoteAnimations", "block")

				end
			end

			-- PERKS
			if sourceType == "ability" or sourceType == "equipment" then
				if serverHitbox.health.Value == serverHitbox.maxHealth.Value then

				elseif serverHitbox.health.Value / serverHitbox.maxHealth.Value <= 0.3 then

				end

				if sourceType == "equipment" and playerDamageAnimationState[player] and playerDamageAnimationState[player].state == "strike2" then

				elseif sourceType == "equipment" and playerDamageAnimationState[player] and playerDamageAnimationState[player].state == "strike3" then
					local hasTripleSlash = false

					local playerData = network:invoke("getPlayerData", player)
					if playerData and playerData.abilities then
						for _, ability in pairs(playerData.abilities) do
							if ability.id == 3 and ability.variant == "tripleSlash" then
								hasTripleSlash = true
							end
						end
					end

					if hasTripleSlash then
						if network:invoke("getIsPlayerOfClass_server", player, "berserker") then
							damageData.damage = damageData.damage * 2
						end

						damageData.damage = damageData.damage * 1.4
					end
				end
			end
			-- PARRY
			if damageData.category then
				local targetPlayer = sourceType == "monster" and player or game.Players:GetPlayerFromCharacter(serverHitbox.Parent)

				if targetPlayer then
					local successAAED, activeAbilityExecutionData = utilities.safeJSONDecode(targetPlayer.Character.PrimaryPart.activeAbilityExecutionData.Value)
					if successAAED then
						if activeAbilityExecutionData.id == 8 then
							if damageData.category == "direct" or damageData.category == "projectile" then
								damageData.damage = damageData.damage * 0.5
								damageData.supressed = true
							end
						elseif activeAbilityExecutionData.id == 17 then
							if damageData.category == "direct" or damageData.category == "projectile" then
								damageData.damage = damageData.damage * 0.35
								damageData.supressed = true

								network:fireAllClients("signal_damageModificationByActiveAbility",
									-- player that is using the ability that modified
									targetPlayer,
									activeAbilityExecutionData.id,
									damageData,
									-- thing damaging you
									player.Character.PrimaryPart
								)
							end
						end
					end
				end
			end

			-- working with this is actually giving me so much anxiety

			local attackerData = isPlayerAttacker and playerData
			local sourceManifest = isPlayerAttacker and player.Character.PrimaryPart or serverHitbox
			local targetManifest = sourceType == "monster" and player.Character.PrimaryPart or serverHitbox
			local targetPlayer = sourceType == "monster" and player or game.Players:GetPlayerFromCharacter(serverHitbox.Parent)
			local targetPlayerData = targetPlayer and network:invoke("getPlayerData", targetPlayer)

			-- go through attacker perks (if applicable)
			local attackerPerks = attackerData and attackerData.nonSerializeData.statistics_final.activePerks or {}
			for perkName, active in pairs(attackerPerks) do
				if active then
					local perkData = perkLookup[perkName]
					if perkData.onDamageGiven then
						perkData.onDamageGiven(sourceManifest, sourceType, sourceId, targetManifest, damageData)
					end

					if damageData.isCritical then
						if perkData.onCritGiven then
							perkData.onCritGiven(sourceManifest, sourceType, sourceId, targetManifest, damageData)
						end
					end
				end
			end
			if attackerData and attackerData.nonSerializeData.statistics_final.damageGivenMulti then
				damageData.damage = damageData.damage * attackerData.nonSerializeData.statistics_final.damageGivenMulti
			end

			-- go through defender perks (if applicable)
			local defenderPerks = targetPlayerData and targetPlayerData.nonSerializeData.statistics_final.activePerks or {}
			for perkName, active in pairs(defenderPerks) do
				if active then
					local perkData = perkLookup[perkName]
					if perkData.onDamageTaken then
						perkData.onDamageTaken(sourceManifest, sourceType, sourceId, targetManifest, damageData)
					end
				end
			end

			if targetPlayerData and targetPlayerData.nonSerializeData.statistics_final.damageTakenMulti then
				damageData.damage = damageData.damage * targetPlayerData.nonSerializeData.statistics_final.damageTakenMulti
			end

			-- INT BOOST
			if damageData.damageType == "magical" then
				damageData.damage = damageData.damage * (1 + (attackerStats.int * 1/160))

			-- STR BOOST
			else
				damageData.damage = damageData.damage * (1 + (attackerStats.str * 1/160))
			end

			-- nerf rangers
			if guid and (damageData.equipmentType == "bow") then
				local damageLossPerMultiHit = 0.5

				if not arrowMultiHitCache[guid] then
					arrowMultiHitCache[guid] = {}

					-- clear this cache to save memory
					delay(5, function()
						arrowMultiHitCache[guid] = nil
					end)
				end
				if not arrowMultiHitCache[guid][targetManifest] then
					arrowMultiHitCache[guid][targetManifest] = 0
				end
				arrowMultiHitCache[guid][targetManifest] = arrowMultiHitCache[guid][targetManifest] + 1

				local loss = damageLossPerMultiHit ^ (arrowMultiHitCache[guid][targetManifest] - 1)
				damageData.damage = damageData.damage * loss
			end
			-- ranger's stance damage implementation
			if (damageData.equipmentType == "bow") and sourceTag == "ranger stance" then
				if not player.Character then return end
				local manifest = player.Character.PrimaryPart
				if not manifest then return end

				local guid = utilities.getEntityGUIDByEntityManifest(manifest)
				if not guid then return end

				local statuses = network:invoke("getStatusEffectsOnEntityManifestByEntityGUID", guid)
				local rangerStanceStatus = nil

				for _, status in pairs(statuses) do
					if status.statusEffectType == "ranger stance" then
						rangerStanceStatus = status
						break
					end
				end

				if rangerStanceStatus then
					damageData.damage = damageData.damage * rangerStanceStatus.statusEffectModifier.damageBonus
				end
			end
			-- fire out on the event system to let other things modify the damage at will
			damageData.target = serverHitbox
			events:fireEventLocal("playerWillDealDamage", player, damageData)
			local successfullyDealtDamage do
				if sourceType == "monster" then
					-- monster is damaging player
					successfullyDealtDamage = network:invoke("playerDamageRequest_server", nil, player.Character.PrimaryPart, damageData)
				else
					if isServerHitboxPlayer then
						damageData.damage = damageData.damage * configuration.getConfigurationValue("abilityPVPDampening")

						-- player is damaging player
						successfullyDealtDamage = network:invoke("playerDamageRequest_server", player, serverHitbox, damageData)
					else
						-- player is damaging monster
						successfullyDealtDamage = network:invoke("monsterDamageRequest_server", player, serverHitbox, damageData)
					end
				end
			end

			if successfullyDealtDamage then
				if sourceType == "ability" then
					network:fire("abilityDealtDamageToEntity", player, sourceId, guid, serverHitbox, sourceTag)
				end

				-- VIT LEACH ON BOWS
				if sourceType == "equipment" then
					local equipmentData = network:invoke("getPlayerEquipmentDataByEquipmentPosition", player, mapping.equipmentPosition.weapon)
					if equipmentData then
						local weaponBaseData = itemLookup[equipmentData.id]
						if weaponBaseData and weaponBaseData.equipmentType == "bow" then
							local healAmt = 0

							if stats.vit >= 30 then
								healAmt = 25
							end
							if stats.vit >= 70 then
								healAmt = 40
							end
							if stats.vit >= 120 then
								healAmt = 100
							end

							-- 10% proc chance
							if math.random() < 1/10 and healAmt ~= 0 then
								local character = player.Character
								if not character then return end
								local manifest = character.PrimaryPart
								if not manifest then return end
								local health = manifest:FindFirstChild("health")
								if not health then return end
								local maxHealth = manifest:FindFirstChild("maxHealth")
								if not maxHealth then return end

								health.Value = math.min(health.Value + healAmt, maxHealth.Value)

								network:fireAllClients("effects_requestEffect", "bloodHeal", {
									player = player,
									playerManifest = manifest,
									target = serverHitbox,
								})
							end
						end
						if playerData.class == "Warrior" or playerData.class == "Knight" or playerData.class == "Paladin" or playerData.class == "Berserker" then
							local healAmt = 0
							local manaAmt = 0
							local stamAmt = 0

							if stats.vit >= 30 then
								healAmt = 2
							end
							if stats.vit >= 70 then
								healAmt = 4
							end
							if stats.vit >= 120 then
								healAmt = 6
							end

							if stats.int >= 30 then
								manaAmt = 1
							end
							if stats.int >= 70 then
								manaAmt = 2
							end
							if stats.int >= 150 then
								manaAmt = 3
							end

							if stats.dex >= 50 then
								stamAmt = 0.5
							end
							if stats.dex >= 120 then
								stamAmt = 1
							end

							local character = player.Character
							if not character then return end
							local manifest = character.PrimaryPart
							if not manifest then return end
							local health = manifest:FindFirstChild("health")
							if not health then return end
							local maxHealth = manifest:FindFirstChild("maxHealth")
							if not maxHealth then return end
							local mana = manifest:FindFirstChild("mana")
							if not mana then return end
							local maxMana = manifest:FindFirstChild("maxMana")
							if not maxMana then return end
							local stamina = manifest:FindFirstChild("stamina")
							if not stamina then return end
							local maxStamina = manifest:FindFirstChild("maxStamina")
							if not maxStamina then return end

							health.Value = math.min(health.Value + healAmt, maxHealth.Value)
							mana.Value = math.min(mana.Value + manaAmt, maxMana.Value)
							stamina.Value = math.min(stamina.Value + stamAmt, maxStamina.Value)
						end
					end
				end

				playerData.nonSerializeData.setNonSerializeDataValue("lastTimeInCombat", tick())
			end

			return successfullyDealtDamage or false
		end
	end
end

local function onReportMonsterInDamageState_server(monsterName, manifest, player)
	local characterPosition
end

local function isDamageAnimationSequence(animationSequence)
	for i, weaponType in pairs(WEAPON_TYPES_TO_SCAN) do
		if animationSequence == weaponType .. "Animations" then
			return true
		end
	end

	return false, nil
end

local function isPlayerDamageAnimationStateTransitionValid(player, weaponType, animationSequence, animationName)
	local currentPlayerDamageAnimationState = playerDamageAnimationState[player]
	local playerData = network:invoke("getPlayerData", player)

	if currentPlayerDamageAnimationState then
		if weaponValidationData[weaponType] then
			if animationName == "strike1" or animationName == "strike2" then
				if tick() - currentPlayerDamageAnimationState.timestamp >= weaponValidationData[weaponType][animationName .. "_animationLength"] / (1 + playerData.nonSerializeData.statistics_final.attackSpeed) then
					return true
				end
			end
		end

		if animationName == "strike1" then
			if currentPlayerDamageAnimationState.state == "strike2" then
				-- compare: minTimeForStrike2ToGetToStrike1
				if weaponValidationData[weaponType] then
					local success = isWithinBounds(
						tick() - currentPlayerDamageAnimationState.timestamp,
						weaponValidationData[weaponType].strike1_slash2PeriodStart_time - DAMAGE_ANIMATION_REQUEST_MISMATCH_LATENCY_FORGIVENESS,
						weaponValidationData[weaponType].strike1_slash2PeriodStart_time + SLASH_CHAIN_WINDOW + DAMAGE_ANIMATION_REQUEST_MISMATCH_LATENCY_FORGIVENESS,
						1 + playerData.nonSerializeData.statistics_final.attackSpeed
					)

					return success
				end

				return true

			elseif currentPlayerDamageAnimationState.state == "strike3" then
				if weaponValidationData[weaponType] then
					local success = isWithinBounds(
						tick() - currentPlayerDamageAnimationState.timestamp,
						weaponValidationData[weaponType].strike3_stopDamageSequence_time - DAMAGE_ANIMATION_REQUEST_MISMATCH_LATENCY_FORGIVENESS,
						weaponValidationData[weaponType].strike3_stopDamageSequence_time + SLASH_CHAIN_WINDOW  + DAMAGE_ANIMATION_REQUEST_MISMATCH_LATENCY_FORGIVENESS,
						1 + playerData.nonSerializeData.statistics_final.attackSpeed
					)

					return success
				end

				return true
			end
		elseif animationName == "strike2" then
			if currentPlayerDamageAnimationState.state == "strike1" then
				-- compare: minTimeForStrike1ToGetToStrike2
				if weaponValidationData[weaponType] then
					local success = isWithinBounds(
						tick() - currentPlayerDamageAnimationState.timestamp,
						weaponValidationData[weaponType].strike2_slash1PeriodStart_time - DAMAGE_ANIMATION_REQUEST_MISMATCH_LATENCY_FORGIVENESS,
						weaponValidationData[weaponType].strike2_slash1PeriodStart_time + SLASH_CHAIN_WINDOW + DAMAGE_ANIMATION_REQUEST_MISMATCH_LATENCY_FORGIVENESS,
						1 + playerData.nonSerializeData.statistics_final.attackSpeed
					)

					return success
				end

				return true
			elseif currentPlayerDamageAnimationState.state == "strike2" then
--				-- compare: minTimeForStrike2ToFinish
--				if weaponValidationData[weaponType] then
--					return tick() - currentPlayerDamageAnimationState.timestamp >= weaponValidationData[weaponType].minTimeForStrike2ToFinish
--				end
--
--				return true

				return false
			end
		elseif animationName == "strike3" then
			if currentPlayerDamageAnimationState.state == "strike2" then
				return true
			end
		end
	else
		return true
	end

	return false
end

local function playerHasArrowToShoot(player)
	local playerData = network:invoke("getPlayerData", player)

	local equipmentData do
		for i, equipmentSlotData in pairs(playerData.equipment) do
			if equipmentSlotData.position == mapping.equipmentPosition.arrow then
				equipmentData = equipmentSlotData
			end
		end
	end

	if equipmentData then
		for i, inventorySlotData in pairs(playerData.inventory) do
			if inventorySlotData.id == equipmentData.id and inventorySlotData.stacks >= 1 then
				return true, equipmentData.id
			end
		end
	else
		return false, "arrow not primed"
	end
end

local function getChargeTimeMultiplierFromChargeTime(chargeTime)
	chargeTime = chargeTime < 0 and 0 or chargeTime

	local m, b

	if chargeTime < configuration.getConfigurationValue("maxBowChargeTime") then
		local chargeTime_a = configuration.getConfigurationValue("maxBowChargeTime")
		local multiplier_a = 1

		local chargeTime_b = 0
		local multiplier_b = 0

		m = (multiplier_b - multiplier_a) / (chargeTime_b - chargeTime_a)
		b = multiplier_a - m * chargeTime_a
	else
		local chargeTime_a = configuration.getConfigurationValue("maxBowChargeTime")
		local multiplier_a = 1

		local chargeTime_b = configuration.getConfigurationValue("bowPullBackTime")
		local multiplier_b = configuration.getConfigurationValue("bowMaxChargeDamageMultiplier")

		m = (multiplier_b - multiplier_a) / (chargeTime_b - chargeTime_a)
		b = multiplier_a - m * chargeTime_a
	end

	local multiplier = math.clamp(chargeTime * m + b, 0.1, configuration.getConfigurationValue("bowMaxChargeDamageMultiplier"))

	return multiplier
end

local playerBowAnimationStateData = {}
local function onPlayerAnimationReplicated(player, animationSequence, animationName, executionData)
	if not player or not player.Character or not player.Character.PrimaryPart then return false end

	local isValid = isDamageAnimationSequence(animationSequence)

	if isValid or animationSequence == "bowAnimations" then
		local equipmentData = network:invoke("getPlayerEquipmentDataByEquipmentPosition", player, mapping.equipmentPosition.weapon)

		if equipmentData then
			local itemBaseData = itemLookup[equipmentData.id]

			if itemBaseData.category == "equipment" then
				local weaponType = itemBaseData.equipmentType
				if weaponType == "bow" then
					local success, info = playerHasArrowToShoot(player)

					if success then
						if animationName == "stretching_bow" then
							playerBowAnimationStateData[player] = {
								weaponType 		= weaponType;
								state 			= animationName;
								timestamp 		= tick();
								damageBlacklist = {}
							};
						elseif animationName == "firing_bow_stance" then
							local success = network:invoke("tradeItemsBetweenPlayerAndNPC", player, {{id = 87; stacks = 1}}, 0, {}, 0, nil)

							if success then
								if not arrowsShotByPlayers[player] then
									arrowsShotByPlayers[player] = {}
								end

								table.insert(arrowsShotByPlayers[player], {
									serverCharacterPosition = player.Character.PrimaryPart.Position;
									executionData 			= executionData;
									timestamp 				= tick();
									chargeTimeMultiplier 	= 1;
									piercesRemaining 		= 999;
									canAOE					= false;
									sourceWeaponBaseData 	= itemBaseData;
								})
							end
						elseif animationName == "firing_bow" then
							if not executionData.canceled then
								if playerBowAnimationStateData[player] and playerBowAnimationStateData[player].state == "stretching_bow" then
									local playerData = network:invoke("getPlayerData", player)
									local stats = playerData.nonSerializeData.statistics_final

									local isMagical = stats.int >= 30

									local attackSpeedScalar = 1 + playerData.nonSerializeData.statistics_final.attackSpeed

									local timeElapsed 		= (tick() - playerBowAnimationStateData[player].timestamp) * attackSpeedScalar
									local minBowChargeTime 	= configuration.getConfigurationValue("minBowChargeTime")
									local maxBowChargeTime 	= configuration.getConfigurationValue("maxBowChargeTime")

									if timeElapsed >= minBowChargeTime --[[change this to real anim time]] then
										local playerCurrentPosition = player.Character.PrimaryPart.Position

										playerBowAnimationStateData[player] = nil

										-- let other parts of the system make sure we need arrows, eh?
										local arrowData = {
											needsArrow = true
										}
										events:fireEventLocal("playerWillUseArrow", player, arrowData)

										local maxNumArrows = utilities.calculateNumArrowsFromDex(stats.dex)
										local inventory = (network:invoke("getPlayerData", player) or {}).inventory or {}

										local arrowsOwned = 0

										for i, inventorySlotData in pairs(inventory) do
											if inventorySlotData.id == 87 then
												arrowsOwned = inventorySlotData.stacks
											end
										end

										local numArrows = math.min(arrowsOwned, maxNumArrows)

										local success, info = playerHasArrowToShoot(player)

										if success and arrowData.needsArrow then
											success = network:invoke("tradeItemsBetweenPlayerAndNPC", player, {{id = info; stacks = numArrows}}, 0, {}, 0, nil)
										end

										if success then
											if not arrowsShotByPlayers[player] then
												arrowsShotByPlayers[player] = {}
											end

											for i = 1, numArrows do
												table.insert(arrowsShotByPlayers[player], {
													serverCharacterPosition = playerCurrentPosition;
													executionData 			= executionData;
													timestamp 				= tick();
													chargeTimeMultiplier 	= getChargeTimeMultiplierFromChargeTime(timeElapsed); --math.clamp(timeElapsed / maxBowChargeTime, 0.1, configuration.getConfigurationValue("bowMaxChargeDamageMultiplier"));
													piercesRemaining 		= utilities.calculatePierceFromStr(stats.str);
													canAOE					= isMagical;
													sourceWeaponBaseData 	= itemBaseData;
													arrowId 				= info;
													damageMultiplier		= math.clamp(1 - ((numArrows-1) * 0.15), 0.10, 1)
												})
											end
										else
											warn("failed to take arrow(s) from player!")
										end

		--								playerDamageAnimationState[player] = {
		--									weaponType 				= weaponType;
		--									state 					= animationName;
		--									timestamp 				= tick();
		--									serverCharacterPosition = playerCurrentPosition;
		--									executionData 			= executionData;
		--									damageBlacklist 		= {}
		--								};
									end
								end
							else
								playerBowAnimationStateData[player] = nil
							end
						else
							playerBowAnimationStateData[player] = nil
						end
					else
						playerBowAnimationStateData[player] = nil
					end
				else
					if not playerDamageAnimationState or isPlayerDamageAnimationStateTransitionValid(player, weaponType, animationSequence, animationName) then
						playerDamageAnimationState[player] = {
							weaponType 		= weaponType;
							state 			= animationName;
							timestamp 		= tick();
							damageBlacklist = {}
						}
					end
				end
			end
		end
	end
end

local function onPlayerRemoving(player)
	playerAbilityHitData 				= nil
	playerBowAnimationStateData[player] = nil
	playerDamageAnimationState[player] 	= nil
	arrowsShotByPlayers[player] 		= nil
	magicBallsByPlayer[player] 			= nil

	-- clear data from arrowsShotByPlayers
	for i, arrowCollectionData in pairs(arrowsShotByPlayers) do
		for ii = #arrowCollectionData, 1, -1 do
			if tick() - arrowCollectionData[ii].timestamp >= ARROW_DATA_MAX_LIFETIME then
				table.remove(arrowCollectionData, ii)
			end
		end
	end

	-- clear data from magicBallsByPlayer
	for i, magicBallCollectionData in pairs(magicBallsByPlayer) do
		for ii = #magicBallCollectionData, 1, -1 do
			if tick() - magicBallCollectionData[ii].timestamp >= ARROW_DATA_MAX_LIFETIME then
				table.remove(magicBallCollectionData, ii)
			end
		end
	end
end

local function main()
	network:create("signal_damageModificationByActiveAbility", "RemoteEvent")
	network:create("playerRequest_damageEntity", "RemoteEvent", "OnServerEvent", playerRequest_damageEntity)
	network:create("playerRequest_damageEntity_server", "BindableEvent", "Event", playerRequest_damageEntity)
	network:create("playerDamageRequest_server", "BindableFunction", "OnInvoke", playerDamageRequest_server)
	network:create("reportMonsterInDamageState_server", "BindableEvent", "Event", onReportMonsterInDamageState_server)

--	if game.PlaceId == 2061558182 then
		spawn(function()
			-- listen to player animation replication
			network:connect("playerAnimationReplicated", "Event", onPlayerAnimationReplicated)

			game.Players.PlayerRemoving:connect(onPlayerRemoving)

			-- process player animations here :smile:
			local animationsLocation = game.StarterPlayer.StarterPlayerScripts.assets.animations

			local playerBaseCharacter 	= replicatedStorage.playerBaseCharacter:Clone()
			playerBaseCharacter.Parent 	= workspace

			for _, obj in pairs(playerBaseCharacter:GetChildren()) do
				if obj.Name == "HumanoidRootPart" then
					obj.Anchored = true
					obj.CanCollide = true
					obj.Transparency = 0.75
				elseif obj:IsA("BasePart") then
					obj.Anchored = false
					obj.CanCollide = true
					obj.Transparency = 0.75
				end
			end

--			playerBaseCharacter:SetPrimaryPartCFrame(CFrame.new(0, 100, 25))

			-- generic melee weapons
			for i, weaponType in pairs(WEAPON_TYPES_TO_SCAN) do
				local weaponAnimationModule = animationsLocation[weaponType .. "Animations"]
				local weaponAnimationData 	= require(weaponAnimationModule)

				local validationTable = {}

				-- startDamageSequence stopDamageSequence
				for name, animationData in pairs(weaponAnimationData) do
					local animation 		= Instance.new("Animation")
					animation.AnimationId 	= animationData.animationId

					local animationTrack = playerBaseCharacter.AnimationController:LoadAnimation(animation)

					animationTrack:Play()

					while animationTrack.Length == 0 do wait(0.1) end



					if name == "strike1" then
						validationTable.strike1_animationLength 			= animationTrack.Length
						validationTable.strike1_startDamageSequence_time 	= animationTrack:GetTimeOfKeyframe("startDamageSequence")
						validationTable.strike1_stopDamageSequence_time 	= animationTrack:GetTimeOfKeyframe("stopDamageSequence")
						validationTable.strike1_slash2PeriodStart_time 		= animationTrack:GetTimeOfKeyframe("slash2PeriodStart")
					elseif name == "strike2" then
						validationTable.strike2_animationLength 			= animationTrack.Length
						validationTable.strike2_startDamageSequence_time 	= animationTrack:GetTimeOfKeyframe("startDamageSequence")
						validationTable.strike2_stopDamageSequence_time 	= animationTrack:GetTimeOfKeyframe("stopDamageSequence")
						validationTable.strike2_slash1PeriodStart_time 		= animationTrack:GetTimeOfKeyframe("slash1PeriodStart")
					elseif name == "strike3" then
						validationTable.strike3_animationLength 			= animationTrack.Length
						validationTable.strike3_startDamageSequence_time 	= animationTrack:GetTimeOfKeyframe("startDamageSequence")
						validationTable.strike3_stopDamageSequence_time 	= animationTrack:GetTimeOfKeyframe("stopDamageSequence")
					end
				end

				weaponValidationData[weaponType] = validationTable
			end

			-- process bow animation data here, bows are a bit unique
			do
				-- we're using the actual bow's streching animation and firing animation
				-- because this lets us know exactly how long the minimum amount of time
				-- must elapse (time of stretching anim + time of firing anim = minimum time)
				-- we can offset this later by some multiple to make the speed faster!
				local bowToolAnimationsModule = animationsLocation.bowToolAnimations_noChar
				local bowToolAnimations = require(bowToolAnimationsModule)

			end

			-- process monster animations here :smile:
			for monsterName, monsterData in pairs(monsterLookup) do
				local monsterModel = monsterData.entity:Clone()

				for _, obj in pairs(monsterModel:GetChildren()) do
					if obj.Name == "HumanoidRootPart" then
						obj.Anchored = true
						obj.CanCollide = true
						obj.Transparency = 0.75
					elseif obj:IsA("BasePart") then
						obj.Anchored = false
						obj.CanCollide = true
						obj.Transparency = 0.75
					end
				end

				monsterModel.Parent = workspace
				monsterModel:SetPrimaryPartCFrame(CFrame.new(0, 100, 0))

				-- open animations folder
				monsterDamageValidationData[monsterName] = {}

				-- process animations
				if monsterModel:FindFirstChild("animations") then
					local animations = monsterModel.animations
					local statesScript = monsterData.module:FindFirstChild("states") and require(monsterData.module:FindFirstChild("states"))
					if statesScript == nil or not statesScript.states then
						statesScript = require(replicatedStorage.defaultMonsterState)
					end
					for stateName, stateData in pairs(statesScript.states) do
						if stateData.animationTriggersDamage then
							local animationName = stateData.animationEquivalent or stateName

							if animations:FindFirstChild(animationName) then
								local animationTrack = monsterModel.AnimationController:LoadAnimation(monsterModel.animations[animationName])
								local recordingStartTime = animationTrack.Length * 0.3
								local recordingFinishTime = animationTrack.Length * 0.7
								local connections = {}
								local fetched = false
								local animationStartTime = tick()

								local damageExtents = {}

								local function onAnimationPlayed()
									animationStartTime = tick()

									local timeDiff = animationTrack.Length * 0.7 - animationTrack.Length * 0.3
									local sampleTimes = {}
									local pointsoverride --math.clamp(math.floor(timeDiff / SAMPLE_POINTS_TIME_GRANULARITY + 0.5), 3, math.huge)
									for i = 1, pointsoverride or SAMPLE_POINTS_TO_TAKE do
										sampleTimes[i] = animationTrack.Length * 0.3 + timeDiff * (i - 1) / ((pointsoverride or SAMPLE_POINTS_TO_TAKE) - 1)
									end

									local maxDistanceAway
									while animationTrack.IsPlaying do
										for i, sampleTime in pairs(sampleTimes) do
											if tick() - animationStartTime >= sampleTime then
												for i, damageHitboxData in pairs(monsterData.damageHitboxCollection) do
													local boundingBoxCF, boundingBoxSize = monsterModel:GetBoundingBox()
													local damageHitboxCF = monsterModel[damageHitboxData.partName].CFrame * (damageHitboxData.originOffset or CFrame.new())

													if not damageExtents[damageHitboxData.partName] then
														damageExtents[damageHitboxData.partName] = {}
													end

													table.insert(damageExtents[damageHitboxData.partName], damageHitboxCF:toObjectSpace(boundingBoxCF))

													table.remove(sampleTimes, i)
												end
											end
										end

										wait()
									end

									for i, v in pairs(connections) do
										v:disconnect()
									end

									fetched = true
								end

								table.insert(connections, monsterModel.AnimationController.AnimationPlayed:connect(onAnimationPlayed))

								while not (animationTrack.Length > 0) do wait(0.25) end

								animationTrack.Looped = false

								-- wait for this to update? idk
								wait()

								animationTrack:Play()

								-- wait for animation stop
								while not fetched do wait(0.25) end

--								local boundingBoxCF, boundingBoxSize = monsterModel:GetBoundingBox()
--								for i, v in pairs(damageExtents) do
--									for i, vv in pairs(v) do
--										local line = Instance.new("Part")
--										line.Anchored = true
--										line.CanCollide = false
--										line.TopSurface = Enum.SurfaceType.Smooth
--										line.BottomSurface = Enum.SurfaceType.Smooth
--										line.Material = Enum.Material.Neon
--										line.BrickColor = BrickColor.new("Institutional white")
--
--										line.Size = Vector3.new(0.25, 0.25, 0.25)
--										line.CFrame = boundingBoxCF * vv:inverse()
--
--										line.Parent = workspace
--
--										game:GetService("Debris"):AddItem(line, 2.5)
--									end
--								end

								monsterDamageValidationData[monsterName] = damageExtents

								wait(3)
							end
						end
					end
				else
					warn("invalid monster", monsterName)
				end

				monsterModel:Destroy()
			end

			playerBaseCharacter:Destroy()
		end)
--	end
end

main()

return module