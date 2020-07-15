if true then
	return false
end


local nicknames = {
	["rbxgameasset://Images/whitecirclecropped2"] = "rbxassetid://2920343923";
	["rbxgameasset://Images/whitecirclecropped2"] = "rbxassetid://2920343923";
	[""] = "";
	[""] = "";

}








local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	
	local target = game.Players.berezaa
	
	for i,player in pairs(game.Players:GetPlayers()) do
		if player.Character and player.Character.PrimaryPart then
			local wasApplied, reason = network:invoke("applyStatusEffectToEntityManifest", player.Character.PrimaryPart, "empower", {
				duration = 600;
				
				modifierData = {
					wisdom = 1;
					stamina = 3;
					maxHealth = 500;
					maxMana = 500;
				};
			}, player.Character.PrimaryPart, "item", 82)	
		end
			
	end	
		
--		if player ~= target then
--		network:invoke("teleportPlayerCFrame_server", player, target.Character.PrimaryPart.CFrame + Vector3.new(math.random(-5,5),math.random(-5,5),math.random(-5,5)))		
--		end
--	end

local admin = game.Players.berezaa
for i,player in pairs(game.Players:GetPlayers()) do
	if player and player.Character and player.Character.PrimaryPart and (player.Character.PrimaryPart.Position - admin.Character.PrimaryPart.Position).magnitude <= 30 then
		spawn(function()
			wait()
			network:invoke("teleportPlayer_rune", player, 4544425669)
		end)
	end
end
			
network:invoke("teleportPlayer_rune", player, 4544425669)




local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	for i, player in pairs(game.Players:GetPlayers()) do
		local playerData = network:invoke("getPlayerData", player)
		if playerData then
			print(playerData["goldwipe3/19"])
		end
	end


local monsterInfo = {}



for i,monster in pairs(game.ReplicatedStorage.monsterLookup:GetChildren()) do
	local monsterData = require(monster)
	monsterInfo[monster.Name] = {
		level = tostring(monsterData.level); 
		baseEXP = tostring(monsterData.baseEXP);
		baseHealth = tostring(monsterData.baseHealth);
		baseDamage = tostring(monsterData.baseDamage);
		attackSpeed = tostring(monsterData.attackSpeed);
	}
end



warn("----------")
print(game.HttpService:JSONEncode(monsterInfo))
warn("----------")







local function normify(str)

	str = string.gsub(string.gsub(str," ","_"),"[^a-zA-Z0-9 - _ :]","")

	
	
	if #str > 40 then
		str = string.sub(str,1,40)
	end
	return str
end

local locale = {}

local abilityLookup = game.ReplicatedStorage.abilityLookup
for i,module in pairs(abilityLookup:GetChildren()) do
	local item = require(module)
	
	local entry = {}
	entry.Key = "abilityName_"..normify(module.Name)
	print(entry.Key)
	entry.Source = item.name
	entry.Example = ""
	entry.Values = {}
	
	table.insert(locale, entry)
	
	local entry = {}
	entry.Key = "abilityDescription_"..normify(module.Name)
	print(entry.Key)
	entry.Source = item.description
	entry.Example = ""
	entry.Values = {}	
	
	table.insert(locale, entry)
end

game.LocalizationService.AbilityTable:SetEntries(locale)






-- mass teleport to internal

local target = game.Players.berezaa.Character.PrimaryPart.Position

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")
		
for i,player in pairs(game.Players:GetPlayers()) do
	if player.Character and player.Character.PrimaryPart and (player.Character.PrimaryPart.Position - target).magnitude <= 20 then
		network:invoke("teleportPlayer", player, 2064647391)
	end
end









if workspace.placeFolders.spawnRegionCollections:FindFirstChild("Spider Queen-0") == nil then
	local folder = Instance.new("Folder", workspace.placeFolders.spawnRegionCollections)
	folder.Name = "Spider Queen-0"
end

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")



local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")



		for i=1,1 do
			wait(0.3)
network:invoke("spawnMonster", "Shroom", game.Players.berezaa.Character.PrimaryPart.Position + game.Players.berezaa.Character.PrimaryPart.CFrame.lookVector * 20 + Vector3.new(math.random(-5,5),00,math.random(-5,5)), workspace.placeFolders.spawnRegionCollections:GetChildren()[1],
	{ level = 50; scale = 1.3; baseSpeed = 100; baseHealth = 20; damageMulti = 999; specialName = "r e d  m u s h r o o m"; dye = {r=255,g=0,b=0}})
		end



--187088672
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")

		for i=1,1 do
			wait(0.3)
network:invoke("spawnMonster", "Trickster Spirit", game.Players.berezaa.Character.PrimaryPart.Position + game.Players.berezaa.Character.PrimaryPart.CFrame.lookVector * 20 + Vector3.new(math.random(-5,5),00,math.random(-5,5)), workspace.placeFolders.spawnRegionCollections:GetChildren()[1],
	{ baseHealth = 1000; lootDrops = {}})
		end


wait(5)
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")
network:invoke("spawnMonster", "Scarab", game.Players.berezaa.Character.PrimaryPart.Position + game.Players.berezaa.Character.PrimaryPart.CFrame.lookVector * 20 + Vector3.new(math.random(-40,40),00,math.random(-40,40)), workspace.placeFolders.spawnRegionCollections:GetChildren()[1],{giant = true})
	


