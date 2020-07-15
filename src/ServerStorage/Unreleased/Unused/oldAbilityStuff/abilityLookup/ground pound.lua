local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local tween 			= modules.load("tween")
	local damage 			= modules.load("damage")
	local detection 		= modules.load("detection")
	local ability_utilities = modules.load("ability_utilities")
	local utilities			= modules.load("utilities")

local entityManifestCollectionFolder 	= placeSetup.awaitPlaceFolder("entityManifestCollection")
local entitiesFolder 					= placeSetup.getPlaceFolder("entities")

local httpService = game:GetService("HttpService")



local metadata = {
	cost = 4;
	upgradeCost = 2;
	maxRank = 8;
	layoutOrder = 3;
	
	requirement = function(playerData)
		return playerData.class == "Warrior";
	end;
}


local abilityData = {
	--> identifying information <--
	id 	= 5;
	metadata = metadata;
	--> generic information <--
	name 		= "Ground Slam";
	image 		= "rbxassetid://3736598447";
	description = "Leap forward and slam your blade down!";
	
	damageType = "physical";

	layoutOrder = 3;		
		
	--> execution information <--
	windupTime 		= 0.5;
	maxRank 		= 10;
	cooldown 		= 7;
	cost 			= 10;
	
	
	speedMulti = 1.5;
	
	--> combat stats <--
	statistics = {
		[1] = {
			damageMultiplier 	= 3.2;
			radius 				= 15;
			cooldown 			= 12;
			manaCost			= 20;
		}; [2] = {
			damageMultiplier 	= 3.4;
			manaCost			= 21;
		}; [3] = {
			damageMultiplier 	= 3.6;
			manaCost			= 22;
		}; [4] = {
			damageMultiplier 	= 3.8;
			manaCost			= 23;
		}; [5] = {
			damageMultiplier 	= 4.1;
			manaCost			= 25;
			radius				= 17;
			tier 				= 3;
		}; [6] = {
			damageMultiplier 	= 4.4;
			manaCost			= 27;
		}; [7] = {
			damageMultiplier	 = 4.7;
			manaCost			= 29;
		}; [8] = {
			damageMultiplier 	= 5.1;
			manaCost			= 32;
			radius				= 19;
			tier 				= 4;
		};																	
	};
	
	securityData = {
		playerHitMaxPerTag 	= 3;
--		maxHitLockout 		= 1;
		isDamageContained 	= true;
	};
	
	--- ehhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
	damage 		= 30;
	maxRange 	= 30;
	equipmentTypeNeeded = "sword";
}

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage)
	if sourceTag == "shockwave" then
		return baseDamage, "physical", "aoe"
	elseif sourceTag == "shockwave-outer" then
		return baseDamage / 2, "physical", "aoe"
	elseif sourceTag == "slash" then
		return baseDamage, "physical", "direct"
	elseif sourceTag == "aftershock" then
		return baseDamage / 2, "physical", "aoe"
	end
end

local function onAnimationStopped()
	
end

function abilityData._abilityExecutionDataCallback(playerData, ref_abilityExecutionData)
	ref_abilityExecutionData["bounceback"] = playerData and playerData.nonSerializeData.statistics_final.activePerks["bounceback"]
	ref_abilityExecutionData["aftershock"] = playerData and playerData.nonSerializeData.statistics_final.activePerks["aftershock"]
end
local function getKnockbackAmount(abilityExecutionData)
	return abilityExecutionData["bounceback"] and 15000 or 1000
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
	
	local currentlyEquipped = network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if not currentWeaponManifest then return end

	local animationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations.warrior_forwardDownslash)

	local trail

	if currentWeaponManifest then
		local sound = script.cast:Clone()
		sound.Parent = currentWeaponManifest
		-- we should start regularly making other people's ability cast sounds quieter
		if not isAbilitySource then
			sound.Volume = sound.Volume * 0.7
		end
		sound:Play()
		game.Debris:AddItem(sound,5)
		
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
		--[[
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
								
								network:fire("requestEntityDamageDealt", serverHitbox, boxProjection_serverHitbox, "ability", self.id, "slash", guid)
							end
						end
					end
					
					wait(1 / 20)
				else
					break
				end
			end
		end)
		]]
		
	end
	
	animationTrack:Play(0.1, 1, self.speedMulti or 1)
	
	wait(animationTrack.Length * 0.06 / animationTrack.Speed)
	
	if isAbilitySource then
	
		
	
