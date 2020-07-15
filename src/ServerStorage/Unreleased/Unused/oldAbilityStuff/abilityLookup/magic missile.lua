local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")
local runService = game:GetService("RunService")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")
	local ability_utilities = modules.load("ability_utilities")
	local detection         = modules.load("detection")
	local projectile        = modules.load("projectile")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")
local spawnRegionCollectionsFolder = placeSetup.getPlaceFolder("spawnRegionCollections")
local entityManifestCollectionFolder = placeSetup.getPlaceFolder("entityManifestCollection")
local entityRenderCollectionFolder = placeSetup.getPlaceFolder("entityRenderCollection")
local itemsFolder = placeSetup.getPlaceFolder("items")
local foilage = placeSetup.getPlaceFolder("foilage")

local RAYCAST_IGNORE_LIST = {spawnRegionCollectionsFolder, entityManifestCollectionFolder, entityRenderCollectionFolder, itemsFolder, entitiesFolder, foilage}


local abilityData = {
	id = 1,
	
	name = "Magic Missile",
	image = "rbxassetid://3736638029",
	description = "Call upon your innate magic ability to send out a homing energy missile.",
	mastery = "More bolts.",
	
	prerequisite = {{id = 3; rank = 1}};
	
	maxRank = 5,
	
	statistics = {
		[1] = {
			cooldown = 1,
			manaCost = 10,
			bolts = 1,
			damageMultiplier = 1,
			tier = 1,
		},
		[2] = {
			damageMultiplier = 1.1,
			manaCost = 12,
		},
		[3] = {
			bolts = 2,
			damageMultiplier = 0.75,
			cooldown = 1.5,
			manaCost = 15,
		},
		[4] = {
			damageMultiplier = 0.8,
			manaCost = 17,
		},
		[5] = {
			bolts = 3,
			damageMultiplier = 0.7,
			cooldown = 2,
			manaCost = 20,
		},
	},
	
	windupTime = 0.35,
	
	securityData = {
		playerHitMaxPerTag = 10,
		isDamageContained = true,
		projectileOrigin = "character",
	},
	
	targetingData = {
		targetingType = "directSphere",
		radius = 3,
		range = 128,
		
		onStarted = function(entityContainer, executionData)
			local track = entityContainer.entity.AnimationController:LoadAnimation(abilityAnimations.rock_throw_upper_loop)
			track:Play()
			
			return {track = track}
		end,
		
		onEnded = function(entityContainer, executionData, data)
			data.track:Stop()
		end
	}
}

function createEffectPart()
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	return part
end

