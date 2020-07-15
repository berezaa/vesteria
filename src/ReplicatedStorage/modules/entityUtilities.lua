local module = {}

local lookupTable = {}

function module.getEntityGUIDByEntityManifest(entityManifest)
	if entityManifest:IsA("Model") then
		if not entityManifest.PrimaryPart then
			return
		end
		
		entityManifest = entityManifest.PrimaryPart
	end
	
	local player
	if entityManifest.Parent and entityManifest.Parent:IsA("Model") then
		player = game.Players:GetPlayerFromCharacter(entityManifest.Parent)
	end
	
	-- this is important because 1 player will always have the same GUID, but the character
	-- might change!
	if player then
		return player.entityGUID.Value
	elseif entityManifest:FindFirstChild("entityGUID") then
		return entityManifest.entityGUID.Value
	end
		
	return nil
end

function module.getEntityManifestByEntityGUID(entityGUID)
	return lookupTable[entityGUID]
end

local function onEntityManifestAdded(entityManifest)
	if entityManifest:IsA("Model") then
		if not entityManifest.PrimaryPart then
			return
		end
		
		entityManifest = entityManifest.PrimaryPart
	end
	
	local entityGUID = module.getEntityGUIDByEntityManifest(entityManifest)
	
	if entityGUID then
		lookupTable[entityGUID] = entityManifest
	end
end

local function onEntityManifestRemoved(entityManifest)
	if entityManifest:IsA("Model") then
		if not entityManifest.PrimaryPart then
			return
		end
		
		entityManifest = entityManifest.PrimaryPart
	end
	
	-- clear up references
	for entityGUID, _entityManifest in pairs(lookupTable) do
		if _entityManifest == entityManifest then
			lookupTable[entityGUID] = nil
		end
	end
end

-- hookup events to stalk the entities folder
coroutine.wrap(function()
	workspace:WaitForChild("placeFolders"):WaitForChild("entityManifestCollection")
	
	for i, entityManifest in pairs(workspace.placeFolders.entityManifestCollection:GetChildren()) do
		onEntityManifestAdded(entityManifest)
	end
	
	workspace.placeFolders.entityManifestCollection.ChildAdded:connect(onEntityManifestAdded)
	workspace.placeFolders.entityManifestCollection.ChildRemoved:connect(onEntityManifestRemoved)
end)()

return module