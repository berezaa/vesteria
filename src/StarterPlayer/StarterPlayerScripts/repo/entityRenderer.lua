-- Master script that handles entity rendering
-- Main Author: Polymorphic
-- Co-Author: berezaa

local module = {}
local client = game.Players.LocalPlayer

local repo = script.Parent

-- render services
local coreRenderServices = require(repo:WaitForChild("coreRenderServices"))

local bow_manager = coreRenderServices("bow_manager")
local staff_manager = coreRenderServices("staff_manager")
local melee_manager = coreRenderServices("melee_manager")
local appearance_manager = coreRenderServices("appearance_manager")
local ragdoll_manager = coreRenderServices("ragdoll_manager")
local item_manager = coreRenderServices("item_manager")

-- services
local assetFolder = repo.Parent:WaitForChild("assets")

local runService = game:GetService("RunService")
local httpService = game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local modules = require(replicatedStorage:WaitForChild("modules"))

-- load modules
local network = modules.load("network")
local tween = modules.load("tween")
local utilities = modules.load("utilities")
local physics = modules.load("physics")
local placeSetup = modules.load("placeSetup")
local projectile = modules.load("projectile")
local configuration = modules.load("configuration")
local events = modules.load("events")

-- assets
local replicatedStorageAssetFolder = replicatedStorage:WaitForChild("assets")

local defaultCharacterAppearance = require(replicatedStorage:WaitForChild("defaultCharacterAppearance"))
local defaultMonsterStateStates = require(replicatedStorage.defaultMonsterState).states

local entityManifestCollectionFolder = placeSetup.awaitPlaceFolder("entityManifestCollection")
local entityRenderCollectionFolder = placeSetup.awaitPlaceFolder("entityRenderCollection")

local animationInterface
local accessoryLookup = replicatedStorage.assets.accessories
local itemLookup = require(replicatedStorage.itemData)
local monsterLookup = require(replicatedStorage.monsterLookup)
local abilityLookup = require(replicatedStorage.abilityLookup)
local statusEffectLookup = require(replicatedStorage.statusEffectLookup)
local entitiesBeingRendered = {}

-- builds a table of whats currently equipped on a renderCharacter,
-- id rather do this than store what every renderCharacter is wearing and
-- keep track of it.

local function getInventoryCountLookupTableByItemId()
	local lookupTable = {}
	local inventoryLastGot = network:invoke("getCacheValueByNameTag", "inventory")

	if inventoryLastGot then
		for i, inventorySlotData in pairs(inventoryLastGot) do
			if lookupTable[inventorySlotData.id] then
				lookupTable[inventorySlotData.id] = lookupTable[inventorySlotData.id] + (inventorySlotData.stacks or 1)
			else
				lookupTable[inventorySlotData.id] = inventorySlotData.stacks or 1
			end
		end
	end
	return lookupTable
end

-- handles updating appearance of renderCharacter (SPECIFICALLY!!)
-- renderEntityContainer.entity is renderCharacter (renderEntityContainer is also shortened as entityContainer)
-- ^^ ONLY IF entityType == "character" ^^
local function int__updateRenderCharacter(renderCharacter, appearanceData, _entityManifest)
	local associatePlayer do
		if _entityManifest then
			associatePlayer = game.Players:GetPlayerFromCharacter(_entityManifest.Parent)
		end
	end

	appearanceData = appearanceData or defaultCharacterAppearance
	appearanceData.equipment = appearanceData.equipment or defaultCharacterAppearance.equipment
	appearanceData.accessories = appearanceData.accessories or defaultCharacterAppearance.accessories

	-- wipe all previous additions
	local accessories = {
		["!! ACCESSORY !!"] = true,
		["!! EQUIPMENT-UPPER !!"] = true,
		["!! EQUIPMENT !!"] = true,
		["!! WEAPON !!"] = true,
		["!! ARROW !!"] = true,
	}

	for i, obj in pairs(renderCharacter:GetChildren()) do
		if accessories[obj.Name] then
			obj:Destroy()
		end
	end

	appearance_manager.ApplySkinColor(appearanceData, renderCharacter, accessoryLookup, replicatedStorageAssetFolder)

	local hatEquipmentData
	local inventoryCountLookup = getInventoryCountLookupTableByItemId()

	if appearanceData and appearanceData.equipment then
		item_manager.iterateThroughappearanceData(appearanceData,renderCharacter,bow_manager,hatEquipmentData,inventoryCountLookup)
	end

--[[
	playerStoreForCurrentlyEquipped[equipmentData.position] = {
		baseData = weaponBaseData;
		manifest = weaponManifest;
		equipmentData = equipmentData;
	}
--]]

	-- iterate through equipped on character and actual
	item_manager.IterateThroughItems(renderCharacter,appearanceData)

	-- equipping new stuff
	item_manager.EquipNewItem(appearanceData,renderCharacter,_entityManifest,entitiesBeingRendered,animationInterface,associatePlayer,client,assetFolder)

	if appearanceData and appearanceData.accessories then
		appearance_manager.LoadAppearence(replicatedStorageAssetFolder.accessories,appearanceData,hatEquipmentData,itemLookup,renderCharacter)
	end

	if appearanceData and appearanceData.temporaryEquipment then
		for temporaryEquipmentName, _ in pairs(appearanceData.temporaryEquipment) do
			if replicatedStorage:FindFirstChild("temporaryEquipment") and replicatedStorage.temporaryEquipment:FindFirstChild(temporaryEquipmentName) then
				local applicationFunction = require(replicatedStorage.temporaryEquipment[temporaryEquipmentName].application)

				applicationFunction(renderCharacter)
			end
		end
	end

	if renderCharacter then
		for i, obj in pairs(renderCharacter:GetDescendants()) do
			if obj:IsA("BasePart") then
				obj.CanCollide = false
			end
		end
	end
end

local function int__assembleRenderCharacter(manifest)
	local entityContainer 	= Instance.new("Model")

	local clientPlayerHitbox = manifest:Clone()
	clientPlayerHitbox.BrickColor = BrickColor.new("Hot pink")
	clientPlayerHitbox.CanCollide = false
	clientPlayerHitbox.Anchored = true
	clientPlayerHitbox.Name = "hitbox"

	local clientHitboxToServerHitboxReference = Instance.new("ObjectValue")
	clientHitboxToServerHitboxReference.Name = "clientHitboxToServerHitboxReference"
	clientHitboxToServerHitboxReference.Value = manifest
	clientHitboxToServerHitboxReference.Parent = entityContainer

	-- clear all unnecessary parts within the hitbox
	-- we only want the part itself
	clientPlayerHitbox:ClearAllChildren()

	entityContainer.PrimaryPart = clientPlayerHitbox
	clientPlayerHitbox.Parent = entityContainer



	local characterBaseModel = replicatedStorage.playerBaseCharacter:Clone()
	characterBaseModel.Name = "entity"
	characterBaseModel.Parent = entityContainer

	local projectionWeld = Instance.new("Motor6D")
	projectionWeld.Name = "projectionWeld"
	projectionWeld.Part0 = clientPlayerHitbox
	projectionWeld.Part1 = characterBaseModel.PrimaryPart
	projectionWeld.C0 = CFrame.new()
	projectionWeld.C1 = CFrame.new(0, characterBaseModel:GetModelCFrame().Y - characterBaseModel.PrimaryPart.CFrame.Y, 0)
	projectionWeld.Parent = clientPlayerHitbox

	return entityContainer
end

local function dissassembleRenderEntityByManifest(entityManifest)
	if entitiesBeingRendered[entityManifest] then
		for i, connection in pairs(entitiesBeingRendered[entityManifest].connections) do
			connection:disconnect()
		end

		if entitiesBeingRendered[entityManifest].entityContainer and entitiesBeingRendered[entityManifest].entityContainer:FindFirstChild("entity") and entitiesBeingRendered[entityManifest].entityContainer.entity:FindFirstChild("AnimationController") then
			animationInterface:deregisterAnimationsForAnimationController(entitiesBeingRendered[entityManifest].entityContainer.entity.AnimationController)
		else
			-- passing nil will flush all registerations whos index no longer exists
			-- just incase something wack happened..
			animationInterface:deregisterAnimationsForAnimationController(nil)
		end

		entitiesBeingRendered[entityManifest].entityContainer:Destroy()
		entitiesBeingRendered[entityManifest] = nil
	end
end

local playerXpTagPairing = {}

