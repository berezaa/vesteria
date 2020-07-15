local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local projectile 		= modules.load("projectile")
	local placeSetup 		= modules.load("placeSetup")
	local client_utilities 	= modules.load("client_utilities")
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local tween				= modules.load("tween")
	local detection			= modules.load("detection")
	local utilities			= modules.load("utilities")

local httpService = game:GetService("HttpService")

local abilityData

local ABILITY_ID = 4

local metadata = {
	cost = 2;
	upgradeCost = 2;
	maxRank = 8;
	layoutOrder = 3;
	
	requirement = function(playerData)
		return playerData.class == "Mage";
	end;
	
	variants = {
		manaBomb = {
			default = true;
			cost = 0;
			requirement = function(playerData)
				return true
			end;			
		};
		sonicBomb = {
			cost = 1;
			requirement = function(playerData)
				return playerData.nonSerializeData.statistics_final.str >= 30
			end;
		};
		multiBomb = {
			cost = 1;	
			requirement = function(playerData)
				return playerData.nonSerializeData.statistics_final.dex >= 30
			end;			
		};
	}	
}

local function generateAbilityData(playerData, abilityExecutionData)
	
	abilityExecutionData = abilityExecutionData or {}
	if playerData then
		local variant
		for i, ability in pairs(playerData.abilities) do
			if ability.id == ABILITY_ID then
				variant = ability.variant
			end
		end
		abilityExecutionData.variant = variant or "rockThrow"
	end	
	
	local abilityData = utilities.copyTable(abilityData)

	if abilityExecutionData.variant == "sonicBomb" then
		abilityData.name = "Sonic Bomb"
		abilityData.image = "rbxassetid://4730231087";
		abilityData.description = "Channel STR to launch a mana torpedo with faster speed and lower cooldown.";
		abilityData.projectileGravityMultipler 	= 0.025;
		abilityExecutionData.bombColor = {255, 158, 119}
		for level, stats in pairs(abilityData.statistics) do
			if level >= 7 then
				stats.piercing = 4
				stats.speed = 2.25
				stats.manaCost = stats.manaCost + 9
			elseif level >= 5 then
				stats.piercing = 3
				stats.speed = 2
				stats.manaCost = stats.manaCost + 6					
			elseif level >= 3 then
				stats.piercing = 2
				stats.speed = 1.75
				stats.manaCost = stats.manaCost + 3	
			else
				stats.speed = 1.5
				stats.piercing = 1					
			end
			if stats.cooldown then
				stats.cooldown = stats.cooldown - 2
			end
		end			
	elseif abilityExecutionData.variant == "multiBomb" then
		abilityData.name = "Multi Bomb"
		abilityData.image = "rbxassetid://4730231321";
		abilityData.description = "Spread out your mana with DEX to fire multiple bombs at a higher cost."
		abilityData.maxUpdateTimes = 7;
		abilityData.projectileGravityMultipler 	= 0.075;
		abilityExecutionData.bombColor = {193, 130, 255}
		for level, stats in pairs(abilityData.statistics) do
			if level >= 7 then
				stats.bolts = 5
				stats.manaCost = stats.manaCost + 60
			elseif level >= 5 then
				stats.bolts = 4
				stats.manaCost = stats.manaCost + 45					
			elseif level >= 3 then
				stats.bolts = 3
				stats.manaCost = stats.manaCost + 30
			else
				stats.bolts = 2	
				stats.manaCost = stats.manaCost + 15				
			end
			stats.radius = 12
		end
	else
		abilityData.name = "Mana Bomb"
		abilityData.image = "rbxassetid://4730231375";
		abilityData.description = "Unleash the purest form of mana upon your foes.";
		for level, stats in pairs(abilityData.statistics) do
			if level >= 7 then
				stats.radius = stats.radius + 16
				stats.manaCost = stats.manaCost + 8
			elseif level >= 5 then
				stats.radius = stats.radius + 12
				stats.manaCost = stats.manaCost + 6					
			elseif level >= 3 then
				stats.radius = stats.radius + 8
				stats.manaCost = stats.manaCost + 4	
			else
				stats.radius = stats.radius + 4
				stats.manaCost = stats.manaCost + 2					
			end
			if level >= 8 then
				stats.damageMultiplier = stats.damageMultiplier + 0.2
				stats.manaCost = stats.manaCost + 12						
			elseif level >= 6 then
				stats.damageMultiplier = stats.damageMultiplier + 0.15
				stats.manaCost = stats.manaCost + 9							
			elseif level >= 4 then
				stats.damageMultiplier = stats.damageMultiplier + 0.1
				stats.manaCost = stats.manaCost + 6						
			elseif level >= 2 then
				stats.damageMultiplier = stats.damageMultiplier + 0.05
				stats.manaCost = stats.manaCost + 3	
			end
		end			
	end
	return abilityData