local teleportService = game:GetService("TeleportService")
	local success, errorMessage, placeId, jobId = pcall(function()
		return teleportService:GetPlayerPlaceInstanceAsync(70347205)
	end)
	print(success, errorMessage, placeId, jobId)
	if success then
		print(placeId, jobId)
		-- Teleport player
		teleportService:TeleportToPlaceInstance(placeId, jobId, game.Players.Polymorphic, nil, {destination = placeId; saveSlot = 2; dataSlot = 2})
	end



local chickens = workspace.placeFolders.monsterManifestCollection:GetChildren()

local bigchicken 

for i,chicken in pairs(chickens) do
	if chicken:FindFirstChild("monsterScale") and chicken.monsterScale.Value > 1.5 then
		bigchicken = chicken
	end
end

Instance.new("PointLight", bigchicken).Brightness = 3

local healthhint = Instance.new("Hint",workspace)
healthhint.Text = "Big Chicken HP: "..bigchicken.health.Value.." / "..bigchicken.maxHealth.Value

bigchicken.health.Changed:connect(function()
	healthhint.Text = "Big Chicken HP: "..bigchicken.health.Value.." / "..bigchicken.maxHealth.Value
end)


local chickens = workspace.placeFolders.monsterManifestCollection:GetChildren()

local bigchicken = chickens[#chickens]

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")
		
for i,player in pairs(game.Players:GetPlayers()) do		
		
					local damageData = {}
						damageData.damage 			= 100000000
						damageData.sourcePlayerId	= player.userId
						damageData.damageTime		= os.time()

wait()
local explode = Instance.new("Explosion",workspace)
explode.BlastPressure = 1000
explode.DestroyJointRadiusPercent = 0
explode.Position = bigchicken.Position		
		
successfullyDealtDamage = network:invoke("monsterDamageRequest_server", player, bigchicken, damageData)

end


wait(5)
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")

		network:invoke("spawnMonster", "The Yeti", 
			game.Players.berezaa.Character.PrimaryPart.Position + game.Players.berezaa.Character.PrimaryPart.CFrame.lookVector * 40 + Vector3.new(math.random(-30,30),00,math.random(-30,30)),
			 workspace.placeFolders.spawnRegionCollections:GetChildren()[1],{dye = {r=0;g=255;b=0}; specialName = "The Incredible Hulk"})




wait(5)
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")
		for i=1,1 do
		pcall(function()

			network:invoke("spawnMonster", "Spiderling", game.Players.berezaa.Character.PrimaryPart.Position + game.Players.berezaa.Character.PrimaryPart.CFrame.lookVector * 40 + Vector3.new(math.random(-30,30),00,math.random(-30,30)), workspace.placeFolders.spawnRegionCollections:GetChildren()[1],{giant = true;})
		end)
end




local placeId = 3112029149
local player = game.Players.berezaa
local dataSlot = 3
game:GetService("TeleportService"):Teleport(placeId, player, {destination = placeId; dataSlot = dataSlot})


	
	local replicatedStorage = game:GetService("ReplicatedStorage")
		local modules 		= require(replicatedStorage.modules)
			local network 		= modules.load("network")
			
			local player = game.Players.berezaa
			network:invoke("tradeItemsBetweenPlayerAndNPC", player, {}, 0, {{id=135;stacks=1}}, 0, "etc:vincent")

			
			
			
			
			
			
			for i,player in pairs(game.Players:GetPlayers()) do
			network:invoke("tradeItemsBetweenPlayerAndNPC", player, {}, 0, {{id=135;stacks=1}}, 0, "etc:vincent")
			end
			
			
			
			
			
			
			wait()
			for i=1,1 do
	network:invoke("spawnMonster", "Chicken", game.Players.Polymorphic.Character.PrimaryPart.Position + game.Players.Polymorphic.Character.PrimaryPart.CFrame.lookVector * 30 + Vector3.new(0,10,0), workspace.placeFolders.spawnRegionCollections:GetChildren()[1],
		{gigaGiant = true, maxhealth = 100000, health = 100000, id = nil, passive = nil, lootDrops = {
			{itemName = "fish"; spawnChance = 0.9};
			{itemName = "yellow puffer fish"; spawnChance = 0.5};
			{itemName = "big brown fish"; spawnChance = 0.7};
			{itemName = "pretty pink fish"; spawnChance = 0.7};
			{itemName = "tall blue fish"; spawnChance = 0.7};
			} })
			end
		

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")
		wait()
		for i=1,1 do
			wait()
network:invoke("spawnMonster", "Shroom", game.Players.berezaa.Character.PrimaryPart.Position + game.Players.berezaa.Character.PrimaryPart.CFrame.lookVector * 30 + Vector3.new(0,10,0), workspace.placeFolders.spawnRegionCollections:GetChildren()[1],
	{giant = true; goldMulti = 1; specialName = [[mÍÌªÌ¥Ì»ÍuÌ³ÍÌ¦shÌÍÌ¯ÌªÌ°rÍÍÌ«oÌ´Ì²Ì©Ì©ÌÌªoÌ¤Ì¼Ì¼ÍÌÍÍmÌµÍÌ»ÍÌ­]]; dye = {r=255;g=0;b=0}; level = 30})
		end

		
		

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")
		wait(10)
		for i=1,10 do
network:invoke("spawnMonster", "Terror of the Deep", game.Players.berezaa.Character.PrimaryPart.Position + game.Players.berezaa.Character.PrimaryPart.CFrame.lookVector * 50 + Vector3.new(0,10,0), workspace.placeFolders.spawnRegionCollections["Spider-0"],{})
		end









local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")
		for i=1,1 do
network:invoke("spawnMonster", "Baby Shroom", game.Players.berezaa.Character.PrimaryPart.Position + Vector3.new(math.random(-10,10), math.random(25,35), math.random(-10,10)), workspace.placeFolders.spawnRegionCollections:GetChildren()[1],
	{lootDropMulti = 30; 
	 lootDrops = {{itemName = "mogomelon", spawnChance = 0.8}}; 
	 })
		end
	
		

local tau = 2 * math.pi
local function convertXBoxMovementToAngle(x, y)
	if x == 0 and y == 0 then return nil end
	
	local vector = Vector2.new(x, y)
	local h = vector.magnitude
	
	local asin, acos, atan2 = math.asin(y), math.acos(x), math.atan2(y, x)
	
	
end

-- set player data
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")
		
		local playerData = network:invoke("getPlayerData",game.Players.berezaa)
		playerData.nonSerializeData.setPlayerData("gold", 70e6)

-- set player data
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")
		
		local playerData = network:invoke("getPlayerData",game.Players.Polymorphic)
		playerData.nonSerializeData.setPlayerData("class", "Hunter")
		

-- ban a player for a duration

local PLAYERNAME = "ihnc"
local DURATION = 60 * 60 * 2
local REASON = "Exploiting is not allowed in Vesteria."

if not game.Players:FindFirstChild(PLAYERNAME) then warn("NO PLAYER FOR BAN") return false end

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")
		network:invoke("banPlayer", game.Players:FindFirstChild(PLAYERNAME), DURATION, REASON, "manual")
		
if game.Players:FindFirstChild(PLAYERNAME) then
local hint = Instance.new("Hint")
hint.Text = PLAYERNAME .. " was banned for " .. REASON
hint.Parent = workspace
game.Debris:AddItem(hint, 4)		
end

-- get a player's data
local datastoreVersion 	= 21
local httpService 		= game:GetService("HttpService")
local function getPlayerDataByUserId(userId, saveSlot, numberSavesToFetch, validatorFunction)
	local timestampResults 		= {}
	local suffix 				= "-slot"..tostring(saveSlot)
	local ODSSuccess, ODSError 	= pcall(function()
		local OrderedStore 	= game:GetService("DataStoreService"):GetOrderedDataStore(tostring(userId), "PlayerSaveTimes" .. datastoreVersion .. suffix)
		local pages 		= OrderedStore:GetSortedAsync(false, numberSavesToFetch)
		
		for i, v in pairs(pages:GetCurrentPage()) do
			if not validatorFunction or validatorFunction(v) then
				table.insert(timestampResults, v)
			end
		end
	end)
	
	local results = {}
	local success = pcall(function()
		if ODSSuccess then
			local datastore = game:GetService("DataStoreService"):GetDataStore(tostring(userId), "PlayerData" .. datastoreVersion .. suffix)
			for i, v in pairs(timestampResults) do
				local result = datastore:GetAsync(tostring(v))
				
				table.insert(results, result)
			end
		end
	end)
	
	return success, results
end

local success, data = getPlayerDataByUserId(75233545, 1, 1)
if success then
	print(data[1])
end

-- actually for real














local assetMap = require(game.ReplicatedStorage.GameAssets)
for i,v in pairs(game.StarterGui:GetDescendants()) do
	if v:IsA("LuaSourceContainer") then
		local source = v.Source
		for map, id in pairs(assetMap) do
			source = source:gsub(map, id)
		end
		v.Source = source
	end
end















local function populateItemHoverFrame(itemBaseData, newSource, inventorySlotData, additionalInfo)
		
		itemHoverFrame.header.itemName.Position = UDim2.new(0, 18,0, 3)
		itemHoverFrame.header.itemName.cuteDecor.Visible = true	
		itemHoverFrame.header.itemName.cuteDecor.Image = "rbxassetid://2528902611"	
		
--		itemHoverFrame.main.thumbnail.BackgroundTransparency = 0.2

		itemHoverFrame.main.thumbnailBG.Visible = true

		Modules.input.setCurrentFocusFrame(script.Parent)
		
		itemHoverFrame.main.mainContents.abilityInfo.Visible = false
		
		itemHoverFrame.main.Visible = true
		
		newSource = newSource or "pickup"
		module.source = newSource	
		
		if itemBaseData == nil then
			script.Parent.Visible = false
			script.Parent.contents.Visible = false
			module.source = "none"
			return false
		end	
		
		script.Parent.Size = UDim2.new(0, 320 + 10, 0, 40 + 10)
		
		if not script.Parent.Visible then
			script.Parent.contents.Visible = false
		end
		

		itemHoverFrame.header.itemName.AutoLocalize = false

		if inventorySlotData and inventorySlotData.customName then
			itemHoverFrame.header.itemName.Font = Enum.Font.SourceSansItalic
--			itemHoverFrame.header.itemName.AutoLocalize = false
		else
			itemHoverFrame.header.itemName.Font = Enum.Font.SourceSansBold
--			itemHoverFrame.header.itemName.AutoLocalize = true
		end
		
		cleanup()
		
		local itemBaseName = itemBaseData.name and localization.translate(itemBaseData.name, itemHoverFrame.header.itemName)
		local itemname = inventorySlotData and inventorySlotData.customName or itemBaseName or "???"
		
		local attribute = inventorySlotData.attribute 
		if attribute then
			local attributeData = itemAttributes[attribute]
			if attributeData then
				if attributeData.color then
					itemHoverFrame.main.thumbnailBG.ImageColor3 = attributeData.color
				end
				if attributeData.prefix and not inventorySlotData.customName then
					local attributeName = localization.translate(attributeData.prefix, itemHoverFrame.header.itemName)
					itemname = attributeName .. " " .. itemname
				end				
			end
		end		
		
		itemname = itemname .. ((inventorySlotData and inventorySlotData.upgrades and inventorySlotData.upgrades > 0 and " +"..(inventorySlotData.successfulUpgrades or 0)) or "")
		
		itemHoverFrame.header.itemName.Text 	= itemname 
		
		itemHoverFrame.main.mainContents.itemDescription.AutoLocalize = false	
		local desc = itemBaseData.description and localization.translate(itemBaseData.description, itemHoverFrame.main.mainContents.itemDescription)
		itemHoverFrame.main.mainContents.itemDescription.Text 	= desc or "Unknown"
		itemHoverFrame.header.itemType.Text 	= itemBaseData.category and string.upper(itemBaseData.category:sub(1, 1)) .. itemBaseData.category:sub(2) or "Unknown"		
		
		--[[
		local itemNameTextSize 			= textService:GetTextSize(itemBaseData.name, 20, Enum.Font.SourceSansBold, Vector2.new())
		local itemDescriptionTextSize 	= textService:GetTextSize(itemBaseData.description, 14, Enum.Font.SourceSansItalic, Vector2.new())
		]]
		local itemNameTextSize 			= textService:GetTextSize(itemHoverFrame.header.itemName.Text, titleTextSize, itemHoverFrame.header.itemName.Font, Vector2.new())
		local itemDescriptionTextSize 	= textService:GetTextSize(itemHoverFrame.main.mainContents.itemDescription.Text, itemHoverFrame.main.mainContents.itemDescription.TextSize, itemHoverFrame.main.mainContents.itemDescription.Font, Vector2.new())		
				
		
		
		local push = 0
		
		-- old scrolls indicator (defunct)
		--[[
		if inventorySlotData.enchantments and #inventorySlotData.enchantments > 0 then
			for i, child in pairs(itemHoverFrame.enchantments:GetChildren()) do
				if child:IsA("GuiObject") then
					child:Destroy()
				end
			end
			for i, enchantment in pairs(inventorySlotData.enchantments) do
				local enchantmentBaseData = itemLookup[enchantment.id]
				local enchantment = enchantmentBaseData.enchantments[enchantment.state]
				local frame = script.enchantment:Clone()
				local tierColor = module.tierColors[enchantment.tier + 1]
				frame.frame.ImageColor3 = tierColor
				frame.shine.ImageColor3 = tierColor
				frame.item.Image = enchantmentBaseData.image
				frame.LayoutOrder = 10-(enchantment.tier)
				frame.Parent = itemHoverFrame.enchantments
				Modules.fx.setFlash(frame.frame, enchantment.tier >= 1)
			end
			itemHoverFrame.enchantments.Visible = true
			push = push + 36
		end
		]]
		
		if (inventorySlotData and inventorySlotData.soulbound) or itemBaseData.soulbound then
			itemHoverFrame.soulbound.Visible = true
			push = push + 24
		end
		
		if itemBaseData.perks then
			for perkName, active in pairs(itemBaseData.perks) do
				if active then
					local perkData = perkLookup[perkName]
					if perkData then
						local perk = script.perk:Clone()
						perk.title.Text = perkData.title
						perk.description.Text = perkData.description						
						if perkData.color then
							perk.ImageColor3 = perkData.color
						end
						perk.Visible = true
						perk.Parent = itemHoverFrame
						push = push + 46
					end
				end
			end
		end
		
		if additionalInfo and additionalInfo.notOwned then
			itemHoverFrame.notOwned.Visible = true
			push = push + 24			
		end
		
		
		local itemNameLines = 1
--		local itemNameLines 		= math.ceil(itemNameTextSize.X / itemHoverFrame.header.itemName.AbsoluteSize.X)
		local itemDescriptionLines 	= math.ceil(itemDescriptionTextSize.X / itemHoverFrame.main.mainContents.itemDescription.AbsoluteSize.X)
		
		
		

		
		itemHoverFrame.main.thumbnail.Image 			= itemBaseData.image	
		
		itemHoverFrame.main.mainContents.equippableClasses.Visible = itemBaseData.category and itemBaseData.category == "equipment"
		itemHoverFrame.main.mainContents.equippableClasses.requirements.reqLevel.Visible = false
--		itemHoverFrame.main.mainContents.equippableClasses.requirements.reqLevel
		if itemBaseData.minLevel then
			itemHoverFrame.main.mainContents.equippableClasses.requirements.reqLevel.Visible = true
			itemHoverFrame.main.mainContents.equippableClasses.requirements.reqLevel.Text = "REQ Lvl. "..itemBaseData.minLevel or 0
			local level = network:invoke("getCacheValueByNameTag", "level") or 1
			itemHoverFrame.main.mainContents.equippableClasses.requirements.reqLevel.TextColor3 = Color3.fromRGB(203, 203, 203)
			if itemBaseData.minLevel > level then
				itemHoverFrame.main.mainContents.equippableClasses.requirements.reqLevel.TextColor3 = Color3.fromRGB(203, 69, 71)
			end
		end
		
		local canEquipClass = false
		
		local class = itemBaseData.minimumClass or "adventurer"
		class = class:lower()
		
		if class == "adventurer" then
			canEquipClass = true
		else
			local abilityBooks = network:invoke("getCacheValueByNameTag", "abilityBooks")
			canEquipClass = abilityBooks[class] ~= nil
		end
		
		local classTree = {
			["hunter"] = "hunter";
			["assassin"] = "hunter";
			["trickster"] = "hunter";
			["ranger"] = "hunter";
			["mage"] = "mage";
			["sorcerer"] = "mage";
			["warlock"] = "mage";
			["cleric"] = "mage";
			["warrior"] = "warrior";
			["paladin"] = "warrior";
			["knight"] = "warrior";
			["berserker"] = "warrior";
		}
		
		local classRoot = classTree[class]
		classRoot = classRoot or class
	
		for i,obj in pairs(itemHoverFrame.main.mainContents.equippableClasses:GetChildren()) do
			if obj:IsA("ImageLabel") then				
				if classRoot and classRoot == obj.Name then
					obj.ImageTransparency = 0
					obj.Image = "rbxgameasset://Images/emblem_"..class
				else
					obj.ImageTransparency = 0.7
					obj.Image = "rbxgameasset://Images/emblem_"..obj.Name
				end
				
				if canEquipClass then
					obj.ImageColor3 = Color3.fromRGB(173, 173, 173)
				else
					obj.ImageColor3 = Color3.fromRGB(203, 69, 71)
				end
			end
		end	
		
		-- clear previous stats
		for i, obj in pairs(itemHoverFrame.stats.container:GetChildren()) do
			if not obj:IsA("UIListLayout") then
				obj:Destroy()
			end
		end
				
		
		local numStats = 0
		
		local totalStats, statBonuses = getItemInfo(itemBaseData, inventorySlotData)
		
		local equippedStats 

		local equipped = network:invoke("getCacheValueByNameTag", "equipment")
		
		-- look for an equipped item to compare this to
		local correspendingEquipmentInventoryData
		for i,equipment in pairs(equipped) do
			if itemBaseData.equipmentSlot and equipment.position and itemBaseData.equipmentSlot == equipment.position then
				correspendingEquipmentInventoryData = equipment
				break
			end
		end
		if newSource ~= "equipment" then
			if correspendingEquipmentInventoryData then
				local correspondingEquipmentBaseData = itemLookup[correspendingEquipmentInventoryData.id]
				if correspondingEquipmentBaseData then
					equippedStats = getItemInfo(correspondingEquipmentBaseData,correspendingEquipmentInventoryData)
				end
			end	
		end
		
		for statName,statValue in pairs(totalStats) do
			if statValue ~= 0 then
			
				local statDisplayName = #statName <=3 and statName:upper() or statName:sub(1,1):upper() .. statName:sub(2)
				
				local statDisplayValue
				local statTextColor = Color3.new(160,160,160)
				
				local statPriority = 5
				
				if statName == "baseDamage" then
					statDisplayName = "Weapon Attack"
					statPriority = 1
				elseif statName == "defense" then
					statPriority = 1
				elseif statName == "damageTakenMulti" then
					statDisplayName = "Damage Taken"
					statPriority = 2
					statDisplayValue = statValue * 100 .. "\%" .. (statBonuses[statName] and statBonuses[statName] > 0 and " (+" .. statBonuses[statName] * 100 .. "\%)" or "")						
				elseif statName == "magicalDamage" then
					statDisplayName = "Magic Attack"
					statPriority = 2
				elseif statName == "rangedDamage" then
					statDisplayName = "Ranged Attack"
					statPriority = 2
				elseif statName == "physicalDamage" then
					statDisplayName = "Physical Attack"		
					statPriority = 2		
				elseif statName == "magicalDefense" then
					statDisplayName = "Magic Defense"
					statPriority = 2
				elseif statName == "rangedDefense" then
					statDisplayName = "Projectile Defense"
					statPriority = 2
				elseif statName == "physicalDefense" then
					statDisplayName = "Physical Defense"
					statPriority = 2
				elseif statName == "maxMana" then
					statDisplayName = "Max MP"
					statPriority = 3
				elseif statName == "maxHealth" then
					statDisplayName = "Max HP"
					statPriority = 3
				elseif statName == "healthRegen" then
					statDisplayName = "HP Recovery"
					statPriority = 4
					statDisplayValue = statValue .. "\%" .. (statBonuses[statName] and statBonuses[statName] > 0 and " (+" .. statBonuses[statName] .. "\%)" or "")
				elseif statName == "manaRegen" then
					statDisplayName = "MP Recovery"
					statPriority = 4
					statDisplayValue = statValue .. "\%" .. (statBonuses[statName] and statBonuses[statName] > 0 and " (+" .. statBonuses[statName] .. "\%)" or "")					
				elseif statName == "criticalStrikeChance" then
					statDisplayName = "Critical Chance"
					statDisplayValue = statValue * 100 .. "\%" .. (statBonuses[statName] and statBonuses[statName] > 0 and " (+" .. statBonuses[statName] * 100 .. "\%)" or "")
					statPriority = 4
				elseif statName == "blockChance" then
					statDisplayName = "Block Chance"
					statDisplayValue = statValue * 100 .. "\%" .. (statBonuses[statName] and statBonuses[statName] > 0 and " (+" .. statBonuses[statName] * 100 .. "\%)" or "")
					statPriority = 4					
				elseif statName == "greed" then
					statDisplayName = "Greed"
					statPriority = 5					
					statDisplayValue = statValue * 100 .. "\%" .. (statBonuses[statName] and statBonuses[statName] > 0 and " (+" .. statBonuses[statName] * 100 .. "\%)" or "")
				elseif statName == "wisdom" then
					statDisplayName = "XP"
					statPriority = 5					
					statDisplayValue = statValue * 100 .. "\%" .. (statBonuses[statName] and statBonuses[statName] > 0 and " (+" .. statBonuses[statName] * 100 .. "\%)" or "")		
				end
				
				if not statDisplayValue then
					statDisplayValue = (statValue .. (statBonuses[statName] and 
						((statBonuses[statName] > 0 and " (+" .. statBonuses[statName] .. ")" ) or
						(statBonuses[statName] < 0 and " (" .. statBonuses[statName] .. ")")) 
						or ""))
				end
				
				local comparisonExtension
				
				if equippedStats and equippedStats[statName] and equippedStats[statName] ~= 0 then

					local difference = ((statValue - equippedStats[statName]) / equippedStats[statName])
					if statName == "damageTakenMulti" then
						difference = -difference
					end
					if difference == difference then
						local comparisonText
						local comparisonColor
						if statValue == equippedStats[statName] or math.abs(difference) <= 0.01 then
							comparisonText = "="
						elseif difference >= 0 then
							comparisonText = "↑"
							comparisonColor = Color3.fromRGB(150,255,150)
							if difference >= 1 then
								comparisonText = "↑↑↑"
							elseif difference >= 0.25 then
								comparisonText = "↑↑"
							end
						else
							comparisonText = "↓"
							comparisonColor = Color3.fromRGB(255,150,150)
							if difference <= -0.5 then
								comparisonText = "↓↓↓"
							elseif difference <= -0.2 then
								comparisonText = "↓↓"
							end							
						end	
						if comparisonText then
							comparisonExtension = {text = comparisonText; textSize=20; font=Enum.Font.SourceSansBold; textColor3 = comparisonColor or Color3.new(0.6,0.6,0.6), autoLocalize = false}							
						end	
					end			
				end
			
				if statValue > 0 then
					statDisplayValue = "+"..statDisplayValue
				end
				statDisplayName = localization.translate(statDisplayName, itemHoverFrame.stats.container)
			
				local textContainer = uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container, {
	
					--[[
					{text = (statValue >= 0 and "+" or "") .. statValue .. (statName:find("Percent") and "%" or "")},
					{text = statName:gsub("Percent", ""):gsub("Flat", "")}
					]]
					{text = statDisplayName, textColor3 = statTextColor, textSize = 19, autoLocalize = false}, 
					{text = statDisplayValue, font = Enum.Font.SourceSansBold, textSize = 23, textColor3 = statTextColor, autoLocalize = false},
					comparisonExtension
				})
				textContainer.LayoutOrder = statPriority
				numStats = numStats + 1
				if statBonuses[statName] and statBonuses[statName] > 0 then
					if statName == "baseDamage" then
						local totalDamage = totalStats["baseDamage"] or 0.1
						local modifierBaseDamage = statBonuses["baseDamage"] or 0
						local difference = totalDamage / (totalDamage - modifierBaseDamage)				
					end
				end		
			end
		end
		
		if inventorySlotData and inventorySlotData.upgrades then
			local maxUpgrades = (itemBaseData.maxUpgrades or 0) + (inventorySlotData.bonusUpgrades or 0)
	
			local upgradesLeft = maxUpgrades - inventorySlotData.upgrades
			local suffix = upgradesLeft == 1 and "upgrade attempt remaining" or "upgrade attempts remaining"

			local label = uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container, {
				{text = (tostring(upgradesLeft).." "..suffix); font = Enum.Font.SourceSans; textColor3 = Color3.new(1,1,1); textTransparency = 0.5; autoLocalize = true} 
			})		
			label.LayoutOrder = 7
			numStats = numStats + 1

		end		
		--[[
		script.Parent.itemType.Visible = true
		
		for i,itemTypeLabel in pairs(script.Parent.itemType:GetChildren()) do
			if itemBaseData.category and itemBaseData.category == itemTypeLabel.Name then
				itemTypeLabel.Visible = true
			else
				itemTypeLabel.Visible = false
			end
		end
		]]		
		
		
		local titleColor
		if inventorySlotData then
			titleColor = getTitleColorForInventorySlotData(inventorySlotData) 
		end
		
		titleColor = titleColor or itemBaseData.nameColor or Color3.new(1,1,1)
		
		
		itemHoverFrame.header.itemName.TextColor3 = titleColor
		itemHoverFrame.header.itemName.cuteDecor.ImageColor3 = titleColor	
		
		local itemType = itemBaseData.itemType 
		itemHoverFrame.header.itemName.cuteDecor.Image = "rbxgameasset://Images/category_"..itemType
		
		local maxUpgrades = itemBaseData.maxUpgrades or 0
		-- stars next to item name (defunct)
		--[[
		for i,star in pairs(itemHoverFrame.header.itemName.stars:GetChildren()) do
			if star:IsA("ImageLabel") then
				local n = tonumber(star.Name)
				star.ImageColor3 = Color3.fromRGB(255, 255, 255)
				star.ImageTransparency = 0.9
				star.LayoutOrder = 12
				star.Visible = n <= maxUpgrades
				star.Image = "rbxassetid://3763830087"
			end
		end
		local n = 0
		if inventorySlotData.enchantments then
			for i, enchantmentData in pairs(inventorySlotData.enchantments) do
				local enchantmentBaseData = itemLookup[enchantmentData.id].enchantments[enchantmentData.state]
				local star = itemHoverFrame.header.itemName.stars:FindFirstChild(tostring(i))
				star.ImageTransparency = 0
				local tier = enchantmentBaseData.tier or 0
--				star.ImageColor3 = module.tierColors[tier]
				star.ImageColor3 = titleColor
				star.LayoutOrder = 10 - tier
				star.Visible = true
				n = n + 1
			end
		end
		local fails = math.clamp((inventorySlotData.upgrades or 0) - (inventorySlotData.successfulUpgrades or 0), 0, maxUpgrades)
		for i=1,fails do
			local star = itemHoverFrame.header.itemName.stars:FindFirstChild(tostring(n+i))
			if star then
				star.LayoutOrder = 11
				star.ImageTransparency = 0
				star.ImageColor3 = module.tierColors[-1]
				star.Image = "rbxassetid://3799648173"
			end
		end
		]]
		
		itemHoverFrame.main.thumbnailBG.frame.ImageColor3 = titleColor
		itemHoverFrame.main.thumbnailBG.shine.ImageColor3 = titleColor
		
		
		itemHoverFrame.main.thumbnail.BorderColor3 = titleColor

		
		--inventorySlotData and inventorySlotData.upgrades

		
		itemHoverFrame.main.thumbnail.ImageColor3 = Color3.new(1,1,1)	
		
		local customTag = (inventorySlotData and inventorySlotData.customTag) or (itemBaseData and itemBaseData.customTag)
		
		if customTag then

			local label = uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container, {
				customTag
			})	
			label.LayoutOrder = 9
			numStats = numStats + 1				
		end	
		
		local perks = {}
		if itemBaseData.perkData then
			table.insert(perks, itemBaseData.perkData)
		end
		if inventorySlotData.perkData then
			table.insert(perks, inventorySlotData.perkData)
		end
		for i,perkData in pairs(perks) do
			local label = uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container, {
				{text = itemBaseData.perkData.title; font = Enum.Font.SourceSansBold; textColor3 = module.tierColors[perkData.tier or 1]; textTransparency = 0; autoLocalize = true} 
			})	
			label.LayoutOrder = 9
			numStats = numStats + 1					
		end
		
		if inventorySlotData and inventorySlotData.dye then
			itemHoverFrame.main.thumbnail.ImageColor3 = Color3.fromRGB(inventorySlotData.dye.r, inventorySlotData.dye.g, inventorySlotData.dye.b)
			local label = uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container, {
				{text = "Dyed"; font = Enum.Font.SourceSansBold; textColor3 = Color3.fromRGB(inventorySlotData.dye.r, inventorySlotData.dye.g, inventorySlotData.dye.b); textTransparency = 0} 
			})	
			label.LayoutOrder = 10
			numStats = numStats + 1				
		end				
				
		
		if inventorySlotData and inventorySlotData.customStory then
			local label = uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container, {
				{text = ""; font = Enum.Font.SourceSans; textTransparency = 1; autoLocalize = false;} 
			})	
			label.LayoutOrder = 11
			local label = uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container, {
				{text = "\""..inventorySlotData.customStory.."\""; font = Enum.Font.Antique; textColor3 = Color3.new(1, 1, 1); textTransparency = 0.2; autoLocalize = false;} 
			})	
			label.LayoutOrder = 11
			numStats = numStats + 2						
		end
		
		local headerYSize = itemNameTextSize.Y * itemNameLines 
	
		itemHoverFrame.header.Size 			= UDim2.new(1, 0, 0, headerYSize)
		itemHoverFrame.header.itemName.Size = UDim2.new(0, itemNameTextSize.X, 0, itemNameTextSize.Y * itemNameLines)
