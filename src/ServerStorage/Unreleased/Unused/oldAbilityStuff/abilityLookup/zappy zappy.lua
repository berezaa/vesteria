local runService 		= game:GetService("RunService")
local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local tween	 			= modules.load("tween")
	local configuration	 	= modules.load("configuration")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local httpService 	= game:GetService("HttpService")

local abilityData = {
	--> identifying information <--
	id 	= 32;
	
	--> generic information <--
	name 		= "Zap!";
	image 		= "rbxassetid://3736598178";
	description = "Zap your foes! Levels 5 & 10 add an electric beam.";
	mastery = "Longer reach.";
	
	damageType = "magical";
		
	--> execution information <--
	animationName 			= {};
	windupTime 				= 0.35;
	maxRank 				= 10;
	projectileSpeed 		= 80;
	maxUpdateTimes 			= 5;
	
	--> combat stats <--
	statistics = {
		[1] = {
			distance 			= 30;
			manaCost			= 20;
			cooldown 			= 3;
			damageMultiplier 	= 1.1;
			bolts = 3;
			tier = 1;
		};
		[2] = {
			damageMultiplier 	= 1.15;
		};
		[3] = {
			damageMultiplier 	= 1.2;
		};
		[4] = {
			damageMultiplier 	= 1.25;
		};
		[5] = {
			damageMultiplier 	= 1.3;
			manaCost			= 25;
			bolts = 4;
			tier = 2;
		};
		[6] = {
			damageMultiplier 	= 1.35;
		};
		[7] = {
			damageMultiplier 	= 1.4;
		};
		[8] = {
			damageMultiplier 	= 1.45;
		};
		[9] = {
			damageMultiplier 	= 1.5;
		};
		[10] = {
			damageMultiplier 	= 1.6;
			manaCost			= 30;
			bolts = 5;
			tier = 3;
		};						
	};
	
	securityData = {
		playerHitMaxPerTag 	= 5;
--		maxHitLockout 		= 1;
		isDamageContained 	= true;
		projectileOrigin 	= "character";
	};
	
	abilityDecidesEnd = true;
}

-- network:fireServer("playerRequest_damageEntity", player, serverHitbox, damagePosition, sourceType, sourceId, sourceTag, guid)
function abilityData._serverProcessDamageRequest(sourceTag, baseDamage, entityManifest, previousHitsOnEntityManifest)
	if sourceTag == "bolt" then
		--[[
		if previousHitsOnEntityManifest > 0 then
			return baseDamage * 0.5, "magical", "direct"
		end
		]]
		
		return baseDamage, "magical", "direct"
	end
end

local function drawLightningSegment(startPos, finishPos, tier)
	tier = tier or 1
	local mag = (finishPos - startPos).magnitude
	
	local line = Instance.new("Part")
	line.Anchored = true
	line.CanCollide = false
	line.TopSurface = Enum.SurfaceType.Smooth
	line.BottomSurface = Enum.SurfaceType.Smooth
	line.Material = Enum.Material.Neon
	line.BrickColor = BrickColor.new("Electric blue")
	
	line.Size = Vector3.new(0.1 * tier, 0.1 * tier, mag)
	line.CFrame = CFrame.new(startPos, finishPos) * CFrame.new(0, 0, -mag/2)
	
	line.Parent = entitiesFolder
	
	tween(line, {"Transparency"}, 1, 0.5)
	
	game:GetService("Debris"):AddItem(line, 0.5)
end

local segmentLength = 3

