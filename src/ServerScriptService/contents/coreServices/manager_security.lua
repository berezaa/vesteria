--[[
	BANS & SUSPICION
--]]

local function handleBanHistory(player, playerBanHistory)
	if playerBanHistory and playerBanHistory.unbanTime > os.time() then
		if player:FindFirstChild("DataLoaded") then
			onPlayerRemoving()
		end
		local banDuration = playerBanHistory.unbanTime - os.time()
		if playerBanHistory.reason then
			player:Kick("You have been banned for: "..playerBanHistory.reason.." (unbanned in "..utilities.timeToString(banDuration)..")")
		else
			player:Kick("You have been banned (unbanned in "..utilities.timeToString(banDuration)..")")
		end
	end
end

local banRecord = game:GetService("DataStoreService"):GetDataStore("banRecord")

game.Players.PlayerAdded:connect(function(player)
	local playerBanHistory = banRecord:GetAsync(player.userId)
	if playerBanHistory then
		handleBanHistory(player, playerBanHistory)
	end
end)

-- unban
--[[
local banRecord = game:GetService("DataStoreService"):GetDataStore("banRecord")
banRecord:UpdateAsync(userId, function(history)
	history.unbanTime = 0
	return history
end)

]]


local function banPlayer(player, duration, reason, source)
	source = source or "system"

	local playerData = playerDataContainer[player]
	local playerBanHistory

	for i=1, 3 do
		local success, err = pcall(function()
			banRecord:UpdateAsync(player.userId, function(banHistory)
				banHistory = banHistory or {}
				playerBanHistory = banHistory
				playerBanHistory.reason = reason
				playerBanHistory.source = source


				playerBanHistory.previousRecords = playerBanHistory.previousRecords or {}
				table.insert(playerBanHistory.previousRecords, {reason = reason, source = source, duration = duration, timestamp = os.time()})

				if playerData then
					playerBanHistory.offendingData = playerData
				end

				playerBanHistory.unbanTime = playerBanHistory.unbanTime or 0
				if playerBanHistory.unbanTime >= os.time() then
					playerBanHistory.unbanTime = playerBanHistory.unbanTime + duration
				else
					playerBanHistory.unbanTime = os.time() + duration
				end
				return playerBanHistory
			end)
		end)

		if success then
			break
		end
	end

	handleBanHistory(player, playerBanHistory)
end

network:create("banPlayer", "BindableFunction", "OnInvoke", banPlayer)

local function addSuspicion(player, amount)
	local playerData = playerDataContainer[player]
	playerData.internalData.suspicion = playerData.internalData.suspicion + amount

	if playerData.internalData.suspicion > 100 then
		local playerBanHistory
		for i = 1, 3 do
			local success, err = pcall(function()
				banRecord:UpdateAsync(player.userId, function(banHistory)

					banHistory = banHistory or {}
					playerBanHistory = banHistory

					local reason = "cheating suspicion"
					local source = "system"
					local duration = 36000

					playerBanHistory.cheatingBans = (playerBanHistory.cheatingBans or 0) + 1

					local banCount = playerBanHistory.cheatingBans
					if banCount >= 5 then
						duration = 14 * 86400
					elseif banCount == 4 then
						duration = 7 * 86400
					elseif banCount == 3 then
						duration = 3 * 86400
					elseif banCount == 2 then
						duration = 86400
					end

					playerBanHistory.previousRecords = playerBanHistory.previousRecords or {}
					table.insert(playerBanHistory.previousRecords, {reason = reason, source = source, duration = duration, timestamp = os.time()})


					playerBanHistory.reason = reason
					playerBanHistory.source = source

					if playerData then
						playerBanHistory.offendingData = playerData
					end

					playerBanHistory.unbanTime = playerBanHistory.unbanTime or 0
					if playerBanHistory.unbanTime >= os.time() then
						playerBanHistory.unbanTime = playerBanHistory.unbanTime + duration
					else
						playerBanHistory.unbanTime = os.time() + duration
					end

					return playerBanHistory
				end)
			end)
			if success then
				playerData.internalData.suspicion = 0
				break
			end
		end
	end
end

network:create("addSuspicion", "BindableFunction", "OnInvoke", addSuspicion)