--		itemHoverFrame.header.itemName.stars.Visible = true
		itemHoverFrame.stats.container.Size = UDim2.new(1, 0, 0, numStats * 20)	
		itemHoverFrame.stats.Size 			= UDim2.new(1, 0, 0, numStats * 20)
		
		itemHoverFrame.stats.Visible = numStats > 0
		
		itemHoverFrame.main.mainContents.itemDescription.Size = UDim2.new(1, 0, 0, itemDescriptionTextSize.Y * itemDescriptionLines + 10)	
		
		--local y = headerYSize + itemDescriptionTextSize.Y * itemDescriptionLines + 20 + numStats * 18 + 30 + 10
		

		
--		local y = headerYSize + mainContentsSize + numStats * 18 + (numStats > 0 and 20 or 0) + push

		local y = 10
		for i,child in pairs(itemHoverFrame:GetChildren()) do
			if child:IsA("GuiObject") and child.Visible then
				y = y + child.AbsoluteSize.Y + itemHoverFrame.UIListLayout.Padding.Offset
			end
		end

		
		local openSize = UDim2.new(0, 320 + 10, 0, y + 10)
		
		script.Parent.Size = openSize
		script.Parent.contents.Visible = true
		
		if module.source ~= "pickup" and module.source ~= "none" then
			reposition()
			script.Parent.Visible = true
			
		end
	end










































