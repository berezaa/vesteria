local module = {}

function module.getUnusedAbilityBookPoints(abilityBookName, level, assignedPoints)
	local abilityBookLookup = require(script.Parent.Parent.abilityBookLookup)
	local abilityBookInfo = abilityBookLookup[abilityBookName]
	
	local maxPoints = (abilityBookInfo.maxLevel - abilityBookInfo.minLevel) * abilityBookInfo.pointsGainPerLevel
	local totalPoints = math.clamp((level - abilityBookInfo.minLevel) * abilityBookInfo.pointsGainPerLevel, 0, maxPoints) + abilityBookInfo.startingPoints
	
	return totalPoints - assignedPoints	
end

function module.getAbilityCastingOrigin(id)
	
end

function module.getAbilityStatisticsForRank(abilityBaseData, rank)
	
	if abilityBaseData then
		if not abilityBaseData.statistics[rank - 1] then
			-- is first rank
			return abilityBaseData.statistics[rank], {}
		end
		-- not a valid rank
		if not abilityBaseData.statistics[rank] then
			return nil
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

function module.getMouseHoveredTarget(abilityExecutionData)
	-- if we don't know who's casting it's not really worth it
	local player = game.Players:GetPlayerByUserId(abilityExecutionData["cast-player-userId"])
	if not player then return nil, false end
	
	-- acquire a bunch of modules that we require here because
	-- we want to avoid a potential require loop with this module
	-- /shrug
	local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local renders = placeSetup.awaitPlaceFolder("entityRenderCollection")
	
	-- raycast the renders
	local screenPosition = abilityExecutionData["mouse-screen-position"]
	local ray = workspace.CurrentCamera:ViewportPointToRay(screenPosition.X, screenPosition.Y)
	ray = Ray.new(ray.Origin, ray.Direction * 1024)
	local part = workspace:FindPartOnRayWithWhitelist(ray, {renders})
	
	-- handily, damage will get us actual targets from a render part!
	local canDamage, target = damage.canPlayerDamageTarget(player, part)
	
	-- return whatever it gave us, which is potentially nil
	return target, canDamage
end

function module.raycastMap(ray)
	if not module.RAYCAST_IGNORE_LIST then
		local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
		local placeSetup 		= modules.load("placeSetup")
		
		local entitiesFolder = placeSetup.awaitPlaceFolder("entities")
		local spawnRegionCollectionsFolder = placeSetup.getPlaceFolder("spawnRegionCollections")
		local entityManifestCollectionFolder = placeSetup.getPlaceFolder("entityManifestCollection")
		local entityRenderCollectionFolder = placeSetup.getPlaceFolder("entityRenderCollection")
		local itemsFolder = placeSetup.getPlaceFolder("items")
		local foilage = placeSetup.getPlaceFolder("foilage")
		
		module.RAYCAST_IGNORE_LIST = {spawnRegionCollectionsFolder, entityManifestCollectionFolder, entityRenderCollectionFolder, itemsFolder, entitiesFolder, foilage}
	end
	
	return workspace:FindPartOnRayWithIgnoreList(ray, module.RAYCAST_IGNORE_LIST)
end

function module.getMeleeHorizontalHitbox(position, size, abilityExecutionData)
	local targetPoint = abilityExecutionData["mouse-world-position"]
	
	targetPoint = Vector3.new(
		targetPoint.X,
		position.Y,
		targetPoint.Z
	)
	
	local hitboxCFrame =
		CFrame.new(position, targetPoint) *
		CFrame.new(0, 0, -size.Z / 2)
	return hitboxCFrame	
end

function module.getCastingPlayer(abilityExecutionData)
	return game:GetService("Players"):GetPlayerByUserId(abilityExecutionData["cast-player-userId"])
end

function module.calculateStats(data)
	local stats = {}
	
	if data.dynamic then
		for stat, dynamicData in pairs(data.dynamic) do
			local min = dynamicData[1]
			local max = dynamicData[2]
			local newData = {}
			
			newData.offset =
				(max - data.maxRank * min) /
				(1 - data.maxRank)
			newData.slope = min - newData.offset
			
			if #dynamicData >= 3 then
				for index = 3, #dynamicData do
					newData[index] = dynamicData[index]
				end
			end
			
			data.dynamic[stat] = newData
		end
	end
	
	for rank = 1, data.maxRank do
		local rankStats = {}
		
		if rank == 1 and data.static then
			for stat, value in pairs(data.static) do
				rankStats[stat] = value
			end
		end
		
		if data.dynamic then
			for stat, dynamicData in pairs(data.dynamic) do
				rankStats[stat] = rank * dynamicData.slope + dynamicData.offset
				
				if dynamicData[3] == "int" then
					rankStats[stat] = math.floor(rankStats[stat])
				end
			end
		end
		
		if data.staggered then
			for stat, sData in pairs(data.staggered) do
				local totalUpgrades = #sData.levels
				
				-- count how many upgrades we ought to have
				local upgrades = 0
				for _, level in pairs(sData.levels) do
					if rank >= level then
						upgrades = upgrades + 1
					end
				end
				
				-- now we can calculate the value at this rank
				rankStats[stat] = sData.first + ((sData.final - sData.first) / totalUpgrades) * upgrades
				
				if sData.integer then
					rankStats[stat] = math.floor(rankStats[stat])
				end
			end
		end
		
		if data.additive then
			for stat, aData in pairs(data.additive) do
				local amount = 0
				for index = 1, rank do
					amount = amount + aData[index]
				end
				rankStats[stat] = amount
			end
		end
		
		if data.pattern then
			for stat, pData in pairs(data.pattern) do
				local amount = pData.base
				local index = 1
				for _ = 1, rank - 1 do
					amount = amount + pData.pattern[index]
					index = index + 1
					if index > #pData.pattern then
						index = 1
					end
				end
				rankStats[stat] = amount
			end
		end
		
		-- round to nearest two digits
		for stat, amount in pairs(rankStats) do
			rankStats[stat] = math.floor(amount * 100) / 100
		end
		
		stats[rank] = rankStats
	end
	
	return stats
end

local function getKnockbackDirection(delta)
	return (CFrame.new(
			Vector3.new(),
			Vector3.new(delta.X, 0, delta.Z)
		) * CFrame.Angles(math.pi / 4, 0, 0)
	).LookVector
end
function module.knockbackMonster(monster, point, knockback, duration)
	local bv = monster.BodyVelocity
		
	local deltaMaxForce = -bv.MaxForce
	bv.MaxForce = bv.MaxForce + deltaMaxForce
	
	local delta = monster.Position - point
	local direction = getKnockbackDirection(delta)
	monster.Velocity = direction * knockback / monster:GetMass()
	
	delay(duration or 1, function()
		bv.MaxForce = bv.MaxForce - deltaMaxForce
	end)
end
function module.knockbackLocalPlayer(point, knockback)
	-- flat reduction on player knockback
	-- because apparently it's too much
	knockback = knockback / 14
	
	local network = require(script.Parent).load("network")
	
	local player = game.Players.LocalPlayer
	if not player then return end
	local char = player.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end
	
	local delta = manifest.Position - point
	local direction = getKnockbackDirection(delta)
	network:fire("applyJoltVelocityToCharacter", direction * knockback / manifest:GetMass())
end

return module