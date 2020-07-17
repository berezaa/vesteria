--[[
	TODO
	- ensure attackSpeed and attacking in general properly works
	- prevent monsters from stacking on top of each other
		> this probably will stem from another issue where the monsters
		are thrown up sometimes when they cross terrain, likely due to
		roblox physics attempting to prevent the monsters from phasing into
		the terrain around it.
	-
--]]

--[[ NOTICE!!!
	> a bit of terminology so its not as confusing as it seems
	'monster' refers to the in-script class that contains all the monster's
	data

	'manifest' or 'monster manifest' refers to the server representation

	'monster manifest render', 'client entity', 'manifest render' refers
	to what the client sees

	'spawnRegion' is the individual parts that make up a whole region

	'spawnRegionCollection' is a collection of 'spawnRegion'
--]]

-- manages monsters, duh
-- author: Polymorphic

local playerLastMonsterKill = {}
local monsterManager = {}
local monsterClass = {}
-- 'true' makes it so when you get too close
-- it will start moving towards you to attack
-- 'false' makes it so players must attack first
monsterClass.isAggressive = true

-- how close before the monster will aggro
-- onto players (aggressionType must be 'aggressive')
monsterClass.aggressionRange = 35

-- how close the monster will try to get near you
-- before attacking
monsterClass.attackRange = 10

-- time in seconds between each attack
monsterClass.attackSpeed = 10

-- if you're within this amount of studs of the monster, itll detect you regardless of if you're in sight
monsterClass.detectionFromOutOfVisionRange = monsterClass.attackRange * 1.5

-- the amount of radians the monster can see from the front part
-- (this is HALF the full vision length, so double this number to get the real cone)
monsterClass.visionAngle = math.rad(75)

-- once aggro'd, the monster must maintain
-- direct sight of you within this range
-- to continue tracking you, else it'll follow you
-- up until the last position it saw of you.
monsterClass.sightRange = 200

-- 'projectile' makes it so when the monster is
-- within attackRange it will start to shoot projectiles
-- at the player
-- 'physical' makes it so when the monster is within attackRange
-- it will do a physical attack
monsterClass.attackType = "physical"

-- default level of monsters
monsterClass.level = 1

-- the furthest distance the monster will
-- follow the player from where it was before the player ran into it
monsterClass.playerFollowDistance = 50

-- how fast does it walk towards you
monsterClass.baseSpeed = 10

-- TODO: make this stuff work (likely involve creating an internal
-- walkspeed class which is the current speed of the monster
-- and update that based on if its bursting, should be easy)
monsterClass.burstSpeed = 9 --
monsterClass.burstDuration = 0 --
monsterClass.burstCooldown = 0 --

local LAST_MONSTER_UPDATE_CYCLE = tick()
local LAST_MONSTER_UPDATE_CYCLE_END = tick()

local function DEBUG__PRINT(monster, ...)
	if monster.manifest:FindFirstChild("ParticleEmitter") then
		print("***", ...)
	end
end

local httpService = game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local modules = require(replicatedStorage.modules)
local network = modules.load("network")
local utilities = modules.load("utilities")
local physics = modules.load("physics")
local placeSetup = modules.load("placeSetup")
local projectile = modules.load("projectile")
local mapping = modules.load("mapping")
local levels = modules.load("levels")
local pathfinding = modules.load("pathfinding")
local configuration = modules.load("configuration")
local events = modules.load("events")

local itemData = require(replicatedStorage.itemData)
local monsterLookup = require(replicatedStorage.monsterLookup)
local defaultMonsterState = require(replicatedStorage.defaultMonsterState)

-- set the metatable up so that values not set personally
-- to each class are redirected to the
monsterClass.__index = monsterClass

-- amount of time monster will sleep between cycles
local MONSTER_MICRO_SLEEP_TIME 	= 1 / 10

-- if there are no players within this amount of range
-- monster will fall asleep (wont be updated for min amount of time)
local MONSTER_SLEEP_RANGE 				= 150

-- time monster is asleep before another check happens
local MONSTER_SLEEP_TIME 				= 10

-- time between monster roams (roaming involves a bit of raycasting
-- so we don't wanna overdue it)
local MONSTER_ROAMING_TIME 				= 3

-- how often the monster will refresh to find the nearest player
--local MONSTER_PLAYER_CHECK_TIME			= 5

-- the margin of error when approaching a target position
-- we cant get it right on the dot for performance reasons
local MONSTER_END_POSITION_ALPHA 		= 1

local MONSTER_DEATH_TIME  				= 5

-- how much it scales down the monster's hitbox from the model size
-- todo: make this a monster stat, some monster might have odd dilutions
local MONSTER_HITBOX_DILUTION 	= 0.96

local MONSTER_SPAWN_CYCLE_TIME 			= 10

local MONSTER_COLLECTION 				= {}


-- disabled cus pathfinding on roblox terrain is awful
-- todo: maybe fix this, maybe remove it.
local IS_MONSTER_PATHFINDING_ENABLED = true

local itemLookupContainer 	= replicatedStorage.itemData
local itemLookup 			= require(itemLookupContainer)

local runService 	= game:GetService("RunService")
local serverStorage = game:GetService("ServerStorage")

local replicatedStorage 	= game:GetService("ReplicatedStorage")
local pathfindingService 	= game:GetService("PathfindingService")
local collectionService 	= game:GetService("CollectionService")

local SHOW_DEBUG = false

local spawnRegionCollectionData = require(serverStorage.spawnRegionCollectionData)

local spawnRegionCollectionsFolder 		= placeSetup.getPlaceFolder("spawnRegionCollections")
local entityManifestCollectionFolder 	= placeSetup.getPlaceFolder("entityManifestCollection")
local entityRenderCollectionFolder 		= placeSetup.getPlaceFolder("entityRenderCollection")
local itemsFolder 						= placeSetup.getPlaceFolder("items")
local entitiesFolder 					= placeSetup.getPlaceFolder("entities")
local foilage							= placeSetup.getPlaceFolder("foilage")
local activeMonsterLures				= placeSetup.getPlaceFolder("activeMonsterLures")


local MONSTER_RAYCAST_IGNORE_LIST 		= {spawnRegionCollectionsFolder, entityManifestCollectionFolder, entityRenderCollectionFolder, itemsFolder, entitiesFolder, foilage}

-- collection of all monsterStats loaded
local monsterDataCollection = {}

-- collection of the spawnRegion each monster can spawn in
local monsterSpawnRegionCollection = {}

network:create("signal_damage", "RemoteEvent")

network:create("showDebugFor", "RemoteEvent", "OnServerEvent", function(client, part)
	for i,v in pairs(entityManifestCollectionFolder:GetChildren()) do
		if v:FindFirstChild("ParticleEmitter") then
			v.ParticleEmitter:Destroy()
		end
	end

	Instance.new("ParticleEmitter", part)
end)

------------------------
-- INTERNAL FUNCTIONS --
------------------------


local function _isTargetEntityInVisionCone(monster)
	local targetEntity = monster.targetEntity or monster.closestEntity
	if not targetEntity then return false, "no HRP" end

	-- point a cframe in the direction of the part, and get the lookVector
	local rLookVector 	= CFrame.new(monster.manifest.Position, targetEntity.Position).lookVector

	-- find out the degree difference in where the part is facing
	-- to the vector that points directly to the target part from the main part
	local res 			= math.acos(rLookVector:Dot(monster.manifest.CFrame.lookVector))

	-- return true if vectors are 30 degrees off each other at maximum
	-- (for either side, giving a cone of 60 degrees)
	return res <= monster.visionAngle
end

-- return if the monster's targetPlayer is in it's line of sight
function monsterClass:isTargetEntityInLineOfSight(overrideSightRange, useVisionCone, predictiveTargetEntity)
	if self.targetEntity and (self.targetEntityLockType or 0) >= 1 then return true end

	local targetEntity = self.targetEntity or self.closestEntity do
		if predictiveTargetEntity then
			targetEntity = predictiveTargetEntity
		end
	end


	local function wasHit(targetEntity)
		if not targetEntity then return false, "no target HRP" end

		if useVisionCone and not _isTargetEntityInVisionCone(self) and utilities.magnitude(targetEntity.Position - self.manifest.Position) > self.detectionFromOutOfVisionRange then
			return false, "vision cone fail"
		end

		if targetEntity:FindFirstChild("isStealthed") then return false, "player stealthed" end

		local monsterPosition 	= self.manifest.Position
		local dir 				= targetEntity.Position - monsterPosition
		local ray 				= Ray.new(
			monsterPosition,
			dir.unit * math.min(dir.magnitude, overrideSightRange and overrideSightRange or self.sightRange)
		)

		local hitPart, hitPosition = projectile.raycast(
			ray,
			{spawnRegionCollectionsFolder, entityManifestCollectionFolder, entityRenderCollectionFolder, itemsFolder, entitiesFolder, foilage}
		)

		-- return if the hitPart is nil (nothing obstructing) or if the hitPart is
		-- a descendant of the target character (this will include hats and tools)

		return
			hitPart == nil
			or hitPart == targetEntity, tostring(hitPart) .. "was hit"

	end

	if targetEntity then
		if wasHit(targetEntity) then
			self.closestEntity = targetEntity
			self.targetEntity = targetEntity
			return true
		end
	end

	local aggressionRange = self.aggressionRange



	for i, targetEntity in pairs(self.nearbyTargets) do
		if utilities.magnitude(targetEntity.Position - self.manifest.Position) <= aggressionRange  then
			if wasHit(targetEntity) then
				self.closestEntity = targetEntity
				self.targetEntity = targetEntity
				return true
			end
		end

	end
end

-- this functions tells the monsters if the target entity is still good to follow around
function monsterClass:isTargetEntityValid()

end

local function purgeNumericKeys(t)
	local keysToPurge = {}

	for key, value in pairs(t) do
		if typeof(key) ~= "string" then
			table.insert(keysToPurge, key)
		end

		if typeof(value) == "table" then
			purgeNumericKeys(value)
		end
	end

	for _, key in pairs(keysToPurge) do
		local value = t[key]
		t[key] = nil
		t[tostring(key)] = value
	end
end

local function _getMonsterByManifest(monsterManifest, specificProperty)
	for i, monster in pairs(MONSTER_COLLECTION) do
		if monster.manifest == monsterManifest then
			if specificProperty then
				return monster[specificProperty]
			else
				return monster
			end
		end
	end

	return nil
end

local function _getMonsterCountInSpawnRegionCollection(spawnRegionCollection)
	local count = 0
	for i, monster in pairs(MONSTER_COLLECTION) do
		if monster.__SPAWN_REGION_COLLECTION == spawnRegionCollection then
			count = count + 1
		end
	end

	return count
end

local function _getSpawnRegionFromSpawnRegionCollection(spawnRegionCollection)
	local weightTable = {}

	for i, spawnRegion in pairs(spawnRegionCollection:GetChildren()) do
		if spawnRegion:IsA("BasePart") then
			table.insert(weightTable, {
				spawnRegion 	= spawnRegion;

				-- weight based on the volume of the spawnRegion
				-- ignoring the Y axis, that could be extremely variable
				selectionWeight = math.floor(spawnRegion.Size.X * spawnRegion.Size.Z + 0.5);
			})
		end
	end

	return utilities.selectFromWeightTable(weightTable)
end

local spawnPositionGenerator = Random.new()
local function _getPositionFromSpawnRegion(spawnRegion)
	local hitPart, hitPosition
	for i=1,5 do
		local ray = Ray.new(
			(spawnRegion.CFrame * CFrame.new(
				0.9 * spawnPositionGenerator:NextInteger(-spawnRegion.Size.X / 2, spawnRegion.Size.X / 2),
				spawnRegion.Size.Y / 2,
				0.9 * spawnPositionGenerator:NextInteger(-spawnRegion.Size.Z / 2, spawnRegion.Size.Z / 2)
			)).p,
			Vector3.new(0, -spawnRegion.Size.Y, 0)
		)

		hitPart, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, MONSTER_RAYCAST_IGNORE_LIST)

		if hitPart then
			break
		end
	end

	return hitPosition
