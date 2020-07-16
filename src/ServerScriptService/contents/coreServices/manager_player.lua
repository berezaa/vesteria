-- manages all player data and data manipulation
-- all data manipulation must be done here.
-- author: Polymorphic
-- editor: berezaa

local module = {}
local playerDataContainer = {}
local playerPositionDataContainer = {}
local datastoreInterface = require(script.datastoreInterface)

local shuttingDown = false
local runService = game:GetService("RunService")

local teleportService = game:GetService("TeleportService")
local collectionService = game:GetService("CollectionService")
local httpService = game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local modules = require(replicatedStorage.modules)
local network = modules.load("network")
local utilities = modules.load("utilities")
local physics = modules.load("physics")
local levels = modules.load("levels")
local mapping = modules.load("mapping")
local configuration = modules.load("configuration")
local ability_utilities = modules.load("ability_utilities")
local placeSetup = modules.load("placeSetup")
local enchantment = modules.load("enchantment")
local events = modules.load("events")
local detection = modules.load("detection")

-- todo: phase out
local playerManifestCollectionFolder = placeSetup.getPlaceFolder("playerManifestCollection")
local playerRenderCollectionFolder = placeSetup.getPlaceFolder("playerRenderCollection")
local monsterManifestCollectionFolder = placeSetup.getPlaceFolder("monsterManifestCollection")
local entityManifestCollectionFolder = placeSetup.getPlaceFolder("entityManifestCollection")
local entityRenderCollectionFolder = placeSetup.getPlaceFolder("entityRenderCollection")
local pvpZoneCollectionFolder = placeSetup.getPlaceFolder("pvpZoneCollection")
local temporaryEquipmentFolder = placeSetup.getPlaceFolder("temporaryEquipment")

local itemLookup = require(replicatedStorage.itemData)
local itemAttributes = require(replicatedStorage.itemAttributes)
local perkLookup = require(replicatedStorage.perkLookup)
local monsterLookup = require(replicatedStorage.monsterLookup)
local questLookup = require(replicatedStorage.questLookup)
local abilityBookLookup = require(replicatedStorage.abilityBookLookup)
local abilityLookup = require(replicatedStorage.abilityLookup)
local blessingLookup = require(replicatedStorage.blessingLookup)
local statusEffectLookup = require(replicatedStorage.statusEffectLookup)
local professionLookup = require(replicatedStorage.professionLookup)

-- has to load here due to requirements on stuff above
local projectile = modules.load("projectile")
local ticksPerSecond = 3
local PLAYER_LEVEL_CAP = 49

-- free weekend has no level cap
if game.gameId == 712031239 or game.PlaceId == 2103419922 then
	PLAYER_LEVEL_CAP = 999999999
end

-- todo: purge spawnChance and itemName (and also futureproof)
-- from inventorySlotData due to item drops metadata being lootDrop based!
local INVENTORY_SLOTS_DATA_INDEXES = {
	id = true;
	stacks = true;
	modifierData = true;
	position = true;
	successfulUpgrades = true;
	upgrades = true;
}

local function getPlayerData(player)
	return playerDataContainer[player]
end

local function getPlayerData_remote(callingPlayer, ...)
	return getPlayerData(...)
end

-- GLOBAL DATA HOOKUP

network:create("getPlayerGlobalData", "BindableFunction", "OnInvoke", function(player)
	local success, data, status = datastoreInterface:getPlayerGlobalSaveFileData(player)

	if not success then
		local reportingSuccess, reportingError = pcall(function()
			network:invoke("reportError", player, "error", "getPlayerGlobalData failed: "..status)
			network:invoke("reportAnalyticsEvent",player,"data:fail:save")
		end)

		if not reportingSuccess then
			warn("Failed to report data error: "..reportingError)
		end
	end

	return success, data, status
end)

network:create("setPlayerGlobalData", "BindableFunction", "OnInvoke", function(player, GlobalData)
	local playerId = player.userId

	local success, status, version = datastoreInterface:updatePlayerGlobalSaveFileData(playerId, GlobalData)

	if not success then
		local reportingSuccess, reportingError = pcall(function()
			network:invoke("reportError", player, "error", "setPlayerGlobalData failed: "..status)
			network:invoke("reportAnalyticsEvent",player,"data:fail:save")
		end)

		if not reportingSuccess then
			warn("Failed to report data error: "..reportingError)
		end
	end

	return success, status, version
end)

local function respawnPlayer__NORMAL(player)
	if player.Character then
		player.Character:Destroy()
	end

	player:LoadCharacter()

	local start = tick()

	repeat
		wait(0.1)
	until player.Character and player.Character.PrimaryPart or (tick() - start >= 10)

	if player.Character and player.Character.PrimaryPart then
		player.Character.PrimaryPart.mana.Value = math.ceil(player.Character.PrimaryPart.maxMana.Value * 0.5)
		player.Character.PrimaryPart.health.Value = math.ceil(player.Character.PrimaryPart.maxHealth.Value * 0.5)
	end
end

local function isPlayerOfClass(player, class)
	class = class:lower()

	if class == "adventurer" then
		return true
	end

	local playerData = playerDataContainer[player]
	if not playerData then
		return false
	end

	if playerData.class:lower() == class then
		return true
	end

	-- conflating the name of an ability book with a class seems spookarook
	-- but here we go anyways, Davidii taking responsibility for this
	return playerData.abilityBooks[class] ~= nil
end
network:create("getIsPlayerOfClass", "RemoteFunction", "OnServerInvoke", isPlayerOfClass)
network:create("getIsPlayerOfClass_server", "BindableFunction", "OnInvoke", isPlayerOfClass)

local function getPlayerDefaultHomePlaceId(player)
	if isPlayerOfClass(player, "warrior") then
		return 2470481225 -- warrior stronghold

	elseif isPlayerOfClass(player, "mage") then
		return 3112029149 -- tree of life

	elseif isPlayerOfClass(player, "hunter") then
		return 2546689567

	else

		return 2064647391
	end
end

local function onDeathGuiAccepted(player)
	local playerData = playerDataContainer[player]
	if not playerData then return end

	local tagName = "acceptedDeathConsequences"
	local tag = player:FindFirstChild(tagName)
	if tag then return end

	local source = "game:death"

	playerData.nonSerializeData.incrementPlayerData("gold", -(playerData.gold*0.1), source)
	local expForNextLevel = levels.getEXPToNextLevel(playerData.level)
	local newExp = math.clamp(playerData.exp - expForNextLevel * 0.2, 0, expForNextLevel)
	playerData.nonSerializeData.setPlayerData("exp", newExp)

	local nearestCity = game.ReplicatedStorage:FindFirstChild("nearestCityId") and game.ReplicatedStorage.nearestCityId.Value
	local returnDestination = nearestCity or playerData.homePlaceId or getPlayerDefaultHomePlaceId(player)
	returnDestination = utilities.placeIdForGame(returnDestination)
	playerData.lastLocationDeathOverride = returnDestination

	tag = Instance.new("BoolValue")
	tag.Name = tagName
	tag.Value = true
	tag.Parent = player

	-- set health and mana to 1
	local character = player.Character
	if character then
		local manifest = character.PrimaryPart
		if manifest then
			local health = manifest:FindFirstChild("health")
			local mana = manifest:FindFirstChild("mana")
			if health and mana then
				health.Value = 1
				mana.Value = 1
			end
		end
	end

	if game.PlaceId == 2103419922 then
	--	game:GetService("TeleportService"):Teleport(2103419922, player)
		player:Kick("You are dead.")
		return
	end

	network:invoke("teleportPlayer", player, playerData.lastLocationDeathOverride, "default", nil, "death")
end
network:create("deathGuiAccepted", "RemoteEvent", "OnServerEvent", onDeathGuiAccepted)

local function respawnPlayer__DANGEROUS(player)
	if player.Character then
		player.Character:Destroy()
	end
	if player:FindFirstChild("awaitingDeathGuiResponse") == nil then
		local tag = Instance.new("BoolValue")
		tag.Name = "awaitingDeathGuiResponse"
		tag.Value = true
		tag.Parent = player
	end
	network:fireClient("deathGuiRequested", player)
	local timer = 70
	while timer > 0 do
		timer = timer - wait(1)

		-- did the player get revived some other way?
		if player.Character then
			return
		end
	end

	-- made it to the end of the timer and they still haven't accepted
	-- kill 'em (but dont really that is really mean :( )
	onDeathGuiAccepted(player)
end
network:create("deathGuiRequested", "RemoteEvent")

local function performDeathCheck(player, isPlayerLeavingGame)
	if replicatedStorage:FindFirstChild("isGlobalSafeZone") then
		if not isPlayerLeavingGame then
			respawnPlayer__NORMAL(player)
		end

		return true
	end

	-- we gotta lose cash cash money y'all
	if not isPlayerLeavingGame then
		respawnPlayer__DANGEROUS(player)

		return true
	end

	local playerData = playerDataContainer[player]
	if playerData then
		if replicatedStorage:FindFirstChild("isGlobalUnsafeZone") or (playerData.nonSerializeData.isInPVPZone and playerData.nonSerializeData.isPVPZoneUnsafe) then
			-- player died in pvp zone, unsafe. figure out what killed them
			if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart:FindFirstChild("health") and player.Character.PrimaryPart.health:FindFirstChild("killingBlow") then
				if player.Character.PrimaryPart.health.killingBlow.Value == "damage" then
					-- bye bye data

					error("Data wiping has been disabled")

					datastoreInterface:wipePlayerSaveFileData(player, playerData)

					return
				end
			end
		else
			-- safe zone
			respawnPlayer__NORMAL(player)

			return
		end
	end
end

local function onPlayerConfirmDeath(player)
--	return performDeathCheck(player)
end

local function onPlayerRemoving(player)
	local playerId = player.userId

	if not player:FindFirstChild("teleporting") then
		if player:FindFirstChild("awaitingDeathGuiResponse") or player:FindFirstChild("acceptedDeathConsequences") or
			(player:FindFirstChild("isPlayerSpawning") and player.isPlayerSpawning.Value) then
			network:fireAllClients("signal_alertChatMessage", {
				Text = player.Name .. " rage quit.";
				Font = Enum.Font.SourceSansBold;
				Color = Color3.fromRGB(45, 87, 255)
			})
		else
			network:fireAllClients("signal_alertChatMessage", {
				Text = player.Name .. " disconnected.";
				Font = Enum.Font.SourceSansBold;
				Color = Color3.fromRGB(45, 87, 255)
			})
		end

		local tag = Instance.new("BoolValue")
		tag.Name = "disconnected"
		tag.Parent = player
	end

	playerPositionDataContainer[player] = nil

	if playerDataContainer[player] then
		-- onUnequipped this player's equipment to avoid memory leaks
		for _, slotData in pairs(playerDataContainer[player].equipment) do
			local itemData = itemLookup[slotData.id]
			if itemData.perks then
				for perkName, _ in pairs(itemData.perks) do
					local perkData = perkLookup[perkName]
					if perkData and perkData.onUnequipped then
						local success, err = pcall(function()
							perkData.onUnequipped(player, itemData, tostring(slotData.position))
						end)
						if not success then
							warn(string.format("item %s unequip failed because: %s", itemData.name, err))
						end
					end
				end
			end
		end

		local deathTag = player:FindFirstChild("awaitingDeathGuiResponse")
		if deathTag ~= nil then
			deathTag:Destroy()
			onDeathGuiAccepted(player)
		end

		if player:FindFirstChild("entityGUID") then
			local statusEffects = network:invoke("playerRemovingPackageStatusEffects", player)

			if statusEffects then
				playerDataContainer[player].packagedStatusEffects = statusEffects
			end
		end

		local char = player.Character
		if char then
			local manifest = char.PrimaryPart
			if manifest then
				local health = manifest:FindFirstChild("health")
				local mana = manifest:FindFirstChild("mana")
				if health and mana then
					playerDataContainer[player]["condition"] = {
						health = health.Value,
						mana = mana.Value
					}
				end
			end
		end

		local playerDataBackup = playerDataContainer[player]
		playerDataContainer[player] = nil

		-- attempt to retry up to 5 times on failure
		for i = 1, 5 do
			local Success, Error, TimeStamp = datastoreInterface:updatePlayerSaveFileData(playerId, playerDataBackup)
			if not Success then
				warn(player.Name,"'s data failed to save.",Error)

				local reportingSuccess, reportingError = pcall(function()
					network:invoke("reportError", player, "error", "Failed to save player data (on exit!): "..Error)
					network:invoke("reportAnalyticsEvent",player,"data:fail:save")
				end)
				if not reportingSuccess then
					warn("Failed to report data error: "..reportingError)
				end

				local messagingSuccess, messagingError = pcall(function()
					game:GetService("MessagingService"):PublishAsync("datawarning", {userId = playerId})
				end)
				if not messagingSuccess then
					warn("Failed to send warning: "..messagingError)
				end

			else
				if player:FindFirstChild("DataSaveFailed") then
					player.DataSaveFailed:Destroy()
				end
				return TimeStamp
			end
		end
	end

	-- can't believe i have to do this.
	if player.Character then
		player.Character.Parent = nil
		player.Character 		= nil
	end
end

--[[
	PLAYER APPEARANCE CHANGE
--]]

function playerRequest_changeAccessories(player, desiredAccessories, dialogueSource)
	local playerData = playerDataContainer[player]
	if playerData then
		if dialogueSource:IsA("ModuleScript") then
			local dialogueData = require(dialogueSource)
			if dialogueData and dialogueData.characterCustomization then
				local details = dialogueData.characterCustomization
				local cost = details.cost or 50000

				if #desiredAccessories > 0 and playerData.gold >= cost then
					local playerAccessoryData = utilities.copyTable(playerData.accessories)

					for i,desiredAccessory in pairs(desiredAccessories) do
						local category = game.ReplicatedStorage.accessoryLookup:FindFirstChild(desiredAccessory.accessory) or
							game.ReplicatedStorage.accessoryLookup:FindFirstChild(string.gsub(desiredAccessory.accessory, "Id", ""))
						if category and category:FindFirstChild(tostring(desiredAccessory.value)) then
							playerAccessoryData[desiredAccessory.accessory] = desiredAccessory.value
						else
							return false, "Invalid accessory request"
						end
					end

					playerData.nonSerializeData.setPlayerData("accessories", playerAccessoryData)
					playerData.nonSerializeData.incrementPlayerData("gold", -50000)

					return true
				end
				return false, "Not enough money or no accessory choice"
			end
			return false, "Invalid source"
		end
		return false, "No source provided"
	end
	return false, "Player data not found"
end

network:create("playerRequest_changeAccessories", "RemoteFunction", "OnServerInvoke", playerRequest_changeAccessories)

--[[
	INVENTORY
--]]

local CATEGORIES = {"equipment"; "consumable"; "miscellaneous"}
local MAX_NUMBER_SLOTS_PER_CATEGORY = 20
local MAX_COUNT_PER_STACK = 99
local MAX_STORAGE_COUNT = 20

local itemDropStacksLookup = {}

local function onGetPlayerEquipment(client, playerToGetEquipmentOf)
	if playerToGetEquipmentOf and typeof(playerToGetEquipmentOf) == "Instance" and playerToGetEquipmentOf:IsA("Player") then
		-- this is important, yield for it if the data isn't there.
		if not playerDataContainer[playerToGetEquipmentOf] then
			while not playerDataContainer[playerToGetEquipmentOf] do
				wait(0.1)
			end
		end

		return playerDataContainer[playerToGetEquipmentOf].equipment
	end
end

network:create("promptPlayerDeathScreen","RemoteEvent")

local function performDeathToRenderCharacter(player)
	local previousCharacter = player.Character
	local serverHitbox = previousCharacter.PrimaryPart

	if serverHitbox.state.Value ~= "dead" then
		player.isPlayerSpawning.Value = true
		player.playerSpawnTime.Value = os.time()

		serverHitbox.state.Value = "dead"

		local killer
		if serverHitbox:FindFirstChild("killingBlow") and serverHitbox.killingBlow:FindFirstChild("source") then
			killer = serverHitbox.killingBlow.source.Value
		end

		network:fire("playerCharacterDied", player, previousCharacter, killer)
		events:fireEventLocal("entityManifestDied", serverHitbox)

		if serverHitbox.health.Value <= serverHitbox.maxHealth.Value * -3 then
			utilities.playSound("DEATH", serverHitbox)
		else
			utilities.playSound("kill", serverHitbox)
		end

		local respawnTime = 7

		if game.ReplicatedStorage:FindFirstChild("respawnTime") then
			respawnTime = game.ReplicatedStorage.respawnTime.Value
		end

		local respawnType do
			local replicatedStorage = game:GetService("ReplicatedStorage")

			if replicatedStorage:FindFirstChild("safeZone") or (game.PlaceId == 2061558182) then
				respawnType = "normal"

			elseif replicatedStorage:FindFirstChild("overrideDeathBehavior") then
				respawnType = "custom"

			else
				respawnType = "dangerous"
			end
		end

		local tombstoneDuration = 300

		if not replicatedStorage:FindFirstChild("safeZone") then
			delay(3, function()
				if true then return end
				-- do not spawn tombstones in safe areas

				local tombstoneTag = player:FindFirstChild("tombstone")
				if tombstoneTag == nil then
					tombstoneTag = Instance.new("ObjectValue")
					tombstoneTag.Name = "tombstone"
					tombstoneTag.Parent = player
				end
				if tombstoneTag.Value then
					tombstoneTag.Value:Destroy()
				end

				local tombstone 	= script.tombstone:Clone()
				tombstone.CanCollide = false


				local targetPosition = (previousCharacter.PrimaryPart.CFrame - Vector3.new(0, previousCharacter.PrimaryPart.Size.Y / 2, 0)).Position

				local rayDown = Ray.new(previousCharacter.PrimaryPart.Position, Vector3.new(0,-50,0))
				local hitPart, hitPosition = workspace:FindPartOnRayWithIgnoreList(rayDown, {workspace.placeFolders, workspace.CurrentCamera}, false, true)
				if hitPart and hitPosition then
					targetPosition = hitPosition + Vector3.new(0, tombstone.Size.Y / 2.1, 0)
				end

				tombstone.CFrame 	= previousCharacter.PrimaryPart.CFrame - previousCharacter.PrimaryPart.Position + targetPosition
				local entityHitbox = network:invoke("spawnMonster", "Hitbox", tombstone.Position - Vector3.new(0,4,0), nil, {
					isPassive 		= true;
					isDamageImmune 	= true;
					isTargetImmune 	= true;
					specialName 	= player.Name .. "'s Tombstone"
				})

				if entityHitbox.manifest then
					entityHitbox.manifest.CanCollide = false
					entityHitbox.manifest.Anchored = true
					game.Debris:AddItem(entityHitbox.manifest, tombstoneDuration)
					tombstone.Parent = entityHitbox.manifest

					tombstoneTag.Value = entityHitbox.manifest

				else
					tombstone:Destroy()
					return false, "Failed to spawn tombstone."
				end
			end)
		end

		if respawnType == "dangerous" then
			network:fireClient("deathGuiRequested", player)

			local tag = Instance.new("BoolValue")
			tag.Name = "awaitingDeathGuiResponse"
			tag.Value = true
			tag.Parent = player

			local playerStillDead = true
			local timer = 70
			while timer > 0 do
				timer = timer - wait(1)

				-- if player is alive, stop this killswitch
				local character = player.Character
				if character then
					local manifest = character.PrimaryPart
					if manifest then
						local state = manifest:FindFirstChild("state")
						if state and state.Value ~= "dead" then
							playerStillDead = false

							break
						end
					end
				end
			end

			if player and player.Parent then
				tag:Destroy()

				if playerStillDead then
					onDeathGuiAccepted(player)
				end
			end
		end

		if respawnType == "normal" then
			delay(respawnTime, function()
				if player then
					local character = player.Character
					if character then
						-- skip out on respawning if they're not dead
						local manifest = character.PrimaryPart
						if manifest then
							local state = manifest:FindFirstChild("state")
							if state and state.Value ~= "dead" then
								return
							end
						end

						-- otherwise we should go on
						player.Character:Destroy()
					end

					player:LoadCharacter()
				end
			end)
		end
	end
end

local function getItemCountByItemId(player, itemId)
    local playerData = playerDataContainer[player]
    local count = 0
    if playerData then
        for i, inventorySlotData in pairs(playerData.inventory) do
            if inventorySlotData.id == itemId then
                count = count + inventorySlotData.stacks or 1
            end
        end
    end

    return count
end

local function onCharacterHealthChanged(player, healthValue)
	if healthValue <= 0 then
		performDeathToRenderCharacter(player)
	end
end

local function applyMaxHealth(player, dontHeal)
	local playerData = playerDataContainer[player]

	if playerData and player.Character and player.Character.PrimaryPart then
		local stats = playerData.nonSerializeData.statistics_final

		local oldMaxHealth = player.Character.PrimaryPart.maxHealth.Value
		local oldMaxMana = player.Character.PrimaryPart.maxMana.Value

		--[[
		player.Character.PrimaryPart.maxMana.Value 	= 15 + (3 * playerData.level) + (5 * stats.int)
		player.Character.PrimaryPart.maxHealth.Value 	= 75 + (25 * playerData.level) + (10 * stats.vit)
		]]

		player.Character.PrimaryPart.maxMana.Value 		= stats.maxMana
		player.Character.PrimaryPart.maxHealth.Value 	= stats.maxHealth

		local newHealth = player.Character.PrimaryPart.maxHealth.Value
		local newMana = player.Character.PrimaryPart.maxMana.Value

		if dontHeal then
			newHealth = player.Character.PrimaryPart.health.Value + (newHealth - oldMaxHealth)
			newMana = player.Character.PrimaryPart.mana.Value + (newMana - oldMaxMana)
		end

		player.Character.PrimaryPart.maxStamina.Value = stats.stamina or 0

		player.Character.PrimaryPart.health.Value = math.clamp(newHealth, 0, player.Character.PrimaryPart.maxHealth.Value)
		player.Character.PrimaryPart.mana.Value = math.clamp(newMana, 0, player.Character.PrimaryPart.maxMana.Value)
	end
