local module = {}
module.priority = 3
-- DATASTORE WRAPPER TO RETURN playerSaveFileData, table storing all there is to know about the player's
-- file on that save!
-- Authors: Polymorphic, berezaa

local RunService = game:GetService("RunService")

-- set this flag to true to do data modification in studio
-- misuse of this would be a mistake, so make sure you're
-- careful with it. search its name to see where you can
-- do the data modification
local PERFORMING_STUDIO_PLAYER_DATA_MODIFICATION = false

local utilities
local network

local DataStoreService = game:GetService("DataStoreService")

local TESTING = false

local isInternal = (game.PlaceId == 2061558182 or game.ReplicatedStorage:FindFirstChild("doNotSaveData") or RunService:IsStudio())


--[[
	inventorySlotData {}
		number id
		number stacks
		number position [1 - MAX_INVENTORY_SLOTS]
			> position is a unique number, game will violently remove
			  contents that overlap if no extra space is available
		modifierData modifierData

	equipmentSlotData {}
		number id
		number position
			1 = weapon
			2 = helmet
			3 = body
			4 = left arm
			5 = right arm
			6 = left leg
			7 = right leg
			> position is a unique number, game will violently remove
			  contents that overlap if no inventory space is available

	accessory

	hotbarSlotData {}
		number id
		dataType dataType [look at mapping]
		number position

	modifierData {}

		-- all these refer to *flat* bonuses, you can make them percentage increases of the base stat
		-- by making the stat [name]Percent, for example: expPercentage = 0.1 would mean a 10% increase of all exp gain
		-- and dexPercent = 0.1 would mean a 10% increase of dex (after all flat amounts are summed)
		int... [dex, int, str, vit, luck, exp]

		string sourceType
		int sourceId
		int sourcePlayerId

	statisticsModifier {}
		int expiration
		{modifierData} modifiers

	accessoryData {}
		accessoryType[mapping] accessoryType
		int id
		int color

		modifierData modifierData

		--> hat, skin, undershirt, underwear, face

	{accessoryData} accessories {}
--]]

-- 21 = production version 3/3/2020

---WARNING-----------------
---WARNING-----------------
---WARNING-----------------
---WARNING-----------------
-- the global version of datstores, incrementing this lets you wipe everyone's data or revert back to a previous version
-- do not change for fun!
--local datastoreVersion = 21

local datastoreVersion = 35

-- 21: main production

-- been set to 21 since alpha-1.0.0
---WARNING-----------------
---WARNING-----------------
---WARNING-----------------
---WARNING-----------------

-- demo override
--if game.GameId == 712031239 then
--	datastoreVersion = 30
--end

local function GetMostRecentSaveTime(pages)
	for _, Pair in pairs(pages:GetCurrentPage()) do
		return Pair.value
	end
end



--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

local function __intGetPlayerGlobalSaveFileData(player, providedVersion)

	local PlayerId 			= player.userId

	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- GODS

	local LastGlobalSave

	-- obtain latest GDS version data from GODS
	local GODSSuccess, GODSError = pcall(function()
		local suffix = (game.ReplicatedStorage:FindFirstChild("mirrorWorld") and "mirror") or ""
		local GlobalOrderedStore = DataStoreService:GetOrderedDataStore(tostring(PlayerId), "GlobalPlayerSaveTimes" .. datastoreVersion .. suffix)
		local pages = GlobalOrderedStore:GetSortedAsync(false, 1)
		LastGlobalSave = GetMostRecentSaveTime(pages)
	end)

	-- GODS call failed, abort.
	if not GODSSuccess then
		return false, nil, "(GODS): "..GODSError
	end

	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- GODS -> GDS

	local GlobalData
	local function loadVersion(version)
		local GDSSuccess, GDSError = pcall(function()
			local suffix = (game.ReplicatedStorage:FindFirstChild("mirrorWorld") and "mirror") or ""
			local GlobalDataStore = DataStoreService:GetDataStore(tostring(PlayerId), "GlobalPlayerData" .. datastoreVersion .. suffix)
			GlobalData = GlobalDataStore:GetAsync(tostring(version))
		end)

		-- GDS call failed, abort.
		if not GDSSuccess then
			return false, "(GDS): "..GDSError
		end

		return true, ""
	end

	if providedVersion then
		local success, message = loadVersion(providedVersion)

		if not success then
			return false, nil, message
		end
	end

	-- if providedVersion failed or we weren't given a providedVersion, do as normal
	if not GlobalData then
		local success, message = loadVersion(LastGlobalSave)

		if not success then
			return false, nil, message
		end
	end

	if (LastGlobalSave and GlobalData == nil) then
		local issue = "globalSave-NoData"
		spawn(function()
			network:invoke("reportError", player, "critical", "LastGlobalSave provided but no GlobalData??")
		end)
		player:Kick("Critical error prevented your data from being loaded. The developers have been alerted. Please try again later. Error code: "..issue)
		error("Game rejected data.")
		return false, nil, "game rejected data"
	elseif providedVersion and LastGlobalSave == nil then
		local issue = "globalSave-providedNoLast"
		spawn(function()
			network:invoke("reportError", player, "critical", "providedVersion but no LastGlobalSave")
		end)
		player:Kick("Critical error prevented your data from being loaded. The developers have been alerted. Please try again later. Error code: "..issue)
		error("Game rejected data.")
		return false, nil, "game rejected data"
	end

	-- this tool may be useful later

	--[[
	-- ROLLBACK!
	local minTime = 1583707058
	local maxTime = 1583710658
	if GlobalData and GlobalData.lastSaveTimestamp then
		if GlobalData.lastSaveTimestamp >= minTime and GlobalData.lastSaveTimestamp <= maxTime then
			if not GlobalData.rollback1 then
				game:GetService("TeleportService"):Teleport(2759159666, player)
				return false, nil, "Requires rollback"
			end
		end
	end
	]]

	--------------------------------------------------------------------------------------------------------------------------------------------------
	return true, GlobalData, "Successfully loaded!"