local function int__connectEntityEvents(entityManifest, renderEntityData)
	local associatePlayer = game.Players:GetPlayerFromCharacter(entityManifest.Parent)

	-- we're freezing whether or not its a character
	-- because we can't garauntee entityContainer will be the same.. i think thats why at least
	-- we'll test...
	-- local isEntityCharacter = entityManifest.entityType.Value == "character"

	local previousKeyframeReached_event
	local currentPlayingStateAnimation
	local characterEntityAnimationTracks
	local entityStatesData
	local entityBaseData

	local previousState = ""
	local isWalkingSoundPlaying = false
	local isIdleSoundPlaying = false
	local isRunningSoundPlaying = false

	local monsterAnimations = {}

	local function populateMonsterAnimationsTable()
		if entityManifest.entityType.Value == "monster" or entityManifest.entityType.Value == "pet" then
			monsterAnimations = {}

			-- please dont ask me why im putting it here
			physics:setWholeCollisionGroup(renderEntityData.entityContainer.entity, "monstersLocal")

			for i, animation in pairs(renderEntityData.entityContainer.entity.animations:GetChildren()) do
				local animationTrack = renderEntityData.entityContainer.entity.AnimationController:LoadAnimation(animation)
				local animPriority = "Idle"

				if animation.Name == "attacking" or animation.Name == "death" then
					animPriority = "Action"
				elseif animation.Name == "dashing" or animation.Name == "damaged" then
					animPriority = "Movement"
				elseif animation.Name == "walking" or animation.Name == "idling" then
					animPriority = "Core"
				end

				animationTrack.Priority = Enum.AnimationPriority[animPriority] or Enum.AnimationPriority.Idle
				monsterAnimations[animation.Name] 	= animationTrack
			end
		end
	end

	local function populateEntityData()
		if entityManifest.entityType.Value == "character" then
			characterEntityAnimationTracks = animationInterface:registerAnimationsForAnimationController(renderEntityData.entityContainer.entity.AnimationController, "movementAnimations", "swordAndShieldAnimations", "dualAnimations", "greatswordAnimations", "swordAnimations", "daggerAnimations", "staffAnimations", "fishing-rodAnimations", "emoteAnimations", "bowAnimations")
		elseif entityManifest.entityType.Value == "monster" or entityManifest.entityType.Value == "pet" then
			entityBaseData = (entityManifest.entityType.Value == "monster") and monsterLookup[entityManifest.entityId.Value] or itemLookup[tonumber(entityManifest.entityId.Value)]
			entityStatesData = utilities.copyTable(entityBaseData.statesData.states)

			setmetatable(entityStatesData, {
				__index = function(_, index)
					return defaultMonsterStateStates[index]
				end;
			})
		end
	end

	local function onCharacterAnimationTrackKeyframeReached(keyframeName)
		if keyframeName == "footstep" then
			-- do not play footstep sounds on stealthed characters
			if entityManifest:FindFirstChild("isStealthed") then return end

			local footStep = ""

			local ignore = {workspace.CurrentCamera}
			if workspace:FindFirstChild("placeFolders") then
				table.insert(ignore, workspace.placeFolders)
			end

			local below = Ray.new(entityManifest.Position, Vector3.new(0,-5,0))
			local belowPart, belowPosition, belowNormal, belowMaterial = workspace:FindPartOnRayWithIgnoreList(below, ignore, false, false)

			if belowPart ~= nil and (belowPart:IsA("BasePart") or belowPart:IsA("Terrain")) then
				if belowMaterial == Enum.Material.Grass or belowMaterial == Enum.Material.LeafyGrass then
					footStep = "grass"
				elseif belowMaterial == Enum.Material.Mud or belowMaterial == Enum.Material.Ground then
					footStep = "dirt"
				elseif belowMaterial == Enum.Material.Sand or belowMaterial == Enum.Material.Sandstone then
					footStep = "sand"
				elseif belowMaterial == Enum.Material.Snow or belowMaterial == Enum.Material.Ice then
					footStep = "snow"
				else
					footStep = "stone"
				end
			end

			local footStepSound

			local possibleSounds = {}
			for i = 1, 3 do
				local sound = game.ReplicatedStorage.assets.sounds:FindFirstChild("footstep_"..footStep..(i>1 and tostring(i) or ""))

				if sound then
					table.insert(possibleSounds, sound)
				end
			end

			if #possibleSounds > 0 then
				footStepSound = possibleSounds[math.random(1,#possibleSounds)]
			end

			if footStepSound and renderEntityData.entityContainer.PrimaryPart then
				local newSound 	= utilities.playSound(footStepSound.Name)

				newSound.Parent = renderEntityData.entityContainer.PrimaryPart
				newSound.Looped = false
				newSound.Pitch 	= math.random(95,105) / 100

				-- make ur own volume louder
				if associatePlayer == client then
					newSound.Volume 		= newSound.Volume * 1.5
					newSound.EmitterSize 	= newSound.EmitterSize * 3
					newSound.MaxDistance	= newSound.MaxDistance * 3
				end

				newSound:Play()
				game.Debris:AddItem(newSound,1.5)
			end
		end
	end

	local function onEntityStateChanged(newState)
		if entityManifest.entityType.Value == "character" then
			animationInterface:stopPlayingAnimationsByAnimationCollectionNameWithException(characterEntityAnimationTracks, "emoteAnimations", "consume_consumable")

			if currentPlayingStateAnimation then
				if typeof(currentPlayingStateAnimation) == "Instance" then
					if currentPlayingStateAnimation.Looped or newState == "jumping" then
						currentPlayingStateAnimation:Stop()
					end
				elseif typeof(currentPlayingStateAnimation) == "table" then
					for ii, obj in pairs(currentPlayingStateAnimation) do
						if obj.Looped or newState == "jumping" then
							obj:Stop()
						end
					end
				end
				currentPlayingStateAnimation = nil
			end
		elseif entityManifest.entityType.Value == "monster" or entityManifest.entityType.Value == "pet" then
			if renderEntityData.entityContainer:FindFirstChild("entity") and renderEntityData.entityContainer.entity.PrimaryPart:FindFirstChild("walking") then
				if newState == "walking" or (entityStatesData[newState] and (entityStatesData[newState].animationEquivalent == "walking")) or newState == "movement" or (entityStatesData[newState] and (entityStatesData[newState].animationEquivalent == "movement")) then
					if not isWalkingSoundPlaying then
						renderEntityData.entityContainer.entity.PrimaryPart.walking.Looped = true
						renderEntityData.entityContainer.entity.PrimaryPart.walking:Play()
						isWalkingSoundPlaying = true
					end
				elseif isWalkingSoundPlaying then
					renderEntityData.entityContainer.entity.PrimaryPart.walking:Stop()
					isWalkingSoundPlaying = false
				end
			end

			if renderEntityData.entityContainer:FindFirstChild("entity") and renderEntityData.entityContainer.entity.PrimaryPart:FindFirstChild("running") then
				if newState == "running" or (entityStatesData[newState] and (entityStatesData[newState].animationEquivalent == "running")) then
					if not isRunningSoundPlaying then
						renderEntityData.entityContainer.entity.PrimaryPart.running.Looped = true
						renderEntityData.entityContainer.entity.PrimaryPart.running:Play()
						isRunningSoundPlaying = true
					end
				elseif isRunningSoundPlaying then
					renderEntityData.entityContainer.entity.PrimaryPart.running:Stop()
					isRunningSoundPlaying = false
				end
			end

			if renderEntityData.entityContainer:FindFirstChild("entity") and renderEntityData.entityContainer.entity.PrimaryPart:FindFirstChild("idling") then
				if not isRunningSoundPlaying and not isWalkingSoundPlaying then
					if not isIdleSoundPlaying then
						renderEntityData.entityContainer.entity.PrimaryPart.idling.Looped = true
						renderEntityData.entityContainer.entity.PrimaryPart.idling:Play()
						isIdleSoundPlaying = true
					end
				elseif isIdleSoundPlaying then
					renderEntityData.entityContainer.entity.PrimaryPart.idling:Stop()
					isIdleSoundPlaying = false
				end
			end

			if currentPlayingStateAnimation then
				if entityStatesData[previousState] and not entityStatesData[previousState].doNotStopAnimation then
					currentPlayingStateAnimation:Stop()
				end

				currentPlayingStateAnimation = nil
			end
		end

		if newState == "dead" then
			-- stop all animations
			local function deathEffect(multi)
				multi = multi or 1

				local target = entityManifest.CFrame
				if renderEntityData.entityContainer and renderEntityData.entityContainer:FindFirstChild("entity") then
					if renderEntityData.entityContainer.entity:FindFirstChild("Torso") then
						target = renderEntityData.entityContainer.entity.Torso.CFrame
					elseif renderEntityData.entityContainer.entity:FindFirstChild("UpperTorso") then
						target = renderEntityData.entityContainer.entity.UpperTorso.CFrame
					end
				end

				local deathPart = Instance.new("Part")
				deathPart.Size = entityManifest.Size * multi
				deathPart.CFrame = target
				deathPart.Transparency = 1
				deathPart.CanCollide = false
				deathPart.Anchored = true

				local deathSound = Instance.new("Sound")
				deathSound.SoundId = "rbxassetid://2199444861"
				deathSound.Name = "deathSound"
				deathSound.MaxDistance = 35
				deathSound.Parent = deathPart
				deathSound.Volume = 0.2
				deathSound.PlaybackSpeed = 0.8 + math.random()/5

				if entityManifest:FindFirstChild("monsterScale") and entityManifest.monsterScale.Value > 1.3 then
					deathSound.Volume = deathSound.Volume * entityManifest.monsterScale.Value
					deathSound.MaxDistance = deathSound.MaxDistance * (entityManifest.monsterScale.Value ^ 3)
					deathSound.PlaybackSpeed = deathSound.PlaybackSpeed * (1 - entityManifest.monsterScale.Value/8)
				end

				deathSound:Play()

				local effect 	= assetFolder.Death:Clone()
				effect.Parent 	= deathPart

				deathPart.Parent = workspace.CurrentCamera

				local size = deathPart.Size
				effect:Emit(3 * math.sqrt(size.X * size.Y * size.Z ))

				game.Debris:AddItem(deathPart,3)
			end

			for i, animationTrack in pairs(renderEntityData.entityContainer.entity.AnimationController:GetPlayingAnimationTracks()) do
				animationTrack:Stop()
			end

			if entityManifest.entityType.Value ~= "character" then
				entityManifest.CanCollide = false
			end

			-- make the render also not collidable
			for i, obj in pairs(renderEntityData.entityContainer.entity:GetDescendants()) do
				if obj:IsA("BasePart") then
					obj.CanCollide = false
				end
			end

			if entityManifest.entityType.Value == "monster" or entityManifest.entityType.Value == "pet" then
				local deathConnection
				deathConnection = monsterAnimations.death.Stopped:connect(function()

					deathConnection:disconnect()
					deathEffect()
					-- bye-bye
					dissassembleRenderEntityByManifest(entityManifest)
				end)

				monsterAnimations.death.Looped = false
				monsterAnimations.death:Play()

				if renderEntityData.entityContainer.entity.PrimaryPart and renderEntityData.entityContainer.entity.PrimaryPart:FindFirstChild("death") then
					local hitsounds = {renderEntityData.entityContainer.entity.PrimaryPart.death}

					if renderEntityData.entityContainer.entity.PrimaryPart:FindFirstChild("death2") then
						table.insert(hitsounds, renderEntityData.entityContainer.entity.PrimaryPart:FindFirstChild("death2"))
					end

					if renderEntityData.entityContainer.entity.PrimaryPart:FindFirstChild("death3") then
						table.insert(hitsounds, renderEntityData.entityContainer.entity.PrimaryPart:FindFirstChild("death3"))
					end

					if renderEntityData.entityContainer.entity.PrimaryPart:FindFirstChild("death4") then
						table.insert(hitsounds, renderEntityData.entityContainer.entity.PrimaryPart:FindFirstChild("death4"))
					end

					local rand = math.random(#hitsounds)
					local hitsound = hitsounds[rand]

					if entityManifest:FindFirstChild("monsterScale") and entityManifest.monsterScale.Value > 1.3 and hitsound:FindFirstChild("scalePitch") == nil then
						local scale = entityManifest.monsterScale.Value

						hitsound.Volume 		= hitsound.Volume * scale
						hitsound.EmitterSize 	= hitsound.EmitterSize * (scale ^ 2)
						hitsound.MaxDistance 	= hitsound.MaxDistance * (scale ^ 3)
						hitsound.PlaybackSpeed 	= 1 - ((scale-1) * 0.2)
					end

					local deathPart = Instance.new("Part")
					deathPart.Anchored = true
					deathPart.CanCollide = false
					deathPart.Parent = workspace.CurrentCamera
					deathPart.Size = Vector3.new(0.1,0.1,0.1)
					deathPart.Transparency = 1
					deathPart.CFrame = entityManifest.CFrame

					hitsound.Parent = deathPart
					hitsound:Play()

					game.Debris:AddItem(deathPart,hitsound.TimeLength + 0.1)
				end

				local stateData = entityStatesData[newState]

				spawn(function()
					if stateData and stateData.execute and renderEntityData.entityContainer and renderEntityData.entityContainer:FindFirstChild("entity") then
						stateData.execute(client, monsterAnimations.death, entityBaseData, renderEntityData.entityContainer)
					end
				end)
			elseif entityManifest.entityType.Value == "character" then
				local entity = renderEntityData.entityContainer and renderEntityData.entityContainer:FindFirstChild("entity")
				if entity then
					ragdoll_manager.ragDollCharacter(renderEntityData.entityContainer,renderEntityData)
				end
			end
		elseif newState == "gettingUp" and entityManifest.entityType.Value == "character" then
			local animation = characterEntityAnimationTracks.movementAnimations[newState]

			if animation then
				local connection
				local function onAnimationStopped()
					if connection then
						connection:disconnect()
						connection = nil
					end

					if associatePlayer == client then
						-- client is the one gettingUp, so after the animation finishes we want to stop
						-- the state
						network:invoke("setCharacterArrested", false)
						network:invoke("setCharacterMovementState", "isGettingUp", false)
					end
				end

				connection = animation.Stopped:connect(onAnimationStopped)

				animation.Looped = false
				animation:Play()

				if associatePlayer == client then
					network:invoke("setCharacterArrested", true)
				end
			end
		else
			if entityManifest.entityType.Value == "monster" or entityManifest.entityType.Value == "pet" then
				-- todo: can we remove monsterAnimations[newState] ?
				if monsterAnimations[newState] or (entityStatesData[newState] and entityStatesData[newState].animationEquivalent and monsterAnimations[entityStatesData[newState].animationEquivalent]) then
					local targetAnimation 	= monsterAnimations[newState] or monsterAnimations[entityStatesData[newState].animationEquivalent]

					-- added support for animation variance for a single state
					if monsterAnimations[newState.."2"] then
						local chance = math.random(2)
						if chance == 2 then
							targetAnimation = monsterAnimations[newState.."2"]
						end
					end

					local stateData = entityStatesData[newState]-- or (entityStatesData[newState].animationEquivalent and entityStatesData[entityStatesData[newState].animationEquivalent])

					if targetAnimation then
						currentPlayingStateAnimation = targetAnimation
						currentPlayingStateAnimation.Priority = (entityStatesData[newState] and entityStatesData[newState].animationPriority) or Enum.AnimationPriority.Idle
						currentPlayingStateAnimation.Looped = (entityStatesData[newState] and entityStatesData[newState].doNotLoopAnimation ~= true) or false
						currentPlayingStateAnimation:Play()
					else
						targetAnimation = nil
					end

					-- yikesssss
					if stateData.additional_animation_to_play_temp then
						monsterAnimations[stateData.additional_animation_to_play_temp]:Play()
					end

					if stateData and stateData.execute then
						-- client damaging thingy!
						spawn(function()
							stateData.execute(client, targetAnimation, entityBaseData, renderEntityData.entityContainer)
						end)
					end
				end
			elseif entityManifest.entityType.Value == "character" then
				local weaponStateAppendment = item_manager.GetWeaponStateAppendment(renderEntityData)

				local animationNameToLookFor = newState do
					if entityManifest.entityId.Value ~= "" then
						-- classifying this as a monster masking as a player,
						-- use their states animation

						if monsterLookup[entityManifest.entityId.Value] then
							if monsterLookup[entityManifest.entityId.Value].statesData.states[newState].animationEquivalent then
								animationNameToLookFor = monsterLookup[entityManifest.entityId.Value].statesData.states[newState].animationEquivalent
							elseif defaultMonsterStateStates[newState].animationEquivalent then
								animationNameToLookFor = defaultMonsterStateStates[newState].animationEquivalent
							end
						end
					end
				end

				if weaponStateAppendment then
					if associatePlayer and associatePlayer:FindFirstChild("class") and characterEntityAnimationTracks.movementAnimations[string.lower(associatePlayer.class.Value) .. "_" .. animationNameToLookFor .. weaponStateAppendment] then
						animationNameToLookFor = string.lower(associatePlayer.class.Value) .. "_" .. animationNameToLookFor .. weaponStateAppendment
					end
				end
				local currentlyEquipped = item_manager.getCurrentlyEquippedForRenderCharacter(renderEntityData.entityContainer.entity)

				if characterEntityAnimationTracks.movementAnimations[animationNameToLookFor] or (currentlyEquipped["1"] and currentlyEquipped["1"].baseData.equipmentType and characterEntityAnimationTracks.movementAnimations[animationNameToLookFor .. "_" .. currentlyEquipped["1"].baseData.equipmentType .. weaponStateAppendment]) then
					currentPlayingStateAnimation = item_manager.GetCurrentlyPlayingAnimation(animationNameToLookFor,weaponStateAppendment,characterEntityAnimationTracks,renderEntityData.entityContainer.entity)
					if currentPlayingStateAnimation then
						if previousKeyframeReached_event then
							previousKeyframeReached_event:disconnect()

							local footstep_sound = renderEntityData.entityContainer:FindFirstChild("footstep_sound", true)
							if footstep_sound and footstep_sound.Playing then
								footstep_sound.Looped = false
							end
						end

						-- stop all emotes
						animationInterface:stopPlayingAnimationsByAnimationCollectionName(characterEntityAnimationTracks, "emoteAnimations")

						-- probably fix this.. i really hate that animations are two layered

						if typeof(currentPlayingStateAnimation) == "Instance" then
						print("Animation!")
							previousKeyframeReached_event = currentPlayingStateAnimation.KeyframeReached:connect(onCharacterAnimationTrackKeyframeReached)
							-- ber edit mess with weights here
							if animationNameToLookFor == "walking" then
								currentPlayingStateAnimation:Play(nil, (currentPlayingStateAnimation.Priority == Enum.AnimationPriority.Movement and 0.85) or 1)
							else
								currentPlayingStateAnimation:Play(nil, 1)
							end

							if animationNameToLookFor == "jumping" then
								currentPlayingStateAnimation:AdjustSpeed(1.5)
							end
						elseif typeof(currentPlayingStateAnimation) == "table" then
							previousKeyframeReached_event = currentPlayingStateAnimation[1].KeyframeReached:connect(onCharacterAnimationTrackKeyframeReached)

							for ii, obj in pairs(currentPlayingStateAnimation) do
								obj:Play()

								if animationNameToLookFor == "jumping" then
									obj:AdjustSpeed(1.5)
								end
							end
						end
					end
				end

				previousState = animationNameToLookFor

				-- end it early
				return
			end
		end

		previousState = newState
	end

	function renderEntityData:playAnimation(animationSequenceName, animationName, extraData)

		if characterEntityAnimationTracks[animationSequenceName] and characterEntityAnimationTracks[animationSequenceName][animationName] then
			-- stop all emotes
			animationInterface:stopPlayingAnimationsByAnimationCollectionName(characterEntityAnimationTracks, "emoteAnimations")

			local associatePlayer = game.Players:GetPlayerFromCharacter(entityManifest.Parent)

			if animationName == "consume_consumable" and extraData and extraData.id then
				local itemBaseData = itemLookup[extraData.id]
				local consumableManifest = itemBaseData.module:FindFirstChild("manifest")

				if consumableManifest and renderEntityData.entityContainer and renderEntityData.entityContainer:FindFirstChild("entity") then
					local consumableGrip = renderEntityData.entityContainer.entity:FindFirstChild("ConsumableGrip", true)

					if consumableGrip then
						consumableManifest = consumableManifest:Clone()
						consumableManifest.CanCollide = false
						consumableManifest.Anchored	= false

						for i, Child in pairs(consumableManifest:GetChildren()) do
							if Child:IsA("BasePart") then
								local motor6d = Instance.new("Motor6D")
								motor6d.Part0 = consumableManifest
								motor6d.Part1 = Child
								motor6d.C0 = CFrame.new()
								motor6d.C1 = Child.CFrame:toObjectSpace(consumableManifest.CFrame)
								motor6d.Parent = Child
								Child.CanCollide = false
								Child.Anchored = false
							end
						end

						consumableManifest.Parent 	= renderEntityData.entityContainer.entity
						consumableGrip.Part1 		= consumableManifest

						local currentEquippedManifest = network:invoke("getCurrentWeaponManifest", entityManifest) --currentlyEquipped[1] and currentlyEquipped[1].manifest

						if currentEquippedManifest then
							if currentEquippedManifest:IsA("BasePart") then
								currentEquippedManifest.Transparency = 1
							end

							for i,part in pairs(currentEquippedManifest:GetDescendants()) do
								if part:isA("BasePart") then
									part.Transparency = part.Transparency + 1
								end
							end
						end
						characterEntityAnimationTracks[animationSequenceName]["consume_loop"]:Play()

						local connection
						connection = characterEntityAnimationTracks[animationSequenceName]["consume_loop"].Stopped:connect(function()
						end)

						if itemBaseData.useSound and game.ReplicatedStorage:FindFirstChild("sounds") and consumableManifest then
							local soundMirror = game.ReplicatedStorage.sounds:FindFirstChild(itemBaseData.useSound)
							if soundMirror then
								local sound = Instance.new("Sound")
								for property, value in pairs(game.HttpService:JSONDecode(soundMirror.Value)) do
									sound[property] = value
								end
								sound.Parent = consumableManifest
								sound.Volume = 0.8
								sound.MaxDistance = 150
								sound:Play()
							end
						end

						delay(extraData.ANIMATION_DESIRED_LENGTH or 2, function()
							if consumableManifest then
								if consumableManifest:FindFirstChild("consumed") then
									consumableManifest.consumed.Transparency = 1
								elseif itemBaseData.useSound == "eat_food" then
									consumableManifest.Transparency = 1
									for i,part in pairs(consumableManifest:GetChildren()) do
										if part:IsA("BasePart") then
											part.Transparency = 1
										end
									end
								end
							end

							delay(0.4, function()
								if consumableGrip.Part1 == consumableManifest then
									consumableGrip.Part1 = nil
								end

								if currentEquippedManifest then
									if currentEquippedManifest:IsA("BasePart") then
										currentEquippedManifest.Transparency = 0
									end
									for i,part in pairs(currentEquippedManifest:GetDescendants()) do
										if part:isA("BasePart") then
											part.Transparency = part.Transparency - 1
										end
									end
								end

								if consumableManifest then
									consumableManifest:Destroy()
									consumableManifest = nil
								end

								connection:disconnect()
							end)

							characterEntityAnimationTracks[animationSequenceName]["consume_loop"]:Stop()
						end)
					end
				end
			elseif animationName == "cast-line" and extraData and extraData.targetPosition then
				local currentWeaponManifest = network:invoke("getCurrentWeaponManifest", entityManifest)

				if not currentWeaponManifest or not currentWeaponManifest:FindFirstChild("line") then return end

				characterEntityAnimationTracks[animationSequenceName][animationName]:Play()

				wait(0.75)

				if not currentWeaponManifest or not currentWeaponManifest:FindFirstChild("line") then return end

				local startPosition = (currentWeaponManifest.CFrame * CFrame.new(0, currentWeaponManifest.Size.Y / 2, 0)).p
				local unitDirection = ((Vector3.new(extraData.targetPosition.X, extraData.targetPosition.Y, extraData.targetPosition.Z) - startPosition).unit + Vector3.new(0, 0.08, 0)).unit--((Vector3.new(extraData.targetPosition.X, startPosition.Y, extraData.targetPosition.Z) - startPosition).unit + Vector3.new(0, 0.05, 0)).unit

				if renderEntityData.fishingBob then
					renderEntityData.fishingBob:Destroy()
					renderEntityData.fishingBob = nil
				end

				renderEntityData.fishingBob 		= game.ReplicatedStorage.fishingBob:Clone()
				renderEntityData.fishingBob.Parent 	= placeSetup.getPlaceFolder("entities")

				currentWeaponManifest.line.Attachment1 = renderEntityData.fishingBob.Attachment
				local castSound = utilities.playSound("fishingPoleCast_Short", currentWeaponManifest)

				local t = 2*(   math.abs(startPosition.Y -  extraData.targetPosition.Y)  ) /60
				local dist = (extraData.targetPosition - startPosition).magnitude
				local vel = math.clamp(dist/t, 1, 70)

				projectile.createProjectile(
					startPosition,
					unitDirection,
					vel,    --2xheight / workspace.gravity
					renderEntityData.fishingBob,
					function(hitPart, hitPosition, hitNormal, hitMaterial)
						if hitPart and game.CollectionService:HasTag(hitPart, "fishingSpot") then --if hitPart and hitPart == workspace.Terrain and hitMaterial == Enum.Material.Water then

							if associatePlayer == client then
								network:fire("fishingBobHit", true)
							end

							if renderEntityData.fishingBob and renderEntityData.fishingBob:FindFirstChild("splash") then
								renderEntityData.fishingBob.splash:Emit(20)
							end
							if castSound then
								castSound:Stop()
							end
							utilities.playSound("fishing_BaitSplash", renderEntityData.fishingBob)
							network:invokeServer("playerRequest_startFishing", hitPosition)
						else
							if associatePlayer == client then
								network:fire("fishingBobHit", false)
							end

							if renderEntityData.fishingBob then
								game:GetService("Debris"):AddItem(renderEntityData.fishingBob, 1 / 30)
							end

							renderEntityData.fishingBob = nil
						end
					end,
					function(t)
						if currentWeaponManifest:FindFirstChild("line") then
							currentWeaponManifest.line.Length = 25 * t
						end
					end
				)
			elseif animationName == "reel-line" then
				local currentWeaponManifest = network:invoke("getCurrentWeaponManifest")
				if not currentWeaponManifest or not currentWeaponManifest:FindFirstChild("line") then return end

				characterEntityAnimationTracks[animationSequenceName][animationName]:Play()

				if associatePlayer == client then
					wait(0.75)

					network:invoke("setCharacterMovementState", "isFishing", false)
					network:invoke("setCharacterArrested", false)

					local fish, fishVelocity
					if renderEntityData.fishingBob then
						local _, fishModel, fishVelocityGiven = network:invokeServer("playerRequest_reelFishingRod", renderEntityData.fishingBob.Position)
						fish = fishModel
						fishVelocity = fishVelocityGiven
					end

					if currentWeaponManifest and not fish then
						currentWeaponManifest.line.Attachment1 = nil
					elseif currentWeaponManifest and fish then
						fish.Velocity = fishVelocity
					end
				end

				if renderEntityData.fishingBob then
					renderEntityData.fishingBob:Destroy()
					renderEntityData.fishingBob = nil
				end
			elseif extraData and extraData.dance then
				-- dance emotes
				local currentEquippedManifest
				if  animationName ~= "point" then
					currentEquippedManifest = network:invoke("getCurrentWeaponManifest", entityManifest) --currentlyEquipped[1] and currentlyEquipped[1].manifest

					if currentEquippedManifest then
						if currentEquippedManifest:IsA("BasePart") then
							currentEquippedManifest.Transparency = 1
						end
						for i,part in pairs(currentEquippedManifest:GetDescendants()) do
							if part:isA("BasePart") then
								part.Transparency = part.Transparency + 1
							end
						end
					end
				end

				local prop
				local extraEmoteInfo = {
					["handstand"]	= {fadeTime = .3;};
					["sit"]			= {fadeTime = .3;};
					["panic"]		= {fadeTime = .3;};
					["pushups"]		= {fadeTime = .3;};
					["point"] 		= {singleAction = true;};
					["flex"] 		= {singleAction = true;};
					["guitar"] 		= {singleAction = true;};
					["tadaa"] 		= {singleAction = true;};
					["cheer"] 		= {singleAction = true;};
				}


				if extraEmoteInfo[animationName] and  extraEmoteInfo[animationName].fadeTime then
					characterEntityAnimationTracks[animationSequenceName][animationName]:Play(extraEmoteInfo[animationName].fadeTime)
				else
					characterEntityAnimationTracks[animationSequenceName][animationName]:Play()
				end

				--to-do: potentially do a unified system for animations that hold
				if animationName == "beg" then
					prop = assetFolder.Plate:Clone()
					local weld = Instance.new("WeldConstraint")
					weld.Parent = prop
					prop.CFrame = renderEntityData.entityContainer.entity.RightHand.CFrame *CFrame.Angles(math.pi,0,0) * CFrame.new(-.5,.16,-.2)
					weld.Part1 = prop
					weld.Part0 = renderEntityData.entityContainer.entity.RightHand
					prop.Parent = workspace


					delay(3.1, function()
						--characterEntityAnimationTracks[animationSequenceName]["beg_hold"]:Play()
						characterEntityAnimationTracks[animationSequenceName][animationName]:AdjustSpeed(0)
					end)
				end

				local connection
				connection = characterEntityAnimationTracks[animationSequenceName][animationName].Stopped:connect(function()
					if prop then
						prop:Destroy()
					end


					if currentEquippedManifest then
						if currentEquippedManifest:IsA("BasePart") then
							currentEquippedManifest.Transparency = 0
						end
						for i,part in pairs(currentEquippedManifest:GetDescendants()) do
							if part:isA("BasePart") then
								part.Transparency = part.Transparency - 1
							end
						end
					end

					-- kind of a messy solution but this is needed for emotes to properly work with the control script
					if extraEmoteInfo[animationName] and  extraEmoteInfo[animationName].singleAction then
						network:fire("endEmote")
					end

					connection:disconnect()
				end)
			else
				local animationToBePlayed = characterEntityAnimationTracks[animationSequenceName][animationName]
				if animationSequenceName == "bowAnimations" then
					bow_manager.PlayAnimation(animationSequenceName)
				elseif animationSequenceName == "staffAnimations" then
					staff_manager.PlayAnimation(animationToBePlayed,extraData,configuration)
				end

				if animationToBePlayed then
					print("plAYING" .. animationName)
					melee_manager.PlayAnimation(animationSequenceName, CharacterEntityAnimationTracks, animationName, animationToBePlayed, extraData)
				end
			end
		end
	end

	local function onEntityTypeChanged(newEntityType)
		dissassembleRenderEntityByManifest(entityManifest)

		-- ugly hack since the building function requires this function
		-- EPIC CIRCULAR REQUIREMENTS!
		network:invoke("assembleEntityByManifest", entityManifest)
	end

	local function onEntityIdChanged()
		print("NateDebuggingSomeRandomFunctionWeHaveThatFiresWhenEntityIdChangesButDosentHaveAnythingInIt")
	end

	local monsterNameUI
	local monsterNameTag

	local function setupMonsterDisplayUI()
		--local monsterNameUIPart = renderEntityData.entityContainer:FindFirstChild("MonsterHealthTag") or assetFolder.MonsterHealthTag:Clone()
		--monsterNameUIPart.Parent = renderEntityData.entityContainer
		--monsterNameUI	= monsterNameUIPart.SurfaceGui
		monsterNameUI = assetFolder.monsterHealth:Clone()
		monsterNameUI.Parent = renderEntityData.entityContainer
		monsterNameUI.Adornee = renderEntityData.entityContainer
		monsterNameUI.Enabled = false
		--monsterNameUIPart.Parent = renderEntityData.entityContainer

		local monsterNamePart = renderEntityData.entityContainer:FindFirstChild("MonsterEnemyTag") or assetFolder.MonsterEnemyTag:Clone()
		monsterNamePart.Parent = workspace.CurrentCamera

		monsterNameTag = monsterNamePart.SurfaceGui
		monsterNameTag.Enabled = false

		local monsterScaled = false

		local function monsterScale()
			if not monsterScaled then
				if entityManifest.monsterScale.Value > 1.3 then
					monsterScaled = true
					monsterNameTag.skull.Visible= true
				end
			end
		end

		if entityManifest:FindFirstChild("monsterScale") then
			monsterScale()
		else
			local scaleConnection
			scaleConnection = entityManifest.ChildAdded:connect(function(child)
				if child.Name == "monsterScale" then
					if scaleConnection then
						scaleConnection:disconnect()
						scaleConnection = nil
					end

					monsterScale()
				end
			end)

			table.insert(renderEntityData.connections, scaleConnection)
		end

		monsterNamePart.Parent = renderEntityData.entityContainer

		local level = entityManifest:FindFirstChild("level") and entityManifest.level.Value or 1
		local levelText = "Lvl "..tostring(level)
		monsterNameTag.level.Text = levelText

		if renderEntityData.disableLevelUI then
			monsterNameTag.level.Visible = false
		end

		local levelBounds = game.TextService:GetTextSize(levelText, monsterNameTag.level.TextSize, monsterNameTag.level.Font, Vector2.new()).X + 6
		monsterNameTag.level.Size = UDim2.new(0, levelBounds, 1, -6)

		local isMonsterPet = not not entityManifest:FindFirstChild("pet")
		local monsterText = entityManifest.entityId:FindFirstChild("nickname") and entityManifest.entityId.nickname.Value or entityManifest.entityId.Value

		local isNicknamed = entityManifest.entityId:FindFirstChild("nickname") ~= nil

		if isMonsterPet and not entityManifest.entityId:FindFirstChild("nickname") then
			monsterText = itemLookup[tonumber(entityManifest.entityId.Value)].name
		end

		if entityManifest:FindFirstChild("specialName") then
			monsterText = entityManifest.specialName.Value
		end

		if entityManifest:FindFirstChild("monsterScale") and (not entityManifest:FindFirstChild("notGiant")) then
			if entityManifest.monsterScale.Value > 4.5 then
				monsterText = "Colossal " .. monsterText
			elseif entityManifest.monsterScale.Value > 2.5 then
				monsterText = "Super Giant " .. monsterText
			elseif entityManifest.monsterScale.Value > 1.3 then
				monsterText = "Giant " .. monsterText
			end
		end

		if not isMonsterPet then
			monsterNameTag.monster.AutoLocalize = true
			monsterNameTag.monster.Text = monsterText
			monsterNameTag.monster.Size = UDim2.new(0, game.TextService:GetTextSize(monsterText, monsterNameTag.monster.TextSize, monsterNameTag.monster.Font, Vector2.new()).X, 1, 0)
		else
			monsterNameTag.level.Visible 	= false
			monsterNameTag.monster.Visible 	= false
			monsterNameTag.nickname.Visible = true

			monsterNameTag.nickname.AutoLocalize = not isNicknamed
			monsterNameTag.nickname.Text 	= monsterText
			monsterNameTag.nickname.Size 	= UDim2.new(0, game.TextService:GetTextSize(monsterText, monsterNameTag.nickname.TextSize, monsterNameTag.nickname.Font, Vector2.new()).X + 10, 1, -4)
		end
	end

	local function cleanupMonsterDisplayUI()

		local monsterNamePart = renderEntityData.entityContainer:FindFirstChild("MonsterEnemyTag")
		if monsterNamePart then
			monsterNamePart:Destroy()
		end
	end

	local function setupCharacterDisplayUI()
		local nameTag 	= renderEntityData.entityContainer.PrimaryPart:FindFirstChild("PlayerTag") or assetFolder.PlayerTag:Clone()
		nameTag.Parent 	= renderEntityData.entityContainer.PrimaryPart

		if associatePlayer then
			local xpTag = assetFolder.xpTag:Clone()
			xpTag.Parent = renderEntityData.entityContainer.PrimaryPart
			xpTag.Enabled = true

			playerXpTagPairing[associatePlayer] = xpTag
		end

		monsterNameUI = assetFolder.monsterHealth:Clone()
		monsterNameUI.Parent = renderEntityData.entityContainer
		monsterNameUI.Adornee = renderEntityData.entityContainer
		monsterNameUI.Enabled = false

		if associatePlayer and nameTag then
			local function updateNameTagForCharacter()
				local level = associatePlayer:FindFirstChild("level") and associatePlayer.level.Value or 0
				local levelText = "Lvl." .. level
				nameTag.SurfaceGui.top.level.Text = levelText

				local class = associatePlayer:FindFirstChild("class") and associatePlayer.class.Value or "unknown"
				if class:lower() ~= "adventurer" then
					nameTag.SurfaceGui.top.class.Image = "rbxgameasset://Images/emblem_"..class:lower()
					nameTag.SurfaceGui.top.class.Visible = true
				else
					nameTag.SurfaceGui.top.class.Visible = false
				end

				nameTag.SurfaceGui.bottom.guild.Visible = false
				if associatePlayer:FindFirstChild("guildId") and associatePlayer.guildId.Value ~= "" then
					local guildDataFolder = game.ReplicatedStorage:FindFirstChild("guildDataFolder")
					if guildDataFolder then
						spawn(function()
							local guildDataValue = guildDataFolder:WaitForChild(associatePlayer.guildId.Value, 10)
							if guildDataValue then
								local guildData = httpService:JSONDecode(guildDataValue.Value)
								if guildData.name then
									nameTag.SurfaceGui.bottom.guild.Text = guildData.name
									local nameBounds = game.TextService:GetTextSize(guildData.name, nameTag.SurfaceGui.bottom.guild.TextSize, nameTag.SurfaceGui.bottom.guild.Font, Vector2.new()).X + 10
									nameTag.SurfaceGui.bottom.guild.Size = UDim2.new(0, nameBounds, 1, -4)
									nameTag.SurfaceGui.bottom.guild.Visible = true
								end
							end
						end)
					end
				end

				nameTag.SurfaceGui.top.input.Visible = false
				for i,v in pairs(nameTag.SurfaceGui.top.input:GetChildren()) do
					if v:IsA("GuiObject") then
						v.Visible = false
					end
				end

				if associatePlayer:FindFirstChild("input") then
					local inputFrame = nameTag.SurfaceGui.top.input:FindFirstChild(associatePlayer.input.Value)
					if inputFrame then
						inputFrame.Visible = true
						nameTag.SurfaceGui.top.input.Visible = true
					end
				end

				nameTag.SurfaceGui.top.dev.Visible = associatePlayer:FindFirstChild("developer") ~= nil
				nameTag.SurfaceGui.top.player.Text = associatePlayer.Name

				local levelBounds = game.TextService:GetTextSize(levelText, nameTag.SurfaceGui.top.level.TextSize, nameTag.SurfaceGui.top.level.Font, Vector2.new()).X + 8
				nameTag.SurfaceGui.top.level.Size 	= UDim2.new(0, levelBounds, 1, -4)

				local nameBounds = game.TextService:GetTextSize(associatePlayer.Name, nameTag.SurfaceGui.top.player.TextSize, nameTag.SurfaceGui.top.player.Font, Vector2.new()).X + 10
				nameTag.SurfaceGui.top.player.Size = UDim2.new(0, nameBounds, 1, -4)

				local totalXBound = 0
				for i,child in pairs(nameTag.SurfaceGui.top:GetChildren()) do
					if child:IsA("GuiObject") and child.Visible then
						totalXBound = totalXBound + child.AbsoluteSize.X
					end
				end
				nameTag.SurfaceGui.curve.Size = UDim2.new(0, totalXBound + 10, 0.5, -4)
			end

			-- update once
			updateNameTagForCharacter()

			if associatePlayer:FindFirstChild("guildId") then
				table.insert(renderEntityData.connections, associatePlayer.guildId.Changed:connect(updateNameTagForCharacter))
			end

			if associatePlayer:FindFirstChild("level") then
				table.insert(renderEntityData.connections, associatePlayer.level.Changed:connect(updateNameTagForCharacter))
			end

			if associatePlayer:FindFirstChild("class") then
				table.insert(renderEntityData.connections, associatePlayer.class.Changed:connect(updateNameTagForCharacter))
			end

			if associatePlayer:FindFirstChild("input") then
				table.insert(renderEntityData.connections, associatePlayer.input.Changed:connect(updateNameTagForCharacter))
			end
		end
	end

	local function cleanupCharacterDisplayUI()
		local nameTag = renderEntityData.entityContainer.PrimaryPart:FindFirstChild("PlayerTag")
		if nameTag then
			nameTag:Destroy()
		end

		local chatTag = renderEntityData.entityContainer:FindFirstChild("chatGui")
		if chatTag then
			chatTag:Destroy()
		end
	end

	local currentHealth = entityManifest.health.Value
	local isShowingDamageAnimation = false
	local function onEntityHealthChanged(newHealth)
		if not monsterNameUI then
			if renderEntityData.entityContainer.PrimaryPart:FindFirstChild("monsterNameUI") then
				monsterNameUI = renderEntityData.entityContainer.PrimaryPart.monsterNameUI
			end
		end

		if not monsterNameTag then
			if renderEntityData.entityContainer.PrimaryPart:FindFirstChild("monsterNameTag") then
				monsterNameTag = renderEntityData.entityContainer.PrimaryPart.monsterNameTag
			end
		end

		if monsterNameTag and renderEntityData.entityContainer.Name ~= "Chicken" then
			monsterNameTag.Enabled = true
		end

		-- should we show the health?
		if monsterNameUI then
			local healthUI = monsterNameUI

			if entityBaseData and entityBaseData.boss then
				monsterNameUI.Enabled = false

				healthUI = network:invoke("prepareBossHealthUIForMonster", entityBaseData) or healthUI
				if healthUI and newHealth <= 0 then
					healthUI.Visible = false
				end
			else
				if entityManifest.maxHealth.Value > newHealth and renderEntityData.entityContainer.Name ~= "Chicken" then
					if associatePlayer then
						monsterNameUI.Enabled = true
					else
						monsterNameUI.Enabled = true
					end
				else
					monsterNameUI.Enabled = false
				end
			end

			local fill = healthUI.container.backgroundFill

			local goal = UDim2.new(math.clamp(newHealth / entityManifest.maxHealth.Value, 0, 1), 0, 1, 0)
			if fill.healthLag.Size.X.Scale < fill.currentHealthFill.Size.X.Scale then
				fill.healthLag.Size = fill.currentHealthFill.Size
			end

			fill.healthLag.ImageColor3 = Color3.fromRGB(255, 23, 23)

			fill.currentHealthFill.Size = goal

			spawn(function()
				wait(0.5)
				if fill and fill:FindFirstChild("healthLag") and fill.currentHealthFill.Size == goal then
				--if fill and fill:FindFirstChild("healthLag") and fill.healthLag.ImageColor3 == Color3.fromRGB(255, 43, 43) then
					tween(fill.healthLag, {"Size","ImageColor3"}, {goal, Color3.fromRGB(255, 210, 38)}, 0.3)
				end
			end)
		end

		-- check if was damaged
		if newHealth < currentHealth then
			if not isShowingDamageAnimation then
				isShowingDamageAnimation = true

				local head = renderEntityData.entityContainer.entity:FindFirstChild("head") or renderEntityData.entityContainer.entity:FindFirstChild("body") or renderEntityData.entityContainer.PrimaryPart
				if head:FindFirstChild("damageTaken") then
					head.damageTaken:Play()
				end

				if monsterAnimations.damaged then
					monsterAnimations.damaged.Looped = false
					monsterAnimations.damaged:Play()
				end

				local hitsound

				if renderEntityData.entityContainer.entity.PrimaryPart and renderEntityData.entityContainer.entity.PrimaryPart:FindFirstChild("hit") then
					local hitsounds = {renderEntityData.entityContainer.entity.PrimaryPart.hit}
					if renderEntityData.entityContainer.entity.PrimaryPart:FindFirstChild("hit2") then
						table.insert(hitsounds, renderEntityData.entityContainer.entity.PrimaryPart:FindFirstChild("hit2"))
					end

					if renderEntityData.entityContainer.entity.PrimaryPart:FindFirstChild("hit3") then
						table.insert(hitsounds, renderEntityData.entityContainer.entity.PrimaryPart:FindFirstChild("hit3"))
					end

					if renderEntityData.entityContainer.entity.PrimaryPart:FindFirstChild("hit4") then
						table.insert(hitsounds, renderEntityData.entityContainer.entity.PrimaryPart:FindFirstChild("hit4"))
					end

					hitsound = hitsounds[math.random(1,#hitsounds)]
				end

				if hitsound then
					if entityManifest:FindFirstChild("monsterScale") and entityManifest.monsterScale.Value > 1.3 and hitsound:FindFirstChild("scalePitch") == nil then
						local scale = entityManifest.monsterScale.Value
						hitsound.EmitterSize = hitsound.EmitterSize * scale
						hitsound.MaxDistance = hitsound.MaxDistance * (scale ^ 2)
						local scalePitch = Instance.new("PitchShiftSoundEffect")
						scalePitch.Name = "scalePitch"
						scalePitch.Octave = 0.9
						scalePitch.Parent = hitsound
					end

					hitsound:Play()
				end

				spawn(function()
					wait(0.5)

					if isShowingDamageAnimation then
						isShowingDamageAnimation = false
					end
				end)
			end
		end

		currentHealth = newHealth
	end

	function renderEntityData:setWeaponState(weaponType, weaponState)
		renderEntityData.weaponState = weaponState

		-- force a refresh of the state animations
		local needStateChange = item_manager.RefreshStateAnimation()
		if needStateChange then
			onEntityStateChanged(entityManifest.state.Value)
		end
	end

	-- todo: refactor this to fit current statusEffect schema (does anything even use this?)
	function renderEntityData:changeStatusEffectState(sourcePlayer, sourceType, sourceId, isEnabled)
		if sourceType == "ability" and renderEntityData.entityContainer then
			local playerData
			if sourcePlayer == game.Players.LocalPlayer then
				playerData = network:invoke("getLocalPlayerDataCache")
			end

			local value = entityManifest.activeAbilityExecutionData.Value
			local success, abilityExecutionData = utilities.safeJSONDecode(value)

			local abilityBaseData = abilityLookup[sourceId](playerData, abilityExecutionData)
			if abilityBaseData then
				if isEnabled and abilityBaseData.onStatusEffectBegan then
					abilityBaseData:onStatusEffectBegan(renderEntityData.entityContainer)
				elseif not isEnabled and abilityBaseData.onStatusEffectEnded then
					abilityBaseData:onStatusEffectEnded(renderEntityData.entityContainer)
				end
			end
		end
	end

	local previousStatusEffects = nil
	local function onPlayerStatusEffectsChanged(currentStatusEffectsJSON)
		local success, currentStatusEffects = utilities.safeJSONDecode(currentStatusEffectsJSON)

		if success then
			if previousStatusEffects then
				local diff = {}

				for i,v in pairs(currentStatusEffects) do
					diff[v.id] = 1
				end

				for i,v in pairs(previousStatusEffects) do
					diff[v.id] = (diff[v.id] or 0) - 1
				end

				for id, state in pairs(diff) do
					-- 1 = added, 0 = same, -1 = removed
					local statusEffectData = statusEffectLookup[id]

					if statusEffectData then
						if state == 1 and statusEffectData.__clientApplyTransitionEffectOnCharacter then
							statusEffectData.__clientApplyTransitionEffectOnCharacter(renderEntityData.entityContainer)
						elseif state == 1 and statusEffectData.__clientApplyStatusEffectOnCharacter then
							statusEffectData.__clientApplyStatusEffectOnCharacter(renderEntityData.entityContainer)
						elseif state == 0 then
							-- do nuffin
						elseif state == -1 and statusEffectData.__clientRemoveStatusEffectOnCharacter then
							statusEffectData.__clientRemoveStatusEffectOnCharacter(renderEntityData.entityContainer)
						end
					end
				end

				previousStatusEffects = currentStatusEffects
			else
				for i, activeStatusEffectData in pairs(currentStatusEffects) do
					local statusEffectData = statusEffectLookup[activeStatusEffectData.id]

					if statusEffectData and statusEffectData.__clientApplyStatusEffectOnCharacter then
						statusEffectData.__clientApplyStatusEffectOnCharacter(renderEntityData.entityContainer)
					end
				end

				previousStatusEffects = currentStatusEffects
			end
		end
	end

	local previousCastingAbilityId = 0

	local function onPlayerCastingAbilityIdChanged(castingAbilityId)
		-- todo: make this not necessary
		if associatePlayer == client then return end

		local value = entityManifest.activeAbilityExecutionData.Value
		local success, abilityExecutionData = utilities.safeJSONDecode(value)

		if previousCastingAbilityId > 0 then
			local previousCastingAbilityBaseData = abilityLookup[previousCastingAbilityId](nil, abilityExecutionData)

			if previousCastingAbilityBaseData and previousCastingAbilityBaseData.onCastingEnded__client then
				previousCastingAbilityBaseData:onCastingEnded__client(renderEntityData.entityContainer)
			end
		end

		if castingAbilityId > 0 then
			local castingAbilityBaseData = abilityLookup[castingAbilityId](nil, abilityExecutionData)

			if castingAbilityBaseData and castingAbilityBaseData.onCastingBegan__client then
				castingAbilityBaseData:onCastingBegan__client(renderEntityData.entityContainer)
			end
		end

		previousCastingAbilityId = castingAbilityId
	end

	local previousAbilityExecutionData = {id = 0}

	local function onActiveAbilityExecutionData_changed(value)
		local success, abilityExecutionData = utilities.safeJSONDecode(value)

		if success then
			if previousAbilityExecutionData["ability-guid"] == abilityExecutionData["ability-guid"] and previousAbilityExecutionData["ability-state"] == "end" then
				return false
			end

			local playerData
			if associatePlayer == client then
				playerData = network:invoke("getLocalPlayerDataCache")
			end

			if abilityExecutionData.id == 0 then
				local abilityBaseData = abilityLookup[previousAbilityExecutionData.id](playerData, previousAbilityExecutionData)
				if abilityBaseData and abilityBaseData.cleanup then
					abilityBaseData:cleanup(renderEntityData.entityContainer)
				end

				previousAbilityExecutionData["ability-state"] = "end"
				if abilityBaseData and abilityBaseData.abilityDecidesEnd and abilityBaseData.execute then
					abilityBaseData:execute(renderEntityData.entityContainer, previousAbilityExecutionData, associatePlayer == client, associatePlayer == client and previousAbilityExecutionData["ability-guid"])
				end

				if associatePlayer == client then
					network:fire("setIsPlayerCastingAbility", false)
				end
			else--if (associatePlayer ~= client or abilityExecutionData["ability-state"] ~= "begin") then
				-- safeguard to prevent the client from double-firing
				if abilityExecutionData["ability-guid"] == previousAbilityExecutionData["ability-guid"] and previousAbilityExecutionData.step and abilityExecutionData.step <= previousAbilityExecutionData.step then
					return false
				end

				-- do this at the start since :execute yields
				previousAbilityExecutionData = abilityExecutionData

				local abilityBaseData = abilityLookup[abilityExecutionData.id](playerData, abilityExecutionData)
				if abilityBaseData and abilityBaseData.execute then
					abilityBaseData:execute(renderEntityData.entityContainer, abilityExecutionData, associatePlayer == client, associatePlayer == client and abilityExecutionData["ability-guid"])
					if associatePlayer == client and not abilityBaseData.abilityDecidesEnd then
						wait()
						network:invoke("client_changeAbilityState", abilityExecutionData.id, "end", abilityExecutionData, abilityExecutionData.guid)
					end
				end
			end
		end
	end

	local function onCharacterAppearanceChanged(appearanceJSON)
		local success, appearanceData = utilities.safeJSONDecode(appearanceJSON)

		if success then
			int__updateRenderCharacter(renderEntityData.entityContainer.entity, appearanceData, entityManifest)
		end
	end

	local previousStatusEffectsV2
	local function onEntityStatusEffectChanged(newStatusEffectsV2)
		local success, currentStatusEffectsV2 = utilities.safeJSONDecode(newStatusEffectsV2)

		if success then
			if previousStatusEffectsV2 then
				local diff = {}

				for i,v in pairs(currentStatusEffectsV2) do
					diff[v.statusEffectType] = 1
				end

				for i,v in pairs(previousStatusEffectsV2) do
					diff[v.statusEffectType] = (diff[v.statusEffectType] or 0) - 1
				end

				for id, state in pairs(diff) do
					-- 1 = added, 0 = same, -1 = removed
					local statusEffectData = statusEffectLookup[id]

					if statusEffectData then
						if state == 1 and statusEffectData.__clientApplyTransitionEffectOnCharacter then
							statusEffectData.__clientApplyTransitionEffectOnCharacter(renderEntityData.entityContainer)
						elseif state == 1 and statusEffectData.__clientApplyStatusEffectOnCharacter then
							statusEffectData.__clientApplyStatusEffectOnCharacter(renderEntityData.entityContainer)
						elseif state == -1 and statusEffectData.__clientRemoveStatusEffectOnCharacter then
							statusEffectData.__clientRemoveStatusEffectOnCharacter(renderEntityData.entityContainer)
						end
					end
				end

				previousStatusEffectsV2 = currentStatusEffectsV2
			else
				for i, activeStatusEffectData in pairs(currentStatusEffectsV2) do
					local statusEffectData = statusEffectLookup[activeStatusEffectData.statusEffectType]

					if statusEffectData then
						if statusEffectData.__clientApplyStatusEffectOnCharacter then
							statusEffectData.__clientApplyStatusEffectOnCharacter(renderEntityData.entityContainer)
						end
					end
				end
				previousStatusEffectsV2 = currentStatusEffectsV2
			end
		end
	end

	if not renderEntityData.entityContainer.entity:FindFirstChild("AnimationController") then
		local animationController 	= Instance.new("AnimationController")
		animationController.Parent 	= renderEntityData.entityContainer.entity
	end

	-- ALL CODE EXECUTION MUST GO AFTER THIS! --

	populateEntityData()

	if entityManifest.entityType.Value == "monster" or entityManifest.entityType.Value == "pet" then
		if entityManifest.entityType.Value == "pet" then
			-- make pets walkthroughable
			for i, obj in pairs(renderEntityData.entityContainer.entity:GetDescendants()) do
				if obj:IsA("BasePart") then
					obj.CanCollide = false
				end
			end
		end

		populateMonsterAnimationsTable()
		cleanupCharacterDisplayUI()
		setupMonsterDisplayUI()
	elseif entityManifest.entityType.Value == "character" then
		onPlayerStatusEffectsChanged(entityManifest.statusEffects.Value)
		onPlayerCastingAbilityIdChanged(entityManifest.castingAbilityId.Value)

		cleanupMonsterDisplayUI()
		setupCharacterDisplayUI()

		table.insert(renderEntityData.connections, entityManifest.statusEffects.Changed:connect(onPlayerStatusEffectsChanged))
		table.insert(renderEntityData.connections, entityManifest.activeAbilityExecutionData.Changed:connect(onActiveAbilityExecutionData_changed))
		table.insert(renderEntityData.connections, entityManifest.castingAbilityId.Changed:connect(onPlayerCastingAbilityIdChanged))
		table.insert(renderEntityData.connections, entityManifest.appearance.Changed:connect(onCharacterAppearanceChanged))
	end

	onEntityStateChanged(entityManifest.state.Value)

	-- todo: fix
	if entityManifest:FindFirstChild("statusEffectsV2") then
		onEntityStatusEffectChanged(entityManifest.statusEffectsV2.Value)
		table.insert(renderEntityData.connections, entityManifest.statusEffectsV2.Changed:connect(onEntityStatusEffectChanged))
	end

	table.insert(renderEntityData.connections, entityManifest.state.Changed:connect(onEntityStateChanged))
	table.insert(renderEntityData.connections, entityManifest.entityType.Changed:connect(onEntityTypeChanged))
	table.insert(renderEntityData.connections, entityManifest.entityId.Changed:connect(onEntityIdChanged))
	table.insert(renderEntityData.connections, entityManifest.health.Changed:connect(onEntityHealthChanged))

	if associatePlayer == client then
		network:fire("myClientCharacterContainerChanged", renderEntityData.entityContainer)
	end
end

events:registerForEvent("playersXpGained", function(playerXpRewards)
	for playerName,xpgained in pairs(playerXpRewards) do
		local player = game.Players:FindFirstChild(playerName)
		if player then
			local xpTag = playerXpTagPairing[player]
			if xpTag and xpTag.Parent then
				spawn(function()
					local timestamp = xpTag:FindFirstChild("timestamp")
					if timestamp == nil then
						timestamp = Instance.new("NumberValue")
						timestamp.Name = "timestamp"
						timestamp.Parent = xpTag
					end
					local difference = timestamp.Value - tick()
					if difference <= 0 then
						timestamp.Value = tick() + 0.2
					else
						timestamp.Value = timestamp.Value + 0.2
						wait(difference)
					end
					local tag = xpTag.Frame.template:Clone()
					tag.Text = "+"..tostring(math.floor(xpgained)).." XP"
					tag.Parent = xpTag.Frame
					tag.TextTransparency = 1
					tag.TextStrokeTransparency = 1
					tag.Visible = true
					tween(tag, {"Position"},UDim2.new(0.5,0,0,0),2, Enum.EasingStyle.Linear)
					tween(tag, {"TextTransparency", "TextStrokeTransparency"}, {0, 0.5}, 0.3)
					delay(0.5,function()
						if tag and tag.Parent then
							tween(tag, {"TextTransparency", "TextStrokeTransparency"}, {1, 1}, 1.5)
						end
					end)
					game.Debris:AddItem(tag, 2)
				end)
			end
		end
	end
end)

local function int__updateMonsterNameTag(renderData)
	local entityContainer = renderData.entityContainer

	local nameTagPart = entityContainer:FindFirstChild("MonsterEnemyTag")
	if nameTagPart then
		local nameTag = nameTagPart:FindFirstChild("SurfaceGui")
		if nameTag then
--			local distanceAway = utilities.magnitude(entityContainer.PrimaryPart.Position - workspace.CurrentCamera.CFrame.p)

			local focus = client.Character and client.Character.PrimaryPart or workspace.CurrentCamera
			local distanceAway = utilities.magnitude(entityContainer.PrimaryPart.Position - focus.CFrame.p)
			-- bite me
			-- todo: options
			local displayDistance = 35

			local damagedByPlayer = renderData.entityManifest:FindFirstChild("damagedByPlayer") ~= nil
			if damagedByPlayer then
				displayDistance = 50
			end



			if not renderData.disableNameTagUI and distanceAway < displayDistance and not renderData.entityManifest:FindFirstChild("isStealthed") and renderData.entityManifest.entityId.Value ~= "Chicken" then
				nameTag.Enabled = true

				local position = Vector3.new(entityContainer.PrimaryPart.Position.X, entityContainer.PrimaryPart.Position.Y - (1 + entityContainer.PrimaryPart.Size.Y / 2), entityContainer.PrimaryPart.Position.Z)
				nameTagPart.CFrame = (workspace.CurrentCamera.CFrame - workspace.CurrentCamera.CFrame.p) + position


				local healthTag = entityContainer:FindFirstChild("monsterHealth")

				if not renderData.disableHealthBarUI and healthTag then

						healthTag.Enabled = damagedByPlayer
--					end
				elseif healthTag then
					healthTag.Enabled = false
				end

				local dif

				if entityContainer.PrimaryPart:FindFirstChild("monsterScale") and entityContainer.PrimaryPart.monsterScale.Value > 1.3 then
					displayDistance = displayDistance * entityContainer.PrimaryPart.monsterScale.Value -- andrew 7/25/19 changed to be scale value instead of 2
				end

				local fullDisplayCutoff = 5
				if damagedByPlayer then
					fullDisplayCutoff = 10
				end

				if distanceAway >= fullDisplayCutoff then
					dif = (distanceAway - fullDisplayCutoff) / (displayDistance - fullDisplayCutoff)

				else
					dif = 0
				end

				if nameTag:FindFirstChild("level") then
					nameTag.level.TextTransparency 					= dif
					nameTag.level.curve.ImageTransparency 			= dif
					nameTag.level.curve.shadow.ImageTransparency 	= dif
				end

				if nameTag:FindFirstChild("monster") then
					nameTag.monster.TextTransparency 				= dif
					nameTag.monster.TextStrokeTransparency 			= dif * 1.1
					nameTag.monster.curve.ImageTransparency 		= dif
					nameTag.monster.curve.shadow.ImageTransparency 	= dif

					if nameTag.nickname.Text ~= "" then
						nameTag.nickname.TextTransparency 		= dif
						nameTag.nickname.BackgroundTransparency = dif
					end
				end

				if nameTag:FindFirstChild("skull") and nameTag.skull.Visible then
					nameTag.skull.ImageTransparency = dif
				end
			else
				nameTag.Enabled = false

				local healthTag = entityContainer:FindFirstChild("monsterHealth")
				if healthTag then
					healthTag.Enabled = false
				end
			end
		end
	end
end

local currentPartyInfo
local function updatePartyInfo(partyInfo)
	currentPartyInfo = partyInfo or network:invokeServer("playerRequest_getMyPartyData")
end

local function isPlayerInParty(player)
	if currentPartyInfo then
		for i, entry in pairs(currentPartyInfo.members) do
			if entry.player == player then
				return true
			end
		end
	end
end

local function int__updateCharacterNameTag(renderEntityData)
	local entityContainer 	= renderEntityData.entityContainer
	local entityManifest 	= renderEntityData.entityManifest

	local displayRange = 35

	local nameTagPart = renderEntityData.entityContainer.PrimaryPart:FindFirstChild("PlayerTag")

	if entityManifest == nil then

		if nameTagPart then
			local nameTag = nameTagPart:FindFirstChild("SurfaceGui")
			if nameTag then
				nameTag.Enabled = false
			end
		end

		return false
	end

	local focus = workspace.CurrentCamera
	local distanceAway = utilities.magnitude(entityContainer.PrimaryPart.Position - focus.CFrame.p)

	if nameTagPart then
		local nameTag = nameTagPart:FindFirstChild("SurfaceGui")

		if nameTag then
			local nameTagColor = Color3.new(1,1,1)
			local associatePlayer = game.Players:GetPlayerFromCharacter(entityManifest.Parent)
			if not associatePlayer then return end

			local isPartyMember = isPlayerInParty(associatePlayer)
			if isPartyMember then
				displayRange = 150
			end

			if not entityManifest:FindFirstChild("isStealthed") and distanceAway < displayRange and associatePlayer ~= client then
				nameTag.Enabled = true

				local player = associatePlayer


				local healthTag = entityContainer:FindFirstChild("monsterHealth")

				if healthTag then


					if entityManifest.health.Value / entityManifest.maxHealth.Value < 1 and (not associatePlayer or (associatePlayer:FindFirstChild("isInPVP") and associatePlayer.isInPVP.Value)) then
						healthTag.Enabled = true
						healthTag.container.backgroundFill.currentHealthFill.ImageColor3 = Color3.fromRGB(77, 225, 69)
					elseif isPartyMember then
						healthTag.Enabled = true
						healthTag.container.backgroundFill.currentHealthFill.ImageColor3 = Color3.fromRGB(226, 34, 40)
					else
						healthTag.Enabled = false
					end

				end

				local fullDisplayCutoff = 20



				if isPartyMember then
					fullDisplayCutoff 		= 50
					displayRange 			= 150
					nameTagColor 			= Color3.fromRGB(100, 255, 255)
					nameTag.top.party.Visible 	= true
				elseif player:FindFirstChild("developer") then
					nameTagColor 			= Color3.fromRGB(255, 255, 128)
				else
					nameTag.top.party.Visible = false
				end

				local position = Vector3.new(entityManifest.Position.X, entityManifest.Position.Y - (1.9 + entityManifest.Size.Y / 2), entityManifest.Position.Z)

				nameTagPart.CFrame = (workspace.CurrentCamera.CFrame - workspace.CurrentCamera.CFrame.p) + position




				local dif

				if distanceAway >= fullDisplayCutoff then
					dif =  (distanceAway - fullDisplayCutoff) / (displayRange - fullDisplayCutoff)
				else
					dif = 0
				end


				nameTag.curve.ImageTransparency = dif

				if nameTag.top:FindFirstChild("level") then
					nameTag.top.level.TextTransparency = dif

					nameTag.top.level.TextColor3 = nameTagColor
				end

				if nameTag.top:FindFirstChild("player") then
					nameTag.top.player.TextTransparency = dif

					nameTag.top.player.TextColor3 = nameTagColor
				end

				if nameTag.top:FindFirstChild("class") then
					nameTag.top.class.ImageTransparency = dif

					nameTag.top.class.ImageColor3 = nameTagColor
				end

				if nameTag.bottom:FindFirstChild("guild") then
					nameTag.bottom.guild.TextTransparency = dif
					nameTag.bottom.guild.BackgroundTransparency = dif

				end

				if nameTag.top:FindFirstChild("party") then
					nameTag.top.party.image.ImageTransparency = dif

					nameTag.top.party.image.ImageColor3 = nameTagColor
				end

				if nameTag.top:FindFirstChild("input") then

					for i,object in pairs(nameTag.top.input:GetChildren()) do
						if object:IsA("ImageLabel") then
							object.ImageColor3 = nameTagColor
							object.ImageTransparency = dif
						end
					end
				end

				if nameTag.top:FindFirstChild("dev") then
					nameTag.top.dev.TextTransparency = dif

					nameTag.top.dev.TextColor3 = nameTagColor
				end
			else
				nameTag.Enabled = false



				local healthTag = entityContainer:FindFirstChild("monsterHealth")
				if healthTag then
					healthTag.Enabled = false
				end
			end
		end
	end
end

-- this function automatically hooks players
-- into the renderCharacter update stream
local function assembleCharacterRenderEntity(entityManifest)
	local associatePlayer = game.Players:GetPlayerFromCharacter(entityManifest.Parent) do
		if associatePlayer then
			if not associatePlayer:FindFirstChild("dataLoaded") then
				return
			end
		end
	end

	local appearanceData 	= httpService:JSONDecode(entityManifest.appearance.Value)
	local entityContainer 	= int__assembleRenderCharacter(entityManifest)
	entityContainer.Parent 	= entityRenderCollectionFolder

	local renderEntityData = {
		entityContainer = entityContainer;
		entityManifest 	= entityManifest;
		connections 	= {};
	}

	int__connectEntityEvents(entityManifest, renderEntityData)

	entitiesBeingRendered[entityManifest] = renderEntityData

	-- update the appearance
	int__updateRenderCharacter(entityContainer.entity, appearanceData, entityManifest)
end

local function assembleMonsterRenderEntity(entityManifest)
	local entityContainer 	= Instance.new("Model")

	local clientPlayerHitbox = entityManifest:Clone()
		clientPlayerHitbox.BrickColor 	= BrickColor.new("Hot pink")
		clientPlayerHitbox.CanCollide 	= false
		clientPlayerHitbox.Anchored 	= true
		clientPlayerHitbox.Name 		= "hitbox"

	local clientHitboxToServerHitboxReference = Instance.new("ObjectValue")
		clientHitboxToServerHitboxReference.Name 	= "clientHitboxToServerHitboxReference"
		clientHitboxToServerHitboxReference.Value 	= entityManifest
		clientHitboxToServerHitboxReference.Parent  = entityContainer

	-- clear all unnecessary parts within the hitbox
	-- we only want the part itself
	clientPlayerHitbox:ClearAllChildren()

	entityContainer.PrimaryPart = clientPlayerHitbox
	clientPlayerHitbox.Parent 	= entityContainer

	local isMonsterPet, monsterBaseStats, monsterEntityModel do
		if not entityManifest:FindFirstChild("pet") then
			isMonsterPet 		= false
			monsterBaseStats 	= monsterLookup[entityManifest.entityId.Value]
			monsterEntityModel 	= monsterLookup[entityManifest.entityId.Value].entity:Clone()
		else
			isMonsterPet 		= true
			monsterBaseStats 	= itemLookup[tonumber(entityManifest.entityId.Value)]
			monsterEntityModel 	= itemLookup[tonumber(entityManifest.entityId.Value)].entity:Clone()
		end

		if monsterEntityModel then
			if entityManifest:FindFirstChild("colorVariant") then
				for i, obj in pairs(monsterEntityModel:GetDescendants()) do
					if obj:IsA("BasePart") and obj:FindFirstChild("doNotDye") == nil then
						if obj:FindFirstChild("colorOverride") then
							local a = entityManifest.colorVariant.Value
							obj.Color = Color3.new(math.clamp(a.r,0,1),math.clamp(a.g,0,1),math.clamp(a.b,0,1))
						else
							local a = obj.Color
							local b = entityManifest.colorVariant.Value
							obj.Color = Color3.new(math.clamp(a.r*b.r,0,1), math.clamp(a.g*b.g,0,1), math.clamp(a.b*b.b,0,1))
						end

					end
				end
			end

			if entityManifest:FindFirstChild("specialName") then
				for i, obj in pairs(monsterEntityModel:GetDescendants()) do
					if obj:IsA("BasePart") and obj.Name == "variation_"..entityManifest:FindFirstChild("specialName").Value then
						obj.Transparency = 0
						obj.CanCollide   = true
					elseif obj:IsA("BasePart") and obj.Name == "variation_default" then
						obj.Transparency = 1
						obj.CanCollide   = false
					end
				end
			end

		end
	end

	if entityManifest:FindFirstChild("monsterScale") then
		utilities.scale(monsterEntityModel, entityManifest.monsterScale.Value)
	end

	local projectionWeld = Instance.new("Motor6D")
		projectionWeld.Name 	= "projectionWeld"
		projectionWeld.Part0 	= clientPlayerHitbox
		projectionWeld.Part1 	= monsterEntityModel.PrimaryPart
		projectionWeld.C0 		= CFrame.new()
		projectionWeld.C1 		= CFrame.new(0, monsterEntityModel:GetModelCFrame().Y - monsterEntityModel.PrimaryPart.CFrame.Y, 0)
		projectionWeld.Parent 	= clientPlayerHitbox

	-- set it up to render
	monsterEntityModel.Parent 	= entityContainer
	entityContainer.Parent 		= entityRenderCollectionFolder

	local renderEntityData = {
		entityContainer 	= entityContainer;
		entityManifest 		= entityManifest;
		disableHealthBarUI 	= not not entityManifest:FindFirstChild("isPassive");
		disableLevelUI 		= not not entityManifest:FindFirstChild("isPassive") or not not entityManifest:FindFirstChild("hideLevel");
		connections 		= {};
	}

	if isMonsterPet then
		renderEntityData.disableHealthBarUI = true
	end

	if entitiesBeingRendered[entityManifest] then
		dissassembleRenderEntityByManifest(entityManifest)
	end

	int__connectEntityEvents(entityManifest, renderEntityData)
	entitiesBeingRendered[entityManifest] = renderEntityData

	return entityContainer
end

local function showDamageAtPosition(damagePosition, isSecondary)
	local part
	if typeof(damagePosition) == "Instance" then
		part = damagePosition
	else
		part = Instance.new("Part")
		part.CFrame = CFrame.new(damagePosition)
		part.Size = Vector3.new(0.2,0.2,0.2)
		part.Transparency = 1
		part.Anchored = true
		part.CanCollide = false
		part.Name = "DamagePositionPart"
		part.Parent = workspace.CurrentCamera
		game.Debris:AddItem(part,3)
	end

	local hitsound = Instance.new("Sound")
	hitsound.SoundId = "rbxassetid://2065833626"
	hitsound.MaxDistance = isSecondary and 200 or 1000
	hitsound.Volume = isSecondary and 0.25 or 1.5
	hitsound.EmitterSize = isSecondary and 1 or 5
	hitsound.Parent = part
	hitsound:Play()
	game.Debris:AddItem(hitsound, 5)

	if not isSecondary then
		local hit = part:FindFirstChild("hitParticle") or assetFolder.hitParticle:Clone()
		hit.Parent = part
		hit:Emit(3)
	end
end

local function isManifestValid(manifest)
	return
		manifest.Parent
		and (manifest.Parent == workspace or manifest.Parent:IsDescendantOf(workspace))
end

local function updateEntitiesBeingRendered(entitiesToRender)
	for i, manifest in pairs(entitiesToRender) do
		local renderData = entitiesBeingRendered[manifest]
		if renderData and isManifestValid(manifest) and renderData.entityContainer and renderData.entityContainer.PrimaryPart then
			renderData.entityContainer.PrimaryPart.CFrame = manifest.CFrame

			-- update display stuff
			if manifest.entityType.Value == "character" then
				int__updateCharacterNameTag(renderData)

			elseif manifest.entityType.Value == "monster" or manifest.entityType.Value == "pet" then
				int__updateMonsterNameTag(renderData)
			end
		else
			dissassembleRenderEntityByManifest(manifest)
		end
	end
end

local function getManifestFromEntityContainer(entityContainer)
	for manifest, entityData in pairs(entitiesBeingRendered) do
		if entityData.entityContainer == entityContainer then
			return manifest
		end
	end

	return nil
end

local DISTANCE_TO_RENDER_IN_ENTITY = 300

local function int__updateNearbyEntities()
	animationInterface = require(script.Parent:WaitForChild("animationInterface"))

	while true do
		if configuration.getConfigurationValue("doFixShadowCloneJutsu", client) then
			for i, entityContainer in pairs(entityRenderCollectionFolder:GetChildren()) do
				local manifest = getManifestFromEntityContainer(entityContainer)

				if not manifest or not manifest:IsDescendantOf(workspace) then
					if manifest then
						entitiesBeingRendered[manifest] = nil
					end

					entityContainer:Destroy()
				end
			end
		end

		for i, player in pairs(game.Players:GetPlayers()) do
			if player.Character and player.Character.Parent ~= entityManifestCollectionFolder then
				player.Character.Parent = entityManifestCollectionFolder
			end
		end

		if client.Character and client.Character.PrimaryPart then

			local clientPosition = workspace.CurrentCamera.CFrame.Position
			local entities = utilities.getEntities()

			for _, entityManifest in pairs(entities) do
				local distanceAway = (entityManifest.Position - clientPosition).magnitude
				local alwaysRendered = (entityManifest:FindFirstChild("alwaysRendered") ~= nil)

				if alwaysRendered then
					if not entitiesBeingRendered[entityManifest] then
						assembleMonsterRenderEntity(entityManifest)
					end
				else
					if distanceAway <= DISTANCE_TO_RENDER_IN_ENTITY and not entitiesBeingRendered[entityManifest] then
						if entityManifest.entityType.Value == "character" then
							assembleCharacterRenderEntity(entityManifest)
						elseif entityManifest.entityType.Value == "monster" or entityManifest.entityType.Value == "pet" then
							assembleMonsterRenderEntity(entityManifest)
						end
					elseif distanceAway > DISTANCE_TO_RENDER_IN_ENTITY * 1.05 and entitiesBeingRendered[entityManifest] and not entitiesBeingRendered[entityManifest].isPinned then
						if entityManifest.entityType.Value == "character" then
							dissassembleRenderEntityByManifest(entityManifest)
						elseif entityManifest.entityType.Value == "monster" or entityManifest.entityType.Value == "pet" then
							dissassembleRenderEntityByManifest(entityManifest)
						end
					end
				end
			end
		end

		wait(1)
	end
end

local function getAlertColor(scale)
	local alertColor = Color3.fromRGB(255, 89, 92);
	if scale > 4.5 then
		alertColor = Color3.fromRGB(255, 64, 0);
	elseif scale >= 2.5 then
		alertColor = Color3.fromRGB(214, 19, 146);
	end
	return alertColor
end

local function updateMapColor()
	local colorCorrection = game.Lighting:FindFirstChild("giantMonsterColor")
	if colorCorrection == nil then
		colorCorrection = assetFolder.giantMonsterColor:Clone()
		colorCorrection.Parent = game.Lighting
	end
	local largestScale = 0
	for i, manifest in pairs(game.CollectionService:GetTagged("giantEnemy")) do
		if manifest:FindFirstChild("health") and manifest.health.Value > 0 then
			if manifest:FindFirstChild("monsterScale") and manifest.monsterScale.Value > largestScale then
				largestScale = manifest.monsterScale.Value
			end
		end
	end
	if largestScale >= 1.3 and game.PlaceId ~= 3303140173 then
		local color = getAlertColor(largestScale)
		local mapColor = Color3.new(math.clamp(color.r * 1.2,0,1), math.clamp(color.g * 1.2,0,1), math.clamp(color.b * 1.2,0,1))
		tween(colorCorrection,
			{"Brightness", "Contrast", "Saturation", "TintColor"},
			{0, 0.1, 0, mapColor},
			0.5
		)
	else
		-- giant enemy gone? Return to normal state
		tween(colorCorrection,
			{"Brightness", "Contrast", "Saturation", "TintColor"},
			{0, 0, 0, Color3.new(1,1,1)},
			1
		)
	end

end

local giantEnemySpawning
local lastGiantEnemyAdded


local function giantEnemyAdded(entityManifest)
	local scaleTag = entityManifest:WaitForChild("monsterScale", 60)

	if not scaleTag then
		return false
	end

	local scale = scaleTag.Value
	local alertColor = getAlertColor(scale)

	local alertText
	if scale > 4.5 then
		alertText = "SWEET MOTHER OF MUSHROOM! A COLOSSAL " .. entityManifest.Name .. " has been spotted!";
	elseif scale > 2.5 then
		alertText = "GET OUT OF HERE! A super giant " .. entityManifest.Name .. " has been spotted!";
	else
		alertText = "Run for your life! A giant " .. entityManifest.Name .. " has been spotted!";
	end
	network:fire("alert", {
		text 					= alertText;
		textColor3 				= Color3.new(0,0,0);
		backgroundColor3 		= alertColor;
		backgroundTransparency 	= 0;
		textStrokeTransparency 	= 1;
		font 					= Enum.Font.SourceSansBold;
	}, 6, "giantEnemySpawned")
	game.StarterGui:SetCore("ChatMakeSystemMessage", {
		Text 	= alertText;
		Color 	= alertColor;
		Font 	= Enum.Font.SourceSansBold;
	})

	local smoke = assetFolder.giantEnemySmoke:Clone()
	smoke.Color = ColorSequence.new(alertColor, Color3.new(0,0,0))
	smoke.Rate = 80 * scale
	smoke.Parent = entityManifest

	local beam 		= assetFolder.beam:Clone()
	beam.CFrame 	= beam.CFrame - beam.Position + entityManifest.Position
	beam.Anchored 	= true
	beam.CanCollide = false
	beam.Parent 	= workspace.CurrentCamera
	beam.Color 		= alertColor

	utilities.playSound("giantEnemyBoom", beam)

	tween(beam, {"Transparency"}, 1, 2)
	tween(beam.Mesh, {"Scale"}, Vector3.new(10000, 20, 20), 2)

	game.Debris:AddItem(beam, 3)

	if (workspace.CurrentCamera.CFrame.Position - entityManifest.Position).magnitude < 200 then
		network:invoke("cameraShake")
	end

	local colorCorrection = game.Lighting:FindFirstChild("giantMonsterColor")
	if colorCorrection == nil then
		colorCorrection = assetFolder.giantMonsterColor:Clone()
		colorCorrection.Parent = game.Lighting
	end
	lastGiantEnemyAdded = entityManifest
	giantEnemySpawning = true
	local max = math.max(alertColor.r, alertColor.g, alertColor.b)^2
	local intenseColor = Color3.new((alertColor.r ^ 3)/max,(alertColor.g ^ 3)/max ,(alertColor.b ^ 3)/max)
	tween(colorCorrection,
		{"Brightness", "Contrast", "Saturation", "TintColor"},
		{0.2, 0.8, -1, intenseColor},
		0.3
	)
	delay(0.5, function()
		if lastGiantEnemyAdded == entityManifest then
			giantEnemySpawning = false
			updateMapColor()
		end
	end)

end

game.CollectionService:GetInstanceRemovedSignal("giantEnemy"):connect(function(entityManifest)
	if not giantEnemySpawning then
		updateMapColor()
	end
end)

game.CollectionService:GetInstanceAddedSignal("giantEnemy"):connect(giantEnemyAdded)

spawn(function()
	for i, enemy in pairs(game.CollectionService:GetTagged("giantEnemy")) do
		giantEnemyAdded(enemy)
	end
end)

-- damage signal
network:connect("signal_damage", "OnClientEvent", function(entityManifest, damageInfo)

	local renderEntityData = entitiesBeingRendered[entityManifest]
	if renderEntityData then
		local associatePlayer
		if entityManifest.Parent and entityManifest.Parent:IsA("Model") then
			associatePlayer = game.Players:GetPlayerFromCharacter(entityManifest.Parent)
		end

		local isSecondary = false do
			if associatePlayer ~= client and (damageInfo.sourcePlayerId == nil or damageInfo.sourcePlayerId ~= client.UserId) then
				isSecondary = true
				if damageInfo.damage > 0 then
					network:fire("monsterDamagedAtPosition", entityManifest, true)
				end
			end
		end

		if damageInfo.sourcePlayerId == client.UserId and entityManifest:FindFirstChild("damagedByPlayer") == nil then
			local damagedTag = Instance.new("BoolValue")
			damagedTag.Name = "damagedByPlayer"
			damagedTag.Parent = entityManifest
		end

		if associatePlayer == client and damageInfo.damage > 0 then
			network:fire("monsterDamagedAtPosition", entityManifest)
		end

		local container =  renderEntityData.entityContainer
		local damageIndicator = container:FindFirstChild("damageIndicator")

		if damageIndicator == nil then
			damageIndicator = replicatedStorageAssetFolder.entities.damageIndicator:Clone()
			local thickness = math.max((container.PrimaryPart.Size.X + container.PrimaryPart.Size.Z) / 2, 3)

			damageIndicator.Size = UDim2.new(thickness, 50, 6, 75)
			damageIndicator.Parent 		= container
		end
		if not damageIndicator.Adornee then
			damageIndicator.Adornee		= container.PrimaryPart
			damageIndicator.Enabled 	= true
		end

		local template 					= damageIndicator.template:Clone()

		local offset 					= 0.5 - (math.random() - 0.5) * 0.5
		template.Text 					= tostring(math.floor(math.abs(damageInfo.damage) or 0))
		template.TextTransparency 		= 1
		template.TextStrokeTransparency = 1
		template.Position 				= UDim2.new(offset,0,0.85,0)
		template.Parent 				= damageIndicator
		game.Debris:AddItem(template, 3)


		template.Size 					= UDim2.new(0.7,0,0.1,0)
		template.Visible 				= true


		if damageInfo.damage < 0 then
			isSecondary = false
		end

		template.ZIndex = (isSecondary and 1) or 2

		local goalPosition = UDim2.new(offset, 0, 0, 0.3)
		local goalTransparency = isSecondary and 0.7 or 0
		local goalSize = UDim2.new(0.7, 0, 0.3, 0)
		local finalSize = UDim2.new(0.7,0,0.1,0)

		if isSecondary then
			local startTime = tick()
			local tweenConnection = runService.Heartbeat:connect(function(step)
				local t = (tick()-startTime)/1.5
				template.Position = UDim2.new(offset,0, 0.85 - 0.55*t ,0)
				if t > 0.5 then
					t = (t - 0.5) * 2
					template.Size = UDim2.new(0.7, 0, 0.3 - 0.2*t, 0)
					template.TextTransparency = 0.5 + t/2
					template.TextStrokeTransparency = 0.5 + t/t
				else
					t = t * 2
					template.Size = UDim2.new(0.7, 0, 0.1 + 0.2*t, 0)
					template.TextTransparency = 1 - t/2
					template.TextStrokeTransparency = 1 - t/2
				end
			end)
			delay(1.5, function()
				tweenConnection:disconnect()
				tweenConnection = nil
			end)
		else
			tween(template, {"Position"}, goalPosition, 1.5)
			tween(template, {"TextTransparency", "TextStrokeTransparency", "Size"}, {goalTransparency, goalTransparency, goalSize}, 0.75)
			delay(0.75, function()
				tween(template,{"TextTransparency","TextStrokeTransparency","Size"},{1,1,finalSize},0.75)
			end)
		end

		template.TextColor3 = Color3.fromRGB(255, 251, 117)
		template.Font 		= Enum.Font.SourceSans

		-- healing
		if damageInfo.damage < 0 then
			template.TextColor3 	= Color3.fromRGB(0, 255, 213)
			template.Font = Enum.Font.SourceSansBold
		else
			if associatePlayer == client then
				template.TextColor3 = Color3.fromRGB(204, 0, 255)

				if damageInfo.supressed then
					template.TextColor3 = Color3.fromRGB(176, 137, 200)
				end
			elseif associatePlayer and isSecondary then
				template.TextColor3 		= Color3.fromRGB(204, 0, 255)
				template.TextTransparency 	= 0.5

				if damageInfo.supressed then
					template.TextColor3 = Color3.fromRGB(176, 137, 200)
				end
			else
				if damageInfo.isCritical then
					template.TextColor3 = Color3.fromRGB(255, 175, 83)
				end

				if damageInfo.supressed then
					template.TextColor3 = Color3.fromRGB(150, 150, 150)
				end
			end

			if damageInfo.isCritical then
				template.Font = Enum.Font.SourceSansBold
			end
		end

	end
end)

local function onEntityManifestCollectionFolderChildAdded(entityManifest)
	--assuming Damiens up to some mischief in here for monster rework

	--[[
	if entityManifest:FindFirstChild("monsterScale") then
		giantEnemyAdded(entityManifest)
	else
		utilities.connectEventHelper(entityManifest.ChildAdded, function(child)
			if child.Name == "monsterScale" and child.Value > 1.3 then
				giantEnemyAdded(entityManifest)
				return true
			end
		end)
	end
	]]
end

local function int__replicateAnimationFromPlayer(player, animationSequenceName, animationName, extraData)
	local entityManifest = player.Character and player.Character.PrimaryPart

	if entitiesBeingRendered[entityManifest] then
		entitiesBeingRendered[entityManifest]:playAnimation(animationSequenceName, animationName, extraData)
	end
end

local function onPlayerAppliedScroll(serverPlayer, scrollItemId, successfullyApplied)
	if not serverPlayer or not serverPlayer.Character or not serverPlayer.Character.PrimaryPart then return end

	local realItem = itemLookup[scrollItemId]
	local clientCharacterContainer = entitiesBeingRendered[serverPlayer.Character.PrimaryPart] and entitiesBeingRendered[serverPlayer.Character.PrimaryPart].entityContainer
	if clientCharacterContainer then
		if realItem and realItem.module then
			local manifest = realItem.module:FindFirstChild("manifest")
			if manifest then
				if manifest:IsA("MeshPart") then
					local representation = manifest:Clone()

					representation.Transparency = 1
					representation.CanCollide = false
					representation.Anchored = false
					representation.Name = "scrollUseRepresentation"

					local originalSize = representation.Size

					representation.Parent = workspace.CurrentCamera
					representation.Size = originalSize / 10
					tween(representation,{"Size","Transparency"},{originalSize, 0},0.3)

					local positionOffset = Instance.new("Vector3Value")
					positionOffset.Value = Vector3.new(0,3,0)

					local function render()
						if representation then
							if clientCharacterContainer and clientCharacterContainer.PrimaryPart then
								representation.CFrame = CFrame.new(clientCharacterContainer.PrimaryPart.Position + positionOffset.Value)
							else
								representation:Destroy()
							end
						end
					end

					local connection
					if serverPlayer == game.Players.LocalPlayer then
						connection = runService.RenderStepped:connect(render)
					else
						connection = runService.Heartbeat:connect(render)
					end

					tween(positionOffset,{"Value"},Vector3.new(0,5,0),0.3)

					if representation then
						if successfullyApplied then
							utilities.playSound("scrollSuccess", representation)
						else
							utilities.playSound("scrollFail", representation)
						end
					end


					wait(0.5)

					if successfullyApplied then

						local sparkles = assetFolder.scrollSuccess.Sparkles:Clone()
						sparkles.Enabled = false
						sparkles.Parent = representation
						sparkles:Emit(30)

						local rayHolder = assetFolder.scrollSuccess.Attachment:Clone()
						rayHolder.Parent = representation

						wait(0.1)

						tween(positionOffset,{"Value"},Vector3.new(0,5,0),0.7,nil,Enum.EasingDirection.In)
						tween(representation,{"Transparency"},1,0.7)

						wait(3)
					else


						wait(0.1)

						local explode = Instance.new("Explosion")
						explode.DestroyJointRadiusPercent = 0
						explode.Parent = workspace
						explode.Position = representation.Position
						connection:disconnect()
						representation.Anchored = false
						representation.CanCollide = true
						representation.Velocity = Vector3.new(math.random(-100,100),math.random(-100,100),math.random(-100,100))
						wait(3)
					end
					pcall(function()
						connection:disconnect()
						connection = nil
					end)
					if representation then
						representation:Destroy()
					end
				end
			end
		end
	end
end


local function main()
	print("__________________ENTITYRENDERER______________________")
	network:create("getMyClientCharacterContainer", "BindableFunction", "OnInvoke", function()
		-- wait for character!
--		while not myClientPlayerCharacterContainer do wait(0.1) end
--
--		return myClientPlayerCharacterContainer
		while not client.Character or not client.Character.PrimaryPart or not entitiesBeingRendered[client.Character.PrimaryPart] do
			wait(0.1)
		end

		return entitiesBeingRendered[client.Character.PrimaryPart].entityContainer
	end)

	--run manager connections
	item_manager.createNetworkConnections(client,entitiesBeingRendered)


	network:connect("playerAppliedScroll", "OnClientEvent", onPlayerAppliedScroll)
	network:create("myClientCharacterContainerChanged", "BindableEvent")

	-- todo: convert all manifestContainer calls to just manifest!
	network:create("createRenderCharacterContainerFromCharacterAppearanceData", "BindableFunction", "OnInvoke", function(manifestContainer, appearanceData)
		local renderCharacterContainer = int__assembleRenderCharacter(manifestContainer.PrimaryPart)
		int__updateRenderCharacter(renderCharacterContainer.entity, appearanceData)

		return renderCharacterContainer
	end)

	network:create("createRenderMonsterContainer", "BindableFunction", "OnInvoke", function(entityManifest)
		local renderMonsterContainer = assembleMonsterRenderEntity(entityManifest)

		return renderMonsterContainer
	end)

	-- todo: convert all manifestContainer calls to just manifest!
	network:create("applyCharacterAppearanceToRenderCharacter", "BindableFunction", "OnInvoke", function(entity, appearanceData)
		int__updateRenderCharacter(entity, appearanceData)
	end)

	network:create("myClientCharacterDied", "BindableEvent")

	network:create("myClientCharacterWeaponChanged", "BindableEvent")

	network:create("assembleEntityByManifest", "BindableFunction", "OnInvoke", function(entityManifest)
		if entityManifest.entityType.Value == "character" then
			return assembleCharacterRenderEntity(entityManifest)
		elseif entityManifest.entityType.Value == "monster" or entityManifest.entityType.Value == "pet" then
			return assembleMonsterRenderEntity(entityManifest)
		end
	end)

	network:create("setStopRenderingPlayers", "BindableFunction", "OnInvoke", function() end)
	network:create("monsterDamagedAtPosition", "BindableEvent", "Event", showDamageAtPosition)

	network:create("getRenderCharacterContainerByEntityManifest", "BindableFunction", "OnInvoke", function(entityManifest)
		if entityManifest and entitiesBeingRendered[entityManifest] then
			return entitiesBeingRendered[entityManifest].entityContainer
		end
	end)

	network:create("getPlayerRenderDataByNameTag", "BindableFunction", "OnInvoke", function(player, nameTag)
		local entityManifest = player.Character and player.Character.PrimaryPart

		if entityManifest and entitiesBeingRendered[entityManifest] then
			return entitiesBeingRendered[entityManifest][nameTag]
		end
	end)

	network:create("getEntityManifestByRenderEntityContainer", "BindableFunction", "OnInvoke", function(renderEntityContainer)
		for entityManifest, v in pairs(entitiesBeingRendered) do
			if renderEntityContainer == v.entityContainer then
				return entityManifest
			end
		end

		return nil
	end)

	network:create("setRenderDataByNameTag", "BindableFunction", "OnInvoke", function(entityManifest, nameTag, value)
		if entityManifest and entitiesBeingRendered[entityManifest] then
			entitiesBeingRendered[entityManifest][nameTag] = value
		end
	end)

	network:create("getRenderDataByNameTag", "BindableFunction", "OnInvoke", function(entityManifest, nameTag)
		if entityManifest and entitiesBeingRendered[entityManifest] then
			return entitiesBeingRendered[entityManifest][nameTag]
		end

		return nil
	end)

	network:connect("replicatePlayerAnimationSequence", "OnClientEvent", function(player, ...)
		int__replicateAnimationFromPlayer(player, ...)
	end)

	network:create("playPlayerAnimationSequenceOnClientCharacter", "BindableEvent", "Event", function(...)
		int__replicateAnimationFromPlayer(client, ...)
	end)

	network:create("getPlayerRenderStateByPlayerName","BindableFunction","OnInvoke",function(playerName)
		return "not added"
	end)

	network:create("getPlayerRenderFromPlayerInstance", "BindableFunction", "OnInvoke", function(playerInstance)
		return error("NOT YET IMPLEMENTED")
	end)

	network:create("getPlayerRenderFromManifest", "BindableFunction", "OnInvoke", function(playerCharacterManifest)
		local data = entitiesBeingRendered[playerCharacterManifest]
		if data then
			return data.entityContainer
		end
	end)

	-- todo: replication
	network:create("replicateClientCharacterWeaponStateChanged", "BindableEvent", "Event", function(weaponType, weaponState)
		local entityManifest = client.Character and client.Character.PrimaryPart

		if entityManifest and entitiesBeingRendered[entityManifest] then
			return entitiesBeingRendered[entityManifest]:setWeaponState(weaponType, weaponState)
		end
	end)

	network:connect("signal_myPartyDataChanged", "OnClientEvent", updatePartyInfo)

	network:create("getMovementAnimationForCharacter", "BindableFunction", "OnInvoke", function(animationController, state, weaponTypeEquipped, weaponState)
		local animation = state

		if not animationInterface then
			animationInterface = require(script.Parent:WaitForChild("animationInterface"))
		end

		if weaponTypeEquipped and animationInterface.rawAnimationData.movementAnimations[animation .. "_" .. weaponTypeEquipped] then
			animation = animation .. "_" .. weaponTypeEquipped

			if weaponState and animationInterface.rawAnimationData.movementAnimations[animation .. "_" .. weaponState] then
				animation = animation .. "_" .. weaponState
			end
		end

		return animationInterface.getSingleAnimation(animationController, "movementAnimations", animation)
	end)

	local priorityCount = 30
	local priorityDistance = 50

	local deferredEntities = {}
	local priorityEntities = {}

	runService:BindToRenderStep("updateEntityRendering", 50, function()
		deferredEntities = {}
		priorityEntities = {}
		local n = 0
		local player = game.Players.LocalPlayer
		local playerPosition = player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.Position
		for manifest, renderData in pairs(entitiesBeingRendered) do
			if n <= priorityCount and (manifest.Position - playerPosition).magnitude <= priorityDistance then
				table.insert(priorityEntities, manifest)
			else
				table.insert(deferredEntities, manifest)
			end
		end
		updateEntitiesBeingRendered(priorityEntities)
	end)

	runService.Heartbeat:connect(function()
		updateEntitiesBeingRendered(deferredEntities)
	end)




--	-- giant message stuff
	entityManifestCollectionFolder.ChildAdded:connect(onEntityManifestCollectionFolderChildAdded)

	-- initialize parties
	updatePartyInfo()

	-- initialize updates
	spawn(int__updateNearbyEntities)
end

main()

return module