local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")

local httpService = game:GetService("HttpService")

local abilityData = {
	--> identifying information <--
	id 		= 20;
	book 	= "mage";
	
	--> generic information <--
	name 		= "Restore";
	image 		= "rbxassetid://2528901888";
	description = "Infuse your ally with life.";
	mastery 	= "Infuse yourself and your ally with life.";
	
	-- "skill-shot", "self-target", "target"
	castType 	= "target";
		
	--> execution information <--
	windupTime 					= 0.35;
	maxRank 					= 2;
	cooldown 					= 10;
	projectileSpeed 			= 50;
	projectileGravityMultipler 	= 0.0001;
	
	--> combat stats <--
	statistics = {
		[1] = {
			magicalStrength = 1;
			range 			= 50;
			manaCost		= 40;
			cooldown 		= 10;
		}; [2] = {
			magicalStrength = 1.25;
			manaCost		= 60;
			cooldown 		= 8;
		};
		 
	};
	
	equipmentTypeNeeded = "staff";
}

function abilityData._serverProcessAbilityActivated(entityCast, abilityStatistics, executionData, hitData)
	
end

function abilityData._serverProcessAbilityDeactivated(entityCast, abilityStatistics, executionData, hitData)
	
end

function abilityData._serverProcessAbilityHit(player, abilityStatistics, abilityGUID, entityManifestHit, sourceTag)
	
	
	return false
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

function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	local currentlyEquipped 	= network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if not currentWeaponManifest or not currentWeaponManifest:FindFirstChild("magic") then return end
	
	local sessionGUID = httpService:GenerateGUID(false)
	for i, animationName in pairs(self.animationName) do
		local animationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations[animationName])
		
		animationTrack:Play()
		if renderCharacterContainer.PrimaryPart then
			local sound = script.cast:Clone()
			sound.Parent = renderCharacterContainer.PrimaryPart
			if not isAbilitySource then
				sound.Volume = sound.Volume * 0.7
			end
			sound:Play()
			game.Debris:AddItem(sound,5)
		end
	end
	
	currentWeaponManifest.magic.castEffect.Enabled = true
	
	wait(self.windupTime)
	
	currentWeaponManifest.magic.castEffect.Enabled = false
	
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	local rock 						= game.ReplicatedStorage.magicBombEntity:Clone()
	local currentlyFacingManifest 	= network:invoke("getCurrentlyFacingManifest")
	local startPosition 			= currentWeaponManifest.magic.WorldPosition--renderCharacterContainer:WaitForChild("entity"):WaitForChild("RightHand").Position
		
