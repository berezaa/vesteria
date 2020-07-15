local replicatedStorage = game:GetService("ReplicatedStorage")
	local abilityAnimations = replicatedStorage:WaitForChild("abilityAnimations")
	local modules 			= require(replicatedStorage:WaitForChild("modules"))
		local projectile 		= modules.load("projectile")
		local placeSetup 		= modules.load("placeSetup")
		local client_utilities 	= modules.load("client_utilities")
		local network 			= modules.load("network")
		local damage 			= modules.load("damage")

local httpService = game:GetService("HttpService")

local abilityData = {
	--> identifying information <--
	id 	= 18;
	
	manaCost	= 50;
	
	--> generic information <--
	name 		= "Dark Binding";
	image 		= "rbxassetid://2528902271";
	description = "Bind your enemy's soul to do your bidding.";
	
	damageType = "magical";
	
	-- "skill-shot", "self-target", "target"
	castType 			= "skill-shot";
	castingAnimation 	= abilityAnimations.rock_throw_upper_loop;
		
	--> execution information <--
	animationName 				= {"rock_throw_upper"; "rock_throw_lower"};
	windupTime 					= 0.2;
	maxRank 					= 5;
	cooldown 					= 2;
	projectileSpeed 			= 45;
	projectileGravityMultipler 	= 0.0001;
	
	--> combat stats <--
	statistics = {
		[1] = {
			damageMultiplier 	= 2;
			manaCost			= 50;
			range 				= 40;
			cooldown 			= 10;
		};
	};
}

-- network:fireServer("playerRequest_damageEntity", player, serverHitbox, damagePosition, sourceType, sourceId, sourceTag, guid)
function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	return baseDamage, "physical", "magical"
end

function abilityData:onCastingBegan__client(renderCharacterContainer)
	if not renderCharacterContainer or not renderCharacterContainer:FindFirstChild("entity") or not renderCharacterContainer.entity:FindFirstChild("AnimationController") then return end
	
	local castingAnimationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(self.castingAnimation)
	
	castingAnimationTrack:Play()
	
	local rockCopy 		= replicatedStorage.rockToThrow:Clone()
	rockCopy.Name 		= "CASTING_PROJECTION_ROCK"
	rockCopy.Anchored 	= false
	rockCopy.Parent 	= renderCharacterContainer.entity
	
	local rockMotor 	= Instance.new("Motor6D")
	rockMotor.Part0 	= rockCopy
	rockMotor.Part1 	= renderCharacterContainer.entity["RightHand"]
	rockMotor.C1 		= CFrame.new(0, -rockCopy.Size.Y / 2, 0)
	rockMotor.Parent 	= rockCopy
	
	local currentlyEquipped 	= network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if currentWeaponManifest then
		currentWeaponManifest.Transparency = 1
	end
	
	return rockCopy
end

function abilityData:onCastingEnded__client(renderCharacterContainer)
	if not renderCharacterContainer or not renderCharacterContainer:FindFirstChild("entity") or not renderCharacterContainer.entity:FindFirstChild("AnimationController") then return end
	
	for i, animationTrack in pairs(renderCharacterContainer.entity.AnimationController:GetPlayingAnimationTracks()) do
		if animationTrack.Animation == self.castingAnimation then
			animationTrack:Stop()
		end
	end
	
	if renderCharacterContainer.entity:FindFirstChild("CASTING_PROJECTION_ROCK") then
		renderCharacterContainer.entity.CASTING_PROJECTION_ROCK:Destroy()
	end
	
	local currentlyEquipped 	= network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if currentWeaponManifest then
		currentWeaponManifest.Transparency = 0
	end
end

--							(renderCharacterContainer, 	targetPosition, isAbilitySource, hitNormal, nil, 	guid)
function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	local currentlyEquipped 	= network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if currentWeaponManifest then
		currentWeaponManifest.Transparency = 0
	end
	
	local upperHandChain = script.upperHandChain:Clone() do
		upperHandChain.Parent = renderCharacterContainer.entity["RightUpperArm"]
		
		local weld 	= Instance.new("Weld")
		weld.Part0 	= upperHandChain
		weld.Part1 	= upperHandChain.Parent
		weld.Parent = upperHandChain
	end
	
	local handChain = script.handChain:Clone() do
		handChain.Parent = renderCharacterContainer.entity["RightHand"]
		
		local weld 	= Instance.new("Weld")
		weld.Part0 	= handChain
		weld.Part1 	= handChain.Parent
		weld.Parent = handChain
	end
	
	
	for i, animationName in pairs(self.animationName) do
		local animationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations[animationName])
		
		animationTrack:Play()		
	end
		
	if isAbilitySource then
		network:invoke("setCharacterArrested", true)
	end
	
	wait(self.windupTime)
	
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	if currentWeaponManifest then
		currentWeaponManifest.Transparency = 0
	end
	
	local rock 	= game.ReplicatedStorage.rockToThrow:Clone()
	rock.Parent = placeSetup.getPlaceFolder("entities")
	
	local startPosition 							= renderCharacterContainer.entity["RightHand"].Position
	local unitDirection, adjusted_targetPosition 	= projectile.getUnitVelocityToImpact_predictiveByAbilityExecutionData(
		startPosition,
		self.projectileSpeed,
		abilityExecutionData,
		self.projectileGravityMultipler
	)
	
	projectile.createProjectile(
		startPosition,
		unitDirection,
		self.projectileSpeed,
		rock,
		function(hitPart, hitPosition)
			game:GetService("Debris"):AddItem(rock, 2 / 30)
	
			upperHandChain:Destroy()
			handChain:Destroy()
			
			if isAbilitySource then
				-- for damien: todo: hitPart is nil
				
				network:invoke("setCharacterArrested", false)
				
				-- for damien: todo: hitPart is nil
				if hitPart then
					local canDamageTarget, trueTarget = damage.canPlayerDamageTarget(game.Players.LocalPlayer, hitPart)
					if canDamageTarget and trueTarget then
						--								   (player, serverHitbox, 	damagePosition, sourceType, sourceId, 		guid)
						network:fire("requestEntityDamageDealt", trueTarget, 		hitPosition, 	"ability", 	self.id, nil, guid)
					end
				end
--				if hitPart and damage.canPlayerDamageTarget(game.Players.LocalPlayer, hitPart) then
--	
--					--								   (player, serverHitbox, 	damagePosition, sourceType, sourceId, 		guid)
--					network:fire("requestEntityDamageDealt", hitPart, 		hitPosition, 	"ability", 	self.id, guid)
--				end
			end
		end,
		
		nil,
		
		nil,
		
		nil,
		
		self.projectileGravityMultipler
	)
end

return abilityData