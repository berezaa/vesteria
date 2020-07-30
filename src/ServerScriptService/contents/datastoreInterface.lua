-- DATASTORE WRAPPER TO RETURN playerSaveFileData, table storing all there is to know about the player's
-- file on that save!
-- Authors: Polymorphic, berezaa

-- set this flag to true to do data modification in studio
-- misuse of this would be a mistake, so make sure you're
-- careful with it. search its name to see where you can
-- do the data modification
local PERFORMING_STUDIO_PLAYER_DATA_MODIFICATION = false

-- todo: refactor save + load method later!!
local replicatedStorage = game:GetService("ReplicatedStorage")
local modules = require(replicatedStorage.modules)
local levels = modules.load("levels")
local utilities = modules.load("utilities")
local network = modules.load("network")
local abilityBookLookup = require(replicatedStorage:WaitForChild("abilityBookLookup"))

local module = {}

local dataStoreService = game:GetService("DataStoreService")

local TESTING = false

module.priority = 3

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

local RunService = game:GetService("RunService")

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
		local GlobalOrderedStore 	= game:GetService("DataStoreService"):GetOrderedDataStore(tostring(PlayerId), "GlobalPlayerSaveTimes" .. datastoreVersion .. suffix)
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
			local GlobalDataStore = game:GetService("DataStoreService"):GetDataStore(tostring(PlayerId), "GlobalPlayerData" .. datastoreVersion .. suffix)
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



	if game.PlaceId == 3372071669 or game.PlaceId == 2061558182 or game.ReplicatedStorage:FindFirstChild("doNotSaveData") then
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
	local GlobalDataStore = game:GetService("DataStoreService"):GetDataStore(tostring(PlayerId), "GlobalPlayerData" .. datastoreVersion .. suffix)

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
	local GlobalOrderedDataStore = game:GetService("DataStoreService"):GetOrderedDataStore(tostring(PlayerId), "GlobalPlayerSaveTimes" .. datastoreVersion .. suffix)

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
--		local inven = game.HttpService:JSONDecode('{"quests":{"active":[],"completed":[{"completionTime":1552487902.63018369674682617188,"id":1},{"completionTime":1552488580.85258817672729492188,"id":2},{"completionTime":1552511425.31855106353759765625,"id":6},{"completionTime":1552498462.74624013900756835938,"id":3},{"completionTime":1552517134.68525004386901855469,"id":5},{"completionTime":1552514091.07201981544494628906,"id":4}]},"professions":{"fishing":{"level":1,"exp":0}},"abilities":[{"rank":1,"id":3},{"rank":5,"id":2},{"rank":8,"id":4},{"rank":3,"id":1},{"rank":5,"id":9},{"rank":2,"id":12}],"holding":[],"lastPhysicalPosition":[243,-36,271],"flags":{"revokeCheatWeapons":true,"statCheck":true,"badges2":true,"stealthRevoke":true,"fixcolors2":true,"removeSpiderQueenCrown":true},"internalData":{"suspicion":0},"timestamp":1193,"level":24,"sessionCount":46,"treasureChests":{"ChestWarFortRoof":{"time":1553024070},"ChestWarFortUnderBridge":{"time":1553024644},"ChestCrane":{"time":1554514823},"ChestGhrotto":{"time":1553032186},"ChestSnowCliffSide":{"time":1553023637},"ChestWaterBridge":{"time":1553044388},"ChestOverlook":{"time":1553044916},"ChestBigWater":{"time":1553099980},"ChestLakeMid":{"time":1553031394},"ChestUpAHill":{"time":1553023011},"ChestJungleSeaFloor":{"time":1553095782},"ChestUnderLog":{"time":1553032109},"ChestDitch":{"time":1554514880},"ChestLabBehindFence":{"time":1553022058},"ChestJungleCave":{"time":1553034279},"ChestSpider2":{"time":1553483420},"ChestLogSnow":{"time":1553023727},"ChestWWaterfall":{"time":1553100076},"ChestSnowFallenTree":{"time":1553023065},"ChestBar":{"time":1553045447},"ChestLowRoof":{"time":1553045685},"ChestWarFortTop1":{"time":1552550889},"ChestCave":{"time":1553032129},"ChestuBRIDGE":{"time":1553028709},"ChestRedwoodFallen":{"time":1553022818},"ChestLabAroundCorner":{"time":1553021924},"ChestUnderShip":{"time":1553095905},"ChestUnderCave":{"time":1553044348},"ChestBackalley":{"time":1554514832},"ChestJungleBarricade":{"time":1553095481},"ChestBehindHouse":{"time":1552597960},"ChestSpiderQnEZ":{"time":1552618367},"ChestUpTop":{"time":1554514785},"IronChestBalcony":{"chestType":"ironChest","disabled":true},"ChestUnderWaterLog":{"time":1553031730},"ChestOnABoat":{"time":1553045005},"ChestGoldFIsh":{"chestType":"goldChest","disabled":true},"ChestWarFortTop2":{"time":1552550891},"ChestSpiderQn1":{"time":1552618185},"ChestCastleTop":{"time":1554514801},"ChestJungleView":{"time":1553033913},"ChestJungleCannon":{"time":1553095286},"ChestSpider1":{"time":1553483421},"ChestSmCave":{"time":1552597812},"ChestWLake":{"time":1553046564},"ChestMushroomCapHat":{"chestType":"goldChest","disabled":true},"ChestWarFortMcLov":{"time":1553024033},"ChestHouse":{"time":1552597913},"ChestJungleHighUp":{"time":1553095277},"ChestSecretEntrance":{"time":1553022318},"ChestCaveRoom1":{"time":1552597844},"ChestCaveRoom2":{"time":1552597842},"ChestUnderBridge":{"time":1554514887},"ChestJungleHunterHouse":{"time":1553037866},"ChestOIsland":{"time":1553026520},"ChestUpTopper":{"time":1554514807},"IronChestSewerCell":{"chestType":"ironChest","disabled":true},"IronChestMushForPillar":{"chestType":"ironChest","disabled":true},"ChestWarFortSide":{"time":1553023880},"ChestTopOfMount":{"time":1553099936},"IronChestSpiderCave":{"chestType":"ironChest","disabled":true},"ChestCaravan":{"time":1553031695},"ChestPallets":{"time":1553021814},"ChestOnTheHill":{"time":1553045306},"ChestTunnelHater":{"time":1553022984},"ChestOnATallBuilding":{"time":1553045399},"IronChestDitch":{"chestType":"ironChest","disabled":true},"ChestDump":{"time":1554514853},"ChestRedwoodBridge":{"time":1553022897},"ChestCliffside":{"time":1553099959},"ChestSpiderQn2":{"time":1553353308},"ChestCliffPocket":{"time":1553031411},"ChestRedRock":{"time":1553022787},"ChestTree":{"time":1554571333},"ChestWarFortUnderStairs":{"time":1553024085},"ChestWater":{"time":1552598084},"ChestBridge":{"time":1553099095},"ChestWarFortFarCliff":{"time":1553024170},"ChestWarFortHanging":{"time":1553024153},"ChestTent":{"time":1553031542},"ChestWarFortSnowDitch":{"time":1553024097},"ChestGrate":{"time":1553185711},"ChestWithMerch":{"time":1554514905},"ChestPipeDitch":{"time":1553021856}},"hasCustomizedCharacter":true,"statusEffects":[],"hobo_lastDonation":1552609251,"newb":false,"equipment":[{"upgrades":7,"successfulUpgrades":4,"modifierData":[{"baseDamage":3},{"baseDamage":3},{"baseDamage":3},{"baseDamage":3}],"id":78,"position":1,"stacks":1},{"upgrades":7,"successfulUpgrades":7,"modifierData":[{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1}],"id":66,"position":2,"stacks":1},{"stacks":25,"position":8,"id":22}],"abilityBooks":{"mage":{"pointsAssigned":15},"adventurer":{"pointsAssigned":9}},"class":"Mage","hotbar":[{"dataType":2,"position":9,"id":9},{"dataType":2,"position":4,"id":4},{"dataType":2,"position":5,"id":2},{"dataType":1,"position":10,"id":22},{"dataType":2,"position":8,"id":1},{"dataType":1,"position":7,"id":46},{"dataType":1,"position":1,"id":8},{"dataType":1,"position":2,"id":88},{"dataType":2,"position":3,"id":1}],"accessories":{"hair":1,"undershirt":1,"shirtColorId":8,"face":1,"skinColorId":1,"hairColorId":1,"underwear":10},"gold":47311,"userSettings":{"keybinds":{"F":"hotbarButton3","Q":"hotbarButton9","U":"openInventory","V":"hotbarButton8","J":"openSkills","G":"hotbarButton4","E":"pick up","R":"hotbarButton5","1":"hotbarButton1"},"clearingInteraction":true},"exp":25549.5736987116833915933966637,"lastLocation":2496503573,"statistics":{"pointsUnassigned":0,"pointsAssigned":0,"dex":0,"int":72,"vit":0,"modifierData":[],"str":0},"hobo_donations":9999,"moneyFlag2":true,"inventory":[{"stacks":5,"position":24,"id":69},{"stacks":5,"position":23,"id":29},{"stacks":2,"position":22,"id":45},{"stacks":5,"position":21,"id":6},{"stacks":1,"position":20,"id":61},{"stacks":5,"position":19,"id":75},{"stacks":28,"position":18,"id":88},{"stacks":42,"position":17,"id":8},{"stacks":13,"position":16,"id":18},{"stacks":10,"position":16,"id":76},{"stacks":88,"position":15,"id":89},{"stacks":16,"position":14,"id":38},{"stacks":28,"position":13,"id":30},{"stacks":2,"position":12,"id":41},{"stacks":45,"position":11,"id":87},{"stacks":10,"position":11,"id":116},{"stacks":1,"position":10,"id":14},{"stacks":77,"position":10,"id":77},{"stacks":1,"position":9,"id":26},{"stacks":7,"position":8,"id":86},{"stacks":1,"position":8,"id":16},{"stacks":1,"position":8,"id":43},{"upgrades":1,"successfulUpgrades":1,"modifierData":[{"baseDamage":5,"dex":2}],"id":3,"position":7,"stacks":1},{"stacks":13,"position":7,"id":31},{"stacks":1,"position":7,"id":63},{"modifierData":[{"baseDamage":3},{"baseDamage":3},{"baseDamage":3},{"baseDamage":3},{"baseDamage":2},{"baseDamage":2},{"baseDamage":2}],"successfulUpgrades":7,"upgrades":7,"id":49,"position":6,"stacks":1},{"stacks":1,"position":6,"id":63},{"spawnChance":0.900000000000000022204460492503,"id":86,"position":6,"itemName":"hay","stacks":99},{"stacks":9,"position":5,"id":58},{"stacks":99,"position":5,"id":86},{"stacks":4,"position":4,"id":46},{"stacks":2,"position":4,"id":114},{"stacks":19,"position":3,"id":47},{"upgrades":7,"successfulUpgrades":7,"modifierData":[{"defense":3},{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1}],"id":65,"position":3,"stacks":1},{"stacks":99,"position":3,"id":31},{"stacks":12,"position":2,"id":95},{"upgrades":1,"successfulUpgrades":1,"modifierData":[{"baseDamage":1}],"id":12,"position":2,"stacks":1},{"stacks":46,"position":1,"id":96},{"stacks":1,"position":1,"id":37},{"stacks":35,"position":1,"id":6}]}')
--		local inven = game.HttpService:JSONDecode('{"timestamp":0,"professions":{"fishing":{"level":1,"exp":0}},"statusEffects":[],"abilities":[],"flags":{"enchantWipe2":true,"fixcolors3":true,"badges2":true,"revokeCheatWeapons":true,"resetQuests":true,"removeSpiderQueenCrown":true,"fixcolors2":true,"statCheck":true,"fixNightmareChickensEXPandInfinitePetPickup":true,"stealthRevoke":true},"equipment":[{"stacks":1,"position":1,"id":5}],"level":30,"holding":[],"abilityBooks":{"adventurer":{"pointsAssigned":0},"admin":{"pointsAssigned":0}},"statistics":{"pointsUnassigned":0,"pointsAssigned":0,"dex":0,"int":0,"vit":0,"modifierData":[],"str":0},"internalData":{"suspicion":0},"quests":{"active":[],"completed":[]},"isTestingDontSave":true,"userSettings":{"musicVolume":0,"shiprockcombo":["zo","tun","oi","ro"]},"gold":9899999,"accessories":{"hair":3,"face":1,"undershirt":1,"shirtColorId":1,"skinColorId":1,"underwear":1,"hairColorId":1},"class":"Adventurer","hotbar":[],"exp":0,"sessionCount":2,"treasureChests":[],"globalData":{"version":0,"itemStorage":[]},"moneyFlag2":true,"inventory":[{"stacks":99,"position":2,"id":6},{"stacks":1,"position":1,"id":37}]}')
--		local inven = game.HttpService:JSONDecode('{"quests":{"active":[{"objectives":[{"started":true,"completedText":"Return to Mayor Noah.","steps":[{"triggerType":"monster-killed","completion":{"amount":10},"requirement":{"amount":10,"monsterName":"Shroom"}}],"objectiveName":"Mushtown Helper"},{"steps":[{"hideAlert":true,"triggerType":"found-jericho","requirement":{"amount":1},"completion":{"amount":1}}],"completedText":"Talk to Jericho.","hideAlert":true,"objectiveName":"Mushtown Helper Part 2","started":true},{"started":true,"completedText":"Return to Jericho.","steps":[{"triggerType":"item-collected","completion":{"amount":0},"requirement":{"amount":1,"id":137}}],"objectiveName":"Mushtown Helper Part 3"}],"currentObjective":3,"handerName":"","id":2,"QUEST_VERSION":1},{"objectives":[{"started":true,"completedText":"Return to Shelly","steps":[{"triggerType":"item-collected","completion":{"amount":1},"requirement":{"amount":1,"id":168}},{"triggerType":"item-collected","completion":{"amount":0},"requirement":{"amount":1,"id":169}},{"triggerType":"item-collected","completion":{"amount":0},"requirement":{"amount":1,"id":170}},{"triggerType":"item-collected","completion":{"amount":0},"requirement":{"amount":1,"id":171}}],"objectiveName":"Shellys Snel Shells"}],"currentObjective":1,"handerName":"","id":16,"QUEST_VERSION":1},{"currentObjective":1,"handerName":"","id":20,"QUEST_VERSION":1,"objectives":[{"started":false,"completedText":"Return to Randy.","objectiveName":"Eye See Snels","steps":[{"triggerType":"item-collected","completion":{"amount":0},"requirement":{"amount":60,"id":182}}]}],"canStartAfterTime":1565138287},{"currentObjective":1,"handerName":"","id":17,"QUEST_VERSION":1,"objectives":[{"started":false,"completedText":"Return to Sid.","steps":[{"triggerType":"monster-killed","completion":{"amount":0},"requirement":{"amount":30,"monsterName":"Baby Yeti"}}],"objectiveName":"Mountain Patrol"}],"canStartAfterTime":1565155241},{"objectives":[{"started":true,"completedText":"Return to Bobby","steps":[{"triggerType":"found-family-gem","completion":{"amount":0},"requirement":{"amount":1}}],"objectiveName":"The Family Gem"}],"currentObjective":1,"handerName":"","id":6,"QUEST_VERSION":2},{"currentObjective":1,"handerName":"","id":5,"QUEST_VERSION":1,"objectives":[{"started":false,"completedText":"Return to Farmer Sam.","steps":[{"triggerType":"item-collected","completion":{"amount":192},"requirement":{"amount":50,"id":86}}],"objectiveName":"Feed Old Sally"}],"canStartAfterTime":1565421625}],"completed":[{"completionTime":1564974143.62085008621215820313,"completionTimeUTC":1564974144,"id":1},{"completionTime":1564976014.98016905784606933594,"completionTimeUTC":1564976015,"id":10},{"completionTime":1564978704.27499604225158691406,"completionTimeUTC":1564978704,"id":4},{"completionTime":1564980304.36901688575744628906,"completionTimeUTC":1564980305,"id":11},{"completionTime":1565010539.4918575286865234375,"completionTimeUTC":1565024940,"id":13},{"completionTime":1565027312.10265588760375976563,"completionTimeUTC":1565027312,"id":5},{"completionTime":1565049323.83400392532348632813,"completionTimeUTC":1565049324,"id":3},{"completionTime":1565058260.5300159454345703125,"completionTimeUTC":1565058260,"id":8},{"completionTime":1565059634.10211896896362304688,"completionTimeUTC":1565059634,"id":17},{"completionTime":1565059871.14038991928100585938,"completionTimeUTC":1565059871,"id":15},{"completionTime":1565067731.41321301460266113281,"completionTimeUTC":1565067731,"id":14},{"completionTime":1565122451.99602603912353515625,"completionTimeUTC":1565122452,"id":7},{"completionTime":1565123887.14095401763916015625,"completionTimeUTC":1565123887,"id":20}]},"professions":{"fishing":{"level":1,"exp":0}},"flags":{"fixcolors3":true,"revokeCheatWeapons":true,"badges2":true,"resetQuests":true,"removeSpiderQueenCrown":true,"fixcolors2":true,"statCheck":true,"fixNightmareChickensEXPandInfinitePetPickup":true,"stealthRevoke":true,"resetStatPointsForV22":true},"lastPhysicalPosition":[59,48,424],"internalData":{"suspicion":0},"equipment":[{"modifierData":[{"defense":3}],"successfulUpgrades":1,"upgrades":1,"id":44,"position":8,"stacks":1},{"upgrades":2,"successfulUpgrades":2,"position":9,"id":184,"customStory":"Its my lucky day!","modifierData":[{"defense":2,"luck":15}],"customName":"Lucky Boots","stacks":1}],"newb":false,"hobo_lastDonation":1565068251,"hasCustomizedCharacter":true,"statusEffects":[],"moneyFlag2":true,"sessionCount":1,"treasureChests":{"ChestuBRIDGE":{"time":1565064496},"ChestSnowFallenTree":{"time":1565059615},"ChestWallWalk":{"time":1564975979},"ChestCaravan":{"time":1564976917},"ChestSunken":{"time":1565043689},"ChestGnomeHouse1":{"time":1565067664},"ChestOverlook":{"time":1565058373},"ChestYetiCave":{"time":1565060380},"ChestJungleView":{"time":1565122573},"ChestUpAHill":{"time":1565125587},"ChestOnATallBuilding":{"time":1565058190},"ChestPvpTent":{"time":1565069139},"GoldenChestRubeeQuest":{"chestType":"goldChest","disabled":true},"IronChestWater":{"chestType":"ironChest","disabled":true},"ChestUnderBridge":{"time":1565066537},"ChestSandCave":{"time":1565123002},"ChestSnowTree":{"time":1565130836},"ChestBehindHouse":{"time":1564976412},"ChestEvilLair1":{"time":1565058215},"ChestDitch":{"time":1565040277},"ChestJungleCave":{"time":1565121401},"ChestCrane":{"time":1565045166},"ChestTower":{"time":1564976238},"ChestBehindLivingTree":{"time":1565043683},"ChestCorridor2":{"time":1565069400},"ChestWarFortSide":{"time":1565025546},"ChestPallets":{"time":1565068166},"ChestBackalley":{"time":1564980363},"ChestPvpStairs1":{"time":1565069149},"ChestEvilLair2":{"time":1565058216},"ChestBridge":{"time":1564974209},"ChestLowRoof":{"time":1565057952},"ChestMast":{"time":1565124156},"ChestDump":{"time":1565040733},"ChestUpTop":{"time":1564977262},"ChestGrate":{"time":1565068216},"ChestCavee3":{"time":1564976997},"ChestRedwoodBridge":{"time":1565023893},"ChestPvpEdge":{"time":1565069210},"ChestUnderWaterLog":{"time":1565041333},"ChestTent":{"time":1565064113},"ChestGhrotto":{"time":1564978644},"ChestUndaLog":{"time":1565041802},"ChestWarFortMcLov":{"time":1565060849},"ChestUnderLog":{"time":1565041372},"ChestJungleHighUp":{"time":1565057679}},"hitByWipe5":true,"lastSaveTimestamp":1565662036,"abilities":[{"rank":1,"id":3},{"rank":5,"id":2},{"rank":3,"id":1},{"rank":1,"id":30},{"rank":4,"id":8},{"rank":5,"id":5}],"level":19,"timestamp":486,"holding":[],"abilityBooks":{"warrior":{"pointsAssigned":10},"adventurer":{"pointsAssigned":9}},"accessories":{"hair":4,"undershirt":2,"shirtColorId":5,"face":3,"skinColorId":10,"hairColorId":10,"underwear":10},"userSettings":{"Dynamite2placed":true,"Dynamite1placed":true,"openStrongholdDoor":true,"keybinds":{"Rtn":"openGuild","KeypadPlus":"openSettings","G":"interact","Lshft":"pick up","C":"openSkills"},"catapultCutscene":true,"shiprockcombo":["ro","tom","fus","pon"],"clearingInteraction":true,"Dynamite3placed":true},"gold":278068,"class":"Warrior","hotbar":[{"dataType":2,"position":5,"id":2},{"dataType":2,"position":1,"id":5},{"dataType":1,"position":3,"id":88},{"dataType":2,"position":4,"id":8},{"dataType":2,"position":6,"id":1},{"dataType":1,"position":2,"id":89}],"exp":20812.2636851748902699910104275,"lastLocation":2119298605,"globalData":{"version":2972,"lastSaveTimestamp":1565664599,"lastSave":{"-slot1":165,"-slot4":486,"-slot2":2196,"-slot3":125},"referrals":1,"emotes":[],"monsterData":{"Goblin":5,"Baby Shroom":6,"Scarecrow":10,"Elder Shroom":5,"Rubee":2,"Shroom":5,"Baby Yeti":5,"Crabby":3,"Hog":5,"Shaman":4},"lastEthyrReward":18121,"ethyrRewards":0,"recievedReferralGift":true,"ethyr":41,"referredUserIds":[1085164690],"saveSlotData":{"-slot1":{"level":14,"customized":true,"lastLocation":2119298605,"class":"Adventurer","accessories":{"hair":10,"undershirt":3,"shirtColorId":1,"face":1,"skinColorId":4,"hairColorId":1,"underwear":3},"equipment":[{"successfulUpgrades":7,"stacks":1,"modifierData":[{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1}],"blessed":true,"idols":4,"position":2,"id":179,"upgrades":7,"enchantments":7},{"upgrades":7,"successfulUpgrades":7,"customStory":"Picked off of the Tree Of Life","enchantments":7,"stacks":1,"modifierData":[{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":49}],"customName":"Twig","position":1,"id":5,"dye":{"r":85,"g":85,"b":85},"blessed":true},{"stacks":1,"successfulUpgrades":2,"upgrades":2,"id":184,"position":9,"modifierData":[{"defense":2,"greed":0.0299999999999999988897769753748}],"customName":"Greedy Boots"},{"modifierData":[{"defense":1},{"defense":1},{"defense":1}],"successfulUpgrades":3,"upgrades":3,"id":25,"position":8,"stacks":1,"enchantments":3}]},"-slot4":{"level":19,"customized":true,"lastLocation":2119298605,"class":"Warrior","accessories":{"hair":4,"face":3,"underwear":10,"skinColorId":10,"shirtColorId":5,"undershirt":2,"hairColorId":10},"equipment":[{"successfulUpgrades":1,"modifierData":[{"defense":3}],"position":8,"id":44,"upgrades":1,"stacks":1},{"successfulUpgrades":2,"customStory":"Its my lucky day!","id":184,"position":9,"upgrades":2,"modifierData":[{"defense":2,"luck":15}],"customName":"Lucky Boots","stacks":1}]},"-slot2":{"customized":true,"level":30,"lastLocation":2119298605,"class":"Hunter","accessories":{"hair":8,"face":4,"hairColorId":6,"skinColorId":3,"underwear":9,"shirtColorId":8,"undershirt":3},"equipment":[{"successfulUpgrades":1,"upgrades":1,"position":9,"id":162,"dye":{"b":85,"g":85,"r":85},"modifierData":[{"defense":1}],"stacks":1,"enchantments":1},{"successfulUpgrades":7,"dye":{"b":85,"g":85,"r":85},"position":8,"id":100,"upgrades":7,"modifierData":[{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1}],"stacks":1},{"successfulUpgrades":1,"modifierData":[{"defense":1}],"position":2,"id":43,"upgrades":1,"stacks":1},{"successfulUpgrades":1,"modifierData":[{"baseDamage":10,"maxHealth":25}],"position":1,"id":92,"upgrades":1,"stacks":1}]},"-slot3":{"level":10,"customized":true,"lastLocation":2260598172,"class":"Warrior","accessories":{"hair":9,"face":3,"underwear":2,"skinColorId":1,"hairColorId":6,"shirtColorId":7,"undershirt":4},"equipment":[{"successfulUpgrades":0,"dye":{"r":255,"g":131,"b":133},"position":2,"id":43,"upgrades":0,"stacks":1},{"successfulUpgrades":0,"dye":{"r":85,"g":85,"b":85},"position":1,"id":5,"upgrades":0,"stacks":1}]}},"itemStorage":[{"stacks":1,"position":1,"id":167},{"upgrades":7,"successfulUpgrades":7,"modifierData":[{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":49}],"id":5,"position":18,"enchantments":7,"stacks":1,"blessed":true}]},"statistics":{"pointsUnassigned":0,"pointsAssigned":0,"dex":0,"int":0,"vit":0,"modifierData":[],"str":54},"hobo_donations":1,"monsterBook":[],"inventory":[{"count":1,"stacks":4,"position":4,"id":143},{"stacks":1,"position":3,"id":168}]}')
--	    local inven = game.HttpService:JSONDecode('{"quests":{"active":[{"objectives":[{"started":true,"completedText":"Return to Scruff.","steps":[{"triggerType":"item-collected","completion":{"amount":20},"requirement":{"amount":20,"id":9}}],"objectiveName":"Scruffs Quest"}],"currentObjective":2,"handerName":"","id":1,"QUEST_VERSION":2},{"objectives":[{"started":true,"completedText":"Return to Mayor Noah.","steps":[{"triggerType":"monster-killed","completion":{"amount":20},"requirement":{"amount":20,"monsterName":"Shroom"}}],"objectiveName":"Mushtown Helper"},{"steps":[{"hideAlert":true,"triggerType":"found-jericho","requirement":{"amount":1},"completion":{"amount":0}}],"completedText":"Talk to Jericho.","hideAlert":true,"objectiveName":"Mushtown Helper Part 2","started":false},{"started":false,"completedText":"Return to Jericho.","steps":[{"triggerType":"item-collected","completion":{"amount":0},"requirement":{"amount":1,"id":137}}],"objectiveName":"Mushtown Helper Part 3"}],"currentObjective":1,"handerName":"","id":2,"QUEST_VERSION":1},{"objectives":[{"started":true,"completedText":"Visit Albert Figgleglasses home.","objectiveName":"Business Trip","steps":[{"triggerType":"item-collected","completion":{"amount":40},"requirement":{"amount":40,"id":147}}]},{"started":false,"completedText":"Return to Mr. Plant.","objectiveName":"Business Trip Part 2","steps":[{"triggerType":"talk-mrsplant-1","completion":{"amount":0},"requirement":{"amount":1}},{"triggerType":"collect-plant","completion":{"amount":0},"requirement":{"amount":1}},{"triggerType":"talk-mrsplant-2","completion":{"amount":0},"requirement":{"amount":1}}]}],"currentObjective":1,"handerName":"","id":14,"QUEST_VERSION":2},{"objectives":[{"started":true,"completedText":"Return to Greg, the City Guard.","steps":[{"triggerType":"item-collected","completion":{"amount":9},"requirement":{"amount":25,"id":10}}],"objectiveName":"A Respected Guard"}],"currentObjective":1,"handerName":"","id":4,"QUEST_VERSION":1},{"objectives":[{"steps":[{"hideAlert":true,"triggerType":"found-timmy","requirement":{"amount":1},"completion":{"amount":1}}],"completedText":"Talk to Streisand.","hideAlert":true,"objectiveName":"Innkeepers Son","started":true}],"currentObjective":1,"handerName":"","id":11,"QUEST_VERSION":1},{"currentObjective":1,"handerName":"","id":5,"QUEST_VERSION":1,"objectives":[{"started":false,"completedText":"Return to Farmer Sam.","steps":[{"triggerType":"item-collected","completion":{"amount":234},"requirement":{"amount":50,"id":86}}],"objectiveName":"Feed Old Sally"}],"canStartAfterTime":1565684482},{"objectives":[{"started":true,"completedText":"Return to Sid.","steps":[{"triggerType":"monster-killed","completion":{"amount":30},"requirement":{"amount":30,"monsterName":"Baby Yeti"}}],"objectiveName":"Mountain Patrol"}],"currentObjective":1,"handerName":"","id":17,"QUEST_VERSION":1},{"objectives":[{"started":true,"completedText":"Go to the hunter outpost.","objectiveName":"Rubee Problem","steps":[{"triggerType":"item-collected","completion":{"amount":1},"requirement":{"amount":1,"id":95}}]},{"started":false,"completedText":"Return to Lieutenant Venessa.","objectiveName":"Rubee Problem Part 2","steps":[{"triggerType":"collect-dynamite","completion":{"amount":0},"requirement":{"amount":1}}]},{"started":false,"completedText":"Return to Lieutenant Venessa","objectiveName":"Rubee Problem Part 3","steps":[{"triggerType":"set-rubee-dynamite","completion":{"amount":0},"requirement":{"amount":3}}]}],"currentObjective":2,"handerName":"","id":7,"QUEST_VERSION":2}],"completed":[{"completionTime":1560807609.14380192756652832031,"completionTimeUTC":1560822010,"id":19},{"completionTime":1565655681.94356608390808105469,"completionTimeUTC":1565655682,"id":5},{"completionTime":1565656700.84888911247253417969,"completionTimeUTC":1565656701,"id":13},{"completionTime":1565663534.78346490859985351563,"completionTimeUTC":1565663534,"id":8}]},"professions":{"fishing":{"level":1,"exp":0}},"sessionCount":1,"treasureChests":{"ChestTent":{"time":1565557288},"ChestCorridor2":{"time":1565559243},"ChestuBRIDGE":{"time":1565558323},"ChestSideDitch":{"time":1560821728},"ChestJungleView":{"time":1565664200},"ChestCastleTop":{"time":1565658526},"ChestUnderLog":{"time":1565647008},"ChestCaravan":{"time":1565556969},"ChestUpTop":{"time":1565658501},"ChestBridge":{"time":1565647178},"ChestEvilLair2":{"time":1565663309},"ChestEvilLair1":{"time":1565663303},"ChestJungleCave":{"time":1565664176},"ChestBehindHouse":{"time":1565560831},"ChestBar":{"time":1565661410},"ChestCorridor4":{"time":1565559232},"ChestSnowFallenTree":{"time":1565657767},"ChestOnABoat":{"time":1565663192},"ChestOnATallBuilding":{"time":1565663275},"IronChestWater":{"chestType":"ironChest","disabled":true},"ChestUnderBridge":{"time":1565647400}},"lastPhysicalPosition":[290,48,-309],"internalData":{"suspicion":0},"hasCustomizedCharacter":true,"statusEffects":[],"newb":false,"equipment":[{"successfulUpgrades":7,"stacks":1,"modifierData":[{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1}],"blessed":true,"idols":4,"position":2,"id":179,"upgrades":7,"enchantments":7},{"upgrades":7,"successfulUpgrades":7,"customStory":"Picked off of the Tree Of Life","enchantments":7,"stacks":1,"modifierData":[{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":49}],"customName":"Twig","position":1,"id":5,"dye":{"r":85,"g":85,"b":85},"blessed":true},{"stacks":1,"successfulUpgrades":2,"upgrades":2,"id":184,"position":9,"modifierData":[{"defense":2,"greed":0.0299999999999999988897769753748}],"customName":"Greedy Boots"},{"modifierData":[{"defense":1},{"defense":1},{"defense":1}],"successfulUpgrades":3,"upgrades":3,"id":25,"position":8,"stacks":1,"enchantments":3}],"moneyFlag2":true,"statistics":{"pointsUnassigned":0,"pointsAssigned":0,"dex":10,"int":0,"vit":0,"modifierData":[],"str":29},"hitByWipe5":true,"holding":[],"flags":{"fixcolors3":true,"revokeCheatWeapons":true,"badges2":true,"referralCheck":true,"resetQuests":true,"removeSpiderQueenCrown":true,"fixcolors2":true,"statCheck":true,"fixNightmareChickensEXPandInfinitePetPickup":true,"stealthRevoke":true,"resetStatPointsForV22":true},"level":14,"timestamp":165,"lastSaveTimestamp":1565664599,"abilities":[{"rank":1,"id":3},{"rank":5,"id":2},{"rank":3,"id":1}],"abilityBooks":{"adventurer":{"pointsAssigned":9}},"accessories":{"hair":10,"undershirt":3,"shirtColorId":1,"face":1,"skinColorId":4,"hairColorId":1,"underwear":3},"userSettings":{"keybinds":{"Q":"hotbarButton1","G":"interact","L":"openSkills","BackSlash":"openSettings","Lshft":"pick up","C":"openGuild","1":"openQuestLog"},"openStrongholdDoor":true,"clearingInteraction":true},"gold":72771,"hotbar":[{"dataType":2,"position":1,"id":2},{"dataType":1,"position":2,"id":88},{"dataType":1,"position":3,"id":89},{"dataType":2,"position":4,"id":1}],"class":"Adventurer","exp":2615.60075577280667857849039137,"lastLocation":2119298605,"globalData":{"version":2972,"lastSaveTimestamp":1565664599,"lastSave":{"-slot1":165,"-slot4":486,"-slot2":2196,"-slot3":125},"referrals":1,"emotes":[],"monsterData":{"Goblin":5,"Baby Shroom":6,"Scarecrow":10,"Elder Shroom":5,"Rubee":2,"Shroom":5,"Baby Yeti":5,"Crabby":3,"Hog":5,"Shaman":4},"lastEthyrReward":18121,"ethyrRewards":0,"recievedReferralGift":true,"ethyr":41,"referredUserIds":[1085164690],"saveSlotData":{"-slot1":{"level":14,"customized":true,"lastLocation":2119298605,"class":"Adventurer","accessories":{"hair":10,"undershirt":3,"shirtColorId":1,"face":1,"skinColorId":4,"hairColorId":1,"underwear":3},"equipment":[{"successfulUpgrades":7,"stacks":1,"modifierData":[{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1}],"blessed":true,"idols":4,"position":2,"id":179,"upgrades":7,"enchantments":7},{"upgrades":7,"successfulUpgrades":7,"customStory":"Picked off of the Tree Of Life","enchantments":7,"stacks":1,"modifierData":[{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":49}],"customName":"Twig","position":1,"id":5,"dye":{"r":85,"g":85,"b":85},"blessed":true},{"stacks":1,"successfulUpgrades":2,"upgrades":2,"id":184,"position":9,"modifierData":[{"defense":2,"greed":0.0299999999999999988897769753748}],"customName":"Greedy Boots"},{"modifierData":[{"defense":1},{"defense":1},{"defense":1}],"successfulUpgrades":3,"upgrades":3,"id":25,"position":8,"stacks":1,"enchantments":3}]},"-slot4":{"level":19,"customized":true,"lastLocation":2119298605,"class":"Warrior","accessories":{"hair":4,"face":3,"underwear":10,"skinColorId":10,"shirtColorId":5,"undershirt":2,"hairColorId":10},"equipment":[{"successfulUpgrades":1,"modifierData":[{"defense":3}],"position":8,"id":44,"upgrades":1,"stacks":1},{"successfulUpgrades":2,"customStory":"Its my lucky day!","id":184,"position":9,"upgrades":2,"modifierData":[{"defense":2,"luck":15}],"customName":"Lucky Boots","stacks":1}]},"-slot2":{"customized":true,"level":30,"lastLocation":2119298605,"class":"Hunter","accessories":{"hair":8,"face":4,"hairColorId":6,"skinColorId":3,"underwear":9,"shirtColorId":8,"undershirt":3},"equipment":[{"successfulUpgrades":1,"upgrades":1,"position":9,"id":162,"dye":{"b":85,"g":85,"r":85},"modifierData":[{"defense":1}],"stacks":1,"enchantments":1},{"successfulUpgrades":7,"dye":{"b":85,"g":85,"r":85},"position":8,"id":100,"upgrades":7,"modifierData":[{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1},{"defense":1}],"stacks":1},{"successfulUpgrades":1,"modifierData":[{"defense":1}],"position":2,"id":43,"upgrades":1,"stacks":1},{"successfulUpgrades":1,"modifierData":[{"baseDamage":10,"maxHealth":25}],"position":1,"id":92,"upgrades":1,"stacks":1}]},"-slot3":{"level":10,"customized":true,"lastLocation":2260598172,"class":"Warrior","accessories":{"hair":9,"face":3,"underwear":2,"skinColorId":1,"hairColorId":6,"shirtColorId":7,"undershirt":4},"equipment":[{"successfulUpgrades":0,"dye":{"r":255,"g":131,"b":133},"position":2,"id":43,"upgrades":0,"stacks":1},{"successfulUpgrades":0,"dye":{"r":85,"g":85,"b":85},"position":1,"id":5,"upgrades":0,"stacks":1}]}},"itemStorage":[{"stacks":1,"position":1,"id":167},{"upgrades":7,"successfulUpgrades":7,"modifierData":[{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":1},{"baseDamage":49}],"id":5,"position":18,"enchantments":7,"stacks":1,"blessed":true}]},"monsterBook":[],"inventory":[{"stacks":1,"position":20,"id":56},{"stacks":32,"position":18,"id":88},{"count":1,"stacks":2,"position":18,"id":115},{"stacks":31,"position":16,"id":89},{"stacks":1,"position":15,"id":57},{"stacks":32,"position":13,"id":88},{"stacks":32,"position":11,"id":89},{"stacks":1,"position":10,"id":122},{"stacks":1,"position":10,"id":58},{"stacks":32,"position":8,"id":88},{"idols":4,"stacks":1,"position":7,"id":179},{"stacks":32,"position":6,"id":89},{"stacks":44,"position":5,"id":86},{"stacks":22,"position":4,"id":144},{"questItem":true,"stacks":53,"position":4,"id":147},{"stacks":99,"position":3,"id":86},{"stacks":32,"position":3,"id":88},{"stacks":1,"position":3,"id":142},{"customStory":"It chooses you.","stacks":1,"position":2,"id":124},{"stacks":99,"position":2,"id":86},{"stacks":32,"position":1,"id":89}]}')
		local inven = {gold = 10; level = 1; inventory = {}; equipment = {}; moneyFlag2 = true; isTestingDontSave = true; abilityBooks = {}; abilities = {};}
		inven.globalData = {
--			guildId = "73370A17-4486-4E7D-AD49-4597D93C52B0",
		}