end

function module:getPlayerGlobalSaveFileData(player, providedVersion)
	return __intGetPlayerGlobalSaveFileData(player, providedVersion)
end



-- internal interface with datastores to save JUST global data
local function __intUpdatePlayerGlobalSaveFileData(PlayerId, playerGlobalData)



	if game.PlaceId == 3372071669 or isInternal then
		return true, nil, playerGlobalData.version
	end

	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- Sanity checks

	if not playerGlobalData.version then
		return false, "no global version"
	end

	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- GDS
	local suffix = (game.ReplicatedStorage:FindFirstChild("mirrorWorld") and "mirror") or ""
	local GlobalDataStore = DataStoreService:GetDataStore(tostring(PlayerId), "GlobalPlayerData" .. datastoreVersion .. suffix)

	local GDSSuccess, GDSError = pcall(function()
		GlobalDataStore:SetAsync(tostring(playerGlobalData.version), playerGlobalData)
	end)

	if not GDSSuccess then
		warn("GDS update Failed!")
		return false, "(GDS): ".. GDSError
	end

	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- GODS
	local suffix = (game.ReplicatedStorage:FindFirstChild("mirrorWorld") and "mirror") or ""
	local GlobalOrderedDataStore = DataStoreService:GetOrderedDataStore(tostring(PlayerId), "GlobalPlayerSaveTimes" .. datastoreVersion .. suffix)

	local GODSSuccess, GODSError = pcall(function()
		GlobalOrderedDataStore:SetAsync("s" .. tostring(playerGlobalData.version), playerGlobalData.version)
	end)

	if not GODSSuccess then
		warn("GODS update Failed!")
		return false, "(GODS): " .. GODSError
	end
	--------------------------------------------------------------------------------------------------------------------------------------------------

	return true, nil, playerGlobalData.version
end

function module:updatePlayerGlobalSaveFileData(playerId, playerGlobalData)
	return __intUpdatePlayerGlobalSaveFileData(playerId, playerGlobalData)
end

