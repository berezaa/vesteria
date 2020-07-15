local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local detection 		= modules.load("detection")
	local ability_utilities = modules.load("ability_utilities")
	local utilities			= modules.load("utilities")

local entitiesFolder = placeSetup.getPlaceFolder("entities")

local httpService = game:GetService("HttpService")
local runService = game:GetService("RunService")

local metadata = {
	cost = 2;
	upgradeCost = 2;
	maxRank = 8;
	layoutOrder = 3;
	
	requirement = function(playerData)
		return playerData.class == "Warrior";
	end;
}


local abilityData = {
	--> identifying information <--
	id 	= 17;
	metadata = metadata;
	--> generic information <--
	name 		= "Parry";
	image 		= "rbxassetid://3736685722";
	description = "Prepare a powerful counterattack!";
	mastery = "Longer parry uptime.";
	
	damageType = "physical";
	
	prerequisite = {{id = 26; rank = 1}};
	layoutOrder = 1;	
		
	--> execution information <--
	windupTime 		= 0.1;
	maxRank 		= 5;
	cooldown 		= 3;
	cost 			= 10;
	
	--> combat stats <--
	statistics = {

		
		[1] = {
			damageMultiplier 	= 3.4;
			cooldown 			= 10;
			manaCost			= 15;
			duration 			= 1.5;
		}; [2] = {
			damageMultiplier 	= 3.6;
			manaCost			= 16;
		}; [3] = {
			damageMultiplier 	= 3.8;
			manaCost			= 17;
		}; [4] = {
			damageMultiplier 	= 4.0;
			manaCost			= 18;
		}; [5] = {
			damageMultiplier 	= 4.3;
			cooldown			= 8;
			manaCost			= 20;
			tier = 3;
		}; [6] = {
			damageMultiplier 	= 4.6;
			manaCost			= 22;
		}; [7] = {
			damageMultiplier 	= 4.9;
			manaCost			= 24;
		}; [8] = {
			damageMultiplier 	= 5.3;
			cooldown			= 6;
			manaCost			= 23;
			tier = 4;
		}; 
	};
	
	securityData = {
		playerHitMaxPerTag 	= 1;
--		maxHitLockout 		= 1;
		isDamageContained 	= true;
	};
	
	--- ehhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
	damage 				= 30;
	maxRange 			= 30;
	projectileSpeed 	= 150;
	equipmentTypeNeeded = "sword";
}

-- network:fireServer("playerRequest_damageEntity", player, serverHitbox, damagePosition, sourceType, sourceId, sourceTag, guid)
function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "ranged-hit" then
		return baseDamage * 1.25, "physical", "projectile"
	elseif sourceTag == "melee-hit" then
		return baseDamage, "physical", "direct"
	end
end

