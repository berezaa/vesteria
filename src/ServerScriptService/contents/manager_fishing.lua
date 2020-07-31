local module = {}

local CollectionService = game:GetService("CollectionService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local network
local placeSetup
local physics

local assetsFolder = ReplicatedStorage.assets

local httpService = game:GetService("HttpService")
local itemLookupContainer = ReplicatedStorage.itemData
local itemLookup = require(itemLookupContainer)

local LATENCY_FORGIVENESS_AFTER_BOBBING = 2.2


local spawnRegionCollectionsFolder

-- keep leveling data for the fish here
local fishpedia = {
	["Fresh Fish"] = {id = "fish"; level = 1; expMulti = 1; favoredRodLevel = 1;};
	["Zebra Fish"] = {id = "pretty pink fish"; level = 1; expMulti = 1; favoredRodLevel = 1;};
	["Rock Fish"] = {id = "tall blue fish";   level = 2; expMulti = 1; favoredRodLevel = 1;};

}

local function getPoolEntry(fishName, chanceRolls)
	if fishpedia[fishName] then
		return {
			id = fishpedia[fishName].id;
			level = fishpedia[fishName].level;
			rolls = chanceRolls;
			favoredRodLevel = fishpedia[fishName].favoredRodLevel;
			expMulti = fishpedia[fishName].expMulti;
		}
	end
	return false, "entry does not exist in fishpedia"
end


-- have the rolls add up to approximately 100 for each map for consistent balance
local fishPool = {
	["2061558182"] = {
		 getPoolEntry("Fresh Fish", 50);
		 getPoolEntry("Zebra Fish", 50);

	};

	["2119298605"] = {
		 {id = "fish"; level = 1; rolls = 20;}
	};
}

local baseHitbox


local playerFishingDataContainer = {}

local rand = Random.new()

local function tick__fishBobbing(player, guid)
	wait(rand:NextInteger(4, 10))

	-- make sure we don't fire for an old fish attempt
	if playerFishingDataContainer[player] and playerFishingDataContainer[player].guid == guid then
		-- check if the bobby is actual in a pile still
		local inRange = false
		for _, spawnRegionCollection in pairs(spawnRegionCollectionsFolder:GetChildren()) do
			for _, child in pairs(spawnRegionCollection.FishFolder:GetChildren()) do
				if child.Parent and child:isA("Part")  then
					if (child.Position - playerFishingDataContainer[player].castPosition).magnitude <= script.spot.Size.Y / 2 +.1 then
						inRange = true
					end
				end
			end
		end

		if inRange then
			playerFishingDataContainer[player].lastTimeBobbed = tick()
			network:fireClient("signal_fishingBobBobbed", player)
		end

		-- tick again
		tick__fishBobbing(player, guid)
	end
end

local function playerRequest_startFishing(player, castPosition)
	if not playerFishingDataContainer[player] then
		-- tracking cast position now for security and practical reasons
		local char = player.Character
		if char then
			if (char.PrimaryPart.Position - castPosition).magnitude > 100 then return end
		else
			return
		end

		local playerData = network:invoke("getPlayerData", player)

		if playerData then
			-- todo: check for rod, account for strength, etc
			local guid = httpService:GenerateGUID(false)

			local playerFishingData = {}
				--playerFishingData.rod 			= nil
				playerFishingData.lastTimeBobbed 	= 0
				playerFishingData.guid 				= guid
				playerFishingData.castPosition      = castPosition


			playerFishingDataContainer[player] = playerFishingData

			spawn(function()
				wait(1)
				if playerFishingDataContainer[player] and playerFishingDataContainer[player].guid == guid then
					tick__fishBobbing(player, guid)
				end
			end)

			return true
		end
	end
end

-- added security
local function playerRequest_reelFishingRod(player, bobPosition)
	if playerFishingDataContainer[player] then
		if tick() - playerFishingDataContainer[player].lastTimeBobbed <= LATENCY_FORGIVENESS_AFTER_BOBBING then -- latency + being quick enough to react, ya dig
			playerFishingDataContainer[player] = nil

			--local fishToSpawnId = {30;30;30;30;30;30;30;30; 38; 39; 40; 41; 42}

			-- grab dat fish
			local mapPool = fishPool[tostring(game.PlaceId)]
			if mapPool == nil then return end

			local fishingLevel = network:invoke("getProfessionLevel", player, "fishing") or 1

			-- do a check with the rod to give a slight edge to the rarer fish. level will unlock the fish and the rod will give you a better chance at catching better fish
			-- formula will be: check if player's rod is >= to the fish's favoredRodLevel, and if so, increase the chances of that specific fish by x% by creating more roll entries
			-- % increase determined by how many rod levels you are above the favored rod level
			-- so if a high level player for whatever reason wants to catch a lower level fish, they have the option to do it by changing rods versus the game forcing them to catch a high level fish even more based off of their level

			local primaryEquipment = network:invoke("getPlayerEquipmentDataByEquipmentPosition", player, 1)
			if primaryEquipment == nil then return end
			local primaryId = primaryEquipment.id

			local rodLevel = 0

			if primaryId == 37 then
				-- old fishing pole
				rodLevel = 1
			else
				return -- that aint no rod
			end

			local validPool = {}

			for _, fish in pairs(mapPool) do
				if fish.level <= fishingLevel then
					if fish.favoredRodLevel < rodLevel then
						for _ = 1, fish.rolls do
							table.insert(validPool, fish.id)
						end

					else
						for _ = 1, fish.rolls + math.clamp((fishingLevel - fish.level)*2, 0,  fish.rolls)  do -- can up to double the rolls on a given map
							table.insert(validPool, fish.id)
						end
					end

				end
			end

			if #validPool == 0 then return end

			local lottery = validPool[rand:NextInteger(1, #validPool)]
			local fishToSpawnItemId = itemLookup[lottery].id

			-- todo: validation
			local fish = network:invoke("spawnItemOnGround", {id = fishToSpawnItemId}, bobPosition + Vector3.new(0, 0.5, 0), {player})
			local facingVelocity = (bobPosition - player.Character.PrimaryPart.Position).unit

			local r = CFrame.new(Vector3.new(), facingVelocity) * CFrame.Angles(-math.pi / 4, math.pi / 8 * (rand:NextInteger() - 0.5) * 2, 0)

			local fishVelocity 	= -Vector3.new(r.lookVector.X, r.lookVector.Y * 1.4, r.lookVector.Z) * 50
			fish.Velocity 		= fishVelocity

			local attachment = Instance.new("Attachment")
			attachment.Parent = fish

			fish:SetNetworkOwner(player)
			fish.HumanoidRootPart:SetNetworkOwner(player)


			local playerData = network:invoke("getPlayerData", player)
			if playerData then
				-- award xp
				--playerData.nonSerializeData.incrementPlayerData("exp",xp)
			end

			return true, fish, fishVelocity
		else
			playerFishingDataContainer[player] = nil
		end
	end
end

local function onPlayerRemoving(player)
	playerFishingDataContainer[player] = nil
end

local FISH_SPAWN_CYCLE_TIME 			= 1.5

function module.init(Modules)

	network = Modules.network
	placeSetup = Modules.placeSetup
	physics = Modules.physics

	spawnRegionCollectionsFolder = placeSetup.getPlaceFolder("fishingRegionCollections")

	baseHitbox = assetsFolder.entities.spot:Clone()
	baseHitbox.CanCollide = true
	baseHitbox.Anchored = true
	CollectionService:AddTag(baseHitbox, "fishingSpot")
	physics:setWholeCollisionGroup(baseHitbox, "fishingSpots")

	game.Players.PlayerRemoving:connect(onPlayerRemoving)

	network:create("playerRequest_startFishing", "RemoteFunction", "OnServerInvoke", playerRequest_startFishing)
	network:create("playerRequest_reelFishingRod", "RemoteFunction", "OnServerInvoke", playerRequest_reelFishingRod)
	network:create("signal_fishingBobBobbed", "RemoteEvent")

	spawn(function()
		while wait(0 or FISH_SPAWN_CYCLE_TIME ) do
			if spawnRegionCollectionsFolder == nil then return end

			for _, spawnRegionCollection in pairs(spawnRegionCollectionsFolder:GetChildren()) do
				--monsterType, monsterSpawnAmount
				local _, monsterSpawnAmount = string.match(spawnRegionCollection.Name, "(.+)-(%d+)")
				monsterSpawnAmount = tonumber(monsterSpawnAmount)

				if monsterSpawnAmount then
					local amntToSpawn = monsterSpawnAmount - #spawnRegionCollection.FishFolder:GetChildren()

					if amntToSpawn > 0 then
						-- look up fish stuff to get the stats
						local fish = baseHitbox:Clone()

						local spawnParts = {}
						for _, child in pairs(spawnRegionCollection:GetChildren()) do
							if child:isA("Part") then
								table.insert(spawnParts, child)
							end
						end

						local randPart = spawnParts[rand:NextInteger(1,#spawnParts)]

						-- fix the randomization here
						local randomX = rand:NextInteger(randPart.Position.X - randPart.Size.X/2, randPart.Position.X + randPart.Size.X/2)
						local randomZ = rand:NextInteger(randPart.Position.Z - randPart.Size.Z/2, randPart.Position.Z + randPart.Size.Z/2)

						fish.Position = Vector3.new(randomX, randPart.Position.Y + randPart.Size.Y/2 -.25 , randomZ) --- .75
						fish.effect.Position = fish.Position - Vector3.new(0,.75,0)
						fish.Parent = spawnRegionCollection.FishFolder

						game.Debris:AddItem(fish, rand:NextInteger(20, 60))
					end
				end
			end
		end
	end)
end

return module