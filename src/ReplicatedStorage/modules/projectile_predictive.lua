local module 	= {}
local projectileQueue = {}

local projectileUpdateConnection
local runService = game:GetService("RunService")

local player = game.Players.LocalPlayer

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 		= modules.load("network")
	local placeSetup 	= modules.load("placeSetup")
	local utilities		= modules.load("utilities")

local entitiesPlaceFolder = placeSetup.getPlaceFolder("entities")

local myClientCharacterContainer

-- how long each segment of 'raycasting' is, this number is needed
-- to ensure raycast is approximate to the real function. smaller = better
local segmentLength = 3

local GRAVITY 		= Vector3.new(0, 0.5 * 60, 0)
local LAST_UPDATE 	= tick()
local IGNORE_LIST 	= {}
local function raycastBetween_accomodate(startTime, origin, speed, velocity, i)
	local previous_i 			= i - 1 > 0 and i - 1 or 0
	local t 					= (LAST_UPDATE + segmentLength / speed * i) - startTime
	local t_compare 			= (LAST_UPDATE + segmentLength / speed * (previous_i)) - startTime
	local newPosition 			= origin + velocity * t - GRAVITY * t * t
	local newPosition_compare 	= origin + velocity * t_compare - GRAVITY * t_compare * t_compare
	
	--workspace.tracker.visualizer.CFrame = CFrame.new(newPosition)
	
	return workspace:FindPartOnRayWithIgnoreList(
		Ray.new(
			newPosition_compare,
			newPosition - newPosition_compare
		), IGNORE_LIST
	)
end

local function raycastDownIgnoreCancollideFalse(ray, ignoreList)
	local hitPart, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
	
	while hitPart and not hitPart.CanCollide do
		ignoreList[#ignoreList + 1] = hitPart
		hitPart, hitPosition 		= workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
	end
	
	return hitPart, hitPosition
end

local function int__updateProjectiles(step)
	for i, projectileData in pairs(projectileQueue) do
		local distanceMoved = projectileData.velocity * step - GRAVITY * step * step
		if utilities.magnitude(distanceMoved) >= segmentLength then

			for i = 1, math.floor(utilities.magnitude(distanceMoved) / segmentLength) do
				local hitPart, hitPosition = raycastBetween_accomodate(projectileData.startTime, projectileData.origin, projectileData.speed, projectileData.velocity, i)
				
				if projectileData.trackerPart then
					projectileData.trackerPart.CFrame = CFrame.new(hitPosition)
				end
				
				if hitPart then
					projectileData.collisionFunction(hitPart)
					projectileData.markForRemove = true
				end
			end
		end
		
		if not projectileData.markForRemove then
			local i = (utilities.magnitude(distanceMoved) / segmentLength) % 1
			
			if i > 0 then
				local hitPart, hitPosition = raycastBetween_accomodate(projectileData.startTime, projectileData.origin, projectileData.speed, projectileData.velocity, i)
				
				if projectileData.trackerPart then
					projectileData.trackerPart.CFrame = CFrame.new(hitPosition)
				end
				
				if hitPart then
					projectileData.collisionFunction(hitPart)
					projectileData.markForRemove = true
				elseif tick() - projectileData.startTime > 3 then
					projectileData.collisionFunction(nil)
					projectileData.markForRemove = true
				end
			end
		end
		
		if projectileData.markForRemove then
			table.remove(projectileQueue, i)
		end
	end
	
	if #projectileQueue == 0 then

		projectileUpdateConnection:disconnect()
		projectileUpdateConnection = nil
	end
	
	LAST_UPDATE = tick()
end

function module.createProjectile(origin, direction, speed, trackerPart, collisionFunction)
	table.insert(projectileQueue, {
		origin 				= origin;
		direction 			= direction;
		speed 				= speed;
		velocity 			= direction * speed;
		collisionFunction 	= collisionFunction;
		trackerPart 		= trackerPart;
		startTime 			= tick();
	})
	
	if not projectileUpdateConnection then
		projectileUpdateConnection = runService.Heartbeat:connect(int__updateProjectiles)
	end
end

local function onCharacterAdded(character)
	myClientCharacterContainer = network:invoke("getMyClientCharacterContainer")
	
	IGNORE_LIST = {character; myClientCharacterContainer; entitiesPlaceFolder}
end

local function main()
	while not game.Players.LocalPlayer do wait() end
	player = game.Players.LocalPlayer
	
	if player.Character then
		onCharacterAdded(player.Character)
	end
	
	player.CharacterAdded:connect(onCharacterAdded)
end

spawn(main)

return module