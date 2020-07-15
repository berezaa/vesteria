local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local detection 		= modules.load("detection")
	local damage 			= modules.load("damage")
	local utilities 		= modules.load("utilities")
	local levels 			= modules.load("levels")

local function weld(part0, part1)
	local motor6d 	= Instance.new("Motor6D")
	motor6d.Part0 	= part0
	motor6d.Part1	= part1
	motor6d.C0    	= CFrame.new()
	motor6d.C1 		= part1.CFrame:toObjectSpace(part0.CFrame)
	motor6d.Name 	= part1.Name
	motor6d.Parent	= part0
end

local httpService 	= game:GetService("HttpService")
local runService 	= game:GetService("RunService")

local metadata = {
	cost = 2;
	upgradeCost = 2;
	maxRank = 8;
	layoutOrder = 3;
	
	requirement = function(playerData)
		return playerData.class == "Hunter";
	end;
}


local abilityData = {
	--> identifying information <--
	id 			= 15;
	metadata = metadata;
	book 		= "hunter";
	
	--> generic information <--
	name 		= "Barrage";
	image 		= "rbxassetid://3736597469";
	description = "Fire three arrows at once. (Requires bow.)";
	
	damageType = "physical";
		
	--> execution information <--
	windupTime 			= 0.1;
	maxRank 			= 10;
	
	prerequisite = {{id = 7; rank = 1}};
	layoutOrder = 1;	
	
	--> combat stats <--
	statistics = {
		[1] = {
			damageMultiplier 	= 1.2;
			manaCost 			= 12;
			cooldown 			= 7;
			_angleOffset 		= 2.5;
		}; [2] = {
			damageMultiplier 	= 1.4;
			manaCost			= 14;
		}; [3] = {
			damageMultiplier 	= 1.6;
			manaCost			= 16;
		}; [4] = {
			damageMultiplier 	= 1.8;
			manaCost			= 18;
		}; [5] = {
			damageMultiplier 	= 2.1;
			cooldown			= 6;
			manaCost			= 21;
			tier = 3;
		}; [6] = {
			damageMultiplier 	= 2.4;
			manaCost			= 24;
		}; [7] = {
			damageMultiplier 	= 2.7;
			manaCost			= 27;
		}; [8] = {
			damageMultiplier 	= 3.1;
			cooldown			= 5;
			manaCost			= 31;
			tier = 4;
		};
	};
	
	securityData = {
		playerHitMaxPerTag 	= 1;
--		maxHitLockout 		= 3;
--		isDamageContained 	= true;
	};
	
	equipmentTypeNeeded = "bow";
	disableAutoaim 		= true;
	
	projectileSpeed = 200,
	
	targetingData = {
		targetingType = "projectile",
		projectileSpeed = "projectileSpeed",
		projectileGravity = 1,
		
		onStarted = function(entityContainer)
			local track = entityContainer.entity.AnimationController:LoadAnimation(abilityAnimations.bow_targeting_sequence)
			track:Play()
			
			return {track = track}
		end,
		
		onEnded = function(entityContainer, executionData, data)
			data.track:Stop()
		end
	}
}

local critChanceRandom = Random.new()

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage, sourcePlayer)
	if sourceTag == "arrow-1" or sourceTag == "arrow-2" or sourceTag == "arrow-3" then
		return baseDamage, "physical", "projectile"
	end
end

