local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")

local entityManifestCollectionFolder = placeSetup.awaitPlaceFolder("entityManifestCollection")

local httpService = game:GetService("HttpService")

local abilityData = {
	--> identifying information <--
	id 	= 10;
	
	
	
	--> generic information <--
	name 		= "Dagger Throw";
	image 		= "rbxassetid://2528902271";
	description = "Throw your dagger at an enemy!";
	
	damageType = "physical";
	equipmentTypeNeeded = "dagger";
	
	-- "skill-shot", "self-target", "target"
	castType 			= "skill-shot";
	castingAnimation 	= abilityAnimations.rock_throw_upper_loop;
		
	--> execution information <--
	windupTime 		= 0.3;
	maxRank 		= 5;
	cooldown 		= 2;
	cost 			= 10;
	projectileSpeed = 150;
	
	--> combat stats <--
	statistics = {
		[1] = {
			damageMultiplier 	= 1;
			range 				= 50;
			cooldown 			= 1;
			manaCost	= 15;
		}; [2] = {
			damageMultiplier = 1.15;
		}; [3] = {
			damageMultiplier = 1.3;
		}; [4] = {
			damageMultiplier = 1.45;
		}; [5] = {
			damageMultiplier 	= 1.7;
		}; 
	};
	
	securityData = {
--		playerHitMaxPerTag 	= 1;
		maxHitLockout 		= 1;
		projectileOrigin 	= "character";
--		isDamageContained 	= true;
	};
}

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "dagger-hit" then
		return baseDamage, "physical", "projectile"
	end
end

function abilityData:onCastingBegan__client(renderCharacterContainer)
	if not renderCharacterContainer or not renderCharacterContainer:FindFirstChild("entity") or not renderCharacterContainer.entity:FindFirstChild("AnimationController") then return end
	
	local castingAnimationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(self.castingAnimation)
	castingAnimationTrack:Play()
	
	return renderCharacterContainer.entity["RightHand"]
end

function abilityData:onCastingEnded__client(renderCharacterContainer)
	if not renderCharacterContainer or not renderCharacterContainer:FindFirstChild("entity") or not renderCharacterContainer.entity:FindFirstChild("AnimationController") then return end
	
	for i, animationTrack in pairs(renderCharacterContainer.entity.AnimationController:GetPlayingAnimationTracks()) do
		if animationTrack.Animation == self.castingAnimation then
			animationTrack:Stop()
		end
	end
end

--							(renderCharacterContainer, 	targetPosition, isAbilitySource, hitNormal, nil, 	guid)
function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	local currentlyEquipped 	= network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if not currentWeaponManifest then return end
	
	local animationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations.dagger_throw)
	
	animationTrack:Play()
	
	wait(self.windupTime)
	
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	local dagger 	= currentWeaponManifest:Clone()
	dagger.Anchored = true
	dagger.Parent 	= placeSetup.getPlaceFolder("entities")
	
	local startPosition 							= currentWeaponManifest.Position
	local unitDirection, adjusted_targetPosition 	= projectile.getUnitVelocityToImpact_predictiveByAbilityExecutionData(
		startPosition,
		self.projectileSpeed,
		abilityExecutionData
	)
	
	currentWeaponManifest.Transparency = 1
	
	projectile.createProjectile(
		startPosition,
		unitDirection,
		self.projectileSpeed,
		dagger,
		function(hitPart, hitPosition, hitNormal)
			if hitNormal then
				dagger.CFrame = CFrame.new(hitPosition, hitPosition + hitNormal) * CFrame.Angles(math.pi / 2, 0, 0)
			end
			
			game:GetService("Debris"):AddItem(dagger, 1)
			
			if isAbilitySource then
				-- for damien: todo: hitPart is nil
				if hitPart then
					local canDamageTarget, trueTarget = damage.canPlayerDamageTarget(game.Players.LocalPlayer, hitPart)
					if canDamageTarget and trueTarget then
						--								   (player, serverHitbox, 	damagePosition, sourceType, sourceId, 		guid)
						network:fire("requestEntityDamageDealt", trueTarget, 		hitPosition, 	"ability", 	self.id, "dagger-hit", guid)
					end
				end
			end
		end,
		
		function(t)
			return CFrame.Angles(8*((math.sin(t*math.pi*2)+1)/2), 0, 0)
		end
	)
	
	wait(0.5)
	
	currentWeaponManifest.Transparency = 0
end

return abilityData