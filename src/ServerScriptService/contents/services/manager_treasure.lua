-- NEW and IMPROVED Treasure chest manager



local INTERVAL = 30 * 60 * 24

local function getTime()
	-- 7AM/PM PT, 10AM/PM ET
	return os.time() - INTERVAL / 12
end

--	local current = math.floor(getTime() / INTERVAL)


local module = {}


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local itemLookup = require(ReplicatedStorage.itemData)
local modules = require(ReplicatedStorage.modules)

local network = modules.load("network")
local utilities = modules.load("utilities")
local configuration = modules.load("configuration")
local levels = modules.load("levels")

local rand = Random.new()


local lootTable = {
	
	{id = "health potion"; stacks = 10; chance = 30; minLevel = 0; maxLevel = 5;};
	{id = "mana potion"; stacks = 10; chance = 30; minLevel = 0; maxLevel = 5;};
	{id = "health potion"; stacks = 20; chance = 5; minLevel = 0; maxLevel = 5;};
	{id = "mana potion"; stacks = 20; chance = 5; minLevel = 0; maxLevel = 5;};	
	
	{id = "100% armor defense scroll"; stacks = 1; chance = 15; minLevel = 0; maxLevel = 100;};
	{id = "100% weapon attack scroll"; stacks = 1; chance = 15; minLevel = 0; maxLevel = 100;};

	{id = "megaphone"; stacks = 1; chance = 1; minLevel = 10; maxLevel = 100;};	
}

-- map-specific potions!!!!!!

