local metadata = {
	cost = 2;
	upgradeCost = 2;
	maxRank = 8;
	
	requirement = function(playerData)
		return true;
	end;
	
	variants = {
		rockThrow = {
			default = true;
			cost = 0;
			requirement = function(playerData)
				return true
			end;			
		};
		magicMissile = {
			cost = 1;
			requirement = function(playerData)
				return playerData.nonSerializeData.statistics_final.int >= 10
			end;
		};
		leechSeed = {
			cost = 1;	
			requirement = function(playerData)
				return playerData.nonSerializeData.statistics_final.vit >= 10
			end;			
		};
	}
}



-- ROCK THROW
-- MAGIC MISSILE
-- LEECH SEED

local debris = game:GetService("Debris")
local runService = game:GetService("RunService")
local httpService = game:GetService("HttpService")

local replicatedStorage = game:GetService("ReplicatedStorage")
	local abilityAnimations = replicatedStorage:WaitForChild("abilityAnimations")
	local modules 			= require(replicatedStorage:WaitForChild("modules"))
		local projectile 		= modules.load("projectile")
		local placeSetup 		= modules.load("placeSetup")
		local client_utilities 	= modules.load("client_utilities")
		local network 			= modules.load("network")
		local damage 			= modules.load("damage")
		local tween	 			= modules.load("tween")
		local ability_utilities = modules.load("ability_utilities")
		local effects           = modules.load("effects")
		local detection         = modules.load("detection")


local entitiesFolder = placeSetup.awaitPlaceFolder("entities")
local spawnRegionCollectionsFolder = placeSetup.getPlaceFolder("spawnRegionCollections")
local entityManifestCollectionFolder = placeSetup.getPlaceFolder("entityManifestCollection")
local entityRenderCollectionFolder = placeSetup.getPlaceFolder("entityRenderCollection")
local itemsFolder = placeSetup.getPlaceFolder("items")
local foilage = placeSetup.getPlaceFolder("foilage")

local RAYCAST_IGNORE_LIST = {spawnRegionCollectionsFolder, entityManifestCollectionFolder, entityRenderCollectionFolder, itemsFolder, entitiesFolder, foilage}

local ABILITY_ID = 34

