local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local detection 		= modules.load("detection")

local monsterManifestCollectionFolder 	= placeSetup.awaitPlaceFolder("monsterManifestCollection")
local entitiesFolder 					= placeSetup.getPlaceFolder("entities")

local httpService = game:GetService("HttpService")




local abilityData = {
	--> identifying information <--
	id 	= 16;
	
	--> generic information <--
	name 		= "Ground Slam";
	image 		= "rbxassetid://2574647455";
	description = "Leap forward and down slash!";
	
	damageType = "physical";
		
	--> execution information <--
	windupTime 		= 0.5;
	maxRank 		= 10;
	cooldown 		= 3;
	cost 			= 10;
	
	
	speedMulti = 1.5;
	
	--> combat stats <--
	statistics = {
		[1] = {
			damageMultiplier 	= 2.50;
			radius 				= 10;
			cooldown 			= 14;
			manaCost			= 25;
		}; [2] = {
			damageMultiplier = 2.60;
		}; [3] = {
			damageMultiplier = 2.70;
		}; [4] = {
			damageMultiplier = 2.80;
		}; [5] = {
			damageMultiplier = 2.90;
			radius 				= 12;
		}; [6] = {
			damageMultiplier = 3.00;
		}; [7] = {
			damageMultiplier = 3.10;
		}; [8] = {
			damageMultiplier = 3.20;
		}; [9] = {
			damageMultiplier = 3.30;
		}; [10] = {
			damageMultiplier = 3.50;
			radius 				= 14;
		}; 																		
		
	};
	
	securityData = {
		playerHitMaxPerTag 	= 1;
--		maxHitLockout 		= 1;
		isDamageContained 	= true;
	};
	
	--- ehhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
	damage 		= 30;
	maxRange 	= 30;
	equipmentTypeNeeded = "sword";
}

local function onAnimationStopped()
	
end

function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	local currentlyEquipped 	= network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if not currentWeaponManifest then return end
	--[[
	local glowEffect 	= script.Glow:Clone()
	glowEffect.Parent 	= currentWeaponManifest
	]]
	local animationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations.warrior_forwardDownslash)

	if currentWeaponManifest then
		local sound = script.cast:Clone()
		sound.Parent = currentWeaponManifest
		-- we should start regularly making other people's ability cast sounds quieter
		if not isAbilitySource then
			sound.Volume = sound.Volume * 0.7
		end
		sound:Play()
		game.Debris:AddItem(sound,5)
	end	
	
	local stopParticles_con
	stopParticles_con = animationTrack.Stopped:connect(function()
		--[[
		glowEffect.Enabled = false
		
		game.Debris:AddItem(glowEffect, 5)
	
		stopParticles_con:disconnect()
		]]
	end)
	
	local localCharacter = game.Players.LocalPlayer.Character
	
	if isAbilitySource and localCharacter then
		
--		local movementVelocity = network:invoke("getMovementVelocity")
--		
--		if movementVelocity then
--			local isPlayerInAir = network:invoke("getCharacterMovementStates").isInAir
--			
--			--network:fire("applyJoltVelocityToCharacter", movementVelocity.unit * (isPlayerInAir and 35 or 85))
--			if not (movementVelocity.magnitude > 0) then
--				movementVelocity = renderCharacterContainer.PrimaryPart.CFrame.lookVector
--			end
--			
--			local characterMovementStates = network:invoke("getCharacterMovementStates")
--			if not characterMovementStates.isInAir and not characterMovementStates.isSprinting then
--				network:fire("applyJoltVelocityToCharacter", movementVelocity.unit *  (isPlayerInAir and 10 or 40))
--			
--				delay(0.2, function()
--					network:fire("applyJoltVelocityToCharacter", Vector3.new(0, 40, 0))
--				end)
--			else
--				return false
--			end
--		else
--			return false
--		end

		while animationTrack.Length == 0 do
			wait(0)
		end
		
		-- hit detection stuff
		spawn(function()
			local hitDebounceTable = {}
			
			while true do
				if animationTrack.IsPlaying then
					-- todo: consider just using serverHitbox in `monsterManifestCollectionFolder` ?
					for i, serverHitbox in pairs(damage.getDamagableTargets(game.Players.LocalPlayer)) do
						if not hitDebounceTable[serverHitbox] then
							local boxcastOriginCF 	= currentWeaponManifest.CFrame
							local boxProjection_serverHitbox = detection.projection_Box(serverHitbox.CFrame, serverHitbox.Size, boxcastOriginCF.p)
							if detection.boxcast_singleTarget(boxcastOriginCF, currentWeaponManifest.Size * Vector3.new(4, 1.5, 2), boxProjection_serverHitbox) then
								hitDebounceTable[serverHitbox] = true
								
								network:fire("requestEntityDamageDealt", serverHitbox, boxProjection_serverHitbox, "ability", self.id, nil, guid)
							end
						end
					end
					
					wait(1 / 20)
				else
					break
				end
			end
		end)
		
	end
	
	animationTrack:Play(0.1, 1, self.speedMulti or 1)
	
	wait(animationTrack.Length * 0.06 / animationTrack.Speed)
	
	if isAbilitySource then
	
		network:invoke("setCharacterArrested", true)
	
