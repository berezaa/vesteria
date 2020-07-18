local module = {}

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local assets = require(game:GetService("ReplicatedStorage"):WaitForChild("assets_new"))
local network = modules.load("network")
local configuration = modules.load("configuration")

-- x = x0 + v0 * t + 0.5 * g * t ^ 2
-- todo
function module.simulateProjectileMotion()

end

module.romanNumerals = {"I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII","XIII","XIV","XV","XVI","XVII","XVIII","XIX","XX"}

function module.copyTable(tableToCopy)
	local tableCopy = {}
	for i, v in pairs(tableToCopy) do
		if type(v) == "table" then
			tableCopy[i] = module.copyTable(v)
		else
			tableCopy[i] = v
		end
	end

	return tableCopy
end

local function addComas(str)
	return #str % 3 == 0 and str:reverse():gsub("(%d%d%d)", "%1,"):reverse():sub(2) or str:reverse():gsub("(%d%d%d)", "%1,"):reverse()
end

function module.formatNumber(number)
	number = math.floor(number)
	return addComas(tostring(number))
end


function module.isEntityManifestValid(entityManifest, deadIncluded)
	return
			entityManifest:FindFirstChild("entityType")
		and entityManifest:FindFirstChild("entityId")
		and entityManifest:FindFirstChild("state") and (deadIncluded or entityManifest.state.Value ~= "dead")
		and entityManifest:FindFirstChild("health")
		and entityManifest:FindFirstChild("maxHealth")
end

function module.getEntities(_entityType, deadIncluded)
	local entities = {}

	for i, entityObject in pairs(workspace.placeFolders.entityManifestCollection:GetChildren()) do
		local entityManifest do
			if entityObject:IsA("Model") and entityObject.PrimaryPart then
				entityManifest = entityObject.PrimaryPart
			elseif entityObject:IsA("BasePart") then
				entityManifest = entityObject
			end
		end

		if entityManifest then
			if module.isEntityManifestValid(entityManifest, deadIncluded) then
				if not _entityType or entityManifest.entityType.Value == _entityType then
					table.insert(entities, entityManifest)
				end
			end
		end
	end

	return entities
end

function module.timeToString(seconds)
	local days = math.floor(seconds / 86400)
	seconds = seconds - days * 86400
	local hours = math.floor(seconds / 3600)
	seconds = seconds - hours * 3600
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60

	local timestring = ""
	if days > 0 then
		timestring = timestring .. days .. "d "
	end
	if hours > 0 then
		timestring = timestring .. hours .. "h "
	end
	if minutes > 0 then
		timestring = timestring .. minutes .. "m "
	end
	if seconds > 0 then
		timestring = timestring .. seconds .. "s"
	end
	return timestring
end


-- LOCATION: Part, Vector3 or CFrame
-- location and duration are optional


function module.playSound(soundName, location, duration, additionalInfo)
	-- soundName can be an instance (deprecated)
	local sound
	if typeof(soundName) == "string" then
		local soundData = assets.sounds[soundName]
		assert(soundData, "Sound " .. soundName .. " missing from assets.")
		sound = Instance.new("Sound")
		for property, value in pairs(soundData) do
			sound[property] = value
		end
	else
		sound = soundName
	end

	if sound then
		if location then
			if typeof(location) == "Instance" and location:IsA("BasePart") then
				-- existing part

				sound.Volume = additionalInfo and additionalInfo.volume or sound.Volume
				sound.EmitterSize = additionalInfo and additionalInfo.emitterSize or sound.EmitterSize
				sound.MaxDistance = additionalInfo and additionalInfo.maxDistance or sound.MaxDistance

				sound.Parent = location
				sound:Play()

				if not sound.Looped then
					game.Debris:AddItem(sound, duration or sound.TimeLength + 1)
				elseif duration then
					game.Debris:AddItem(sound, duration)
				end

				return sound
			else
				-- create a new part
				local targetCF
				if typeof(location) == "CFrame" then
					targetCF = location
				elseif typeof(location) == "Vector3" then
					targetCF = CFrame.new(location)
				end
				if targetCF then
					local soundPart = Instance.new("Part")
					soundPart.Name = "soundPart"
					soundPart.Size = Vector3.new(1,1,1)
					soundPart.Anchored = true
					soundPart.CanCollide = false
					soundPart.Transparency = 1
					soundPart.CFrame = targetCF
					soundPart.Parent = workspace.CurrentCamera

					sound = sound:Clone()

				sound.Volume = additionalInfo and additionalInfo.volume or sound.Volume
				sound.EmitterSize = additionalInfo and additionalInfo.emitterSize or sound.EmitterSize
				sound.MaxDistance = additionalInfo and additionalInfo.maxDistance or sound.MaxDistance
					sound.Parent = soundPart

					sound:Play()
					if not sound.Looped then
						game.Debris:AddItem(soundPart, duration or sound.TimeLength + 1)
					elseif duration then
						game.Debris:AddItem(soundPart, duration)
					end
					return soundPart
				end
			end
		else
			-- no location provided, just play the root sound
			if sound.Looped then
				sound:Play()
			else
				sound = sound:Clone()
				sound.Parent = workspace.CurrentCamera
				sound:Play()
				game.Debris:AddItem(sound, 1 + sound.TimeLength)
			end

			return sound
		end
	end
