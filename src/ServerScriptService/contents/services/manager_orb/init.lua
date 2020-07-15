local collectionService = game:GetService("CollectionService")

local modules = require(game.ReplicatedStorage.modules)
local network = modules.load("network")

local placeIdList do
	-- main game
	if game.GameId == 833209132 then
		placeIdList = {
			2119298605, -- nilgarf
		}
		
	-- free to play
	elseif game.GameId == 712031239 then
		placeIdList = {
			4787415375, -- crabby den
			4042431927, -- enchanted forest
			4041618739, -- great crossroads
			4042399045, -- lost corridor
			4041616995, -- mushroom forest
			4041642879, -- mushroom grotto
			4041449372, -- mushtown
			4042577479, -- nilgarf
			4042595899, -- nilgarf sewers
			4042356215, -- port fidelio
			4042533453, -- redwood pass
			4042327457, -- scallop shores
			4784800626, -- seaside path
			4787417227, -- shiprock bottom
			4786263828, -- spider queen's lair
			4784798551, -- the clearing
			4042381342, -- colosseum
			4042493740, -- tree of life
			4042553675, -- warrior stronghold
		}
	end
end

local orbSpawn do
	local orbSpawnParts = collectionService:GetTagged("orbSpawn")
	assert(#orbSpawnParts == 1, "There must be only one part in the game tagged \"orbSpawn\"")
	
	orbSpawn = Instance.new("Vector3Value")
	orbSpawn.Name = "orbSpawn"
	orbSpawn.Value = orbSpawnParts[1].Position
	orbSpawn.Parent = game:GetService("ReplicatedStorage")
	
	orbSpawnParts[1]:Destroy()
end

local orb = script.orb
local checkForOrbSpawn = true

local function onPlayerAdded(player)
	if orb.Parent == workspace then
		network:fireClient("effects_requestEffect", player, "orbAnnoucement")
	end
end
game.Players.PlayerAdded:Connect(onPlayerAdded)

local function spawnOrb()
	orb:SetPrimaryPartCFrame(CFrame.new(orbSpawn.Value))
	orb.Parent = workspace
	orb.PrimaryPart.loop:Play()
	network:fireAllClients("effects_requestEffect", "orbArrival", {orb = orb})
end

local function despawnOrb()
	network:fireAllClients("effects_requestEffect", "orbDeparture", {orb = orb})
	delay(5, function()
		orb.Parent = script
	end)
end

local function getCurrentDay()
	local vesterianDay = game:GetService("ReplicatedStorage"):FindFirstChild("vesterianDay")
	if not vesterianDay then
		return 0
	end
	
	return math.floor(vesterianDay.Value + 0.5)
end

local function update()
	local clockTime = game.Lighting.ClockTime
	local isNight = (clockTime < 5.9) or (clockTime > 18.6) -- keep synchronized with day night cycle
	
	if isNight then
		if checkForOrbSpawn then
			checkForOrbSpawn = false
			
			local day = getCurrentDay()
			local rand = Random.new(day)
			
			local placeId = placeIdList[rand:NextInteger(1, #placeIdList)]
			if game.PlaceId == placeId then
				spawnOrb()
			end
			
			print("manager_orb chose "..placeId.." as the spawn location. This place is "..game.PlaceId..".")
		end
	else
		if not checkForOrbSpawn then
			checkForOrbSpawn = true
			
			if orb.Parent ~= script then
				despawnOrb()
			end
		end
	end
end

local function startUpdating()
	while true do
		update()
		wait(1)
	end
end

spawn(startUpdating)
spawn(function()
	if game.PlaceId == 2061558182 then
		spawnOrb()
		wait(30)
		despawnOrb()
	end
end)

return {}