--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-- internal interface with datastores to get data
local function __intGetPlayerSaveFileData(player, saveFileNumber, desiredVersion)

	-- dont load datastores in studio
	if (RunService:IsStudio() or RunService:IsRunMode()) and (not PERFORMING_STUDIO_PLAYER_DATA_MODIFICATION) then

		-- new adventure
		if game.PlaceId == 4561988219 then
			local Data = {}
			Data.newb = true
			Data.globalData = {}
			return true, Data
		end
		if game.PlaceId == 4041427413 then
			local Data = {}
			Data.newb = true
			Data.globalData = {}
			return true, Data
		end

		local Tag = player:FindFirstChild("dataSlot")
		if Tag == nil then
			Tag = Instance.new("IntValue")
			Tag.Name = "dataSlot"
			Tag.Parent = player
			Tag.Value = 0

			--return true, game.HttpService:JSONDecode('{"quests":{"active":[{"objectives":[{"completion":{"amount":30},"triggerType":"monster-killed","requirement":{"amount":30,"monsterName":"Shroom"}}],"id":2}],"completed":[{"completionTime":1549512122.07898211479187011719,"id":1},{"completionTime":1549573249.58895897865295410156,"id":4},{"completionTime":1549671842.90531301498413085938,"id":5}]},"hotbar":[{"position":2,"dataType":1,"id":22},{"position":6,"dataType":2,"id":10},{"position":1,"dataType":1,"id":6},{"position":3,"dataType":1,"id":29},{"position":4,"dataType":1,"id":45},{"position":7,"dataType":1,"id":22},{"position":8,"dataType":1,"id":22},{"position":9,"dataType":1,"id":22},{"position":10,"dataType":1,"id":22},{"position":5,"dataType":1,"id":22}],"professions":{"fishing":{"level":1,"exp":0}},"sessionCount":52,"holding":[],"lastPhysicalPosition":[-57,38,-381],"flags":{"revokeCheatWeapons":true,"statCheck":true,"fixcolors2":true,"badges2":true,"stealthRevoke":true,"removeSpiderQueenCrown":true},"internalData":{"suspicion":0},"newb":false,"equipment":[{"modifierData":[{"baseDamage":3},{"baseDamage":3},{"baseDamage":3},{"baseDamage":3},{"baseDamage":3},{"baseDamage":3},{"baseDamage":3}],"successfulUpgrades":7,"upgrades":7,"id":50,"position":1,"stacks":1},{"position":8,"stacks":1,"id":84},{"position":2,"stacks":1,"id":85}],"moneyFlag2":true,"abilities":[{"rank":5,"id":1},{"rank":3,"id":2},{"rank":1,"id":3},{"rank":10,"id":6},{"rank":1,"id":7},{"rank":5,"id":10}],"statusEffects":[],"inventory":[{"position":25,"stacks":7,"id":89},{"position":24,"stacks":33,"id":88},{"position":23,"stacks":1,"id":14},{"position":22,"stacks":1,"id":6},{"spawnChance":0.5,"id":60,"stacks":1,"position":22,"itemName":"goblin necklace"},{"spawnChance":0.0500000000000000027755575615629,"id":87,"stacks":12,"position":21,"itemName":"arrow"},{"spawnChance":0.299999999999999988897769753748,"id":88,"stacks":7,"position":21,"itemName":"mana potion 2"},{"position":20,"stacks":1,"id":64},{"position":19,"stacks":1,"id":14},{"position":18,"stacks":22,"id":22},{"spawnChance":0.0400000000000000008326672684689,"id":89,"stacks":99,"position":17,"itemName":"health potion 3"},{"position":16,"stacks":23,"id":96},{"position":16,"stacks":5,"id":22},{"position":15,"stacks":70,"id":95},{"position":15,"stacks":5,"id":22},{"position":14,"stacks":99,"id":96},{"position":14,"stacks":5,"id":22},{"position":13,"stacks":99,"id":96},{"position":13,"stacks":6,"id":22},{"position":12,"stacks":99,"id":96},{"spawnChance":0.100000000000000005551115123126,"id":47,"stacks":2,"position":12,"itemName":"intelligence potion"},{"position":11,"stacks":16,"id":22},{"position":11,"stacks":99,"id":96},{"position":10,"stacks":99,"id":96},{"position":10,"stacks":5,"id":22},{"position":9,"stacks":99,"id":96},{"position":9,"stacks":5,"id":22},{"position":8,"stacks":6,"id":22},{"position":8,"stacks":99,"id":96},{"position":7,"stacks":5,"id":22},{"position":7,"stacks":1,"id":50},{"position":7,"stacks":99,"id":95},{"position":6,"stacks":9,"id":22},{"spawnChance":0.900000000000000022204460492503,"id":86,"stacks":99,"position":6,"itemName":"hay"},{"position":6,"stacks":1,"id":81},{"position":5,"stacks":7,"id":77},{"position":5,"stacks":1,"id":37},{"position":5,"stacks":5,"id":22},{"position":4,"stacks":50,"id":31},{"position":4,"stacks":1,"id":21},{"position":4,"stacks":5,"id":22},{"spawnChance":0.0100000000000000002081668171172,"id":20,"stacks":1,"position":3,"itemName":"rake"},{"spawnChance":0.00800000000000000016653345369377,"id":45,"stacks":10,"position":3,"itemName":"vitality potion"},{"spawnChance":0.699999999999999955591079014994,"id":10,"stacks":2,"position":3,"itemName":"mushroom beard"},{"position":2,"stacks":56,"id":86},{"position":2,"stacks":5,"id":22},{"spawnChance":0.0400000000000000008326672684689,"id":7,"stacks":1,"position":2,"itemName":"wooden club"},{"position":1,"stacks":99,"id":6},{"spawnChance":1,"id":9,"stacks":81,"position":1,"itemName":"mushroom spore"},{"position":1,"stacks":1,"id":36}],"statistics":{"pointsUnassigned":0,"pointsAssigned":0,"modifierData":[],"dex":35,"int":1,"vit":17,"str":25},"lastLocation":2471035818,"treasureChests":{"ChestSpiderQnEZ":{"time":1549809595},"ChestJungleCave":{"time":1549807288},"ChestJungleHighUp":{"time":1549610051},"ChestCaveRoom1":{"time":1549513159},"ChestGhrotto":{"time":1549671139},"ChestJungleView":{"time":1549803003},"ChestBar":{"time":1549602753},"ChestWaterBridge":{"time":1549567414},"ChestUnderCave":{"time":1549567402},"ChestJungleCannon":{"time":1549567251},"IronChestDitch":{"chestType":"ironChest","disabled":true},"ChestJungleBarricade":{"time":1549608072},"IronChestSpiderCave":{"chestType":"ironChest","disabled":true},"ChestGoldFIsh":{"chestType":"goldChest","disabled":true},"ChestCave":{"time":1549514147},"ChestBridge":{"time":1549600487},"ChestUnderBridge":{"time":1549515639},"ChestCaveRoom2":{"time":1549513160}},"timestamp":511,"level":26,"gold":221250,"exp":4377.38674400269519537687301636,"hasCustomizedCharacter":true,"accessories":{"hair":1,"undershirt":1,"shirtColorId":1,"face":1,"skinColorId":1,"hairColorId":1,"underwear":1},"class":"Hunter","userSettings":{"keybinds":{"W":"pick up","Q":"interact"},"clearingInteraction":true},"abilityBooks":{"hunter":{"pointsAssigned":16},"adventurer":{"pointsAssigned":9}}}')
		end
		local inven = {gold = 10; level = 1; inventory = {}; equipment = {}; moneyFlag2 = true; isTestingDontSave = true; abilityBooks = {}; abilities = {};}
		inven.globalData = {
		}
		inven.flags = inven.flags or {}
		inven.flags.enchantWipe3 = true
		inven.flags.completedGauntlet = true
		inven.inventory = {
		}
		inven.equipment = {
			{id = 5, position = 1}, -- main hand
			--{id = 179, position = 2}, -- hat
		}




		return true, inven
	end

	local Data
	local PlayerId 			= player.userId
	local Slot 				= saveFileNumber

	local providedVersion


	if desiredVersion then
		providedVersion = desiredVersion
	end



	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- GODS + GDS

	local Suffix = "-slot"..tostring(Slot)
	local LastSave

	local GlobalDataSuccess, GlobalData, GlobalDataStatus = __intGetPlayerGlobalSaveFileData(player, providedVersion)

	if not GlobalDataStatus then
		return false, nil, GlobalDataStatus
	end

	if GlobalData then
		LastSave = GlobalData.lastSave[Suffix]
	end

	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- ODS (legacy)

	-- No data from new method, revert to old method for LastSave
	if not LastSave then
		warn("DSI>Obtaining data from legacy method")
		-- obtain latest data from ODS
		local ODSSuccess, ODSError = pcall(function()
			local suffix = (game.ReplicatedStorage:FindFirstChild("mirrorWorld") and "mirror") or ""
			local OrderedStore 	= DataStoreService:GetOrderedDataStore(tostring(PlayerId), "PlayerSaveTimes" .. datastoreVersion .. Suffix .. suffix) -- dont worry i hate this too
			local pages = OrderedStore:GetSortedAsync(false, 1)
			LastSave = GetMostRecentSaveTime(pages) or 0
		end)

		-- ODS call failed, abort.
		if not ODSSuccess then
			return false, nil, "(ODS): "..ODSError
		end
	end

	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- Sanity Checks
	--[[
	if (providedTimeStamp and LastSave == nil) then
		local issue = "lastSave-nil"
		spawn(function()
			network:invoke("reportError", player, "critical", "LastSave nil for providedTimeStamp")
		end)
		player:Kick("Critical error prevented your data from being loaded. The developers have been alerted. Please try again later. Error code: "..issue)
		error("Game rejected data.")
		return false, nil, "game rejected data"
	elseif (providedTimeStamp and providedTimeStamp > 1) and (LastSave and LastSave <= 1) then
		local issue = "lastSave-lessThan"
		spawn(function()
			network:invoke("reportError", player, "critical", "LastSave lessThan for providedTimeStamp")
		end)
		player:Kick("Critical error prevented your data from being loaded. The developers have been alerted. Please try again later. Error code: "..issue)
		error("Game rejected data.")
		return false, nil,"game rejected data"
	end

	if providedTimeStamp and providedTimeStamp > LastSave then
		-- The player passed a timestamp that is newer than what the ODS has recorded

		LastSave = providedTimeStamp
	end
	]]

	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- Load from DataStore, this should be the same

	local DSSuccess, DSError

	-- player data is available
	if LastSave > 1 then
		DSSuccess, DSError = pcall(function()
			-- This data slot should have data on it
			local suffix = (game.ReplicatedStorage:FindFirstChild("mirrorWorld") and "mirror") or ""
			local DataStore = DataStoreService:GetDataStore(tostring(PlayerId), "PlayerData" .. datastoreVersion .. Suffix .. suffix) -- Suffix .. suffix xD
			Data = DataStore:GetAsync(tostring(LastSave))

			Data.globalData = GlobalData or {}


			local issue

			--------------------------------------------------------------------------------------------------------------------------------------------------
			-- More sanity checks

			if Data == nil then
				if --[[ providedTimeStamp ]] false then
					spawn(function()
						network:invoke("reportError", player, "critical", "DataStores returned nil data for provided timestamp")
					end)
					issue = "nil-provided"
				else
					spawn(function()
						network:invoke("reportError", player, "critical", "DataStores returned nil data for recorded timestamp")
					end)
					issue = "nil-recorded"
				end
			elseif typeof(Data) ~= "table" then
				spawn(function()
					network:invoke("reportError", player, "critical", "DataStores returned invalid (non-table) data")
				end)
				issue = "invalid"
			elseif Data.level == nil or Data.inventory == nil or Data.gold == nil or Data.equipment == nil then
				spawn(function()
					network:invoke("reportError", player, "critical", "DataStores returned data with missing values")
				end)
				issue = "missing"
			end

			if issue then
				player:Kick("Critical error prevented your data from being loaded. The developers have been alerted. Please try again later. Error code: "..issue)
				error("Game rejected data.")
			end

			-- apply timestamp (for legacy saves)
			if Data and not Data.timestamp then
				Data.timestamp = LastSave
			end
		end)
	else
		DSSuccess = true
		Data = {}
		Data.newb = true
		Data.globalData = GlobalData or {}
	end

	-- DataStore failed, return error:
	if not DSSuccess then
		return false, nil, "(DS): "..DSError
	end

	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- All good

	local Tag = player:FindFirstChild("dataSlot")
	if Tag == nil then
		Tag = Instance.new("IntValue")
		Tag.Name = "dataSlot"
		Tag.Parent = player
	end
	Tag.Value = Slot


	return true, Data
