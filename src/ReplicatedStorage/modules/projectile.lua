local module 	= {}
local projectileQueue = {}

local projectileUpdateConnection
local runService = game:GetService("RunService")

local player = game.Players.LocalPlayer

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 		= modules.load("network")
	local configuration = modules.load("configuration")
	local placeSetup 	= modules.load("placeSetup")
	local damage 		= modules.load("damage")
	local detection 	= modules.load("detection")

local entitiesPlaceFolder 				= placeSetup.getPlaceFolder("entities")
local entityManifestCollectionFolder 	= placeSetup.getPlaceFolder("entityManifestCollection")

local myClientCharacterContainer

-- how long each segment of 'raycasting' is, this number is needed
-- to ensure raycast is approximate to the real function. smaller = better
local segmentLength = 3

local LAST_UPDATE 	= tick()



local GRAVITY 		= Vector3.new(0, -60, 0)
	module.GRAVITY = GRAVITY
	
function module.calculateBeamProjectile(x0, v0, t1, gMulti)
	gMulti = gMulti or 1
	
	-- calculate the bezier points
	local c = 0.5*0.5*0.5;
	local p3 = 0.5*GRAVITY*gMulti*t1*t1 + v0*t1 + x0;
	local p2 = p3 - (GRAVITY*gMulti*t1*t1 + v0*t1)/3;
	local p1 = (c*GRAVITY*gMulti*t1*t1 + 0.5*v0*t1 + x0 - c*(x0+p3))/(3*c) - p2;
	
	-- the curve sizes
	local curve0 = (p1 - x0).magnitude;
	local curve1 = (p2 - p3).magnitude;
	
	-- build the world CFrames for the attachments
	local b = (x0 - p3).unit;
	local r1 = (p1 - x0).unit;
	local u1 = r1:Cross(b).unit;
	local r2 = (p2 - p3).unit;
	local u2 = r2:Cross(b).unit;
	b = u1:Cross(r1).unit;
	
	local cf1 = CFrame.new(
		x0.x, x0.y, x0.z,
		r1.x, u1.x, b.x,
		r1.y, u1.y, b.y,
		r1.z, u1.z, b.z
	)
	
	local cf2 = CFrame.new(
		p3.x, p3.y, p3.z,
		r2.x, u2.x, b.x,
		r2.y, u2.y, b.y,
		r2.z, u2.z, b.z
	)
	
	return curve0, -curve1, cf1, cf2;
end

function module.showProjectilePath(x0, v0, t, gMulti)
	gMulti = gMulti or 1
	
	local attach0 = Instance.new("Attachment", workspace.Terrain)
	local attach1 = Instance.new("Attachment", workspace.Terrain)
	
	local beam 			= Instance.new("Beam", workspace.Terrain)
	beam.Attachment0 	= attach0
	beam.Attachment1 	= attach1
	
	local curve0, curve1, cf1, cf2 = module.calculateBeamProjectile(x0, v0, t, gMulti)
	
	beam.CurveSize0 = curve0
	beam.CurveSize1 = curve1
	beam.Segments 	= 50
	
	-- convert world space CFrames to be relative to the attachment parent
	attach0.CFrame = attach0.Parent.CFrame:inverse() * cf1
	attach1.CFrame = attach1.Parent.CFrame:inverse() * cf2
	
	return beam, attach0, attach1
end

function module.updateProjectilePath(beam, attach0, attach1, x0, v0, t, gravMulti)
	gravMulti = gravMulti or 1
	
	local curve0, curve1, cf1, cf2 = module.calculateBeamProjectile(x0, v0, t, gravMulti)
	
	beam.CurveSize0 = curve0
	beam.CurveSize1 = curve1
	beam.Segments 	= 50
	
	-- convert world space CFrames to be relative to the attachment parent
	attach0.CFrame = attach0.Parent.CFrame:inverse() * cf1
	attach1.CFrame = attach1.Parent.CFrame:inverse() * cf2
end

