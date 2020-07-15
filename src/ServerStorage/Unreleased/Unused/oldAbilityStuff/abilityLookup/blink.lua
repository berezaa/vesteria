local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local detection			= modules.load("detection")

local entityManifestCollectionFolder 	= placeSetup.awaitPlaceFolder("entityManifestCollection")
local entityRenderCollectionFolder 		= placeSetup.awaitPlaceFolder("entityRenderCollection")
local entitiesFolder 					= placeSetup.awaitPlaceFolder("entities")

local itemLookup 	= require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))

local httpService = game:GetService("HttpService")

local metadata = {
	cost = 1;
	upgradeCost = 2;
	maxRank = 8;
	layoutOrder = 3;
	
	requirement = function(playerData)
		return playerData.class == "Mage";
	end;
}

local abilityData = {
	--> identifying information <--
	id 	= 9;
	metadata = metadata;	
	--> generic information <--
	name 		= "Blink";
	image 		= "rbxassetid://3736597962";
	description = "Launch your character forward faster than one can blink.";
		
	--> execution information <--
	animationName 	= {"mage_blink"};
	windupTime 		= 0.2;
	layoutOrder		= 2;
	maxRank 		= 5;
	
	prerequisite = {{id = 4; rank = 1}};
	layoutOrder = 1;	
	
	--> combat stats <--
	statistics = {
		[1] = {
			power 		= 15;
			cooldown 	= 4;
			manaCost 	= 12;
		};
		[2] = {
			power 		= 18;
			manaCost 	= 14;
		};
		[3] = {
			power 		= 21;
			manaCost 	= 16;
		};
		[4] = {
			power 		= 24;
			manacost 	= 18;			
		};
		[5] = {
			power 	= 30;
			manaCost 	= 22;
			tier = 3;
		};		
		[6] = {
			power 	= 36;
			manaCost 	= 26;
		};	
		[7] = {
			power 	= 42;
			manaCost 	= 30;
		};	
		[8] = {
			power 	= 51;
			manaCost 	= 36;
			tier = 4;
		};						
											
	};
	
	dontDisableSprinting = true;
}

function abilityData.__serverValidateMovement(player, previousPosition, currentPosition)
	local abilityStatisticsData = network:invoke("getAbilityStatisticsForRank", abilityData, network:invoke("getPlayerAbilityRankByAbilityId", player, abilityData.id))
	
	return (currentPosition - previousPosition).magnitude <= abilityStatisticsData.power * 2.5
end

-- authorize damage if the player has the poison clouds perk
-- authorize damage if the player has strength requirement
function abilityData._serverProcessDamageRequest(sourceTag, baseDamage, _, _, player)
	local playerData = network:invoke("getPlayerData", player)
	if playerData then
		local stats = playerData.nonSerializeData.statistics_final
		if stats.activePerks["poisonblink"] then
			if sourceTag == "poison" then
				return baseDamage * 0.25, "magical", "dot"
			end
		end
		
		if sourceTag == "warpDamage" then
			if stats.str >= 70 then
				return baseDamage * 2.00, "magical", "direct"
			elseif stats.str >= 30 then
				return baseDamage * 1.50, "magical", "direct"
			end
		end
	end
end

function abilityData._abilityExecutionDataCallback(playerData, ref_abilityExecutionData)
	if playerData then
		local stats = playerData.nonSerializeData.statistics_final
		
		ref_abilityExecutionData["poisonblink"] = stats.activePerks["poisonblink"]
		
		ref_abilityExecutionData["holymagic"] = stats.activePerks["holymagic"]
		
		ref_abilityExecutionData["solar wind"] = stats.activePerks["solar wind"]
		
		ref_abilityExecutionData["warpDamage"] = stats.str >= 30
	end
	
end

local segmentLength = 4

local function fireLightning(startPos, finishPos, doBranch, offsetMulti, color)
	-- new particles xD
	local particlePart = script.particlePart:Clone()
	local length = (startPos - finishPos).magnitude 
	particlePart.Size = Vector3.new(2, 5, length)
	particlePart.CFrame = CFrame.new((startPos + finishPos)/2, finishPos)
	particlePart.Parent = workspace.CurrentCamera
	
	if color then
		particlePart.Fire.Color = ColorSequence.new(color)
	end
	
	particlePart.Fire:Emit(40)
	
	local blonk = script.blonk:Clone()
	blonk.Parent =  particlePart
	blonk:Play()
	
	game.Debris:AddItem(particlePart, 5)
end

local function sparkle(position)
	local newSparklePart = script.sparklePart:Clone()
	
	newSparklePart.CFrame = CFrame.new(position)
	newSparklePart.Parent = workspace.CurrentCamera
	
	newSparklePart.Attachment.Sparks:Emit(40)
	
	game.Debris:AddItem(newSparklePart, 1)
end

function abilityData:execute_server(castPlayer, activeAbilityExecutionData, isAbilitySource)
	local playerData = network:invoke("getPlayerData", castPlayer)
	if playerData then
		local stats = playerData.nonSerializeData.statistics_final
		
		local healAmt = 0
							
		if stats.vit >= 20 then
			healAmt = 15
		end
		if stats.vit >= 50 then
			healAmt = 40
		end
		if stats.vit >= 120 then
			healAmt = 100
		end
		
		local character = castPlayer.Character
		if not character then return end
		local manifest = character.PrimaryPart
		if not manifest then return end
		local health = manifest:FindFirstChild("health")
		if not health then return end
		local maxHealth = manifest:FindFirstChild("maxHealth")
		if not maxHealth then return end
		
		health.Value = math.min(health.Value + healAmt, maxHealth.Value)
	end
end

