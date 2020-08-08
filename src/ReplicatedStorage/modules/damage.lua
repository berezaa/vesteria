local module = {}

-- hurts but we need to stop circular dependencies
local network 		= require(script.Parent:WaitForChild("network"))
local utilities 	= require(script.Parent:WaitForChild("utilities"))
local placeSetup 	= require(script.Parent:WaitForChild("placeSetup"))
	local entityManifestCollectionFolder 	= placeSetup.getPlaceFolder("entityManifestCollection")

local runService = game:GetService("RunService")

local rand = Random.new(os.time())

local function getNonSerializeData(player)
	local nonSerializeData do
		if runService:IsServer() and player then
			local playerData = network:invoke("getPlayerData", player)
			
			if playerData then
				nonSerializeData = playerData.nonSerializeData
			end
		elseif runService:IsClient() then
			nonSerializeData = network:invoke("getCacheValueByNameTag", "nonSerializeData")
		end
	end
	return nonSerializeData
end

-- TODO(dnurkkala, 8/28/2019): maybe this function is worthless
-- but I'm leaving it here in case we decide to do something
-- with it. not like it does any harm just sitting here uncalled
function module.getNonHostileTargets(playerDoingDamage)
	local nonHostileTargets = {}
	
	for _, entityManifest in pairs(entityManifestCollectionFolder:GetChildren()) do
		if
			entityManifest:IsA("BasePart") and
			entityManifest:FindFirstChild("pet") and
			entityManifest:FindFirstChild("state") and
			entityManifest.state.Value ~= "dead" and
			entityManifest:FindFirstChild("isTargetImmune") == nil
		then
			table.insert(nonHostileTargets, entityManifest)
		end
	end
	
	local nonSerializeData = getNonSerializeData(playerDoingDamage)
	
	if nonSerializeData.isGlobalPVPEnabled or #nonSerializeData.whitelistPVPEnabled > 0 then
		local players = nonSerializeData.isGlobalPVPEnabled and game.Players:GetPlayers() or nonSerializeData.whitelistPVPEnabled
		for _, player in pairs(players) do
			if
				player ~= playerDoingDamage and
				player:FindFirstChild("isInPVP") and
				player.Character and
				player.Character.PrimaryPart
			then
				table.insert(nonHostileTargets, player.Character.PrimaryPart)
			end
		end
	end

	-- you're always non-hostile to yourself
	if playerDoingDamage.Character then
		table.insert(nonHostileTargets, playerDoingDamage.Character.PrimaryPart)
	end
	
	return nonHostileTargets
end

function module.getFriendlies(playerDoingDamage)
	local friendlies = {}
	
	-- our party is friendly!
	local partyData
	if runService:IsClient() then
		partyData = network:invokeServer("playerRequest_getMyPartyData")
	
	elseif runService:IsServer() then
		partyData = network:invoke("getPartyDataByPlayer", playerDoingDamage)
	end
	
	if partyData then
		for _, partyMemberData in pairs(partyData.members) do
			if
				partyMemberData.player and
				partyMemberData.player ~= playerDoingDamage and
				partyMemberData.player.Character
			then
				table.insert(friendlies, partyMemberData.player.Character.PrimaryPart)
			end
		end
	end
	
	-- you're always friendly to yourself
	if playerDoingDamage.Character then
		table.insert(friendlies, playerDoingDamage.Character.PrimaryPart)
	end
	
	return friendlies
end



-- at some point, do some calculations
function module.getDamagableTargets(playerDoingDamage)
	local damagableTargets = {}
	
	for i, entityManifest in pairs(entityManifestCollectionFolder:GetChildren()) do
		if entityManifest:IsA("BasePart") then
			if not entityManifest:FindFirstChild("pet") and entityManifest:FindFirstChild("entityType") and entityManifest.entityType.Value == "monster" and entityManifest:FindFirstChild("state") and entityManifest.state.Value ~= "dead" and not entityManifest:FindFirstChild("isTargetImmune") then
				table.insert(damagableTargets, entityManifest)
			end
		end
	end
		
	local nonSerializeData do
		if runService:IsServer() and playerDoingDamage then
			local playerData = network:invoke("getPlayerData", playerDoingDamage)
			
			if playerData then
				nonSerializeData = playerData.nonSerializeData
			end
		elseif runService:IsClient() then
		-- dnurkkala removed this check and it looks like it won't cause issues but if
		-- shit goes down then y'all can blame me I'm ready to take responsibility

		-- elseif runService:IsClient() and playerDoingDamage == game.Players.LocalPlayer then
			nonSerializeData = network:invoke("getCacheValueByNameTag", "nonSerializeData")
		end
	end
	
	if not nonSerializeData then return damagableTargets end
	
	if nonSerializeData.isGlobalPVPEnabled or #nonSerializeData.whitelistPVPEnabled > 0 then
		local playersToScan = nonSerializeData.isGlobalPVPEnabled and game.Players:GetPlayers() or nonSerializeData.whitelistPVPEnabled
		for i, playerToScan in pairs(playersToScan) do
			if playerToScan ~= playerDoingDamage and playerToScan:FindFirstChild("isInPVP") and playerToScan.isInPVP.Value and playerToScan.Character and playerToScan.Character.PrimaryPart then 
				table.insert(damagableTargets, playerToScan.Character.PrimaryPart)
			end
		end
	end
	
	return damagableTargets
end

function module.canPlayerDamageTarget(playerDoingDamage, target)
	if not target then return false, nil end
	
	local damagableTargets = module.getDamagableTargets(playerDoingDamage)
	
	local trueTarget = target do
		if runService:IsClient() then
			if target:IsDescendantOf(workspace.placeFolders.entityRenderCollection) then
				local currentLocation = target
				local clientHitboxToServerHitboxReference
				
				while not currentLocation:FindFirstChild("clientHitboxToServerHitboxReference") and currentLocation ~= workspace.placeFolders.entityRenderCollection do
					currentLocation = currentLocation.Parent
				end
				
				if currentLocation:FindFirstChild("clientHitboxToServerHitboxReference") then
					trueTarget = currentLocation.clientHitboxToServerHitboxReference.Value
				end
			end
		end
	end
	
	for i, damagableTarget in pairs(damagableTargets) do
		if trueTarget == damagableTarget then
			return true, trueTarget
		end
	end
	
	return false, trueTarget
end

function module.getNeutrals(playerDoingDamage)
	local neutrals = {}
	for i, player in pairs(game.Players:GetPlayers()) do
		if player.Character and player.Character.PrimaryPart then
			local target = player.Character.PrimaryPart
			if not module.canPlayerDamageTarget(playerDoingDamage, target) then
				table.insert(neutrals, player.Character.PrimaryPart)
			end	
		end
	end
	return neutrals
end;

return module