end

-- Used to figure out how players are spread out around the monster
-- Basically just the magnitude of the average of a bunch of directional unit vectors
-- Includes other useful data like a vector aimed at the point of highest density
-- Used for attack logic that depends on how players are spread out
local function getEntityDensity(monster)
	local directionVector = Vector3.new()
	local avgDistance = 0
	local monsterPos = monster.manifest.Position
	local entities = monster.nearbyTargets

	for _, entity in pairs (entities) do
		local entityPos = entity.position
		local monsterToPlayerCf = CFrame.new(monsterPos, Vector3.new(entityPos.X, monsterPos.Y, entityPos.Z))
		directionVector = directionVector + monsterToPlayerCf.LookVector
		avgDistance = avgDistance + (monsterPos - entityPos).Magnitude
	end
	directionVector = directionVector / #entities

	-- As density approaches 0, players are more evenly spread out
	-- As density approaches 1, players are more concentrated in one area
	return {
		density = directionVector.Magnitude,
		direction = directionVector,
		distance = avgDistance
	}
end

local function _debugShowPath(monster, waypoints)

end

---------------------
-- CLASS FUNCTIONS --
---------------------

function monsterClass:getRoamPositionInSpawnRegion()
	return _getPositionFromSpawnRegion(self.__SPAWN_REGION)
end

--[[
	dropItem(
		dropInformation = {
			lootDropData 	= {id = 1}; -- can include dye, attribute, etc
			dropPosition 	= Vector3.new();
			itemOwners 		= {players}
		},

		physItem = nil,
		lootMulti = 1
	)
]]--

local randoGen = Random.new()
function monsterClass:dropItem(dropInformation, physItem, lootMulti)
	physItem = physItem or nil
	lootMulti = lootMulti or 1

	local item = network:invoke("spawnItemOnGround",dropInformation.lootDropData, dropInformation.dropPosition, dropInformation.itemOwners)
	if item == nil then return false end

	-- monster idol
	if dropInformation.lootDropData.id == 181 then
		local monsterNameTag = Instance.new("StringValue")
		monsterNameTag.Name = "monsterName"
		monsterNameTag.Value = self.module.Name
		monsterNameTag.Parent = item
	end

	-- apply random enchantments to drops:



	if lootMulti > 1 then
		--[[
			local tag = Instance.new("BoolValue")
			tag.Name = "singleOwnerPickup"
			tag.Parent = item
		]]
	end

	local attachmentTarget

	local velo = Vector3.new((randoGen:NextNumber() - 0.5) * 24, (2 + randoGen:NextNumber()) * 30, (randoGen:NextNumber() - 0.5) * 24)
	velo = velo * (1 + ((lootMulti - 1) / 27))

	if item:IsA("BasePart") then
		item.Velocity = velo
		attachmentTarget = item
	elseif item:IsA("Model") and (item.PrimaryPart or item:FindFirstChild("HumanoidRootPart")) then
		local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart")
		if primaryPart then
			primaryPart.Velocity = velo
			attachmentTarget = primaryPart
		end
	end


	return true, item
end

-- internally sets targetPlayer (player monster is following)
-- targetEntityLockType
	-- 0 = regular behaviour
	-- 1 = soft lock, damage will allow targetentity to swap
	-- 2 = semi-soft lock, only damage will allow TargetEntity to be set and manually setting it. will never just roam, will always default to defaulttargetentity
	-- 3 = hard lock, nothing but manually setting target entity will allow targetEntity to be set
function monsterClass:setTargetEntity(targetEntity, resetDueToDeath, targetEntitySetSource, targetEntityLockType)

	if resetDueToDeath then
		self.closestEntity 					= nil
	end

	self.targetEntityLockType = self.targetEntityLockType or 0

	if self.targetEntityLockType >= 3 and self.targetEntityLockType > (targetEntityLockType or 0) then
		return false
	end

	if self.targetEntityLockType <= 2 and targetEntityLockType and targetEntityLockType >= 2 then
		self.defaultTargetEntity = targetEntity
	end

	if not targetEntity and self.defaultTargetEntity then
		self.targetEntity = self.defaultTargetEntity
	else
		self.targetEntity = targetEntity
	end


	self.targetEntitySetSource 	= targetEntitySetSource or nil

	if targetEntityLockType then
		self.targetEntityLockType 	= targetEntityLockType
	end

	-- update objectValue for target
	self.manifest.targetEntity.Value = targetEntity


end

-- set the current state of the monster
function monsterClass:setState(newState, newStateData)
	if self.state == "dead" then return end

	if self.state ~= newState then
		local success, newStateDataJSON = utilities.safeJSONEncode(newStateData or {})

		self.manifest.stateData.Value 	= success and newStateDataJSON or "[]"
		self.manifest.state.Value 		= newState
		self.state 						= newState
	end

	if newState == "dead" then
		network:fire("onMonsterDeath", self.manifest)

		self.manifest.Anchored 		= true
		self.manifest.CanCollide 	= false

		if self.stateMachine and self.stateMachine.onTransition then
			self.stateMachine.onTransition:Destroy()
		end

		-- step dead once
		if self.stateMachine.states.dead and self.stateMachine.states.dead.step then
			self.stateMachine.states.dead.step(self)
		end

		for i, monster in pairs(MONSTER_COLLECTION) do
			if monster == self then
				-- remove from update queue

				table.remove(MONSTER_COLLECTION, i)
				for i, event in pairs(monster.__EVENTS) do
					event:disconnect()
				end

				monster.__EVENTS = nil

				delay(MONSTER_DEATH_TIME, function()
					self.stateMachine.states = nil

					wait(30)

					-- destroy manifest after death timer.
					self.manifest:Destroy()


					-- get rid of states

					-- clear table.
					for i, v in pairs(self) do
						self[i] = nil
					end
				end)

				break
			end
		end
	end
end

-- return mass of the manifest
function monsterClass:getMass(monster)
	return self.manifest:GetMass()
end

function monsterClass:resetPathfinding()
	if self.pathfindingTrigger == "roaming" then
		self.__LAST_ROAM_TIME = tick()
	end

	self.isProcessingPath 	= false
	self.pathfindingTrigger = nil
	self.path 				= nil
	self.currentNode 		= 1
end

-------------------------
-- STATE INSTANTIATION --
-------------------------

local stateMachineFactory = {}

local stateMachine = {}
	stateMachine.__index = stateMachine

local function isMonsterStunned(monster)
	local manifest = monster.manifest

	local guid = utilities.getEntityGUIDByEntityManifest(manifest)
	if not guid then return false end

	local statuses = network:invoke("getStatusEffectsOnEntityManifestByEntityGUID", guid)

	for _, status in pairs(statuses) do
		if status.statusEffectType == "stunned" then
			return true
		end
	end

	return false
end

local function updateMonsterStateMachine(monster)



	-- this should be better, I need more information about how the state machine works
	if isMonsterStunned(monster) then
		monster.manifest.BodyVelocity.Velocity = Vector3.new()
		return
	end

	local stateMachine 		= monster.stateMachine

	-- dead
	if (not stateMachine) or (not stateMachine.states) then
		return
	end

	local currentStateData 	= stateMachine.states[stateMachine.currentState]
	local canSwitchState 	= (not currentStateData.lockTimeForPreventStateTransition or tick() - currentStateData.__START_TIME > currentStateData.lockTimeForPreventStateTransition)

	-- potential stuckage
	local nextState, stateData = currentStateData.step(monster, canSwitchState)

	if nextState and canSwitchState then
		local nextStateData = stateMachine.states[nextState]

		if nextStateData and (not currentStateData.lockTimeForLowerTransition or nextStateData.transitionLevel >= currentStateData.transitionLevel or tick() - currentStateData.__START_TIME >= currentStateData.lockTimeForLowerTransition) then
			stateMachine.onTransition:Fire(stateMachine.currentState, nextState, stateData)

			if currentStateData.verify then
				if monster.targetEntity and monster.targetEntity:FindFirstChild("entityType") and monster.targetEntity.entityType.Value == "monster" then
					currentStateData.verify(monster)
				end
			end

			nextStateData.__START_TIME 	= tick()
			stateMachine.previousState 			= stateMachine.currentState
			stateMachine.currentState 			= nextState
		end
	end
end

function stateMachine:forceStateChange(newState)
	if self.states[newState] then
		self.onTransition:Fire(self.currentState, newState)

		self.states[newState].__START_TIME = tick()
		self.previousState 	= self.currentState
		self.currentState 	= newState
	end
end

function stateMachineFactory.create(monster, startingState, states)
	local newStateMachine = {}
		newStateMachine.states 			= states and utilities.copyTable(states) or {}
		newStateMachine.previousState 	= "initializing"
		newStateMachine.currentState 	= startingState
		newStateMachine.onTransition 	= Instance.new("BindableEvent")

	local defaultMonsterStateMachine = utilities.copyTable(require(replicatedStorage.defaultMonsterState))

	setmetatable(newStateMachine.states, {
		__index = function(_, index)
			return defaultMonsterStateMachine.states[index]
		end
	})

	startingState = startingState or "idling"

	-- initialize the first state
	newStateMachine.states[startingState].__START_TIME = tick()

	return setmetatable(newStateMachine, stateMachine)
end

-------------------------
-- CLASS INSTANTIATION --
-------------------------

local baseHitbox do
	baseHitbox 					= Instance.new("Part")
	baseHitbox.TopSurface 		= Enum.SurfaceType.Smooth
	baseHitbox.BottomSurface 	= Enum.SurfaceType.Smooth
	baseHitbox.Shape 			= Enum.PartType.Ball
	baseHitbox.Transparency 	= 1
	baseHitbox.CanCollide 		= true
	baseHitbox.Anchored 		= false

	local bodyVelocity 		= Instance.new("BodyVelocity", baseHitbox)
	bodyVelocity.MaxForce 	= Vector3.new(100000, 0, 100000)
	bodyVelocity.Velocity 	= Vector3.new(0, 0, 0)

	-- todo: keep bodyGyro so hitbox is always upright, ie cant
	-- be toppled over.
	local bodyGyro 		= Instance.new("BodyGyro", baseHitbox)
	bodyGyro.MaxTorque 	= Vector3.new(1e5, 1e5, 1e5)
	bodyGyro.P 			= 7000
	bodyGyro.D 			= 500

	local bodyForce = Instance.new("BodyForce", baseHitbox)

	-- todo: convert all these ValueBase classes to be stored within a folder
	-- to look cleaner
	local stateValue 	= Instance.new("StringValue", baseHitbox)
	stateValue.Name 	= "state"
	stateValue.Value 	= "sleeping"

	local targetEntity 	= Instance.new("ObjectValue", baseHitbox)
	targetEntity.Name 	= "targetEntity"
	targetEntity.Value 	= nil

	local stateData 	= Instance.new("StringValue", baseHitbox)
	stateData.Name 		= "stateData"
	stateData.Value 	= "[]"

	local entityType 	= Instance.new("StringValue", baseHitbox)
	entityType.Name 	= "entityType"
	entityType.Value 	= "monster"

	local entityId 	= Instance.new("StringValue", baseHitbox)
	entityId.Name 	= "entityId"
	entityId.Value 	= ""

	local statusEffects = Instance.new("StringValue", baseHitbox)
	statusEffects.Name 	= "statusEffectsV2"
	statusEffects.Value = "{}"

	local stanceValue 	= Instance.new("StringValue", baseHitbox)
	stanceValue.Name 	= "stance"

	local maxHealthValue 	= Instance.new("NumberValue", baseHitbox)
	maxHealthValue.Name 	= "maxHealth"
	maxHealthValue.Value 	= 100

	local healthValue 	= Instance.new("NumberValue", baseHitbox)
	healthValue.Name 	= "health"
	healthValue.Value 	= 100

	local levelValue 	= Instance.new("IntValue", baseHitbox)
	levelValue.Name		= "level"
	levelValue.Value 	= 1

	collectionService:AddTag(baseHitbox, "monster")
	physics:setWholeCollisionGroup(baseHitbox, "monsters")