--							(renderCharacterContainer, 	targetPosition, isAbilitySource, hitNormal, nil, 	guid)
function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	if not renderCharacterContainer.entity.PrimaryPart then return end
	
	local mainTrack
	 
	for i, animationName in pairs(self.animationName) do
		local animationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations[animationName])
		animationTrack.Looped = false
		animationTrack.Priority = Enum.AnimationPriority.Movement
		animationTrack:Play(0.05, 1, 1)
		mainTrack = animationTrack
	end
	
	local Magic = script.Magic:Clone()
	Magic.Parent = renderCharacterContainer.entity.PrimaryPart
	Magic:Play() 
	game.Debris:AddItem(Magic,5)
	
	local origin = abilityExecutionData["cast-origin"]

	
	local colorOverride 
	if abilityExecutionData["holymagic"] then
		colorOverride = Color3.fromRGB(255, 234, 110)
	end
	
	if abilityExecutionData["solar wind"] then
		colorOverride = BrickColor.new("Cool yellow").Color
	end
	
	if isAbilitySource and renderCharacterContainer.entity.PrimaryPart then		
		-- todo: fix
		if not renderCharacterContainer:FindFirstChild("entity") then return end
		local movementVelocity = network:invoke("getMovementVelocity") or Vector3.new()
	
		local totalVelocity = network:invoke("getTotalVelocity") or Vector3.new()		
		
		
		local movementVelocity = movementVelocity * Vector3.new(1,1,1)
	
		local movementFactorY = math.clamp(totalVelocity.Y, -5, 5)
		movementVelocity = movementVelocity + (movementFactorY * Vector3.new(0,1,0))
		
		local facingFactor = (movementVelocity.magnitude > 1 and movementVelocity) or renderCharacterContainer.entity.PrimaryPart.CFrame.lookVector
		
	--			local facingDirection = (facingFactor  * Vector3.new(1,0,1)).unit
		local facingDirection = facingFactor.unit	
		
		wait(self.windupTime)

		
		
		if movementVelocity then
			-- unitify it...
			local startPosition = renderCharacterContainer.entity.PrimaryPart.Position
			
			local power = abilityExecutionData["ability-statistics"]["power"]
			if abilityExecutionData["solar wind"] then
				power = power * 1.5
			end
			
			local targetTPPosition = renderCharacterContainer.entity.PrimaryPart.Position + (power * facingDirection) 
			local movementDirection = (targetTPPosition - startPosition).unit
			local speed = abilityExecutionData["ability-statistics"].power * 1.2
			local duration = (mainTrack.Length - self.windupTime)
			local startTime = tick()
			
			local ray = Ray.new(renderCharacterContainer.entity.PrimaryPart.Position, (targetTPPosition - renderCharacterContainer.entity.PrimaryPart.Position))
			local hit, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, {workspace:FindFirstChild("placeFolders")})
			
			local castingWeaponBaseData = itemLookup[abilityExecutionData["cast-weapon-id"]]
	
			
			if renderCharacterContainer:FindFirstChild("clientHitboxToServerHitboxReference") then
				renderCharacterContainer.clientHitboxToServerHitboxReference.Value.CFrame = CFrame.new(hitPosition)--CFrame.new(hitPosition - movementVelocity * 5, hitPosition + movementVelocity)
				fireLightning(origin, targetTPPosition, true, 1.25, colorOverride)
				
				
				if abilityExecutionData["warpDamage"] then
					local teleDistance = (ray.Origin - hitPosition).Magnitude
					local boxcastOriginCF = CFrame.new(ray.Origin, hitPosition) * CFrame.new(0,0, -teleDistance/2)
					local boxcastSize = Vector3.new(5,5,teleDistance)
					
					local damagables = damage.getDamagableTargets(game.Players.LocalPlayer)
					local hitEntities = detection.boxcast_all(damagables, boxcastOriginCF, boxcastSize)
					
					for _, manifest in pairs(hitEntities) do
						local damagePosition = manifest.Position
						
						sparkle(damagePosition)
						
						network:fire("requestEntityDamageDealt", manifest, damagePosition, "ability", self.id, "warpDamage", guid)
					end
				end
			end
		end
	elseif not isAbilitySource and renderCharacterContainer.entity.PrimaryPart then
		wait(self.windupTime + 0.15)
		fireLightning(origin, renderCharacterContainer.entity.PrimaryPart.Position, true, 1.25, colorOverride)
	end

	if abilityExecutionData["poisonblink"] then
		local active = true
		local smokePart = script.LingeringSmokePart:Clone()
		smokePart.CFrame = CFrame.new(origin)
		smokePart.Parent = entitiesFolder
		smokePart.sound:Play()
		delay(5, function()
			active = false
			if smokePart and smokePart:FindFirstChild("Smoke") then
				smokePart.Smoke.Enabled = false
			end
			game.Debris:AddItem(smokePart, 2)
		end)
		if isAbilitySource then
			spawn(function()
				while active and smokePart and smokePart.Parent do
					for i, v in pairs(damage.getDamagableTargets(game.Players.LocalPlayer)) do
						local boxcastOriginCF 	= smokePart.CFrame + Vector3.new(0, 3, 0)
						local boxProjection_HRP = detection.projection_Box(v.CFrame, v.Size, boxcastOriginCF.p)
						if detection.boxcast_singleTarget(boxcastOriginCF, smokePart.Size, boxProjection_HRP) then
							local damagePosition = (smokePart.Position + v.Position) / 2
							network:fire("requestEntityDamageDealt", v, damagePosition, "ability", self.id, "poison", guid)
						end
					end
					wait(0.33)
				end
			end)
		end					
	end
	
end

return abilityData