function abilityData:validateDamageRequest(monsterManifest, hitPosition)
	return (monsterManifest - hitPosition).magnitude <= 2
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	if not renderCharacterContainer:FindFirstChild("entity") then return end
		
	local entityManifest = network:invoke("getEntityManifestByRenderEntityContainer", renderCharacterContainer)
	if not entityManifest then return end
		
	local currentlyEquipped 	= network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if not currentWeaponManifest then return end
			
	if abilityExecutionData["ability-state"] == "begin" then
		local playerAnimationTrack 	= renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations.player_tripleshot)
		local bowAnimationTrack 	= currentWeaponManifest.AnimationController:LoadAnimation(abilityAnimations.bow_tripleshot)
		
		local arrow1 = script.arrow:Clone()
			arrow1.Reflectance 	= 1
			arrow1.Material 	= Enum.Material.Neon
			arrow1.Anchored 	= true
			arrow1.Parent 		= workspace.CurrentCamera
		local arrow2 = script.arrow:Clone()
			arrow2.Parent = workspace.CurrentCamera
		local arrow3 = script.arrow:Clone()
			arrow3.Reflectance 	= 1
			arrow3.Material 	= Enum.Material.Neon
			arrow1.Anchored 	= true
			arrow3.Parent 		= workspace.CurrentCamera
		
		local abilityRenderData = {}
			abilityRenderData.arrow1 = arrow1
			abilityRenderData.arrow2 = arrow2
			abilityRenderData.arrow3 = arrow3
			
		network:invoke("setRenderDataByNameTag", entityManifest, "abilityRenderData" .. abilityData.id, abilityRenderData)
		
		local arrow1Origin = script.sphere:Clone()
			arrow1Origin.Parent = workspace.CurrentCamera
		local arrow3Origin = script.sphere:Clone()
			arrow3Origin.Parent = workspace.CurrentCamera
		
		local arrow2Holder 	= currentWeaponManifest.slackRopeRepresentation.arrowHolder
		arrow2Holder.C0 	= CFrame.Angles(0, math.rad(180), 0) * CFrame.Angles(math.rad(45), 0, 0) * CFrame.Angles(math.rad(45), 0, 0) * CFrame.new(0, -arrow2.Size.Y / 2 - 0.1, 0)
		arrow2Holder.Part1 	= arrow2
		arrow2Holder.Parent = currentWeaponManifest.slackRopeRepresentation
		
		local connection do
			local function onBowAnimationTrackStopped()
				if connection then
					connection:disconnect()
					connection = nil
				end
				
				arrow1:Destroy()
				arrow2:Destroy()
				arrow3:Destroy()
				
				if isAbilitySource then
					network:invoke("setCanPlayerBasicAttack", true)
				end
			end
			
			connection = bowAnimationTrack.Stopped:connect(onBowAnimationTrackStopped)
		end
		
		playerAnimationTrack:Play()
		bowAnimationTrack:Play()
		
		if isAbilitySource then
			network:invoke("setCanPlayerBasicAttack", false)
		end
		
		utilities.playSound("bowDraw", currentWeaponManifest:IsA("Model") and currentWeaponManifest.PrimaryPart or currentWeaponManifest)
		
		local angleOffset = abilityExecutionData["ability-statistics"]._angleOffset
		
		-- todo: tie this to animation keyframes or markers
		local startTime = tick() do
			local minimumArrowSize 	= Vector3.new(0.154, 0.050, 0.301)
			local maximumArrowSize 	= Vector3.new(0.154, 2.803, 0.301)
			
			local minimumOriginSize = Vector3.new(0.050, 0.050, 0.050)
			local maximumOriginSize = Vector3.new(1.000, 1.000, 1.000)
			
			while true do
				local i = (tick() - startTime) / (0.3 * bowAnimationTrack.Length)
				
				arrow1Origin.Size = maximumOriginSize:Lerp(minimumArrowSize, i)
				arrow3Origin.Size = maximumOriginSize:Lerp(minimumArrowSize, i)
				
				arrow1Origin.CFrame = currentWeaponManifest.arrowPart.CFrame * CFrame.Angles(-math.rad(angleOffset), 0, 0) * CFrame.new(0, 1.15, 0)
				arrow3Origin.CFrame = currentWeaponManifest.arrowPart.CFrame * CFrame.Angles(math.rad(angleOffset), 0, 0) * CFrame.new(0, -1.15, 0)
				
				arrow1.Size = minimumArrowSize:Lerp(maximumArrowSize, i)
				arrow3.Size = minimumArrowSize:Lerp(maximumArrowSize, i)
				
				arrow1.CFrame = arrow1Origin.CFrame * CFrame.Angles(0, math.rad(180), 0) * CFrame.Angles(math.rad(80), 0, 0) * CFrame.new(0, arrow1.Size.Y / 2, 0)
				arrow3.CFrame = arrow3Origin.CFrame * CFrame.Angles(0, math.rad(180), 0) * CFrame.Angles(math.rad(80), 0, 0) * CFrame.new(0, arrow3.Size.Y / 2, 0)
				
				if i <= 1 then
					runService.RenderStepped:Wait()
				else
					break
				end
			end
			
			arrow1Origin:Destroy()
			arrow3Origin:Destroy()
			
			arrow2Holder.Part1 = nil
		end
		
		if isAbilitySource then
			local newAbilityExecutionData 				= network:invoke("getAbilityExecutionData", abilityData.id, abilityExecutionData)
			newAbilityExecutionData["ability-state"] 	= "update"
			newAbilityExecutionData["ability-guid"] 	= guid
			
			local success, encodeValue = utilities.safeJSONEncode(newAbilityExecutionData)
			
			game.Players.LocalPlayer.Character.PrimaryPart.activeAbilityExecutionData.Value = encodeValue
			network:invoke("client_changeAbilityState", abilityData.id, "update", newAbilityExecutionData, guid)
		end
	elseif abilityExecutionData["ability-state"] == "update" then
		local abilityRenderData = network:invoke("getRenderDataByNameTag", entityManifest, "abilityRenderData" .. abilityData.id)
		if not abilityRenderData then return end
		
		-- clear out the renderData
		network:invoke("setRenderDataByNameTag", entityManifest, "abilityRenderData" .. abilityData.id, nil)
		
		local entityManifestCollectionFolder 	= placeSetup.awaitPlaceFolder("entityManifestCollection")
		local entityRenderCollectionFolder 		= placeSetup.awaitPlaceFolder("entityRenderCollection")
		
		local angleOffset = abilityExecutionData["ability-statistics"]._angleOffset
		
		local arrow1 = abilityRenderData.arrow1
		local arrow2 = abilityRenderData.arrow2
		local arrow3 = abilityRenderData.arrow3
		
		local unitDirection, adjusted_targetPosition = projectile.getUnitVelocityToImpact_predictive(
			arrow2.Position,
			self.projectileSpeed,
			abilityExecutionData["mouse-target-position"],
			Vector3.new()
		)
		if not unitDirection then
			unitDirection = (abilityExecutionData["mouse-target-position"] - arrow2.Position).Unit
		end
		
		spawn(function()
			for i=1, 3 do
				wait()
				utilities.playSound("bowFire", currentWeaponManifest:IsA("Model") and currentWeaponManifest.PrimaryPart or currentWeaponManifest)
			end
		end)
	
		projectile.createProjectile(
			arrow2.Position,
			unitDirection,
			self.projectileSpeed,
			arrow2,
			function(hitPart, hitPosition, hitNormal, hitMaterial)
				--[[
				if hitNormal then
					currentArrow.CFrame = CFrame.new(hitPosition, hitPosition + hitNormal) * CFrame.Angles(-math.rad(90), 0, 0)
				end
				]]
				
				if arrow2:FindFirstChild("Trail") then
					arrow2.Trail.Enabled = false
				end 
				
				local expireTime = 2
				
				if hitPart then
					if (hitPart:IsDescendantOf(entityManifestCollectionFolder) or hitPart:IsDescendantOf(entityRenderCollectionFolder)) then
						arrow2.Anchored = false
						weld(arrow2, hitPart)
						expireTime = 5	
					else
						if arrow2:FindFirstChild("impact") then
							local hitColor = hitPart.Color
							if hitPart == workspace.Terrain then
								hitColor = hitPart:GetMaterialColor(hitMaterial)
							end
							local emitPart = Instance.new("Part")
							emitPart.Size = Vector3.new(0.1,0.1,0.1)
							emitPart.Transparency = 1
							emitPart.Anchored = true
							emitPart.CanCollide = false
							emitPart.CFrame = arrow2.CFrame - arrow2.CFrame.p + hitPosition
							local impact = arrow2.impact:Clone()
							impact.Parent = emitPart
							emitPart.Parent = workspace.CurrentCamera
							impact.Color = ColorSequence.new(hitColor)
							impact:Emit(10)
							game.Debris:AddItem(emitPart,3)
						end
					end
				end
				
				utilities.playSound("bowArrowImpact", arrow2)
				
				game:GetService("Debris"):AddItem(arrow2, expireTime)
				
				-- for damien: todo: hitPart is nil
				if isAbilitySource and hitPart then
					local canDamageTarget, trueTarget = damage.canPlayerDamageTarget(game.Players.LocalPlayer, hitPart)
					if canDamageTarget and trueTarget then
						--								   (player, serverHitbox, 	damagePosition, sourceType, sourceId, sourceTag, 		guid)
						network:fire("requestEntityDamageDealt", trueTarget, 		hitPosition,  	"ability", 	self.id, "arrow-2", 		guid)
					end
				end
			end,
			
			function(t)
				return CFrame.Angles(math.rad(90), 0, 0)
			end,
			
			-- ignore list
			{renderCharacterContainer; renderCharacterContainer.clientHitboxToServerHitboxReference.Value},
			
			-- points to next position
			true
		)				
		
		projectile.createProjectile(
			arrow1.Position,
			(CFrame.new(Vector3.new(), unitDirection) * CFrame.Angles(0, math.rad(angleOffset), 0)).lookVector,
			self.projectileSpeed,
			arrow1,
			function(hitPart, hitPosition, hitNormal, hitMaterial)
				--[[
				if hitNormal then
					currentArrow.CFrame = CFrame.new(hitPosition, hitPosition + hitNormal) * CFrame.Angles(-math.rad(90), 0, 0)
				end
				]]
				
				if arrow1:FindFirstChild("Trail") then
					arrow1.Trail.Enabled = false
				end 
				
				local expireTime = 2
				
				if hitPart then
					if (hitPart:IsDescendantOf(entityRenderCollectionFolder) or hitPart:IsDescendantOf(entityManifestCollectionFolder)) then
						arrow1.Anchored = false
						weld(arrow1, hitPart)
						expireTime = 5	
					else
						if arrow1:FindFirstChild("impact") then
							local hitColor = hitPart.Color
							if hitPart == workspace.Terrain then
								hitColor = hitPart:GetMaterialColor(hitMaterial)
							end
							local emitPart = Instance.new("Part")
							emitPart.Size = Vector3.new(0.1,0.1,0.1)
							emitPart.Transparency = 1
							emitPart.Anchored = true
							emitPart.CanCollide = false
							emitPart.CFrame = arrow1.CFrame - arrow1.CFrame.p + hitPosition
							local impact = arrow1.impact:Clone()
							impact.Parent = emitPart
							emitPart.Parent = workspace.CurrentCamera
							impact.Color = ColorSequence.new(hitColor)
							impact:Emit(10)
							game.Debris:AddItem(emitPart,3)
						end
					end
				end
				
				utilities.playSound("bowArrowImpact", arrow1)
				
				game:GetService("Debris"):AddItem(arrow1, expireTime)
				
				-- for damien: todo: hitPart is nil
				if isAbilitySource and hitPart then
					local canDamageTarget, trueTarget = damage.canPlayerDamageTarget(game.Players.LocalPlayer, hitPart)
					if canDamageTarget and trueTarget then
						--								   (player, serverHitbox, 	damagePosition, sourceType, sourceId, 	sourceTag, 		guid)
						network:fire("requestEntityDamageDealt", trueTarget, 		hitPosition,  	"ability", 	self.id, 	"arrow-1", 		guid)
					end
				end
			end,
			
			function(t)
				return CFrame.Angles(math.rad(90), 0, 0)
			end,
			
			-- ignore list
			{renderCharacterContainer; renderCharacterContainer.clientHitboxToServerHitboxReference.Value},
			
			-- points to next position
			true
		)				
		
		projectile.createProjectile(
			arrow3.Position,
			(CFrame.new(Vector3.new(), unitDirection) * CFrame.Angles(0, -math.rad(angleOffset), 0)).lookVector,
			self.projectileSpeed,
			arrow3,
			function(hitPart, hitPosition, hitNormal, hitMaterial)
				--[[
				if hitNormal then
					currentArrow.CFrame = CFrame.new(hitPosition, hitPosition + hitNormal) * CFrame.Angles(-math.rad(90), 0, 0)
				end
				]]
				
				if arrow3:FindFirstChild("Trail") then
					arrow3.Trail.Enabled = false
				end 
				
				local expireTime = 2
				
				if hitPart then
					if (hitPart:IsDescendantOf(entityRenderCollectionFolder) or hitPart:IsDescendantOf(entityManifestCollectionFolder)) then
						arrow3.Anchored = false
						weld(arrow3, hitPart)
						expireTime = 5	
					else
						if arrow3:FindFirstChild("impact") then
							local hitColor = hitPart.Color
							if hitPart == workspace.Terrain then
								hitColor = hitPart:GetMaterialColor(hitMaterial)
							end
							local emitPart = Instance.new("Part")
							emitPart.Size = Vector3.new(0.1,0.1,0.1)
							emitPart.Transparency = 1
							emitPart.Anchored = true
							emitPart.CanCollide = false
							emitPart.CFrame = arrow3.CFrame - arrow3.CFrame.p + hitPosition
							local impact = arrow3.impact:Clone()
							impact.Parent = emitPart
							emitPart.Parent = workspace.CurrentCamera
							impact.Color = ColorSequence.new(hitColor)
							impact:Emit(10)
							game.Debris:AddItem(emitPart,3)
						end
					end
				end
				
				utilities.playSound("bowArrowImpact", arrow3)
				
				game:GetService("Debris"):AddItem(arrow3, expireTime)
				
				-- for damien: todo: hitPart is nil
				if isAbilitySource and hitPart then
					local canDamageTarget, trueTarget = damage.canPlayerDamageTarget(game.Players.LocalPlayer, hitPart)
					if canDamageTarget and trueTarget then
						--								   (player, serverHitbox, 	damagePosition, sourceType, sourceId, sourceTag, 		guid)
						network:fire("requestEntityDamageDealt", trueTarget, 		hitPosition,  	"ability", 	self.id, "arrow-3", 		guid)
					end
				end
			end,
			
			function(t)
				return CFrame.Angles(math.rad(90), 0, 0)
			end,
			
			-- ignore list
			{renderCharacterContainer; renderCharacterContainer.clientHitboxToServerHitboxReference.Value},
			
			-- points to next position
			true
		)

		if isAbilitySource then
			network:fire("setIsPlayerCastingAbility", false)
			network:invoke("client_changeAbilityState", abilityData.id, "end")
		end
	elseif abilityExecutionData["ability-state"] == "end" then
	end
end

return abilityData