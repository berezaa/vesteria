-- Funny bolt ripped from magic missile
-- I want to use this for EXP orbs when you kill a monster
local bolt = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local modules = require(replicatedStorage:WaitForChild("modules"))
local placeSetup = modules.load("placeSetup")
local network = modules.load("network")
local levels = modules.load("levels")
local tween = modules.load("tween")

local spawnRegionCollectionsFolder = placeSetup.getPlaceFolder("spawnRegionCollections")
local entityManifestCollectionFolder = placeSetup.getPlaceFolder("entityManifestCollection")
local entityRenderCollectionFolder = placeSetup.getPlaceFolder("entityRenderCollection")
local itemsFolder = placeSetup.getPlaceFolder("items")
local entitiesFolder = placeSetup.getPlaceFolder("entities")
local foilage = placeSetup.getPlaceFolder("foilage")

local RAYCAST_IGNORE_LIST = {
	spawnRegionCollectionsFolder,
	entityManifestCollectionFolder,
	entityRenderCollectionFolder,
	itemsFolder,
	entitiesFolder,
	foilage
}

local rand = Random.new()


local assets = replicatedStorage:WaitForChild("assets")
local entities = assets:WaitForChild("entities")

function bolt.fire(launchCFrame, target, size)
	-- constants for the function
    local contactDistanceSq = 1
	local missileTemplate = entities:FindFirstChild("missile")
    assert(missileTemplate, "missile for exp bolts not found")
	-- create a missile and keep track of it
    local missile = missileTemplate:Clone()

    missile.Size = Vector3.new(1, 1, 1) * size
    missile.top.Position = Vector3.new(0, -size/2, 0)
    missile.bottom.Position = Vector3.new(0, size/2, 0)

	missile.CFrame = launchCFrame * missile.alignAttachment.CFrame:Inverse()

	local mover = missile.mover
    local orientationAttachment = missile.orientationAttachment
    local align = missile.alignOrientation
	local trail = missile.trail

	orientationAttachment.CFrame = launchCFrame
	orientationAttachment.Parent = workspace.Terrain
	missile.Parent = entitiesFolder

	-- this data is used to update
	-- what the missile does in flight
	local boltData = {
		speed = 15,
		missile = missile,
		target = target,
		startTime = tick(),
		-- which way the missile will drift while searching for a target
		driftCFrame = CFrame.Angles(math.pi * 2 * rand:NextNumber(), 0, math.pi * 2 * rand:NextNumber()),
    }

    local offset = Vector3.new(rand:NextNumber() - 0.5, rand:NextNumber() - 0.5, rand:NextNumber() - 0.5) * 2

    local connection
    local finished


    local function finish(wasSuccess)
        if not finished then
            finished = true
            missile.Anchored = true
            trail.Enabled = false
            tween(missile, {"Transparency", "Size"}, {1, missile.Size * 5}, 0.7)
            delay(0.7, function()
                connection:Disconnect()
                orientationAttachment:Destroy()
                missile:Destroy()
            end)
        end
	end

	local function checkForCollision()
		local origin = missile.Position
		local direction = missile.CFrame.LookVector/2
		local ray = Ray.new(origin, direction)
		local part = workspace:FindPartOnRayWithIgnoreList(ray, RAYCAST_IGNORE_LIST, false, true)
		return part ~= nil and part.CanCollide
	end

	-- run every frame while the missile is airborne
	local function update(dt)
        -- move in the direction we're facing
        if finished then
            missile.CFrame = CFrame.new(boltData.target.Position + offset)
        else
            mover.Velocity = (missile.CFrame * missile.alignAttachment.CFrame).LookVector * boltData.speed
            -- accelerate!
            boltData.speed = boltData.speed + (dt or 0) * 15
            align.MaxAngularVelocity = align.MaxAngularVelocity + (dt or 0) * 7


            -- if we have a target, rotate towards it and run logic if we hit

            local directionCFrame = CFrame.new(missile.Position, boltData.target.Position + offset)
            orientationAttachment.CFrame = directionCFrame

            local delta = (boltData.target.Position + offset) - missile.Position
            local distanceSq =
                delta.X * delta.X +
                delta.Y * delta.Y +
                delta.Z * delta.Z

            local size = boltData.target.Size / 4
            local sizeSq =
                size.X * size.X +
                size.Y * size.Y +
                size.Z * size.Z

            if distanceSq <= math.max(contactDistanceSq, sizeSq) then
                finish(true)
            end

            -- if we hit something we're done
            if checkForCollision() then
                finish(false)
            end
        end

	end

    connection = runService.Heartbeat:Connect(update)
	update()

	-- failsafe
	delay(5, function()
		finish(false)
	end)

	return boltData
end

network:connect("signal_exp", "OnClientEvent", function(EXPTable, sourcePart)
    local myCharacter = game.Players.LocalPlayer.Character

    myCharacter = myCharacter and myCharacter.PrimaryPart
    if myCharacter then

        for playerName, EXP in pairs(EXPTable) do
            local player = game.Players:FindFirstChild(playerName)
            local character = player.Character and player.Character.PrimaryPart

            if character and ((character == myCharacter) or (character.Position - myCharacter.Position).magnitude <= 150) then

                local level = player.level.Value
                local needed = levels.getEXPToNextLevel(level)
                local bolts = math.ceil((EXP / needed) * (6 + level * 3))
                for _ = 1, bolts do
                    delay(rand:NextNumber() * 0.5, function()
                        local origin = sourcePart.Position
                        local offset = Vector3.new(3 * (rand:NextNumber() - 0.5), 5, 3 * (rand:NextNumber() - 0.5))
                        local lookat = sourcePart.Position + offset
                        bolt.fire(CFrame.new(origin, lookat), character, 0.3 * EXP ^ (1/3))
                    end)
                end
            end
        end
    end
end)

return bolt