local mapSpecificLoot = {
	
	-- Whispering Dunes
	["3303140173"] = {
		{id = "crystal beetle"; stacks = 3; chance = 10;};
		{id = "broken crystal beetle"; stacks = 6; chance = 30;};
		{id = "broken crystal beetle"; stacks = 7; chance = 30;};
		{id = "broken crystal beetle"; stacks = 8; chance = 30;};
		{id = "cactus fruit"; stacks = 15; chance = 25;};
		{id = "item dye yellow"; stacks = 1; chance = 1;};
	};	
	
	-- Port Fidelio
	["2546689567"] = {
		{id = "rune hunter"; stacks = 3; chance = 25;};
		{id = "health potion chalice"; stacks = 10; chance = 80;};
		{id = "dexterity potion"; stacks = 1; chance = 10;};
		{id = "arrow"; stacks = 50; chance = 20;};
		{id = "banana"; stacks = 15; chance = 25;};
		{id = "mighty sub"; stacks = 16; chance = 3;};
		{id = "wayfarer ticket"; stacks = 1; chance = 2;};
		{id = "item dye green"; stacks = 1; chance = 1;};
		{id = "wooden bow"; attribute = "pristine"; stacks = 1; chance = 5;};
		{id = "hunter bandit vest"; attribute = "pristine"; stacks = 1; chance = 5;};
		{id = "hunter bandit mask"; attribute = "pristine"; stacks = 1; chance = 5;};
	};
	
	-- spider abyss
	["3207211233"] = {
		{id = "spider fang"; stacks = 30; chance = 80;};
		{id = "royal spider egg"; stacks = 1; chance = 20;};
		{id = "spider potion"; stacks = 1; chance = 10;};
		{id = "spider fang dagger"; stacks = 1; chance = 3;};
		{id = "spider bow"; stacks = 1; chance = 3;};
		{id = "spider staff"; stacks = 1; chance = 3;};
		{id = "spider sword"; stacks = 1; chance = 3;};
		{id = "item dye purple"; stacks = 1; chance = 1;};
	};
	
	-- Scallop Shores
	["2471035818"] = {
		{id = "rune hunter"; stacks = 3; chance = 25;};
		{id = "dexterity potion"; stacks = 1; chance = 10;};
		{id = "tomahawk"; attribute = "pristine"; stacks = 1; chance = 5;};
		{id = "arrow"; stacks = 50; chance = 20;};
		{id = "item dye green"; stacks = 1; chance = 1;};
	};	
	-- Shiprock Bottom
	["3232913902"] = {
		{id = "snel snel shell"; stacks = 1; chance = 1;};
		{id = "snelleth shell"; stacks = 1; chance = 1;};
		{id = "snelly shell"; stacks = 1; chance = 1;};
		{id = "snelvin shell"; stacks = 1; chance = 1;};
	};	
	-- Seaside Path
	["2093766642"] = {
		{id = "rune hunter"; stacks = 3; chance = 25;};
		{id = "fish"; stacks = 10; chance = 80;};
		{id = "tall blue fish"; stacks = 10; chance = 20;};
		{id = "yellow puffer fish"; stacks = 3; chance = 10;};
	};		
	
	-- The Colosseum
	["2496503573"] = {
		{id = "rune colosseum"; stacks = 3; chance = 25;};
		{id = "health potion horn"; stacks = 10; chance = 80;};
	};
		
	-- Warrior Stronghold
	["2470481225"] = {
		{id = "rune warrior"; stacks = 3; chance = 25;};
		{id = "health potion flagon"; stacks = 10; chance = 80;};
		{id = "strength potion"; stacks = 1; chance = 10;};
		{id = "item dye red"; stacks = 1; chance = 1;};
		{id = "bronze helmet"; attribute = "pristine"; stacks = 1; chance = 5;};
		{id = "bronze armor"; attribute = "pristine"; stacks = 1; chance = 5;};
		{id = "bronze mace"; attribute = "pristine"; stacks = 1; chance = 5;};			
	};		
	-- Redwood Pass
	["2376890690"] = {
		{id = "rune warrior"; stacks = 3; chance = 25;};
		{id = "strength potion"; stacks = 1; chance = 10;};
	};			
	-- Enchanted forest
	["2260598172"] = {
		{id = "rune mage"; stacks = 3; chance = 25;};
		{id = "health potion silver"; stacks = 10; chance = 80;};
	};
	-- Tree of life
	["3112029149"] = {
		{id = "rune mage"; stacks = 3; chance = 25;};
		{id = "health potion silver"; stacks = 10; chance = 80;};
		{id = "item dye blue"; stacks = 1; chance = 1;};
		{id = "mage hat 2"; attribute = "pristine"; stacks = 1; chance = 5;};
		{id = "mage robes 2"; attribute = "pristine"; stacks = 1; chance = 5;};
		{id = "willow staff"; attribute = "pristine"; stacks = 1; chance = 5;};		
	};
	-- The Clearing
	["2060556572"] = {
		{id = "oak axe"; attribute = "pristine"; stacks = 1; chance = 10;};
	};	
	-- Nilgarf
	["2119298605"] = {
		{id = "rune nilgarf"; stacks = 3; chance = 25;};
		{id = "pear"; stacks = 15; chance = 25;};
		{id = "item renamer"; stacks = 1; chance = 1;};
		{id = "item lore"; stacks = 1; chance = 1;};
		{id = "item dye grey"; stacks = 1; chance = 1;};
	};
	-- Mushtropolis
	["3273679677"] = {
		{id = "mushroom soup"; stacks = 1; chance = 5;};
		{id = "rune mushtown"; stacks = 3; chance = 25;};
		{id = "golden mushroom"; stacks = 5; chance = 35;};
	};		
	-- Mushroom Grotto
	["2060360203"] = {
		{id = "mushroom beard"; stacks = 30; chance = 20;};
		{id = "mushroom mini"; stacks = 30; chance = 40;};
		{id = "mushroom soup"; stacks = 1; chance = 1;};
		{id = "rune mushtown"; stacks = 3; chance = 25;};
	};							
	-- Mushtown
	["2064647391"] = {
		{id = "rune mushtown"; stacks = 3; chance = 25;};
		{id = "mushroom mini"; stacks = 30; chance = 25;};
		{id = "apple"; stacks = 15; chance = 25;};
		{id = "mushroom soup"; stacks = 1; chance = 1;};
	};		
	-- Mushroom Forest
	["2035250551"] = {
		{id = "rune mushtown"; stacks = 3; chance = 25;};
		{id = "mushroom mini"; stacks = 30; chance = 40;};
		{id = "mushroom soup"; stacks = 1; chance = 1;};
	};			
	-- Internal build (testing)
--	["2061558182"] = {
--		{id = "bronze helmet"; attribute = "pristine"; stacks = 1; chance = 500;};
--	};			
}

-- since you DIDNT WANT TO DO IT YOURSELF!!!!
local conversionBlock do
	for i, lootDrop in pairs(lootTable) do
		if type(lootDrop.id) == "string" then
			lootDrop.id = itemLookup[lootDrop.id].id
		end
	end
	
	for placeId, placeLootTable in pairs(mapSpecificLoot) do
		for i, lootDrop in pairs(placeLootTable) do
			if type(lootDrop.id) == "string" then
				local lookupLootDrop = itemLookup[lootDrop.id]
				if (lookupLootDrop) then
					lootDrop.id = itemLookup[lootDrop.id].id
				else
					if RunService:IsStudio() and game.PlaceId == placeId then
						warn("Treasure manager: Item \"" .. lootDrop.id .. " does not exist in itemLookup!")
					end
				end
			end
		end
	end
end

for placeId, contents in pairs(mapSpecificLoot) do
	if tonumber(placeId) == utilities.originPlaceId(game.PlaceId) then
		for i, lootEntry in pairs(contents) do
			table.insert(lootTable, lootEntry)
		end
	end