function bolt(launchCFrame, owner, guid, doesDealDamage, boltType)
	-- constants for the function
	local topSpeed = 50
	local contactDistanceSq = 3 ^ 2
	local homingDistanceSq = 24 ^ 2
	local homingDelay = 0.2
	
	local missileTemplate = script.missile
	if boltType == "star" then
		missileTemplate = script.star
		topSpeed = topSpeed * 1.5
	end
	
	-- create a missile and keep track of it
	local missile = missileTemplate:Clone()	
	missile.CFrame = launchCFrame * missile.alignAttachment.CFrame:Inverse()
	
	local mover = missile.mover
	local orientationAttachment = missile.orientationAttachment
	local trail = missile.trail
	
	orientationAttachment.CFrame = launchCFrame
	orientationAttachment.Parent = workspace.Terrain
	missile.Parent = entitiesFolder
	
	-- this data is used to update
	-- what the missile does in flight
	local boltData = {
		speed = 12,
		missile = missile,
		target = nil,
		startTime = tick(),
		
		-- which way the missile will drift while searching for a target
		driftCFrame = CFrame.Angles(math.pi * 2 * math.random(), 0, math.pi * 2 * math.random()),
	}
	
	local connection
	local function finish(wasSuccess)
		connection:Disconnect()
		orientationAttachment:Destroy()
		
		missile.Anchored = true
		missile.Transparency = 1
		trail.Enabled = false
		debris:AddItem(missile, trail.Lifetime)
		
		if wasSuccess and doesDealDamage then
			local damageTag = "strike"
			if boltType == "star" then
				damageTag = "twilight"
			end
			network:fire("requestEntityDamageDealt", boltData.target, boltData.target.Position, "ability", abilityData.id, damageTag, guid)
		end
	end
	
	local function checkForCollision()
		local missile = boltData.missile
		local origin = missile.Position
		local direction = missile.CFrame.LookVector/2
		local ray = Ray.new(origin, direction)
		local part = workspace:FindPartOnRayWithIgnoreList(ray, RAYCAST_IGNORE_LIST, false, true)
		return part ~= nil and part.CanCollide
	end
	
	-- finds and assigns the nearest target
	-- within homingDistance (defined above)
	local function findTarget()
		local targets = damage.getDamagableTargets(owner)
		local here = boltData.missile.Position
		local best = nil
		local bestDistanceSq = homingDistanceSq
		for _, target in pairs(targets) do
			local there = detection.projection_Box(target.CFrame, target.Size, here)
			local delta = there - here
			local distanceSq =
				delta.X * delta.X +
				delta.Y * delta.Y +
				delta.Z * delta.Z
			if (distanceSq <= bestDistanceSq) then
				best = target
				bestDistanceSq = distanceSq
			end
		end
		boltData.target = best
	end
	
	-- run every frame while the missile is airborne
	local function update(dt)
		-- move in the direction we're facing
		mover.Velocity = (missile.CFrame * missile.alignAttachment.CFrame).LookVector * boltData.speed
		
		-- if we have a target, rotate towards it and run logic if we hit
		if boltData.target then
			local directionCFrame = CFrame.new(missile.Position, boltData.target.Position)
			orientationAttachment.CFrame = directionCFrame
			
			local delta = boltData.target.Position - missile.Position
			local distanceSq =
				delta.X * delta.X +
				delta.Y * delta.Y +
				delta.Z * delta.Z
				
			local size = boltData.target.Size / 2	
			local sizeSq = 
				size.X * size.X +
				size.Y * size.Y +
				size.Z * size.Z
			
			if distanceSq <= math.max(contactDistanceSq, sizeSq) then
				finish(true)
			end
		
		-- if we don't have a target, search for one
		else
			local now = tick()
			local since = now - boltData.startTime
			if since >= homingDelay then
				boltData.speed = topSpeed
				findTarget()
			else
				-- if we're not searching for a target, drift slowly to look cool
				mover.Velocity = boltData.driftCFrame.LookVector * boltData.speed
			end
		end
		
		-- if we hit something we're done
		if checkForCollision() then
			finish(false)
		end
	end
	
	update()
	
	connection = runService.Heartbeat:Connect(update)
	
	-- failsafe
	delay(1.4, function()
		finish(false)
	end)
	
	return boltData
end

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "strike" then
		return baseDamage, "magical", "aoe"
	elseif sourceTag == "twilight" then
		return baseDamage * 1.25, "magical", "aoe"
	end
end

local function throwBolts(bolts, launchCFrame, owner, guid, doesDealDamage, boltType)
	for boltNumber = 1, bolts do
		bolt(launchCFrame, owner, guid, doesDealDamage, boltType)
		if boltType == "normal" then
			wait(0.1)
		elseif boltType == "star" then
			wait(0.05)
		end
	end
end

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource, data)
	network:fireAllClientsExcludingPlayer("abilityFireClientCall", player, abilityExecutionData, self.id, data)
end

function abilityData:execute_client(abilityExecutionData, data)
	throwBolts(data.bolts, data.cframe, data.owner, nil, false, data.boltType)
end

function abilityData._abilityExecutionDataCallback(playerData, abilityExecutionData)
	abilityExecutionData["twilight"] = playerData and playerData.nonSerializeData.statistics_final.activePerks["twilight"]
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	-- assurances
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	local entity = renderCharacterContainer:FindFirstChild("entity")
	if not entity then return end
	local rightHand = entity:FindFirstChild("RightHand")
	if not rightHand then return end
	
	-- animation
	local track = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations["rock_throw_upper"])
	track:Play()
	
	-- pause for effect
	wait(self.windupTime)
	
	-- sounds
	for _, soundTemplate in pairs{script.throw, script.magic} do
		local sound = soundTemplate:Clone()
		sound.Parent = root
		sound:Play()
		debris:AddItem(sound, sound.TimeLength)
	end
	
	-- fire the bolts!
	local bolts = abilityExecutionData["ability-statistics"]["bolts"]
	local boltType = "normal"
	
	if abilityExecutionData["twilight"] then
		bolts = bolts + 4
		boltType = "star"
	end
	
	if isAbilitySource then
		local position = rightHand.Position
		local cframe = CFrame.new(root.Position, abilityExecutionData["mouse-world-position"])
		cframe = cframe + (position - cframe.Position)
		
		throwBolts(bolts, cframe, game.Players.LocalPlayer, guid, true, boltType)
		
		network:fireServer("abilityFireServerCall", abilityExecutionData, self.id, {
			bolts = bolts,
			cframe = cframe,
			owner = game.Players.LocalPlayer,
			boltType = boltType,
		})
	end
end

return abilityData