end

local function onPlayerRequest_returnToMainMenu(player)
	game:GetService("TeleportService"):Teleport(2376885433, player, {teleportReason = "Heading back to the main menu..."}, game.ReplicatedStorage.returnToLobby)
end

local function onPlayerRequest_respawnMyCharacter(player)
	if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart:FindFirstChild("health") then
		if player.Character.PrimaryPart.health.Value > 0 and player.Character.PrimaryPart.state.Value ~= "dead" then
			if not game.ReplicatedStorage:FindFirstChild("safeZone") then

				local isNight = game.Lighting.ClockTime < 5.9 or game.Lighting.ClockTime > 18.6
				local messages = {
					"got themselves into a sticky situation";
					"is not having a good time right now";
					"pondered the meaning of life a little too hard";
					"wants to go home right now";
					"tripped over a pebble";
					"forgot how to breathe";
					"is just taking a long nap... right guys?";
					"ceased to exist";
					"ignored the warning";
					"used the stones to destroy... uh... themselves.";
					"didn't wash their hands for 20 seconds";
					"evaporated into thin air";
					"suddenly stopped being alive";
					"pressed the wrong button";
					isNight and "stared directly at the moon" or "stared directly into the sun"
				}

				local message = messages[math.random(1,#messages)]
				local text = "☠ " .. player.Name .. " " .. message .. " ☠"
				network:fireAllClients("signal_alertChatMessage", {
					Text = text,
					Font = Enum.Font.SourceSansBold,
					Color = Color3.fromRGB(255, 130, 100),
				})
			end
			player.Character.PrimaryPart.health.Value = 0
		end
	else
		if not game.ReplicatedStorage:FindFirstChild("noRespawns") then
			player:LoadCharacter()
		end
	end
end

local statsToProcessWithFormula = {"dex"; "int"; "str"; "vit"}
local function generatecompletePlayerStats(player, isInitializing, playerData)
	if not isInitializing and (not player or not playerDataContainer[player]) then return nil end

	local playerData = playerData or playerDataContainer[player]

	local baseStats = {}
	local baseStatsAdditive = {}
	local baseStatsMultiplicative = {}
	local totalStatsAdditive = {}
	local totalStatsMultiplicative = {}

	local equipmentDefense = 0
	local equipmentDamage = 0

	local function incorporateModifierData(modifierData)
		for i, modifier in pairs(modifierData) do
			for stat, statValue in pairs(modifier) do
				if stat == "defense" then
					equipmentDefense = equipmentDefense + statValue
				elseif stat == "damage" or stat == "baseDamage" then
					equipmentDamage = equipmentDamage + statValue
				else
					baseStats[stat] = (baseStats[stat] or 0) + statValue
				end
			end
		end

		--[[
		for ii, stat in pairs(statsToProcessWithFormula) do
			if modifierData[stat] then
				baseStats[stat] = baseStats[stat] + modifierData[stat]
			elseif modifierData[stat .. "_baseAdditive"] then
				baseStatsAdditive[stat] = baseStatsAdditive[stat] + modifierData[stat .. "_baseAdditive"]
			elseif modifierData[stat .. "_baseMultiplicative"] then
				baseStatsMultiplicative[stat] = baseStatsMultiplicative[stat] + modifierData[stat .. "_baseMultiplicative"]
			elseif modifierData[stat .. "_totalAdditive"] then
				totalStatsAdditive[stat] = totalStatsAdditive[stat] + modifierData[stat .. "_totalAdditive"]
			elseif modifierData[stat .. "_totalMultiplicative"] then
				totalStatsMultiplicative[stat] = totalStatsMultiplicative[stat] + modifierData[stat .. "_totalMultiplicative"]
			end
		end

		if modifierData.defense then
			equipmentDefense = equipmentDefense + modifierData.defense
		end

		if modifierData.baseDamage or modifierData.damage then
			equipmentDamage = equipmentDamage + (modifierData.baseDamage or modifierData.damage)
		end
		]]
	end

	-- set defaults for each stat
	for i, stat in pairs(statsToProcessWithFormula) do
		baseStats[stat] = 0
		baseStatsAdditive[stat] = 0
		baseStatsMultiplicative[stat] = 1
		totalStatsAdditive[stat] = 0
		totalStatsMultiplicative[stat] = 1
	end

	-- apply the stats
	local completePlayerStats = {}
	for i, stat in pairs(statsToProcessWithFormula) do
		-- fetch the base stat in the player data container file
		baseStats[stat] 				= playerData.statistics[stat] or 0
		baseStatsAdditive[stat] 		= baseStatsAdditive[stat] or 0
		baseStatsMultiplicative[stat] 	= baseStatsMultiplicative[stat] or 1
		totalStatsAdditive[stat] 		= baseStatsAdditive[stat] or 0
		totalStatsMultiplicative[stat] 	= totalStatsMultiplicative[stat] or 1
	end

	-- statusEffectsV2
	local activeStatusEffects = network:invoke("getStatusEffectsOnEntityManifestByEntityGUID", player.entityGUID.Value)
	for i, activeStatusEffectData in pairs(activeStatusEffects) do
		if activeStatusEffectData.statusEffectModifier and activeStatusEffectData.statusEffectModifier.modifierData then
			local modifierData = activeStatusEffectData.statusEffectModifier.modifierData

			incorporateModifierData({modifierData})
		end
	end

	local equipAttackSpeed = 3

	-- calculate from what the player is currently wearing
	local mainhandWeaponData, offhandWeaponData

	for i, equipmentSlotData in pairs(playerData.equipment) do
		local itemBaseData = itemLookup[equipmentSlotData.id]

		-- add in base data
		if itemBaseData then
			if itemBaseData.modifierData then
				incorporateModifierData(itemBaseData.modifierData)
			end

			local slot = equipmentSlotData.position
			local isWeapon = false
			if slot == 1 then
				mainhandWeaponData = itemBaseData
				isWeapon = true
				if itemBaseData.attackSpeed then
					equipAttackSpeed = itemBaseData.attackSpeed
				end
			-- only swords in the offhand count as weapons
			elseif slot == 11 and itemBaseData.equipmentType == "sword" then
				offhandWeaponData = itemBaseData
				isWeapon = true

			-- ignore bows and daggers in the offhand too
			-- but don't save their data because we aren't
			-- averaging the bows and daggers together
			elseif slot == 11 and (itemBaseData.equipmentType == "bow" or itemBaseData.equipmentType == "dagger") then
				isWeapon = true

			-- ignore fishing rods? why are these considered weapons
			elseif slot == 11 and itemBaseData.equipmentType == "fishing-rod" then
				isWeapon = true
			end

			-- we'll calculate weapon damage later because dual wielding is wacky
			if (not isWeapon) and (itemBaseData.baseDamage or itemBaseData.damage) then
				equipmentDamage = equipmentDamage + (itemBaseData.baseDamage or itemBaseData.damage)
			end

			-- enchantments! :P
			local statUpgrade = 0
			if equipmentSlotData.enchantments then
				for ii, enchantmentData in pairs(equipmentSlotData.enchantments) do
					local enchantmentBaseData = itemLookup[enchantmentData.id]
					if enchantmentBaseData.enchantments then
						local enchantmentState = enchantmentBaseData.enchantments[enchantmentData.state]
						if enchantmentState then
							if enchantmentState.modifierData then
								incorporateModifierData({enchantmentBaseData.enchantments[enchantmentData.state].modifierData})
							end
							if enchantmentState.statUpgrade then
								statUpgrade = statUpgrade + enchantmentState.statUpgrade
							end
						end
					end
				end
			end

			-- variable stat-enhancing enchants (mainly for hats!)
			if statUpgrade > 0 and itemBaseData.statUpgrade then
				local statUpgradeModifierData = {}
				for stat, value in pairs(itemBaseData.statUpgrade) do
					if value ~= 0 then
						statUpgradeModifierData[stat] = value * statUpgrade
					end
				end
				incorporateModifierData({statUpgradeModifierData})
			end

			-- attributes! :D
			if equipmentSlotData.attribute then
				local attributeData = itemAttributes[equipmentSlotData.attribute]
				if attributeData and attributeData.modifier then
					local attributeModifierData = attributeData.modifier(itemBaseData, equipmentSlotData)
					if attributeModifierData then
						incorporateModifierData({attributeModifierData})
					end
				end
			end
		end

		if equipmentSlotData.modifierData then
			incorporateModifierData(equipmentSlotData.modifierData)
		end
	end

	-- calculate the damage of weapons because dual wielding is wacky
	if mainhandWeaponData and offhandWeaponData then
		local damage = (
			(mainhandWeaponData.baseDamage or 0) + (mainhandWeaponData.damage or 0) +
			(offhandWeaponData.baseDamage or 0) + (offhandWeaponData.damage or 0)
		) / 2
		equipmentDamage = equipmentDamage + damage
	elseif mainhandWeaponData and (not offhandWeaponData) then
		local damage = (mainhandWeaponData.baseDamage or 0) + (mainhandWeaponData.damage or 0)
		equipmentDamage = equipmentDamage + damage
	end

	-- compile the stats
	for stat, value in pairs(baseStats) do
		completePlayerStats[stat] = value
	end

	-- post def-negation buffs
	completePlayerStats.damageTakenMulti = 1 + (baseStats.damageTakenMulti or 0)
	completePlayerStats.damageGivenMulti = 1 + (baseStats.damageGivenMulti or 0)

	-- unique stats are calculated differently
	completePlayerStats.equipmentDefense 	= equipmentDefense --+ playerData.level
	completePlayerStats.defense 			= equipmentDefense --+ playerData.level

	completePlayerStats.equipmentDamage 	= (equipmentDamage + (baseStats.equipmentDamage or 0)) --+ playerData.level
	completePlayerStats.damage 				= completePlayerStats.equipmentDamage --+ playerData.level

	completePlayerStats.physicalDamage 		= completePlayerStats.equipmentDamage --+ playerData.level
	completePlayerStats.magicalDamage 		= completePlayerStats.equipmentDamage --+ playerData.level

	completePlayerStats.physicalDefense 	= completePlayerStats.equipmentDefense --+ playerData.level
	completePlayerStats.magicalDefense 		= completePlayerStats.equipmentDefense --+ playerData.level

	completePlayerStats.stamina = 3 + (baseStats.stamina or 0)
	completePlayerStats.staminaRecovery = 1 + (baseStats.staminaRecovery or 0)

	-- previous:		75 + 25*lvl * 1/100*VIT
	-- new:				50 + 25*lvl
	local level = playerData.level
	local vit = completePlayerStats.vit
	local int = completePlayerStats.int
	local class = playerData.class

	-- health
	local HP = 15 + (5 * level)
	HP = HP + (5 * vit)
	if baseStats.maxHealth then
		HP = HP + baseStats.maxHealth
	end
	completePlayerStats.maxHealth = math.ceil(HP)

	-- mana
	local MP = 3 + (2 * level)
	MP = MP + 1 * int
	if baseStats.maxMana then
		MP = MP + baseStats.maxMana
	end
	completePlayerStats.maxMana = math.ceil(MP)

	local manaRegenMulti = 1
	if baseStats.manaRegen then
		manaRegenMulti = manaRegenMulti + baseStats.manaRegen/100
	end

	completePlayerStats.manaRegen 			= (1.0 + 0.035 * playerData.level + 0.050 * completePlayerStats.int) * manaRegenMulti

	local healthRegenMulti = 1
	if baseStats.healthRegen then
		healthRegenMulti = healthRegenMulti + baseStats.healthRegen/100
	end

	completePlayerStats.healthRegen 		= (0.5 + 0.240 * playerData.level + 0.100 * completePlayerStats.vit) * healthRegenMulti
	completePlayerStats.jump 				= 75 + (baseStats.jump or 0)
	completePlayerStats.consumeTimeReduction = 0 + (baseStats.consumeTimeReduction  or 0)
	completePlayerStats.attackSpeed = 0 + (equipAttackSpeed - 3)/3.5
	completePlayerStats.woodcutting = math.max(baseStats.woodcutting or 1, 1)
	completePlayerStats.mining = math.max(baseStats.mining or 1, 1)

--	completePlayerStats.attackSpeed 			= ((2 / 100) / 3) * completePlayerStats.dex + (baseStats.attackSpeed or 0)
	completePlayerStats.criticalStrikeChance 	= ((0.5 / 100) / 3) * completePlayerStats.dex + (baseStats.criticalStrikeChance or 0)
	completePlayerStats.blockChance 			= math.clamp(0.20 * (completePlayerStats.dex / (3 * playerData.level)), 0, 1) + (baseStats.blockChance or 0)
	-- how much damage critical strikes do (decimal multiplier)
	--  2 means 200%, not just "2".
	completePlayerStats.criticalStrikeDamage = 2 + (baseStats.criticalStrikeDamage or 0)

	-- how much more gold you get (this is a multipler, so 1 is just 100% of the
	-- regular value you'd get, anything higher is considered an increase)
	completePlayerStats.greed = 1 + (baseStats.greed or 0)

	-- how much more exp you get (this is a multipler, so 1 is just 100% of the
	-- regular value you'd get, anything higher is considered an increase)
	completePlayerStats.wisdom = 1 + (baseStats.wisdom or 0)

	-- increases chance of soulbound items being given to you
	completePlayerStats.luck 				= baseStats.luck or 0
	completePlayerStats.luckEffectiveness 	= 1.5 + (baseStats.luckEffectiveness or 0)

	-- flat movement speed of player
	completePlayerStats.walkspeed = 18 + (baseStats.walkspeed or 0)

	-- merchantCostReduction (1 = 100% reduction (1 gold minimum))
	completePlayerStats.merchantCostReduction = 0

	-- ability cool down reduction (1 = 100% reduction)
	completePlayerStats.abilityCDR = 0

	-- additive bonus (1 + attackRangeIncrease, therefore 1 = 200% increase)
	completePlayerStats.attackRangeIncrease = 0

	-- additive bonus (1 + consumableHealthIncrease, therefore 1 = 200% increase)
	completePlayerStats.consumableHealthIncrease 	= 0
	completePlayerStats.consumableManaIncrease 		= 0

	-- apply multiplicative bonuses?
	for stat, value in pairs(completePlayerStats) do
		local multiplicative = baseStats[stat.."_totalMultiplicative"]
		if multiplicative then
			completePlayerStats[stat] = value * (1 + multiplicative)
		end
	end

	-- apply perks here
	local activePerks = {}

	-- add perks from equipment
	for i, equipmentSlotData in pairs(playerData.equipment) do
		local itemBaseData = itemLookup[equipmentSlotData.id]
		-- add in base data
		if itemBaseData.perks then
			for perkName, perkData in pairs(itemBaseData.perks) do
				activePerks[perkName] = true
			end
		end
		if equipmentSlotData.perks then
			for perkName, perkData in pairs(equipmentSlotData.perks) do
				activePerks[perkName] = true
			end
		end
	end

	-- run conditions and apply perks as needed
	for perkName, perk in pairs(perkLookup) do
		local condition = perk.condition and perk.condition(completePlayerStats)
		-- figured this would be easier to do at the manager level
		if perk.class and isPlayerOfClass(player, perk.class) then
			condition = true
		end
		if condition or activePerks[perkName] then
			activePerks[perkName] = true
			if perk.apply then
				perk.apply(completePlayerStats)
			end
		else
			activePerks[perkName] = false
		end
	end

	completePlayerStats.activePerks = activePerks

	playerData.nonSerializeData.statistics_final = completePlayerStats

	applyMaxHealth(player, true)

	if player then
		for i, stat in pairs(statsToProcessWithFormula) do
			local valueObject = player:FindFirstChild(stat)
			if valueObject == nil then
				valueObject = Instance.new("IntValue")
				valueObject.Name = stat
				valueObject.Parent = player
			end

			valueObject.Value = completePlayerStats[stat]
		end

		if playerDataContainer[player] then
			network:fireClient("playerStatisticsChanged", player, playerData.statistics, completePlayerStats)
			playerData.nonSerializeData.playerDataChanged:Fire("nonSerializeData")
		end
	end

	return completePlayerStats
end

local function isPlayerInPVPZone(pvpZone, player)
	if not player or not player.Character or not player.Character.PrimaryPart then return false end

	local isInPVPZone

	local points = pvpZone:GetChildren()
	for i = 1, #points do
		local point1 		= pvpZone[tostring(i)]
		local point2 		= pvpZone[tostring(i == #points and 1 or i + 1)]
		local isInsideFace 	= (point2.Position - point1.Position):Cross(player.Character.PrimaryPart.Position - point1.Position).Y < 0

		if isInPVPZone ~= nil and isInsideFace ~= isInPVPZone then
			return false
		end

		isInPVPZone = isInsideFace
	end

	if isInPVPZone then
		local characterY 	= player.Character.PrimaryPart.Position.Y
		local upperYBound 	= points[1].Position.Y + points[1].Size.Y / 2
		local lowerYBound 	= points[1].Position.Y - points[1].Size.Y / 2

		return characterY >= lowerYBound and characterY <= upperYBound
	end

	return isInPVPZone
end

network:create("playerCharacterLoaded", "BindableEvent")

local function isStartingValueRemoved(primaryPart, child)
	if primaryPart.Parent == nil then
		return false
	end

	return not not game.StarterPlayer.StarterCharacter.PrimaryPart:FindFirstChild(child.Name)
end

local RESPAWN_POINT_RADIUS = 32
local RESPAWN_POINT_RADIUS_SQ = RESPAWN_POINT_RADIUS ^ 2

local function checkForRespawnPoint(player)
	local char = player.Character
	if not char then return end

	local root = char.PrimaryPart
	if not root then return end

	local respawnPoint = player:FindFirstChild("respawnPoint")
	if not respawnPoint then return end

	local spawnPoints = game.ReplicatedStorage.spawnPoints:GetChildren()

	local bestSpawnPoint = nil
	local bestDistanceSq = RESPAWN_POINT_RADIUS_SQ

	local function checkSpawnPoint(spawnPoint)
		if not spawnPoint:FindFirstChild("description") then return end
		if spawnPoint:FindFirstChild("ignore") then return end

		local delta = spawnPoint.Value.Position - root.Position
		local distanceSq = delta.X * delta.X + delta.Y * delta.Y + delta.Z * delta.Z

		if distanceSq <= bestDistanceSq then
			bestSpawnPoint = spawnPoint
			bestDistanceSq = distanceSq
		end
	end

	for _, spawnPoint in pairs(spawnPoints) do
		checkSpawnPoint(spawnPoint)
	end

	if bestSpawnPoint and (respawnPoint.Value ~= bestSpawnPoint) then
		respawnPoint.Value = bestSpawnPoint
		local spawnText = bestSpawnPoint:FindFirstChild("description") and bestSpawnPoint.description.Value
		if spawnText then
			local playerData = playerDataContainer[player]
			local placeData = playerData.locations[tostring(game.PlaceId)]
			placeData.spawns[bestSpawnPoint.Name] = {text = spawnText}
			playerData.nonSerializeData.playerDataChanged:Fire("locations")
		end
		events:fireEventPlayer("playerRespawnPointChanged", player, respawnPoint.Value)
	end
end

local function onCharacterAdded(player, character)
	while character.Parent ~= entityManifestCollectionFolder do
		wait(0.1)
		character.Parent = entityManifestCollectionFolder
	end

	generatecompletePlayerStats(player, false, playerDataContainer[player])

	if character:WaitForChild("hitbox", 10) then
		character.PrimaryPart = character.hitbox

		local VALUE_OBJECT_EXPLOITER_DELETION_CHECK do
			local primaryPartForCheck = character.PrimaryPart

			for i, obj in pairs(game.StarterPlayer.StarterCharacter.PrimaryPart:GetChildren()) do
				if not character.PrimaryPart:FindFirstChild(obj.Name) then
					player:Kick("Anti-exploit")
		--			game:GetService("TeleportService"):Teleport(2376885433, player, nil, game.ReplicatedStorage.returnToLobby)
				end
			end

			local function onChildRemoved(child)
				if isStartingValueRemoved(primaryPartForCheck, child) then
					player:Kick("Anti-exploit")
		--			game:GetService("TeleportService"):Teleport(2376885433, player, nil, game.ReplicatedStorage.returnToLobby)
				end
			end

			character.PrimaryPart.ChildRemoved:connect(onChildRemoved)
		end

		network:fire("playerCharacterLoaded", player, character)

		local success = pcall(function() character.PrimaryPart:SetNetworkOwner(player) end) do
			while not success do
				wait(0.5)
				success = pcall(function() character.PrimaryPart:SetNetworkOwner(player) end)
			end
		end

		applyMaxHealth(player)

		local playerData = playerDataContainer[player]
		if playerData and playerData.condition then
			local manifest = character.PrimaryPart
			if not manifest then return end

			local health = manifest.health
			local mana = manifest.mana
			if not (health and mana) then return end

			health.Value = math.max(1, playerData.condition.health)
			mana.Value = math.max(1, playerData.condition.mana)

			playerData.condition = nil
		end

		onCharacterHealthChanged(player, player.Character.PrimaryPart.health.Value)

		local alive = true

		if character.PrimaryPart and player.Character.PrimaryPart.health.Value > 0 then
			player.Character.PrimaryPart.health.Changed:connect(function(newHealth)
				onCharacterHealthChanged(player, newHealth)

				if newHealth <= 0 then
					alive = false
				end
			end)
		end

		local health_regenPool 	= 0
		local mana_regenPool 	= 0

		local playerData = playerDataContainer[player]

		spawn(function()
			while true do
				local delta = wait(1)

				if configuration.getConfigurationValue("server_doRedirectMaxHealthDeletions") and character.PrimaryPart and not character.PrimaryPart:FindFirstChild("maxHealth") then
					player:Kick("Anti-exploit")
	--				game:GetService("TeleportService"):Teleport(2376885433, player, nil, game.ReplicatedStorage.returnToLobby)
				end

				checkForRespawnPoint(player)

				if alive and character and character.PrimaryPart and player.Character == character and playerData and playerData.nonSerializeData then
					local isInCombat = (tick() - (playerData.nonSerializeData.lastTimeInCombat or 0)) <= 4
					local stats = playerData.nonSerializeData.statistics_final

					local multiplier_mana 	= 1
					local multiplier_health = 1

					local state = player.Character.PrimaryPart:FindFirstChild("state")

					if state and state.Value == "sitting" and player.Character.PrimaryPart.Anchored then
						multiplier_mana 	= multiplier_mana * 2
						multiplier_health 	= multiplier_health * 2
					end

					if isInCombat then
						multiplier_health 	= multiplier_health * 0
						multiplier_mana 	= multiplier_mana 	* 0.5
					end

					if state and state.Value == "dead" then
						multiplier_health = 0
						multiplier_mana = 0
					end

					local healthGainFromThisTick 	= stats.healthRegen * delta * multiplier_health * 0.5
					local healthGain 				= health_regenPool + healthGainFromThisTick
					local healthToGivePlayer 		= math.floor(healthGain)

					if healthToGivePlayer > 0 then
						character.PrimaryPart.health.Value = math.clamp(character.PrimaryPart.health.Value + healthToGivePlayer, 0, character.PrimaryPart.maxHealth.Value)
					end

					local manaGainFromThisTick 	= stats.manaRegen * delta * multiplier_mana * 0.5
					local manaGain 				= mana_regenPool + manaGainFromThisTick
					local manaToGivePlayer 		= math.floor(manaGain)

					if manaToGivePlayer > 0 then
						character.PrimaryPart.mana.Value = math.clamp(character.PrimaryPart.mana.Value + manaToGivePlayer, 0, character.PrimaryPart.maxMana.Value)
					end

					health_regenPool 	= healthGain - healthToGivePlayer
					mana_regenPool 		= manaGain - manaToGivePlayer
				else
					break
				end
			end
		end)

		-- when we stand on death traps, be... uh, death trapped.
		local manifest = character.PrimaryPart
		local deathTrapNext = 0
		local deathTrapTime = 1
		local collisionWiggle = Vector3.new(1, 1, 1) * 0.2
		local conn = nil
		local lastDeathTrap
		local function getDeathTrapKillMessage(part)
			local text = "☠ " .. player.Name .. " was killed by "..part.Name.." ☠"

			local message = part:FindFirstChild("message")
			if message then
				text = message.Value
				text = string.gsub(text, "%[playerName]", player.Name)
				text = string.gsub(text, "%[trapName]", part.Name)
				text = "☠ "..text.." ☠"
			end

			return text
		end
		local function applyDeathTrap(part, now)
			deathTrapNext = now + deathTrapTime

			if part:FindFirstChild("cooldown") then
				deathTrapNext = now + part.cooldown.Value
			end

			-- is this a status effect trap?
			if part:FindFirstChild("statusEffect") then
				local statusName = part.statusEffect.Value

				local function getArgs(object)
					local args = {}
					for _, child in pairs(object:GetChildren()) do
						if child:IsA("Folder") then
							args[child.Name] = getArgs(child)
						else
							args[child.Name] = child.Value
						end
					end
					return args
				end
				local args = getArgs(part.statusEffect)

				network:invoke(
					"applyStatusEffectToEntityManifest",
					manifest,
					statusName,
					args,
					manifest,
					"trap",
					0
				)

				-- drop a special tag so that the kill notification system knows what to say
				-- in the case where we "kill ourselves" and it was actually due to a trap
				local tag = Instance.new("StringValue")
				tag.Name = "deathTrapKillMessage"
				tag.Value = getDeathTrapKillMessage(part)
				tag.Parent = player
				game:GetService("Debris"):AddItem(tag, args.duration or 1)
			end

			-- how much damage?
			local damage
			if part:FindFirstChild("damage") then
				damage = part.damage.Value

			elseif part:FindFirstChild("percentDamage") then
				local maxHealth = manifest:FindFirstChild("maxHealth")
				if maxHealth then
					damage = maxHealth.Value * part.percentDamage.Value
				end
			end

			if damage then
				local health = manifest:FindFirstChild("health")
				if not health then return end
				if health.Value <= 0 then return end

				health.Value = math.max(0, health.Value - damage)

				-- play a sound
				local injurySound = Instance.new("Sound")
				injurySound.SoundId = "rbxassetid://2065833626"
				injurySound.MaxDistance = 1000
				injurySound.Volume = 1.5
				injurySound.EmitterSize = 5
				injurySound.Parent = manifest
				injurySound:Play()
				game:GetService("Debris"):AddItem(injurySound, injurySound.TimeLength)

				-- potentially show a message
				if health.Value <= 0 then
					network:fireAllClients("signal_alertChatMessage", {
						Text = getDeathTrapKillMessage(part),
						Font = Enum.Font.SourceSansBold,
						Color = Color3.fromRGB(255, 130, 100),
					})
				end
			end

			-- any knockback?
			if part:FindFirstChild("knockback") then
				--"deathTrapKnockback"
				local nearestPoint = detection.projection_Box(part.CFrame, part.Size, manifest.Position)
				local delta = manifest.Position - nearestPoint
				network:fireClient("deathTrapKnockback", player, delta.Unit * part.knockback.Value)
			end
		end
		local function getIsTouchingDeathTrap(part)
			-- fast distance check
			local delta = manifest.Position - part.Position
			local manhattan = math.max(math.abs(delta.X), math.abs(delta.Y), math.abs(delta.Z))
			local range = math.max(part.Size.X, part.Size.Y, part.Size.Z)
			if manhattan > range then return false end

			-- slower collision check
			-- we need to add a bit to the top and bottom of our character because the
			-- hit box as it exists now doesn't fully cover the head and feet
			local charCFrame = manifest.CFrame
			local charSize = manifest.Size + collisionWiggle + Vector3.new(0, 2, 0)
			local castPosition = detection.projection_Box(charCFrame, charSize, part.Position)
			if not detection.boxcast_singleTarget(part.CFrame, part.Size, castPosition) then return false end

			return true
		end
		local function checkDeathTrap(part, now)
			if not getIsTouchingDeathTrap(part) then return end

			if part:FindFirstChild("reference") then
				part = part.reference.Value
				if not part then return end
			end

			lastDeathTrap = part

			if part:FindFirstChild("onTouched") then
				part = part.onTouched
			end

			applyDeathTrap(part, now)
		end
		local function checkForOnTouchEnded(part)
			if getIsTouchingDeathTrap(part) then return end

			local part = lastDeathTrap
			lastDeathTrap = nil

			if part:FindFirstChild("onTouchEnded") then
				applyDeathTrap(part.onTouchEnded, tick())
			end
		end
		local function checkForDeathTraps()
			if (not manifest.Parent) or (manifest.Parent ~= player.Character) then
				conn:Disconnect()
			end

			if lastDeathTrap then
				checkForOnTouchEnded(lastDeathTrap)
			end

			local now = tick()
			if now < deathTrapNext then return end

			local origin = manifest.Position - Vector3.new(0, manifest.Size.Y / 2, 0)
			local direction = Vector3.new(0, -2, 0)
			local parts = collectionService:GetTagged("deathTrap")

			for _, part in pairs(parts) do
				local hitATrap = checkDeathTrap(part, now)

				if hitATrap then
					break
				end
			end
		end
		conn = runService.Heartbeat:Connect(checkForDeathTraps)

		physics:setWholeCollisionGroup(character, "characters")

		local entity = character.PrimaryPart
		--[[
		entity:WaitForChild("state")

		while character and character.Parent do
			if entity.state.Value == "sprinting" then
				entity.stamina.Value = math.max(entity.stamina.Value - 0.2, 0)
			elseif entity.stamina.Value < entity.maxStamina.Value then
				entity.stamina.Value = math.min(entity.stamina.Value + 0.2, entity.maxStamina.Value)
			end
			wait(0.2)
		end

		]]
--		if player:FindFirstChild("developer") then
--			script.adminUI:Clone().Parent = player.PlayerGui
--		end
	end
end

network:create("deathTrapKnockback", "RemoteEvent")

local function forceCharacterPosition(player, cf)
	if player.Character and player.Character.PrimaryPart then
		player.Character:SetPrimaryPartCFrame(cf)
	end
end

network:create("serverVerifyCharacterPosition", "RemoteEvent", "OnServerEvent", forceCharacterPosition)

local function onClientRequestFlushPropogationCache(client)
	if not playerDataContainer[client] then
		while not playerDataContainer[client] do
			wait()
		end
	end

	if playerDataContainer[client] then
		local propogationCacheLookupTable = {}
		for propogationNameTag, propogationValue in pairs(playerDataContainer[client]) do
			--if propogationNameTag ~= "nonSerializeData" then
				propogationCacheLookupTable[propogationNameTag] = propogationValue
			--end
		end

		network:fireClient("clientFlushPropogationCache", client, propogationCacheLookupTable)
	end
end

local function replicatePlayerCharacterAppearance(player, playerData)
	playerData = playerData or playerDataContainer[player]

	if playerData then
		local characterAppearanceData = {}
			characterAppearanceData.equipment 			= playerData.equipment
			characterAppearanceData.accessories 		= playerData.accessories
			characterAppearanceData.temporaryEquipment 	= playerData.nonSerializeData.temporaryEquipment

		if player.Character and player.Character.PrimaryPart then
			player.Character.PrimaryPart.appearance.Value = httpService:JSONEncode(characterAppearanceData)
		end
	end
end

local function onPlayerRequest_equipTemporaryEquipment(player, temporaryEquipmentModel)
	local playerData = playerDataContainer[player]

	if playerData then
		if temporaryEquipmentModel and temporaryEquipmentModel:IsDescendantOf(temporaryEquipmentFolder) then
			if not playerData.nonSerializeData.temporaryEquipment[temporaryEquipmentModel.Name] then
				playerData.nonSerializeData.temporaryEquipment[temporaryEquipmentModel.Name] = true

				-- force update player appearance
				replicatePlayerCharacterAppearance(player, playerData)

				return true
			end
		end
	end

	return false
end

local function replicatePlayerCharacterActiveStatusEffects(player, playerData)
	if player:FindFirstChild("entityGUID") then
		network:invoke("updateStatusEffectsForEntityManifestByEntityGUID", player.entityGUID.Value)
	end
end

local function getPropogationCacheLookupTable(client)
	if game.PlaceId == 2376885433 or game.PlaceId == 3323943158 or game.PlaceId == 2015602902 then
		return {}
	end

	if not playerDataContainer[client] then
		while not playerDataContainer[client] do
			wait()
		end
	end

	local propogationCacheLookupTable = {}
	for propogationNameTag, propogationValue in pairs(playerDataContainer[client]) do
		--if propogationNameTag ~= "nonSerializeData" then
			propogationCacheLookupTable[propogationNameTag] = propogationValue
		--end
	end

	return propogationCacheLookupTable
end

local function onClientRequestPropogateCacheData(client, propogationNameTag)
	if not playerDataContainer[client] then
		while not playerDataContainer[client] do
			wait(0.1)
		end
	end

	if playerDataContainer[client] then
		network:fireClient("propogateCacheDataRequest", client, propogationNameTag, playerDataContainer[client][propogationNameTag])
	end
end

local function getAvailableSlot(slots)
	for slotId, isSlotOpen in pairs(slots) do
		if isSlotOpen then
			return slotId
		end
	end

	return nil
end

local function validateEquipmentSlots(playerEquipment)
	-- iterate through playerEquipment and make sure its all good
	while true do
		local hasMadeChange = false

		for i, equipmentSlotData in pairs(playerEquipment) do
			local itemBaseData = itemLookup[equipmentSlotData.id]

			if itemBaseData.equipmentSlot ~= equipmentSlotData.position then
				hasMadeChange = true

				table.remove(playerEquipment, i)

				break
			end
		end

		if not hasMadeChange then
			break
		end
	end
end

-- validates and builds intermediate transfer data
-- second return is true IF AND ONLY IF the player is missing the
-- items stipulated
local function int__getInventoryTransferData_intermediateCollectionFromInventoryTransferDataCollection(player, inventoryTransferDataCollection)
	local playerData = playerDataContainer[player]

	if playerData then
		local inventoryTransferData_intermediateCollection 	= {}
		local wasInventoryTransferDataModified 				= false
		local isDataMalformed 								= false
		local successful_conversions 						= 0

		local inventoryTransferDataCollection_list = utilities.copyTable(inventoryTransferDataCollection)

		for i, inventoryTransferData in pairs(inventoryTransferDataCollection_list) do
			local itemBaseData = itemLookup[inventoryTransferData.id]

			if itemBaseData and (inventoryTransferData.stacks or 1) > 0 then
				for trueInventorySlotPosition, inventorySlotData in pairs(playerData.inventory) do
					if inventorySlotData.id == inventoryTransferData.id then
						if itemBaseData.canStack then
							if inventoryTransferData.stacks > 0 then
								local stacksToRemove = math.clamp(inventoryTransferData.stacks, 1, inventorySlotData.stacks or 1)

								local inventoryTransferData_intermediate = {}
									inventoryTransferData_intermediate.id 		= inventoryTransferData.id
									inventoryTransferData_intermediate.position = inventorySlotData.position

								-- copy over the item metadata
								for metadataName, metadataValue in pairs(inventorySlotData) do
									if not inventoryTransferData_intermediate[metadataName] then
										if type(metadataValue) == "table" then
											inventoryTransferData_intermediate[metadataName] = utilities.copyTable(metadataValue)
										else
											inventoryTransferData_intermediate[metadataName] = metadataValue
										end
									end
								end

								inventoryTransferData_intermediate.stacks = stacksToRemove

								-- flag this as taken!
								inventoryTransferData.stacks = inventoryTransferData.stacks - stacksToRemove

								table.insert(inventoryTransferData_intermediateCollection, inventoryTransferData_intermediate)

								if inventoryTransferData.stacks == 0 then
									break
								end
							end
						else
							if inventorySlotData.position == inventoryTransferData.position then
								local inventoryTransferData_intermediate = {}
									inventoryTransferData_intermediate.id 		= inventoryTransferData.id
									inventoryTransferData_intermediate.position = inventoryTransferData.position

								-- copy over the item metadata
								for metadataName, metadataValue in pairs(inventorySlotData) do
									if not inventoryTransferData_intermediate[metadataName] then
										if type(metadataValue) == "table" then
											inventoryTransferData_intermediate[metadataName] = utilities.copyTable(metadataValue)
										else
											inventoryTransferData_intermediate[metadataName] = metadataValue
										end
									end
								end

								table.insert(inventoryTransferData_intermediateCollection, inventoryTransferData_intermediate)

								-- flag this as taken!
								inventoryTransferData.stacks = 0

								break
							end
						end
					end
				end

				--  [{"position":2,"stacks":1,"id":3}, {"position":1,"stacks":1,"id":8}, {"position":1,"stacks":1,"id":3}]
				if inventoryTransferData.stacks == 0 then
					-- pop it from the table, its all good
					-- table.remove(inventoryTransferDataCollection_list, i)
				else
					-- didn't get all the stacks for this item! deny it.
					break
				end
			else
				-- invalid item, either stacks <= 0 or id is invalid
				break
			end
		end

		local isGood = true
		for i, v in pairs(inventoryTransferDataCollection_list) do
			if (v.stacks or 1) > 0 then
				isGood = false
			end
		end

		-- if everything went well, #inventoryTransferDataCollection_list == 0
		-- this function returns true in arg#2 if there was an error
		return inventoryTransferData_intermediateCollection, not isGood--#inventoryTransferDataCollection_list > 0 --successful_conversions ~= #inventoryTransferDataCollection or isDataMalformed or wasInventoryTransferDataModified
	end

	return nil, true
end

-- CONTINUE NPC TRADING HERE!!!!!!
local function int__doesPlayerHaveInventorySpaceForTrade(player, inventoryTransferData_intermediateCollection_losing, inventoryTransferData_intermediateCollection_gaining)
	-- reminder: respect category
	local availableSlots = {}
	local necessarySlots = {}

	for i_category = 1, #CATEGORIES do
		availableSlots[CATEGORIES[i_category]] = MAX_NUMBER_SLOTS_PER_CATEGORY
	end

	local playerData = playerDataContainer[player]
	if playerData then
		for trueInventorySlotDataPosition, inventorySlotData in pairs(playerData.inventory) do
			local itemBaseData = itemLookup[inventorySlotData.id]

			if itemBaseData then
				availableSlots[itemBaseData.category] = availableSlots[itemBaseData.category] - 1
			else
				return false
			end
		end
	end

	for i, inventoryTransferData_intermediate in pairs(inventoryTransferData_intermediateCollection_losing) do
		local itemBaseData = itemLookup[inventoryTransferData_intermediate.id]

		if itemBaseData then
			availableSlots[itemBaseData.category] = availableSlots[itemBaseData.category] + 1
		else
			return false
		end
	end

	local representation_inventoryTransferData_intermediateCollection_gaining = utilities.copyTable(inventoryTransferData_intermediateCollection_gaining)
	local playerInventoryClone = utilities.copyTable(playerData.inventory)

	while true do
		local madeChange = false

		for i, inventoryTransferData_intermediate in pairs(representation_inventoryTransferData_intermediateCollection_gaining) do
			local itemBaseData = itemLookup[inventoryTransferData_intermediate.id]

			if not inventoryTransferData_intermediate.stacks then
				inventoryTransferData_intermediate.stacks = 1
			end

			if itemBaseData then
				if itemBaseData.canStack then
					for _, playerInventorySlotData in pairs(playerInventoryClone) do
						if playerInventorySlotData.id == inventoryTransferData_intermediate.id and playerInventorySlotData.stacks <= (itemBaseData.stackSize or MAX_COUNT_PER_STACK) then
							local stacksToAdd = math.clamp(inventoryTransferData_intermediate.stacks, 0, (itemBaseData.stackSize or MAX_COUNT_PER_STACK) - playerInventorySlotData.stacks)

							inventoryTransferData_intermediate.stacks 	= inventoryTransferData_intermediate.stacks - stacksToAdd
							playerInventorySlotData.stacks 				= playerInventorySlotData.stacks + stacksToAdd

							if inventoryTransferData_intermediate.stacks == 0 then
								table.remove(representation_inventoryTransferData_intermediateCollection_gaining, i)

								madeChange = true

								break
							end
						end
					end
				end
			end

			if madeChange then
				break
			end
		end

		if not madeChange then
			break
		end
	end

	for i, inventoryTransferData_intermediate in pairs(representation_inventoryTransferData_intermediateCollection_gaining) do
		local itemBaseData = itemLookup[inventoryTransferData_intermediate.id]

		if itemBaseData then
			if itemBaseData.canStack then
				availableSlots[itemBaseData.category] = availableSlots[itemBaseData.category] - 1
			else
				availableSlots[itemBaseData.category] = availableSlots[itemBaseData.category] - inventoryTransferData_intermediate.stacks
			end

			necessarySlots[itemBaseData.category] = true
		else
			return false
		end
	end

	-- check if player can do the trade based on their slots!
	for category, _ in pairs(necessarySlots) do
		-- NOTE: we are not doing <= 0 because if we do, it doesn't
		-- acount for the scenario where we are at 24 slots available
		-- and gaining 1 item. if we have all items full, and only gain 1
		-- itll be -1 so it wont pass through.
		if availableSlots[category] < 0 then
			return false
		end
	end

	return true
end

-- todo: merge into already present stacks!
local function grantPlayerItemsByInventoryTranferData_intermediateCollection(player, inventoryTransferDataCollection_g)
	local playerData = playerDataContainer[player]
	local inventoryTransferDataCollection = utilities.copyTable(inventoryTransferDataCollection_g)

	if playerData then
		local hasInventoryChanged = false

		for i, inventoryTransferData in pairs(inventoryTransferDataCollection) do
			local itemBaseData = itemLookup[inventoryTransferData.id]

			-- set this for the lazy
			if not inventoryTransferData.stacks then
				inventoryTransferData.stacks = 1
			end

			if itemBaseData and itemBaseData.canStack then
				for trueInventorySlotDataPosition, inventorySlotData in pairs(playerData.inventory) do
					if inventorySlotData.id == inventoryTransferData.id then
						if (inventorySlotData.stacks + inventoryTransferData.stacks) <= (itemBaseData.stackSize or MAX_COUNT_PER_STACK) then
							inventorySlotData.stacks = inventorySlotData.stacks + inventoryTransferData.stacks

							network:fire("questTriggerOccurred", player, "item-collected", {id = itemBaseData.id; amount = 1}) -- amount is irrelevant to the check
							-- flag as finished item
							inventoryTransferData.stacks = 0

							-- flag as changed!
							hasInventoryChanged = true

							-- move to next item!
							break
						elseif inventorySlotData.stacks < (itemBaseData.stackSize or MAX_COUNT_PER_STACK) then
							local diff = (itemBaseData.stackSize or MAX_COUNT_PER_STACK) - inventorySlotData.stacks

							if inventoryTransferData.stacks >= diff then
								inventorySlotData.stacks 		= inventorySlotData.stacks + diff
								inventoryTransferData.stacks 	= inventoryTransferData.stacks - diff


								hasInventoryChanged = true

								if inventoryTransferData.stacks == 0 then
									network:fire("questTriggerOccurred", player, "item-collected", {id = itemBaseData.id; amount = 1})
									break
								end
							end
						end
					end
				end
			end
		end

		for _, inventoryTransferData in pairs(inventoryTransferDataCollection) do
			if inventoryTransferData.stacks > 0 then
				-- grant the item
				local itemBaseData = itemLookup[inventoryTransferData.id]

				if itemBaseData then
					-- make sure the id is the integer id, not the string id
					inventoryTransferData.id = itemBaseData.id


					if itemBaseData.canStack then
						local itemStackSize = itemBaseData.stackSize or 99
						local stacksNeeded 	= inventoryTransferData.stacks

						while stacksNeeded > 0 do
							if stacksNeeded >= itemStackSize then
								local itemToAdd 	= utilities.copyTable(inventoryTransferData)
								itemToAdd.stacks 	= itemStackSize
								stacksNeeded 		= stacksNeeded - itemStackSize

								table.insert(playerData.inventory, itemToAdd)
							else
								local itemToAdd 	= utilities.copyTable(inventoryTransferData)
								itemToAdd.stacks 	= stacksNeeded
								stacksNeeded 		= 0
								table.insert(playerData.inventory, itemToAdd)
							end
						end

						inventoryTransferData.stacks = 0

						network:fire("questTriggerOccurred", player, "item-collected", {id = itemBaseData.id; amount = 1})
						-- flip flag
						hasInventoryChanged = true
					else
						-- todo look to remove this for loop!
						for i = 1, inventoryTransferData.stacks or 1 do
							local newInventorySlotData = {
								id 				= inventoryTransferData.id;
								stacks 			= 1;
								modifierData 	= inventoryTransferData.modifierData;
							}

							for i, v in pairs(inventoryTransferData) do
								if not newInventorySlotData[i] then
									if type(v) == "table" then
										newInventorySlotData[i] = utilities.copyTable(v)
									elseif i ~= "stacks" then
										newInventorySlotData[i] = v
									end
								end
							end

							table.insert(playerData.inventory, newInventorySlotData)
							network:fire("questTriggerOccurred", player, "item-collected", {id = itemBaseData.id; amount = 1})
							-- flip flag
							hasInventoryChanged = true
						end
					end
				end
			end
		end

		if hasInventoryChanged then
			playerData.nonSerializeData.playerDataChanged:Fire("inventory")
		end

		return true
	end

	return false
end

-- reminder: inventoryTransferData and inventoryTransferData_intermediate can both be used. Since we don't care about modifierData
-- they're pretty much identical.
local function revokePlayerItemsByInventoryTransferDataCollection(player, inventoryTransferDataCollection_r)
	local playerData = playerDataContainer[player]
	local inventoryTransferDataCollection = utilities.copyTable(inventoryTransferDataCollection_r)

	if playerData then
		local hasInventoryChanged = false

		for _, inventoryTransferData in pairs(inventoryTransferDataCollection) do
			local itemBaseData = itemLookup[inventoryTransferData.id]

			-- set this for the lazy
			if not inventoryTransferData.stacks then
				inventoryTransferData.stacks = 1
			end

			if itemBaseData and itemBaseData.canStack then
				while inventoryTransferData.stacks > 0 do
					local tookStacksThisCycle = false

					for trueInventorySlotPosition, inventorySlotData in pairs(playerData.inventory) do
						if inventorySlotData.id == inventoryTransferData.id then
							-- drop the item
							if inventorySlotData.stacks > inventoryTransferData.stacks then
								inventorySlotData.stacks 		= inventorySlotData.stacks - inventoryTransferData.stacks
								inventoryTransferData.stacks 	= 0
							else
								inventoryTransferData.stacks = inventoryTransferData.stacks - inventorySlotData.stacks

								table.remove(playerData.inventory, trueInventorySlotPosition)
							end

							-- flip flag
							hasInventoryChanged = true
							tookStacksThisCycle = true

							break
						end
					end

					if not tookStacksThisCycle then
						break
					end
				end
			else
				-- non-stackable item revoke, only one stack (entire item)
				inventoryTransferData.stacks = 1

				for trueInventorySlotPosition, inventorySlotData in pairs(playerData.inventory) do
					if inventorySlotData.position == inventoryTransferData.position and inventorySlotData.id == inventoryTransferData.id then
						-- revoke item
						table.remove(playerData.inventory, trueInventorySlotPosition)

						-- flag is taken
						inventoryTransferData.stacks = 0

						-- mark as changed
						hasInventoryChanged = true

						-- move to next item
						break
					end
				end
			end
		end

		if hasInventoryChanged then
			playerData.nonSerializeData.playerDataChanged:Fire("inventory")
		end

		return true
	end

	return false
end

local function int__transferInventoryToStorage(player, inventorySlotData)
	local playerData = playerDataContainer[player]

	if playerData then
		local inventoryTransferData_intermediateCollection_player, wasInventoryTransferDataModified_player 	= int__getInventoryTransferData_intermediateCollectionFromInventoryTransferDataCollection(player, {inventorySlotData})

		if not wasInventoryTransferDataModified_player then
			for i, inventoryTransferData in pairs(inventoryTransferData_intermediateCollection_player) do
				local itemBaseData = itemLookup[inventoryTransferData.id]
				if inventoryTransferData.questBound or (itemBaseData and itemBaseData.questBound) then
					return false, "Item is quest bound"
				end
			end

			revokePlayerItemsByInventoryTransferDataCollection(player, inventoryTransferData_intermediateCollection_player)

			local copy_inventoryTransferData_intermediateCollection_player = utilities.copyTable(inventoryTransferData_intermediateCollection_player)

			-- merge itemStorage stacks if possible
			while true do
				local hasChanged = false
				for i, inventoryTransferData in pairs(copy_inventoryTransferData_intermediateCollection_player) do
					local itemBaseData = itemLookup[inventoryTransferData.id]

					if itemBaseData.canStack then
						for ii, itemStorageSlotData in pairs(playerData.globalData.itemStorage) do
							local maxStackSizeForItem = itemBaseData.stackSize or MAX_COUNT_PER_STACK

							if inventoryTransferData.id == itemStorageSlotData.id and itemStorageSlotData.stacks < maxStackSizeForItem then
								local amountFromMaxStacks = (itemStorageSlotData.stacks + inventoryTransferData.stacks) - maxStackSizeForItem

								if amountFromMaxStacks > 0 then
									-- this is all overflow
									itemStorageSlotData.stacks 		= amountFromMaxStacks
									inventoryTransferData.stacks 	= maxStackSizeForItem
								else
									-- this is all underflow, so it merged completely.
									itemStorageSlotData.stacks 		= itemStorageSlotData.stacks + inventoryTransferData.stacks
									inventoryTransferData.stacks 	= 0

									table.remove(copy_inventoryTransferData_intermediateCollection_player, i)

									hasChanged = true

									break
								end
							end
						end
					end

					if hasChanged then
						break
					end
				end

				if not hasChanged then
					break
				end
			end

			for i, itemSlotData in pairs(copy_inventoryTransferData_intermediateCollection_player) do
				table.insert(playerData.globalData.itemStorage, itemSlotData)
			end

			playerData.nonSerializeData.playerDataChanged:Fire("inventory")
			playerData.nonSerializeData.playerDataChanged:Fire("globalData")

			return true, "Successfully transfered to storage."
		else
			return false, "Failed find item."
		end
	end

	return false, "PlayerData not found."
end

local function int__transferStorageToInventory(player, storageSlotData)
	local playerData = playerDataContainer[player]

	if playerData then
		local player_hasInventorySpace = int__doesPlayerHaveInventorySpaceForTrade(player, {}, {storageSlotData})

		if player_hasInventorySpace then
			local wasStorageSlotDataRemoved, removeSlotData = false, nil do
				for i, storageSlot in pairs(playerData.globalData.itemStorage) do
					if storageSlot.id == storageSlotData.id and i == storageSlotData.position then
						removeSlotData 				= table.remove(playerData.globalData.itemStorage, i)
						wasStorageSlotDataRemoved 	= true
					end
				end
			end

			if wasStorageSlotDataRemoved then
				table.insert(playerData.inventory, removeSlotData)

				playerData.nonSerializeData.playerDataChanged:Fire("inventory")
				playerData.nonSerializeData.playerDataChanged:Fire("globalData")

				return true, "Successfully transfered to inventory."
			else
				return false, "Failed to find in storage."
			end
		else
			return false, "Player does not have space in inventory."
		end
	end

	return false, "PlayerData not found."
end

local function updateInventorySlots(player)
	local playerData = playerDataContainer[player]

	if playerData then
		local availableSlots = {}

		for i_category = 1, #CATEGORIES do
			availableSlots[CATEGORIES[i_category]] = {}
			for i_slot = 1, MAX_NUMBER_SLOTS_PER_CATEGORY do
				availableSlots[CATEGORIES[i_category]][i_slot] = true
			end
		end

		for i, inventorySlotData in pairs(playerData.inventory) do
			local itemBaseData = itemLookup[inventorySlotData.id]
			if itemBaseData then
				-- make sure the slots have stacks value
				if not inventorySlotData.stacks then
					inventorySlotData.stacks = 1
				end

				-- TEMP DISABLED WHILE CONVERTING OLD STACK SIZES TO NEW ONES
				-- make sure the slots are at their valid stack value and reset if not
				--if inventorySlotData.stacks >= (itemBaseData.stackSize or MAX_COUNT_PER_STACK) then
				--	inventorySlotData.stacks = itemBaseData.stackSize or MAX_COUNT_PER_STACK
				--end

				if availableSlots[itemBaseData.category] then
					if inventorySlotData.position and availableSlots[itemBaseData.category][inventorySlotData.position] then
						availableSlots[itemBaseData.category][inventorySlotData.position] = false
					elseif inventorySlotData.position then
						-- item trying to take up same category+position as another item
						-- reset its position
						inventorySlotData.position = nil
					end
				else
					-- item with no category, kick it to the curb
					table.remove(playerData.inventory, i)
				end
			else
				-- no itemBaseData, kick it to the curb
				table.remove(playerData.inventory, i)
			end
		end

		local storageTransferItems = {}

		-- so gross we have to do this cus tables dont autoscale
		while true do
			local madeChange = false
			for i, inventorySlotData in pairs(playerData.inventory) do
				if not inventorySlotData.position then
					-- find a slot for this
					local itemBaseData 	= itemLookup[inventorySlotData.id]
					local slot 			= getAvailableSlot(availableSlots[itemBaseData.category])

					if slot then
						inventorySlotData.position = slot
						availableSlots[itemBaseData.category][slot] = false
					else
						-- no open slot, kick it to the curb
						warn("moving item to storage due to lack of inv space")

						local success, reason = int__transferInventoryToStorage(player, inventorySlotData)
						warn("INV->STOR", success, reason)

						if not success then
							table.remove(playerData.inventory, i)
							warn("taking out and wiping it")
						end

						madeChange = true

						break
					end
				end
			end

			if not madeChange then
				break
			end
		end

		-- try to ensure that stuff is gotten to in order
		-- if a.position and b.position then
			-- ^ fix for https://forum.playvesteria.com/t/game-breaking-glitch/2991
		table.sort(playerData.inventory, function(a, b)
			if a.position and b.position then
				return a.position > b.position
			end

			-- default
			return false
		end)
	end
end

-- true 	= its completed
-- false 	= its being worked on
-- nil 		= not assigned

local STAT_POINTS_GAINED_PER_LEVEL = 2

local function autoSavePlayerData(player)
	if player.Parent ~= game.Players or player:FindFirstChild("DataLoaded") == nil or player:FindFirstChild("teleporting") or playerDataContainer[player] == nil then
		return false
	end

	-- autosave ongoing statusEffects
	if player:FindFirstChild("entityGUID") then
		local statusEffects = network:invoke("playerRemovingPackageStatusEffects", player)

		if statusEffects then
			playerDataContainer[player].packagedStatusEffects = statusEffects
		end
	end

	local playerId = player.userId

	local Success, Error, TimeStamp = datastoreInterface:updatePlayerSaveFileData(playerId, playerDataContainer[player])
	if Success then
		if player:FindFirstChild("DataSaveFailed") then
			player.DataSaveFailed:Destroy()
		end
	else
		warn(player.Name,"'s data failed to save.",Error)
		network:invoke("reportError", player, "error", "Failed to save player data: "..Error)
		network:invoke("reportAnalyticsEvent",player,"data:fail:save")
		if player:FindFirstChild("DataSaveFailed") == nil then
			local tag = Instance.new("BoolValue")
			tag.Name = "DataSaveFailed"
			tag.Parent = player
		end
		network:fireClient("alertPlayerNotification", player, {text = "Failed to save data: "..Error; textColor3 = Color3.fromRGB(255, 57, 60)})
	end

	-- get rid of packagedstatuseffects
	if playerDataContainer[player] then
		playerDataContainer[player].packagedStatusEffects = nil
	end

	return Success, TimeStamp
end

local playerStatTypes = {"dex", "int", "vit", "str"}

local function VALIDATE_SECTION_FOR_CHEAT_WEAPONS(section, holding)
	local enchantmentMapping ={
		["0.05"] = 1.0;
		["0.075"] = 0.7;
		["0.1"] = 0.1;
	}

	for i, inventorySlotData in pairs(section) do
		local weaponEnchantmentSuccess 	= 1
		local hasUnrealisticIncrease 	= false
		if inventorySlotData.successfulUpgrades and inventorySlotData.successfulUpgrades > 0 then
			local itemBaseData = itemLookup[inventorySlotData.id]
			if itemBaseData.baseDamage then
				for ii, modifierData in pairs(inventorySlotData.modifierData) do
					if modifierData.baseDamage then
						local percentIncrease = tostring(math.floor(modifierData.baseDamage / itemBaseData.baseDamage / 0.025) * 0.025)
						if enchantmentMapping[percentIncrease] then
							weaponEnchantmentSuccess = weaponEnchantmentSuccess * enchantmentMapping[percentIncrease]
						else
							warn(inventorySlotData.id, "@", inventorySlotData.position, "has weird scaling (", percentIncrease,"% increase)", modifierData.baseDamage, "baseDamage increase")

							--hasUnrealisticIncrease = true
						end
					end
				end
			end
		end

		if weaponEnchantmentSuccess * 100 <= 0.5 or hasUnrealisticIncrease then
			table.remove(section, i)
			table.insert(holding, inventorySlotData)

			warn("id", inventorySlotData.id, "@", inventorySlotData.position, "was revoked", "(" .. weaponEnchantmentSuccess * 100 .. "%)")
		end
	end
end

local function completelyNukeSaveFile(player, playerData)
	playerData.level 		= 1
	playerData.exp 			= 0
	playerData.equipment 	= {}
	playerData.inventory 	= {}
	playerData.abilities 	= {}
	playerData.abilityBooks = {}
	playerData.statistics 	= {}
	playerData.gold 		= 0
	playerData.class 		= "Adventurer"
end

local function onLogPerkActivation_server(player, equipmentId)
	local playerData = playerDataContainer[player]

	if playerData then
		playerData.nonSerializeData.perksActivated[tostring(equipmentId)] = tick()
	end
end

network:create("logPerkActivation_server", "BindableEvent", "Event", onLogPerkActivation_server)

local function flagCheck(player, playerData)
--	if not playerData.flags.referralCheck then
--		if (playerData.globalData.referrals or 0) >= 50 or playerData.globalData.doWipeReferrals then
--			warn("WIPING DUE TO REFERRALS")
--
--			local referrals = playerData.globalData.referrals
--
--			playerData.globalData.referrals 		= 0
--			playerData.globalData.doWipeReferrals 	= true
--
--			completelyNukeSaveFile(player, playerData)
--
--			spawn(function()
--				local Error = "A user ("..player.Name..") had their data wiped for having "..tostring(referrals).." referrals"
--				network:invoke("reportError", player, "debug", Error)
--				network:fireClient("signal_alertChatMessage", player, {Text = "Your data was wiped for abusing a referral exploit."; Font = Enum.Font.SourceSansBold; Color = Color3.fromRGB(255, 0, 0)} )
--			end)
--		end
--
--		playerData.flags.referralCheck = true
--	end

	if not playerData.flags.arrowChangeXD then
		playerData.flags.arrowChangeXD = true

		local trueEquip do
			for i, equip in pairs(playerData.equipment) do
				if equip.position == mapping.equipmentPosition.arrow then
					trueEquip = equip
				end
			end
		end

		if trueEquip and trueEquip.id == nil then
			trueEquip.id = 87
		elseif not trueEquip then
			table.insert(playerData.equipment, {
				id 			= 87;
				position 	= mapping.equipmentPosition.arrow;
				stacks 		= 0;
			})
		end
	end


	if not playerData.flags.abilityReset then
		playerData.flags.abilityReset = true
		if game.PlaceId ~= 2103419922 then
			playerData.abilities = {}

			for abilityBookName, abilityBookPlayerData in pairs(playerData.abilityBooks) do
				abilityBookPlayerData.pointsAssigned = 0
			end

			while true do
				local madeChange = false

				for i, hotbarAbilityData in pairs(playerData.hotbar) do
					if hotbarAbilityData.dataType == mapping.dataType.ability then
						madeChange = true

						table.remove(playerData.hotbar, i)

						break
					end
				end

				if not madeChange then
					break
				end
			end

			playerData.statistics.dex = 0
			playerData.statistics.int = 0
			playerData.statistics.str = 0
			playerData.statistics.vit = 0
		end

	end

	if not playerData.flags.fixNightmareChickensEXPandInfinitePetPickup then
		playerData.flags.fixNightmareChickensEXPandInfinitePetPickup = true

		if playerData.gold > 25000000 and not runService:IsStudio() then
			playerData.gold = 0
		end

		if playerData.level == 30 or playerData.exp > levels.getEXPToNextLevel(playerData.level) then
			playerData.exp = 0
		end
	end

	if not playerData.flags.statCheck then
		local needsReset = false
		local statSum = 0

		-- check individual stats
		for i, statName in pairs(playerStatTypes) do
			local stat = playerData.statistics[statName] or 0
			statSum = statSum + math.abs(stat)
		end

		if statSum > levels.getStatPointsForLevel(playerData.level or 1) then
			needsReset = true
		end

		playerData.flags.statCheck = true

		-- wipe stats if bad
		if needsReset then
			for i, statName in pairs(playerStatTypes) do
				playerData.statistics[statName] = 0
			end
			addSuspicion(player, 200)
		end
	end

	if not playerData.flags.resetQuests then
		playerData.flags.resetQuests = true

		playerData.quests = {}
			playerData.quests.completed = {} --playerSaveFileData.quests.completed or {}
			playerData.quests.active 	= {} --playerSaveFileData.quests.active or {}
	end

	if configuration.getConfigurationValue("doStartRevokingCheatWeapons") then
		if not playerData.flags.revokeCheatWeapons then
			playerData.flags.revokeCheatWeapons = true
			playerData.holding 					= {}

			VALIDATE_SECTION_FOR_CHEAT_WEAPONS(playerData.inventory, playerData.holding)
			VALIDATE_SECTION_FOR_CHEAT_WEAPONS(playerData.equipment, playerData.holding)
		end
	end

--	if (playerData.class == "Hunter" or playerData.class == "Warrior") and not playerData.flags.resetAbilityBookPoints1 then
--		playerData.flags.resetAbilityBookPoints1 = true
--
--
--	end

	if not playerData.flags.resetStatPointsForV23 then
		playerData.flags.resetStatPointsForV23 = true

		playerData.statistics.dex = 0
		playerData.statistics.int = 0
		playerData.statistics.str = 0
		playerData.statistics.vit = 0
	end

	if not playerData.flags.removeSpiderQueenCrown then
		playerData.flags.removeSpiderQueenCrown = true

		for i, inventorySlotData in pairs(playerData.inventory) do
			if inventorySlotData.id == 68 then
				table.remove(playerData.inventory, i)
			end
		end

		for i, equipmentSlotData in pairs(playerData.equipment) do
			if equipmentSlotData.id == 68 then
				table.remove(playerData.equipment, i)
			end
		end
	end
end

network:create("playerDataLoaded", "BindableEvent")

local function onGetPlayerEquipmentDataByEquipmentPosition(player, equipmentPosition)
	if playerDataContainer[player] then
		for i, equipmentData in pairs(playerDataContainer[player].equipment) do
			if equipmentData.position == equipmentPosition then
				return equipmentData
			end
		end
	end

	return nil
end

-- local function grantPlayerAbilityBook(player, abilityBook)
-- 	local playerData = playerDataContainer[player]

-- 	if playerData then

-- 		abilityBook = string.lower(abilityBook)
-- 		if not playerData.abilityBooks[abilityBook] and abilityBookLookup[abilityBook] then

-- 			local abilityBookData = {}
-- 				abilityBookData.pointsAssigned = 0

-- 			playerData.abilityBooks[abilityBook] = abilityBookData

-- 			-- let the game know we changed abilities
-- 			playerData.nonSerializeData.playerDataChanged:Fire("abilityBooks")

-- 			return true, "successfully granted"
-- 		else
-- 			if playerData.abilityBooks[abilityBook] then
-- 				return false, "already has book"
-- 			else
-- 				return false, "invalid book"
-- 			end
-- 		end
-- 	end

-- 	return false, "invalid playerData"
-- end

-- couldn't find a better place to put this
-- spawn point logic
local spawnPoints = Instance.new("Folder")
spawnPoints.Name = "spawnPoints"

local function registerSpawnPoint(Child)
	if Child then
		local tag = Instance.new("CFrameValue")
		tag.Name = ((Child.Name:lower() == "spawnpoint" or Child.Name:lower() == "spawnpart") and "default") or Child.Name
		tag.Value = Child.CFrame
		if Child:FindFirstChild("description") then
			Child.description:Clone().Parent = tag
		end
		tag.Parent = spawnPoints
	end
end

for i,Child in pairs(game.CollectionService:GetTagged("spawnPoint")) do
	registerSpawnPoint(Child)
end

game.CollectionService:GetInstanceAddedSignal("spawnPoint"):Connect(registerSpawnPoint)

local mapNameCache = {}

local function getPlaceName(destination)
	if mapNameCache[tostring(destination)] then
		return mapNameCache[tostring(destination)]
	else
		local placeInfo = game.MarketplaceService:GetProductInfo(destination,Enum.InfoType.Asset)
		local placeName = placeInfo.Name
		if placeName then
			placeName = string.gsub(placeName, " %(Demo%)", "")
			mapNameCache[tostring(destination)] = placeName
			return placeName
		end
	end
	return "???"
end

local function registerTeleportAsSpawn(Child)
	if Child and Child:FindFirstChild("teleportDestination") then

		local tag = Instance.new("CFrameValue")
		local destination = utilities.placeIdForGame(Child.teleportDestination.Value)
		tag.Name = tostring(destination)
		tag.Value = Child.CFrame
		tag.Parent = spawnPoints

		local isLoadBarrier = Instance.new("BoolValue")
		isLoadBarrier.Name = "isLoadBarrier"
		isLoadBarrier.Value = true
		isLoadBarrier.Parent = tag

		if Child:FindFirstChild("ignore") == nil then
			spawn(function()
				local description = Instance.new("StringValue")
				description.Name = "description"
				description.Value = "Path to ".. getPlaceName(destination)
				description.Parent = tag
			end)
		end
	end
end

for i,Child in pairs(game.CollectionService:GetTagged("teleportPart")) do
	registerTeleportAsSpawn(Child)
end

game.CollectionService:GetInstanceAddedSignal("teleportPart"):Connect(registerTeleportAsSpawn)

spawnPoints.Parent = game.ReplicatedStorage
-- end spawn point logic

network:create("signal_inputChanged", "RemoteEvent", "OnServerEvent", function(player, input)
	if input == "xbox" or input == "mobile" or input == "pc" then
		if player:FindFirstChild("input") then
			player.input.Value = input
		end
	end
end)


local function onPlayerAdded(player, desiredSlot, desiredTimeStamp, accessories)
	if player:FindFirstChild("DataLoaded") or playerDataContainer[player] then
		spawn(function()
--			network:invoke("reportError", player, "debug", "onPlayerAdded called when player data already exists.")
		end)
		return false, nil, "Data already loaded"
	end

	local joinData = player:GetJoinData()

	local teleportData
	if joinData and joinData.TeleportData then
		-- support shared teleportData for parties
		teleportData = (joinData.TeleportData.members and joinData.TeleportData.members[player.Name]) or joinData.TeleportData
	end

	if not ((teleportData and teleportData.destination == game.PlaceId) or game.PlaceId == 2015602902 or game.PlaceId == 2015602902 or game.PlaceId == 2376885433 or runService:IsRunMode() or runService:IsStudio()) then

		if player:GetRankInGroup(4238824) < 250 then
			-- stress test place is always allowed
			if game.PlaceId ~= 2103419922 then
				player:Kick("Not authorized")
				network:invoke("reportError", player, "debug", "Player not authorized to join server")
				return false
			end
		end


	end




--[[
		teleportData.destination 				= destination
		teleportData.dataTimestamp 				= timestamp
		teleportData.dataSlot					= player.dataSlot.Value
		teleportData.analyticsSessionId 		= player.AnalyticsSessionId.Value
		teleportData.joinTime					= player.JoinTime.Value
		teleportData.partyData 					= network:invoke("getPartyDataByPlayer", player)
--]]


	local existingAnalyticsSession
	local joinTime
	local wasReferred

	if teleportData then
		desiredSlot = teleportData.dataSlot
		desiredTimeStamp = teleportData.dataTimestamp

		if teleportData.analyticsSessionId and teleportData.joinTime then
			existingAnalyticsSession = teleportData.analyticsSessionId
			joinTime = teleportData.joinTime
		end

		if teleportData.playerAccessories then
			accessories = teleportData.playerAccessories
		end

		if teleportData.partyData and teleportData.partyData.guid then
			network:invoke("resumePartyAfterTeleport", player, teleportData.partyData.guid, teleportData.partyData.partyLeaderUserId)
		end

		if teleportData.wasReferred then
			wasReferred = true
		end

		local location = teleportData.arrivingFrom
		if location and location ~= 2376885433 and location ~= 2015602902 then
			spawn(function()
				local placeName = getPlaceName(location)
				if teleportData.teleportType and teleportData.teleportType == "rune" then
					network:fireAllClients("signal_alertChatMessage", {
						Text = player.Name .. " arrived from " .. placeName .. " via a magical rune.";
						Font = Enum.Font.SourceSansBold;
						Color = Color3.fromRGB(45, 87, 255)
					})
				elseif teleportData.teleportType and teleportData.teleportType == "death" then
					network:fireAllClients("signal_alertChatMessage", {
						Text = player.Name .. " escaped from " .. placeName .. ".";
						Font = Enum.Font.SourceSansBold;
						Color = Color3.fromRGB(45, 87, 255)
					})
				elseif teleportData.teleportType and teleportData.teleportType == "taxi" then
					network:fireAllClients("signal_alertChatMessage", {
						Text = player.Name .. " arrived from " .. placeName .. " via Taximan Dave.";
						Font = Enum.Font.SourceSansBold;
						Color = Color3.fromRGB(45, 87, 255)
					})
				else
					network:fireAllClients("signal_alertChatMessage", {
						Text = player.Name .. " arrived from " .. placeName .. ".";
						Font = Enum.Font.SourceSansBold;
						Color = Color3.fromRGB(45, 87, 255)
					})
				end


			end)
		else
			network:fireAllClients("signal_alertChatMessage", {
				Text = player.Name .. " connected.";
				Font = Enum.Font.SourceSansBold;
				Color = Color3.fromRGB(45, 87, 255)
			})
		end
	end

	-- defaults
	desiredSlot = desiredSlot or 1
--	desiredTimeStamp = desiredTimeStamp or 0

	-- get playerData
	local success, playerData, errorMsg = datastoreInterface:getPlayerSaveFileData(player, desiredSlot, desiredTimeStamp)

	if not success then
		warn("Failed to load "..player.Name.."'s data from slot "..desiredSlot.." ("..errorMsg..")")
		network:invoke("reportError", player, "error", "Failed to load player data: "..errorMsg)
		network:invoke("reportAnalyticsEvent",player,"data:fail:load")
		return false, nil, errorMsg
	end

	if playerData == nil then
		warn("Player data is nil???")
	end

 	if game.PlaceId == 2376885433 or game.PlaceId == 2015602902 or game.PlaceId == 4623219432 then
		-- lobby server, return data to player
		return playerData
	end

	local professionTag = Instance.new("IntValue")
	professionTag.Name = "professions"

	spawn(function()
		if game.MarketplaceService:UserOwnsGamePassAsync(player.userId, 7785243) or game:GetService("RunService"):IsStudio() then
			local tag = Instance.new("BoolValue")
			tag.Name = "bountyHunter"
			tag.Parent = player
		end
	end)

	if game.ReplicatedStorage.professionLookup then
		for i, profession in pairs(game.ReplicatedStorage.professionLookup:GetChildren()) do
			if profession:IsA("ModuleScript") then
				playerData.professions[profession.Name] = playerData.professions[profession.Name] or {level = 1, exp = 0}
				local tag = Instance.new("IntValue")
				tag.Name = profession.Name
				tag.Value = playerData.professions[profession.Name].level
				tag.Parent = professionTag
			end
		end
	end

	professionTag.Parent = player

	local levelTag 	= Instance.new("IntValue")
	levelTag.Name 	= "level"
	levelTag.Value 	= playerData.level
	levelTag.Parent = player

	local moneyTag  = Instance.new("NumberValue")
	moneyTag.Name	= "gold"
	moneyTag.Value	= playerData.gold
	moneyTag.Parent	= player

	spawn(function()
		network:invoke("reportAnalyticsEvent",player,"level:lvl"..tostring(playerData.level),playerData.level)
	end)
	local inputTag 	= Instance.new("StringValue")
	inputTag.Name	= "input"
	inputTag.Parent = player

	local classTag 	= Instance.new("StringValue")
	classTag.Name 	= "class"
	classTag.Value 	= playerData.class
	classTag.Parent = player

	local pvpTag 	= Instance.new("BoolValue")
	pvpTag.Name 	= "isPVPEnabled"
	pvpTag.Value 	= false
	pvpTag.Parent 	= player

	local pvpTag 	= Instance.new("BoolValue")
	pvpTag.Name 	= "isInPVP"
	pvpTag.Value 	= false
	pvpTag.Parent 	= player

	local entityGUIDTag 	= Instance.new("StringValue")
	entityGUIDTag.Name 		= "entityGUID"
	entityGUIDTag.Value 	= httpService:GenerateGUID(false)
	entityGUIDTag.Parent 	= player

	local playerSpawnTimeTag 	= Instance.new("IntValue")
	playerSpawnTimeTag.Name 	= "playerSpawnTime"
	playerSpawnTimeTag.Value 	= os.time()
	playerSpawnTimeTag.Parent 	= player

	local isPlayerSpawningTag 	= Instance.new("BoolValue")
	isPlayerSpawningTag.Name 	= "isPlayerSpawning"
	isPlayerSpawningTag.Value 	= true
	isPlayerSpawningTag.Parent 	= player
		local isFirstTimeSpawning 	= Instance.new("BoolValue")
		isFirstTimeSpawning.Name 	= "isFirstTimeSpawning"
		isFirstTimeSpawning.Value 	= true
		isFirstTimeSpawning.Parent 	= isPlayerSpawningTag

	local respawnPointTag = Instance.new("ObjectValue")
	respawnPointTag.Name = "respawnPoint"
	respawnPointTag.Value = nil
	respawnPointTag.Parent = player

	if not playerData.flags.ancientsRevert then
		playerData.flags.ancientsRevert = true

		for i,v in pairs(playerData.inventory) do
			if v.id == 63 or v.id == 62 or v.id == 64 or v.id == 17 then -- 63, 62, 17, 64 -> 200
				v.id = 200
			end
		end

		if playerData.globalData and playerData.globalData.itemStorage then
			if not playerData.globalData.ancientsRevertStore then
				playerData.globalData.ancientsRevertStore = true
				for i,v in pairs(playerData.globalData.itemStorage) do
					if v.id == 63 or v.id == 62 or v.id == 64 or v.id == 17 then -- 63, 62, 17, 64 -> 200
						v.id = 200
					end
				end
			end
		end
	end

	if not playerData.flags.enchantWipe3 then
		playerData.flags.enchantWipe3 = true

		if playerData.gold > 50000 then
			playerData.gold = 50000
		end

		local function process(v)
			if v.modifierData then
				v.modifierData = {}
			end
			if v.upgrades then
				v.upgrades = 0
			end
			if v.successfulUpgrades then
				v.successfulUpgrades = 0
			end
			if v.blessed then
				v.blessed = nil
			end
			if v.enchantments then
				v.enchantments = nil
			end
		end

		for i,v in pairs(playerData.equipment) do
			process(v)
		end

		for i,v in pairs(playerData.inventory) do
			process(v)
		end

		-- for damien: this isnt how storage works pls fix it thnx
		--playerData.globalData.itemStorage
		if playerData.globalData and playerData.globalData.itemStorage then
			if not playerData.globalData.enchantWipe3 then
				playerData.globalData.enchantWipe3 = true
				for i,v in pairs(playerData.globalData.itemStorage) do
					process(v)
				end
			end
		end

		playerData.treasureChests = nil
	end

	-- boom boom
	if not playerData.hasCustomizedCharacter then
		if accessories then
			playerData.accessories = accessories
		else
			playerData.accessories = require(replicatedStorage.defaultCharacterAppearance).accessories
		end
		playerData.hasCustomizedCharacter = true
	end

	playerData.accessories.skinColorId = playerData.accessories.skinColorId or 1
	playerData.accessories.hairColorId = playerData.accessories.hairColorId or 1
	playerData.accessories.shirtColorId = playerData.accessories.shirtColorId or 1


	-- location data
	playerData.locations = playerData.locations or {}
	if game.PrivateServerId == "" and game.PrivateServerOwnerId == 0 then
		playerData.locations[tostring(game.PlaceId)] = playerData.locations[tostring(game.PlaceId)] or {}
		local spawns = {} do
			for i, spawnPart in pairs(collectionService:GetTagged("spawnPoint")) do
				spawns[spawnPart.Name] = spawnPart
			end
		end
		local placeData = playerData.locations[tostring(game.PlaceId)]
		placeData.visited = os.time()
		placeData.spawns = placeData.spawns or {}
		for spawnName, spawnDescription in pairs(placeData.spawns) do
			if not spawns[spawnName] then
				placeData.spawns[spawnName] = nil
			end
		end
	end

	-- treasure data
	playerData.treasure = playerData.treasure or {}
	playerData.treasure["place-"..game.PlaceId] = playerData.treasure["place-"..game.PlaceId] or {}
	playerData.treasure["place-"..game.PlaceId].chests = playerData.treasure["place-"..game.PlaceId].chests or {}
	for i, treasureChest in pairs(game.CollectionService:GetTagged("treasureChest")) do
		playerData.treasure["place-"..game.PlaceId].chests[treasureChest.Name] = playerData.treasure["place-"..game.PlaceId].chests[treasureChest.Name] or {
			open = false
		}
	end

	if wasReferred then
		if not playerData.globalData.recievedReferralGift then
			playerData.globalData.recievedReferralGift  = true
			playerData.globalData.ethyr = (playerData.globalData.ethyr or 0) + 200
			network:fireClient("signal_alertChatMessage", player, {Text = "Recieved 200 Ethyr referral bonus."; Font = Enum.Font.SourceSansBold; Color = Color3.fromRGB(196, 209, 216)} )
			network:invoke("reportCurrency", player, "ethyr", 200, "gift:referral")
		end
	end

	local lastPosition = playerData.lastPhysicalPosition
	if lastPosition and (playerData.lastLocation == nil or game.PlaceId == playerData.lastLocation) then
		local tag = Instance.new("Vector3Value")
		tag.Name = "lastPhysicalPosition"
		tag.Value = Vector3.new(lastPosition[1],lastPosition[2],lastPosition[3])
		tag.Parent = player
	end

	-- signal for when data is changed (`_previousValue` and `_newValue` are optional,
	-- do not depend on them being there unless you know they will be)
	local function signal__playerDataChanged(index, _previousValue, _newValue)
		if index == "class" then
			player.class.Value = _newValue
			generatecompletePlayerStats(player)
		elseif index == "gold" then
			player.gold.Value = _newValue
		elseif index == "exp" then -- EXP CHANGED
			while playerData.level < PLAYER_LEVEL_CAP do
				local expForNextLevel = levels.getEXPToNextLevel(playerData.level)
				if playerData.exp >= expForNextLevel then
					-- level the player up and silently remove extra exp

					-- NOTE: we are doing this silently because the propogation at the end will get the **CURRENT** exp value
					-- which will include this silent reduction.
					playerData.exp = playerData.exp - expForNextLevel

					-- increase player level and propogate this change
					playerData.nonSerializeData.incrementPlayerData("level", 1)

					player.level.Value = player.level.Value + 1

					spawn(function()
						network:invoke("reportAnalyticsEvent",player,"levelup:lvl"..tostring(player.level.Value))
					end)

					network:fireAllClients("signal_alertChatMessage", {
						Text = player.Name .. " has reached Lvl." .. player.level.Value .. "!";
						Font = Enum.Font.SourceSansBold;
						Color = Color3.fromRGB(255, 219, 12)
					})

					if player.Character and player.Character.PrimaryPart then
						for i,oPlayer in pairs(game.Players:GetPlayers()) do
							local ui = script.levelUp:Clone()
							ui.Adornee = player.Character.PrimaryPart
							ui.Parent = oPlayer.PlayerGui
						end
						local Sound = Instance.new("Sound")
						Sound.Volume = 0.7
						Sound.MaxDistance = 500
						Sound.SoundId = "rbxassetid://2066645345"
						Sound.Parent = player.Character.PrimaryPart
						Sound:Play()
						game.Debris:AddItem(Sound,10)

						local Attach = Instance.new("Attachment")
						Attach.Parent = player.Character.PrimaryPart
						Attach.Orientation = Vector3.new(0,0,0)
						Attach.Axis = Vector3.new(1,0,0)
						Attach.SecondaryAxis = Vector3.new(0,1,0)

						for i,particle in pairs(script.particles:GetChildren()) do
							local newParticle = particle:Clone()
							newParticle.Enabled = false
							newParticle.Parent = Attach
							if newParticle.Name == "Dust" then
								newParticle:Emit(40)
							else
								newParticle:Emit(1)
							end

						end

						game.Debris:AddItem(Attach, 10)

						applyMaxHealth(player)
					end
				else
					if playerData.level >= PLAYER_LEVEL_CAP then
						playerData.exp = 0
					end

					break
				end
			end
		elseif index == "equipment" then -- equipment was changed!
			generatecompletePlayerStats(player)
			replicatePlayerCharacterAppearance(player)

			network:fire("playerEquipmentChanged_server", player, playerData.equipment)
			--network:fireAllClients("playerEquipmentChanged", player, playerData.equipment)
		elseif index == "inventory" then
			-- update the inventory
			updateInventorySlots(player)

			network:fire("playerInventoryChanged_server", player)

			-- try to ensure that stuff is gotten to in order
			table.sort(playerData[index], function(a, b)
				return a.position > b.position
			end)
		elseif index == "quests" then
			for i, playerQuestData in pairs(playerData.quests.active) do
				-- update objective data to
				if getPlayerQuestState(player, playerQuestData.id) == mapping.questState.handing then

				end
			end
		elseif index == "level" then
--			playerData.statistics.pointsUnassigned = playerData.statistics.pointsUnassigned + STAT_POINTS_GAINED_PER_LEVEL
			--playerData.nonSerializeData.playerDataChanged:Fire("statistics")
			--generatecompletePlayerStats(player)
		elseif index == "statistics" then
			generatecompletePlayerStats(player)
		elseif index == "accessories" then
			replicatePlayerCharacterAppearance(player)
		elseif index == "nonSerializeData" then
			player.isPVPEnabled.Value 	= playerData.nonSerializeData.isPVPEnabled
			player.isInPVP.Value 		= playerData.nonSerializeData.isGlobalPVPEnabled or #playerData.nonSerializeData.whitelistPVPEnabled > 0

			if player.isInPVP.Value and player.Character then
				physics:setWholeCollisionGroup(player.Character, "pvpCharacters")
			elseif player.Character then
				physics:setWholeCollisionGroup(player.Character, "characters")
			end
		elseif index == "statusEffects" then
			generatecompletePlayerStats(player)
			--replicatePlayerCharacterActiveStatusEffects(player)
		elseif index == "internalData" then
			warn("attempt to signal internalData changed.")
		end

		onClientRequestPropogateCacheData(player, index)
	end

	-- set-up playerDataChanged event to propogate playerData changes
	playerData.nonSerializeData.playerDataChanged = Instance.new("BindableEvent")
	playerData.nonSerializeData.playerDataChanged.Event:connect(signal__playerDataChanged)

	-- set condition properly if this was a death teleport
	if teleportData and teleportData.teleportType == "death" then
		playerData.condition = {
			health = 1,
			mana = 1,
		}
	end

	-- continue statusEffects that were packaged
	if playerData.packagedStatusEffects then
		network:invoke("playerAddedContinuePackageStatusEffects", player, playerData.packagedStatusEffects)

		playerData.packagedStatusEffects = nil
	end

	-- calculate stats table
	generatecompletePlayerStats(player, true, playerData)
	replicatePlayerCharacterActiveStatusEffects(player)

	-- set up character appearance
	replicatePlayerCharacterAppearance(player, playerData)

	local function onCharacterSpawn(character)
--		if isPlayerSpawningTag.Value and not isFirstTimeSpawning.Value then warn("not going to spawn player", isPlayerSpawningTag.Value, not isFirstTimeSpawning.Value) return false end

		isPlayerSpawningTag.Value = true
		playerSpawnTimeTag.Value = os.time()
--		isFirstTimeSpawning.Value = false

		if player.Character ~= character then
--			warn("player character is not character?")
		end

		if character.Parent == nil then
--			warn("character Parent nil, overriding")
			character.Parent = entityManifestCollectionFolder
		end

		if character.PrimaryPart == nil then
			repeat wait(0.1) until character.PrimaryPart or character:FindFirstChild("hitbox") or character.Parent == nil
		end

		if character.Parent == nil then
			if player.Character == character then
				character.Parent = entityManifestCollectionFolder
			else
				character:Destroy()
				return
			end
		end

		if character:FindFirstChild("hitbox") and character.PrimaryPart ~= character.hitbox then
			character.PrimaryPart = character.hitbox
		end

		replicatePlayerCharacterAppearance(player, playerData)
		replicatePlayerCharacterActiveStatusEffects(player, playerData)

		local characterPrimaryPart = character.PrimaryPart

		pcall(function() characterPrimaryPart:SetNetworkOwner(player) end)

		local lastCharacterPostion do
			if player:FindFirstChild("lastPhysicalPosition") then
				lastCharacterPostion  = player.lastPhysicalPosition.Value
				player.lastPhysicalPosition:Destroy()
			end
		end

		local targetCharacterSpawnPosition do
			if lastCharacterPostion then
				targetCharacterSpawnPosition = CFrame.new(lastCharacterPostion) + Vector3.new(0, 4, 0)
			elseif replicatedStorage:FindFirstChild("spawnPoints") then
				local spawnPoint = teleportData and ((teleportData.spawnLocation and replicatedStorage.spawnPoints:FindFirstChild(teleportData.spawnLocation)) or teleportData.arrivingFrom and replicatedStorage.spawnPoints:FindFirstChild(teleportData.arrivingFrom)) or replicatedStorage.spawnPoints:FindFirstChild("default")

				-- if the player has a set respawn point, use that
				if player:FindFirstChild("respawnPoint") and player.respawnPoint.Value then
					spawnPoint = player.respawnPoint.Value
				end

				if spawnPoint then
					local cf 			= spawnPoint.Value
					local goalCFrame 	= characterPrimaryPart.CFrame - characterPrimaryPart.CFrame.p + cf.p + cf.lookVector * 30 + Vector3.new(math.random() * 3, 4, math.random() * 3)

					-- shift randomly if this isn't a load barrier
					-- local isLoadBarrier = (teleportData and (teleportData.spawnLocation == nil)) and spawnPoint.Name ~= "default"
					local isLoadBarrier = (spawnPoint:FindFirstChild("isLoadBarrier") ~= nil)
					if not isLoadBarrier then
						goalCFrame = cf + Vector3.new(math.random(-3, 3), math.random(3, 5), math.random(-3, 3))
					end

					targetCharacterSpawnPosition = goalCFrame
				elseif #replicatedStorage.spawnPoints:GetChildren() > 0 then
					warn(">> spawn point missing!",	teleportData and teleportData.arrivingFrom or "no default found")
					warn(">> using first spawnPoint")

					local cf 			= replicatedStorage.spawnPoints:GetChildren()[1].Value
					local goalCFrame 	= characterPrimaryPart.CFrame - characterPrimaryPart.CFrame.p + cf.p + cf.lookVector * 30 + Vector3.new(math.random() * 3, 4, math.random() * 3)

					targetCharacterSpawnPosition = goalCFrame
				else
					warn(">> no spawn points at all.. ?")
				end
			else
				warn(">> no spawnPoints ?")
			end
		end

		local resurrectTag = player:FindFirstChild("resurrecting")
		if resurrectTag ~= nil then
			resurrectTag:Destroy()
			targetCharacterSpawnPosition = nil
		end

		if targetCharacterSpawnPosition then
			local ray = Ray.new(targetCharacterSpawnPosition.p + Vector3.new(0, 2, 0), Vector3.new(0, -999, 0))
			local hitPart, hitPos = projectile.raycast(ray, {character; entityManifestCollectionFolder})

			if hitPart then
				wait(0.1)

				--while (characterPrimaryPart.Position - targetCharacterSpawnPosition.p).magnitude > 3 do
				for i = 1, 8 do
					network:invoke("teleportPlayerCFrame_server", player, targetCharacterSpawnPosition)
					wait(0.2)
				end
			end
		end

		if player.Character == character and characterPrimaryPart.state.Value ~= "dead" then
			isPlayerSpawningTag.Value = false
		end
	end

	if player.Character then
		spawn(function() onCharacterSpawn(player.Character) end)
	end

	player.CharacterAdded:connect(onCharacterSpawn)

	-- register playerData internally
	playerDataContainer[player] = playerData

	flagCheck(player, playerData)

	-- assign inventory slots that aren't assigned positions
	updateInventorySlots(player)

	local success, rank = pcall(function()
		return player:GetRankInGroup(4238824)
	end)

	if (runService:IsStudio() or (success and type(rank) == "number" and rank >= 254)) and not playerData.abilityBooks.admin then
		warn("GRANTING ADMIN BOOK TO", player)
		--grantPlayerAbilityBook(player, "admin")
	end

	-- push player data to client
	onClientRequestFlushPropogationCache(player)

	-- some functions to change value easily while also flushing the change to the client
	function playerData.nonSerializeData.setPlayerData(index, value)
		local previousValue = playerData[index]
		playerData[index] 	= value

		-- signal to script something changed
		playerData.nonSerializeData.playerDataChanged:Fire(index, previousValue, playerData[index])
	end

	function playerData.nonSerializeData.incrementPlayerData(index, increment, source)
		if index == "exp" and playerData.level >= PLAYER_LEVEL_CAP then
			return
		end

		local previousValue = playerData[index]
		playerData[index] 	= previousValue + increment

		-- signal to script something changed
		playerData.nonSerializeData.playerDataChanged:Fire(index, previousValue, playerData[index])

		-- analytics for gold
		if index == "gold" then
			local currency 	= index
			local amount 	= increment

			if amount ~= 0 and source then
				network:invoke("reportCurrency", player, currency, amount, source)
			end
		end
	end

	function playerData.nonSerializeData.setNonSerializeDataValue(index, value)
		playerData.nonSerializeData[index] = value
		playerData.nonSerializeData.playerDataChanged:Fire("nonSerializeData")
	end
	-- end easy functions --

	if player.Character and player.Character.PrimaryPart then
		spawn(function() onCharacterAdded(player, player.Character) end)
	end

	player.CharacterAdded:connect(function(character)
		while not character.PrimaryPart and player.Parent == game.Players do
			wait(0.1)
		end

		if character.PrimaryPart then
			onCharacterAdded(player, character)
		end
	end)

	local tag = Instance.new("BoolValue")
	tag.Name = "DataLoaded"
	tag.Parent = player

	local tag = Instance.new("IntValue")
	tag.Name = "dataLoaded"
	tag.Value = os.time()
	tag.Parent = player

	network:fire("playerDataLoaded", player, playerDataContainer[player])

	local posTag = Instance.new("Vector3Value")
	posTag.Name = "playerCharacterPosition"
	posTag.Parent = player
	spawn(function()
		while player and player.Parent == game.Players do
			if player.Character and player.Character.PrimaryPart then
				posTag.Value = player.Character.PrimaryPart.Position
			end
			wait(3)
		end
	end)

	-- more aggresively save lastPhysicalPosition
	spawn(function()
		local players = game:GetService("Players")
		while player and player.Parent == players do
			local playerData = playerDataContainer[player]
			if playerData and player.Character and player.Character.PrimaryPart then
				local position = player.Character.PrimaryPart.Position
				playerData["lastPhysicalPosition"] = {
					math.floor(position.X),
					math.floor(position.Y),
					math.floor(position.Z)
				}
			end
			wait(3)
		end
	end)

	spawn(function()
		wait(60)
		local errorcount = 0

		while player and player.Parent == game.Players and player:FindFirstChild("DataLoaded") do
			local waittime = 180
			if player:FindFirstChild("teleporting") == nil and playerDataContainer[player] then
				local success, timestamp = autoSavePlayerData(player)
				if not success then
					if errorcount == 0 then
						waittime = 10
					elseif errorcount <= 3 then
						waittime = 20
					else
						waittime = 60
					end
					errorcount = errorcount + 1
				end
			end
			wait(waittime)
		end
	end)

	-- Admin hunter
	spawn(function()
		if player:IsInGroup(1200769) then
			local Error = "An admin ("..player.Name..") joined the game."
			network:invoke("reportError", player, "info", Error)
		elseif player:IsInGroup(4199740) then
			local Error = "A Star Creator ("..player.Name..") joined the game."
			network:invoke("reportError", player, "info", Error)
		end
		if player:IsInGroup(4484634) then
			local Error = "A Red Manta ("..player.Name..") joined the game."
			network:invoke("reportError", player, "info", Error)
		end
	end)

	if existingAnalyticsSession then
		network:invoke("continueSession", player, existingAnalyticsSession, joinTime)
	else
		network:invoke("newSession", player)
	end

	-- tp exploit stuff --
	local playerPositionData = {}
		playerPositionData.positions 			= {}
		playerPositionData.sketchyMovements 	= {}

	playerPositionDataContainer[player] = playerPositionData
	----------------------

	--items currently equipped need to have their onEquipped fired
	for _, slotData in pairs(playerData.equipment) do
		local itemData = itemLookup[slotData.id]
		if itemData.perks then
			for perkName, _ in pairs(itemData.perks) do
				local perkData = perkLookup[perkName]
				if perkData and perkData.onEquipped then
					local success, err = pcall(function()
						perkData.onEquipped(player, itemData, tostring(slotData.position))
					end)
					if not success then
						warn(string.format("item %s equip failed because: %s", itemData.name, err))
					end
				end
			end
		end
	end

	-- data recovery flags processed here, we don't need to care if this is studio
	spawn(function()
		-- data recovery disabled by this return
		-- guess we're not using it for a while
		if game.PlaceId ~= 4409709778 then return end



		local lastSaveTimestamp = 0
		if playerData.globalData then
			lastSaveTimestamp = playerData.globalData.lastSaveTimestamp or 0
		end

		if not playerData.flags.dataRecovery11_14 then
			if lastSaveTimestamp < 1573760698 then
				playerData.flags.dataRecovery11_14 = true
			else
				performDataRecovery(player, desiredSlot, "dataRecovery11_14")
			end
		end
	end)

	return true, playerData, errorMsg
end

function performDataRecovery(player, desiredSlot, flagName)
	local playerData = playerDataContainer[player]

	if game.PlaceId == 4409709778 then
		while true do
			wait(1)
			network:fireClient("dataRecoveryRequested", player, playerData, desiredSlot, flagName)
		end
	else
		playerData.dataRecoveryReturnPlaceId = game.PlaceId
		repeat
			wait(1)
		until network:invoke("teleportPlayer", player, 4409709778)
	end
end

local DATA_RECOVERY_FLAG_NAMES = {
	"dataRecovery11_14",
}

function onDataRecoveryRejected(player, flagName)
	-- is this a legal flag?
	local legalFlag = false
	for _, acceptedFlagName in pairs(DATA_RECOVERY_FLAG_NAMES) do
		if acceptedFlagName == flagName then
			legalFlag = true
		end
	end
	if not legalFlag then return end

	local playerData = playerDataContainer[player]
	if not playerData then return end
	if playerData.flags[flagName] then return end

	playerData.flags[flagName] = true

	repeat
		wait(1)
	until network:invoke("teleportPlayer", player, playerData.dataRecoveryReturnPlaceId)
end

function onDataRecoveryRequested(player, slot, version, flagName)
	-- only in data recovery place!
	if game.PlaceId ~= 4409709778 then return end

	-- is this a legal flag?
	local legalFlag = false
	for _, acceptedFlagName in pairs(DATA_RECOVERY_FLAG_NAMES) do
		if acceptedFlagName == flagName then
			legalFlag = true
		end
	end
	if not legalFlag then return end

	-- do we have this flag already?
	local playerData = playerDataContainer[player]
	if playerData.flags[flagName] then return end

	local latestVersion = datastoreInterface:getLatestSaveVersion(player)
	local success, rollbackData, message = datastoreInterface:getPlayerSaveFileData(player, slot, version)

	if not success then return end

	rollbackData.timestamp = playerData.timestamp
	rollbackData.globalData.version = playerData.globalData.version

	rollbackData.flags[flagName] = true
	playerDataContainer[player] = rollbackData

	datastoreInterface:updatePlayerSaveFileData(player.UserId, rollbackData)

	repeat
		wait(1)
	until network:invoke("teleportPlayer", player, playerData.dataRecoveryReturnPlaceId)
end

game:BindToClose(function()
	if shuttingDown then
		return false
	end
	shuttingDown = true

	local msg = Instance.new("Message")
	msg.Text = "Servers are shutting down for a Vesteria or Roblox client update. Your data is now saving..."
	msg.Parent = workspace

	if game:GetService("RunService"):IsStudio() then return end
	local playersToSave = {}
	local playerCount = 0
	for i,player in pairs(game.Players:GetPlayers()) do
		local playerName = player.Name
		playersToSave[playerName] = player
		playerCount = playerCount + 1
		spawn(function()
			local success, err = pcall(onPlayerRemoving,player)
			if success then
				playersToSave[playerName] = nil
				playerCount = playerCount - 1
--				player:Kick("Your data has been saved. Please rejoin.")
				local destination = 2376885433
				if game.GameId == 712031239 then
					destination = 2015602902
				end

				game:GetService("TeleportService"):Teleport(destination, player, {teleportReason = "You were teleported back to the lobby because Vesteria your server was shutdown. This probably means we released an update for new content or bug fixes."}, game.ReplicatedStorage.returnToLobby)
			else
				warn("Failed to save",playerName,"data")
				warn(err)
			end
		end)
	end
	repeat wait(0.1) until playerCount <= 0
end)


--[[
	TELEPORTATION
--]]

local teleportService = game:GetService("TeleportService")

-- TODO: tie into teleport manager
local function saveDataForTeleport(player)
	if not player:FindFirstChild("teleporting") then
		local tag = Instance.new("BoolValue")
		tag.Name = "teleporting"
		tag.Parent = player

		network:invoke("reportAnalyticsEvent",player,"teleport:attempt")
		local TimeStamp = onPlayerRemoving(player)
		if TimeStamp then
			return TimeStamp
		end
	end
end

network:create("signal_teleport", "RemoteEvent")



-- note: category can be factored out because items of same itemId share same category
local function getInventorySlotByItemId(player, itemId, ignoreSlotsThatAreStacked)
	local lowestInventorySlot
	if playerDataContainer[player] then
		for i, inventorySlot in pairs(playerDataContainer[player].inventory) do
			local itemBaseData = itemLookup[inventorySlot.id]
			if inventorySlot.id == itemId and (not lowestInventorySlot or inventorySlot.position < lowestInventorySlot.position) and (not ignoreSlotsThatAreStacked or (inventorySlot.stacks and inventorySlot.stacks < (itemBaseData.stackSize or MAX_COUNT_PER_STACK))) then
				lowestInventorySlot = inventorySlot
			end
		end
	end

	return lowestInventorySlot
end

local function onGetPlayerInventorySlotDataByInventorySlotPosition(player, category, inventorySlotPosition)
	if not player or not playerDataContainer[player] then return nil end

	for trueInventorySlotPosition, inventorySlotData in pairs(playerDataContainer[player].inventory) do
		local itemBaseData = itemLookup[inventorySlotData.id]
		if itemBaseData and itemBaseData.category == category then
			if inventorySlotData.position == inventorySlotPosition then
				return inventorySlotData, trueInventorySlotPosition
			end
		end
	end

	return nil
end

-- gold_player is how much the player loses, gold_NPC is how much the player gains
-- inventoryTransferDataCollection_player is what the player loses
-- inventoryTransferData_intermediateCollection_NPC is what the player gains
local function int__tradeItemsBetweenPlayerAndNPC(player, inventoryTransferDataCollection_player, gold_player, inventoryTransferData_intermediateCollection_NPC, gold_NPC, source, additionalValues)
	local playerData = playerDataContainer[player]

	if player and playerData and inventoryTransferDataCollection_player and inventoryTransferData_intermediateCollection_NPC then
		local inventoryTransferData_intermediateCollection_player, wasInventoryTransferDataModified_player 	= int__getInventoryTransferData_intermediateCollectionFromInventoryTransferDataCollection(player, inventoryTransferDataCollection_player)
		local player_hasInventorySpace 																		= int__doesPlayerHaveInventorySpaceForTrade(player, inventoryTransferData_intermediateCollection_player, inventoryTransferData_intermediateCollection_NPC)

		if not wasInventoryTransferDataModified_player and player_hasInventorySpace then
			if not gold_player or playerData.gold >= gold_player then
				-- remove items from playerFrom
				revokePlayerItemsByInventoryTransferDataCollection(player, inventoryTransferData_intermediateCollection_player)
				if gold_player and gold_player ~= 0 then
					playerData.nonSerializeData.incrementPlayerData("gold", -gold_player, source)
				end

				-- grant items from NPC
				grantPlayerItemsByInventoryTranferData_intermediateCollection(player, inventoryTransferData_intermediateCollection_NPC)
				if gold_NPC and gold_NPC ~= 0 then
					playerData.nonSerializeData.incrementPlayerData("gold", gold_NPC, source)
				end


				if not (additionalValues and additionalValues.overrideItemsRecieved) then
					network:fireClient("itemsRecieved", player, inventoryTransferData_intermediateCollection_NPC, gold_NPC)
				end

				return true
			else
				return false, player.Name .. " does not have enough gold"
			end
		else
			return false, wasInventoryTransferDataModified_player and "Player inventory was modified" or "Not enough space in inventory!"
		end
	end

	return false, "denied straight-up"
end

local function int__tradeItemsBetweenPlayers(playerFrom, inventoryTransferData_intermediateCollection_playerFrom, gold_playerFrom, playerTo, inventoryTransferData_intermediateCollection_playerTo, gold_playerTo)
	local playerFromData 	= playerDataContainer[playerFrom]
	local playerToData 		= playerDataContainer[playerTo]

	if playerFrom:FindFirstChild("DataSaveFailed") or playerTo:FindFirstChild("DataSaveFailed") then
		return false, "player is experiencing a DataStore outage"
	end

	if playerFromData and playerToData then
		-- check if playerFrom has inventory space
		local playerFrom_hasInventorySpace = int__doesPlayerHaveInventorySpaceForTrade(playerFrom, inventoryTransferData_intermediateCollection_playerFrom, inventoryTransferData_intermediateCollection_playerTo)
		if playerFrom_hasInventorySpace then
			-- check if playerTo has inventory space
			local playerTo_hasInventorySpace = int__doesPlayerHaveInventorySpaceForTrade(playerTo, inventoryTransferData_intermediateCollection_playerTo, inventoryTransferData_intermediateCollection_playerFrom)
			if playerTo_hasInventorySpace then
				-- remove items from playerFrom
				revokePlayerItemsByInventoryTransferDataCollection(playerFrom, inventoryTransferData_intermediateCollection_playerFrom)

				-- remove items from playerTo
				revokePlayerItemsByInventoryTransferDataCollection(playerTo, inventoryTransferData_intermediateCollection_playerTo)

				-- grant items to playerFrom
				grantPlayerItemsByInventoryTranferData_intermediateCollection(playerFrom, inventoryTransferData_intermediateCollection_playerTo)

				-- grant items to playerTo
				grantPlayerItemsByInventoryTranferData_intermediateCollection(playerTo, inventoryTransferData_intermediateCollection_playerFrom)

				local source = "player:trade"

				playerFromData.nonSerializeData.incrementPlayerData("gold", -gold_playerFrom, source)
				playerFromData.nonSerializeData.incrementPlayerData("gold", gold_playerTo * 0.7, source)

				playerToData.nonSerializeData.incrementPlayerData("gold", -gold_playerTo, source)
				playerToData.nonSerializeData.incrementPlayerData("gold", gold_playerFrom * 0.7, source)

				-- replicate these changes
				playerFromData.nonSerializeData.playerDataChanged:Fire("inventory")
				playerToData.nonSerializeData.playerDataChanged:Fire("inventory")

				return true, "ALL GOOD!!!"
			else
				return false, playerTo.Name .. " does not have inventory space."
			end
		else
			return false, playerFrom.Name .. " does not have inventory space."
		end
	end

	return false, "ERROR!"
end

-- inventoryTransferDataCollection_player1 refers to the data player1 is going to transfer to player2 and vice versa
local function onTradeRequestReceived(player1, inventoryTransferDataCollection_player1, gold_player1, player2, inventoryTransferDataCollection_player2, gold_player2)
	if not configuration.getConfigurationValue("isTradingEnabled", player1) or not configuration.getConfigurationValue("isTradingEnabled", player2) then
		return false, "This feature has been disabled"
	end

	if player1:FindFirstChild("DataSaveFailed") then
		network:fireClient("alertPlayerNotification", player1, {text = "Cannot trade during DataStore outage."; textColor3 = Color3.fromRGB(255, 57, 60)})
		return false, "This feature is temporarily disabled"
	end

	if player1 and player2 and inventoryTransferDataCollection_player1 and inventoryTransferDataCollection_player2 then
		do -- todo: fix this ugly hack
			local p1in = {}
			for i,v in pairs(inventoryTransferDataCollection_player1) do
				table.insert(p1in, v)
			end

			local p2in = {}
			for i,v in pairs(inventoryTransferDataCollection_player2) do
				table.insert(p2in, v)
			end

			inventoryTransferDataCollection_player1 = p1in
			inventoryTransferDataCollection_player2 = p2in
		end

		if player1:FindFirstChild("DataSaveFailed") then
			network:fireClient("alertPlayerNotification", player1, {text = "Cannot trade during DataStore outage. Trade canceled."; textColor3 = Color3.fromRGB(255, 57, 60)})
			network:fireClient("alertPlayerNotification", player2, {text = "Other player is experiencing a DataStore outage. Trade canceled."; textColor3 = Color3.fromRGB(255, 57, 60)})
			return false, "This feature is temporarily disabled"
		end

		if player2:FindFirstChild("DataSaveFailed") then
			network:fireClient("alertPlayerNotification", player2, {text = "Cannot trade during DataStore outage. Trade canceled."; textColor3 = Color3.fromRGB(255, 57, 60)})
			network:fireClient("alertPlayerNotification", player1, {text = "Other player is experiencing a DataStore outage. Trade canceled."; textColor3 = Color3.fromRGB(255, 57, 60)})
			return false, "This feature is temporarily disabled"
		end

		local inventoryTransferData_intermediateCollection_player1, wasInventoryTransferDataModified_player1 = int__getInventoryTransferData_intermediateCollectionFromInventoryTransferDataCollection(player1, inventoryTransferDataCollection_player1)
		local inventoryTransferData_intermediateCollection_player2, wasInventoryTransferDataModified_player2 = int__getInventoryTransferData_intermediateCollectionFromInventoryTransferDataCollection(player2, inventoryTransferDataCollection_player2)

		if not wasInventoryTransferDataModified_player1 then
			if not wasInventoryTransferDataModified_player2 then
				local success, reason = int__tradeItemsBetweenPlayers(player1, inventoryTransferData_intermediateCollection_player1, gold_player1, player2, inventoryTransferData_intermediateCollection_player2, gold_player2)

				if success then

				end

				return success, reason
			else
				return false, player2.Name .. " has invalid data"
			end
		else
			return false, player1.Name .. " has invalid data"
		end
	end

	return false, "invalid data"
end

local function incrementPlayerStatPointsByStatName(player, statName)
	local playerData = playerDataContainer[player]

	if playerData and (statName == "dex" or statName == "int" or statName == "str" or statName == "vit") then
		local usedPoints = playerData.statistics.dex + playerData.statistics.int + playerData.statistics.str + playerData.statistics.vit

		if levels.getStatPointsForLevel(playerData.level) - usedPoints >= 1 then
			playerData.statistics[statName] 		= playerData.statistics[statName] + 1

			playerData.nonSerializeData.playerDataChanged:Fire("statistics")

			applyMaxHealth(player, true)

			return true, "All good"
		else
			return false, "not enough"
		end
	end

	return false, "nope"
end

-- todo: handle 'swapping' and 'stack breaking/making' as one function based on the items involved
-- or something like that. it'll be a big function though, but they cross over too much to keep it separate
local function onRequestModifyInventorySlots()

end

local function onRequestSplitInventorySlotDataStack(player, category, inventorySlotPosition, targetInventorySlotPosition, splitAmount)
	splitAmount = splitAmount or 1
	splitAmount = math.floor(splitAmount)

	if splitAmount > 0 then

		local inventorySlotData, trueInventorySlotPosition = onGetPlayerInventorySlotDataByInventorySlotPosition(player, category, inventorySlotPosition)
		if inventorySlotData then
			local itemBaseData = itemLookup[inventorySlotData.id]
			if itemBaseData and itemBaseData.canStack then
				local targetInventorySlotData 	= onGetPlayerInventorySlotDataByInventorySlotPosition(player, category, targetInventorySlotPosition)
				if not targetInventorySlotData then
					local cap 						= math.min((itemBaseData.stackSize or MAX_COUNT_PER_STACK), inventorySlotData.stacks)
					local real_split_amount 		= math.clamp(splitAmount, 1, cap)
					local diff 						= cap - real_split_amount

					local itemDataForInv = {id = inventorySlotData.id; count = real_split_amount}
					table.insert(playerDataContainer[player].inventory, itemDataForInv)

					-- empty stack now :CC
					if diff == 0 then
						table.remove(playerDataContainer[player].inventory, trueInventorySlotPosition)
					else
						inventorySlotData.stacks = inventorySlotData.stacks - real_split_amount
					end

					-- update the inventory slots to assign this new slot a position value
					updateInventorySlots(player)

					-- force an inventory refresh
					onClientRequestPropogateCacheData(player, "inventory")

					return true
				else
					-- targetInventorySlotData is there
					if targetInventorySlotData.id == inventorySlotData.id and targetInventorySlotData.stacks and targetInventorySlotData.stacks < (itemBaseData.stackSize or MAX_COUNT_PER_STACK) then
						local splitDifference = math.clamp(splitAmount, 1, math.min(inventorySlotData.stacks, (itemBaseData.stackSize or MAX_COUNT_PER_STACK)))

						if inventorySlotData.stacks >= splitDifference then
							-- clamp this to not overfill the target slot
							splitDifference = math.clamp(splitDifference, 1, (itemBaseData.stackSize or MAX_COUNT_PER_STACK) - targetInventorySlotData.stacks)

							-- remove from old stack
							if inventorySlotData.stacks - splitDifference == 0 then
								-- diff is zero, remove old stack!!!!!!
								table.remove(playerDataContainer[player].inventory, trueInventorySlotPosition)
							else
								inventorySlotData.stacks = inventorySlotData.stacks - splitDifference
							end

							-- add to new stack
							targetInventorySlotData.stacks = targetInventorySlotData.stacks + splitDifference

							-- update the inventory slots to assign this new slot a position value
							updateInventorySlots(player)

							-- force an inventory refresh
							onClientRequestPropogateCacheData(player, "inventory")

							return true
						end
					end
				end
			end
		end
	else
		addSuspicion(player, 100)
	end

	return false
end

-- todo: further validation, rn it just gives it to them
local function onRequestAddItemToInventoryReceived(player, itemId, stacks, metadata)
	-- default to one stack!
	stacks = stacks or 1


	if playerDataContainer[player] and itemLookup[itemId] then
		local itemBaseData = itemLookup[itemId]
		if itemBaseData then

			-- todo, probably use a copy of inventory to prevent tampering?
			if itemBaseData.canStack then
				while stacks > 0 do
					local currentInventorySlotData = getInventorySlotByItemId(player, itemId, true)

					if currentInventorySlotData then
						local amountTaken = math.clamp(stacks, 1, (itemBaseData.stackSize or MAX_COUNT_PER_STACK) - currentInventorySlotData.stacks)

						currentInventorySlotData.stacks = currentInventorySlotData.stacks + amountTaken

						stacks = stacks - amountTaken
					else
						local amountTaken = math.clamp(stacks, 1, (itemBaseData.stackSize or MAX_COUNT_PER_STACK))

						table.insert(playerDataContainer[player].inventory, {id = itemId; stacks = amountTaken})

						stacks = stacks - amountTaken
					end
				end

				-- update the inventory slots to assign this new slot a position value
				updateInventorySlots(player)

				-- force an inventory refresh
				onClientRequestPropogateCacheData(player, "inventory")

				return true
			else
				stacks = stacks or 1

				local inventoryTransferDataCollection = {} do
					for i = 1, stacks do
						local itemDataForInv = {id = itemId}

						for i, v in pairs(metadata or {}) do
							itemDataForInv[i] = v
						end

						table.insert(inventoryTransferDataCollection, itemDataForInv)
					end
				end

				local hasInventorySpace = int__doesPlayerHaveInventorySpaceForTrade(player, {}, inventoryTransferDataCollection)

				if hasInventorySpace then
					grantPlayerItemsByInventoryTranferData_intermediateCollection(player, inventoryTransferDataCollection)

					-- update the inventory slots to assign this new slot a position value
					updateInventorySlots(player)

					-- force an inventory refresh
					onClientRequestPropogateCacheData(player, "inventory")

					return true
				end
			end
		end
	end

	return false
end

-- todo: check for category
local function onSwitchInventorySlotDataRequestReceived(player, category, inventorySlotNumber1, inventorySlotNumber2)
	if playerDataContainer[player] and inventorySlotNumber1 and inventorySlotNumber2 then
		if inventorySlotNumber1 > 0 and inventorySlotNumber2 > 0 and inventorySlotNumber1 ~= inventorySlotNumber2 and category then
			-- lock the state of the player's Inventory to prevent duplications
			local playerInventoryCopy = utilities.copyTable(playerDataContainer[player].inventory)

			local inventorySlotNumber1_Index
			local inventorySlotNumber2_Index
			for i, inventorySlotData in pairs(playerInventoryCopy) do
				local itemBaseData = itemLookup[inventorySlotData.id]
				if itemBaseData and itemBaseData.category == category then
					if inventorySlotData.position == inventorySlotNumber1 then
						inventorySlotNumber1_Index = i
					elseif inventorySlotData.position == inventorySlotNumber2 then
						inventorySlotNumber2_Index = i
					end
				end
			end

			if inventorySlotNumber1_Index and inventorySlotNumber2_Index then
				playerInventoryCopy[inventorySlotNumber1_Index].position = inventorySlotNumber2
				playerInventoryCopy[inventorySlotNumber2_Index].position = inventorySlotNumber1
			elseif inventorySlotNumber1_Index and not inventorySlotNumber2_Index then
				playerInventoryCopy[inventorySlotNumber1_Index].position = inventorySlotNumber2
			elseif not inventorySlotNumber1_Index and inventorySlotNumber2_Index then
				playerInventoryCopy[inventorySlotNumber2_Index].position = inventorySlotNumber1
			else

				-- request was denied, force a refresh
				onClientRequestPropogateCacheData(player, "inventory")
				return false
			end

			playerDataContainer[player].nonSerializeData.setPlayerData("inventory", playerInventoryCopy)
			return true
		end
	end

	-- request was denied, force a refresh
	onClientRequestPropogateCacheData(player, "inventory")
	return false
end

local function getEquipmentDataByPosition(equipment, position)
	for index, data in pairs(equipment) do
		if data.position == position then
			return data, index
		end
	end
	return nil, nil
end

-- todo make sure equipmentSlotPosition is valid for the weapon being moved, deny if not
local function onTransferInventoryToEquipment(player, category, inventorySlotPosition, equipmentSlotPosition)
	if playerDataContainer[player] and inventorySlotPosition and equipmentSlotPosition then
		if inventorySlotPosition > 0 and equipmentSlotPosition > 0 then

			local playerData = playerDataContainer[player]

			-- we make copies to prevent duplications or to prevent the player from doing something
			-- fishy when the client script is hung waiting for this to return (ie due to ping)
			local playerInventoryCopy = utilities.copyTable(playerData.inventory)
			local playerEquipmentCopy = utilities.copyTable(playerData.equipment)

			local trueInventorySlotPosition
			for i, inventorySlotData in pairs(playerInventoryCopy) do
				local itemBaseData = itemLookup[inventorySlotData.id]
				if itemBaseData and itemBaseData.category == category then
					if inventorySlotData.position == inventorySlotPosition and category then
						if not itemBaseData.minLevel or playerData.level >= itemBaseData.minLevel then
							if not itemBaseData.minimumClass or isPlayerOfClass(player, itemBaseData.minimumClass) then
								trueInventorySlotPosition = i

							else

								return false, "incorrect class"
							end
						else

							return false, "not high enough level"
						end
					end
				else
				end
			end

			local trueEquipmentSlotPosition
			for i, equipmentSlotData in pairs(playerEquipmentCopy) do
				if equipmentSlotData.position == equipmentSlotPosition then
					trueEquipmentSlotPosition = i
				end
			end

			if trueInventorySlotPosition then
				local baseData = itemLookup[playerInventoryCopy[trueInventorySlotPosition].id]

				if baseData.equipmentPosition == mapping.equipmentPosition.arrow then
					print("in arrow exception")
					if not trueEquipmentSlotPosition then
						table.insert(playerEquipmentCopy, {
							position 	= mapping.equipmentPosition.arrow;
							id 			= baseData.id;
							stacks 		= 0;
						})
					else
						playerEquipmentCopy[trueEquipmentSlotPosition].id = baseData.id;
					end

					playerDataContainer[player].nonSerializeData.setPlayerData("equipment", playerEquipmentCopy)

					events:fireEventLocal("playerEquipmentChanged", player)

					return
				end

				-- validate that the equip is ok
				local isWeapon = baseData.equipmentSlot == 1
				local isWeaponSlot = (equipmentSlotPosition == 1) or (equipmentSlotPosition == 11)
				local equippingWeaponToWeaponSlot = isWeapon and isWeaponSlot
				local equippingToExactSlot = baseData.equipmentSlot == equipmentSlotPosition
				local equipLegal = equippingWeaponToWeaponSlot or equippingToExactSlot

				-- only allow berzerkers to equip weapons to offhand
				if baseData.equipmentType == "sword" and equipmentSlotPosition == 11 then
					equipLegal = equipLegal and isPlayerOfClass(player, "berserker")
				end

				-- only allow knights to equip shields to offhand
				if baseData.equipmentType == "shield" and equipmentSlotPosition == 11 then
					equipLegal = equipLegal and isPlayerOfClass(player, "knight")
				end

				-- hunters can equip a dagger and a bow, but not two of each
				if baseData.equipmentType == "dagger" or baseData.equipmentType == "bow" then
					if equipmentSlotPosition == 1 then
						local offhand = getEquipmentDataByPosition(playerEquipmentCopy, 11)
						if offhand then
							offhand = itemLookup[offhand.id]
							if offhand then
								equipLegal = equipLegal and (offhand.equipmentType ~= baseData.equipmentType)
							end
						end

					elseif equipmentSlotPosition == 11 then
						local mainHand = getEquipmentDataByPosition(playerEquipmentCopy, 1)
						if mainHand then
							mainHand = itemLookup[mainHand.id]
							if mainHand then
								equipLegal = equipLegal and (mainHand.equipmentType ~= baseData.equipmentType)
							end
						end
					end
				end

				-- make some offhands illegal
				if equipmentSlotPosition == 11 then
					local equipmentType = baseData.equipmentType
					if
						equipmentType == "staff" or
						equipmentType == "greatsword" or
						equipmentType == "fishing-rod"
					then
						equipLegal = false
					end

				end

				-- no offhands if you're holding a greatsword (unless it's an amulet)
				if equipmentSlotPosition == 11 then
					local mainHand = getEquipmentDataByPosition(playerEquipmentCopy, 1)
					if mainHand then
						mainHand = itemLookup[mainHand.id]
						if mainHand then
							if mainHand.equipmentType == "greatsword" and baseData.equipmentType ~= "amulet" then
								equipLegal = false
							end
						end
					end
				end

				-- no greatswords if you're holding an offhand (unless it's an amulet)
				if equipmentSlotPosition == 1 and baseData.equipmentType == "greatsword" then
					local offhand = getEquipmentDataByPosition(playerEquipmentCopy, 11)
					if offhand then
						offhand = itemLookup[offhand.id]
						if offhand and (offhand.equipmentType ~= "amulet") then
							equipLegal = false
						end
					end
				end

				-- now we can use it
				if not equipLegal then
					return false, "attempt to equip illegal item"
				end
			end

			local function onEquipped(itemId, equipmentSlot)
				local itemData = itemLookup[itemId]
				if itemData.perks then
					for perkName, _ in pairs(itemData.perks) do
						local perkData = perkLookup[perkName]
						if perkData and perkData.onEquipped then
							local success, err = pcall(function()
								perkData.onEquipped(player, itemData, tostring(equipmentSlot))
							end)
							if not success then
								warn(string.format("item %s equip failed because: %s", itemData.name, err))
							end
						end
					end
				end
			end

			local function onUnequipped(itemId, equipmentSlot)
				local itemData = itemLookup[itemId]
				if itemData.perks then
					for perkName, _ in pairs(itemData.perks) do
						local perkData = perkLookup[perkName]
						if perkData and perkData.onUnequipped then
							local success, err = pcall(function()
								perkData.onUnequipped(player, itemData, tostring(equipmentSlot))
							end)
							if not success then
								warn(string.format("item %s unequip failed because: %s", itemData.name, err))
							end
						end
					end
				end
			end

			-- never allow real swapping with arrows
			if equipmentSlotPosition == mapping.equipmentPosition.arrow then
				return false
			end

			if not trueInventorySlotPosition and trueEquipmentSlotPosition then
				-- inventory is empty, equipment is not empty.
				-- move equipment to that slot
				if not int__doesPlayerHaveInventorySpaceForTrade(player, {}, {playerEquipmentCopy[trueEquipmentSlotPosition]}) then
					-- denied, force a refresh
					onClientRequestPropogateCacheData(player, "inventory")
					onClientRequestPropogateCacheData(player, "equipment")

					warn("inventory is full, no go")

					return false
				end

				local equipmentSlotData 	= table.remove(playerEquipmentCopy, trueEquipmentSlotPosition)
				equipmentSlotData.position 	= inventorySlotPosition

				table.insert(playerInventoryCopy, equipmentSlotData)

				playerDataContainer[player].nonSerializeData.setPlayerData("inventory", playerInventoryCopy)
				playerDataContainer[player].nonSerializeData.setPlayerData("equipment", playerEquipmentCopy)

				events:fireEventLocal("playerEquipmentChanged", player)
				onUnequipped(equipmentSlotData.id, equipmentSlotPosition)

				return true
			elseif trueInventorySlotPosition and trueEquipmentSlotPosition then
				-- inventory is not empty, equipment is not empty.
				local inventorySlotData 	= table.remove(playerInventoryCopy, trueInventorySlotPosition)
				inventorySlotData.position 	= equipmentSlotPosition

				local equipmentSlotData 	= table.remove(playerEquipmentCopy, trueEquipmentSlotPosition)
				equipmentSlotData.position 	= inventorySlotPosition

				table.insert(playerInventoryCopy, equipmentSlotData)
				table.insert(playerEquipmentCopy, inventorySlotData)

				playerDataContainer[player].nonSerializeData.setPlayerData("inventory", playerInventoryCopy)
				playerDataContainer[player].nonSerializeData.setPlayerData("equipment", playerEquipmentCopy)

				events:fireEventLocal("playerEquipmentChanged", player)
				onUnequipped(equipmentSlotData.id, equipmentSlotPosition)
				onEquipped(inventorySlotData.id, equipmentSlotPosition)

				return true
			elseif trueInventorySlotPosition and not trueEquipmentSlotPosition then
				-- inventory is not empty, equipment is empty.
				local inventorySlotData 	= table.remove(playerInventoryCopy, trueInventorySlotPosition)
				inventorySlotData.position 	= equipmentSlotPosition

				table.insert(playerEquipmentCopy, inventorySlotData)

				playerDataContainer[player].nonSerializeData.setPlayerData("inventory", playerInventoryCopy)
				playerDataContainer[player].nonSerializeData.setPlayerData("equipment", playerEquipmentCopy)

				events:fireEventLocal("playerEquipmentChanged", player)
				onEquipped(inventorySlotData.id, equipmentSlotPosition)

				return true
			else
				-- wtf?

				--warn("wtf?!?!")

				onClientRequestPropogateCacheData(player, "inventory")
				onClientRequestPropogateCacheData(player, "equipment")
				return false
			end
		end
	end

	warn("straight up denial")

	-- denied, force a refresh
	onClientRequestPropogateCacheData(player, "inventory")
	onClientRequestPropogateCacheData(player, "equipment")
	return false
end

local function swapPlayerWeapons(player)
	local playerData = playerDataContainer[player]
	if not playerData then return end

	local equipment = playerData.equipment
	if not equipment then return end

	local equipmentCopy = utilities.copyTable(equipment)
	local mainHand, mainHandIndex, offhand, offhandIndex

	for index, slotData in pairs(equipmentCopy) do
		if slotData.position == 1 then
			mainHand = itemLookup[slotData.id]
			mainHandIndex = index

		elseif slotData.position == 11 then
			offhand = itemLookup[slotData.id]
			offhandIndex = index
		end
	end

	-- only swap if we have two weapons
	if (not mainHand) or (not offhand) then return end

	local shouldSwap = false

	-- cases where swap is valid, for now only dagger/bow
	if mainHand.equipmentType == "dagger" then
		shouldSwap = offhand.equipmentType == "bow"

	elseif mainHand.equipmentType == "bow" then
		shouldSwap = offhand.equipmentType == "dagger"
	end

	-- perform the swap
	if not shouldSwap then return end

	equipmentCopy[mainHandIndex].position = 11
	equipmentCopy[offhandIndex].position = 1

	playerData.nonSerializeData.setPlayerData("equipment", equipmentCopy)

	local function firePerkEvents(itemData, oldSlot, newSlot)
		if itemData.perks then
			for perkName, _ in pairs(itemData.perks) do
				local perkData = perkLookup[perkName]
				if perkData and perkData.onUnequipped then
					perkData.onUnequipped(player, itemData, oldSlot)
				end
				if perkData and perkData.onEquipped then
					perkData.onEquipped(player, itemData, newSlot)
				end
			end
		end
	end

	firePerkEvents(mainHand, "1", "11")
	firePerkEvents(offhand, "11", "1")

	events:fireEventLocal("playerEquipmentChanged", player)
end
network:create("playerRequest_swapWeapons", "RemoteEvent", "OnServerEvent", swapPlayerWeapons)
network:create("playerRequest_swapWeapons_yielding", "RemoteFunction", "OnServerInvoke", swapPlayerWeapons)

-- Give clients a section of their data file that they can freely modify/read (maybe with some sanity checks)

local function changePlayerSetting(player, setting, value)
	local playerData = getPlayerData(player)
	if playerData and playerData.userSettings then

		-- todo: maybe do some basic sanity checks?
		if type(setting) == "string" and #setting < 40 then

			playerData.userSettings[setting] = value
			onClientRequestPropogateCacheData(player, "userSettings")

			return true
		end

	end
end

network:create("requestChangePlayerSetting","RemoteFunction","OnServerInvoke",changePlayerSetting)
network:create("serverChangePlayerSetting","BindableFunction","OnInvoke",changePlayerSetting)

-- keybind stuff

local function playerRequestSetKeyAction(player,key,action)
	-- validation
	if type(action) == "string"	and #action < 40 then
		-- store the key preference
		local playerData = getPlayerData(player)

		local preferences = playerData.userSettings.keybinds or {}

		-- remove old keybinds
		for key,existingAction in pairs(preferences) do
			if existingAction == action then
				preferences[key] = nil
			end
		end

		preferences[key] = action

		playerData.userSettings.keybinds = preferences
		onClientRequestPropogateCacheData(player, "userSettings")
		return true
	end
end

network:create("playerRequestSetKeyAction","RemoteFunction","OnServerInvoke",playerRequestSetKeyAction)

local function onDamagePlayer(player, damage)
	player.Character.PrimaryPart.health.Value = player.Character.PrimaryPart.health.Value - damage
end

local function getTrueInventorySlotDataByInventorySlotDataFromPlayer(player, inventorySlotDataFromPlayer)
	local playerData = playerDataContainer[player]
	if playerData then
		for trueInventorySlot, inventorySlotData in pairs(playerData.inventory) do
			if inventorySlotData.position == inventorySlotDataFromPlayer.position and inventorySlotData.id == inventorySlotDataFromPlayer.id then
				return trueInventorySlot, inventorySlotData
			end
		end
	end

	return nil, nil
end

local function getTrueEquipmentSlotDataByEquipmentSlotDataFromPlayer(player, equipmentSlotDataFromPlayer)
	local playerData = playerDataContainer[player]
	if playerData then
		local itemBaseDataFromPlayer = itemLookup[equipmentSlotDataFromPlayer.id]
		for trueEquipmentSlot, equipmentSlotData in pairs(playerData.equipment) do
			local itemBaseData = itemLookup[equipmentSlotData.id]
			if equipmentSlotData.position == equipmentSlotDataFromPlayer.position and itemBaseData.category == itemBaseDataFromPlayer.category then
				return trueEquipmentSlot, equipmentSlotData
			end
		end
	end

	return nil, nil
end

network:create("playerAppliedScroll","RemoteEvent")

-- dont mind me just inserting this here

local megaphoneConnection

local isMessagingEnabled, messagingError = pcall(function()
	megaphoneConnection = game:GetService("MessagingService"):SubscribeAsync("megaphone", function(message)
		network:fireAllClients("signal_alertChatMessage", {Text = message.Data; Font = Enum.Font.SourceSansBold; Color = Color3.fromRGB(196, 209, 216)} )
	end)
end)

if not isMessagingEnabled then
	warn("Failed to enable MessagingService", messagingError)
end

local function int__decrementStackSizeForInventorySlotData(player, trueInventorySlotDataPosition, stacksToRemove)
	if not player or not playerDataContainer[player] then return nil end
	stacksToRemove = stacksToRemove or 1

	local inventorySlotData = playerDataContainer[player].inventory[trueInventorySlotDataPosition]
	if inventorySlotData then

		local stacksRemoved = math.clamp(stacksToRemove, 0, inventorySlotData.stacks)
		if inventorySlotData.stacks and inventorySlotData.stacks >= stacksToRemove then
			inventorySlotData.stacks 	= inventorySlotData.stacks - stacksToRemove

			if inventorySlotData.stacks <= 0 then
				table.remove(playerDataContainer[player].inventory, trueInventorySlotDataPosition)
			end
		else
			stacksRemoved = inventorySlotData.stacks
			table.remove(playerDataContainer[player].inventory, trueInventorySlotDataPosition)
		end

		-- update the inventory
		onClientRequestPropogateCacheData(player, "inventory")

		return stacksRemoved
	end

	return 0
end

-- removes _stacks[=1] stacks from inventorySlotData at position `inventorySlotPosition`
local function onRemovePlayerInventorySlotData(player, inventorySlotData, stacksToRemove)
	if not player or not playerDataContainer[player] or not inventorySlotData then return nil end
	local itemBaseData = itemLookup[inventorySlotData.id]
	stacksToRemove = math.clamp(stacksToRemove or 1, 1, (itemBaseData.stackSize or MAX_COUNT_PER_STACK))

	local playerData = playerDataContainer[player]

	local itemBaseData = itemLookup[inventorySlotData.id]
	if itemBaseData then
		if itemBaseData.canStack then
			for inventorySlotPosition, trueInventorySlotData in pairs(playerData.inventory) do
				if trueInventorySlotData.position == inventorySlotData.position and trueInventorySlotData.id == inventorySlotData.id then
					local canRemoveStacksRequested = ((trueInventorySlotData.stacks or 1) - stacksToRemove) >= 0

					if canRemoveStacksRequested then
						if trueInventorySlotData.stacks then
							trueInventorySlotData.stacks = trueInventorySlotData.stacks
						else
						end
					else
						return false
					end
				end
			end
		else
			-- item doesn't stack, can only remove one stack from this item (so entire item)
			if stacksToRemove <= 1 then
				for inventorySlotPosition, trueInventorySlotData in pairs(playerData.inventory) do
					if trueInventorySlotData.position == inventorySlotData.position and trueInventorySlotData.id == inventorySlotData.id then
						table.remove(playerData.inventory, inventorySlotPosition)

						-- update the inventory
						onClientRequestPropogateCacheData(player, "inventory")

						return true
					end
				end
			else
				return false, "attempt to remove more than 1 stack from non-stackable item"
			end
		end
	end

--	if inventorySlotPosition then
--		-- provided inventorySlotPosition, ONLY remove from this stack.
--		for trueInventorySlotDataPosition, inventorySlotData in pairs(playerDataContainer[player].inventory) do
--			if inventorySlotData.id == itemId then
--				local stacksRemoved = int__decrementStackSizeForInventorySlotData(player, trueInventorySlotDataPosition, _stacks)
--
--				warn("straight byebye", stacksRemoved)
--				return true, stacksRemoved
--			end
--		end
--	else
--		local itemBaseData = itemLookup[itemId]
--
--		if itemBaseData.canStack then
--			-- item is stackable and inventorySlotPosition wasn't taken, take from it in order
--			local stackSizeToRemoveLeft = _stacks
--			for trueInventorySlotDataPosition, inventorySlotData in pairs(playerDataContainer[player].inventory) do
--				if inventorySlotData.id == itemId then
--					local stacksRemoved 	= int__decrementStackSizeForInventorySlotData(player, trueInventorySlotDataPosition, stackSizeToRemoveLeft)
--					stackSizeToRemoveLeft 	= stackSizeToRemoveLeft - stacksRemoved
--
--					if stackSizeToRemoveLeft <= 0 then
--						break
--					end
--				end
--			end
--
--			warn("all good")
--			return stackSizeToRemoveLeft < _stacks, _stacks - stackSizeToRemoveLeft
--		else
--			warn("rejecting nil `inventorySlotPosition` for canStack item")
--			return false, 0
--		end
--	end

	warn("just nothing found")
	return false, 0
end

-- let the player be authoritative in this regard, it's their personal data anyway.
local function onRegisterHotbarSlotData(player, dataType, id, position)
	if not playerDataContainer[player] then end

	if not id or not dataType then
		if position then
			local alteration = false
			-- clear out the position for this one
			for i, hotbarSlotData in pairs(playerDataContainer[player].hotbar) do
				if hotbarSlotData.position == position then
					table.remove(playerDataContainer[player].hotbar, i)

					alteration = true
				end
			end

			if alteration then
				-- update the inventory
				onClientRequestPropogateCacheData(player, "hotbar")
				return true
			end
		end
	elseif position then
		-- clear out the position for this one
		for i, hotbarSlotData in pairs(playerDataContainer[player].hotbar) do
			if hotbarSlotData.position == position then
				table.remove(playerDataContainer[player].hotbar, i)
			end
		end

		table.insert(playerDataContainer[player].hotbar, {dataType = dataType; id = id; position = position})

		-- update the inventory
		onClientRequestPropogateCacheData(player, "hotbar")
		return true
	end
end

local seatsTaken = {}

local function isSeatTaken(seat)
	for i,otherSeat in pairs(seatsTaken) do
		if otherSeat == seat then
			return true
		end
	end
end

local function onReplicateClientStateChanged(player, state, stateVariant, otherData)
	-- never replicate the dead state, client is not incharge of this.
	if state == "dead" then
		return false
	end

	stateVariant = stateVariant or ""

	if player.Character and player.Character.PrimaryPart and (player.Character.PrimaryPart.state.Value ~= state or player.Character.PrimaryPart.state.variant.Value ~= stateVariant) and player.Character.PrimaryPart.state.Value ~= "dead" then
		local previousState = player.Character.PrimaryPart.state.Value

		player.Character.PrimaryPart.state.variant.Value 	= stateVariant or ""
		player.Character.PrimaryPart.state.Value 			= state

		-- handle sitting/unsitting
		if state == "sitting" and otherData then
			-- new state is sitting
			local existingSeat = seatsTaken[player.Name]
			if existingSeat then
				game.CollectionService:AddTag(existingSeat,"interact")
				seatsTaken[player.Name] = nil
			end

			if isSeatTaken(otherData) then
				-- tell the client to go away
				player.Character.PrimaryPart.Anchored = false
				player.Character.PrimaryPart:SetNetworkOwner(player)

				return false
			else
				player.Character.PrimaryPart:SetNetworkOwner(nil)
				player.Character.PrimaryPart.Anchored 	= true
				seatsTaken[player.Name] 				= otherData
				game.CollectionService:RemoveTag(otherData, "interact")
			end

			if seatsTaken[player.Name] == otherData then
				player.Character.PrimaryPart.grounder.Position 			= otherData.CFrame.p + Vector3.new(0, 0.5, 0)
				player.Character.PrimaryPart.hitboxVelocity.Velocity 	= Vector3.new()
				player.Character.PrimaryPart.hitboxGyro.CFrame 			= CFrame.new(otherData.CFrame.p + Vector3.new(0, 0.5, 0), otherData.CFrame.p + Vector3.new(0, 0.5, 0) + otherData.CFrame.lookVector)
				player.Character.PrimaryPart.CFrame 					= otherData.CFrame + Vector3.new(0, 0.5, 0)
			end
		elseif previousState == "sitting" then
			if otherData and otherData == "override" then
				return false
			end

			-- old state was sitting
			player.Character.PrimaryPart.Anchored = false
			player.Character.PrimaryPart:SetNetworkOwner(player)

			for userName,seat in pairs(seatsTaken) do
				if userName == player.Name or game.Players:FindFirstChild(userName) == nil then
					game.CollectionService:AddTag(seat,"interact")
					seatsTaken[player.Name] = nil
				end
			end
		elseif state == "gettingUp" and otherData then

			local MINIMUM_DAMAGE = 30
			local MAXIMUM_DAMAGE = 120
			local MINIMUM_DAMAGE_FALL_DISTANCE = 100
			local MAXIMUM_DAMAGE_FALL_DISTANCE = 400

			local playerData = playerDataContainer[player]

			local fallingDistance 	= math.clamp(math.abs(otherData), MINIMUM_DAMAGE_FALL_DISTANCE, MAXIMUM_DAMAGE_FALL_DISTANCE)
			local damageTaken 		= math.floor(MINIMUM_DAMAGE + (MAXIMUM_DAMAGE - MINIMUM_DAMAGE) * ((fallingDistance - MINIMUM_DAMAGE_FALL_DISTANCE) / (MAXIMUM_DAMAGE_FALL_DISTANCE - MINIMUM_DAMAGE_FALL_DISTANCE))) * math.clamp(1 - playerData.nonSerializeData.statistics_final.featherFalling, 0, 1)

			player.Character.PrimaryPart.health.Value = math.clamp(player.Character.PrimaryPart.health.Value - damageTaken, 0, player.Character.PrimaryPart.maxHealth.Value)
		end
	end
end

local function onReplicateClientWeaponStateChanged(player, weaponState)
	if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.weaponState.Value ~= weaponState and player.Character.PrimaryPart.state.Value ~= "dead" then
		local previousState 	= player.Character.PrimaryPart.weaponState.Value
		local playerData 		= playerDataContainer[player]
		local equipmentData 	= onGetPlayerEquipmentDataByEquipmentPosition(player, 1)
		local weaponBaseData 	= equipmentData and itemLookup[equipmentData.id] or nil

		-- block bad requests
		if weaponState ~= nil and weaponState ~= "" then
			if not weaponBaseData then
				return false
			elseif weaponBaseData.equipmentType == "bow" then
				if weaponState ~= "stretched" and weaponState ~= "firing" then
					return false
				end
			else
				return false
			end
		end

		player.Character.PrimaryPart.weaponState.Value = weaponState or ""
	end
end

network:create("playerRequestAlphaGift", "RemoteFunction", "OnServerInvoke")

-- NOTE: This is not the same route that state animations take (ie, walking running etc!)
local function onReplicatePlayerAnimationSequence(player, animationCollection, animationName, extraData)
	if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.state.Value ~= "dead" then
		if playerDataContainer[player] and (animationCollection == "swordAnimations" or animationCollection == "staffAnimations" or animationCollection == "daggerAnimations" or animationCollection == "bowAnimations") then
			extraData = extraData or {}
				extraData.attackSpeed = playerDataContainer[player].nonSerializeData.statistics_final.attackSpeed or 0
		end

		if animationCollection == "staffAnimations" and extraData then
			if player.Character.PrimaryPart.mana.Value < configuration.getConfigurationValue("mageManaDrainFromBasicAttack") then
				extraData.noRangeManaAttack = true
			end
		end

		-- let the server know we are replicating this
		network:fire("playerAnimationReplicated", player, animationCollection, animationName, extraData)

		-- replicate this to other clients
		network:fireAllClientsExcludingPlayer("replicatePlayerAnimationSequence", player, player, animationCollection, animationName, extraData)
	end
end

local function isPlayerNearResetCharacter(player)
	local char = player.Character
	if not char then return false end
	local manifest = char.PrimaryPart
	if not manifest then return false end

	local resetCharacters = game:GetService("CollectionService"):GetTagged("resetCharacter")
	if #resetCharacters == 0 then return false end

	for _, resetCharacter in pairs(resetCharacters) do
		local root = resetCharacter.PrimaryPart
		if root then
			local distance = (manifest.Position - root.Position).Magnitude
			if distance <= 8 then
				return true
			end
		end
	end

	return false
end

local function playerRequest_transferInventoryToStorage(player, inventorySlotData)
	if not configuration.getConfigurationValue("isTradingEnabled", player) then return false, "Storage has been disabled." end
	if math.floor(inventorySlotData.stacks) ~= inventorySlotData.stacks then return false, "MagicRebirthed... BAD!" end
	--if not player:FindFirstChild("QA") then return false, "Only testers can use Storage right now." end
	if not configuration.getConfigurationValue("isStorageEnabled", player) then return false, "Storage is currently disabled" end

	local playerData = playerDataContainer[player]

	if playerData and #playerData.globalData.itemStorage < MAX_STORAGE_COUNT then
		return int__transferInventoryToStorage(player, inventorySlotData)
	elseif playerData then
		return false, "Inventory full."
	end

	return false, "PlayerData not found."
end

local function playerRequest_transferStorageToInventory(player, storageSlotData)
	if not configuration.getConfigurationValue("isTradingEnabled", player) then return false, "Storage has been disabled." end
	if math.floor(storageSlotData.stacks) ~= storageSlotData.stacks then return false, "MagicRebirthed... BAD!" end
	--if not player:FindFirstChild("QA") then return false, "Only testers can use Storage right now." end
	if not configuration.getConfigurationValue("isStorageEnabled", player) then return false, "Storage is currently disabled" end

	local playerData = playerDataContainer[player]

	if playerData then
		return int__transferStorageToInventory(player, storageSlotData)
	end

	return false, "PlayerData not found."
end

local function main()
	network:create("confirmPlayerDeath", "RemoteEvent", "OnServerEvent", onPlayerConfirmDeath)

	-- data manipulation
	network:create("loadPlayerData", "RemoteFunction", "OnServerInvoke", onPlayerAdded)
	network:create("playerRequest_setupPlayerData", "RemoteFunction", "OnServerInvoke", onPlayerAdded)

	network:create("switchInventorySlotData", "RemoteFunction", "OnServerInvoke", onSwitchInventorySlotDataRequestReceived)
	network:create("playerRequest_switchInventorySlotData", "RemoteFunction", "OnServerInvoke", onSwitchInventorySlotDataRequestReceived)

	network:create("transferInventoryToEquipment", "RemoteFunction", "OnServerInvoke", onTransferInventoryToEquipment)
	network:create("playerRequest_transferInventoryToEquipment", "RemoteFunction", "OnServerInvoke", onTransferInventoryToEquipment)

	network:create("playerRequest_transferInventoryToStorage", "RemoteFunction", "OnServerInvoke", playerRequest_transferInventoryToStorage)
	network:create("playerRequest_transferStorageToInventory", "RemoteFunction", "OnServerInvoke", playerRequest_transferStorageToInventory)

	network:create("saveDataForTeleportation", "RemoteFunction", "OnServerInvoke", saveDataForTeleport)
	network:create("playerRequest_savePlayerDataForTeleportation", "RemoteFunction", "OnServerInvoke", saveDataForTeleport)

	network:create("requestAddItemToInventory", "BindableFunction", "OnInvoke", onRequestAddItemToInventoryReceived)

	network:create("teleportPlayerCFrame_server", "BindableFunction", "OnInvoke", function(player, targetCFrame)
		if playerPositionDataContainer[player] and player.Character and player.Character.PrimaryPart then
			playerPositionDataContainer[player].positions = {{position = targetCFrame.p; velocity = Vector3.new()}}
			player.Character.PrimaryPart.CFrame = targetCFrame
		end
	end)

	network:create("dataRecoveryRequested", "RemoteEvent", "OnServerEvent", onDataRecoveryRequested)
	network:create("dataRecoveryGetVersion", "RemoteFunction", "OnServerInvoke", function(player, slot, version)
		local success, playerData, message = datastoreInterface:getPlayerSaveFileData(player, slot, version)

		if not success then
			return false, nil, message
		else
			return true, playerData, ""
		end
	end)
	network:create("dataRecoveryRejected", "RemoteEvent", "OnServerEvent", onDataRecoveryRejected)

	-- data interfacing with client
	network:create("getPropogationCacheLookupTable", "RemoteFunction", "OnServerInvoke", getPropogationCacheLookupTable)

	network:create("propogateCacheDataRequest", "RemoteEvent", "OnServerEvent", onClientRequestPropogateCacheData)

	network:create("clientFlushPropogationCache", "RemoteEvent", "OnServerEvent", onClientRequestFlushPropogationCache)

	network:create("getPlayerEquipment", "RemoteFunction", "OnServerInvoke", onGetPlayerEquipment)
	network:create("playerRequest_getPlayerEquipmentData", "RemoteFunction", "OnServerInvoke", onGetPlayerEquipment)

	network:create("playerEquipmentChanged", "RemoteEvent")

	network:create("requestSplitInventorySlotDataStack", "RemoteFunction", "OnServerInvoke", onRequestSplitInventorySlotDataStack)
	network:create("playerRequest_splitInventorySlotDataStack", "RemoteFunction", "OnServerInvoke", onRequestSplitInventorySlotDataStack)

	network:create("registerHotbarSlotData", "RemoteFunction", "OnServerInvoke", onRegisterHotbarSlotData)
	network:create("playerRequest_getHotbarSlotData", "RemoteFunction", "OnServerInvoke", onRegisterHotbarSlotData)

	network:create("replicateClientStateChanged", "RemoteEvent", "OnServerEvent", onReplicateClientStateChanged)
	network:create("replicateClientWeaponStateChanged", "RemoteEvent", "OnServerEvent", onReplicateClientWeaponStateChanged)

	network:create("playerRequest_equipTemporaryEquipment", "RemoteFunction", "OnServerInvoke", onPlayerRequest_equipTemporaryEquipment)

	-- data interfacing with server
	network:create("getPlayerData", "BindableFunction", "OnInvoke", getPlayerData)
	network:create("getPlayerData_remote", "RemoteFunction", "OnServerInvoke", getPlayerData_remote)
	network:create("getPlayerEquipmentDataByEquipmentPosition", "BindableFunction", "OnInvoke", onGetPlayerEquipmentDataByEquipmentPosition)
	network:create("getPlayerInventorySlotDataByInventorySlotPosition", "BindableFunction", "OnInvoke", onGetPlayerInventorySlotDataByInventorySlotPosition)
	network:create("removePlayerInventorySlotData", "BindableFunction", "OnInvoke", onRemovePlayerInventorySlotData)
	network:create("playerEquipmentChanged_server", "BindableEvent")
	network:create("doesPlayerHaveInventorySpaceForTrade", "BindableFunction", "OnInvoke", int__doesPlayerHaveInventorySpaceForTrade)

	-- data routing
	network:create("replicatePlayerAnimationSequence", "RemoteEvent", "OnServerEvent", onReplicatePlayerAnimationSequence)

	-- events
	network:create("playerCharacterDied", "BindableEvent")
	network:create("alertPlayerNotification","RemoteEvent")

	network:create("playerRequest_incrementPlayerStatPointsByStatName", "RemoteFunction", "OnServerInvoke", incrementPlayerStatPointsByStatName)
	network:create("playerStatisticsChanged", "RemoteEvent")

	network:create("playerRequest_respawnMyCharacter", "RemoteFunction", "OnServerInvoke", onPlayerRequest_respawnMyCharacter)
	network:create("playerRequest_returnToMainMenu", "RemoteFunction", "OnServerInvoke", onPlayerRequest_returnToMainMenu)

	network:create("requestTradeBetweenPlayers", "BindableFunction", "OnInvoke", onTradeRequestReceived)

	-- todo: probably tighten this
	network:create("tradeItemsBetweenPlayerAndNPC", "BindableFunction", "OnInvoke", int__tradeItemsBetweenPlayerAndNPC)

	network:create("playerAnimationReplicated", "BindableEvent")

	network:create("setStamina", "RemoteEvent")

	-- random teleport crap
	network:create("externalTeleport", "RemoteEvent")

	network:create("signal_alertChatMessage", "RemoteEvent")

	network:create("openLoreBookFromServer", "RemoteEvent")

	network:create("playerInventoryChanged_server", "BindableEvent")

	network:create("playerWasExhausted", "RemoteEvent", "OnServerEvent", function()

	end)

	game.Players.PlayerRemoving:connect(onPlayerRemoving)

	game.Players.PlayerAdded:Connect()

	spawn(int__tickForPVP)
	spawn(init__exploitBlock)
end

spawn(main)

return module