-- being as barebones as possible to try to break things
local defaultData = {
	id = ABILITY_ID;
	metadata = metadata;
}
local rockThrowData = {
	id 	= ABILITY_ID;
	metadata = metadata;	
	manaCost	= 15;
	name 		= "Rock Throw",
	image 		= "rbxassetid://2528902271";
	description = "Throw a rock at an enemy.";
	damageType = "physical";
	castingAnimation 	= abilityAnimations.rock_throw_upper_loop;
	animationName 	= {"rock_throw_upper"; "rock_throw_lower"};
	windupTime 		= 0.2;
	cooldown 		= 2;
	projectileSpeed = 45;
	statistics = {
		[1] = {
			damageMultiplier 	= 1.5;
			manaCost			= 3;
			cooldown 			= 5;
		};
		[2] = {
			damageMultiplier 	= 1.8;
			manaCost			= 4;
		};	
		[3] = {
			damageMultiplier 	= 2.1;
			manaCost			= 5;
		};			
		[4] = {
			damageMultiplier 	= 2.4;
			manaCost			= 6;
		};	
		[5] = {
			damageMultiplier 	= 3.0;
			manaCost			= 8;
			tier 				= 3;
		};	
		[6] = {
			damageMultiplier 	= 3.6;
			manaCost			= 10;
		};	
		[7] = {
			damageMultiplier 	= 4.2;
			manaCost			= 12;
		};	
		[8] = {
			damageMultiplier 	= 5;
			manaCost			= 15;
			tier 				= 4;
		};											
	};
	securityData = {
		maxHitLockout 		= 1;
		projectileOrigin 	= "character";
	};
	targetingData = {
		targetingType = "projectile",
		projectileSpeed = "projectileSpeed",
		projectileGravity = 1,
		
		onStarted = function(entityContainer, executionData)
			local track = entityContainer.entity.AnimationController:LoadAnimation(abilityAnimations.rock_throw_upper_loop)
			track:Play()
			
			local rock = replicatedStorage.rockToThrow:Clone()
			rock.Trail:Destroy()
			rock.Anchored = false
			rock.Parent = entitiesFolder
			
			local weld = Instance.new("Weld")
			weld.Part1 = entityContainer.entity.RightHand
			weld.Part0 = rock
			weld.C0 = CFrame.new(0, 0.25, 0)
			weld.Parent = rock
			
			local showWeapons = network:invoke("hideWeapons", entityContainer.entity)
			
			return {track = track, showWeapons = showWeapons, rock = rock}
		end,
		
		onEnded = function(entityContainer, executionData, data)
			data.track:Stop()
			
			delay(0.4, function()
				data.rock:Destroy()
				data.showWeapons()
			end)
		end
	};
	_serverProcessDamageRequest = function (sourceTag, baseDamage)
		if sourceTag == "rock-hit" then
			return baseDamage, "physical", "projectile"
		end
	end;	
	execute = function(self, renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
		-- todo: fix
		if not renderCharacterContainer:FindFirstChild("entity") then return end
		
		for i, animationName in pairs(self.animationName) do
			local animationTrack = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations[animationName])
			
			animationTrack:Play()
			
			if renderCharacterContainer.PrimaryPart then
				local sound = script.sound:Clone()
				sound.Parent = renderCharacterContainer.PrimaryPart
				sound:Play()
				game.Debris:AddItem(sound,5)
			end			
		end
		
		wait(self.windupTime)
		
		-- todo: fix
		if not renderCharacterContainer:FindFirstChild("entity") then return end
		
		local rock 	= game.ReplicatedStorage.rockToThrow:Clone()
		rock.Parent = placeSetup.getPlaceFolder("entities")
		
		local startPosition 							= renderCharacterContainer.entity["RightHand"].Position
		local unitDirection, adjusted_targetPosition 	= projectile.getUnitVelocityToImpact_predictive(
			startPosition,
			self.projectileSpeed,
			abilityExecutionData["mouse-target-position"],
			Vector3.new()
		)
		
		local scale = 1 + (abilityExecutionData["ability-statistics"]["damageMultiplier"]/1.5 - 1) * 2
		rock.Size = rock.Size * scale
		
		projectile.createProjectile(
			startPosition,
			unitDirection or (abilityExecutionData["mouse-target-position"] - startPosition).Unit,
			self.projectileSpeed,
			rock,
			function(hitPart, hitPosition)
				game:GetService("Debris"):AddItem(rock, 2 / 30)
				
				if isAbilitySource then
					-- for damien: todo: hitPart is nil
					
					
					-- for damien: todo: hitPart is nil
					if hitPart then
						local canDamageTarget, trueTarget = damage.canPlayerDamageTarget(game.Players.LocalPlayer, hitPart)
						if canDamageTarget and trueTarget then
							--								   (player, serverHitbox, 	damagePosition, sourceType, sourceId, 		guid)
							network:fire("requestEntityDamageDealt", trueTarget, 		hitPosition, 	"ability", 	self.id, "rock-hit", guid)
						end
					end
				end
			end,
			
			nil,
			
			{renderCharacterContainer.clientHitboxToServerHitboxReference.Value}
		)
	end;
}
local magicMissileData = {
	id = ABILITY_ID,
	metadata = metadata;
	name = "Magic Missile",
	image = "rbxassetid://3736638029",
	description = "Call upon your innate magic ability to send out a homing energy missile.",			
	statistics = {
		[1] = {
			cooldown = 1,
			manaCost = 10,
			bolts = 1,
			damageMultiplier = 1.2,
		},
		[2] = {
			damageMultiplier = 1.3,
			manaCost = 14,
		},
		[3] = {
			damageMultiplier = 1.3,
			bolts = 2,
			manaCost = 28,
		},
		[4] = {
			damageMultiplier = 1.4,
			manaCost = 36,
		},
		[5] = {
			damageMultiplier = 1.4,
			bolts = 3,
			manaCost = 54,
			tier = 3;
		},
		[6] = {
			damageMultiplier = 1.5,
			manaCost = 66,
		},
		[7] = {
			damageMultiplier = 1.5,
			bolts = 4,
			manaCost = 88,
		},
		[8] = {
			damageMultiplier = 1.6,
			bolts = 5,
			manaCost = 130,
			tier = 4;
		},												

	},	
	windupTime = 0.35,	
	securityData = {
		playerHitMaxPerTag = 10,
		isDamageContained = true,
		projectileOrigin = "character",
	},	
	targetingData = {
		targetingType = "directSphere",
		radius = 3,
		range = 128,
		
		onStarted = function(entityContainer, executionData)
			local track = entityContainer.entity.AnimationController:LoadAnimation(abilityAnimations.rock_throw_upper_loop)
			track:Play()
			
			return {track = track}
		end,
		
		onEnded = function(entityContainer, executionData, data)
			data.track:Stop()
		end
	};	
	_serverProcessDamageRequest = function(sourceTag, baseDamage)
		if sourceTag == "strike" then
			return baseDamage, "magical", "aoe"
		elseif sourceTag == "twilight" then
			return baseDamage * 1.25, "magical", "aoe"
		end
	end;		
	execute_server = function(self, player, abilityExecutionData, isAbilitySource, data)
		network:fireAllClientsExcludingPlayer("abilityFireClientCall", player, abilityExecutionData, self.id, data)
	end;	
	_abilityExecutionDataCallback = function(playerData, abilityExecutionData)
		abilityExecutionData["twilight"] = playerData and playerData.nonSerializeData.statistics_final.activePerks["twilight"]
	end;
	execute = function(self, renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
		-- assurances
		local root = renderCharacterContainer.PrimaryPart
		if not root then return end
		local entity = renderCharacterContainer:FindFirstChild("entity")
		if not entity then return end
		local rightHand = entity:FindFirstChild("RightHand")
		if not rightHand then return end
		
		-- animation
		local track = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations["rock_throw_upper"])
		track:Play()
		
		-- pause for effect
		wait(self.windupTime)
		
		-- sounds
		for _, soundTemplate in pairs{script.throw, script.magic} do
			local sound = soundTemplate:Clone()
			sound.Parent = root
			sound:Play()
			debris:AddItem(sound, sound.TimeLength)
		end
		
		-- fire the bolts!
		local bolts = abilityExecutionData["ability-statistics"]["bolts"]
		local boltType = "normal"
		
		if abilityExecutionData["twilight"] then
			bolts = bolts + 4
			boltType = "star"
		end
	
		local position = rightHand.Position
		local cframe = CFrame.new(root.Position, abilityExecutionData["mouse-world-position"])
		cframe = cframe + (position - cframe.Position)
	
		local bolts, launchCFrame, owner, guid, doesDealDamage, boltType = bolts, cframe, game.Players.LocalPlayer, guid, true, boltType
	
		local function bolt(launchCFrame, owner, guid, doesDealDamage, boltType)
		
			local topSpeed = 50
			local contactDistanceSq = 3 ^ 2
			local homingDistanceSq = 24 ^ 2
			local homingDelay = 0.2
			
			local missileTemplate = script.missile
			if boltType == "star" then
				missileTemplate = script.star
				topSpeed = topSpeed * 1.5
			end
			
			-- create a missile and keep track of it
			local missile = missileTemplate:Clone()	
			missile.CFrame = launchCFrame * missile.alignAttachment.CFrame:Inverse()
			
			local mover = missile.mover
			local orientationAttachment = missile.orientationAttachment
			local trail = missile.trail
			
			orientationAttachment.CFrame = launchCFrame
			orientationAttachment.Parent = workspace.Terrain
			missile.Parent = entitiesFolder
			
			-- this data is used to update
			-- what the missile does in flight
			local boltData = {
				speed = 12,
				missile = missile,
				target = nil,
				startTime = tick(),
				
				-- which way the missile will drift while searching for a target
				driftCFrame = CFrame.Angles(math.pi * 2 * math.random(), 0, math.pi * 2 * math.random()),
			}
			
			local connection
			local function finish(wasSuccess)
				connection:Disconnect()
				orientationAttachment:Destroy()
				
				missile.Anchored = true
				missile.Transparency = 1
				trail.Enabled = false
				game.Debris:AddItem(missile, trail.Lifetime)
				
				if wasSuccess and doesDealDamage then
					local damageTag = "strike"
					if boltType == "star" then
						damageTag = "twilight"
					end
					network:fire("requestEntityDamageDealt", boltData.target, boltData.target.Position, "ability", ABILITY_ID, damageTag, guid)
				end
			end
			
			local function checkForCollision()
				local missile = boltData.missile
				local origin = missile.Position
				local direction = missile.CFrame.LookVector/2
				local ray = Ray.new(origin, direction)
				local part = workspace:FindPartOnRayWithIgnoreList(ray, RAYCAST_IGNORE_LIST, false, true)
				return part ~= nil and part.CanCollide
			end
			
			-- finds and assigns the nearest target
			-- within homingDistance (defined above)
			local function findTarget()
				local targets = damage.getDamagableTargets(owner)
				local here = boltData.missile.Position
				local best = nil
				local bestDistanceSq = homingDistanceSq
				for _, target in pairs(targets) do
					local there = detection.projection_Box(target.CFrame, target.Size, here)
					local delta = there - here
					local distanceSq =
						delta.X * delta.X +
						delta.Y * delta.Y +
						delta.Z * delta.Z
					if (distanceSq <= bestDistanceSq) then
						best = target
						bestDistanceSq = distanceSq
					end
				end
				boltData.target = best
			end
			
			-- run every frame while the missile is airborne
			local function update(dt)
				-- move in the direction we're facing
				mover.Velocity = (missile.CFrame * missile.alignAttachment.CFrame).LookVector * boltData.speed
				
				-- if we have a target, rotate towards it and run logic if we hit
				if boltData.target then
					local directionCFrame = CFrame.new(missile.Position, boltData.target.Position)
					orientationAttachment.CFrame = directionCFrame
					
					local delta = boltData.target.Position - missile.Position
					local distanceSq =
						delta.X * delta.X +
						delta.Y * delta.Y +
						delta.Z * delta.Z
						
					local size = boltData.target.Size / 2	
					local sizeSq = 
						size.X * size.X +
						size.Y * size.Y +
						size.Z * size.Z
					
					if distanceSq <= math.max(contactDistanceSq, sizeSq) then
						finish(true)
					end
				
				-- if we don't have a target, search for one
				else
					local now = tick()
					local since = now - boltData.startTime
					if since >= homingDelay then
						boltData.speed = topSpeed
						findTarget()
					else
						-- if we're not searching for a target, drift slowly to look cool
						mover.Velocity = boltData.driftCFrame.LookVector * boltData.speed
					end
				end
				
				-- if we hit something we're done
				if checkForCollision() then
					finish(false)
				end
			end
			
			update()
			
			connection = runService.Heartbeat:Connect(update)
			
			-- failsafe
			delay(1.4, function()
				finish(false)
			end)
			
			return boltData
		end	
		
		for boltNumber = 1, bolts do
			bolt(launchCFrame, owner, guid, doesDealDamage, boltType)
			if boltType == "normal" then
				wait(0.1)
			elseif boltType == "star" then
				wait(0.05)
			end
		end		
			
	end;
}
local leechSeedData = {
	id = ABILITY_ID,
	metadata = metadata;	
	name = "Leech Seed",
	image = "rbxassetid://4834447253",
	description = "Hurl a dark bolt which steals health from its victim.",	
	maxRank = 8,
	
	statistics = {
		[1] = {
			cooldown = 2,
			manaCost = 15,
			damageMultiplier = 1.6,
			healing = 30;
			tier = 1;
		},	
		[2] = {
			manaCost = 19,
			damageMultiplier = 1.8,
			healing = 50;
			tier = 2;
		},		
		[3] = {
			manaCost = 23,
			damageMultiplier = 2.0,
			healing = 70
		},		
		[4] = {
			manaCost = 27,
			damageMultiplier = 2.2,
			healing = 90
		},	
		[5] = {
			manaCost = 35,
			damageMultiplier = 2.6,
			healing = 130;
			tier = 3;
		},	
		[6] = {
			manaCost = 43,
			damageMultiplier = 3.0,
			healing = 170
		},		
		[7] = {
			manaCost = 51,
			damageMultiplier = 3.4,
			healing = 210
		},		
		[8] = {
			manaCost = 64,
			damageMultiplier = 4.0,
			healing = 300;
			tier = 4;
		},											
	};			
				

	windupTime = 0.55,	
	securityData = {
		playerHitMaxPerTag = 4,
		isDamageContained = true,
		projectileOrigin = "character",
	},	
	abilityDecidesEnd = true,	
	targetingData = {
		targetingType = "projectile",
		projectileSpeed = 50,
		projectileGravity = 0.0001,
		
		onStarted = function(entityContainer, executionData)
			local track = entityContainer.entity.AnimationController:LoadAnimation(abilityAnimations.left_hand_targeting_sequence)
			track:Play()
			
			local projectionPart = entityContainer.entity.LeftHand
			
			return {track = track, projectionPart = projectionPart}
		end,
		
		onEnded = function(entityContainer, executionData, data)
			data.track:Stop()
		end
	};
	_serverProcessDamageRequest = function(sourceTag, baseDamage)
		if sourceTag == "bolt" then
			return baseDamage, "magical", "projectile"
		end
	end;	
	execute_server = function(self, player, abilityExecutionData, isAbilitySource)
		if not isAbilitySource then return end
		
		local uses = 1
		
		local remote = Instance.new("RemoteEvent")
		remote.Name = "PillageVitalityTemporarySecureRemote"
		remote.OnServerEvent:Connect(function(player, abilityExecutionData)
			
			if player.Character and player.Character.PrimaryPart then			
				local healing = abilityExecutionData["ability-statistics"]["healing"]
				player.Character.PrimaryPart.health.Value = math.min(player.Character.PrimaryPart.health.Value + healing, player.Character.PrimaryPart.maxHealth.Value)
			end
			
			uses = uses - 1
			if uses <= 0 then
				remote:Destroy()
			end
		end)
		remote.Parent = game.ReplicatedStorage
		debris:AddItem(remote, 30)
		
		return remote
	end;			
	execute = function(self, renderCharacterContainer, abilityExecutionData, isAbilitySource, guid)
		-- assurances
		local root = renderCharacterContainer.PrimaryPart
		if not root then return end
		local entity = renderCharacterContainer:FindFirstChild("entity")
		if not entity then return end
		local leftHand = entity:FindFirstChild("LeftHand")
		if not leftHand then return end
		local upperTorso = entity:FindFirstChild("UpperTorso")
		if not upperTorso then return end
		
		-- target acquisition
		local targetPoint =
			abilityExecutionData["target-position"] or
			abilityExecutionData["mouse-world-position"]
		local castingPlayer = ability_utilities.getCastingPlayer(abilityExecutionData)
		
		local tier = abilityExecutionData["ability-statistics"].tier
		
		-- shorthand update function
		local function updateAbilityExecution()
			if not isAbilitySource then return end
			
			local newAbilityExecutionData = network:invoke("getAbilityExecutionData", ABILITY_ID, abilityExecutionData)
			newAbilityExecutionData["ability-state"] = "update"
			newAbilityExecutionData["ability-guid"] = guid
			network:invoke("client_changeAbilityState", ABILITY_ID, "update", newAbilityExecutionData, guid)
		end
		
		if abilityExecutionData["ability-state"] == "begin" then
			-- animation
			local track = renderCharacterContainer.entity.AnimationController:LoadAnimation(abilityAnimations["mage_cast_left_hand_top"])
			track:Play()
			
			-- emitter
			local attachment = Instance.new("Attachment")
			attachment.Name = "PillageVitalityEmitterAttachment"
			attachment.Parent = leftHand
			
			local emitter = script.darkEmitter:Clone()
			emitter.Parent = attachment
			
			local chargeSound = script.charge:Clone()
			chargeSound.Parent = leftHand
			chargeSound:Play()
			
			-- turn off emitter so that it's finished when the windup is done
			delay(self.windupTime - emitter.Lifetime.Max, function()
				emitter.Enabled = false
			end)
			
			-- pause for effect
			wait(self.windupTime)
			
			-- stop charge sound
			chargeSound:Stop()
			chargeSound:Destroy()
			
			-- update the ability
			updateAbilityExecution()
		
		elseif abilityExecutionData["ability-state"] == "update" then
			-- casting sound
			local castSound = script.cast:Clone()
			castSound.Parent = leftHand
			castSound:Play()
			debris:AddItem(castSound, castSound.TimeLength)
		
			-- launch the projectile!
			local function fireProjectile(startPoint)
				local healRemote
				if isAbilitySource then
					healRemote = network:invokeServer("abilityInvokeServerCall", abilityExecutionData, self.id)
				end
				
				local bolt = script.bolt:Clone()
				bolt.Size = bolt.Size * (0.7+tier)/2
				bolt.Parent = entitiesFolder
				
				local ignoreList = projectile.makeIgnoreList{
					renderCharacterContainer,
					renderCharacterContainer.clientHitboxToServerHitboxReference.Value
				}
				
				local function bloodEffect(partA, partB, spin)
					local duration = 1
					local bezierStretch = 16
					
					local blood = script.blood:Clone()
					local trail = blood.trail
					blood.CFrame = partA.CFrame
					blood.Parent = entitiesFolder
					
					local offsetB = CFrame.Angles(0, 0, spin) * CFrame.new(0, bezierStretch, 0)
					local offsetC = CFrame.Angles(0, 0, -spin) * CFrame.new(0, bezierStretch, 0)
					
					effects.onHeartbeatFor(duration, function(dt, t, w)
						local startToFinish = CFrame.new(partA.Position, partB.Position)
						local finishToStart = CFrame.new(partB.Position, partA.Position)
						
						local a = startToFinish.Position
						local b = (startToFinish * offsetB).Position
						local c = (finishToStart * offsetC).Position
						local d = finishToStart.Position
					
						local ab = a + (b - a) * w
						local cd = c + (d - c) * w
						local p = ab + (cd - ab) * w
						
						blood.CFrame = CFrame.new(p)
					end)
					
					delay(duration, function()
						blood.Transparency = 1
						trail.Enabled = false
						debris:AddItem(blood, trail.Lifetime)
					end)
				end
				
				local function lifeStealEffect(target)
					for blood = 1, tier do
						local spin = (blood - 2) * (math.pi / 3)
						bloodEffect(target, upperTorso, spin)
					end
					
					delay(1, function()
						-- restore sound
						local restoreSound = script.restore:Clone()
						restoreSound.Parent = root
						restoreSound:Play()
						debris:AddItem(restoreSound, restoreSound.TimeLength)
						
						-- blood poof
						local duration = 1
						
						local part = Instance.new("Part")
						part.Anchored = true
						part.CanCollide = false
						part.TopSurface = Enum.SurfaceType.Smooth
						part.BottomSurface = Enum.SurfaceType.Smooth					
						
						local sphere = part
						sphere.Shape = Enum.PartType.Ball
						sphere.Color = script.blood.Color
						sphere.Material = Enum.Material.Neon
						sphere.Size = Vector3.new()
						sphere.CFrame = CFrame.new(upperTorso.Position)
						sphere.Parent = entitiesFolder
						
						tween(sphere, {"Size", "Transparency"}, {Vector3.new(6, 6, 6) * (1 + tier)/2, 1}, duration)
						effects.onHeartbeatFor(duration, function()
							sphere.CFrame = CFrame.new(upperTorso.Position)
						end)
						debris:AddItem(sphere, duration)
						
						-- actually heal
						if isAbilitySource then
							healRemote:FireServer(abilityExecutionData)
						end
					end)
				end
				
				local projectileSpeed = 50
				local targetPoint = abilityExecutionData["mouse-target-position"]
				local direction = (targetPoint - startPoint).Unit
				
				-- local direction, targetPoint = projectile.getUnitVelocityToImpact_predictiveByAbilityExecutionData(startPoint, projectileSpeed, abilityExecutionData, 0)
				
				projectile.createProjectile(
					startPoint,
					
					direction,
					
					projectileSpeed,
					
					bolt,
					
					function(hitPart)
						bolt.Transparency = 1
						bolt.emitterAttachment.emitter.Enabled = false
						debris:AddItem(bolt, bolt.emitterAttachment.emitter.Lifetime.Max)
						
						local canDamage, target = damage.canPlayerDamageTarget(castingPlayer, hitPart)
						if canDamage then
							-- sound effect
							local hitSound = script.hit:Clone()
							hitSound.Parent = target
							hitSound:Play()
							debris:AddItem(hitSound, hitSound.TimeLength)
							
							-- succ effect
							lifeStealEffect(target)
							
							if isAbilitySource then
								network:fire("requestEntityDamageDealt", target, bolt.Position, "ability", self.id, "bolt", guid)
							end
						end
					end,
					
					function(t)
						return CFrame.Angles(0, math.pi, math.pi * 2 * t)
					end,
					
					ignoreList,
					
					true,
					
					0
				)
			end
			
			fireProjectile(leftHand.Position)
	
			-- maybe fire another!
			if isAbilitySource then
				if abilityExecutionData["times-updated"] < 1 then
					updateAbilityExecution()
				else
					network:fire("setIsPlayerCastingAbility", false)
					network:invoke("client_changeAbilityState", ABILITY_ID, "end")
				end
			end
		end
	end		
}

function generateAbilityData(playerData, abilityExecutionData)
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

	if abilityExecutionData.variant == "rockThrow" then
		return rockThrowData
	elseif abilityExecutionData.variant == "magicMissile" then
		return magicMissileData
	elseif abilityExecutionData.variant == "leechSeed" then
		return leechSeedData
	end
	
	-- default (barebones as possible to try to break things)
	return defaultData
end

return generateAbilityData