local function fireLightning2(startPos, finishPos, doBranch, offsetMulti, isAbilitySource, renderCharacterContainer, abilityExecutionData, id, guid)
	
	local mag = (finishPos - startPos).magnitude
	local maximumOffset = math.sqrt(mag / 2) * (offsetMulti or 1)
	local numGenerations = 4
	
	local tier = abilityExecutionData["ability-statistics"]["tier"]
	
	local segments = {{startPos, finishPos}}
	for i = 1, numGenerations do
		local newSegmentsList = {}
		for ind, segment in pairs(segments) do
			local start 	= segment[1]
			local finish 	= segment[2]
			
			local r = 360 * math.random()
			local d = maximumOffset * math.random()
			
			local facing = CFrame.new(start, finish)
			local mag = (finish - start).magnitude
			
			local cf = facing * CFrame.new(0, 0, -mag * math.random(40, 60) / 100) * CFrame.Angles(0, 0, math.rad(r)) * CFrame.new(0, d * math.random(80, 120) / 100, 0)
			
			table.insert(newSegmentsList, {start, cf.p})
			table.insert(newSegmentsList, {cf.p, finish})
			
			if doBranch and ((math.random(1, 3)==2) or i == 1 or i == 2) then
				table.insert(newSegmentsList, {cf.p, cf.p + facing.lookVector * (mag / 2)})
			end
		end
		
		maximumOffset = maximumOffset / 2
		segments = newSegmentsList
	end
	
	local numSegments 	= #segments
	local timeToTravel 	= mag / abilityData.projectileSpeed
	
	local ray = Ray.new(startPos, (finishPos - startPos).unit)
	
	for i, segment in pairs(segments) do
		segment.lengthProjectionToThisSegment = (ray:ClosestPoint(segment[1]) - startPos).magnitude
	end
	
	local startTime 		= tick()
	local damage 			= modules.load("damage")
	local damageDebounce 	= {}
	local hitPartDebounce 	= {}
	
	while true do
		local t 			= tick() - startTime
		local currentLength = abilityData.projectileSpeed * t
		
		for i, segment in pairs(segments) do
			if segment.lengthProjectionToThisSegment <= currentLength then
				-- drop this segment
				local segment = table.remove(segments, i)
				
				drawLightningSegment(segment[1], segment[2], tier)
				
				local ray 		= Ray.new(startPos, finishPos - startPos)
				
				local ignoreList = {renderCharacterContainer, workspace.CurrentCamera}
				if workspace:FindFirstChild("placeFolders") and workspace.placeFolders:FindFirstChild("foilage") then
					table.insert(ignoreList, workspace.placeFolders.foilage)
				end
				
				local hitPart, hitPos = projectile.raycastForProjectile(ray, ignoreList)
				
				if hitPart and not hitPartDebounce[hitPart] then
					hitPartDebounce[hitPart] = true
					
					if isAbilitySource then
						
						local canDamage, trueTarget = damage.canPlayerDamageTarget(game.Players.LocalPlayer, hitPart)
						if canDamage and trueTarget and not damageDebounce[trueTarget] then
							damageDebounce[trueTarget] = true
							network:fire("requestEntityDamageDealt", trueTarget, --[[abilityExecutionData["target-position"] or]] abilityExecutionData["mouse-world-position"], "ability", id, "bolt", guid)
						end
					end
					
					local endPointPart = script.sparks:Clone()
					endPointPart.Anchored = true
					endPointPart.CanCollide = false
					endPointPart.Transparency = 1
					endPointPart.CFrame = CFrame.new(hitPos)
					endPointPart.Parent = workspace.CurrentCamera
					endPointPart.Fire:Emit(25)
					
					local sound = script.zappity:Clone()
					sound.Parent = endPointPart
					if not isAbilitySource then
						sound.Volume = sound.Volume * 0.65
					end
					
					sound:Play()	
					
					game.Debris:AddItem(endPointPart,5)									
				end
			end
		end
		
		if #segments > 0 then
			runService.Heartbeat:Wait()
		else
			break
		end
	end
end

--							(renderCharacterContainer, 	targetPosition, isAbilitySource, hitNormal, nil, 	guid)
function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
--	local targetPosition = projectile.getTargetPositionByAbilityExecutionData(abilityExecutionData)
	local targetPosition = abilityExecutionData["mouse-world-position"]
	if not targetPosition then return end
	
	local currentlyEquipped 	= network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if not currentWeaponManifest or not currentWeaponManifest:FindFirstChild("magic") then return end
	
	local bolts = abilityExecutionData["ability-statistics"]["bolts"]
	
	if abilityExecutionData["ability-state"] == "begin" or abilityExecutionData["ability-state"] == "update" then
		if abilityExecutionData["ability-state"] == "begin" then
			local animationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations.mage_zap)		
			animationTrack:Play()
			
			wait(self.windupTime/3)
		else
			wait(self.windupTime/4)
		end
		
		currentWeaponManifest.magic.castEffect.Enabled = true
		
		local startPointPart 		= script.sparks:Clone()
		startPointPart.Anchored 	= true
		startPointPart.CanCollide 	= false
		startPointPart.Transparency = 1
		startPointPart.CFrame 		= CFrame.new(currentWeaponManifest.magic.WorldPosition)
		startPointPart.Parent 		= workspace.CurrentCamera
		
		startPointPart.Fire:Emit(15)
		
		local sound 	= script.zippity:Clone()
		sound.Parent 	= startPointPart
		sound:Play()
		
		currentWeaponManifest.magic.castEffect.Enabled = false
		
		local startPosition = currentWeaponManifest.magic.WorldPosition
		
		local adjusted_end_position = targetPosition
		local adjusted_end_position = startPosition + (targetPosition - startPosition).unit * abilityExecutionData["ability-statistics"].distance
		
		spawn(function()
			if isAbilitySource and renderCharacterContainer.entity.PrimaryPart then		
				if not renderCharacterContainer:FindFirstChild("entity") then return end
						
				fireLightning2(currentWeaponManifest.magic.WorldPosition, adjusted_end_position, true, 1.1, isAbilitySource, renderCharacterContainer, abilityExecutionData, self.id, guid)
			elseif not isAbilitySource and renderCharacterContainer.entity.PrimaryPart then
				-- todo: fix this later, position doesnt replicate fast enough.
				fireLightning2(startPosition, adjusted_end_position, true, 1.1)
			end
		end)
		
		if isAbilitySource and (abilityExecutionData["times-updated"] or 0) < (bolts - 1) then
			local newAbilityExecutionData 				= network:invoke("getAbilityExecutionData", abilityData.id, abilityExecutionData)
			newAbilityExecutionData["ability-state"] 	= "update"
			newAbilityExecutionData["ability-guid"] 	= guid
			
			network:invoke("client_changeAbilityState", abilityData.id, "update", newAbilityExecutionData, guid)
		elseif isAbilitySource then
			network:invoke("client_changeAbilityState", abilityData.id, "end")
		end
	end
end

return abilityData