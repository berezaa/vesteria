local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local detection 		= modules.load("detection")

local entitiesFolder = placeSetup.getPlaceFolder("entities")

local httpService = game:GetService("HttpService")

local abilityData = {
	--> identifying information <--
	id 	= 11;
	
	--> generic information <--
	name 		= "Lunge Uppercut";
	image 		= "rbxassetid://2574647455";
	description = "Leap forward and knock enemies up.";
	
	damageType = "physical";
		
	--> execution information <--
	windupTime 		= 0.1;
	maxRank 		= 10;
	cooldown 		= 3;
	cost 			= 10;
	
	--> combat stats <--
	statistics = {
		[1] = {
			damageMultiplier 	= 2.00;
			range 		= 10;
			cooldown 	= 3;
			manaCost	= 35;
		}; [2] = {
			damageMultiplier = 2.10;
		}; [3] = {
			damageMultiplier = 2.20;
		}; [4] = {
			damageMultiplier = 2.30;
		}; [5] = {
			range 		= 11;
			damageMultiplier = 2.40;
		}; [6] = {
			damageMultiplier = 2.50;
		}; [7] = {
			damageMultiplier = 2.60;
		}; [8] = {
			damageMultiplier = 2.70;
		}; [9] = {
			damageMultiplier = 2.80;
		}; [10] = {
			range 		= 12;
			damageMultiplier = 3.00;
		}; 																		
		
	};
	
	--- ehhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
	damage 		= 30;
	maxRange 	= 30;
	equipmentTypeNeeded = "sword";
}

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "uppercut" then
		return baseDamage, "physical", "direct"
	end
end

function abilityData.__serverValidateMovement(player, previousPosition, currentPosition)
	local abilityStatisticsData = network:invoke("getAbilityStatisticsForRank", abilityData, network:invoke("getPlayerAbilityRankByAbilityId", player, abilityData.id))
	
	return (currentPosition - previousPosition).magnitude <= abilityStatisticsData.range * 2
end

local function onAnimationStopped()
	
end

function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	local currentlyEquipped = network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if not currentWeaponManifest then return end
	
	local glowEffect 	= script.Glow:Clone()
	glowEffect.Parent 	= currentWeaponManifest
	
	local animationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations.warrior_uppercut)
	
	local stopParticles_con
	stopParticles_con = animationTrack.Stopped:connect(function()
		glowEffect.Enabled = false
		game.Debris:AddItem(glowEffect,5)
	
		stopParticles_con:disconnect()
	end)
	
	animationTrack:Play()
	
	wait(self.windupTime)
	
	if isAbilitySource then
		local movementVelocity = network:invoke("getMovementVelocity")
		
		if movementVelocity then
			
			local isPlayerInAir = network:invoke("getCharacterMovementStates").isInAir
			
			--network:fire("applyJoltVelocityToCharacter", movementVelocity.unit * (isPlayerInAir and 35 or 85))
			if not (movementVelocity.magnitude > 0) then
				movementVelocity = renderCharacterContainer.PrimaryPart.CFrame.lookVector
			end			
			
			
			local characterMovementStates = network:invoke("getCharacterMovementStates")
			if not characterMovementStates.isInAir and not characterMovementStates.isSprinting then
				network:fire("applyJoltVelocityToCharacter", movementVelocity.unit *  (isPlayerInAir and 10 or 40))
			
				delay(0.2, function()
					network:fire("applyJoltVelocityToCharacter", Vector3.new(0, 40, 0))
				end)
			else
				return false
			end
		else
			return false
		end
		
		local hitDebounceTable = {}
		
		while true do
			if animationTrack.IsPlaying then
				-- todo: consider just using serverHitbox in `monsterManifestCollectionFolder` ?
				for i, serverHitbox in pairs(damage.getDamagableTargets(game.Players.LocalPlayer)) do
					if not hitDebounceTable[serverHitbox] then
						local boxcastOriginCF 	= currentWeaponManifest.CFrame
						local boxProjection_serverHitbox = detection.projection_Box(serverHitbox.CFrame, serverHitbox.Size, boxcastOriginCF.p)
						if detection.boxcast_singleTarget(boxcastOriginCF, currentWeaponManifest.Size * Vector3.new(3, 1.5, 3), boxProjection_serverHitbox) then
							hitDebounceTable[serverHitbox] = true
							
							network:fire("requestEntityDamageDealt", serverHitbox, boxProjection_serverHitbox, "ability", self.id, "uppercut", guid)
						end
					end
				end
				
				wait(1 / 20)
			else
				break
			end
		end
		
		return true
	end
end

return abilityData