end

local chestStorage = Instance.new("Folder")
chestStorage.Name = "chestStorage"
chestStorage.Parent = game.ServerStorage

local dailyChests = {}
local n = 1
for i, chest in pairs(game.CollectionService:GetTagged("treasureChest")) do
	local specialContents = chest:FindFirstChild("inventory") or chest:FindFirstChild("ironChest") or chest:FindFirstChild("goldChest")
	if not specialContents and chest.Name == "Chest" then
		chest.Name = "Chest" .. n
		n = n + 1
		table.insert(dailyChests, chest)
		chest.Parent = chestStorage
	end
end



local dailyChestCount = 7

local currentChests = {}

-- Shuffle random chests
local function newDay()
	local today = math.floor(getTime() / INTERVAL)
	local rand = Random.new(today)
	local chance = dailyChestCount / #dailyChests
	-- remove existing chests
	for i, chest in pairs(currentChests) do
		chest:Destroy()
	end
	currentChests = {}
	-- add in new chests (clone)
	for i, chest in pairs(dailyChests) do
		if rand:NextNumber() <= chance then
			local newChest = chest:Clone()
			newChest.Parent = workspace
			table.insert(currentChests, newChest)
		end
	end
end

-- Day loop
local currentDay = 0
spawn(function()
	while wait(1) do
		local today = math.floor(getTime() / INTERVAL)
		if today > currentDay then
			newDay()
			currentDay = today
		end
	end
end)