end

-- internal interface with datastores to save data
local function __intUpdatePlayerSaveFileData(PlayerId, saveFileNumber, playerSaveFileData, playerGlobalData)
	if game.ReplicatedStorage:FindFirstChild("doNotSaveData") then
		return true, "don't save data here"
	end

	local Slot 				= saveFileNumber

	playerSaveFileData.lastSaveTimestamp = os.time()
	playerGlobalData.lastSaveTimestamp = os.time()


	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- Sanity checks

	if not playerGlobalData.version then
		return false, "no global version"
	end

	if not playerSaveFileData.timestamp then
		return false, "no data timestamp"
	end


	local Suffix = "-slot"..tostring(Slot)


	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- GDS
	local suffix = (game.ReplicatedStorage:FindFirstChild("mirrorWorld") and "mirror") or ""
	local GlobalDataStore = DataStoreService:GetDataStore(tostring(PlayerId), "GlobalPlayerData" .. datastoreVersion .. suffix)

	local GDSSuccess, GDSError = pcall(function()
		GlobalDataStore:SetAsync(tostring(playerGlobalData.version), playerGlobalData)
	end)

	if not GDSSuccess then
		warn("GDS update Failed!")
		return false, "(GDS): ".. GDSError
	end
	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- DS
	local suffix = (game.ReplicatedStorage:FindFirstChild("mirrorWorld") and "mirror") or ""
	local DataStore = DataStoreService:GetDataStore(tostring(PlayerId), "PlayerData" .. datastoreVersion .. Suffix .. suffix) -- we need another programmer

	local DSSuccess, DSError = pcall(function()
		DataStore:SetAsync(tostring(playerSaveFileData.timestamp), playerSaveFileData)
	end)

	if not DSSuccess then
		warn("DS update Failed!")
		return false, "(DS): " .. DSError
	end
	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- GODS
	local suffix = (game.ReplicatedStorage:FindFirstChild("mirrorWorld") and "mirror") or ""
	local GlobalOrderedDataStore = DataStoreService:GetOrderedDataStore(tostring(PlayerId), "GlobalPlayerSaveTimes" .. datastoreVersion .. suffix)

	local GODSSuccess, GODSError = pcall(function()
		GlobalOrderedDataStore:SetAsync("s" .. tostring(playerGlobalData.version), playerGlobalData.version)
	end)

	if not GODSSuccess then
		warn("GODS update Failed!")
		return false, "(GODS): " .. GODSError
	end
	--------------------------------------------------------------------------------------------------------------------------------------------------

	return true, nil, playerGlobalData.version