local datastoreVersion = 21

local Slot = 3
local PlayerId = 5000861

local Data







for i,child in pairs(workspace:GetDescendants()) do
	if child:IsA("MeshPart") and child.Parent:IsA("Model") and not child.Parent.PrimaryPart then
		if child.MeshId == "rbxassetid://1280289624" and string.find(child.Parent.Name:lower(), "pine") then
			child.Parent.Name = "Pine"
			child.Name = "Log"
			child.Parent.PrimaryPart = child
		elseif child.MeshId == "rbxassetid://1280289624" and string.find(child.Parent.Parent.Name:lower(), "pine") and child.Parent.Name == "Model" then
			child.Parent.Name = "Pine"
			child.Name = "Log"
			child.Parent.PrimaryPart = child	
			local uselessModel = child.Parent.Parent
			child.Parent.Parent = uselessModel.Parent
			uselessModel:Destroy()
		elseif string.find(child.Name:lower(), "tree") and #child.Parent:GetChildren() <= 20 then
			child.Parent.Name = child.Name
			child.Name = "Log"
			child.Parent.PrimaryPart = child
		elseif child.Name == "Rock" and child.Parent:FindFirstChild("Leaf") and #child.Parent:GetChildren() <= 20 then
			child.Parent.Name = "Tree"
			child.Name = "Log"
			child.Parent.PrimaryPart = child			
		elseif child.MeshId == "rbxassetid://1301715800" and string.find(child.Parent.Name:lower(), "oak") then
			child.Parent.Name = "Oak"
			child.Name = "Log"
			child.Parent.PrimaryPart = child
		elseif child.Name == "Stump" and string.find(child.Parent.Name:lower(), "tree") and #child.Parent:GetChildren() <= 5 then
			child.Parent.Name = "SmallPine"
			child.Name = "Log"
			child.Parent.PrimaryPart = child
		elseif child.MeshId == "rbxassetid://2473655248" and #child.Parent:GetChildren() <= 5 then
			child.Parent.Name = "BigPalm"
			child.Name = "Log"
			child.Parent.PrimaryPart = child 	
		elseif child.MeshId == "rbxassetid://2473781473" and #child.Parent:GetChildren() <= 5 then
			child.Parent.Name = "Palm"
			child.Name = "Log"
			child.Parent.PrimaryPart = child 	
		end
	end