--		inven.treasureChests = {}
		inven.flags = inven.flags or {}
		inven.flags.enchantWipe3 = true
		inven.flags.completedGauntlet = true
		inven.inventory = {
		}
		inven.equipment = {
			{id = 5, position = 1}, -- main hand
--			{id = 281, position = 11}, -- off-hand
--			{id = 205, position = 8}, -- chest
			--{id = 179, position = 2}, -- hat
--			{id = 163, position = 9}, -- boots
		}

--		delay(3, function()
--			local data = network:invoke("getPlayerData", player)
--
--			data.nonSerializeData.setPlayerData("abilities", {
--				{id = 46, rank = 10},
--				{id = 47, rank = 10},
--				{id = 54, rank = 10},
--				{id = 38, rank = 10},
--				{id = 40, rank = 10},
--			})
--		end)

--		for _, id in pairs{
--			245,
--			261,
--			254,
--			255,
--		} do
--			table.insert(inven.inventory, {id = id})
--		end

		return true, inven
	end

	local Data
	local PlayerId 			= player.userId
	local Slot 				= saveFileNumber

	local providedVersion

--	local currentTime = os.time()

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
			local OrderedStore 	= game:GetService("DataStoreService"):GetOrderedDataStore(tostring(PlayerId), "PlayerSaveTimes" .. datastoreVersion .. Suffix .. suffix) -- dont worry i hate this too
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
			local DataStore = game:GetService("DataStoreService"):GetDataStore(tostring(PlayerId), "PlayerData" .. datastoreVersion .. Suffix .. suffix) -- Suffix .. suffix xD
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
	local GlobalDataStore = game:GetService("DataStoreService"):GetDataStore(tostring(PlayerId), "GlobalPlayerData" .. datastoreVersion .. suffix)

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
	local DataStore = game:GetService("DataStoreService"):GetDataStore(tostring(PlayerId), "PlayerData" .. datastoreVersion .. Suffix .. suffix) -- we need another programmer

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
	local GlobalOrderedDataStore = game:GetService("DataStoreService"):GetOrderedDataStore(tostring(PlayerId), "GlobalPlayerSaveTimes" .. datastoreVersion .. suffix)

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