end

if PERFORMING_STUDIO_PLAYER_DATA_MODIFICATION then
	delay(10, function()
		-- player setup
		local fakePlayer = {
			userId = 133827873,
			UserId = 133827873,
			FindFirstChild = function()
				return {}
			end,
		}

		-- data loading
		local success, data = __intGetPlayerSaveFileData(fakePlayer, 1)

		-- data modification here
		data.level = 30

		-- data saving here
		local success, reason, version = __intUpdatePlayerSaveFileData(fakePlayer.UserId, 1, data, data.globalData)
		print(string.format(
			"data modification for UserId %d was %s because %s. Current version: %d.",
			fakePlayer.UserId,
			success and "successful" or "unsuccessful",
			success and "nothing went wrong" or reason,
			version
		))
	end)
end



local function int__modifyPlayerSaveFileIncludeDefaults(player, saveFileNumber, playerSaveFileData)

	playerSaveFileData.accessories = playerSaveFileData.accessories or {}


	playerSaveFileData.professions = playerSaveFileData.professions or {}

	playerSaveFileData.statistics 	= playerSaveFileData.statistics or {}
		playerSaveFileData.statistics.str = playerSaveFileData.statistics.str or 0
		playerSaveFileData.statistics.int = playerSaveFileData.statistics.int or 0
		playerSaveFileData.statistics.dex = playerSaveFileData.statistics.dex or 0
		playerSaveFileData.statistics.vit = playerSaveFileData.statistics.vit or 0

		playerSaveFileData.statistics.modifierData 		= playerSaveFileData.statistics.modifierData or {}
		playerSaveFileData.statistics.pointsAssigned 	= playerSaveFileData.statistics.pointsAssigned or 0
		playerSaveFileData.statistics.pointsUnassigned 	= playerSaveFileData.statistics.pointsUnassigned or 0

	playerSaveFileData.statusEffects 	= playerSaveFileData.statusEffects or {}
	playerSaveFileData.flags 			= playerSaveFileData.flags or {
		dataRecovery11_14 = true,
	}

	playerSaveFileData.gold 		= playerSaveFileData.gold or 10
	playerSaveFileData.exp 			= playerSaveFileData.exp or 0
	playerSaveFileData.level 		= playerSaveFileData.level or 1

	playerSaveFileData.internalData = playerSaveFileData.internalData or {}
	playerSaveFileData.internalData.suspicion = playerSaveFileData.internalData.suspicion or 0

	if not playerSaveFileData.abilitiesReset2 then
		playerSaveFileData.abilities = {}
		playerSaveFileData.hotbar = {}

		playerSaveFileData.abilitiesReset2 = true
	end

	-- TODO: REMOVE ON 01/12/2018 [DD/MM/YYYY]
	if not playerSaveFileData.flags.stealthRevoke then
		for i, abilitySlotData in pairs(playerSaveFileData.abilities) do
			if abilitySlotData.id == 15 and not playerSaveFileData.abilityBooks.Admin then
				table.remove(playerSaveFileData.abilities, i)

				if playerSaveFileData.abilityBooks.Hunter then
					playerSaveFileData.abilityBooks.Hunter.pointsAssigned = playerSaveFileData.abilityBooks.Hunter.pointsAssigned - (abilitySlotData.rank or 0)
				end

			elseif playerSaveFileData.abilityBooks.Admin then
			end
		end

		playerSaveFileData.flags.stealthRevoke = true
	end

	if not playerSaveFileData.flags.fixcolors2 then
		if playerSaveFileData.accessories then
			if playerSaveFileData.accessories.skinColor then
				playerSaveFileData.accessories.skinColorId = playerSaveFileData.accessories.skinColor
			end
			if playerSaveFileData.accessories.faceColor then
				playerSaveFileData.accessories.faceColorId = playerSaveFileData.accessories.faceColor
			end
			if playerSaveFileData.accessories.hairColor then
				playerSaveFileData.accessories.hairColorId = playerSaveFileData.accessories.hairColor
			end
		end
		playerSaveFileData.flags.fixcolors2 = true
	end

	if not playerSaveFileData.flags.fixcolors3 then
		if playerSaveFileData.accessories then
			if playerSaveFileData.accessories.shirtColor then
				playerSaveFileData.accessories.shirtColorId = playerSaveFileData.accessories.shirtColor
			end
		end
		playerSaveFileData.flags.fixcolors3 = true
	end

	playerSaveFileData.accessories.shirtColorId = playerSaveFileData.accessories.shirtColorId or 1



	if TESTING then
		playerSaveFileData.gold 	= 10000
		playerSaveFileData.level	= 10
	end

	playerSaveFileData.keyPreferences 	= playerSaveFileData.keyPreferences or nil
	playerSaveFileData.health 			= playerSaveFileData.health or nil
	playerSaveFileData.savePosition 	= playerSaveFileData.savePosition or nil
	playerSaveFileData.class 			= playerSaveFileData.class or "Adventurer"

	playerSaveFileData.subclass 		= playerSaveFileData.subclass or nil

	playerSaveFileData.treasureChests	= playerSaveFileData.treasureChests or {}

	playerSaveFileData.quests 			= playerSaveFileData.quests or {}
		playerSaveFileData.quests.completed = playerSaveFileData.quests.completed or {}
		playerSaveFileData.quests.active 	= playerSaveFileData.quests.active or {}



	-------------------


	playerSaveFileData.userSettings = playerSaveFileData.userSettings or {}

	playerSaveFileData.sessionCount = playerSaveFileData.sessionCount or 1


	-- information related to player's save, how to handle errors, etc
	playerSaveFileData.nonSerializeData = {}
		playerSaveFileData.nonSerializeData.saveFileNumber 		= saveFileNumber
		playerSaveFileData.nonSerializeData.playerPointer 		= player
		playerSaveFileData.nonSerializeData.isGlobalPVPEnabled 	= false
		playerSaveFileData.nonSerializeData.whitelistPVPEnabled = {}
		playerSaveFileData.nonSerializeData.temporaryEquipment 	= {}
		playerSaveFileData.nonSerializeData.perksActivated 		= {}