local function getTreasureForChest(player, chest)
	local placeId = utilities.originPlaceId(game.PlaceId)
	assert(chest, "Chest cannot be nil!")
	
	local level = chest.chestLevel.Value 
	local goldReward = 0
	
	local playerData = network:invoke("getPlayerData", player)
	
	local mapLoot = mapSpecificLoot[tostring(placeId)]
	local rewards = {}
	

	local function selectReward()

		-- ethyr reward
		local ethyrReward
		
		local globalData = playerData.globalData
		
		if globalData then
		
			local today = math.floor(getTime() / INTERVAL)
			
			globalData.ethyrRewards = globalData.ethyrRewards or 0
			if globalData.lastEthyrReward == nil or globalData.lastEthyrReward < today then
				globalData.ethyrRewards = 0
				globalData.lastEthyrReward = today
			end
			
			if globalData.ethyrRewards < 5 then
				local chance = 0.025 
				if level >= 40 then
					chance = 0.15
				elseif level >= 25 then
					chance = 0.1
				elseif level >= 18 then
					chance = 0.075
				elseif level >= 7 then
					chance = 0.04
				end
				if chance and rand:NextNumber() <= chance then
					globalData.ethyrRewards = globalData.ethyrRewards + 1
					ethyrReward = true
				end
			end
			
			playerData.nonSerializeData.setPlayerData("globalData", globalData)
		
		end	
		
		if ethyrReward then
			local reward = {id = "ethyr pile"; stacks = 1;}
			table.insert(rewards, {id = reward.id; stacks = reward.stacks})	
		elseif rand:NextInteger(1,5) == 4 then
			-- 1/5 chance to recieve money
			goldReward = (goldReward or 0) + levels.getQuestGoldFromLevel(level or 1) * 0.5
		else
			-- standard loot table
			local lottery = {}
			
			for i, lootInfo in pairs(lootTable) do
				if (level >= (lootInfo.minLevel or 0)) and (level <= (lootInfo.maxLevel or 999999)) then
					for i=1, (lootInfo.chance or 0) do
						table.insert(lottery, lootInfo)
					end
				end
			end
			
			if mapLoot then
				for i, lootInfo in pairs(mapLoot) do
					if (level >= (lootInfo.minLevel or 0)) and (level <= (lootInfo.maxLevel or 999999)) then
						for i=1, (lootInfo.chance or 0) do
							table.insert(lottery, lootInfo)
						end
					end					
				end
			end
			
			if #lottery > 0 then
				local reward = lottery[rand:NextInteger(1, #lottery)]
				local rewardItemData = {}
				for key, value in pairs(reward) do
					if key ~= "minLevel" and key ~= "maxLevel" and key ~= "chance" then
						rewardItemData[key] = value
					end
				end
				table.insert(rewards, rewardItemData)				
			end										
		end		
	end		
	
	selectReward()
	
	-- double trouble(rare)
	if rand:NextNumber() >= 0.85 then
		selectReward()
	end		
	
	-- treasure hunt quest
	for i, quest in pairs(playerData.quests.active) do
		if quest.id == 10 then
			local hadRelic = false
			for ii, item in pairs(playerData.inventory) do
				if item.id == 138 then
					hadRelic = true
				end
			end
			if not hadRelic then
				local chance = rand:NextInteger(1,3)
				if chance == 1 then
					table.insert(rewards, {id = 138; stacks = 1})
				end
			end
		end
	end
	
	return {
		rewards = rewards,
		gold = goldReward,
	}
end

local function playerRequest_openTreasureChest(player, chest)
	if player.Character and player.Character.PrimaryPart then
		if chest and chest.PrimaryPart then
			local dist = (chest.PrimaryPart.Position - player.Character.PrimaryPart.Position).magnitude
			if dist >= 40 then
				local factor = math.floor(dist/40)
				network:invoke("incrementPlayerArcadeScore", player, configuration.getConfigurationValue("server_TPExploitScoreToFail") * (factor / 5))
				-- (previously just a flat increment of 1/5... i decided to make it fun)
				return false
			end
		end
	end
	if game.CollectionService:HasTag(chest, "treasureChest") then
		local playerData = network:invoke("getPlayerData", player)
		if playerData then
			local treasureData = playerData.treasure
			local chestData = treasureData["place-"..game.PlaceId].chests[chest.Name] 
			if chestData == nil or chestData.blocked then
				return false, "Invalid chest"
			end
			local chestInfo = getTreasureForChest(player, chest) or {}
			-- check for inventory
			local specialContents = chest:FindFirstChild("inventory") or chest:FindFirstChild("ironChest") or chest:FindFirstChild("goldChest")
			
			local today = math.floor(getTime() / INTERVAL)
			
			if specialContents then
				if chestData.open then
					return false, "Already opened"
				end
				chestInfo = require(specialContents)
				-- Allow custom prereqs for chests
				if chestInfo.prereq then
					local success, status = chestInfo.prereq(player, {network = network; utilities = utilities})
					if not success then
						return false, status
					end
				end
				if specialContents.Name == "goldChest" then
					spawn(function()
						game.BadgeService:AwardBadge(player.userId, 2124445630)
					end)
				end
			else
				if chestData.open and chestData.open >= today then
					return false, "Already opened"
				end
				--
			end
			
			local rewards = chestInfo.rewards or {}
			local goldReward = chestInfo.gold or 0
			
			
			if chest:FindFirstChild("minLevel") then
				if player.level.Value < chest.minLevel.Value then
					return false, "This chest is too sturdy to for you to break right now!"
				end
			else
				local chestLevel = chest:FindFirstChild("chestLevel")
				if chestLevel then
					if player.level.Value < chestLevel.Value - 10 then
						return false, "This chest is too sturdy to for you to break right now!"
					end
				else
					return false, "This chest is broken! Let a dev know!"
				end
			end
			
			local rewardInfo = utilities.copyTable(rewards)					
		
			if goldReward > 0 then
				table.insert(rewardInfo, {id = 1; value = goldReward})
			end
			
			chestData.open = today
			
			
			playerData.nonSerializeData.setPlayerData("treasure", treasureData)
			
--			local success = network:invoke("tradeItemsBetweenPlayerAndNPC", player, {}, 0, rewards, goldReward, "treasure:"..chest.Name, {overrideItemsRecieved = true})
			
			spawn(function()
				wait(0.784)
				for _, itemInfo in pairs(rewardInfo) do
					local dropInformation = {
						lootDropData = itemInfo,
						dropPosition = (chest.PrimaryPart.CFrame * CFrame.new(0,chest.PrimaryPart.Size.Y*2, 0)).Position,
						itemOwners = {player},
					}
					
					local item = network:invoke("spawnItemOnGround",dropInformation.lootDropData, dropInformation.dropPosition, dropInformation.itemOwners)	
					if item == nil then break end
					
					local attachmentTarget
					local rand = Random.new()
					
					local cf = chest.PrimaryPart.CFrame * CFrame.Angles(0, -math.pi/2, 0)
					local velo = Vector3.new((rand:NextNumber() - 0.5) * 10, (2 + rand:NextNumber()) * 25, (rand:NextNumber() - 0.5) * 10) + cf.lookVector * 10
					
					if item:IsA("BasePart") then
						item.Velocity = velo
					elseif item:IsA("Model") and (item.PrimaryPart or item:FindFirstChild("HumanoidRootPart")) then
						local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart")
						if primaryPart then
							primaryPart.Velocity = velo
						end
					end				
					
					wait(2/5)
				end
			end)	
			return true		
			
		end
		return false, "Not a chest"
	end
end



function main()
	network:create("playerRequest_openTreasureChest","RemoteFunction","OnServerInvoke", playerRequest_openTreasureChest)
end

main()

return module