end


-- welds two parts together
function module.weld(part0, part1)
	local motor6d 	= Instance.new("Motor6D")
	motor6d.Part0 	= part0
	motor6d.Part1	= part1
	motor6d.C0    	= CFrame.new()
	motor6d.C1 		= part1.CFrame:toObjectSpace(part0.CFrame)
	motor6d.Name 	= part1.Name
	motor6d.Parent	= part0
end

local httpService = game:GetService("HttpService")

function module.safeJSONEncode(t)
	local t2 = module.copyTable(t)
	for i, v in pairs(t2) do
		if typeof(v) == "Vector3" then
			t2[i] = {x = v.X; y = v.Y; z = v.Z}
		elseif typeof(v) == "Vector2" then
			t2[i] = {x = v.X; y = v.Y}
		end
	end

	return pcall(function() return httpService:JSONEncode(t2) end)
end

function module.safeJSONDecode(t)
	local success, response = pcall(function() return httpService:JSONDecode(t) end)

	if success then
		local t2 = module.copyTable(response)
		for i, v in pairs(t2) do
			if typeof(v) == "table" and v.x and v.y and v.z then
				t2[i] = Vector3.new(v.x, v.y, v.z)
			elseif typeof(v) == "table" and v.x and v.y and not v.z then
				t2[i] = Vector2.new(v.x, v.y)
			end
		end

		return true, t2
	end

	return false, nil
end

-- i put this here just so the client and the server can access the same function
local itemLookup
function module.playerCanPickUpItem(player, item, isPet)
	if not itemLookup then
		itemLookup = require(game.ReplicatedStorage.itemData)
	end

	if item:FindFirstChild("pickupBlacklist") and item.pickupBlacklist:FindFirstChild(tostring(player.userId)) then
		return false
	end

	if isPet and item:FindFirstChild("petsIgnore") then
		return false
	end

	if item:FindFirstChild("created") then
		local timeSinceCreated = os.time() - item.created.Value

		if timeSinceCreated >= configuration.getConfigurationValue("timeForAnyonePickupItem") then
			return true
		elseif itemLookup[item.Name] then
			if itemLookup[item.Name].everyoneAvailabilityTime and timeSinceCreated >= itemLookup[item.Name].everyoneAvailabilityTime then
				return true
			end
		end
	end

	if item:FindFirstChild("owners") then
		for _, owner in pairs(item.owners:GetChildren()) do
			if owner.Value == player or tonumber(owner.Name) == player.userId then
				return true
			end
		end

		return false
	end

	return true
end

function module.magnitude(vec)
	local x = vec.x;
	local y = vec.y;
	local z = vec.z;

	local m = (x*x + y*y + z*z)

	return m ^ .5;
end

function module.wipeReferences(tableToLookInto)
	for i, v in pairs(tableToLookInto) do
		if typeof(v) == "Instance" then
			tableToLookInto[i] = nil
		elseif type(v) == "table" then
			module.wipeReferences(v)
		end

		-- do this after iterating through v to make sure we get deepest references
		if typeof(i) == "Instance" then
			tableToLookInto[i] = nil
		end
	end
end

function module.isSafeToProcess(part, doWaitForChild, ...)
	for _, v in pairs({...}) do
		if doWaitForChild then
			part:WaitForChild(v)
		else
			if not part:FindFirstChild(v) then
				return false
			end
		end
	end

	return true
end

function module.isInTable(t, valueToLookFor)
	for _, v in pairs(t) do
		if v == valueToLookFor then
			return true
		end
	end

	return false
end