end






local function GetMostRecentSaveTime(pages)
	for _, Pair in pairs(pages:GetCurrentPage()) do
		return Pair.value
	end
end
	local Suffix 		= "-slot"..tostring(Slot)
	local LastSave



	local ODSSuccess, ODSError = pcall(function()
		local OrderedStore 	= game:GetService("DataStoreService"):GetOrderedDataStore(tostring(PlayerId), "PlayerSaveTimes" .. datastoreVersion .. Suffix)
--		OrderedStore:SetAsync("Default", 1)
		local pages = OrderedStore:GetSortedAsync(false, 1)
		LastSave = GetMostRecentSaveTime(pages) or 0
	end)
	
	-- ODS call failed, abort.
	if not ODSSuccess then
		return false, nil, "(ODS): "..ODSError
	end

	
	local DSSuccess, DSError
	
	-- player data is available 
	if LastSave > 1 then
		DSSuccess, DSError = pcall(function()	
			-- This data slot should have data on it
			local DataStore = game:GetService("DataStoreService"):GetDataStore(tostring(PlayerId), "PlayerData" .. datastoreVersion .. Suffix)
			Data = DataStore:GetAsync(tostring(LastSave))
		end)
	end	
	
local datastring = game:GetService("HttpService"):JSONEncode(Data)
print(#datastring, datastring)			
			
			