--	local e = 1.15
--	local predicted_targetPosition = targetPosition + (targetVelocity or Vector3.new()) * e
--	local t = (predicted_targetPosition - startPosition).magnitude / 18
--	local projectile_unit_velocity = (predicted_targetPosition - startPosition + projectile.GRAVITY * t^2) / (18 * t)
	
	local unitDirection, adjusted_targetPosition = projectile.getUnitVelocityToImpact_predictiveByAbilityExecutionData(
		startPosition,
		self.projectileSpeed,
		abilityExecutionData,
		self.projectileGravityMultipler
	)
	
	if not unitDirection then return false end
	
	rock.Parent = placeSetup.getPlaceFolder("entities")

	projectile.createProjectile(
		startPosition,
		unitDirection,
		self.projectileSpeed,
		rock,
		function(hitPart, hitPosition)
			
			
			if hitPart then
				local canDamageTarget, trueTarget = damage.canPlayerDamageTarget(game.Players.LocalPlayer, hitPart)
				if canDamageTarget and trueTarget then
					network:fire("requestEntityDamageDealt", trueTarget, 		hitPosition, 	"ability", 	self.id, nil, guid)
				end
			end			
			
			local ring = game.ReplicatedStorage.magicBombRing:Clone()
			ring.Parent = rock
			
			local ring2 = game.ReplicatedStorage.magicBombRing:Clone()
			ring2.Parent = rock
			
			local ring3 = game.ReplicatedStorage.magicBombRing:Clone()
			ring3.Parent = rock
			

			local ring1BaseRotation = CFrame.Angles(2 * math.pi * math.random(), 0, 2 * math.pi * math.random())
			local ring2BaseRotation = CFrame.Angles(2 * math.pi * math.random(), 0, 2 * math.pi * math.random())
			local ring3BaseRotation = CFrame.Angles(2 * math.pi * math.random(), 0, 2 * math.pi * math.random())
			
			--local startSize = Vector3.new(2, 2, 2)
			
			local blastRadius = abilityExecutionData["ability-statistics"]["blast radius"] or 10
			
			local startSize = (rock.Mesh.Scale * 0.45 * blastRadius/10) + Vector3.new(0.6,0.6,0.6)
			
			local sound = script.boom:Clone()
			sound.Parent = rock
			sound.Volume = math.clamp(startSize.magnitude / 3, 0.2, 1)
			sound.MaxDistance = sound.MaxDistance * sound.Volume
			sound.EmitterSize = sound.EmitterSize * sound.Volume
			
			if not isAbilitySource then
				sound.Volume = sound.Volume * 0.4
			end			
			
			sound:Play()
						
			
			local durationMutli = math.clamp(startSize.magnitude / 2, 0.3, 1)
			
			delay(0.05 * durationMutli, function()
				-- 								= (2 * (x - x0 - v0 * t)) / (t * t) = a
				rock.explosionParticles.Drag 	= (2 * (startSize.X * 8 - 0 - 160 * 1.5)) / (1.5 * 1.5)
				rock.explosionParticles:Emit(100)
			end)
--			for i = 0, 1 + 1 / (2 * 30), 1 / (2 * 30) do
--				local tSize = startSize:lerp(startSize * 8, i ^ (1/5))
--				
--				rock.Mesh.Scale 	= tSize
--				
--				ring.Mesh.Scale 	= tSize
--				ring.CFrame 		= rock.CFrame * ring1BaseRotation * CFrame.Angles(0, math.pi * (i^0.5), 0)
--				
--				ring2.Mesh.Scale 	= tSize
--				ring2.CFrame 		= rock.CFrame * ring2BaseRotation * CFrame.Angles(0, math.pi * (i^0.5), 0)
--				
--				ring3.Mesh.Scale 	= tSize
--				ring3.CFrame 		= rock.CFrame * ring3BaseRotation * CFrame.Angles(0, math.pi * (i^0.5), 0)
--				
--				rock.Transparency 	= i^2
--				
--				ring.Transparency 	= i
--				ring2.Transparency 	= i
--				ring3.Transparency 	= i
--				
--				wait()
--			end

			

			local timeStart = tick()
			local renderStepped_conn
			renderStepped_conn = game:GetService("RunService").RenderStepped:connect(function(step)
				local i = (tick() - timeStart) / (1.5 * durationMutli) 
				local tSize = startSize:lerp(startSize * 12, i ^ (1/5))
				
				rock.Mesh.Scale = tSize
				rock.Rays.Size = NumberSequence.new(tSize.magnitude)
				rock.Glow.Size = NumberSequence.new(tSize.magnitude)
				
				ring.Size 		= tSize * Vector3.new(1.25, 0.25, 1.25)
				ring.CFrame 	= rock.CFrame * ring1BaseRotation * CFrame.Angles(0, 0, math.pi * (i^0.5))
				
				ring2.Size 		= tSize * Vector3.new(1.25, 0.25, 1.25)
				ring2.CFrame 	= rock.CFrame * ring2BaseRotation * CFrame.Angles(0, 0, math.pi * (i^0.5))
				
				ring3.Size 		= tSize * Vector3.new(1.25, 0.25, 1.25)
				ring3.CFrame 	= rock.CFrame * ring3BaseRotation * CFrame.Angles(0, 0, math.pi * (i^0.5))
				
				rock.Transparency 	= i^2
				
				ring.Transparency 	= 0.1 + i^(1 / 3)
				ring2.Transparency 	= 0.1 + i^(1 / 3)
				ring3.Transparency 	= 0.1 + i^(1 / 3)
			end)
			
			if hitPosition and isAbilitySource then
				for i, v in pairs(damage.getDamagableTargets(game.Players.LocalPlayer)) do
					if (v.Position - hitPosition).magnitude <= 0.1 + startSize.X * 6 then
						spawn(function()
							wait(0.1)
							network:fire("requestEntityDamageDealt", v, hitPosition, "ability", self.id, "explosion", guid)
						end)
					end
				end
			end
			
			wait(0.5 * durationMutli)
			
			rock.Rays.Enabled 	= false
			rock.Glow.Enabled 	= false
			
			wait(1 * durationMutli)
			
			renderStepped_conn:disconnect()
			
			ring.Transparency 	= 1
			ring2.Transparency 	= 1
			ring3.Transparency 	= 1
			
			game:GetService("Debris"):AddItem(rock, 3 * durationMutli)
		end,
		
		function(t)
			rock.Mesh.Scale = Vector3.new(0.1,0.1,0.1) + Vector3.new(t, t, t) * 1.65
		end,
		
		{renderCharacterContainer.clientHitboxToServerHitboxReference.Value},
		
		nil,
		
		self.projectileGravityMultipler
	)
	
	return true
end

return abilityData