local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local detection 		= modules.load("detection")
	local damage 			= modules.load("damage")
	local utilities 		= modules.load("utilities")

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

local abilityData = {
	--> identifying information <--
	id 			= 15;
	book 		= "hunter";
	
	--> generic information <--
	name 		= "Barrage";
	image 		= "rbxassetid://2871266140";
	description = "Like shooting an arrow, but with three times the arrow.";
	
	damageType = "ranged";
		
	--> execution information <--
	windupTime 			= 0.1;
	maxRank 			= 10;
	
	--> combat stats <--
	statistics = {
		[1] = {
			damageMultiplier 	= 1.25;
			manaCost 			= 15;
			cooldown 			= 12;
		}; [2] = {
			damageMultiplier 	= 1.30;
		}; [3] = {
			damageMultiplier 	= 1.35;
		}; [4] = {
			damageMultiplier 	= 1.40;
		}; [5] = {
			damageMultiplier 	= 1.45;
		};
	};
	
	equipmentTypeNeeded = "bow";
}

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	return baseDamage, "ranged", "projectile"
end

function abilityData:validateDamageRequest(monsterManifest, hitPosition)
	return (monsterManifest - hitPosition).magnitude <= 2
end

function abilityData:execute(renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	local currentlyEquipped 	= network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if not currentWeaponManifest then return end
	
	local playerManifestCollectionFolder 	= placeSetup.awaitPlaceFolder("playerManifestCollection")
	local playerRenderCollectionFolder 		= placeSetup.awaitPlaceFolder("playerRenderCollection")
	local monsterRenderCollectionFolder 	= placeSetup.awaitPlaceFolder("monsterRenderCollection")
	local monsterManifestCollectionFolder 	= placeSetup.awaitPlaceFolder("monsterManifestCollection")
	
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
			arrow1:Destroy()
			arrow2:Destroy()
			arrow3:Destroy()
			
			network:invoke("setCanPlayerBasicAttack", true)
		end
		
		connection = bowAnimationTrack.Stopped:connect(onBowAnimationTrackStopped)
	end
	
	playerAnimationTrack:Play()
	bowAnimationTrack:Play()
	
	network:invoke("setCanPlayerBasicAttack", false)
	
	-- todo: tie this to animation keyframes or markers
	local startTime = tick() do
		local minimumArrowSize 	= Vector3.new(0.154, 0.050, 0.301)
		local maximumArrowSize 	= Vector3.new(0.154, 2.803, 0.301)
		
		local minimumOriginSize = Vector3.new(0.050, 0.050, 0.050)
		local maximumOriginSize = Vector3.new(1.000, 1.000, 1.000)
		
		while true do
			local i = (tick() - startTime) / (0.4 * bowAnimationTrack.Length)
			
			arrow1Origin.Size = maximumOriginSize:Lerp(minimumArrowSize, i)
			arrow3Origin.Size = maximumOriginSize:Lerp(minimumArrowSize, i)
			
			arrow1Origin.CFrame = currentWeaponManifest.arrowPart.CFrame * CFrame.new(0, 1, 0)
			arrow3Origin.CFrame = currentWeaponManifest.arrowPart.CFrame * CFrame.new(0, -1, 0)
			
			arrow1.Size = minimumArrowSize:Lerp(maximumArrowSize, i)
			arrow3.Size = minimumArrowSize:Lerp(maximumArrowSize, i)
			
			arrow1.CFrame = arrow1Origin.CFrame * CFrame.Angles(0, math.rad(180), 0) * CFrame.Angles(math.rad(45), 0, 0) * CFrame.Angles(math.rad(45), 0, 0) * CFrame.new(0, arrow1.Size.Y / 2, 0)
			arrow3.CFrame = arrow3Origin.CFrame * CFrame.Angles(0, math.rad(180), 0) * CFrame.Angles(math.rad(45), 0, 0) * CFrame.Angles(math.rad(45), 0, 0) * CFrame.new(0, arrow3.Size.Y / 2, 0)
			
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
	
	local unitDirection, adjusted_targetPosition = projectile.getUnitVelocityToImpact_predictiveByAbilityExecutionData(
		arrow2.Position,
		200,
		abilityExecutionData
	)				
	
	projectile.createProjectile(
		arrow2.Position,
		unitDirection,
		200,
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
				if (hitPart:IsDescendantOf(playerRenderCollectionFolder) or hitPart:IsDescendantOf(monsterRenderCollectionFolder) or hitPart:IsDescendantOf(playerManifestCollectionFolder) or hitPart:IsDescendantOf(monsterManifestCollectionFolder)) then
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
					network:fire("requestEntityDamageDealt", trueTarget, 		hitPosition,  	"ability", 	self.id, nil, 		guid)
				end
			end
		end,
		
		function(t)
			return CFrame.Angles(math.rad(90), 0, 0)
		end,
		
		-- ignore list
		{renderCharacterContainer},
		
		-- points to next position
		true
	)				
	
	projectile.createProjectile(
		arrow1.Position,
		unitDirection,
		200,
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
				if (hitPart:IsDescendantOf(playerRenderCollectionFolder) or hitPart:IsDescendantOf(monsterRenderCollectionFolder) or hitPart:IsDescendantOf(playerManifestCollectionFolder) or hitPart:IsDescendantOf(monsterManifestCollectionFolder)) then
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
					network:fire("requestEntityDamageDealt", trueTarget, 		hitPosition,  	"ability", 	self.id, 	nil, 		guid)
				end
			end
		end,
		
		function(t)
			return CFrame.Angles(math.rad(90), 0, 0)
		end,
		
		-- ignore list
		{renderCharacterContainer},
		
		-- points to next position
		true
	)				
	
	projectile.createProjectile(
		arrow3.Position,
		unitDirection,
		200,
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
				if (hitPart:IsDescendantOf(playerRenderCollectionFolder) or hitPart:IsDescendantOf(monsterRenderCollectionFolder) or hitPart:IsDescendantOf(playerManifestCollectionFolder) or hitPart:IsDescendantOf(monsterManifestCollectionFolder)) then
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
					network:fire("requestEntityDamageDealt", trueTarget, 		hitPosition,  	"ability", 	self.id, nil, 		guid)
				end
			end
		end,
		
		function(t)
			return CFrame.Angles(math.rad(90), 0, 0)
		end,
		
		-- ignore list
		{renderCharacterContainer},
		
		-- points to next position
		true
	)
end

return abilityData