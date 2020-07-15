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

local abilityData = {
	--> identifying information <--
	id 			= 22;
	
	--> generic information <--
	name 		= "Piercing Shot";
	image 		= "rbxassetid://2871266140";
	description = "Fire an arrow that will pierce through enemies.";
	
	damageType = "physical";
		
	--> execution information <--
	windupTime 			= 0.1;
	maxRank 			= 10;
	
	--> combat stats <--
	statistics = {
		[1] = {
			damageMultiplier 	= 1.50;
			manaCost 			= 15;
			cooldown 			= 5;
			angleOffset 		= 2.5;
		}; [2] = {
			damageMultiplier 	= 1.60;
		}; [3] = {
			damageMultiplier 	= 1.70;
		}; [4] = {
			damageMultiplier 	= 1.80;
		}; [5] = {
			damageMultiplier 	= 1.90;
		};
--		[6] = {
--			damageMultiplier 	= 1.50;
--		}; [7] = {
--			damageMultiplier 	= 1.55;
--		}; [8] = {
--			damageMultiplier 	= 1.60;
--		}; [9] = {
--			damageMultiplier 	= 1.65;
--		}; [10] = {
--			damageMultiplier 	= 1.75;
--		};
	};
	
	equipmentTypeNeeded = "bow";
	disableAutoaim 		= false;
}

local critChanceRandom = Random.new()

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage, sourcePlayer)
	if sourceTag == "arrow-hit" then
		if levels.getPlayerCritChance(sourcePlayer) >= critChanceRandom:NextNumber() then
			
			return baseDamage * 2, "physical", "projectile"
		end
		
		return baseDamage, "physical", "projectile"
	end
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
	
	local entityManifestCollectionFolder 	= placeSetup.awaitPlaceFolder("entityManifestCollection")
	local entityRenderCollectionFolder 		= placeSetup.awaitPlaceFolder("entityRenderCollection")
	
	local playerAnimationTrack 	= renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations.player_tripleshot)
	local bowAnimationTrack 	= currentWeaponManifest.AnimationController:LoadAnimation(abilityAnimations.bow_tripleshot)
	
	local arrow = script.arrow:Clone()
		arrow.Reflectance 	= 1
		arrow.Material 		= Enum.Material.Neon
		arrow.Anchored 		= true
		arrow.Parent 		= workspace.CurrentCamera
	
	local arrow1Origin = script.sphere:Clone()
		arrow1Origin.Parent = workspace.CurrentCamera
	local arrow3Origin = script.sphere:Clone()
		arrow3Origin.Parent = workspace.CurrentCamera
	
	local arrow2Holder 	= currentWeaponManifest.slackRopeRepresentation.arrowHolder
	arrow2Holder.C0 	= CFrame.Angles(0, math.rad(180), 0) * CFrame.Angles(math.rad(45), 0, 0) * CFrame.Angles(math.rad(45), 0, 0) * CFrame.new(0, -arrow.Size.Y / 2 - 0.1, 0)
	arrow2Holder.Part1 	= arrow
	arrow2Holder.Parent = currentWeaponManifest.slackRopeRepresentation
	
	local connection do
		local function onBowAnimationTrackStopped()
			arrow:Destroy()
			
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
	
	local angleOffset = abilityExecutionData["ability-statistics"].angleOffset
	
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
			
			arrow1Origin.CFrame = currentWeaponManifest.arrowPart.CFrame * CFrame.Angles(-math.rad(angleOffset), 0, 0) * CFrame.new(0, 1.15, 0)
			arrow3Origin.CFrame = currentWeaponManifest.arrowPart.CFrame * CFrame.Angles(math.rad(angleOffset), 0, 0) * CFrame.new(0, -1.15, 0)
			
			arrow.Size = minimumArrowSize:Lerp(maximumArrowSize, i)
			arrow.CFrame = arrow1Origin.CFrame * CFrame.Angles(0, math.rad(180), 0) * CFrame.Angles(math.rad(80), 0, 0) * CFrame.new(0, arrow.Size.Y / 2, 0)
			
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
		arrow.Position,
		200,
		abilityExecutionData
	)
	
	spawn(function()
		for i=1,3 do
			wait()
			utilities.playSound("bowFire", currentWeaponManifest:IsA("Model") and currentWeaponManifest.PrimaryPart or currentWeaponManifest)
		end
	end)				
	
	projectile.createProjectile(
		arrow.Position,
		unitDirection,
		200,
		arrow,
		function(hitPart, hitPosition, hitNormal, hitMaterial)
			--[[
			if hitNormal then
				currentArrow.CFrame = CFrame.new(hitPosition, hitPosition + hitNormal) * CFrame.Angles(-math.rad(90), 0, 0)
			end
			]]
			
			if arrow:FindFirstChild("Trail") then
				arrow.Trail.Enabled = false
			end 
			
			local expireTime = 2
			
			if hitPart then
				if (hitPart:IsDescendantOf(entityManifestCollectionFolder) or hitPart:IsDescendantOf(entityRenderCollectionFolder)) then
					arrow.Anchored = false
					weld(arrow, hitPart)
					expireTime = 5	
				else
					if arrow:FindFirstChild("impact") then
						local hitColor = hitPart.Color
						if hitPart == workspace.Terrain then
							hitColor = hitPart:GetMaterialColor(hitMaterial)
						end
						local emitPart = Instance.new("Part")
						emitPart.Size = Vector3.new(0.1,0.1,0.1)
						emitPart.Transparency = 1
						emitPart.Anchored = true
						emitPart.CanCollide = false
						emitPart.CFrame = arrow.CFrame - arrow.CFrame.p + hitPosition
						local impact = arrow.impact:Clone()
						impact.Parent = emitPart
						emitPart.Parent = workspace.CurrentCamera
						impact.Color = ColorSequence.new(hitColor)
						impact:Emit(10)
						game.Debris:AddItem(emitPart,3)
					end
				end
			end
			
			utilities.playSound("bowArrowImpact", arrow)
			
			game:GetService("Debris"):AddItem(arrow, expireTime)
			
			if isAbilitySource and hitPart then
				local canDamageTarget, trueTarget = damage.canPlayerDamageTarget(game.Players.LocalPlayer, hitPart)
				if canDamageTarget and trueTarget then
					network:fire("requestEntityDamageDealt", trueTarget, hitPosition, "ability", self.id, "arrow-hit", guid)
					
					-- tell the projectileHandler to ignore this part and keep going
					return true
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
end

return abilityData