--		local movementDirection = CFrame.new(abilityExecutionData["cast-origin"] * Vector3.new(1, 0, 1), abilityExecutionData["mouse-world-position"] * Vector3.new(1, 0, 1)).lookVector
	
	
		local movementDirection = (localCharacter.PrimaryPart.CFrame.lookVector)
		
		local bodyGyro 		= localCharacter.PrimaryPart.hitboxGyro
		local bodyVelocity 	= localCharacter.PrimaryPart.hitboxVelocity
		
		bodyGyro.CFrame = CFrame.new(Vector3.new(), movementDirection)
		
		movementDirection =	movementDirection + Vector3.new(0, 1, 0)
		
		network:invoke("setMovementVelocity", movementDirection * 23 * animationTrack.Speed)
	
	end
	
	wait(animationTrack.Length * 0.355 / animationTrack.Speed)
	
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	network:invoke("setMovementVelocity", Vector3.new())
	
	local timeLeft = 30
	local startTime = tick()
	
	local animationTimePosition = animationTrack.TimePosition
	
	
	local hitPart, hitPosition, hitNormal
			
	
	
	local runService = game:GetService("RunService")
	
	animationTrack:AdjustSpeed(0)
	
	network:invoke("setCharacterArrested", false)
	
	repeat 
		local ray = Ray.new(currentWeaponManifest.Position + (renderCharacterContainer.PrimaryPart.CFrame.lookVector * 2) + Vector3.new(0, 2.5, 0), Vector3.new(0, -9, 0))
		hitPart, hitPosition, hitNormal = workspace:FindPartOnRayWithIgnoreList(ray, {renderCharacterContainer, currentWeaponManifest}) 
		wait()
	until hitPart or tick() - startTime >= timeLeft
	
	network:invoke("setCharacterArrested", true)
	
	animationTrack:AdjustSpeed(self.speedMulti)
		
	
	
	spawn(function()
		
		
		if not hitPart then
			return false
		end
		
		
		local shockwave1 = game.ReplicatedStorage.shockwaveEntity:Clone()
		local shockwave2 = game.ReplicatedStorage.shockwaveEntity:Clone()
		
		shockwave1.Parent = entitiesFolder
		shockwave2.Parent = entitiesFolder
		
		local radius = abilityExecutionData["ability-statistics"].radius
		
		local dustPart = script.dustPart:Clone()
		dustPart.Parent = workspace.CurrentCamera
		dustPart.CFrame = CFrame.new(hitPosition)
		
		dustPart.Dust.Speed = NumberRange.new(30 * (radius/10), 50 * (radius/10))
		
		dustPart.Dust:Emit(100)
		game.Debris:AddItem(dustPart,6)
		

		local sound = script.impact:Clone()
		
		if not isAbilitySource then
			sound.Volume = sound.Volume * 0.7
		end		
		
		sound.Parent = dustPart
		sound:Play()
		
		if isAbilitySource then
--			local radius = 0.25 + 15 * (0.8 ^ 3)
			
			
			for i, v in pairs(damage.getDamagableTargets(game.Players.LocalPlayer)) do
				if (v.Position - hitPosition).magnitude <= radius then
					network:fire("requestEntityDamageDealt", v, hitPosition, "ability", self.id, nil, guid)
				end
			end
		end				
		
		local startTime = tick()
		local cf = CFrame.new(hitPosition, hitPosition + hitNormal) * CFrame.Angles(math.pi / 2, 0, 0)
		local multi = Vector3.new(radius * 1.7, 0, radius * 1.7)
		local base = Vector3.new(0.25, 0.1, 0.25)
		local duration = 0.8
		local anim_con = game:GetService("RunService").RenderStepped:connect(function()
			local i = (tick() - startTime) / duration
			
			shockwave1.Size = base + multi * (i ^ 3)
			shockwave2.Size = base + multi * (i ^ 2)
			
			shockwave1.Transparency = math.clamp(i ^ 1.5, 0, 1)
			shockwave2.Transparency = math.clamp(i, 0, 1)
			
			shockwave1.CFrame = cf
			shockwave2.CFrame = cf
		end)
		
		wait(1)
	
		
		shockwave1:Destroy()
		shockwave2:Destroy()
		anim_con:disconnect()
	end)
		
	wait(animationTrack.Length * 0.5 / animationTrack.Speed)
	
	network:invoke("setCharacterArrested", false)
	
	return true

end

return abilityData