local itemWeightSelectionGenerator = Random.new()
function module.selectFromWeightTable(weightTable)
	local sum = 0
	for _, item in pairs(weightTable) do
		sum = sum + item.selectionWeight
	end

	while true do
		local rIndex 	= itemWeightSelectionGenerator:NextInteger(1, #weightTable)
		local item 		= weightTable[rIndex]

		if item then
			if sum - item.selectionWeight > 0 then
				sum = sum - item.selectionWeight
			else
				return item, rIndex
			end
		else

			return weightTable[1] or {}, weightTable[1] and 1 or nil
		end
	end
end

local function findObjectHelper(model, objectName, className, listOfFoundObjects)
	if not model then return end
	local findStart, findEnd = string.find(model.Name, objectName)
	if findStart == 1 and findEnd == #(model.Name) then  -- must match entire name
		if not className or model.className == className or (pcall(model.IsA, model, className) and model:IsA(className)) then
			table.insert(listOfFoundObjects, model)
		end
	end
	if pcall(model.GetChildren, model) then
		local modelChildren = model:GetChildren()
		for i = 1, #modelChildren do
			findObjectHelper(modelChildren[i], objectName, className, listOfFoundObjects)
		end
	end
end

local function resizeModelInternal(model, resizeFactor)
	local modelCFrame = model:GetModelCFrame()
	local modelSize = model:GetModelSize()
	local baseParts = {}
	local basePartCFrames = {}
	local joints = {}
	local jointParents = {}
	local meshes = {}

	findObjectHelper(model, ".*", "BasePart", baseParts)
	findObjectHelper(model, ".*", "JointInstance", joints)

	-- meshes don't inherit from anything accessible?
	findObjectHelper(model, ".*", "FileMesh", meshes)                    -- base class for SpecialMesh and FileMesh
	findObjectHelper(model, ".*", "CylinderMesh", meshes)
	findObjectHelper(model, ".*", "BlockMesh", meshes)

	-- store the CFrames, so our other changes don't rearrange stuff
	for _, basePart in pairs(baseParts) do
		basePartCFrames[basePart] = basePart.CFrame
	end

	-- scale joints
	for _, joint in pairs(joints) do
		joint.C0 = joint.C0 + (joint.C0.p) * (resizeFactor - 1)
		joint.C1 = joint.C1 + (joint.C1.p) * (resizeFactor - 1)
		jointParents[joint] = joint.Parent
	end

	-- scale parts and reposition them within the model
	for _, basePart in pairs(baseParts) do
		-- if pcall(function() basePart.FormFactor = "Custom" end) then basePart.FormFactor = "Custom" end
		basePart.Size = basePart.Size * resizeFactor
		local oldCFrame = basePartCFrames[basePart]
		local oldPositionInModel = modelCFrame:pointToObjectSpace(oldCFrame.p)
		local distanceFromCorner = oldPositionInModel + modelSize/2
		distanceFromCorner = distanceFromCorner * resizeFactor

		local newPositionInSpace = modelCFrame:pointToWorldSpace(distanceFromCorner - modelSize/2)
		basePart.CFrame = oldCFrame - oldCFrame.p + newPositionInSpace
	end

	-- scale meshes
	for _,mesh in pairs(meshes) do
--		mesh.Scale = mesh.Scale * resizeFactor
	end

	-- pop the joints back, because they prolly got borked
	for _, joint in pairs(joints) do
		joint.Parent = jointParents[joint]
	end

	return model
end

function module.getEntityGUIDByEntityManifest(entityManifest)
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

-- returns
-- * BasePart entityManifest
-- * Boolean isEntityInWorld [even if first argument is nil, treat it like it isn't... ie if player is respawning]
function module.getEntityManifestByEntityGUID(entityGUID)
	local entityManifests = module.getEntities(nil, true)

	for i, entityManifest in pairs(entityManifests) do
		local _entityGUID = module.getEntityGUIDByEntityManifest(entityManifest)
		if _entityGUID == entityGUID then
			return entityManifest, true
		end
	end

	for i, player in pairs(game.Players:GetPlayers()) do
		if player:FindFirstChild("entityGUID") and player.entityGUID.Value == entityGUID then
			return nil, true
		end
	end

	return nil, false
end

function module.connectEventHelper(event, func)
	local connection
	connection = event:connect(function(...)
		local doDisconnect = func(...)

		if doDisconnect then
			connection:disconnect()
		end
	end)

	return connection
end

module.placeIdMapping = {
	["2376885433"] = 2015602902;
	["2064647391"] = 4041449372;
	["2035250551"] = 4041616995;
	["2060360203"] = 4041642879;
	["2060556572"] = 4784798551;
	["2093766642"] = 4784800626;
	["2471035818"] = 4042327457;
	["2546689567"] = 4042356215;
	["3852057184"] = 4041618739;
	["2376890690"] = 4042533453;
	["2470481225"] = 4042553675;
	["2260598172"] = 4042431927;
	["3112029149"] = 4042493740;
	["3460262616"] = 4042399045;
	["2496503573"] = 4042381342;
	["2119298605"] = 4042577479;
	["2878620739"] = 4042595899;
	["2677014001"] = 4786263828;

	["3232913902"] = 4787417227;
	["2544075708"] = 4787415375;
}

function module.placeIdForGame(placeId)

	if game.GameId == 712031239 then
		return module.placeIdMapping[tostring(placeId)] or placeId
	else
		return placeId
	end
end

function module.originPlaceId(placeId)
	if game.GameId == 712031239 then
		for originPlaceIdString, mappedId in pairs(module.placeIdMapping) do
			if mappedId == placeId then
				return tonumber(originPlaceIdString)
			end
		end
	end
	return placeId
end

module.scale = resizeModelInternal

function module.doesPlayerHaveEquipmentPerk(player, perkName)
	local char = player.Character
	if not char then return false end
	local entityManifest = char.PrimaryPart
	if not entityManifest then return false end
	local renderCharacterContainer = network:invoke("getRenderCharacterContainerByEntityManifest", entityManifest)
	if not renderCharacterContainer then return false end
	local entityRender = renderCharacterContainer:FindFirstChild("entity")
	if not entityRender then return false end
	local equipment = network:invoke("getCurrentlyEquippedForRenderCharacter", entityRender)
	if not equipment then return false end

	for position, info in pairs(equipment) do
		if info.baseData.perks then
			for perk, active in pairs(info.baseData.perks) do
				if perk == perkName then
					return active
				end
			end
		end
	end

	return false
end

function module.calculateNumArrowsFromDex(dex)
	local numArrows = 1
	local dexAccumulator = 0
	local currentDexStep = 20

	repeat
		dexAccumulator = dexAccumulator + currentDexStep
		currentDexStep = currentDexStep + 10
		if dexAccumulator <= dex then
			numArrows = numArrows + 1
		end
	until dexAccumulator >= dex

	return numArrows
end

function module.calculatePierceFromStr(str)
	local pierce = 0
	local accumulator = 0
	local currentStep = 20
	local stepIncrease = 10

	repeat
		accumulator = accumulator + currentStep
		currentStep = currentStep + stepIncrease
		if accumulator <= str then
			pierce = pierce + 1
		end
	until accumulator >= str

	return pierce
end

function module.doesEntityHaveStatusEffect(entity, statusEffectName)
	local statusEffectsV2 = entity:FindFirstChild("statusEffectsV2")
	if not statusEffectsV2 then return false end

	local success, statusEffects = module.safeJSONDecode(statusEffectsV2.Value)
	if not success then return false end

	for _, statusEffect in pairs(statusEffects) do
		if statusEffect.statusEffectType == statusEffectName then
			return true
		end
	end

	return false
end

function module.healEntity(sourceEntity, targetEntity, amount)
	local health = targetEntity:FindFirstChild("health")
	if not health then return end
	local maxHealth = targetEntity:FindFirstChild("maxHealth")
	if not maxHealth then return end

	local healthBefore = health.Value
	health.Value = math.min(health.Value + amount, maxHealth.Value)
	local trueHealing = health.Value - healthBefore

	if trueHealing > 1 then
		network:fireAllClients("signal_damage", targetEntity, {
			damage = -trueHealing,
		})
	end
end

local function rankCheck(player)
	wait(0.1)

	local playerRank = 0 do
		local success, returnValue = pcall(function()
			return player:GetRankInGroup(4238824)
		end)

		if success and returnValue > playerRank then
			playerRank = returnValue
		end
	end

	if game:GetService("RunService"):IsStudio() or player.Name == "berezaa" or player.Name == "Polymorphic" or player.Name == "sk3let0n" or playerRank >= 250 then
		local devTag 	= Instance.new("BoolValue")
		devTag.Name 	= "developer"
		devTag.Parent 	= player
	end

	if playerRank > 1 then
		local devTag 	= Instance.new("BoolValue")
		devTag.Name 	= "QA"
		devTag.Parent 	= player
--	elseif game.PlaceId == 2061558182 and not (runService:IsRunMode() or runService:IsStudio()) then
--		player:Kick("Not allowed to be here.")
	end
end

game.Players.PlayerAdded:connect(rankCheck)
for _, player in pairs(game.Players:GetPlayers()) do
	rankCheck(player)
end

return module