-- tp exploit stuff
local function init__exploitBlock()
	local positionCheckHeartbeatTick = 1 / 3

	local doors 		= collectionService:GetTagged("door")
	local cannons 		= collectionService:GetTagged("cannon")
	local escapeRopes 	= collectionService:GetTagged("escapeRope")

	local ACCEPTABLE_THRESHOLD_FOR_NEARBY = 50
	local function isNearbyAcceptableObject(pos, objTable, label)
		for i, obj in pairs(objTable) do
			local objPos = obj:IsA("Model") and (obj.PrimaryPart and obj.PrimaryPart.Position) or obj.Position

			if objPos and (pos - objPos).magnitude <= ACCEPTABLE_THRESHOLD_FOR_NEARBY then
				return true, obj
			end
		end

		return false, nil
	end

	local function getOtherDoorFromDoor(door)
		for i, v in pairs(doors) do
			if v.Parent.Name == door.Parent.Name and v.Parent ~= door.Parent then
				return v
			end
		end
	end

	local function isPlayerPerformingUnacceptableSketchyMovements(player)
		local timeWindow 	= configuration.getConfigurationValue("server_TPExploitTimeWindow")
		local scoreToFail 	= configuration.getConfigurationValue("server_TPExploitScoreToFail")

		local score = 0

		if playerPositionDataContainer[player] then
			for i, scoreData in pairs(playerPositionDataContainer[player].sketchyMovements) do
				if tick() - scoreData.timestamp <= timeWindow then
					score = score + scoreData.movementRatio
				end
			end
		end

		return score >= scoreToFail
	end

	network:create("reportPlayerAttemptDamageEntity", "BindableEvent", "Event", function(player, weaponType, serverHitbox)
		if playerPositionDataContainer[player] then
			if playerPositionDataContainer[player].positions and #playerPositionDataContainer[player].positions > 0 then
				local lastPosition = playerPositionDataContainer[player].positions[#playerPositionDataContainer[player].positions].position

				local playerData = playerDataContainer[player]
				local distanceToTravel = (serverHitbox.Position - lastPosition).magnitude

				if distanceToTravel > playerData.nonSerializeData.statistics_final.walkspeed * 4 * positionCheckHeartbeatTick + 5 then
					warn("earlyTrigger exploiter!", player)
					local response = configuration.getConfigurationValue("tpExploitPunishment")
					if response == "suspicion" then
						local amount = configuration.getConfigurationValue("tpExploitPunishmentSuspicionAddAmount")
						addSuspicion(player, amount or 25)
					elseif response == "kick" then
						player:Kick("TP Exploiting")
					elseif response == "redirect" then
						player:Kick("Anti-exploit")
--						game:GetService("TeleportService"):Teleport(2376885433, player, nil, game.ReplicatedStorage.returnToLobby)
					end
				end
			end
		end
	end)

	local function visualizePart(brc, pos, nm)
		local p = Instance.new("Part", workspace)
		p.Size = Vector3.new(1, 1, 1)
		p.CanCollide = false
		p.Anchored = true
		p.BrickColor = brc
		p.CFrame = CFrame.new(pos)
		p.Name = nm
		--game:GetService("Debris"):AddItem(p, 10)
	end

	local function getRayClosestPoint(ray, point)
	    --  shift point to be relative to the origin of the ray
	    local a, b = ray.Origin - point, ray.Direction
	    --  calculate rejection of a from b
	    local v = a - ((a:Dot(b)) / (b:Dot(b))) * b
	    --  add rejection to point to get the closest point on the ray
	    return point + v
	end

	network:create("playerRequest_activateEscapeRope", "RemoteEvent", "OnServerEvent", function(player, cEscapeRope)
		if cEscapeRope and collectionService:HasTag(cEscapeRope, "escapeRope") then
			local isNearbyEscapeRope, nearestEscapeRope = isNearbyAcceptableObject(player.Character.PrimaryPart.Position, escapeRopes)

			if isNearbyEscapeRope and nearestEscapeRope == cEscapeRope then
				if nearestEscapeRope.Parent and nearestEscapeRope.Parent:FindFirstChild("Target") then
					network:invoke("teleportPlayerCFrame_server", player, nearestEscapeRope.Parent.Target.CFrame)
				end
			end
		end
	end)

	local function checkIfPlayerIsBad(player)
		local playerData = network:invoke("getPlayerData", player)

		if playerData then
			if isPlayerPerformingUnacceptableSketchyMovements(player) then
				if configuration.getConfigurationValue("doLogTPExploitersInPlayerDataFlags") then
					playerData.flags.isPlayerTPExploiter = true
				end

				warn("player exploiting!", player)

				local response = configuration.getConfigurationValue("tpExploitPunishment")
				if response == "suspicion" then
					local amount = configuration.getConfigurationValue("tpExploitPunishmentSuspicionAddAmount")
					addSuspicion(player, amount or 25)
				elseif response == "kick" then
					player:Kick("TP Exploiting")
				elseif response == "redirect" then
					player:Kick("Anti-exploit")
--					game:GetService("TeleportService"):Teleport(2376885433, player, nil, game.ReplicatedStorage.returnToLobby)
				end
			end
		end
	end

	network:create("incrementPlayerArcadeScore", "BindableFunction", "OnInvoke", function(player, scoreToAdd)
		local playerPositionData = playerPositionDataContainer[player]

		if playerPositionData then
			table.insert(playerPositionData.sketchyMovements, {movementRatio = scoreToAdd; timestamp = tick()})

			checkIfPlayerIsBad(player)
		end
	end)

	while true do
		local step = wait(positionCheckHeartbeatTick)

		for player, playerPositionData in pairs(playerPositionDataContainer) do
			if player:FindFirstChild("isPlayerSpawning") and not player.isPlayerSpawning.Value and player:FindFirstChild("playerSpawnTime") and (os.time() - player.playerSpawnTime.Value >= 5) then
				if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart:FindFirstChild("state") and player.Character.PrimaryPart.state.Value ~= "dead" and configuration.getConfigurationValue("isTeleportingExploitFixEnabled", player) then
					local playerData = playerDataContainer[player]

					if #playerPositionData.positions > 0 then
						local currPosition = player.Character.PrimaryPart.Position
						local currVelocity = player.Character.PrimaryPart.Velocity

						local prevPosition = playerPositionData.positions[#playerPositionData.positions].position
						local prevVelocity = playerPositionData.positions[#playerPositionData.positions].velocity

						local playerVelocityForCalculations = currVelocity.magnitude > prevVelocity.magnitude and currVelocity or prevVelocity

						if playerVelocityForCalculations.magnitude < 0.1 then
							if (currPosition - prevPosition).magnitude >= 0.1 then
								if (currPosition - prevPosition).magnitude < playerData.nonSerializeData.statistics_final.walkspeed * step then
									playerVelocityForCalculations = (currPosition - prevPosition).unit * playerData.nonSerializeData.statistics_final.walkspeed * step
								end
							else
								-- actually nothing is going on
								playerVelocityForCalculations = Vector3.new()
							end
						elseif playerVelocityForCalculations.magnitude < playerData.nonSerializeData.statistics_final.walkspeed * step then
							playerVelocityForCalculations = playerVelocityForCalculations.unit * playerData.nonSerializeData.statistics_final.walkspeed * step
						end

						-- pretend double?
						playerVelocityForCalculations = playerVelocityForCalculations * configuration.getConfigurationValue("server_TPExploitVelocityMultiplier")


						local delta 		= ((currPosition - prevPosition) * Vector3.new(1, 0, 1)).magnitude

						-- stuns set your walkspeed to zero so let's not ban people just for getting stunned yeah?
						local walkspeed = math.max(playerData.nonSerializeData.statistics_final.walkspeed, 0.1)

						local movementRatio = delta / (math.max((playerVelocityForCalculations * Vector3.new(1, 0, 1)).magnitude, walkspeed) * step)

						-- we're not kicking anyone for going too slowly, just chill out
						if playerVelocityForCalculations.Magnitude < 16 then
							movementRatio = 1
						end

						table.insert(playerPositionData.positions, {position = currPosition; velocity = player.Character.PrimaryPart.Velocity})

						if #playerPositionData.positions > 10 then
							table.remove(playerPositionData.positions, 1)
						end

						-- 2x is running
						if delta > (playerData.nonSerializeData.statistics_final.walkspeed * 3) * step then
							-- flag!
							local isPlayerGood = false

							if not isPlayerGood then
								local isCurrNearDoor, currDoor = isNearbyAcceptableObject(currPosition, doors, "curr")
								local isPrevNearDoor, prevDoor = isNearbyAcceptableObject(prevPosition, doors, "prev")
								if isCurrNearDoor and isPrevNearDoor then
									isPlayerGood = true
								elseif isCurrNearDoor or isPrevNearDoor then
									local door1 	= currDoor or prevDoor
									local otherDoor = getOtherDoorFromDoor(door1)

									if otherDoor then
										local ray = Ray.new(door1.Position, otherDoor.Position - door1.Position)

										if (currPosition - getRayClosestPoint(ray, currPosition)).magnitude <= ACCEPTABLE_THRESHOLD_FOR_NEARBY and (prevPosition - getRayClosestPoint(ray, prevPosition)).magnitude <= ACCEPTABLE_THRESHOLD_FOR_NEARBY then
											isPlayerGood = true
											warn("is good at intersection!")
										end
									end
								end
							end

							if not isPlayerGood then
								local isNearbyEscapeRope, nearestEscapeRope = isNearbyAcceptableObject(prevPosition, escapeRopes)
								if isNearbyEscapeRope and (nearestEscapeRope.Parent.Target.Position - currPosition).magnitude <= ACCEPTABLE_THRESHOLD_FOR_NEARBY then
									isPlayerGood = true
								elseif nearestEscapeRope then
									local ray = Ray.new(nearestEscapeRope.Position, nearestEscapeRope.Parent.Target.Position - nearestEscapeRope.Position)

									if (currPosition - getRayClosestPoint(ray, currPosition)).magnitude <= ACCEPTABLE_THRESHOLD_FOR_NEARBY and (prevPosition - getRayClosestPoint(ray, prevPosition)).magnitude <= ACCEPTABLE_THRESHOLD_FOR_NEARBY then
										isPlayerGood = true
										warn("is good at intersection for rope!")
									end
								end
							end

							if not isPlayerGood then
								local isNearbyCannon, cannon = isNearbyAcceptableObject(prevPosition, cannons)
								if isNearbyCannon then
									if math.acos((cannon.Parent.target.CFrame.lookVector * Vector3.new(1, 0, 1)).unit:Dot(((currPosition - prevPosition).unit))) <= math.pi / 2 then
										playerPositionData.lastCannon 			= cannon
										playerPositionData.lastTimeNearCannon 	= tick()
									end
								end

								if playerPositionData.lastTimeNearCannon and tick() - playerPositionData.lastTimeNearCannon <= 7 then
									if math.acos((playerPositionData.lastCannon.Parent.target.CFrame.lookVector * Vector3.new(1, 0, 1)).unit:Dot(((currPosition - prevPosition).unit))) <= math.pi / 2 then
										isPlayerGood = true
									end
								else
									playerPositionData.lastCannon 			= nil
									playerPositionData.lastTimeNearCannon 	= nil
								end
							end

							if not isPlayerGood then
								local playerUnitVelocity = playerVelocityForCalculations.magnitude > 0.01 and playerVelocityForCalculations.unit or Vector3.new()

								-- if the directions at least 72 degrees align..
								if math.acos((playerUnitVelocity * Vector3.new(1, 0, 1)):Dot(((currPosition - prevPosition).unit * Vector3.new(1, 0, 1)))) <= math.pi / 2 then
									-- ok... figure out now what couldve caused this massive velocity..
									if movementRatio <= 1 then
										isPlayerGood = true
									end
								end
							end

							-- check abilities
							if not isPlayerGood then
								local activeAbilityIds = network:invoke("getCurrentlyActiveAbilityGUIDsForPlayer", player)

								for _, abilityId in pairs(activeAbilityIds) do
									local ability = abilityLookup[abilityId](playerData)
									if ability and ability.__serverValidateMovement then
										if ability.__serverValidateMovement(player, prevPosition, currPosition) then
											isPlayerGood = true

											break
										end
									end
								end
							end

							if not isPlayerGood then
								table.insert(playerPositionData.sketchyMovements, {movementRatio = movementRatio; timestamp = tick()})

								checkIfPlayerIsBad(player)
							end
						end
					else
						table.insert(playerPositionData.positions, {position = player.Character.PrimaryPart.Position; velocity = player.Character.PrimaryPart.Velocity})
					end
				else
					playerPositionData.positions = {}
				end
			else
				-- wipe if respawning, just incase
				if playerPositionData.positions and #playerPositionData.positions > 0 then
					playerPositionData.positions = {}
				end
			end
		end
	end
end