end

abilityData = {
	--> identifying information <--
	id 		= ABILITY_ID;
	book 	= "mage";
	metadata = metadata;
	
	--> generic information <--
	name 		= "Mana Bomb";
	image 		= "rbxassetid://4730231375";
	description = "Unleash the purest form of mana upon your foes.";
	-- important todo: override descriptions with this key from the locale table
	description_key = "abilityDescription_magic_bomb";
	mastery = "Bigger explosion.";
	
	
	
	layoutOrder = 1;
	
	damageType = "magical";
	
	-- "skill-shot", "self-target", "target"
	--[[
	castType 			= "skill-shot";
	castingAnimation 	= abilityAnimations.rock_throw_upper_loop;
	]]
		
	--> execution information <--
	animationName 				= {"rock_throw_upper"; "rock_throw_lower"};
	windupTime 					= 0.36;
	maxRank 					= 10;
	maxUpdateTimes 				= 3;
	cooldown 					= 6;
	projectileSpeed 			= 40;
	projectileGravityMultipler 	= 0.05;
	layoutOrder = 1;
	
	--> combat stats <--
	statistics = {
		[1] = {
			damageMultiplier 	= 3;
			radius 				= 15;
			cooldown 			= 6;
			manaCost			= 23;
			range = 160,
		}; [2] = {
			damageMultiplier 	= 3.05;
			radius 				= 17;
			manaCost			= 26;
		}; [3] = {
			damageMultiplier 	= 3.1;
			radius 				= 17;
			manaCost			= 28;
		}; [4] = {
			damageMultiplier 	= 3.15;
			radius 				= 17;
			manaCost			= 30;
		}; [5] = {
			damageMultiplier 	= 3.2;
			radius 				= 19;
			manaCost			= 33;
		}; [6] = {
			damageMultiplier 	= 3.25;
			radius 				= 19;
			manaCost			= 35;
		}; [7] = {
			damageMultiplier 	= 3.3;
			radius 				= 19;
			manaCost			= 37;
		}; [8] = {
			damageMultiplier 	= 3.35;
			radius 				= 21;
			manaCost			= 40;
		}; [9] = {
			damageMultiplier 	= 3.4;
			radius 				= 21;
			manaCost			= 42;
		}; [10] = {
			damageMultiplier 	= 3.45;
			radius 				= 21;
			manaCost			= 44;
		};
	};
	
	securityData = {
		playerHitMaxPerTag 	= nil;
		maxHitLockout 		= nil;
		isDamageContained 	= true;
		projectileOrigin 	= "character";
	};
	
	targetingData = {
		targetingType = "directSphere",
		
		-- "radius" in this ability is actually diameter
		-- epic victory royale amiritelads
		radius = function(executionData)
			return executionData["ability-statistics"]["radius"] / 2
		end,
		
		range = "range",
		
		onStarted = function(entityContainer, executionData)
			local attachment = network:invoke("getCurrentlyEquippedForRenderCharacter", entityContainer.entity)["1"].manifest.magic
			
			local emitter = script.magicBombEntity.t1:Clone()
			emitter.Lifetime = NumberRange.new(0.5)
			emitter.Parent = attachment
			
			local light = Instance.new("PointLight")
			light.Color = BrickColor.new("Electric blue").Color
			light.Parent = attachment
			
			if executionData["holymagic"] then
				emitter.Color = ColorSequence.new(
					BrickColor.new("Daisy orange").Color,
					BrickColor.new("White").Color
				)
				light.Color = BrickColor.new("Daisy orange").Color
			end
			
			return {emitter = emitter, light = light, projectionPart = attachment}
		end,
		
		onEnded = function(entityContainer, executionData, data)
			data.emitter.Enabled = false
			game:GetService("Debris"):AddItem(data.emitter, data.emitter.Lifetime.Max)
			
			data.light:Destroy()
		end
	},
	
	equipmentTypeNeeded = "staff";
	disableAutoaim 		= true;
	abilityDecidesEnd = true;
}