end

function module:getLatestSaveVersion(player)
	local playerId = player.UserId

	local globalOrderedStore = DataStoreService:GetOrderedDataStore(tostring(playerId), "GlobalPlayerSaveTimes" .. datastoreVersion)
	local pages = globalOrderedStore:GetSortedAsync(false, 1)

	if not pages then
		return 0
	end

	pages = pages:GetCurrentPage()

	if not pages[1] then
		return 0
	end

	return pages[1].value
end

function module:getPlayerSaveFileDataOlderThan(player, saveFileNumber, timestamp)
	timestamp = tonumber(timestamp)

	print(string.format("Attempting to find save data with timestamp older than %d.", timestamp))

	local playerId = player.UserId

	local globalOrderedStore = DataStoreService:GetOrderedDataStore(tostring(playerId), "GlobalPlayerSaveTimes" .. datastoreVersion)
	local pages = globalOrderedStore:GetSortedAsync(false, 1)

	if not pages then
		print("Failed to acquire pages for save times. Reverting to default behavior.")

		return self:getPlayerSaveFileData(player, saveFileNumber)
	end

	pages = pages:GetCurrentPage()

	if not pages[1] then
		print("Player does not have any lastSaveId possibilities. Reverting to default behavior.")

		return self:getPlayerSaveFileData(player, saveFileNumber)
	end

	local lastSaveId = pages[1].value
	lastSaveId = tonumber(lastSaveId)

	local lastSaveOlderThanTimestamp
	local lastSaveKey = "-slot"..saveFileNumber

	local globalDataStore = DataStoreService:GetDataStore(tostring(playerId), "GlobalPlayerData" .. datastoreVersion)

	local id = lastSaveId
	while id > 0 do
		local globalData = globalDataStore:GetAsync(tostring(id))

		local lastSaveTimestamp = tonumber(globalData.lastSaveTimestamp)

		print(string.format(
			"Testing id %d: timestamp %d < %d?",
			id,
			lastSaveTimestamp,
			timestamp
		))

		if lastSaveTimestamp <= timestamp then
			print("Found id with older timestamp.")

			lastSaveOlderThanTimestamp = globalData.lastSave[lastSaveKey]

			-- this save file didn't exist before this timestamp, it's new
			if not lastSaveOlderThanTimestamp then
				print("This id does not have a file for this slot. Reverting to default behavior.")

				return self:getPlayerSaveFileData(player, saveFileNumber)

			else
				print("Found save file for this id and this slot. Returning it.")

				local success, playerData, message = self:getPlayerSaveFileData(player, saveFileNumber, lastSaveOlderThanTimestamp)

				if success then
					playerData.globalData.version = lastSaveId
				end

				return success, playerData, message
			end
		end

		id = id - 1
	end

	print("Exhausted all lastSaveId possibilities. Reverting to default behavior.")

	return self:getPlayerSaveFileData(player, saveFileNumber)