local function setupDamageReductionAura(renderCharacterContainer)
	for i, obj in pairs(renderCharacterContainer:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Transparency < 1 and obj.Name ~= "!! PARRY_REDUCTION_AURA !!" then
			local reductionAuraPart = obj:Clone()
			
			for ii, child in pairs(reductionAuraPart:GetDescendants()) do
				if not child:IsA("DataModelMesh") then
					child:Destroy()
				end
			end
			
			reductionAuraPart.RootPriority 	= -127
			reductionAuraPart.Transparency 	= 0.75
			reductionAuraPart.BrickColor 	= BrickColor.new("Royal purple")
			reductionAuraPart.Material 		= Enum.Material.Glass
			reductionAuraPart.Name 			= "!! PARRY_REDUCTION_AURA !!"
			reductionAuraPart.Anchored 		= false
			reductionAuraPart.CanCollide 	= false
			reductionAuraPart.Size 			= reductionAuraPart.Size + Vector3.new(0.2, 0.2, 0.2)
			
			local attachMotor 	= Instance.new("Motor6D")
			attachMotor.Part0 	= reductionAuraPart
			attachMotor.Part1 	= obj
			attachMotor.Parent 	= reductionAuraPart
			
			reductionAuraPart.Parent = obj
		end
	end
end

local function removeDamageReductionAura(renderCharacterContainer)
	for i, obj in pairs(renderCharacterContainer:GetDescendants()) do
		if obj.Name == "!! PARRY_REDUCTION_AURA !!" then
			obj:Destroy()
		end
	end
end

function abilityData._abilityExecutionDataCallback(playerData, ref_abilityExecutionData)
	ref_abilityExecutionData["bounceback"] =
		playerData and playerData.nonSerializeData.statistics_final.activePerks["bounceback"]
end
local function getKnockbackAmount(abilityExecutionData)
	return (abilityExecutionData["bounceback"] and 15000 or 1000) * 3
end
function abilityData:execute_server(player, abilityExecutionData, isAbilitySource, targetPoint, monster, knockbackAmount)
	if not isAbilitySource then return end
	if abilityExecutionData["bounceback"] then
		utilities.playSound("bounce", monster)
	end				
	ability_utilities.knockbackMonster(monster, targetPoint, knockbackAmount, 0.2)
end
function abilityData:doKnockback(abilityExecutionData, target, point, amount)
	if	target:FindFirstChild("entityType") and
		target.entityType.Value == "monster"
	then
		network:fireServer("abilityFireServerCall", abilityExecutionData, self.id, point, target, amount)
	end
	
	local player = game.Players.LocalPlayer
	local char = player.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end
	
	if target == manifest then
		ability_utilities.knockbackLocalPlayer(point, amount)
	end
end

function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	local currentlyEquipped 	= network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if not currentWeaponManifest then return end
	
	local parryStart 	= renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations.warrior_parryStart)
	local parryHold 	= renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations.warrior_parryHold)
	local parryMelee 	= renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations.warrior_parryMelee)
	local parryRanged 	= renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations.warrior_parryRanged)
	
	local startParryHold do
		startParryHold = parryStart.Stopped:connect(function()
			if startParryHold then
				startParryHold:disconnect()
				startParryHold = nil
			
				parryHold:Play()
			end
		end)
	end
	
	parryStart:Play()
	
	local parrySound = script.cast:Clone()
	parrySound.Parent =  currentWeaponManifest
	parrySound:Play()
	if not isAbilitySource then
		parrySound.Volume = parrySound.Volume * 0.7
	end
	
	game.Debris:AddItem(parrySound,5)
	
	setupDamageReductionAura(renderCharacterContainer)
	
	if isAbilitySource then
		network:invoke("setCharacterArrested", true)
	end
	
	local _, event
	local abilityEnded
	local function onSignal_DamageModificationByActiveAbility(targetPlayer, abilityId, damageData, entityHitboxDamageSource)
		if not event then return end
		if abilityId ~= self.id then return end
		if abilityExecutionData["cast-player-userId"] ~= targetPlayer.userId then return end
			
		event:disconnect()
		event = nil
		
		if startParryHold then
			startParryHold:disconnect()
			startParryHold = nil
		end
		
		parryHold:Stop()
		parryStart:Stop()
		removeDamageReductionAura(renderCharacterContainer)
				
		if damageData.category == "projectile" and currentWeaponManifest:IsDescendantOf(renderCharacterContainer) then
			while parryRanged.Length == 0 do wait(0) end
			
			parryRanged:Play()
			
			wait(parryRanged.Length * 0.9)
						
			if currentWeaponManifest:IsDescendantOf(renderCharacterContainer) then
				local proj 	= script.projectileParry:Clone()
				proj.Parent = placeSetup.getPlaceFolder("entities")
				
				local startPosition 							= currentWeaponManifest.CFrame * Vector3.new(0, -currentWeaponManifest.Size.Y * 0.45, 0)
				local unitDirection, adjusted_targetPosition 	= projectile.getUnitVelocityToImpact_predictive(
					startPosition,
					self.projectileSpeed,
					entityHitboxDamageSource.Position,
					entityHitboxDamageSource.Velocity,
					nil
				)
				
				local parrySound 	= script.deflect:Clone()
				parrySound.Parent 	= currentWeaponManifest
				parrySound:Play()
				
				if not isAbilitySource then
					parrySound.Volume = parrySound.Volume * 0.7
				end
				
				game.Debris:AddItem(parrySound,5)
				
				projectile.createProjectile(
					startPosition,
					unitDirection,
					self.projectileSpeed,
					proj,
					function(hitPart, hitPosition)
						game:GetService("Debris"):AddItem(proj, 2 / 30)
						
						if isAbilitySource then
							if hitPart then
								local canDamageTarget, trueTarget = damage.canPlayerDamageTarget(game.Players.LocalPlayer, hitPart)
								if canDamageTarget and trueTarget then
									network:fire("requestEntityDamageDealt", trueTarget, 		hitPosition, 	"ability", 	self.id, "ranged-hit", guid)
									
						
									
									--knockback
									self:doKnockback(abilityExecutionData, trueTarget, hitPosition, getKnockbackAmount(abilityExecutionData))
								end
							end
						end
					end
				)
			end
		elseif damageData.category == "direct" then
			while parryMelee.Length == 0 do wait(0) end
			
			parryMelee:Play()
			
			local hitDebounceTable = {}
			
			local parrySound = script.counter:Clone()
			parrySound.Parent =  currentWeaponManifest
			parrySound:Play()
			if not isAbilitySource then
				parrySound.Volume = parrySound.Volume * 0.7
			end
			game.Debris:AddItem(parrySound,5)			
			
			local trail
		
			local attach0 = currentWeaponManifest:FindFirstChild("bottomAttachment")
			local attach1 = currentWeaponManifest:FindFirstChild("topAttachment")
			
			if attach0 and attach1 then
				trail = script.Trail:Clone()
				trail.Name = "groundSlamTrail"
				trail.Parent = currentWeaponManifest
				trail.Attachment0 = attach0
				trail.Attachment1 = attach1
				trail.Enabled = true
			end		
		
			while parryMelee.IsPlaying do
				if isAbilitySource then
					-- todo: consider just using serverHitbox in `monsterManifestCollectionFolder` ?
					for i, serverHitbox in pairs(damage.getDamagableTargets(game.Players.LocalPlayer)) do
						if not hitDebounceTable[serverHitbox] then
							local boxcastOriginCF 	= currentWeaponManifest.CFrame
							local boxProjection_serverHitbox = detection.projection_Box(serverHitbox.CFrame, serverHitbox.Size, boxcastOriginCF.p)
							if detection.boxcast_singleTarget(boxcastOriginCF, currentWeaponManifest.Size * Vector3.new(5, 1.5, 5), boxProjection_serverHitbox) then
								hitDebounceTable[serverHitbox] = true
								
								network:fire("requestEntityDamageDealt", serverHitbox, boxProjection_serverHitbox, "ability", self.id, "melee-hit", guid)
								
									
								
								--knockback
								self:doKnockback(abilityExecutionData, serverHitbox, boxProjection_serverHitbox, getKnockbackAmount(abilityExecutionData))
							end
						end
					end
				end
				
				wait(1 / 20)
			end
			
			trail:Destroy()
		end
		
		if isAbilitySource then
			network:invoke("setCharacterArrested", false)
		end
		abilityEnded = true
	end
	
	_, event = network:connect("signal_damageModificationByActiveAbility", "OnClientEvent", onSignal_DamageModificationByActiveAbility)
	
	-- max time you can parry
	--wait(abilityExecutionData["ability-statistics"].duration)
	local tock = tick()
	repeat wait() until abilityEnded or tick() - tock > abilityExecutionData["ability-statistics"].duration
	
	if event then
		event:disconnect()
		event = nil
		
		if startParryHold then
			startParryHold:disconnect()
			startParryHold = nil
		end
		
		parryHold:Stop()
		parryStart:Stop()
		removeDamageReductionAura(renderCharacterContainer)
		
		if isAbilitySource then
			network:invoke("setCharacterArrested", false)
		end
	end
end

return abilityData