--		local movementDirection = CFrame.new(abilityExecutionData["cast-origin"] * Vector3.new(1, 0, 1), abilityExecutionData["mouse-world-position"] * Vector3.new(1, 0, 1)).lookVector
	
	
--		local movementDirection = (localCharacter.PrimaryPart.CFrame.lookVector)
	
		local movementVelocity = network:invoke("getMovementVelocity")
	
		local movementDirection 
		if movementVelocity.magnitude > 0 then
			movementDirection = movementVelocity.unit 
		else
			movementDirection = localCharacter.PrimaryPart.CFrame.lookVector * 0.05
		end
		
		network:invoke("setCharacterArrested", true)
		
		local bodyGyro 		= localCharacter.PrimaryPart.hitboxGyro
		local bodyVelocity 	= localCharacter.PrimaryPart.hitboxVelocity
		
		bodyGyro.CFrame = CFrame.new(Vector3.new(), movementDirection)
		
		movementDirection =	movementDirection + Vector3.new(0, 1, 0)
		
		
		
		network:invoke("setMovementVelocity", movementDirection * 23 * animationTrack.Speed)
	
	end
	
	wait(animationTrack.Length * 0.36 / animationTrack.Speed)
	
	-- todo: fix
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	network:invoke("setMovementVelocity", Vector3.new())
	
	local timeLeft = 30
	local startTime = tick()
	
	local animationTimePosition = animationTrack.TimePosition
	
	
	local hitPart, hitPosition, hitNormal
			
	
	
	local runService = game:GetService("RunService")
	
	animationTrack:AdjustSpeed(0)
	
	if isAbilitySource then
		network:invoke("setCharacterArrested", false)
	end
	
	repeat 
		local ray = Ray.new(currentWeaponManifest.Position + (renderCharacterContainer.PrimaryPart.CFrame.lookVector * 3) + Vector3.new(0, 2.5, 0), Vector3.new(0, -10, 0))
		hitPart, hitPosition, hitNormal = workspace:FindPartOnRayWithIgnoreList(ray, {renderCharacterContainer, currentWeaponManifest}) 
		wait()
	until hitPart or tick() - startTime >= timeLeft
	
	if trail then
		trail:Destroy()
	end
	
	if isAbilitySource then
		network:invoke("setCharacterArrested", true)
	end
	
	animationTrack:AdjustSpeed(self.speedMulti)
	
	spawn(function()
		if not hitPart then
			return false
		end
		
		if abilityExecutionData["aftershock"] then
			local radius = 8
			local radiusSq = radius ^ 2
			local duration = 0.5
			
			local function aftershock(position)
				-- visuals
				local part = Instance.new("Part")
				part.Anchored = true
				part.CanCollide = false
				part.TopSurface = Enum.SurfaceType.Smooth
				part.BottomSurface = part.TopSurface
				part.Shape = Enum.PartType.Cylinder
				part.BrickColor = BrickColor.new("Dirt brown")
				part.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.pi / 2)
				part.Size = Vector3.new(1, 1, 1)
				
				part.Parent = entitiesFolder
				
				tween(part, {"Size", "Transparency"}, {Vector3.new(1, radius * 2, radius * 2), 1}, duration)
				game:GetService("Debris"):AddItem(part, duration)
				
				-- damage
				if isAbilitySource then
					for _, target in pairs(damage.getDamagableTargets(game.Players.LocalPlayer)) do
						local targetPosition = detection.projection_Box(target.CFrame, target.Size, position)
						local delta = targetPosition - position
						local distanceSq = delta.X ^ 2 + delta.Y ^ 2 + delta.Z ^ 2
						if distanceSq <= radiusSq then
							network:fire("requestEntityDamageDealt", target, target.Position, "ability", self.id, "aftershock", guid)
						end
					end
				end
			end
			
			local function aftershocks()
				local aftershockCount = 8
				for aftershockNumber = 1, aftershockCount do
					local theta = aftershockNumber / aftershockCount * math.pi * 2
					local r = abilityExecutionData["ability-statistics"]["radius"] * 0.75
					local dx = math.cos(theta) * r
					local dz = math.sin(theta) * r
					aftershock(hitPosition + Vector3.new(dx, 0, dz))
				end
				
				utilities.playSound(script.aftershock, hitPosition)
			end
			
			delay(0.5, aftershocks)
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
				local targetPosition = detection.projection_Box(v.CFrame, v.Size, hitPosition)
				
				if ((targetPosition - hitPosition) * Vector3.new(1,0,1)).magnitude <= radius * 0.7 and ((targetPosition - hitPosition) * Vector3.new(0,1,0)).magnitude <= (radius/2) * 0.7 then
					network:fire("requestEntityDamageDealt", v, hitPosition, "ability", self.id, "shockwave", guid)
					
					--knockback
					self:doKnockback(abilityExecutionData, v, hitPosition, getKnockbackAmount(abilityExecutionData))
					
				elseif ((targetPosition - hitPosition) * Vector3.new(1,0,1)).magnitude <= radius and ((targetPosition - hitPosition) * Vector3.new(0,1,0)).magnitude <= (radius/2) then
					network:fire("requestEntityDamageDealt", v, hitPosition, "ability", self.id, "shockwave-outer", guid)
					
					--knockback
					self:doKnockback(abilityExecutionData, v, hitPosition, getKnockbackAmount(abilityExecutionData))
				end
			end
		end				
		
		local startTime = tick()
		local cf = CFrame.new(hitPosition, hitPosition + hitNormal) * CFrame.Angles(math.pi / 2, 0, 0)
		local multi = Vector3.new(radius * 1.7, -1.1, radius * 1.7)
		local base = Vector3.new(0.25, 1.5, 0.25)
		local duration = 0.8
		--[[
		local anim_con = game:GetService("RunService").RenderStepped:connect(function()
			local i = (tick() - startTime) / duration
			
			shockwave1.Size = base + multi * (i ^ 3)
			shockwave2.Size = base + multi * (i ^ 2)
			
			shockwave1.Transparency = math.clamp(i ^ 1.5, 0, 1)
			shockwave2.Transparency = math.clamp(i, 0, 1)
			
			shockwave1.CFrame = cf
			shockwave2.CFrame = cf
		end)
		]]
		
		shockwave1.Size = base
		shockwave2.Size = base
		
		shockwave1.CFrame = cf
		shockwave2.CFrame = cf		
		
		shockwave1.Transparency = 0
		shockwave2.Transparency = 0
		
		tween(shockwave1, {"Size", "Transparency"}, {base + multi, 1}, 1, Enum.EasingStyle.Quad)
		tween(shockwave2, {"Size", "Transparency"}, {base + multi, 1}, 1, Enum.EasingStyle.Quint)
		
		
		
		game.Debris:AddItem(shockwave1, 1)
		game.Debris:AddItem(shockwave2, 1)
		
		--[[
		wait(1)
	
		
		shockwave1:Destroy()
		shockwave2:Destroy()
		anim_con:disconnect()
		]]
	end)
	
	animationTrack:AdjustSpeed(self.speedMulti * 1.65)
		
	wait(animationTrack.Length * 0.4 / animationTrack.Speed)
	
	if isAbilitySource then
		network:invoke("setCharacterArrested", false)
	end
	
	return true

end

return abilityData