local function raycast(ray, ignoreList)
	local hitPart, hitPosition, hitNormal, hitMaterial = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
	
	while hitPart and not hitPart.CanCollide do
		ignoreList[#ignoreList + 1] 					= hitPart
		hitPart, hitPosition, hitNormal, hitMaterial 	= workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
	end
	
	return hitPart, hitPosition, hitNormal, hitMaterial
end

-- oh wow ;o
module.raycastForProjectile = raycast
module.raycast 				= raycast

local FFLAG_DO_EXTRA_COLLISION_CHECK

local function getManifests()
	local m = {}
	for i, v in pairs(entityManifestCollectionFolder:GetChildren()) do
		if v:IsA("BasePart") then
			table.insert(m, v)
		elseif v:IsA("Model") and v.PrimaryPart then
			table.insert(m, v.PrimaryPart)
		end
	end
	
	return m
end

local function int__updateProjectiles(step)
	local currTime 	= LAST_UPDATE + step
	local targets 	= getManifests()
	
	for i, projectileData in pairs(projectileQueue) do
		local t 			= currTime - projectileData.startTime
		local nextPosition 	= projectileData.origin + projectileData.velocity * t + 0.5 * (GRAVITY * projectileData.projectileGravityMultipler) * t * t
		
		local dir = nextPosition - projectileData.lastPosition
		
		local hitPart, hitPosition, hitNormal, hitMaterial = raycast(
			Ray.new(
				projectileData.lastPosition,
				dir + dir.unit * 0.15
			), projectileData.ignoreList or {entitiesPlaceFolder, placeSetup.getPlaceFolder("items"), placeSetup.getPlaceFolder("foilage"), game.Players.LocalPlayer.Character}
		)
		
		local alterationCF
		if projectileData.stepFunction then
			alterationCF = projectileData.stepFunction(t)
		end
		
		if projectileData.trackerPart then
			if projectileData.pointToNextPosition then
				if alterationCF then
					projectileData.trackerPart.CFrame = CFrame.new(hitPosition, hitPosition + dir) * alterationCF
				else
					projectileData.trackerPart.CFrame = CFrame.new(hitPosition, hitPosition + dir)
				end
			else
				if alterationCF then
					projectileData.trackerPart.CFrame = CFrame.new(hitPosition) * alterationCF
				else
					projectileData.trackerPart.CFrame = CFrame.new(hitPosition)
				end
			end
			
			if configuration.getConfigurationValue("doUseTrackerPartAsHitbox", player) then
				if not hitPart then
					for i, manifest in pairs(targets) do
						if not projectileData.reverseIgnoreList or not projectileData.reverseIgnoreList[manifest] then
							local adjustPos = detection.projection_Box(manifest.CFrame, manifest.Size, projectileData.trackerPart.CFrame.p)
							
							if detection.boxcast_singleTarget(projectileData.trackerPart.CFrame, projectileData.trackerPart.Size, adjustPos) then
								hitPart = manifest
							end
						end
					end
				end
			end
		end
		
		if hitPart or t > (projectileData.projectileLifetime or 3) then
			table.remove(projectileQueue, i)
			
			local clamp_t = math.clamp(t, 0, projectileData.projectileLifetime or 3)
			
			if t <= (projectileData.projectileLifetime or 3) and (not projectileData.collisionFunction or not projectileData.collisionFunction(hitPart, hitPosition, hitNormal, hitMaterial, clamp_t)) then
				-- keep it removed
			elseif t <= (projectileData.projectileLifetime or 3) and projectileData.collisionFunction then
				-- returned true, so it means we should ignore the part we hit
				projectileData.lastPosition = nextPosition
				
				table.insert(projectileQueue, projectileData)
				table.insert(projectileData.ignoreList, hitPart)
			else
				projectileData.collisionFunction(hitPart, hitPosition, hitNormal, hitMaterial, clamp_t)
			end
		else
			projectileData.lastPosition = nextPosition
		end	
	end
	
	if #projectileQueue == 0 and projectileUpdateConnection then
		projectileUpdateConnection:disconnect()
		projectileUpdateConnection = nil
	end
	
	LAST_UPDATE = tick()
end

function module.createProjectile(origin, direction, speed, trackerPart, collisionFunction, stepFunction, ignoreList, pointToNextPosition, projectileGravityMultipler, projectileLifetime)
	local projectileData = {
		origin 						= origin;
		direction 					= direction;
		speed 						= speed;
		velocity 					= direction * speed;
		collisionFunction 			= collisionFunction;
		trackerPart 				= trackerPart;
		stepFunction 				= stepFunction;
		lastPosition 				= origin;
		startTime 					= tick();
		ignoreList 					= ignoreList;
		pointToNextPosition 		= pointToNextPosition or false;
		projectileGravityMultipler 	= projectileGravityMultipler or 1;
		projectileLifetime 			= projectileLifetime or 3;
	}
	
	if projectileData.ignoreList then
		projectileData.reverseIgnoreList = {}
		
		for i,v in pairs(projectileData.ignoreList) do
			projectileData.reverseIgnoreList[v] = true
		end
	end
	
	table.insert(projectileQueue, projectileData)
	
	if not projectileUpdateConnection then
		LAST_UPDATE 				= tick()
		projectileUpdateConnection 	= runService.Heartbeat:connect(int__updateProjectiles)
	end
end

function module.createProjectileByProjectileData(projectileData)
	assert(projectileData.origin, "projectileData lacking origin")
	assert(projectileData.origin, "projectileData lacking direction")
	assert(projectileData.origin, "projectileData lacking speed")
	
	-- start at origin
	projectileData.lastPosition 				= projectileData.origin
	projectileData.startTime 					= tick()
	projectileData.ignoreList 					= projectileData.ignoreList;
	projectileData.pointToNextPosition 			= projectileData.pointToNextPosition or false;
	projectileData.projectileGravityMultipler 	= projectileData.projectileGravityMultipler or 1;
	projectileData.projectileLifetime 			= projectileData.projectileLifetime or 3;
	projectileData.collisionFunction 			= projectileData.collisionFunction or nil;
	projectileData.trackerPart 					= projectileData.trackerPart or nil;
	projectileData.stepFunction 				= projectileData.stepFunction or nil;
end

function module.makeIgnoreList(additions)
	local ignoreList = {
		placeSetup.getPlaceFolder("entities"),
		placeSetup.getPlaceFolder("spawnRegionCollections"),
		placeSetup.getPlaceFolder("items"),
		placeSetup.getPlaceFolder("foilage"),
	}
	
	for _, addition in pairs(additions or {}) do
		table.insert(ignoreList, addition)
	end
	
	return ignoreList
end

local sqrt = math.sqrt
function module.getUnitVelocityToImpact_predictive(projecileStartPosition, projectileSpeed, targetPosition, targetVelocity, projectileGravityMultipler, projectileLifetime)
	projectileLifetime = projectileLifetime or 3

	projectileGravityMultipler = projectileGravityMultipler or 1
	
	local p1x = projecileStartPosition.X
	local p1z = projecileStartPosition.Z
	
	local p2x = targetPosition.X
	local p2z = targetPosition.Z
	
	local v2x = targetVelocity.X
	local v2z = targetVelocity.Z
	
	-- 0 = at^2 + bt + c
	local a = (v2x * v2x + v2z * v2z - projectileSpeed * projectileSpeed)
	local b = (2*p2x*v2x - 2*p1x*v2x+ 2*p2z*v2z  - 2*p1z*v2z)
	local c = (p2x*p2x - 2*p2x*p1x + p1x*p1x + p2z*p2z - 2*p2z*p1z + p1z*p1z)
	
	if b * b - 4 * a * c < 0 then
		-- solution is a complex number, not real
		return nil, nil
	end
	
	local t1 = (-b + math.sqrt(b * b - 4 * a * c)) / (2 * a)
	local t2 = (-b - math.sqrt(b * b - 4 * a * c)) / (2 * a)
	
	if t1 < 0 and t2 < 0 then
		-- no valid solution in the future, both solutions in the past
		return nil, nil
	end
	
	-- use smallest (postitive) time value
	local t
	if t1 > 0 and t2 < 0 then
		t = t1
	elseif t2 > 0 and t1 < 0 then
		t = t2
	elseif t1 > 0 and t2 > 0 then
		t = t1 < t2 and t1 or t2
	end
	
	if t > projectileLifetime then
		return nil, nil
	end
	
	-- find where we think the target will be after time `t`
	local adjusted_targetPosition = targetPosition + t * targetVelocity 
	
	local unitDirection = (adjusted_targetPosition - projecileStartPosition - 0.5 * (module.GRAVITY * projectileGravityMultipler) * t^2) / (projectileSpeed * t)
	
	return unitDirection, adjusted_targetPosition
end


-- added scalable predicivity to find a nice balance on a per mob basis
--[[function module.getUnitVelocityToImpact_slightpredictive(projecileStartPosition, projectileSpeed, targetPosition, targetVelocity, projectileGravityMultipler, predictivityMultiplier)

	projectileGravityMultipler = projectileGravityMultipler or 1
	
	local p1x = projecileStartPosition.X
	local p1z = projecileStartPosition.Z
	
	local p2x = targetPosition.X
	local p2z = targetPosition.Z
	
	local v2x = targetVelocity.X
	local v2z = targetVelocity.Z
	
	-- 0 = at^2 + bt + c
	local a = (v2x * v2x + v2z * v2z - projectileSpeed * projectileSpeed)
	local b = (2*p2x*v2x - 2*p1x*v2x+ 2*p2z*v2z  - 2*p1z*v2z)
	local c = (p2x*p2x - 2*p2x*p1x + p1x*p1x + p2z*p2z - 2*p2z*p1z + p1z*p1z)
	
	if b * b - 4 * a * c < 0 then
		-- solution is a complex number, not real
		return nil, nil
	end
	
	local t1 = (-b + math.sqrt(b * b - 4 * a * c)) / (2 * a)
	local t2 = (-b - math.sqrt(b * b - 4 * a * c)) / (2 * a)
	
	if t1 < 0 and t2 < 0 then
		-- no valid solution in the future, both solutions in the past
		return nil, nil
	end
	
	-- find the largest time value and use it (incase one was negative, and one isn't
	local t = t1 > t2 and t1 or t2
	
	-- find where we think the target will be after time `t`
	local adjusted_targetPosition = targetPosition + t * Vector3.new(targetVelocity.X * predictivityMultiplier, targetVelocity.Y * predictivityMultiplier, targetVelocity.Z * predictivityMultiplier)
	
	local unitDirection = (adjusted_targetPosition - projecileStartPosition - 0.5 * (module.GRAVITY * projectileGravityMultipler) * t^2) / (projectileSpeed * t)
	
	return unitDirection, adjusted_targetPosition
end]]--
	

function module.getTargetPositionByAbilityExecutionData(abilityExecutionData)
	return
		abilityExecutionData["target-casting-position"]
		or abilityExecutionData["target-position"]
		or abilityExecutionData["mouse-world-position"]
end
	
function module.getUnitVelocityToImpact_predictiveByAbilityExecutionData(projecileStartPosition, projectileSpeed, abilityExecutionData, projectileGravityMultipler)
	return module.getUnitVelocityToImpact_predictive(
		projecileStartPosition,
		projectileSpeed,
		module.getTargetPositionByAbilityExecutionData(abilityExecutionData),
		(abilityExecutionData["target-casting-position"] and Vector3.new()) or abilityExecutionData["target-velocity"] or Vector3.new(),
		projectileGravityMultipler
	)
end

local clientCharacter
local function onCharacterAdded(character)
	local IGNORE_LIST = {character; entitiesPlaceFolder}
end

local function main()
	if runService:IsClient() then
		while not game.Players.LocalPlayer do wait() end
		player = game.Players.LocalPlayer
		
		if player.Character then
			onCharacterAdded(player.Character)
		end
		
		player.CharacterAdded:connect(onCharacterAdded)
	end
	game.ReplicatedStorage.cust_test_stuff.grav.Changed:connect(function(val)
		GRAVITY 		= Vector3.new(0, val, 0)
		module.GRAVITY 	= GRAVITY
	end)
end

spawn(main)

return module