function abilityData._doEnhanceAbility(playerData)
	return not not playerData.nonSerializeData.statistics_final.VENOM_BOMB
end
function abilityData._abilityExecutionDataCallback(playerData, ref_abilityExecutionData)
	local doHolyMagic = playerData and playerData.nonSerializeData.statistics_final.activePerks["holymagic"]
	ref_abilityExecutionData["holymagic"] = doHolyMagic;
end

function abilityData._serverProcessDamageRequest(sourceTag, baseDamage, _, _, player)
	local playerData = network:invoke("getPlayerData", player)
	local damageMulti = 1
	if playerData and playerData.nonSerializeData.statistics_final.activePerks["holymagic"] then
		damageMulti = damageMulti * 1.1
	end
	baseDamage = baseDamage * damageMulti
	if sourceTag == "explosion1" or sourceTag == "explosion2" or sourceTag == "explosion3" or sourceTag == "explosion4" or sourceTag == "explosion5" or sourceTag == "explosion6" or sourceTag == "explosion7" then
		return baseDamage, "magical", "aoe"
	elseif sourceTag == "impact" then
		return baseDamage, "magical", "projectile"
	elseif sourceTag == "venom-puddle" then
		return baseDamage * 0.1, "magical", "dot"
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

function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	if not renderCharacterContainer:FindFirstChild("entity") then return end
	
	local targetPosition = abilityExecutionData["mouse-inrange"]
	warn("$", targetPosition)
	if not targetPosition then return end
	
	if not renderCharacterContainer:FindFirstChild("clientHitboxToServerHitboxReference") then return end
	local serverHitbox = renderCharacterContainer.clientHitboxToServerHitboxReference.Value
	if not serverHitbox then return end
	
	local currentlyEquipped 	= network:invoke("getCurrentlyEquippedForRenderCharacter", renderCharacterContainer.entity)
	local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
	if not currentWeaponManifest or not currentWeaponManifest:FindFirstChild("magic") then return end
	
	
	
	if abilityExecutionData["ability-state"] == "end" then
		if isAbilitySource then
			network:invoke("setCharacterArrested", false)
		end	
		currentWeaponManifest.magic.castEffect.Enabled = false
	elseif abilityExecutionData["ability-state"] == "begin" then
		if isAbilitySource then
			network:invoke("setCharacterArrested", true)
		end	
		currentWeaponManifest.magic.castEffect.Enabled = true
	end
	
	local bombColor = abilityExecutionData["bombColor"] or {85, 253, 255}
	local colorOverride = Color3.fromRGB(unpack(bombColor))
	
	if abilityExecutionData["holymagic"] then
		colorOverride = Color3.fromRGB(255, 234, 110)
	end
	if abilityExecutionData.IS_ENHANCED then
		-- purple for spider venom
		colorOverride = Color3.new(math.max(colorOverride.r * 0.3, 1), colorOverride.g * 0.1, math.max(colorOverride.b * 0.7, 1))
	end
	
	
	
	local bolts = abilityExecutionData["ability-statistics"]["bolts"] or 1
	
	--[[
	local dex = abilityExecutionData["_dex"]
	local bolts = 1
	if dex >= 330 then
		bolts = 7
	elseif dex >= 250 then
		bolts = 6
	elseif dex >= 180 then 
		bolts = 5
	elseif dex >= 120 then
		bolts = 4
	elseif dex >= 70 then
		bolts = 3
	elseif dex >= 30 then
		bolts = 2
	end
	
	colorOverride = Color3.new(
		math.max(colorOverride.r * (1/(bolts^(1/2))), 0),
		math.min(colorOverride.g * (bolts^(1/2)),1), 
		math.max(colorOverride.b * (1/(bolts^(1/2))), 0)
	)
	
	local int = abilityExecutionData["_int"]
	local growthFactor = 0
	if int >= 220 then
		growthFactor = 2
	elseif int >= 150 then
		growthFactor = 1.5
	elseif int >= 90 then
		growthFactor = 1
	elseif int >= 40 then
		growthFactor = 0.5
	end
	
	local str = abilityExecutionData["_str"]
	local multiBangs = 1
	local speedMulti = 1
	if str >= 330 then
		speedMulti = 4
		multiBangs = 7			
	elseif str >= 250 then
		speedMulti = 3.5
		multiBangs = 6			
	elseif str >= 180 then
		speedMulti = 3
		multiBangs = 5			
	elseif str >= 120 then
		speedMulti = 2.5
		multiBangs = 4			
	elseif str >= 70 then
		speedMulti = 2
		multiBangs = 3		
	elseif str >= 30 then
		speedMulti = 1.5
		multiBangs = 2
	end
	local cH, cS, cV = Color3.toHSV(colorOverride)
	colorOverride = Color3.fromHSV(
		cH, 
		cS / speedMulti^(1/2),
		math.min(cV * speedMulti^(1/2), 1)	
	)
	--]]
	
	
	local function fireBall()
		if not currentWeaponManifest then return end
		local magic = currentWeaponManifest:FindFirstChild("magic")
		if not magic then return end
		
		
		-- todo: fix
		if not renderCharacterContainer:FindFirstChild("entity") then return end
		
		local rock 						= script.magicBombEntity:Clone()
		
		if colorOverride then
			rock.Color = colorOverride
			for i,child in pairs(rock:GetChildren()) do
				if child:IsA("ParticleEmitter") then
					local colorOverrideEnd = Color3.new(colorOverride.r * 0.5, colorOverride.g * 0.4, colorOverride.b * 0.5)
					child.Color = ColorSequence.new(colorOverride, colorOverrideEnd)
				end
			end
		end
		
		local currentlyFacingManifest 	= network:invoke("getCurrentlyFacingManifest")
		local startPosition 			= magic.WorldPosition
		
		local speedMulti = abilityExecutionData["ability-statistics"]["speed"] or 1
		
		local unitDirection = projectile.getUnitVelocityToImpact_predictive(
			startPosition,
			self.projectileSpeed * speedMulti,
			targetPosition,
			Vector3.new(),
			self.projectileGravityMultipler
		)
		
		local function ring(factor)
			local newRing = script:FindFirstChild("ring"):Clone()
			
			newRing.Color = colorOverride
			local cf = CFrame.new(rock.Position, rock.Position + unitDirection)
			newRing.CFrame = cf:ToWorldSpace(CFrame.Angles(math.rad(90),0,0)) 
			newRing.Parent = workspace.CurrentCamera
			
			tween(newRing, {"Size"}, {Vector3.new(4,0.5,4)*factor}, factor ^ (1/2), Enum.EasingStyle.Quint)
			tween(newRing, {"Transparency"}, {1}, factor ^ (1/2), Enum.EasingStyle.Linear)
			
			game:GetService("Debris"):AddItem(newRing, factor*1.15)
		end
												
		
		if not unitDirection then return false end
		
		local entityFolder = placeSetup.getPlaceFolder("entities")
		rock.Parent = entityFolder
		
		local multiBangs = (abilityExecutionData["ability-statistics"]["piercing"] or 0) + 1
		local explosionCount = multiBangs
		local explosions = 0
		
		local renderFolder = placeSetup.awaitPlaceFolder("entityRenderCollection")
		
		local boomRadius = abilityExecutionData["ability-statistics"]["radius"]
		if abilityExecutionData["holymagic"] then
			boomRadius = boomRadius * 1.2
		end		
		
		rock.t1.Rate = (boomRadius/15)^(1/2) * 30
		rock.t1.Size = NumberSequence.new(0.312 * (boomRadius/15), 0)
		
		rock.t1.Enabled = true
		
		local tier = abilityExecutionData["ability-statistics"]["tier"] or 1
	
			local mobFolder = placeSetup.awaitPlaceFolder("entityManifestCollection")
		local ignoreList = {renderCharacterContainer, serverHitbox, entityFolder, mobFolder}
	

		
		local hasHitTerrain 
		
		local firesound = script.fireLoop:Clone()
		firesound.Parent = rock
		firesound:Play()
		
	
		rock.CFrame = CFrame.new(startPosition)

		if speedMulti > 1 then
			ring(speedMulti^1.5)
		end	
	
		local growthFactor = 0.25
	
		projectile.createProjectile(
			startPosition,
			unitDirection,
			self.projectileSpeed * speedMulti,
			rock,
			function(hitPart, hitPosition, hitNormal, hitMaterial, t)
				if hitPart then
					for i,ignoreListParent in pairs(ignoreList) do
						if hitPart:IsDescendantOf(ignoreListParent) then
							return true
						end
					end				
				end
				
				explosions = explosions + 1
				local blastRadius = (boomRadius/(explosions^(1/2))) * (1 + t * growthFactor)
				
				do
					
					local rock = rock:Clone()
					rock.Size = Vector3.new(1,1,1) 
					rock.CFrame = CFrame.new(hitPosition)
					rock.Anchored = true
					rock.Parent = entityFolder
					 
					local ring = script.magicBombRing:Clone()
					ring.Parent = rock
					
					
					local ring2 = script.magicBombRing:Clone()
					ring2.Parent = rock
					
					local ring3 = script.magicBombRing:Clone()
					ring3.Parent = rock
		
					if colorOverride then
						local ringColor = Color3.new(
							colorOverride.r / 4,
							colorOverride.g / 3,
							colorOverride.b / 2
						)
						ring.Color = ringColor
						ring2.Color = ringColor
						ring3.Color = ringColor
					end
		
					local ring1BaseRotation = CFrame.Angles(2 * math.pi * math.random(), 0, 2 * math.pi * math.random())
					local ring2BaseRotation = CFrame.Angles(2 * math.pi * math.random(), 0, 2 * math.pi * math.random())
					local ring3BaseRotation = CFrame.Angles(2 * math.pi * math.random(), 0, 2 * math.pi * math.random())
					
					
					
					
					
					local startSize = ((rock.Mesh.Scale * 0.2 * blastRadius/10)) + Vector3.new(5,5,5)
					
					local sound = script.boom:Clone()
					sound.Parent = rock
					sound.Volume = math.clamp(startSize.magnitude / 3, 0.2, 0.6)
					sound.MaxDistance = sound.MaxDistance * sound.Volume
					sound.EmitterSize = sound.EmitterSize * sound.Volume
					
					if not isAbilitySource then
						sound.Volume = sound.Volume * 0.5
					end			
					
					sound:Play()
					
					local durationMulti = math.clamp(startSize.magnitude / 2, 0.3, 1)
					
					delay(0.05 * durationMulti, function()
						rock.explosionParticles.Drag 	= (1.7 * (startSize.X * 8 - 0 - 160 * 1.5)) / (1.5 * 1.5)
						rock.explosionParticles:Emit(60)
					end)
		
					local i = 0
					local tSize = Vector3.new(blastRadius, blastRadius, blastRadius)
								
					rock.Mesh.Scale = Vector3.new(1,1,1)
					
					ring.Size 		= tSize * Vector3.new(0.5, 0.1, 0.5)
					ring.CFrame 	= rock.CFrame * ring1BaseRotation * CFrame.Angles(0, 0, math.pi * (i^0.5))
					
					ring2.Size 		= tSize * Vector3.new(0.5, 0.1, 0.5)
					ring2.CFrame 	= rock.CFrame * ring2BaseRotation * CFrame.Angles(0, 0, math.pi * (i^0.5))
					
					ring3.Size 		= tSize * Vector3.new(0.5, 0.1, 0.5)
					ring3.CFrame 	= rock.CFrame * ring3BaseRotation * CFrame.Angles(0, 0, math.pi * (i^0.5))
					
					rock.Transparency 	= 0
					
					ring.Transparency 	= 0.4
					ring2.Transparency 	= 0.4
					ring3.Transparency 	= 0.4
					
					
					
					local tSize = 2 * Vector3.new(blastRadius, blastRadius, blastRadius) * (1 / 3)
					
					for i,child in pairs(rock:GetChildren()) do
						if child:IsA("ParticleEmitter") then
							child.Enabled = false
						end
					end
					
					local duration = 1 * durationMulti
					
					tween(ring, {"Size", "CFrame", "Transparency"}, {tSize * Vector3.new(1.75, 0.35, 1.75), rock.CFrame * ring1BaseRotation * CFrame.Angles(0, 0, math.pi), 1}, 1.5 * duration, Enum.EasingStyle.Quint)
					tween(ring2, {"Size", "CFrame", "Transparency"}, {tSize * Vector3.new(2, 0.4, 2), rock.CFrame * ring2BaseRotation * CFrame.Angles(0, 0, math.pi), 1}, 1.5 * duration, Enum.EasingStyle.Quint)
					tween(ring3, {"Size", "CFrame", "Transparency"}, {tSize * Vector3.new(1.75, 0.35, 1.75), rock.CFrame * ring3BaseRotation * CFrame.Angles(0, 0, math.pi), 1}, 1.5 * duration, Enum.EasingStyle.Quint)
		
					local spread = rock.spread
					spread.Parent = rock
					local pSize = (tSize.X + tSize.Z) / 2
					spread.Size = NumberSequence.new(pSize / 10, 0.1)
					spread.Speed = NumberRange.new(pSize * 0.7, pSize * 0.9) 
					spread:Emit(50)
					
					
					if hitPosition and isAbilitySource then
						for i, v in pairs(damage.getDamagableTargets(game.Players.LocalPlayer)) do
							local vSize = (v.Size.X + v.Size.Y + v.Size.Z)/3
							if (v.Position - hitPosition).magnitude <= tSize.X/2 + vSize/2.5 then
								spawn(function()
									wait(0.1)
									network:fire("requestEntityDamageDealt", v, hitPosition, "ability", self.id, "explosion"..tostring(explosions), guid)
								end)
							end
						end
					end
					
					tween(rock, {"Transparency"}, {1}, duration, Enum.EasingStyle.Linear)
					tween(rock.Mesh, {"Scale"}, {tSize * 1.25}, duration, Enum.EasingStyle.Quint)
					game:GetService("Debris"):AddItem(rock, 3 * durationMulti)	
					spawn(function()
						wait(0.5 * durationMulti)
						
						wait(1 * durationMulti)
						
						ring.Transparency 	= 1
						ring2.Transparency 	= 1
						ring3.Transparency 	= 1			
					end)
				end
				
				-- badabing badaboom
				if hitPart and explosions < explosionCount then
					if hitPart:IsDescendantOf(renderFolder) then
						local hitEntity
						for i,entity in pairs(renderFolder:GetChildren()) do
							if hitPart:IsDescendantOf(entity) then
								hitEntity = entity
								break
							end
						end
						
						-- allow the bomb to go on and explode again
						if hitEntity then
							table.insert(ignoreList,hitEntity)
							if hitEntity:FindFirstChild("clientHitboxToServerHitboxReference") and hitEntity.clientHitboxToServerHitboxReference.Value then
								table.insert(ignoreList,hitEntity.clientHitboxToServerHitboxReference.Value)
							end
							ring(1 + explosionCount - explosions)
							return true
						end
					end
				end
				
				rock:Destroy()
				
				if abilityExecutionData.IS_ENHANCED and math.acos(hitNormal:Dot(Vector3.new(0, 1, 0))) <= math.rad(50) then
					local venomPuddle 	= script.venomPuddle:Clone()
					venomPuddle.Parent 	= workspace.CurrentCamera
					venomPuddle.CFrame 	= CFrame.new(hitPosition) * CFrame.Angles(0, 0, math.rad(90))
					venomPuddle.Bubbles:Play()
					venomPuddle.Size = Vector3.new(venomPuddle.Size.X, blastRadius * 0.8, blastRadius * 0.8)
					if isAbilitySource then
						spawn(function()
							while venomPuddle.Parent == workspace.CurrentCamera do
								for i, v in pairs(damage.getDamagableTargets(game.Players.LocalPlayer)) do
									local boxcastOriginCF 	= venomPuddle.CFrame + Vector3.new(0, 3, 0)
									local boxProjection_HRP = detection.projection_Box(v.CFrame, v.Size, boxcastOriginCF.p)
									if detection.boxcast_singleTarget(boxcastOriginCF, venomPuddle.Size + Vector3.new(1, 0, 0), boxProjection_HRP) then
										local damagePosition = (hitPosition + v.Position) / 2
										network:fire("requestEntityDamageDealt", v, damagePosition, "ability", self.id, "venom-puddle", guid)
									end
								end
								wait(0.33)
							end
						end)
					end
					
					wait(7)
					
					venomPuddle.Fire.Enabled = false
					tween(venomPuddle, {"Transparency"}, 1, 1)
					game.Debris:AddItem(venomPuddle, 1)
				end
			end,
			function(t) 
				rock.Size = Vector3.new(1,1,1) * (1 + t * growthFactor) * (boomRadius/15)
			end,
			ignoreList,
			
			nil,
			
			self.projectileGravityMultipler
		)	
		

	end	
	
	if abilityExecutionData["ability-state"] == "begin" or abilityExecutionData["ability-state"] == "update" then		
		if abilityExecutionData["ability-state"] == "begin" then			

			
			local animationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations.mage_zapbomb)		
			animationTrack.Looped = true
			animationTrack:AdjustSpeed(0.8)
			spawn(function()
				wait(0.1 + self.windupTime/2.2 + (bolts-1)*(0.1 + self.windupTime/2.8))
				animationTrack:Stop(0.5)
			end)
			animationTrack:Play()			
			
			wait(self.windupTime/2.2)
		else
			
			local castSound = script.cast:Clone()
			castSound.Parent = currentWeaponManifest
			castSound:Play()			
			
			local startPointPart 		= script.sparks:Clone()
			startPointPart.Anchored 	= true
			startPointPart.CanCollide 	= false
			startPointPart.Transparency = 1
			startPointPart.CFrame 		= CFrame.new(currentWeaponManifest.magic.WorldPosition)
			startPointPart.Parent 		= workspace.CurrentCamera
			
			if colorOverride then
				startPointPart.Color = colorOverride
				startPointPart.Fire.Color = ColorSequence.new(colorOverride)
			end
			
			startPointPart.Fire:Emit(15)
			
			local sound 	= script.zippity:Clone()
			sound.Parent 	= startPointPart
			sound:Play()			
			local startPosition = currentWeaponManifest.magic.WorldPosition

			fireBall()						
			wait(self.windupTime/2.4)
		end
		
		if isAbilitySource then
			if (abilityExecutionData["times-updated"] or 0) < bolts then
				local abilityExecutionData = network:invoke("getAbilityExecutionData", abilityData.id, abilityExecutionData)
				abilityExecutionData["ability-state"] 	= "update"
				abilityExecutionData["ability-guid"] 	= guid
					
				network:invoke("client_changeAbilityState", abilityData.id, "update", abilityExecutionData, guid)
			else
				network:fire("setIsPlayerCastingAbility", false)
				network:invoke("client_changeAbilityState", abilityData.id, "end", nil, guid)				
			end
		end
	end
end

return generateAbilityData