-- pets service, duh!
	-- acts as the interfacing between manager_monster and manager_player
	-- to keep track of pets and spawning/despawning them.

local module = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network 		= modules.load("network")
		local utilities 	= modules.load("utilities")
		local physics 		= modules.load("physics")
		local placeSetup 	= modules.load("placeSetup")
		local projectile 	= modules.load("projectile")
		local mapping 		= modules.load("mapping")
		local levels 		= modules.load("levels")
		local pathfinding 	= modules.load("pathfinding")

	local itemData = require(replicatedStorage.itemData)

local playerPetDataCollection = {}
--[[
	playerPetData {}
		int id
		instance manifest
]]--

local function despawnPlayerPet(player)
	if playerPetDataCollection[player] then
		playerPetDataCollection[player].manifest:Destroy()
		playerPetDataCollection[player] = nil
	end
end

local function spawnPlayerPet(player, petEquipmentData)
	if not playerPetDataCollection[player] then
		local petManifest = network:invoke("spawnMonsterPet", player, petEquipmentData.id, petEquipmentData)
		
		local playerPetData = {}
			playerPetData.id 		= petEquipmentData.id
			playerPetData.manifest 	= petManifest
		
		playerPetDataCollection[player] = playerPetData
	end
end

local function getPlayerPetEquipment(player, equipment)
	for i, equipmentData in pairs(equipment) do
		if equipmentData.position == mapping.equipmentPosition.pet then
			return equipmentData
		end
	end
	
	return nil
end

local function int__processPlayerPetEquipmentData(player, petEquipmentData)
	if petEquipmentData and not playerPetDataCollection[player] then
		spawnPlayerPet(player, petEquipmentData)
	elseif not petEquipmentData and playerPetDataCollection[player] then
		despawnPlayerPet(player, petEquipmentData)
	end
end

local function onPlayerEquipmentChanged_server(player, equipment)
	local playerPetEquipmentData = getPlayerPetEquipment(player, equipment)
	
	int__processPlayerPetEquipmentData(player, playerPetEquipmentData)
end

local function onPlayerAdded(player)
	-- get the player's data, waiting until they either leave or 
	-- we successfully fetch their player data
	local playerData do
		while not playerData and player.Parent == game.Players do
			playerData = network:invoke("getPlayerData", player)
			
			wait(0.1)
		end
	end
	
	if playerData then
		onPlayerEquipmentChanged_server(player, playerData.equipment)
	end
end

local function onPlayerRemoving(player)
	if playerPetDataCollection[player] then
		-- despawn pet here!
		
		despawnPlayerPet(player)
	end
	
	playerPetDataCollection[player] = nil
end

local function main()
	for i, player in pairs(game.Players:GetPlayers()) do
		onPlayerAdded(player)
	end
	
	game.Players.PlayerAdded:connect(onPlayerAdded)
	game.Players.PlayerRemoving:connect(onPlayerRemoving)
	
	network:connect("playerEquipmentChanged_server", "Event", onPlayerEquipmentChanged_server)
end

spawn(main)

return module