local rand = Random.new()

local function int__modifyPlayerSaveFileIncludeDefaults(player, saveFileNumber, playerSaveFileData)
	playerSaveFileData.timestamp = playerSaveFileData.timestamp or 0
	playerSaveFileData.globalData.version = playerSaveFileData.globalData.version or 0
	playerSaveFileData.globalData.itemStorage = playerSaveFileData.globalData.itemStorage or {}

	playerSaveFileData.globalData.emotes = playerSaveFileData.globalData.emotes or {}

	playerSaveFileData.monsterBook 	= playerSaveFileData.monsterBook or {}
	playerSaveFileData.bountyBook	= playerSaveFileData.bountyBook or {}

	-- maintain data --
	playerSaveFileData.inventory 	= playerSaveFileData.inventory  or {{id = 5; position = 1}}
	playerSaveFileData.equipment 	= playerSaveFileData.equipment or {}
	playerSaveFileData.hotbar 		= playerSaveFileData.hotbar or {}

	playerSaveFileData.abilities 	= playerSaveFileData.abilities or {}
	playerSaveFileData.abilityBooks = playerSaveFileData.abilityBooks or {}
		playerSaveFileData.abilityBooks.adventurer = playerSaveFileData.abilityBooks.adventurer or {}
			playerSaveFileData.abilityBooks.adventurer.pointsAssigned = playerSaveFileData.abilityBooks.adventurer.pointsAssigned or 0