end

function module:getPlayerSaveFileData(player, saveFileNumber, desiredVersion)
	local success, playerSaveFileData, errorMsg = __intGetPlayerSaveFileData(player, saveFileNumber, desiredVersion)

	if not success then
		warn("datastore-failure: ", player, errorMsg)
		return success, playerSaveFileData, errorMsg
	end

	int__modifyPlayerSaveFileIncludeDefaults(player, saveFileNumber, playerSaveFileData)

	return success, playerSaveFileData
end

function module:updatePlayerSaveFileData(playerId, playerSaveFileData)

	-- do not save data in testing environment

	if isInternal then
		-- return true
		return true, nil, 0
	end

	playerSaveFileData.newb = false

	-- Record Keeping
	local Slot = playerSaveFileData.nonSerializeData.saveFileNumber

	local Suffix = "-slot"..tostring(Slot)

	playerSaveFileData.timestamp = playerSaveFileData.timestamp + 1
	playerSaveFileData.globalData.version = playerSaveFileData.globalData.version + 1

	playerSaveFileData.globalData.lastSave = playerSaveFileData.globalData.lastSave or {}
	playerSaveFileData.globalData.lastSave[Suffix] = playerSaveFileData.timestamp

	playerSaveFileData.globalData.saveSlotData = playerSaveFileData.globalData.saveSlotData or {}

	local lastLocation = game.ReplicatedStorage:FindFirstChild("lastLocationOverride") and game.ReplicatedStorage.lastLocationOverride.Value or game.PlaceId

	if playerSaveFileData.lastLocationDeathOverride then
		lastLocation = playerSaveFileData.lastLocationDeathOverride
		playerSaveFileData.lastLocationDeathOverride = nil
	end

	playerSaveFileData.globalData.saveSlotData[Suffix] = {
		level = playerSaveFileData.level;
		class = playerSaveFileData.class;
		lastLocation = lastLocation;
		equipment = playerSaveFileData.equipment;
		accessories = playerSaveFileData.accessories;
		customized = true;
	}

	-- Processing
	playerSaveFileData = utilities.copyTable(playerSaveFileData)

	local nonSerializeData 				= playerSaveFileData.nonSerializeData
	playerSaveFileData.nonSerializeData = nil

	local globalData = playerSaveFileData.globalData

	playerSaveFileData.globalData = nil

	-- don't save lastPhysicalPosition if we're gonna get booted somewhere else
	if game:GetService("ReplicatedStorage"):FindFirstChild("lastLocationOverride") then
		playerSaveFileData.lastPhysicalPosition = nil
	end

	-- Last Minute Data
	playerSaveFileData.lastLocation = lastLocation



	-- Saving
	return __intUpdatePlayerSaveFileData(playerId, Slot, playerSaveFileData, globalData)

end

function module:wipePlayerSaveFileData(player, currentPlayerData)
	local playerSaveFileData = {}

	int__modifyPlayerSaveFileIncludeDefaults(player, currentPlayerData.nonSerializeData.saveFileNumber, playerSaveFileData)

	return module:updatePlayerSaveFileData(player.userId, playerSaveFileData)
end

function module.init(Modules)
	utilities = Modules.utilities
	network = Modules.network
end

return module