end

local blacklistedSpawnRegion = {}
local function setIsSpawnRegionCollectionDisabled(spawnRegionCollection, isDisabled)
	blacklistedSpawnRegion[spawnRegionCollection.Name] = isDisabled
end

function monsterManager:getSpawnRegionCollectionsUnderPopulated()
	local spawnRegionsCollection_underpopulated = {}

	for i, spawnRegionCollection in pairs(spawnRegionCollectionsFolder:GetChildren()) do
		if spawnRegionCollection.Name ~= "Pets" and not blacklistedSpawnRegion[spawnRegionCollection.Name] then
			local monsterType, monsterSpawnAmount = string.match(spawnRegionCollection.Name, "(.+)-(%d+)")

			local isUnderpopulated = false


			--local playerDensityFactor = 0.25 + (#game.Players:GetPlayers() / (game.Players.MaxPlayers * 0.75))
			--playerDensityFactor = math.min(playerDensityFactor, 1.25)
			local playerDensityFactor = 1

			if runService:IsRunMode() or runService:IsStudio() then
				playerDensityFactor = 0.75
			end

			-- night time!
			if game.Lighting.ClockTime < 5.9 or game.Lighting.ClockTime > 18.6 then
				playerDensityFactor = playerDensityFactor * 1.5
			end

			if monsterType and monsterSpawnAmount then
				monsterSpawnAmount = math.ceil(tonumber(monsterSpawnAmount) * playerDensityFactor)

				if _getMonsterCountInSpawnRegionCollection(spawnRegionCollection) < monsterSpawnAmount then
					isUnderpopulated = true
				end
			end

			if isUnderpopulated then
				table.insert(spawnRegionsCollection_underpopulated, {monsterNameToSpawn = monsterType; spawnRegionCollection = spawnRegionCollection})
			end
		end
	end

	return spawnRegionsCollection_underpopulated
end

-- fetches the real clientEntity (not a clone!)
function monsterManager.getRealClientEntity(monsterName)
	if monsterLookup[monsterName] then
		return monsterLookup[monsterName].entity:Clone()
	end
end

local extentsCache = {}

-- generates the server entity of the monster
function monsterManager.getMonsterManifestFromClientEntity(realMonsterClientEntity, baseStats, monsterName)
	if realMonsterClientEntity and baseStats then
		-- generate hitbox
		local hitBox = baseHitbox:Clone()
		hitBox.Name = monsterName

		local extent = extentsCache[monsterName]
		if extent == nil then
			extent = realMonsterClientEntity:GetExtentsSize()
			extentsCache[monsterName] = extent
		end

		hitBox.Size = Vector3.new(extent.Y, extent.Y, extent.Y) * (baseStats.hitboxDilution or MONSTER_HITBOX_DILUTION)

		return hitBox
	else
		warn("realMonsterClientEntity", realMonsterClientEntity, "baseStats", baseStats)
	end
end

-- returns the baseStats of the monster
-- based on the moduleScript of that name
function monsterManager.getMonsterBaseStats(monsterName)
	return monsterLookup[monsterName]
end

local rand = Random.new(os.time())

local function isNightTime(guard)

	-- DANGER!
	if game.Lighting.ClockTime < 5.9 or game.Lighting.ClockTime > 18.6 then
		return true
	end

	if not guard and not configuration.getConfigurationValue("doUseNightTimeGiantSpawn") then
		-- its always nighttime in derry
		return true
	elseif guard and not configuration.getConfigurationValue(guard) then
		-- you'll float too!
		return true
	end

	return game.Lighting.ClockTime > 18.3 or game.Lighting.ClockTime < 6
end

-- generate new monster class to interface with the
-- control script
function monsterManager.new(monsterName, spawnLocation, spawnRegionCollection, spawnRegion, _additionalStats, postInitCallback)
	if not monsterName then return end

	local baseStats = monsterManager.getMonsterBaseStats(monsterName)
	local clientEntity = monsterManager.getRealClientEntity(monsterName)
	local manifest = monsterManager.getMonsterManifestFromClientEntity(clientEntity, baseStats, monsterName)

	-- return if manifest is nil (no model for this thing)
	if not manifest then warn("no manifest for " .. tostring(monsterName)) return end

	-- default baseStats to internal defaults
	if not baseStats then baseStats = {} end

	if not clientEntity then return false end

	-- set name of manifest
	manifest.Name = monsterName
	manifest.entityId.Value = monsterName

	local newMonster = {}
	newMonster.monsterName = monsterName

	-- internal variables --
	newMonster.__LAST_UPDATE = tick()
	newMonster.__LAST_ATTACK_TIME = 0
	newMonster.__LAST_GRAVITY_RAYCAST_UPDATE = 0
	newMonster.__LAST_POSITION_SEEN = nil
	newMonster.__LAST_MOVE_DIRECTION = nil
	newMonster.__SPAWN_REGION_COLLECTION = spawnRegionCollection
	newMonster.__SPAWN_REGION = spawnRegion
	newMonster.__LAST_ROAM_TIME = 0
	newMonster.__IS_WAITING_FOR_PATH_FINDING = false
	newMonster.__EVENTS = {}
	newMonster.__MONSTER_EVENTS = baseStats.monsterEvents or {}
	newMonster.__STATE_OVERRIDES = baseStats.stateOverrides or {}

	-- state variables --
	newMonster.currentNode = 1
	newMonster.specialsUsed = 0
	newMonster.isProcessingPath = false
	newMonster.origin = nil
	newMonster.state = "sleeping"
	newMonster.roamingTargetPosition = nil
	newMonster.targetEntity = nil
	newMonster.maxHealth = baseStats.maxHealth
	newMonster.health = baseStats.maxHealth
	newMonster.level = baseStats.level

	-- identity variables
	newMonster.manifest = manifest
	newMonster.clientEntity = monsterManager.getRealClientEntity(monsterName)

	-- apply monster baseStats
	for baseStat, baseStatValue in pairs(baseStats) do
		newMonster[baseStat] = baseStatValue
		newMonster["_" .. baseStat] = baseStatValue
	end

	if (not _additionalStats or not _additionalStats.variation) and isNightTime("doSpawnNightTimeVariants") then
		-- todo: merge this draft too
	end

	if _additionalStats then
--		variation = "poisoned"
		local variation = _additionalStats.variation
		local variationStats = variation and baseStats.variations[variation]

		-- signal to the game what kind of variation this is
		newMonster.variation = variation

		if variationStats then
			for stat, statValue in pairs(variationStats) do
				newMonster[stat] = statValue
			end
		end

		for additionalStat, additionalStateValue in pairs(_additionalStats) do
			newMonster[additionalStat] = additionalStateValue
		end
	end

	local statesLookup = monsterLookup[monsterName].statesData
	local monsterStateMachine = stateMachineFactory.create(newMonster, statesLookup.default, statesLookup.states)
	newMonster.stateMachine = monsterStateMachine

	local spawnCFrame
	if spawnLocation then
		if typeof(spawnLocation) == "CFrame" then
			spawnCFrame = spawnLocation + Vector3.new(0, newMonster.manifest.Size.Y, 0)
		elseif typeof(spawnLocation) == "Vector3" then
			spawnCFrame = CFrame.new(spawnLocation) + Vector3.new(0, newMonster.manifest.Size.Y, 0)
		elseif typeof(spawnLocation) == "Instance" and spawnLocation:IsA("BasePart") then
			spawnCFrame = spawnLocation.CFrame + Vector3.new(0, newMonster.manifest.Size.Y, 0)
		end

		spawnCFrame = spawnCFrame
	else
		warn("spawnLocation was nil")
	end

	spawnCFrame = spawnCFrame * CFrame.Angles(0, math.rad(math.random(1,360)), 0)

	if spawnCFrame then
		newMonster.manifest.CFrame = spawnCFrame
		newMonster.origin = spawnCFrame
	else
		warn("invalid spawnLocation given")
	end

	local transitionEvent = monsterStateMachine.onTransition.Event:connect(function(old, new, newStateData)
		if manifest:FindFirstChild("ParticleEmitter") then

		end

--		if monsterStateMachine.states[new].animationTriggersDamage then
--			if newMonster.targetEntity then
--				network:fire("reportMonsterInDamageState_server", monsterName, manifest, newMonster.targetEntity)
--			end
--		end

		if monsterStateMachine.states[new].execute_server then
			spawn(function()
				monsterStateMachine.states[new].execute_server(newMonster)
			end)
		end

		newMonster:setState(new, newStateData)

		if baseStats.monsterEvents and baseStats.monsterEvents.onStateChanged then
			baseStats.monsterEvents.onStateChanged(newMonster, old, new)
		end
	end)

	table.insert(newMonster.__EVENTS, transitionEvent)

	-- set the metatable
	setmetatable(newMonster, monsterClass)

	-- step it up
	updateMonsterStateMachine(newMonster)

	-- spawn the monster based on the data type of the
	-- spawnLocation given

	-- attempt to correct for the monsters constantly being thrusted upward

	newMonster.healthMulti = newMonster.healthMulti or 1
	newMonster.bonusXPMulti = newMonster.bonusXPMulti or 1
	newMonster.damageMulti = newMonster.damageMulti or 1
	newMonster.goldMulti = newMonster.goldMulti or 1
	newMonster.bonusLootMulti = newMonster.bonusLootMulti or 1
	newMonster.attackRange = newMonster.attackRange or 1

	-- night time!

	local nighttime

	if game.Lighting.ClockTime < 5.9 or game.Lighting.ClockTime > 18.6 then
		if not ( _additionalStats and _additionalStats.level) then
			newMonster.nightboosted = true
			newMonster.level = newMonster.level + 1
			newMonster.healthMulti = newMonster.healthMulti * 1.25
			newMonster.damageMulti = newMonster.damageMulti * 1.25
			newMonster.bonusXPMulti = newMonster.bonusXPMulti * 1.25
			newMonster.bonusLootMulti = newMonster.bonusLootMulti * 1.25
			newMonster.goldMulti = newMonster.goldMulti * 1.25
			newMonster.aggressionRange = newMonster.aggressionRange * 2
			newMonster.attackSpeed = newMonster.attackSpeed * 0.8
			newMonster.playerFollowDistance = newMonster.playerFollowDistance * 2
			newMonster.baseSpeed = newMonster.baseSpeed * 1.1
			newMonster.attackRange = newMonster.attackRange * 1.1
			newMonster.detectionFromOutOfVisionRange = newMonster.detectionFromOutOfVisionRange * 2
			newMonster.visionAngle = newMonster.visionAngle * 1.25
		end
	end

	if newMonster.gigaGiant then
		if not ( _additionalStats and _additionalStats.level) then
			newMonster.level = newMonster.level + 3
		end

		newMonster.scale 				= 5
		newMonster.IS_MONSTER_ENRAGED 	= true

		local monsterManifest 	= newMonster.manifest
		monsterManifest.Size 	= monsterManifest.Size * 5

		local scaleTag 		= Instance.new("NumberValue")
		scaleTag.Name 		= "monsterScale"
		scaleTag.Value 		= 5
		scaleTag.Parent 	= monsterManifest

		newMonster.healthMulti = newMonster.healthMulti * 1000

--		newMonster.maxHealth 	= (newMonster.maxHealth or 1) * 1000
--		newMonster.health 		= newMonster.maxHealth

		newMonster.bonusLootMulti 	= 30
		newMonster.bonusXPMulti 	= newMonster.bonusXPMulti * 500
		newMonster.goldMulti 		= (newMonster.goldMulti or 1) * 3.5

		monsterManifest.maxHealth.Value = newMonster.maxHealth
		monsterManifest.health.Value 	= newMonster.health

		newMonster.damageMulti = (newMonster.damageMulti or 1) * 5

		newMonster.attackRange = (newMonster.attackRange or 0) * 5.1
	elseif newMonster.superGiant or ((not newMonster.dontScale and not newMonster.boss) and (isNightTime() and rand:NextInteger(1,7500) == 13)) then

		newMonster.scale = 3
		newMonster.superGiant = true
		newMonster.IS_MONSTER_ENRAGED 	= true

		if not ( _additionalStats and _additionalStats.level) then
			newMonster.level = newMonster.level + 2
		end

		local monsterManifest 	= newMonster.manifest
		monsterManifest.Size 	= monsterManifest.Size * 3

		local scaleTag 		= Instance.new("NumberValue")
		scaleTag.Name 		= "monsterScale"
		scaleTag.Value 		= 3
		scaleTag.Parent 	= monsterManifest

		newMonster.healthMulti = newMonster.healthMulti * 250

--		newMonster.maxHealth 	= (newMonster.maxHealth or 1) * 250
--		newMonster.health 		= newMonster.maxHealth

		newMonster.bonusLootMulti 	= 20
		newMonster.bonusXPMulti 	= newMonster.bonusXPMulti * 125
		newMonster.goldMulti 		= (newMonster.goldMulti or 1) * 3

		monsterManifest.maxHealth.Value = newMonster.maxHealth
		monsterManifest.health.Value 	= newMonster.health

		newMonster.damageMulti = (newMonster.damageMulti or 1) * 2.5

		newMonster.attackRange = (newMonster.attackRange or 0) * 3
	elseif newMonster.giant or ((not newMonster.dontScale and not newMonster.boss) and (isNightTime() and rand:NextInteger(1, 750) == 13)) then -- 1, 1000, 777

		newMonster.giant = true
		newMonster.IS_MONSTER_ENRAGED 	= true

		if not ( _additionalStats and _additionalStats.level) then
			newMonster.level = newMonster.level + 1
		end

		newMonster.scale = 2

		local monsterManifest 	= newMonster.manifest
		monsterManifest.Size 	= monsterManifest.Size * 2

		local scaleTag 		= Instance.new("NumberValue")
		scaleTag.Name 		= "monsterScale"
		scaleTag.Value 		= 2
		scaleTag.Parent 	= monsterManifest

		newMonster.healthMulti = newMonster.healthMulti * 70

--		newMonster.maxHealth 	= (newMonster.maxHealth or 1) * 50
--		newMonster.health 		= newMonster.maxHealth

		newMonster.bonusLootMulti 	= 10

		newMonster.bonusXPMulti 	= newMonster.bonusXPMulti * 35
		newMonster.goldMulti 		= (newMonster.goldMulti or 1) * 2.5

		monsterManifest.maxHealth.Value = newMonster.maxHealth
		monsterManifest.health.Value 	= newMonster.health

		newMonster.damageMulti = (newMonster.damageMulti or 1) * 1.75


		newMonster.attackRange = (newMonster.attackRange or 0) * 2
	elseif newMonster.scale then
		local scale = newMonster.scale

		local monsterManifest 	= newMonster.manifest
		monsterManifest.Size 	= monsterManifest.Size * scale

		local scaleTag 		= Instance.new("NumberValue")
		scaleTag.Name 		= "monsterScale"
		scaleTag.Value 		= scale
		scaleTag.Parent 	= monsterManifest

		newMonster.attackRange = (newMonster.attackRange or 0) * scale
	else
		-- random size variation
		local scale = 1 + rand:NextInteger(-5,5)/100

		newMonster.scale = scale

		local monsterManifest 	= newMonster.manifest
		monsterManifest.Size 	= monsterManifest.Size * scale

		local scaleTag 		= Instance.new("NumberValue")
		scaleTag.Name 		= "monsterScale"
		scaleTag.Value 		= scale
		scaleTag.Parent 	= monsterManifest

		newMonster.attackRange = (newMonster.attackRange or 0) * scale
	end

	if newMonster.giant or newMonster.superGiant or newMonster.gigaGiant or newMonster.boss or newMonster.resilient then
		local resilientTag = Instance.new("BoolValue")
		resilientTag.Name = "resilient"
		resilientTag.Value = true
		resilientTag.Parent = newMonster.manifest
	end

	if postInitCallback then
		postInitCallback(newMonster)
	end

	newMonster.maxHealth = newMonster.maxHealth * (newMonster.healthMulti or 1);
	newMonster.health = newMonster.maxHealth * (newMonster.healthMulti or 1);
	newMonster.damage = newMonster.damage * (newMonster.damageMulti or 1);

	manifest.BodyForce.Force = Vector3.new(0, newMonster.floats and 0 or -196.2 * manifest:getMass(), 0)
	manifest.BodyVelocity.MaxForce = Vector3.new(100 * manifest:getMass(), newMonster.flies and 100 * manifest:getMass() or 0, 100 * manifest:getMass()) * 100 * (baseStats.velocityMaxForceMultiplier or 1)

	manifest.CustomPhysicalProperties = PhysicalProperties.new(newMonster.density or 5, newMonster.friction or 0.4, newMonster.elasticity or 0.2)

	if newMonster.specialName then
		local nameTag = Instance.new("StringValue")
		nameTag.Name = "specialName"
		nameTag.Value = newMonster.specialName
		nameTag.Parent = manifest
	end

	if newMonster.notGiant then
		local notGiantTag = Instance.new("BoolValue")
		notGiantTag.Name = "notGiant"
		notGiantTag.Value = true
		notGiantTag.Parent = manifest
	end

	if newMonster.alwaysRendered then
		local alwaysRenderedTag = Instance.new("BoolValue")
		alwaysRenderedTag.Name = "alwaysRendered"
		alwaysRenderedTag.Value = true
		alwaysRenderedTag.Parent = manifest
	end

	if newMonster.isPassive then
		local isPassiveTag 	= Instance.new("BoolValue")
		isPassiveTag.Name 	= "isPassive"
		isPassiveTag.Value 	= true
		isPassiveTag.Parent = manifest
	end

	if newMonster.hideLevel then
		local hideLevelTag 	= Instance.new("BoolValue")
		hideLevelTag.Name 	= "hideLevel"
		hideLevelTag.Value 	= true
		hideLevelTag.Parent = manifest
	end

	if newMonster.isDamageImmune then
		local isDamageImmuneTag 	= Instance.new("BoolValue")
		isDamageImmuneTag.Name 		= "isDamageImmune"
		isDamageImmuneTag.Value 	= true
		isDamageImmuneTag.Parent 	= manifest
	end

	if newMonster.dye then
		local monsterColorVariantTag 	= Instance.new("Color3Value")
		monsterColorVariantTag.Name 	= "colorVariant"
		monsterColorVariantTag.Value 	= Color3.fromRGB(newMonster.dye.r, newMonster.dye.g, newMonster.dye.b)
		monsterColorVariantTag.Parent 	= manifest
	end

	if newMonster.isTargetImmune then
		local isTargetImmune 	= Instance.new("BoolValue")
		isTargetImmune.Name 	= "isTargetImmune"
		isTargetImmune.Value 	= true
		isTargetImmune.Parent 	= manifest
	end

	manifest.maxHealth.Value 		= newMonster.maxHealth
	manifest.health.Value 			= newMonster.health
	manifest.level.Value 			= newMonster.level

	local entityGUIDTag = Instance.new("StringValue")
	entityGUIDTag.Name = "entityGUID"
	entityGUIDTag.Value = httpService:GenerateGUID(false)
	entityGUIDTag.Parent = manifest

	manifest.Parent = entityManifestCollectionFolder
	manifest:SetNetworkOwner(nil)

	if (newMonster.scale >= 1.4) and (not newMonster.notGiant) then
		game.CollectionService:AddTag(manifest, "giantEnemy")
	end

	if baseStats.boss then
		manifest.BodyForce.Force = Vector3.new()

		local hitPart, hitPos = projectile.raycastForProjectile(
			Ray.new(
				spawnCFrame.p,
				Vector3.new(0, -300, 0)
			), {workspace.placeFolders}
		)
		--[[
		local downForce 	= Instance.new("BodyPosition")
		downForce.Name 		= "bossDownForce"
		downForce.Position 	= Vector3.new(0, hitPos.Y + newMonster.manifest.Size.Y / 2 + 0.5, 0)
		downForce.MaxForce 	= Vector3.new(0, math.huge, 0)
		downForce.Parent 	= manifest
		]]
	end

	-- give ownership to the server if we're using accuratemonsterhitbox
	-- we don't want it falling through the ground :smile:
	if baseStats.useAccurateMonsterHitbox then
		manifest:SetNetworkOwner(nil)
	end

	-- handle monster variant stuff --
	events:fireEventLocal("monsterEntitySpawning", newMonster)

	-- register this new monster internally
	-- to be updated by the scheduler
	table.insert(MONSTER_COLLECTION, newMonster)

	return newMonster
end

function monsterManager.new_Pet(player, id, petEquipmentData)
	if not id then return end
	if not itemLookup[id] then return end

	local baseStats 	= itemLookup[id]
	local clientEntity 	= itemLookup[id].entity
	local manifest 		= monsterManager.getMonsterManifestFromClientEntity(clientEntity, baseStats, clientEntity.Name)

	-- return if manifest is nil (no model for this thing)
	if not manifest then warn("no manifest for pet " .. tostring(baseStats.name)) return end

	-- default baseStats to internal defaults
	if not baseStats then baseStats = {} end

	if not clientEntity then return false end

	-- name manifest
	manifest.Name 			= baseStats.name
	manifest.entityId.Value = id

	local newMonster = {}
		newMonster.monsterName = baseStats.name

		-- internal variables --
		newMonster.__LAST_UPDATE 					= tick()
		newMonster.__EVENTS 						= {}

		-- state variables --
		newMonster.owner 		= player
		newMonster.isMonsterPet = true

		-- identity variables
		newMonster.manifest 		= manifest
		newMonster.clientEntity 	= clientEntity

	manifest.BodyForce.Force 		= Vector3.new(0, -196.2 * manifest:getMass(), 0)
	manifest.BodyVelocity.MaxForce 	= Vector3.new(100 * manifest:getMass(), 0, 100 * manifest:getMass()) * 100 * (baseStats.velocityMaxForceMultiplier or 1)

	local statesLookup 			= baseStats.statesData
	local monsterStateMachine 	= stateMachineFactory.create(newMonster, statesLookup.default, statesLookup.states)
	newMonster.stateMachine 	= monsterStateMachine



	manifest.CustomPhysicalProperties = PhysicalProperties.new(newMonster.density or 5, newMonster.friction or 0.4, newMonster.elasticity or 0.2)

	local transitionEvent = monsterStateMachine.onTransition.Event:connect(function(old, new, newStateData)
		newMonster:setState(new, newStateData)
	end)

	table.insert(newMonster.__EVENTS, transitionEvent)

	-- set the metatable
	setmetatable(newMonster, monsterClass)

	-- tag it as a pet so clients know..
	local monsterPetTag 	= Instance.new("IntValue")
	monsterPetTag.Name 		= "pet"
	monsterPetTag.Value 	= id
	monsterPetTag.Parent 	= manifest

	manifest.entityType.Value = "pet"

	physics:setWholeCollisionGroup(manifest, "passthrough")

	if petEquipmentData and petEquipmentData.customName then
		local monsterNicknameTag 	= Instance.new("StringValue")
		monsterNicknameTag.Name 	= "nickname"
		monsterNicknameTag.Value 	= petEquipmentData.customName
		monsterNicknameTag.Parent 	= manifest.entityId
	end

	if petEquipmentData and petEquipmentData.dye then
		local monsterColorVariantTag 	= Instance.new("Color3Value")
		monsterColorVariantTag.Name 	= "colorVariant"
		monsterColorVariantTag.Value 	= Color3.fromRGB(petEquipmentData.dye.r, petEquipmentData.dye.g, petEquipmentData.dye.b)
		monsterColorVariantTag.Parent 	= manifest
	end

	-- step it up
	updateMonsterStateMachine(newMonster)

	local entityGUIDTag = Instance.new("StringValue")
	entityGUIDTag.Name = "entityGUID"
	entityGUIDTag.Value = httpService:GenerateGUID(false)
	entityGUIDTag.Parent = manifest

	-- parent and set ownership to server
	manifest.Parent = entityManifestCollectionFolder
	manifest:SetNetworkOwner(nil)

	-- register this new monster internally
	-- to be updated by the scheduler
	table.insert(MONSTER_COLLECTION, newMonster)

	return newMonster
end

local giantEnemyScale = 2


local idolCaps = {
	["1"] = 5;
	["2"] = 10;
	["3"] = 15;
	["4"] = 20;
	["5"] = 25;
	["6"] = 30;
	["99"] = 15;
}

-- NOTE: This spawns a monster while respecting spawnRegion's
-- spawn limits.
-- TODO: finish this
function monsterManager.spawn(monsterName, spawnRegionCollection, _spawnPosition, additionalData, postInitCallback)
	-- make sure we can spawn the monster here...
	if spawnRegionCollection then
		local spawnRegionSelection = _getSpawnRegionFromSpawnRegionCollection(spawnRegionCollection)

		if spawnRegionSelection then
			local spawnRegion = spawnRegionSelection.spawnRegion
			additionalData = additionalData or {}

			for _,valueObject in pairs(spawnRegionCollection:GetChildren()) do
				if valueObject:IsA("ValueBase") then
					if valueObject:FindFirstChild("JSON") then
						additionalData[valueObject.Name] = game.HttpService:JSONDecode(valueObject.Value)
					else
						additionalData[valueObject.Name] = valueObject.Value
					end
				end
			end

			local spawnPosition = _spawnPosition or _getPositionFromSpawnRegion(spawnRegion)
			local newMonster = monsterManager.new(monsterName, spawnPosition, spawnRegionCollection, spawnRegion, additionalData, postInitCallback)

			----------------- handle monster stuff

			return newMonster
		end
	elseif _spawnPosition then
		local newMonster = monsterManager.new(monsterName, _spawnPosition, nil, nil, additionalData, postInitCallback)

		return newMonster
	end
end

function monsterManager.spawnPet(player, id, ...)
	return monsterManager.new_Pet(player, id, ...)
end

local function onSpawnMonster(monsterName, spawnPosition, spawnRegionCollection, additionalData, postInitCallback)
	return monsterManager.spawn(monsterName, spawnRegionCollection, spawnPosition, additionalData, postInitCallback)
end

network:create("spawnMonster", "BindableFunction", "OnInvoke", onSpawnMonster)

local function onSpawnMonsterPet(player, id, ...)
	local monsterPet = monsterManager.spawnPet(player, id, ...)

	return monsterPet.manifest
end

local monsterIdolModelCache = Instance.new("Folder")
monsterIdolModelCache.Name = "monsterIdolModelCache"
monsterIdolModelCache.Parent = game.ReplicatedStorage

------------------------
-- MAIN PROCESS LOGIC --
------------------------

local function onMonsterRemoved(monsterManifest)
	for i, monster in pairs(MONSTER_COLLECTION) do
		if monster.manifest == monsterManifest then
			table.remove(MONSTER_COLLECTION, i)

			if monster.__EVENTS then
				for i, event in pairs(monster.__EVENTS) do
					event:disconnect()
				end
			end

			if monster.stateMachine and monster.stateMachine.onTransition then
				monster.stateMachine.onTransition:Destroy()
			end

			monster.__EVENTS = nil

			-- get rid of states
			monster.stateMachine.states = nil

			-- clear table.
			for i, v in pairs(monster) do
				monster[i] = nil
			end

			break
		end
	end
end

local rand = Random.new(os.time())

local monsterStateRegistry = {}

local function int__getMonsterStateInformation(monster)
	return {
		["previous-state"] 	= monster.stateMachine.previousState;
		["current-state"] 	= monster.stateMachine.currentState;
		["name"] 			= monster.monsterName;
		["target-player"] 	= monster.targetPlayer and monster.targetPlayer.Name;
		["closest-player"] 	= monster.closestPlayer and monster.closestPlayer.Name;
		["last-updated"] 	= math.floor((tick() - monster.__LAST_UPDATE)*1000*100)/100;
	}
end

local monsterDebugStateData = {}
	monsterDebugStateData.phase = "init"
	monsterDebugStateData.monster = ""
	monsterDebugStateData.stateBefore = ""

local function onDumpMonsterManagerDebugInformation()
	local timeSinceLastMonsterUpdateCycle 	= math.floor((tick() - LAST_MONSTER_UPDATE_CYCLE)*1000*100)/100
	local timeSinceLastMOnsterUpdateCycleEnd = math.floor((tick() - LAST_MONSTER_UPDATE_CYCLE_END)*1000*100)/100

	local numberMonsterInMemory 			= #MONSTER_COLLECTION

	warn("MONSTER-MANAGER-DEBUG-DUMP")
		warn("MONSTERS IN MEMORY:", numberMonsterInMemory)
		warn("TIME SINCE LAST UPDATE CYCLE:", timeSinceLastMonsterUpdateCycle,"ms")
		warn("TIME SINCE LAST UPDATE CYCLE:", timeSinceLastMOnsterUpdateCycleEnd,"ms")
		warn("CURRENT STATE DATA --", "phase:", monsterDebugStateData.phase, "|", "monster:", monsterDebugStateData.monster, "|", "stateBefore:", monsterDebugStateData.stateBefore)
		warn("MONSTER SPECIFIC INFORMATION")

		for i, v in pairs(MONSTER_COLLECTION) do
			local monsterDebugData = int__getMonsterStateInformation(v)
			warn(
				monsterDebugData["name"],
				"|", "cState:", monsterDebugData["current-state"],
				"|", "target:", v.targetPlayer, v.targetEntity, v.targetEntity.Parent,
				"|", "last updated:", monsterDebugData["last-updated"], "ms"
			)
		end
end

local function onRegisterToMonsterState(player, monsterManifest)
	local monster = _getMonsterByManifest(monsterManifest)
	if monster then
		if monsterStateRegistry[player] then
			monsterStateRegistry[player]:disconnect()
		end

		monsterStateRegistry[player] = monster.stateMachine.onTransition.Event:connect(function(old, new)
			network:fireClient("monsterStateChanged", player, int__getMonsterStateInformation(monster))

			if new == "dead" then
				if monsterStateRegistry[player] then
				--	monsterStateRegistry[player]:disconnect()
				end
			end
		end)

		return true, int__getMonsterStateInformation(monster)
	end

	return false, nil
end

local function triggerMonsterRewardsSequence(monster, playerWhoKilled, damageData)
	if monster.deathRewardsApplied then
		return
	end

	monster.deathRewardsApplied = true
	----------------
	----------------
	----------------
	----------------
	if playerWhoKilled then
		network:fire("playerKilledMonster", playerWhoKilled, monster.manifest, damageData.sourceType, damageData.sourceId)
	end

	local killer
	if playerWhoKilled then
		killer = playerWhoKilled.Character and playerWhoKilled.Character.PrimaryPart
	end

	network:fire("entityKillingBlow", monster.manifest, killer, damageData)

	monster.deathRewardsApplied = true

	local XPMulti = 1
	local lootMulti =  1
	local goldMulti = 1

	local totalDamageDealt 	= 0
	local adjustedTotalDamageDealt = 0
	local damageDealers = 0

	for player, damageDealt in pairs(monster.damageTable) do
		if player and damageDealt > 1 then
			local char = player.Character and player.Character.PrimaryPart
			if char and char:FindFirstChild("state") and char.state.Value ~= "dead" then
				totalDamageDealt = totalDamageDealt + damageDealt
				adjustedTotalDamageDealt = adjustedTotalDamageDealt + damageDealt ^ (1/2)
				damageDealers = damageDealers + 1
			end
		end
	end

	local playerInvolvementMulti = damageDealers ^ (1/3)
	XPMulti = XPMulti * playerInvolvementMulti
	goldMulti = goldMulti * playerInvolvementMulti
	lootMulti = lootMulti * playerInvolvementMulti

	local totalEXP 	= monster.EXP * XPMulti

	local owners = {}
	local expResults = {}
	-- award EXP

	for player, damageDealt in pairs(monster.damageTable) do
		if player and player.Parent and damageDealt > 0 then
			local playerData = network:invoke("getPlayerData", player)
			if playerData then

				if totalEXP > 0 then
					local xp = (totalEXP / damageDealers) * playerData.nonSerializeData.statistics_final.wisdom

					-- party bonus
					local partyData = network:invoke("getPartyDataByPlayer", player)
					if partyData and partyData.members then
						if #partyData.members >= 6 then
							xp = xp * 1.2
						elseif #partyData.members > 1 then
							xp = xp * 1.1
						end
					end

					xp = math.ceil(xp)

					-- up to 2x exp for mobs 10 levels higher, 0.5x exp for mobs 5 levels lower
					-- no effect on mobs within 1 level of you
					--[[
					local levelDifference = monster.level - playerData.level
					if math.abs(levelDifference) > 1 then
						xp = xp * math.clamp(1 + levelDifference/10, 0.5, 2)
					end
					]]

					playerData.nonSerializeData.incrementPlayerData("exp",xp)
					expResults[player.Name] = xp

				end

				-- give quest trigger to anyone who damages enemy

				local monsterReference = {}
				for i,v in pairs(monster) do
					if typeof(i) == "string" and typeof(v) ~= "table" then
						monsterReference[i] = v
					end
				end

				network:fire("questTriggerOccurred", player, "monster-killed", {["monsterName"] = monster.monsterName; ["monster"] = monsterReference})

				if monster.module.Name == "Spider Queen" then
					spawn(function()
						game.BadgeService:AwardBadge(player.userId, 2124454074)
					end)
				end

				table.insert(owners, player)
			end
		end

	end

	if totalEXP > 0 then
--				events:fireEventAll("playersXpGained", expResults)
	end

	-- drop item loot

	-- super hacky todo: dont do this xD



	local damageTable = monster.damageTable
	local lootDrops = utilities.copyTable(monster.lootDrops)

	local level = monster.level
	local dropPosition = monster.manifest.Position
	local monsterName = monster.manifest.Name

	if monster.additionalLootDrops then
		for i, lootDrop in pairs(monster.additionalLootDrops) do
			table.insert(lootDrops, lootDrop)
		end
	end

	if not monster.dropsDisabled then
		spawn(function()
			for n = 1, math.ceil(lootMulti) do
				for i, lootDrop in pairs(lootDrops) do
					if n <= math.floor(lootMulti) or rand:NextNumber() < (lootMulti - math.floor(lootMulti)) then

						local lootSpawnChance = lootDrop.spawnChance or 0.001
						while lootSpawnChance > rand:NextNumber() do
							lootSpawnChance = lootSpawnChance - 1

							local itemInfo
							if lootDrop.itemName then
								local real = game.ReplicatedStorage.itemData:FindFirstChild(lootDrop.itemName)
								if real then
									itemInfo = require(real)
									lootDrop.id = itemInfo.id
								end
							end
							if itemInfo == nil then
								itemInfo = itemLookup[lootDrop.id]
							end

							local itemOwners = {}

							local ownerCount = #owners

							-- ber: equal loot drop
							for i,owner in pairs(owners) do
								table.insert(itemOwners, owner)
							end

							local isUnique = itemInfo and (itemInfo.rarity and (itemInfo.rarity == "Rare" or itemInfo.rarity == "Legendary")) or (itemInfo.category and itemInfo.category == "equipment")

							-- ber: equal chance for unique drops
							if isUnique then
								itemOwners = {itemOwners[rand:NextInteger(1, #itemOwners)]}
							end

							--assign value for gold
							if lootDrop.id == 1 then
								local baseMulti = (goldMulti or 1)

								lootDrop.value = math.ceil(baseMulti * monster.gold)
								lootDrop.source = "monster:"..monsterName:lower()
							end

							-- remove itemName and other non-important values from being saved
							local lootDropClone = utilities.copyTable(lootDrop)
							lootDropClone.itemName = nil
							lootDropClone.spawnChance = nil

							local dropInformation = {
								itemOwners = itemOwners;
								dropPosition = dropPosition;
								lootDropData = lootDropClone;
							}

							if lootDrop.dropCircumstance then
								dropInformation = lootDrop.dropCircumstance(dropInformation, {network = network})
							end

							local physItem
							if lootDrop.id == 181 then
								local monsterIdolModel = monsterIdolModelCache:FindFirstChild(monster.module.Name)

								if monsterIdolModel == nil then

									if game.ReplicatedStorage.monsterLookup:FindFirstChild(monster.module.Name):FindFirstChild("displayEntity") then
									monsterIdolModel = game.ReplicatedStorage.monsterLookup:FindFirstChild(monster.module.Name).displayEntity:Clone()
									else
										monsterIdolModel = game.ReplicatedStorage.monsterLookup:FindFirstChild(monster.module.Name).entity:Clone()
									end

									local extents = monsterIdolModel:GetExtentsSize()
									local min = math.min(extents.X, extents.Y, extents.Z)
									local max = math.max(extents.X, extents.Y, extents.Z)
									local reductionFactor = 4/(min+max)

									utilities.scale(monsterIdolModel, reductionFactor)
									local primary = monsterIdolModel.PrimaryPart
									primary.Name = "manifest"
									for i,v in pairs(monsterIdolModel:GetChildren()) do
										if v:IsA("BasePart") then
											v.Material = Enum.Material.Glass
											v.Reflectance = v.Reflectance + 0.2
											v.Transparency = 0
											v.Color = Color3.new(0,0,0)
											if v ~= primary then
												v.Parent = primary
												v.Massless = true
											end
										end
									end
									local oldModel = monsterIdolModel
									primary.Size = Vector3.new(2.2,2.2,2.2)
									primary.Name = monster.module.Name
									primary.Parent = monsterIdolModelCache
									monsterIdolModel = primary
									oldModel:Destroy()

								end

								physItem = monsterIdolModel:Clone()
							end

							if #dropInformation.itemOwners > 0 then
								-- drop the item!
								local success = monster:dropItem(dropInformation, physItem, lootMulti)

								if not success then
									-- we error, stop spawning drops?
									break
								end
							end
						end
					end
				end
			end
			wait()
		end)
	end
	----------------
	----------------
	----------------
	----------------

--	if playerWhoKilled then
--		network:fire("playerKilledMonster", playerWhoKilled, monster.manifest, damageData.sourceType, damageData.sourceId)
--	end
--
--	local XPMulti 			= monster.bonusXPMulti or 1
--	local totalEXP 			= levels.getMonsterEXPFromLevel(monster.level) * XPMulti
--	local totalDamageDealt 	= 0
--
--	for playerCheck, damageDealt in pairs(monster.damageTable) do
--		local playerData 		= network:invoke("getPlayerData", playerCheck)
--		local equipmentSlotData = network:invoke("getPlayerEquipmentDataByEquipmentPosition", playerCheck, 1)
--		-- we need to seriously re-eval our anti-exploit strategy. This was coming up too often in testing -ber
--		--[[
--		if playerData and equipmentSlotData and itemLookup[equipmentSlotData.id] and itemLookup[equipmentSlotData.id].equipmentType ~= "bow" then
--			if playerLastMonsterKill[playerCheck] then
--				local currentMonsterKill 	= {position = monsterManifest.Position; timestamp = tick()}
--
--				local timeDelta 	= currentMonsterKill.timestamp - playerLastMonsterKill[playerCheck].timestamp
--				local positionDelta = currentMonsterKill.position - playerLastMonsterKill[playerCheck].position
--
--				if configuration.getConfigurationValue("doCheckMonsterKillDistanceChangeForEXPAndLoot") then
--					if not monster.playersWithAbilityUse or not monster.playersWithAbilityUse[playerCheck.userId] then
--						--warn("pos dif in", math.floor(timeDelta * 100) / 100, "sec --", positionDelta.magnitude, "expected", playerData.nonSerializeData.statistics_final.walkspeed * 2 * timeDelta)
--						if positionDelta.magnitude <= 5 + playerData.nonSerializeData.statistics_final.walkspeed * 2 * timeDelta then
--							-- do nothing, they're good :)
--						else
--							-- player got here much faster than expected..
--							warn(playerCheck, "GOT HERE WAY TOO QUICKLY FROM LAST MONSTER, NO REWARDS FOR THEM.")
--							monster.damageTable[playerCheck] = nil
--							-- network:invoke("incrementPlayerArcadeScore", playerCheck, 1)
--						end
--					else
--						-- used ability, they're probably fine
--					end
--				end
--
--				playerLastMonsterKill[playerCheck] = currentMonsterKill
--			else
--				playerLastMonsterKill[playerCheck] 	= {position = monsterManifest.Position; timestamp = tick()}
--			end
--		end
--		]]
--		totalDamageDealt = totalDamageDealt + damageDealt
--	end
--
--	local owners = {}
--	local expResults = {}
--	-- award EXP
--
--	for player,damageDealt in pairs(monster.damageTable) do
--		if player and damageDealt > 0 then
--			local playerData = network:invoke("getPlayerData", player)
--			if playerData then
--				local share = damageDealt / totalDamageDealt
--
--				if totalEXP > 0 then
--
--					local adjustEXP = share * totalEXP
--					local xp =  math.clamp(math.floor(adjustEXP + 0.5), 1, totalEXP) * playerData.nonSerializeData.statistics_final.wisdom
--
--
--					-- party bonus
--					local partyData = network:invoke("getPartyDataByPlayer", player)
--					if partyData and partyData.members then
--						if #partyData.members >= 6 then
--							xp = xp * 1.2
--						elseif #partyData.members > 1 then
--							xp = xp * 1.1
--						end
--					end
--
--					playerData.nonSerializeData.incrementPlayerData("exp",xp)
--					expResults[player.Name] = xp
--
--				end
--
--				-- give quest trigger to anyone who damages enemy
--
--				local monsterReference = {}
--				for i,v in pairs(monster) do
--					if typeof(i) == "string" and typeof(v) ~= "table" then
--						monsterReference[i] = v
--					end
--				end
--
--				network:fire("questTriggerOccurred", player, "monster-killed", {["monsterName"] = monster.monsterName; ["monster"] = monsterReference})
--
--				if monster.module.Name == "Spider Queen" then
--					spawn(function()
--						game.BadgeService:AwardBadge(player.userId, 2124454074)
--					end)
--				end
--
--				table.insert(owners, player)
--			end
--		end
--
--	end
--
--	if totalEXP > 0 then
----		events:fireEventAll("playersXpGained", expResults)
--	end
--
--	-- drop item loot
--
--	-- super hacky todo: dont do this xD
--
--	local lootMulti = monster.bonusLootMulti or 1
--
--	local damageTable = monster.damageTable
--	local lootDrops = utilities.copyTable(monster.lootDrops)
--	local goldMulti = monster.goldMulti
--	local level = monster.level
--	local dropPosition = monster.manifest.Position
--	local monsterName = monster.manifest.Name
--
--	if monster.additionalLootDrops then
--		for i, lootDrop in pairs(monster.additionalLootDrops) do
--			table.insert(lootDrops, lootDrop)
--		end
--	end
--
--	if not monster.dropsDisabled then
--		spawn(function()
--			for n = 1, lootMulti do
--
--				for i, lootDrop in pairs(lootDrops) do
--					local lootSpawnChance = lootDrop.spawnChance or 0.001
--					while lootSpawnChance > rand:NextNumber() do
--						lootSpawnChance = lootSpawnChance - 1
--
--						local itemInfo
--						if lootDrop.itemName then
--							local real = game.ReplicatedStorage.itemData:FindFirstChild(lootDrop.itemName)
--							if real then
--								itemInfo = require(real)
--								lootDrop.id = itemInfo.id
--							end
--						end
--						if itemInfo == nil then
--							itemInfo = itemLookup[lootDrop.id]
--						end
--
--						-- assign attributes
--						local equipSlot = itemInfo.equipmentSlot
--						if equipSlot then
--							local rarity = itemInfo.rarity or "Common"
--							local attribute
--							if equipSlot == 1 or equipSlot == 8 then
--								local r = rand:NextInteger(1,1000)
--								if rarity == "Common" then
--									if r == 777 then
--										attribute = "legendary"
--									elseif r <= 30 then
--										attribute = "pristine"
--									elseif r <= 300 then
--										-- sorry
--										attribute = ({"keen", "fierce", "swift", "vibrant"})[rand:NextInteger(1,4)]
--									elseif r > 600 then
--										if equipSlot == 1 then
--											attribute = "dull"
--										elseif equipSlot == 8 then
--											attribute = "tattered"
--										end
--									end
--								else
--									if r == 777 then
--										attribute = "legendary"
--									elseif r <= 10 then
--										attribute = "pristine"
--									elseif r <= 300 then
--										-- sorry
--										attribute = ({"keen", "fierce", "swift", "vibrant"})[rand:NextInteger(1,4)]
--									end
--								end
--							end
--							if attribute then
--								lootDrop.attribute = attribute
--							end
--						end
--
--
--						--local itemOwners = owners
--						local itemOwners = {}
--
--						local ownerCount = #owners
--
--						for i,owner in pairs(owners) do
--							local share = (damageTable and damageTable[owner] or 0) / totalDamageDealt
--
--							local minSecureShare = 1/ownerCount
--
--							if share >= minSecureShare then
--								table.insert(itemOwners, owner)
--							else
--								if math.clamp(share/minSecureShare,0,1) <= rand:NextNumber() then
--									table.insert(itemOwners, owner)
--								end
--							end
--						end
--
--						-- do a lottery for soulbound drops (note: different than the actual soulbound field)
--						if itemInfo and (itemInfo.rarity and (itemInfo.rarity == "Rare" or itemInfo.rarity == "Legendary")) or (itemInfo.category and itemInfo.category == "equipment") then
--							local lottery = {}
--							for i,owner in pairs(itemOwners) do
--								local ownerData = network:invoke("getPlayerData", owner)
--								local share = (damageTable and damageTable[owner] or 0) / totalDamageDealt
--								if owner then
--									--local shares = math.floor(share * 20 * (ownerData.nonSerializeData.statistics_final.luckEffectiveness * ownerData.nonSerializeData.statistics_final.luck))
--
--									local luckMulti = 1 + ownerData.nonSerializeData.statistics_final.luck / 100
--									-- !!!!!!!!!!!!warning: right now there are a pair of boots in the game that have a +15 luck bonus as an enchantment. make sure to clear these items from players invs if changes to luck are made
--									-- dont give them +1500% luck
--									-- right now: one point of luck = +1%
--
--
--
--
--
--									local shares   = math.floor(share * 20 * luckMulti)
--									for i=1,shares do
--										table.insert(lottery, owner)
--									end
--								end
--							end
--							local owner = lottery[rand:NextInteger(1,#lottery)]
--							if owner and owner.Parent == game.Players then
--								-- todo: alert the player they've got a soulbound drop
--
--								itemOwners = {owner}
--
--							end
--						end
--
--						--assign value for gold
--						if lootDrop.id == 1 then
--							local baseMulti = (goldMulti or 1) * rand:NextInteger(8,12)/10
--
--
--
--							lootDrop.value = math.ceil(baseMulti * levels.getMonsterGoldForLevel(level or 1))
--							lootDrop.source = "monster:"..monsterName:lower()
--						end
--
--						-- remove itemName and other non-important values from being saved
--						local lootDropClone = utilities.copyTable(lootDrop)
--							lootDropClone.itemName 		= nil
--							lootDropClone.spawnChance 	= nil
--
--						local dropInformation = {
--							itemOwners = itemOwners;
--							dropPosition = dropPosition;
--							lootDropData = lootDropClone;
--						}
--
--						if lootDrop.dropCircumstance then
--							dropInformation = lootDrop.dropCircumstance(dropInformation, {network = network})
--						end
--
--						local physItem
--						if lootDrop.id == 181 then
--							local monsterIdolModel = monsterIdolModelCache:FindFirstChild(monster.module.Name)
--
--							if monsterIdolModel == nil then
--								print("$skip cache")
--
--								if game.ReplicatedStorage.monsterLookup:FindFirstChild(monster.module.Name):FindFirstChild("displayEntity") then
--								monsterIdolModel = game.ReplicatedStorage.monsterLookup:FindFirstChild(monster.module.Name).displayEntity:Clone()
--								else
--									monsterIdolModel = game.ReplicatedStorage.monsterLookup:FindFirstChild(monster.module.Name).entity:Clone()
--								end
--
--								local extents = monsterIdolModel:GetExtentsSize()
--								local min = math.min(extents.X, extents.Y, extents.Z)
--								local max = math.max(extents.X, extents.Y, extents.Z)
--								local reductionFactor = 4/(min+max)
--
--								utilities.scale(monsterIdolModel, reductionFactor)
--								local primary = monsterIdolModel.PrimaryPart
--								primary.Name = "manifest"
--								for i,v in pairs(monsterIdolModel:GetChildren()) do
--									if v:IsA("BasePart") then
--										v.Material = Enum.Material.Glass
--										v.Reflectance = v.Reflectance + 0.2
--										v.Transparency = v.Transparency + 0.1
--										if v ~= primary then
--											v.Parent = primary
--											v.Massless = true
--										end
--									end
--								end
--								local oldModel = monsterIdolModel
--								primary.Size = Vector3.new(2.2,2.2,2.2)
--								primary.Name = monster.module.Name
--								primary.Parent = monsterIdolModelCache
--								monsterIdolModel = primary
--								oldModel:Destroy()
--
--							end
--
--							physItem = monsterIdolModel:Clone()
--						end
--
--						if #dropInformation.itemOwners > 0 then
--							local item = network:invoke("spawnItemOnGround",dropInformation.lootDropData, dropInformation.dropPosition, dropInformation.itemOwners, physItem)
--							if item == nil then break end
--
--							-- monster idol
--							if lootDrop.id == 181 then
--								local monsterNameTag = Instance.new("StringValue")
--								monsterNameTag.Name = "monsterName"
--								monsterNameTag.Value = monster.module.Name
--								monsterNameTag.Parent = item
--							end
--
--							-- apply random enchantments to drops:
--
--
--
--							if lootMulti > 1 then
--								--[[
--									local tag = Instance.new("BoolValue")
--									tag.Name = "singleOwnerPickup"
--									tag.Parent = item
--								]]
--							end
--
--							local attachmentTarget
--
--							local velo = Vector3.new((rand:NextNumber() - 0.5) * 30, rand:NextNumber() * 65, (rand:NextNumber() - 0.5) * 30)
--							velo = velo * (1 + ((lootMulti - 1) / 27))
--
--							if item:IsA("BasePart") then
--								item.Velocity = velo
--								attachmentTarget = item
--							elseif item:IsA("Model") and (item.PrimaryPart or item:FindFirstChild("HumanoidRootPart")) then
--								local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart")
--								if primaryPart then
--									primaryPart.Velocity = velo
--									attachmentTarget = primaryPart
--								end
--							end
--
--							if attachmentTarget then
--								local topAttachment = Instance.new("Attachment", attachmentTarget)
--									topAttachment.Position = Vector3.new(0, attachmentTarget.Size.Y / 2, 0)
--
--								local bottomAttachment = Instance.new("Attachment", attachmentTarget)
--									bottomAttachment.Position = Vector3.new(0, -attachmentTarget.Size.Y / 2, 0)
--
--								local trail = script.Trail:Clone()
--									trail.Attachment0 	= topAttachment
--									trail.Attachment1 	= bottomAttachment
--									trail.Enabled 		= true
--									trail.Parent 		= attachmentTarget
--							end
--						end
--					end
--				end
--			end
--			wait()
--		end)
--	end
end

-- give api function to drop rewards for a monster
-- ie, special way to grant exp/rewards without death of monster
function monsterClass:dropRewards(playerWhoKilled, damageData)
	if self.deathRewardsApplied then
		return false
	end

	triggerMonsterRewardsSequence(self, playerWhoKilled, damageData)

	return true
end

local function onMonsterDamageRequestReceived(player, monsterManifest, damageData)
	local monster
	for _, monsterToCheck in pairs(MONSTER_COLLECTION) do
		if monsterToCheck.manifest == monsterManifest then
			monster = monsterToCheck
			break
		end
	end

	if monster then
		if monster.health > 0 then
			local monsterData 	= monsterLookup[monster.monsterName]
			local statesData 	= monsterData.statesData

			-- process status effects that may affect damage here
			-- unfortunately we don't have as robust a system for mobs
			-- as we do for players, but this will have to suffice for now
			-- Davidii wrote this
			do
				local manifest = monster.manifest
				local guid = utilities.getEntityGUIDByEntityManifest(manifest)

				if guid then
					local statuses = network:invoke("getStatusEffectsOnEntityManifestByEntityGUID", guid)

					for _, status in pairs(statuses) do
						for stat, value in pairs(status.statusEffectModifier.modifierData or {}) do
							if stat == "damageTakenMulti" then
								damageData.damage = damageData.damage * (1 + value)
							end
						end
					end
				end
			end

			-- allow monsters to modify damage done to them
			if statesData.processDamageRequestToMonster then
				damageData = statesData.processDamageRequestToMonster(monster, damageData) or damageData
			end

			-- player is hitting monster, or monster is hitting monster?
			events:fireEventLocal("entityWillDealDamage", player, monsterManifest, damageData)

			local newHealth 						= math.clamp(monster.health - damageData.damage, -99999999, monster.maxHealth)
			local actualDamage 						= monster.health - newHealth
			local actualDamageForLootCalculation 	= monster.health - math.clamp(newHealth, 0, monster.maxHealth)

			monster.health 						= newHealth

			monster.manifest.health.Value 		= monster.health
			monster.manifest.maxHealth.Value	= monster.maxHealth

			monster.damageTable = monster.damageTable or {}

			if monster.__MONSTER_EVENTS.onMonsterDamaged then
				monster.__MONSTER_EVENTS.onMonsterDamaged(monster, damageData.damage, player)
			end

			if player then
				if damageData.sourceType == "ability" then
					if not monster.playersWithAbilityUse then
						monster.playersWithAbilityUse = {}
					end

					monster.playersWithAbilityUse[player.userId] = true
				end

				if statesData.onDamageReceived then
					statesData.onDamageReceived(monster, "player", player, damageData.damage)
				end



				if damageData.damage > 0 then

					-- make monsters switch targets if attacked by someone closer
					if player.Character and player.Character.PrimaryPart then
						if monster.targetEntity and monster.targetEntity ~= player.Character.PrimaryPart then

							local monsterPosition = monster.entity:IsA("BasePart") and monster.entity.Position or monster.entity:IsA("Model") and monster.entity.PrimaryPart.Position
							local targetPosition = monster.targetEntity:IsA("BasePart") and monster.targetEntity.Position or monster.targetEntity:IsA("Model") and monster.targetEntity.PrimaryPart.Position

							if (player.Character.PrimaryPart.Position -  monsterPosition).magnitude < (targetPosition -  monsterPosition).magnitude or rand:NextNumber() <= 0.3 then
								monster.targetEntity = player.Character.PrimaryPart
								monster.entityMonsterWasAttackedBy = player.Character.PrimaryPart
							end
						end
					end

					monster.damageTable[player] = (monster.damageTable[player] or 0) + actualDamageForLootCalculation

					if not monster.targetEntity and player.Character.PrimaryPart then
						if statesData.states["attacked-by-player"] and statesData.states["idling"] and statesData.states["following"] then
							monster.entityMonsterWasAttackedBy = player.Character.PrimaryPart
							print("FORCE STATE CHANGE! :D")
							monster.stateMachine:forceStateChange("attacked-by-player")
						end

					-- PLS DON'T GET RID OF ME I AM IMPORTANT FOR THIS MOB
					elseif monster.manifest.Name == "Bandit Skirmisher"  then -- needed this for the skirmisher mob
						monster.entityMonsterWasAttackedBy = player.Character.PrimaryPart
						if monster.state ~= "attacking" then
							monster.stateMachine:forceStateChange("attacked-by-player")
						end
					end
				end
			end
		end

		network:fireAllClients("signal_damage", monster.manifest, damageData)

		if monster.health <= 0 then
			-- trigger the rewards
			if not monster.deathRewardsApplied then
				triggerMonsterRewardsSequence(monster, player, damageData)
			end



			-- monster died. kill it.
			monster.stateMachine:forceStateChange("dead")
		else
			if monster.stateMachine.states.hurt then
				monster.stateMachine:forceStateChange("hurt")
			end
		end

		return true, monster.health <= 0
	end

	return false, false
end

local errormsg = Instance.new("Message")

local function updateMonsterLogic()
	LAST_MONSTER_UPDATE_CYCLE = tick()

	monsterDebugStateData.phase = "start"
	monsterDebugStateData.monster = ""
	monsterDebugStateData.stateBefore = ""

	local lastMonsterUpdated 	= nil
	local preState 				= nil

	local currTime = tick()
	for i, monster in pairs(MONSTER_COLLECTION) do
		local success, err 			= pcall(function()
			if monster.manifest and monster.manifest.Parent == entityManifestCollectionFolder and monster.state ~= "dead" then

				-- update the brain
				lastMonsterUpdated = monster

				if not monster.isMonsterPet then

					-- fetch enemies within range
					local entities do
						local monsterData 	= monsterLookup[monster.monsterName]
						local statesData 	= monsterData.statesData

						if statesData.getClosestEntities then
							entities = statesData.getClosestEntities(monster)
						else
							entities = defaultMonsterState.getClosestEntities(monster)
						end
					end

					local nearbyTargets = {}

					local closestEntity
					local nearestDist = 999

					-- find nearby targets
					for i, entityManifest in pairs(entities) do
						if (not entityManifest:FindFirstChild("isStealthed")) and (not entityManifest:FindFirstChild("isTargetImmune")) then
							if entityManifest.state.Value ~= "dead" and entityManifest.state.Value ~= "sitting" and entityManifest.entityType.Value ~= "pet" then
								local dist = (entityManifest.Position - monster.manifest.Position).magnitude
								if dist < monster.sightRange then
									nearbyTargets[#nearbyTargets + 1] = entityManifest
									if dist <= nearestDist then
										closestEntity = entityManifest
										nearestDist = dist
									end
								end
							end
						end
					end


					if monster.closestEntity and (monster.closestEntity.Parent == nil or monster.closestEntity.state.Value == "dead") then
						monster.closestEntity = nil
					end

					--legacy
					monster.closestEntity = (monster.closestEntity == monster.targetEntity and monster.closestEntity) or closestEntity
					monster.nearbyTargets = nearbyTargets

					-- ITS TIME FOR G-G-G-GALAXY BRAIN MMMMMONSTERRRRR AI ! ! !
					monster.entityDensityData = getEntityDensity(monster)

					-- targetEntity
					if monster.targetEntity and (monster.targetEntity.Parent == nil or monster.targetEntity.state.Value == "dead") then
						monster:setTargetEntity(nil, nil)
					end

					-- despawn night mobs
					if nearestDist >= 100 and monster.nightBoosted and not (game.Lighting.ClockTime < 5.9 or game.Lighting.ClockTime > 18.6) then
						if monster and monster.manifest and monster.manifest.Parent then
							monster.manifest:Destroy()
						end
					end
				end

				monsterDebugStateData.phase = "before-stateUpdate"

				monster.__LAST_UPDATE = currTime

				preState = monster.stateMachine.currentState
				updateMonsterStateMachine(monster)

				monsterDebugStateData.phase = "after-stateUpdate"
			end
		end)
		if not success then
			warn("manager_monster::" .. tostring(lastMonsterUpdated.monsterName) .. "::" .. tostring(lastMonsterUpdated.stateMachine.currentState) .. "::", err)
			warn("killing entity")
			if monster and monster.manifest and monster.manifest.Parent then
				monster.manifest:Destroy()
			end
		end
	end

	monsterDebugStateData.phase = "end"
	monsterDebugStateData.monster = ""
	monsterDebugStateData.stateBefore = ""

	LAST_MONSTER_UPDATE_CYCLE_END = tick()
end

local function onPlayerCharacterDied(player)
	if not player.Character or not player.Character.PrimaryPart then return end

	for i, monster in pairs(MONSTER_COLLECTION) do
		if monster.targetEntity == player.Character.PrimaryPart then
			monster:setTargetEntity(nil, nil, true)

			updateMonsterStateMachine(monster)
		end
	end
end

local function onPlayerRemoving(player)
	playerLastMonsterKill[player] = nil
end

local function monsterHasAttribute(monster, attribute)
	if attribute == "enraged" then
		return not not monster.IS_MONSTER_ENRAGED
	end

	return monster.variation == attribute
end

local function main()
--	for i, monsterStatModule in pairs(replicatedStorage.monsterData:GetChildren()) do
--		monsterDataCollection[monsterStatModule.Name] = require(monsterStatModule)
--	end

	-- register for variants --
	events:registerForEvent("entityDiedTakingDamage", function(sourcePlayer, entityHitboxDamaged, damageData)
		if not configuration.getConfigurationValue("doSpawnNightTimeVariants") then return end

		local sourceEntityHitbox = utilities.getEntityManifestByEntityGUID(damageData.sourceEntityGUID)

		if sourceEntityHitbox then
			local monsterData = _getMonsterByManifest(sourceEntityHitbox)

			if monsterData then

			end
		end
	end)

	events:registerForEvent("monsterEntitySpawning", function(monster)
		if not configuration.getConfigurationValue("doSpawnNightTimeVariants") then return end

		if monsterHasAttribute(monster, "stalker") then
			monster.autoStealthTimer = tick()

			local wasApplied, reason = network:invoke(
				"applyStatusEffectToEntityManifest",
				monster.manifest,
				"stealth",
				{
					duration = 9999,
				},
				monster.manifest,
				"autoStealth_stealth",
				0
			)
		end
	end)

	events:registerForEvent("entityWillDealDamage", function(sourcePlayer, entityHitboxDamaged, damageData)
		if not configuration.getConfigurationValue("doSpawnNightTimeVariants") then return end

		local sourceEntityHitbox = utilities.getEntityManifestByEntityGUID(damageData.sourceEntityGUID)

		if sourceEntityHitbox then
			local monsterDealingDamageData 	= _getMonsterByManifest(sourceEntityHitbox)

			-- note: not sure if this exists, make sure to check!
			local monsterTakingDamageData 	= entityHitboxDamaged and _getMonsterByManifest(entityHitboxDamaged)

			if monsterDealingDamageData then
				if monsterHasAttribute(monsterDealingDamageData, "cursed") then
					if math.random() < (1 / 3) then
						local wasApplied, reason = require(game.ReplicatedStorage.modules.network):invoke(
							"applyStatusEffectToEntityManifest",
							entityHitboxDamaged,
							"poison",
							{duration = 3; healthLost = 0.2 * damageData.damage},
							sourceEntityHitbox,
							"monster-variant",
							"poison"
						)
					end
				elseif monsterHasAttribute(monsterDealingDamageData, "stalker") or (monsterTakingDamageData and monsterHasAttribute(monsterTakingDamageData, "stalker")) then
					-- this will revoke stealth regardless of if the monster is being damaged or dealing damage
					local monsterDataToRevokeStealthFrom = monsterHasAttribute(monsterDealingDamageData, "stalker") and monsterDealingDamageData or monsterTakingDamageData

					if network:invoke("doesEntityManifestHaveStatusEffectBySourceType", monsterDataToRevokeStealthFrom.manifest, "autoStealth_stealth") then
						network:invoke("removeStatusEffectFromEntityManifestBySourceType", monsterDataToRevokeStealthFrom.manifest, "autoStealth_stealth")

						monsterDataToRevokeStealthFrom.autoStealthTimer = tick()

						delay(5, function()
							if tick() - monsterDataToRevokeStealthFrom.autoStealthTimer >= 5 and monsterDataToRevokeStealthFrom.manifest.Parent and not network:invoke("doesEntityManifestHaveStatusEffectBySourceType", monsterDataToRevokeStealthFrom.manifest, "autoStealth_stealth") then
								local wasApplied, reason = network:invoke(
									"applyStatusEffectToEntityManifest",
									monsterDataToRevokeStealthFrom.manifest,
									"stealth",
									{
										duration = 9999,
									},
									monsterDataToRevokeStealthFrom.manifest,
									"autoStealth_stealth",
									0
								)
							end
						end)
					end
				end
			end

			if monsterTakingDamageData and monsterHasAttribute(monsterTakingDamageData, "short-fused") then
				local wasApplied, reason = require(game.ReplicatedStorage.modules.network):invoke(
					"applyStatusEffectToEntityManifest",
					entityHitboxDamaged,
					"explode",
					{duration = 1},
					sourceEntityHitbox,
					"monster-variant",
					"explosion"
				)
			end

			if monsterTakingDamageData and monsterHasAttribute(monsterTakingDamageData, "enraged") then
				if not monsterTakingDamageData.ENRAGED_AGGRO_TIMER then
					monsterTakingDamageData.ENRAGED_AGGRO_TIMER = 0
				end

				if tick() - monsterTakingDamageData.ENRAGED_AGGRO_TIMER > 5 then
					monsterTakingDamageData.ENRAGED_AGGRO_TIMER = tick()

					for i, oMonsterData in pairs(MONSTER_COLLECTION) do
						if oMonsterData.manifest and (oMonsterData.manifest.Position - monsterTakingDamageData.manifest.Position).magnitude < 100 then
							oMonsterData:setTargetEntity(sourceEntityHitbox)
						end
					end
				end
			end
		end
	end)
	-- end register for variants --

	game.Players.PlayerRemoving:connect(onPlayerRemoving)
	entityManifestCollectionFolder.ChildRemoved:connect(onMonsterRemoved)

	network:create("setIsSpawnRegionCollectionDisabled_server", "BindableFunction", "OnInvoke", setIsSpawnRegionCollectionDisabled)

	network:create("monsterDamageRequest_server", "BindableFunction", "OnInvoke", onMonsterDamageRequestReceived)
	network:create("getMonsterDataByMonsterManifest_server", "BindableFunction", "OnInvoke", function(monsterManifest, specificProperty)
		if specificProperty then
			return _getMonsterByManifest(monsterManifest, specificProperty)
		else
			local monster = _getMonsterByManifest(monsterManifest)

			if not monster then
				return nil
			end

			monster = utilities.copyTable(monster)
			purgeNumericKeys(monster)
			return monster
		end
	end)
	network:create("registerToMonsterState", "RemoteFunction", "OnServerInvoke", onRegisterToMonsterState)
	network:create("monsterStateChanged", "RemoteEvent")
	network:create("playerKilledMonster", "BindableEvent")

	network:create("spawnMonsterPet", "BindableFunction", "OnInvoke", onSpawnMonsterPet)
	network:create("dumpMonsterManagerDebugInformation", "BindableFunction", "OnInvoke", onDumpMonsterManagerDebugInformation)

	network:connect("playerCharacterDied", "Event", onPlayerCharacterDied)

	network:create("getMonsterEntityDataTag", "BindableFunction", "OnInvoke", function(monsterEntity, nameTag)
		local monsterData do
			for i, monster in pairs(MONSTER_COLLECTION) do
				if monster.manifest == monsterEntity then
					monsterData = monster
				end
			end
		end

		if monsterData then
			return monsterData[nameTag]
		end
	end)

	network:create("setMonsterEntityDataTag", "BindableFunction", "OnInvoke", function(monsterEntity, nameTag, value)
		local monsterData do
			for i, monster in pairs(MONSTER_COLLECTION) do
				if monster.manifest == monsterEntity then
					monsterData = monster
				end
			end
		end

		if monsterData then
			monsterData[nameTag] = value
		end
	end)

	network:create("setMonsterTargetEntity", "BindableFunction", "OnInvoke", function(monsterEntity, targetEntity, targetEntitySetSource, targetEntityLockType)
		local monsterData do
			for i, monster in pairs(MONSTER_COLLECTION) do
				if monster.manifest == monsterEntity then
					monsterData = monster
				end
			end
		end

		if monsterData and targetEntity then
			monsterData:setTargetEntity(targetEntity, nil, targetEntitySetSource, targetEntityLockType)
		end
	end)
	local function isNight()
		return game.Lighting.ClockTime < 5.9 or game.Lighting.ClockTime > 18.6
	end
	spawn(function() while wait(isNight() and MONSTER_SPAWN_CYCLE_TIME * 0.5 or MONSTER_SPAWN_CYCLE_TIME) do
		for i, monsterSpawnInformation in pairs(monsterManager:getSpawnRegionCollectionsUnderPopulated()) do
			monsterManager.spawn(monsterSpawnInformation.monsterNameToSpawn, monsterSpawnInformation.spawnRegionCollection)
		end
	end end)

	while wait(1/5) do
		updateMonsterLogic()
	end
end

-- run separately
spawn(main)

return monsterManager