--	if playerSaveFileData.accessories and not playerSaveFileData.accessories.face then
--		playerSaveFileData.accessories = require(replicatedStorage.defaultCharacterAppearance).accessories
--	end

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
--		playerSaveFileData.nonSerializeData.resultByError 		= resultByError
		playerSaveFileData.nonSerializeData.saveFileNumber 		= saveFileNumber
--		playerSaveFileData.nonSerializeData.playerPromptDoSave 	= false
		playerSaveFileData.nonSerializeData.playerPointer 		= player
		playerSaveFileData.nonSerializeData.isGlobalPVPEnabled 	= false
		playerSaveFileData.nonSerializeData.whitelistPVPEnabled = {}
		playerSaveFileData.nonSerializeData.temporaryEquipment 	= {}
		playerSaveFileData.nonSerializeData.perksActivated 		= {}
end

function module:getLatestSaveVersion(player)
	local playerId = player.UserId

	local globalOrderedStore = game:GetService("DataStoreService"):GetOrderedDataStore(tostring(playerId), "GlobalPlayerSaveTimes" .. datastoreVersion)
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

	local globalOrderedStore = game:GetService("DataStoreService"):GetOrderedDataStore(tostring(playerId), "GlobalPlayerSaveTimes" .. datastoreVersion)
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

	local globalDataStore = game:GetService("DataStoreService"):GetDataStore(tostring(playerId), "GlobalPlayerData" .. datastoreVersion)

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

	if game.PlaceId == 2061558182 or game.ReplicatedStorage:FindFirstChild("doNotSaveData") then
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

return module