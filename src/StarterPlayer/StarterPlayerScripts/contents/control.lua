-- Authors: Polymorphic, berezaa

local module = {}
local player = game.Players.LocalPlayer
local starterPlayer = game:GetService("StarterPlayer")

local DISTANCE_AWAY_THRESHOLD 				= 50
local MANIFEST_ORIENTATION_ASSIST_TIME_BASE = 0.5
local MANIFEST_ORIENTATION_ASSIST_TIME 		= MANIFEST_ORIENTATION_ASSIST_TIME_BASE
local CAMERA_RAYCAST_LENGTH 				= math.floor(starterPlayer.CameraMaxZoomDistance * 1.25)

local assetFolder = script.Parent.Parent:WaitForChild("assets")

local closestManifest
local currentEquipType

local playerMovementSpeed = 16

local total_statistics = {}


local UserInputService = game:GetService("UserInputService")

local placeSetup
local network
local client_utilities
local tween
local utilities
local terrainUtil
local damage


local isMenuInFocus
local function signal_menuFocusChanged(value)
	isMenuInFocus = value
end


local entityRenderCollectionFolder
local entityManifestCollectionFolder

local IGNORE_LIST
local userInputService = game:GetService("UserInputService")
local camera = workspace.Camera
local myClientCharacterContainer

local isPlayerJumpEnabled = true
local isPlayerSprintingEnabled = true
local IS_PLAYER_CAMERA_LOCKED = false
local playerWalkspeedMultiplier = 1
local isPlayerChanneling = false

local basicAttacking = false

local function onPlayerStatisticsChanged(base, tot)
	total_statistics = tot
	playerMovementSpeed = total_statistics.walkspeed or 14
end

-- todo: fix
local animationInterface

local itemLookup 	= require(game.ReplicatedStorage.itemData)

local function getServerHitboxFromClientHitbox(clientHitbox)
	if clientHitbox.Parent:FindFirstChild("clientHitboxToServerHitboxReference") then
		return clientHitbox.Parent.clientHitboxToServerHitboxReference.Value
	end
end

-- my only purpose is to make you walk slower while UserInputServiceng a bow :D
local function onSetIsChanneling(isChanneling)
	isPlayerChanneling = isChanneling

	spawn(function()
		if isChanneling then
			for i = 1, 0.5, -1 / 30 do
				-- break if channeling status changes
				if not isPlayerChanneling then break end
				playerWalkspeedMultiplier = i

				wait()
			end

			playerWalkspeedMultiplier = 0.5
		else
			for i = 0.5, 1, 1 / 30 do
				-- break if channeling status changes
				if isPlayerChanneling then break end
				playerWalkspeedMultiplier = i

				wait()
			end

			playerWalkspeedMultiplier = 1
		end
	end)
end

local tweenService 	= game:GetService("TweenService")
local TWEEN_INFO 	= TweenInfo.new(1 / 3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

local sprintFOV 	= Instance.new("NumberValue")
sprintFOV.Name 		= "sprintFOV"
sprintFOV.Parent 	= script

local LAST_UPDATE_TIME 	= 0
local UPDATE_TIME 		= 0.3

local manifestTargetLocked

local isPlayerSprinting = false

local isForward 	= false
local isBackward 	= false
local isLeftward 	= false
local isRightward 	= false

local isCastingSpell = false

local characterArrested = false

local states = {}
	states.isSprinting 		= false
	states.isInAir 			= false
	states.isMoving 		= false
	states.isJumping 		= false
	states.isSitting 		= false
	states.isExhausted 		= false
	states.isDoubleJumping 	= false
	states.isFalling 		= false
	states.isRotating 		= false
	states.isFishing 		= false
	states.isGettingUp 		= false
	states.isSwimming 		= false

-- ask damien if you need to know how status effects work now, this aint it chief
local function doesCharacterHaveStatusEffect(statusEffectType, sourceId, sourceVariant)
	local char = player.Character
	if not char then return false end
	local manifest = char.PrimaryPart
	if not manifest then return false end
	local statusEffects = manifest:FindFirstChild("statusEffectsV2")
	if not statusEffects then return false end
	local decodeSuccessful, statuses = utilities.safeJSONDecode(statusEffects.Value)
	if not decodeSuccessful then return false end

	for _, status in pairs(statuses) do
		if status.statusEffectType == statusEffectType then
			if (sourceId == nil or status.sourceId == sourceId) and (sourceVariant == nil or status.variant == sourceVariant) then
				return true
			end
		end
	end

	return false
end


local function isCharacterStunned()
	return doesCharacterHaveStatusEffect("stunned")
end

local function begin_sprint()
	network:invoke("setCharacterMovementState", "isSprinting", true)
end

local function end_sprint()
	network:invoke("setCharacterMovementState", "isSprinting", false)
end

-- performs state checks and changes the sprinting state, will correct invalid state
local function set_sprinting(val)
	if not characterArrested then
		if isPlayerSprintingEnabled and val then
			begin_sprint()
		else
			end_sprint()
		end
	else
		end_sprint()
	end
end

local tau = 2 * math.pi
local function convertXBoxMovementToAngle(x, y)
    return (math.atan2(y, x) - math.pi / 2) % tau
end

local movementUnitVector

local mobileMovementDirection

local function mobileMovementDirectionChanged(direction)
	mobileMovementDirection = direction
end

-- youre gonna need to live with this
local function getMovementAngle()
	local movementAngle

	if isForward and (((isRightward and isLeftward) and not isBackward) or not (isBackward or isRightward or isLeftward)) then
		movementAngle = 0
	elseif isForward and isRightward and not (isBackward or isLeftward) then
		movementAngle = math.pi / 4
	elseif isRightward and (((isForward and isBackward) and not isLeftward) or not (isForward or isBackward or isLeftward)) then
		movementAngle = math.pi / 2
	elseif isBackward and isRightward and not (isForward or isLeftward) then
		movementAngle = 3 * math.pi / 4
	elseif isBackward and (((isRightward and isLeftward) and not isForward) or not (isForward or isLeftward or isRightward)) then
		movementAngle = math.pi
	elseif isBackward and isLeftward and not (isRightward or isForward) then
		movementAngle = 5 * math.pi / 4
	elseif isLeftward and (((isForward and isBackward) and not isRightward) or not (isRightward or isForward or isBackward)) then
		movementAngle = 3 * math.pi / 2
	elseif isLeftward and isForward and not (isRightward or isBackward) then
		movementAngle = 7 * math.pi / 4
	end

	if mobileMovementDirection then
		if mobileMovementDirection.magnitude > 0.1 then
			movementUnitVector = mobileMovementDirection
		else
			movementUnitVector = nil
			return nil
		end
		return convertXBoxMovementToAngle(mobileMovementDirection.X, -mobileMovementDirection.Y)
	end

	if movementAngle then
		movementUnitVector = nil
		return movementAngle
	end

	local state = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)
	if state then
		for index, input in pairs(state) do
			if input.KeyCode == Enum.KeyCode.Thumbstick1 then
				if input.Position.magnitude > 0.2 and not game.GuiService.SelectedObject then
					movementUnitVector = input.Position
				else
					if states.isSprinting then
						set_sprinting(false)
					end
					movementUnitVector = nil
					return nil
				end
				return convertXBoxMovementToAngle(input.Position.X, input.Position.Y)
			end
		end
	end

	movementUnitVector = nil

	return movementAngle
end

local function isOnScreen(position)
	return
		position.X >= 0 and position.X <= workspace.CurrentCamera.ViewportSize.X
		and position.Y >= 0 and position.Y <= workspace.CurrentCamera.ViewportSize.Y
		and position.Z > 0
end

local targetsList = {}
local targetIndex = 1
local manifestCurrentlyTargetted
local manifestCurrentlyTargetted_distanceAway

local function updateTargetsList()
	local characterHitbox = player.Character and player.Character.PrimaryPart
	if not characterHitbox then return end

	if tick() - LAST_UPDATE_TIME >= UPDATE_TIME then
		LAST_UPDATE_TIME = tick()

		local new__targetsList = {}

		local hitPart, hitPosition = client_utilities.raycastFromCurrentScreenPoint({entityRenderCollectionFolder})

		if hitPart then
			local hitPlayer, hitMonster do
				local canDoDamage, trueHitPart = damage.canPlayerDamageTarget(player, hitPart)
				if canDoDamage and trueHitPart then
					if trueHitPart.entityId.Value == "character" then
						hitPlayer = game.Players:GetPlayerFromCharacter(trueHitPart.Parent)
					elseif trueHitPart.entityId.Value == "monster" then
						hitMonster = trueHitPart
					end
				end
			end

			if
				hitMonster and
				not hitMonster:FindFirstChild("pet") and
				not hitMonster:FindFirstChild("isStealthed")
			then
				local distanceAway = (hitMonster.Position - characterHitbox.Position).magnitude
				if distanceAway <= DISTANCE_AWAY_THRESHOLD then
					manifestCurrentlyTargetted 				= hitMonster
					manifestCurrentlyTargetted_distanceAway = distanceAway

					-- short circuit
					return manifestCurrentlyTargetted, manifestCurrentlyTargetted_distanceAway
				end
			end
		end

		local nearestMonsterManifest, distanceAway = nil, DISTANCE_AWAY_THRESHOLD
		local damagableTargets = damage.getDamagableTargets(game.Players.LocalPlayer)
		for i, manifest in pairs(damagableTargets) do
			local isStealthed = manifest:FindFirstChild("isStealthed") ~= nil
			if not isStealthed then
				local _distanceAway = utilities.magnitude(manifest.Position - characterHitbox.Position)

				if distanceAway > _distanceAway then
					local position, isInFrontNearClipping = camera:WorldToScreenPoint(manifest.Position)
					if position.Z > 0 and isOnScreen(position) and manifest.health.Value > 0 then
						nearestMonsterManifest 	= manifest
						distanceAway 			= _distanceAway
					end
				end
			end
		end

		manifestCurrentlyTargetted 				= nearestMonsterManifest
		manifestCurrentlyTargetted_distanceAway = distanceAway
	end

	return manifestCurrentlyTargetted, manifestCurrentlyTargetted_distanceAway
end

local function cycleThroughTargetsList(cycleBackwardsNotForwards)
	if #targetsList > 1 then
		if cycleBackwardsNotForwards then
			if targetIndex == 1 then
				targetIndex = #targetsList
			else
				targetIndex = targetIndex - 1
			end
		else
			targetIndex = ((targetIndex + 1) % #targetsList) + 1
		end
	else
		targetIndex = 1
	end

	manifestCurrentlyTargetted 				= targetsList[targetIndex] and targetsList[targetIndex].manifest
	manifestCurrentlyTargetted_distanceAway = targetsList[targetIndex] and targetsList[targetIndex].distanceAway
end

local renderStepped_connection
local function onCharacterAdded(character)
	-- reset states --
	states.isSprinting 		= false
	states.isInAir 			= false
	states.isMoving 		= false
	states.isJumping 		= false
	states.isSitting 		= false
	states.isExhausted 		= false
	states.isDoubleJumping 	= false
	states.isFishing 		= false
	states.isRotating 		= false
	states.isFalling 		= false
	states.isGettingUp 		= false
	states.isSwimming 		= false

	onSetIsChanneling(false)

	myClientCharacterContainer = network:invoke("getMyClientCharacterContainer")

	if character.PrimaryPart == nil and character:FindFirstChild("hitbox") then
		character.PrimaryPart = character.hitbox
	end

	local startTime = tick()

	repeat wait() until character.PrimaryPart or character.Parent == nil or tick() - startTime >= 10

	if not character.PrimaryPart then
		return false
	end

	network:fireServer("replicateClientStateChanged", character.PrimaryPart.state.Value)
end


local startSprintTime = 0
local isPlayerSprintingAnimationPlaying = false

local function startSprinting_animations(onlyStopAnimation)
	--if states.isExhausted then return end
	if isPlayerSprintingAnimationPlaying then return end

	network:fire("stopChannels", "sprint")

	isPlayerSprintingAnimationPlaying = true
	tween(sprintFOV,{"Value"},15,0.5)
	--cameraSprinting:Play()

	if not states.isInAir and myClientCharacterContainer and myClientCharacterContainer:FindFirstChild("entity") then
		myClientCharacterContainer.entity.RightFoot.ParticleEmitter.Enabled = true
		myClientCharacterContainer.entity.LeftFoot.ParticleEmitter.Enabled 	= true
	end

	startSprintTime = tick()
end

local function stopSprinting_animations()
	--if not isPlayerSprintingAnimationPlaying then return end

	isPlayerSprintingAnimationPlaying = false
	tween(sprintFOV,{"Value"},0,0.5)
	--cameraWalking:Play()

	if myClientCharacterContainer and myClientCharacterContainer:FindFirstChild("entity") then
		myClientCharacterContainer.entity.RightFoot.ParticleEmitter.Enabled = false
		myClientCharacterContainer.entity.LeftFoot.ParticleEmitter.Enabled 	= false
	end
end

local renderUpdateConnection
local runService 				= game:GetService("RunService")
local mouseMovementInputObject 	= nil



local function raycastFromScreenPosition(screenPositionX, screenPositionY)
	local characterHitbox = player.Character and player.Character.PrimaryPart

	if characterHitbox then
		local cameraRay = workspace.CurrentCamera:ScreenPointToRay(screenPositionX, screenPositionY)

		local ray = Ray.new(cameraRay.Origin, cameraRay.Direction.unit * CAMERA_RAYCAST_LENGTH)
		local hitPart, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, IGNORE_LIST)

		return hitPart, hitPosition, (hitPart and utilities.magnitude(hitPart.Position - characterHitbox.Position) or nil)
	end
end

local curEmote = ""
local isPlayerEmoting = false

local emoteCooldown = false

local defaultEmotes = {
	["dance"]    = true;
	["dance2"]   = true;
	["dance3"]   = true;
	["oh yea"]   = true;
	["hype"]     = true;
	["sit"]      = true;
	["wave"]     = true;
	["point"]    = true;
	["beg"]      = true;
	["flex"]     = true;
	["handstand"]  = true;
	["tadaa"]     = true;
	["jumps"]   = true;
	["guitar"]   = true;
	["panic"]   = true;
	["cheer"]   = true;
	["pushups"]   = true;
}

local function performEmote(emote)


	if states.isSprinting or states.isInAir or	states.isMoving or	states.isJumping or	states.isSitting or	states.isExhausted or states.isDoubleJumping or states.isFalling or states.isFishing or states.isGettingUp or states.isSwimming then
		return false
	end



	local lastEmotesReceived = network:invoke("getCacheValueByNameTag", "globalData").emotes
	local found = false
	emote = string.lower(emote)
	for i, ownedEmote in pairs(lastEmotesReceived) do
		if emote == ownedEmote then
			found = true
		end
	end


	if defaultEmotes[emote] then found = true end

	if found and not emoteCooldown then

		if curEmote ~= emote then
			curEmote = emote
			isPlayerEmoting = true

			spawn(function()
				emoteCooldown = true
				wait(1)
				emoteCooldown = false
			end)
			player.Character.PrimaryPart.state.Value = "idling"
			network:fireServer("replicateClientStateChanged", "idling")

			animationInterface:replicatePlayerAnimationSequence("emoteAnimations", emote, nil, {dance = true}) -- add security check on the remote, serverside when players can buy emotes
			return true
		end

		--return false, "Cannot perform emote while moving."


	else
		if emoteCooldown then
			return false, "Emote on cooldown."
		end
		return false, "Cannot perform invalid emote."
	end


end


function module.endEmote()
	if isPlayerEmoting then
		curEmote = ""
		isPlayerEmoting = false
	end
end


-- this is all crappy bad code but you cant burn it all down because you need it so figure out how to
-- use it in a way that isnt crappy bad code thank you good luck have fun we're praying for your
-- safe return
local function setCharacterMovementState(state, value, ...)
	--if state and state ~= "isMoving" then
	--	isPlayerEmoting = false
	--	curEmote = ""
	--end
	--isPlayerEmoting = false
	--curEmote = ""

	if states[state] ~= nil and states[state] ~= value and player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.state.Value ~= "dead" then
		isPlayerEmoting = false
		curEmote = ""

		if state == "isSprinting" and not network:invoke("getIsCurrentlyConsuming") and not states.isExhausted then
			if states.isMoving then
				if not states[state] and value then
					-- turning on
					startSprinting_animations()

				elseif states[state] and not value then
					-- turning off
					stopSprinting_animations()
				end
			else
				-- still play exhaust if they stop moving
				-- while sprinting then stop sprinting
				if states[state] and not value then
					stopSprinting_animations()
				end
			end
		elseif state == "isSprinting" and (network:invoke("getIsCurrentlyConsuming") or states.isExhausted) then
			return
		elseif state == "isMoving" and not states.isExhausted then

			if states.isSprinting and not isPlayerSprintingAnimationPlaying then
				startSprinting_animations(true)
			elseif not states.isSprinting and isPlayerSprintingAnimationPlaying then
				stopSprinting_animations(true)
			end
		elseif state == "isGettingUp" then
			if states.isSprinting then
				states.isSprinting = false

				stopSprinting_animations(true)
			end




		end

		states[state] = value


		if player.Character and player.Character.PrimaryPart then
			if not states.isGettingUp then
				if not states.isSwimming then
					if not states.isFishing then

							if not states.isSitting then
								if not states.isFalling then
									if not states.isJumping then

										if states.isMoving or states.isRotating then


											if states.isSprinting and not characterArrested then
												-- pray this doesnt cause race condition issues
												if player.Character.PrimaryPart.state.Value ~= "sprinting" then
													network:fireServer("replicateClientStateChanged", "sprinting")
												end
												player.Character.PrimaryPart.state.Value = "sprinting"

											else
												if states.isExhausted then
													player.Character.PrimaryPart.state.Value = "walking_exhausted"
													network:fireServer("replicateClientStateChanged", "walking_exhausted")
												else
													-- pray  here too
													if player.Character.PrimaryPart.state.Value ~= "walking" then
														network:fireServer("replicateClientStateChanged", "walking")
													end
													player.Character.PrimaryPart.state.Value = "walking"
												end
											end
										else
											if states.isExhausted then
												player.Character.PrimaryPart.state.Value = "idling_exhausted"
												network:fireServer("replicateClientStateChanged", "idling_exhausted")
											else
												player.Character.PrimaryPart.state.Value = "idling"


												network:fireServer("replicateClientStateChanged", "idling", "kicking")
											end
										end

								else
									if not states.isDoubleJumping then
										player.Character.PrimaryPart.state.Value = "jumping"
										network:fireServer("replicateClientStateChanged", "jumping")
									else
										player.Character.PrimaryPart.state.Value = "double_jumping"
										network:fireServer("replicateClientStateChanged", "double_jumping")
									end
								end
							else
								player.Character.PrimaryPart.state.Value = "falling"
								network:fireServer("replicateClientStateChanged", "falling")
							end
						else
							player.Character.PrimaryPart.state.Value = "sitting"
							network:fireServer("replicateClientStateChanged", "sitting", nil, ...)
						end

					else
						player.Character.PrimaryPart.state.Value = "fishing"
						network:fireServer("replicateClientStateChanged", "fishing")
					end
				else
					player.Character.PrimaryPart.state.Value = "swimming"
					network:fireServer("replicateClientStateChanged", "swimming")
				end
			else
				player.Character.PrimaryPart.state.Value = "gettingUp"
				network:fireServer("replicateClientStateChanged", "gettingUp", nil, ...)
			end
		end

		network:fire("characterStateChanged", state, value, ...)
		return true
	end
end

local MAX_CONE_ANGLE_DIFF = math.rad(20)
local function isMouseInMovementCone(movementDirection, mouseDirection, movementAngle)
	local dotProduct 	= movementDirection:Dot(mouseDirection)
	local angleDiff 	= math.acos(dotProduct)

	return angleDiff <= MAX_CONE_ANGLE_DIFF, dotProduct < 0, angleDiff, math.sign(movementDirection:Cross(mouseDirection):Dot(Vector3.new(0, 1, 0)))
end

local wind = assetFolder.wind
local windBaseVolume = game.ReplicatedStorage:FindFirstChild("windVolume") and game.ReplicatedStorage.windVolume.Value or 0.02
wind.Volume = windBaseVolume
wind:Play()

local baseFriction = 500
local friction = baseFriction -- change friction based on individual parts

local externalVelocity = Vector3.new()
local movementVelocity = Vector3.new()

local overrideCharacterCFrame



-- stops all movement, state changes, etc
local function setCharacterArrested(arrested, arrestedCFrame)
	if arrested then
		characterArrested 	= true
		movementVelocity 	= Vector3.new()

		if states.isSprinting then
			stopSprinting_animations(true)
		end

		setCharacterMovementState("isMoving", false)
		setCharacterMovementState("isSprinting", false)
		setCharacterMovementState("isSitting", false)
		setCharacterMovementState("isRotating", false)

		if arrestedCFrame then
			overrideCharacterCFrame = arrestedCFrame
			externalVelocity 	= Vector3.new()

			player.Character:SetPrimaryPartCFrame(arrestedCFrame)


			local characterHitbox = player.Character and player.Character.PrimaryPart

			if characterHitbox then
				local bodyPosition 	= characterHitbox.grounder
				local bodyVelocity 	= characterHitbox.hitboxVelocity
				local bodyGyro 		= characterHitbox.hitboxGyro

				bodyPosition.MaxForce = Vector3.new(1e5, 1e5, 1e5)
				bodyVelocity.MaxForce = Vector3.new(0, 0, 0)

				bodyGyro.CFrame 		= overrideCharacterCFrame
				bodyPosition.Position 	= overrideCharacterCFrame.Position
			end
		end
	else
		characterArrested = false
		overrideCharacterCFrame = nil

		-- if shift is held when we come out of arrest we should start sprinting
		local sprintKeyCode = Enum.KeyCode.LeftShift -- later we can change this to work with keybindings
		local sprintKeyDown = userInputService:IsKeyDown(sprintKeyCode)

		if sprintKeyDown then
			set_sprinting(true)
		end
	end
end




local lastJump = 0

local totalStats

local function playerStatisticsChanged(base, total)
	totalStats = total
end



local isPlayerUnderwater
local velocityHandler

local function raycastDownIgnoreCancollideFalse(ray, ignoreList)
	local hitPart, hitPosition, hitDown, hitMaterial = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList, true)

	local items = workspace.placeFolders:FindFirstChild("items")
	-- edit: ignore water and dropped items
	while hitPart and not (hitPart.CanCollide and (not hitPart:IsDescendantOf(entityManifestCollectionFolder) or (not hitPart:FindFirstChild("entityType") or hitPart.entityType.Value ~= "pet")) and hitMaterial ~= Enum.Material.Water and (items == nil or not hitPart:IsDescendantOf(items))) do
		ignoreList[#ignoreList + 1] = hitPart
		hitPart, hitPosition, hitDown, hitMaterial = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList, true)
	end

	return hitPart, hitPosition, hitDown, hitMaterial
end

local yJumpVelocity
local lastPositionOnGround
local startPositionForFalling

local characterOrientationUpdateConnection

local function setupRenderSteppedConnection()
	local function updateCharacterOrientationFaceManifest(_,step)
		local characterHitbox = player.Character and player.Character.PrimaryPart

		local bodyPosition 	= characterHitbox and characterHitbox:FindFirstChild("grounder")
		local bodyVelocity 	= characterHitbox and characterHitbox:FindFirstChild("hitboxVelocity")
		local bodyGyro 		= characterHitbox and characterHitbox:FindFirstChild("hitboxGyro")

		if not bodyPosition or not bodyVelocity or not bodyGyro then return end

		if overrideCharacterCFrame then
			bodyPosition.MaxForce = Vector3.new(1e5, 1e5, 1e5)
			bodyVelocity.MaxForce = Vector3.new(0, 0, 0)

			bodyGyro.CFrame = overrideCharacterCFrame
			bodyPosition.Position = overrideCharacterCFrame.Position
			return
		end

		local movementAngle = getMovementAngle()
		local hitPosition

		if mouseMovementInputObject then
			_, hitPosition = raycastFromScreenPosition(mouseMovementInputObject.Position.X, mouseMovementInputObject.Position.Y)
		end

		-- todo optimize
		local ignoreList = {
			myClientCharacterContainer,
		}
		local downRay = Ray.new(characterHitbox.Position, Vector3.new(0, -5, 0))
		local downHitPart, downHitPosition, downHitNormal, downHitMaterial = raycastDownIgnoreCancollideFalse(downRay, ignoreList)

		local height = 2.5

		-- check in front of the player
		if utilities.magnitude(movementVelocity) > 0.1 then
			local moving 							= movementVelocity.Unit
			local frontRay 							= Ray.new(characterHitbox.Position, Vector3.new(moving.X, -height, moving.Z))
			local frontHitPart, frontHitPosition 	= raycastDownIgnoreCancollideFalse(frontRay, ignoreList)

			if frontHitPart then
				local frontHitHeight = frontHitPosition.Y - (characterHitbox.Position.Y - height)
				if frontHitHeight > 0 and frontHitHeight < height then
					height = height + frontHitHeight * 12
				end
			end

		end
		local function land()
			bodyPosition.MaxForce = Vector3.new(0, 1e4, 0)
			bodyVelocity.MaxForce = Vector3.new(1e4, 0, 1e4)

			states.isInAir = false

			local yVelocityOnImpact = 0

			if states.isJumping then
				setCharacterMovementState("isJumping", false)
				setCharacterMovementState("isDoubleJumping", false)

				if states.isFalling then
					yVelocityOnImpact = externalVelocity.Y
				end
				setCharacterMovementState("isFalling", false)
			elseif states.isFalling then
				yVelocityOnImpact = externalVelocity.Y

				setCharacterMovementState("isFalling", false)
			end

			bodyPosition.Position = downHitPosition + Vector3.new(0, height, 0)
		end

		if downHitPart then
			-- to get around floating characters, make sure active parts still trigger collision events
			if game.CollectionService:HasTag(downHitPart, "ActivePart") then
				network:fire("touchedActivePart", downHitPart, characterHitbox)
			end

			if states.isSprinting and myClientCharacterContainer and myClientCharacterContainer:FindFirstChild("entity") then
				myClientCharacterContainer.entity.RightFoot.ParticleEmitter.Enabled = true
				myClientCharacterContainer.entity.LeftFoot.ParticleEmitter.Enabled 	= true

				local color = downHitPart.Color
				if downHitPart:IsA("Terrain") and (downHitMaterial ~= Enum.Material.Air) then
					color = downHitPart:GetMaterialColor(downHitMaterial)
				end

				myClientCharacterContainer.entity.LeftFoot.ParticleEmitter.Color = ColorSequence.new(color)
				myClientCharacterContainer.entity.RightFoot.ParticleEmitter.Color = ColorSequence.new(color)
			end



			-- make players slide off of enemies
			if downHitPart:isDescendantOf(entityManifestCollectionFolder) or downHitPart:isDescendantOf(entityRenderCollectionFolder) then
				-- except other players
				local downHitRender =
					(downHitPart:FindFirstChild("clientHitboxToServerHitboxReference") and downHitPart) or
					(downHitPart.Parent:FindFirstChild("clientHitboxToServerHitboxReference") and downHitPart.Parent) or
					(downHitPart.Parent.Parent:FindFirstChild("clientHitboxToServerHitboxReference") and downHitPart.Parent.Parent) or
					(downHitPart.Parent.Parent.Parent:FindFirstChild("clientHitboxToServerHitboxReference") and downHitPart.Parent.Parent.Parent)
				local downHitEntity = downHitPart.Parent
				if downHitRender then
					downHitEntity = downHitRender.clientHitboxToServerHitboxReference.Value.Parent
				end
				if game.Players:GetPlayerFromCharacter(downHitEntity) then
					friction = baseFriction * downHitPart.Friction
					land()
				else

					friction = 0
					local dif = (characterHitbox.Position - downHitPart.Position).unit * 10
					externalVelocity = externalVelocity + Vector3.new(dif.X,0,dif.Z)
				end
			else
				friction = baseFriction * downHitPart.Friction
			end
		end

		if not isPlayerUnderwater or not states.isSwimming then
			if externalVelocity.Y > 0.1 or downHitPart == nil or (characterHitbox.Position.Y - downHitPosition.Y) > height + 1 then
				bodyVelocity.MaxForce 	= Vector3.new(1e4, 1e4, 1e4)
				bodyPosition.MaxForce 	= Vector3.new()
				states.isInAir 			= true

				if externalVelocity.Y < -30 and not states.isFalling then
					setCharacterMovementState("isFalling", true)

				end

				if not startPositionForFalling and characterHitbox.Velocity.Y < -30 and states.isFalling then
					startPositionForFalling = characterHitbox.Position
				end

				if states.isSprinting and myClientCharacterContainer and myClientCharacterContainer:FindFirstChild("entity") then
					myClientCharacterContainer.entity.RightFoot.ParticleEmitter.Enabled = false
					myClientCharacterContainer.entity.LeftFoot.ParticleEmitter.Enabled 	= false
				end
			else
				land()
			end
		else
			-- player is underwater, and swimming!
			bodyVelocity.MaxForce 	= Vector3.new(1e4, 1e4, 1e4)
			bodyPosition.MaxForce 	= Vector3.new()

			--bodyPosition.Position = downHitPosition + Vector3.new(0, height, 0)
		end

		local mouseMovementDirection = hitPosition and CFrame.new(
			characterHitbox.Position,
			Vector3.new(hitPosition.X, characterHitbox.Position.Y, hitPosition.Z)
		).lookVector

		mouseMovementDirection = mouseMovementDirection and (mouseMovementDirection - Vector3.new(0, mouseMovementDirection.Y, 0)).unit

		if isMenuInFocus then
			mouseMovementDirection = characterHitbox.CFrame.lookVector * Vector3.new(1,0,1)
		end

		-- process final move direction
		local final_direction
		if not characterArrested then
			if movementAngle then
				local movementDirection = workspace.CurrentCamera.CFrame:toWorldSpace(CFrame.Angles(0, movementAngle, 0)).lookVector
				movementDirection 		= (movementDirection - Vector3.new(0, movementDirection.Y, 0)).unit

				local baseSpeed = playerMovementSpeed
				if isPlayerSprintingAnimationPlaying then
					baseSpeed = baseSpeed * 2 + 1
				end

				local moveSpeed = baseSpeed * math.clamp(playerWalkspeedMultiplier, 0.5, 1)

				movementUnitVector 	= movementUnitVector or Vector3.new(1,0,0)
				movementVelocity 	= movementDirection * moveSpeed * movementUnitVector.magnitude

				-- update player movement
				bodyVelocity.Velocity = velocityHandler:stepCurrentVelocity(step)

				if currentEquipType ~= "bow" and not IS_PLAYER_CAMERA_LOCKED and not isCastingSpell and mouseMovementDirection then
					if not states.isSprinting then
						local isInCone, isBehind, angleDiff, sign = isMouseInMovementCone(movementDirection, mouseMovementDirection, movementAngle)
						if isInCone then
							final_direction = CFrame.new(Vector3.new(), mouseMovementDirection)
						else
							if not isBehind then
								final_direction = CFrame.Angles(0, MAX_CONE_ANGLE_DIFF * sign, 0) * CFrame.new(Vector3.new(), movementDirection)
							else
								final_direction = CFrame.new(Vector3.new(), movementDirection)
							end
						end
					else
						final_direction = CFrame.new(Vector3.new(), movementDirection)
					end
				elseif IS_PLAYER_CAMERA_LOCKED then
					final_direction = CFrame.new(Vector3.new(), camera.CFrame.lookVector * Vector3.new(1, 0, 1))
				elseif mouseMovementDirection then
					final_direction = CFrame.new(Vector3.new(), mouseMovementDirection)
				else
					final_direction = CFrame.new(Vector3.new(), movementDirection)
				end

				assetFolder.bRef.Value = bodyVelocity

				-- movement logic

				setCharacterMovementState("isMoving", true)

			else
				if IS_PLAYER_CAMERA_LOCKED then
					final_direction = CFrame.new(Vector3.new(), camera.CFrame.lookVector * Vector3.new(1, 0, 1))
				elseif mouseMovementDirection then
					final_direction = mouseMovementDirection and CFrame.new(Vector3.new(), mouseMovementDirection)
				end

				movementVelocity 		= Vector3.new()
				bodyVelocity.Velocity 	= velocityHandler:stepCurrentVelocity(step)

				-- movement logic

				setCharacterMovementState("isMoving", false)
			end
		else
			-- step even if arrested, incase we manually set it!
			bodyVelocity.Velocity = velocityHandler:stepCurrentVelocity(step)
		end

		-- update the target listing
		updateTargetsList()

		if manifestCurrentlyTargetted and currentEquipType ~= "bow" and not IS_PLAYER_CAMERA_LOCKED and not states.isSprinting and not isCastingSpell and final_direction  then

			local frac = ((manifestCurrentlyTargetted_distanceAway - 10) / (DISTANCE_AWAY_THRESHOLD - 10)) ^ 2
			local derivativeFrac = 2 * (1 / (DISTANCE_AWAY_THRESHOLD - 10)) * (manifestCurrentlyTargetted_distanceAway - 10)

			if derivativeFrac < 0 then
				frac = 0
			end

			frac = math.clamp(1 - frac, 0, 1)

			final_direction = final_direction:lerp(CFrame.new(
				characterHitbox.Position,
				Vector3.new(manifestCurrentlyTargetted.Position.X, characterHitbox.Position.Y, manifestCurrentlyTargetted.Position.Z)
			), frac)
		end



		if not characterArrested and final_direction and player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.state.Value ~= "dead" and not isPlayerEmoting   then
			if IS_PLAYER_CAMERA_LOCKED then
				bodyGyro.CFrame = final_direction
			else
				bodyGyro.CFrame = bodyGyro.CFrame:lerp(final_direction, 0.1)
			end

			local diffAngle = Vector3.new(final_direction.lookVector.X, 0, final_direction.lookVector.Z).unit:Dot(Vector3.new(characterHitbox.CFrame.lookVector.X, 0, characterHitbox.CFrame.lookVector.Z).unit)

			if math.abs(1 - diffAngle) > 0.05 then
				if not states.isRotating then
					setCharacterMovementState("isRotating", true)
				end

			else
				if states.isRotating then
					setCharacterMovementState("isRotating", false)
				end

			end

		end
	end

	if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.state.Value ~= "dead"  then
		if characterOrientationUpdateConnection then
			characterOrientationUpdateConnection:disconnect()
			characterOrientationUpdateConnection = nil
		end
		characterOrientationUpdateConnection = runService.Stepped:connect(updateCharacterOrientationFaceManifest)

	end
end

local function doesPlayerHaveAbilityUnlocked(abilityId)
	local playerAbilitiesSlotDataCollection = network:invoke("getCacheValueByNameTag", "abilities")
	if playerAbilitiesSlotDataCollection then
		for _, abilitySlotData in pairs(playerAbilitiesSlotDataCollection) do
			if abilitySlotData.id == abilityId and abilitySlotData.rank > 0 then
				return true
			end
		end
	end

	return false
end


local isJumping = false
local hasDoubleJumped = false
local function perform_forceJump(inputObject)
	if not player.Character or not player.Character.PrimaryPart then return end
	if isCharacterStunned() then return end


	if states.isJumping then
		if player.Character.PrimaryPart.state.Value ~= "dead" and not states.isExhausted and doesPlayerHaveAbilityUnlocked(7) and not states.isDoubleJumping and states.isInAir then

			if externalVelocity.Y > -60 then
				player.Character.PrimaryPart.stamina.Value = math.max(player.Character.PrimaryPart.stamina.Value - 0.5, 0)
				setCharacterMovementState("isDoubleJumping", true)
				externalVelocity = Vector3.new(externalVelocity.X, 80, externalVelocity.Z)

				network:fire("stopChannels", "jump")
				lastJump = tick()
			end
			--velocityHandler:applyJoltVelocity(Vector3.new(0, 75, 0))
		end
	else
		-- regular jump
		if player.Character.PrimaryPart.state.Value ~= "dead" and not states.isExhausted then
			player.Character.PrimaryPart.stamina.Value = math.max(player.Character.PrimaryPart.stamina.Value - 0.5, 0)
			setCharacterMovementState("isJumping", true)

			network:fire("stopChannels", "jump")

			local jumpPower = totalStats.jump
			velocityHandler:applyJoltVelocity(Vector3.new(0, jumpPower, 0))
			lastJump = tick()
		end
	end

	if isPlayerUnderwater and inputObject then
		delay(0.25, function()
			if isPlayerUnderwater and inputObject.UserInputState == Enum.UserInputState.Begin then
				-- still holding it down

				setCharacterMovementState("isSwimming", true)
				setCharacterMovementState("isSprinting", false)
				isPlayerSprintingEnabled = false

				while isPlayerUnderwater and inputObject.UserInputState == Enum.UserInputState.Begin do
					wait(0.05)
				end

				setCharacterMovementState("isSwimming", false)
				isPlayerSprintingEnabled = true
			end
		end)
	end
end

local function onInputBegan(inputObject, absorbed)

	if absorbed then
		return false
	end

	if inputObject.KeyCode == Enum.KeyCode.W or inputObject.KeyCode == Enum.KeyCode.Up then
		isForward = true
	elseif inputObject.KeyCode == Enum.KeyCode.S or inputObject.KeyCode == Enum.KeyCode.Down then
		isBackward = true
	elseif inputObject.KeyCode == Enum.KeyCode.D then
		isLeftward = true
	elseif inputObject.KeyCode == Enum.KeyCode.A then
		isRightward = true
	elseif inputObject.KeyCode == Enum.KeyCode.LeftShift or inputObject.KeyCode == Enum.KeyCode.ButtonL3 and states.isMoving then
		set_sprinting(true)
	elseif inputObject.KeyCode == Enum.KeyCode.Space or inputObject.KeyCode == Enum.KeyCode.LeftAlt or inputObject.KeyCode == Enum.KeyCode.ButtonA then
		if not characterArrested then
			if isPlayerJumpEnabled and not states.isSwimming then
				perform_forceJump(inputObject)
			end
		end
	end
end

function module.doJump()
	if not characterArrested then
		if isPlayerJumpEnabled then
			perform_forceJump()
		end
	end
end

function module.doSprint(val)
	set_sprinting(val)
end

local function signalBasicAttacking(val)
	basicAttacking = val
end


local function onInputEnded(inputObject)
	--if inputObject.UserInputType == Enum.UserInputType.Keyboard then

		if inputObject.KeyCode == Enum.KeyCode.W or inputObject.KeyCode == Enum.KeyCode.Up then
			isForward = false

		elseif inputObject.KeyCode == Enum.KeyCode.S or inputObject.KeyCode == Enum.KeyCode.Down then
			isBackward = false
		elseif inputObject.KeyCode == Enum.KeyCode.D then
			isLeftward = false
		elseif inputObject.KeyCode == Enum.KeyCode.A then
			isRightward = false
		elseif inputObject.KeyCode == Enum.KeyCode.LeftShift --[[or inputObject.KeyCode == Enum.KeyCode.ButtonL3]] then
			set_sprinting(false)
		elseif inputObject.KeyCode == Enum.KeyCode.P then
			--cycleThroughTargetsList()
		end
	--end
end

local isSetup = false
local function onInputChanged(inputObject)
	if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
		mouseMovementInputObject = inputObject
	end
end


local function onMyClientCharacterDied()
	if characterOrientationUpdateConnection then
		characterOrientationUpdateConnection:disconnect()
		characterOrientationUpdateConnection = nil
	end
--	runService:UnbindFromRenderStep("updateCharacterOrientation")
end

local function onSetCharacterMovementStateInvoke(state, value, ...)
	if states[state] == nil or states[state] == value then return end

	return setCharacterMovementState(state, value, ...)
end

local function getCurrentlyFacingManifest(updateFirst)
	if updateFirst then
		updateTargetsList()
	end
	return manifestCurrentlyTargetted
end

local function setIsCastingSpell(value)
	isCastingSpell = value
end

local function getMovementVelocity()
	return movementVelocity
end

local function getTotalVelocity()
	local bodyVelocity = player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart:FindFirstChild("hitboxVelocity")

	if bodyVelocity then
		return bodyVelocity.Velocity
	end

	return Vector3.new(0,0,0)
end

local function getCharacterMovementStates()
	return states
end

local function onSetMovementVelocity(newMovementVelocity)
	movementVelocity = newMovementVelocity
end

local function onSetIsJumpEnabled(isEnabled)
	isPlayerJumpEnabled = isEnabled
end

local function onSetIsSprintingEnabled(isEnabled)
	isPlayerSprintingEnabled = isEnabled
end

local function onPropogationRequestToSelf(nameTag, value)
	if nameTag == "equipment" then
		local weaponData do
			for i, equipmentSlotData in pairs(value) do
				if equipmentSlotData.position == 1 then
					weaponData = equipmentSlotData
				end
			end
		end

		if weaponData then
			currentEquipType = itemLookup[weaponData.id].equipmentType
		end
	end
end

local function setStamina(value, cureExhaustion)
	local char = player.Character
	if not char then return end

	local manifest = char.PrimaryPart
	if not manifest then return end

	local stamina = manifest:FindFirstChild("stamina")
	if not stamina then return end

	local maxStamina = manifest:FindFirstChild("maxStamina")
	if not maxStamina then return end

	if value == "max" then
		value = maxStamina.Value
	end

	stamina.Value = value

	if cureExhaustion then
		setCharacterMovementState("isExhausted", false)
	end
end

function module.init(Modules)

	placeSetup = Modules.placeSetup
	network = Modules.network
	client_utilities = Modules.client_utilities
	tween = Modules.tween
	utilities = Modules.utilities
	terrainUtil = Modules.terrainUtil
	damage = Modules.damage
	animationInterface = Modules.animationInterface

	IGNORE_LIST = {placeSetup.getPlaceFoldersFolder()}
	entityRenderCollectionFolder = placeSetup.awaitPlaceFolder("entityRenderCollection")
	entityManifestCollectionFolder = placeSetup.awaitPlaceFolder("entityManifestCollection")

	totalStats = network:invoke("getCacheValueByNameTag", "nonSerializeData").statistics_final

	if player.Character then
		spawn(function()
			onCharacterAdded(player.Character)
		end)
	end
	network:create("doesPlayerHaveStatusEffect", "BindableFunction", "OnInvoke", doesCharacterHaveStatusEffect)
	network:create("isCharacterStunned", "BindableFunction", "OnInvoke", isCharacterStunned)
	network:create("mobileMovementDirectionChanged", "BindableEvent", "Event", mobileMovementDirectionChanged)
	network:create("playerRequest_performEmote", "BindableFunction", "OnInvoke", performEmote)
	network:create("setCharacterArrested", "BindableFunction", "OnInvoke", setCharacterArrested)
	network:create("signal_menuFocusChanged", "BindableEvent", "Event", signal_menuFocusChanged)
	network:connect("myClientCharacterContainerChanged", "Event", function() onCharacterAdded(player.Character) end)
	network:connect("toggleCameraLockChanged", "Event", function(newValue) IS_PLAYER_CAMERA_LOCKED = newValue end)
	network:create("signalBasicAttacking", "BindableEvent", "Event", signalBasicAttacking)
	network:connect("playerStatisticsChanged", "OnClientEvent", playerStatisticsChanged)
	userInputService.InputBegan:connect(onInputBegan)
	userInputService.InputChanged:connect(onInputChanged)
	userInputService.InputEnded:connect(onInputEnded)

	network:connect("myClientCharacterDied", "Event", onMyClientCharacterDied)

	network:create("stopChannels", "BindableEvent")

	network:create("setIsChanneling", "BindableFunction", "OnInvoke", onSetIsChanneling)
	network:create("setMovementVelocity", "BindableFunction", "OnInvoke", onSetMovementVelocity)
	network:create("setIsJumpEnabled", "BindableFunction", "OnInvoke", onSetIsJumpEnabled)
	network:create("setIsSprintingEnabled", "BindableFunction", "OnInvoke", onSetIsSprintingEnabled)

	network:create("characterStateChanged", "BindableEvent")
	network:create("setCharacterMovementState", "BindableFunction", "OnInvoke", onSetCharacterMovementStateInvoke)
	network:create("forceCharacterMovementState", "RemoteEvent", "OnClientEvent", onSetCharacterMovementStateInvoke)
	network:create("getCurrentlyFacingManifest", "BindableFunction", "OnInvoke", getCurrentlyFacingManifest)
	network:create("getMovementVelocity", "BindableFunction", "OnInvoke", getMovementVelocity)
	network:create("getTotalVelocity", "BindableFunction", "OnInvoke", getTotalVelocity)
	network:create("setIsCastingSpell", "BindableFunction", "OnInvoke", setIsCastingSpell)
	network:create("getCharacterMovementStates", "BindableFunction", "OnInvoke", getCharacterMovementStates)

	network:connect("playerStatisticsChanged", "OnClientEvent", onPlayerStatisticsChanged)
	network:connect("propogationRequestToSelf", "Event", onPropogationRequestToSelf)

	network:connect("setStamina", "OnClientEvent", setStamina)

	total_statistics = network:invoke("getCacheValueByNameTag", "nonSerializeData").statistics_final

	velocityHandler = {} do
		local airResistance = 20


		function velocityHandler:applyJoltVelocity(vel)
			if isPlayerUnderwater then
				vel = vel * 0.5
			end

			externalVelocity = externalVelocity + vel
		end

		-- this is what i think of your oop damien
		local function jolt(vel)
			velocityHandler:applyJoltVelocity(vel)
		end

		network:create("applyJoltVelocityToCharacter","BindableEvent","Event",jolt)
		network:connect("deathTrapKnockback", "OnClientEvent", jolt)

		local cameraUnderwater

		local underwaterBlur = Instance.new("BlurEffect")
		underwaterBlur.Size = 4
		underwaterBlur.Enabled = false
		underwaterBlur.Parent = game.Lighting

		local underwaterCorrect = Instance.new("ColorCorrectionEffect")
		underwaterCorrect.Saturation = 0.35
		underwaterCorrect.Contrast = 0.05
		underwaterCorrect.Enabled = false
		underwaterCorrect.Parent = game.Lighting

		local underwaterBloom = Instance.new("BloomEffect")
		underwaterBloom.Enabled = false
		underwaterBloom.Parent = game.Lighting

		local defaultReverb = game.SoundService.AmbientReverb



		function velocityHandler:stepCurrentVelocity(step)
			local characterHitbox 	= player.Character and player.Character.PrimaryPart
			local frictionApplied 	= false
			local observedVelocity 	= characterHitbox.Velocity
			local heatExhausted = doesCharacterHaveStatusEffect("heat exhausted")

			if states.isSprinting and characterHitbox.Velocity.Magnitude > 0.2 then
				characterHitbox.stamina.Value = math.max(characterHitbox.stamina.Value - step, 0)
			elseif not states.isExhausted and not states.isJumping and not states.isDoubleJumping then --and not states.isFalling then
				local recovery = totalStats.staminaRecovery
				if (tick() - lastJump) > 1 / (recovery) then
					local scalar = recovery
					if heatExhausted then
						scalar = scalar - 1
					end

					characterHitbox.stamina.Value = math.min(characterHitbox.stamina.Value + (characterHitbox.maxStamina.Value * step/3 * scalar), characterHitbox.maxStamina.Value)
				end
			end

			if heatExhausted then
				characterHitbox.stamina.Value = math.max(characterHitbox.stamina.Value - step / 16, 0)
			end

			if characterHitbox.health.Value <= 0 or characterHitbox.state.Value == "dead" then
				if states.isExhausted then
					setCharacterMovementState("isExhausted", false)
				end
			elseif characterHitbox.stamina.Value <= 0 and not states.isExhausted then
				setCharacterMovementState("isSprinting", false)
				setCharacterMovementState("isExhausted", true)
				spawn(function()
					wait(2)
					characterHitbox.stamina.Value = 0
					setCharacterMovementState("isExhausted", false)
				end)
				network:fireServer("playerWasExhausted")
			end

			local desiredFOV = 70 + sprintFOV.Value + math.clamp(utilities.magnitude(observedVelocity) / 5 - 10, 0, 40)
			local currentFOV = workspace.CurrentCamera.FieldOfView

			if desiredFOV ~= currentFOV then
				local difference = desiredFOV - currentFOV
				local change = math.abs(difference) * step * 3 + 0.1
				if desiredFOV > currentFOV then
					if desiredFOV > currentFOV + change then
						currentFOV = currentFOV + change
					else
						currentFOV = desiredFOV
					end
				else
					if desiredFOV < currentFOV - change then
						currentFOV = currentFOV - change
					else
						currentFOV = desiredFOV
					end
				end
				if not workspace.CurrentCamera:FindFirstChild("overridden") then
					workspace.CurrentCamera.FieldOfView = currentFOV
				end
			end

			local char = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.PrimaryPart

			if char then
				if (not isPlayerUnderwater) and terrainUtil.isPointUnderwater(char.Position) then

					externalVelocity = externalVelocity / 5
					isPlayerUnderwater = true

					-- bubbles should be tied to your head being underwater, not your torso
					--[[
					if myClientCharacterContainer and myClientCharacterContainer:FindFirstChild("entity") and myClientCharacterContainer.entity:FindFirstChild("Head") and myClientCharacterContainer.entity.Head:FindFirstChild("MouthAttachment") then
						myClientCharacterContainer.entity.Head.MouthAttachment.bubbleParticles.Enabled = true
					end
					]]

					local soundMirror = game.ReplicatedStorage.assets.sounds:FindFirstChild("water_in")
					if soundMirror then
						local sound = Instance.new("Sound")
						for property, value in pairs(game.HttpService:JSONDecode(soundMirror.Value)) do
							sound[property] = value
						end
						sound.Parent = game.Players.LocalPlayer.Character.PrimaryPart
						sound.PlaybackSpeed = math.random(105,120)/100
						sound:Play()
						game.Debris:AddItem(sound,5)
					end

					local splashPart = game.ReplicatedStorage:FindFirstChild("fishingBob")
					if splashPart then
						splashPart = splashPart:Clone()
						splashPart.Transparency = 1
						splashPart.CanCollide = false
						splashPart.CFrame = CFrame.new() + char.Position
						splashPart.splash.Color = ColorSequence.new(workspace.Terrain.WaterColor)
						splashPart.splash:Emit(20)
						splashPart.Parent = workspace.CurrentCamera
						game.Debris:AddItem(splashPart,5)
					end

					network:fireServer("onPlayerEnteredWater", char.Position)

				elseif isPlayerUnderwater and not terrainUtil.isPointUnderwater(char.Position - Vector3.new(0, 0.5, 0)) then

					--[[
					if myClientCharacterContainer and myClientCharacterContainer:FindFirstChild("entity") and myClientCharacterContainer.entity:FindFirstChild("Head") and myClientCharacterContainer.entity.Head:FindFirstChild("MouthAttachment") then
						myClientCharacterContainer.entity.Head.MouthAttachment.bubbleParticles.Enabled = false
					end
					]]


					isPlayerUnderwater = false

					if states.isSwimming then
						setCharacterMovementState("isSwimming", false)
						setCharacterMovementState("isJumping", false)
						setCharacterMovementState("isDoubleJumping", false)

						perform_forceJump()
					end

					local soundMirror = game.ReplicatedStorage.assets.sounds:FindFirstChild("water_out")
					if soundMirror then
						local sound = Instance.new("Sound")
						for property, value in pairs(game.HttpService:JSONDecode(soundMirror.Value)) do
							sound[property] = value
						end
						sound.Parent = game.Players.LocalPlayer.Character.PrimaryPart
						sound.PlaybackSpeed = math.random(105,120)/100
						sound:Play()
						game.Debris:AddItem(sound,5)
					end
				end
			end

			if terrainUtil.isPointUnderwater(workspace.CurrentCamera.CFrame.Position) then
				if not cameraUnderwater then
					cameraUnderwater = true
					game.SoundService.AmbientReverb = "UnderWater"
					underwaterBlur.Enabled = true
					underwaterCorrect.Enabled = true
					underwaterBloom.Enabled = true
				end
			elseif cameraUnderwater and not terrainUtil.isPointUnderwater(workspace.CurrentCamera.CFrame.Position + Vector3.new(0, 0.25, 0)) then
				cameraUnderwater = false
				game.SoundService.AmbientReverb = defaultReverb
				underwaterBlur.Enabled = false
				underwaterCorrect.Enabled = false
				underwaterBloom.Enabled = false
			end

			if not states.isSwimming and (utilities.magnitude(externalVelocity) > 0 or states.isInAir) then

				-- Collision velocity decrement
				local expectedVelocity = externalVelocity + movementVelocity
				local observedVelocity = characterHitbox.Velocity

				local collideDecrementX = math.abs(expectedVelocity.X - observedVelocity.X) * step * 3
				local collideDecrementZ = math.abs(expectedVelocity.Z - observedVelocity.Z)	* step * 3

				local externalXZ = Vector3.new(externalVelocity.X, 0, externalVelocity.Z)

				local gravityDecrement = Vector3.new(0, workspace.Gravity * step, 0)

				if isPlayerUnderwater then
					gravityDecrement = gravityDecrement / 5
				end

				-- Normal velocity decrement (Friction/Air resist)
				if states.isInAir then
					local volumeGoal = math.clamp((observedVelocity.magnitude - 100) / 500, windBaseVolume, 2)
					local delta = math.abs(volumeGoal - wind.Volume)
					if wind.Volume < volumeGoal then
						wind.Volume = wind.Volume + math.clamp(delta, 0.01, 0.1)
					else
						wind.Volume = wind.Volume - math.clamp(delta, 0.01, 0.1)
					end

					--local airDecrement = airResistance * step

					local airDecrementX = airResistance * step * (math.abs(externalVelocity.X) / utilities.magnitude(externalXZ)) + collideDecrementX
					local airDecrementZ = airResistance * step * (math.abs(externalVelocity.Z) / utilities.magnitude(externalXZ)) + collideDecrementZ

					if math.abs(externalVelocity.X) > airDecrementX then
						externalVelocity = Vector3.new(externalVelocity.X - airDecrementX * math.sign(externalVelocity.X), externalVelocity.Y, externalVelocity.Z)
					else
						externalVelocity = Vector3.new(0, externalVelocity.Y, externalVelocity.Z)
					end

					if math.abs(externalVelocity.Z) > airDecrementZ then
						externalVelocity = Vector3.new(externalVelocity.X, externalVelocity.Y, externalVelocity.Z - airDecrementZ * math.sign(externalVelocity.Z))
					else
						externalVelocity = Vector3.new(externalVelocity.X, externalVelocity.Y, 0)
					end

					externalVelocity = externalVelocity - gravityDecrement
				else
					if wind.Volume > windBaseVolume then
						wind.Volume = wind.Volume - 0.02
					end

					local frictionDecrementX = friction * step * (math.abs(externalVelocity.X) / utilities.magnitude(externalXZ)) + collideDecrementX
					local frictionDecrementZ = friction * step * (math.abs(externalVelocity.Z) / utilities.magnitude(externalXZ)) + collideDecrementZ

					if frictionDecrementX > 0 then
						if math.abs(externalVelocity.X) > frictionDecrementX then
							externalVelocity = Vector3.new(externalVelocity.X - frictionDecrementX * math.sign(externalVelocity.X), externalVelocity.Y, externalVelocity.Z)
							frictionApplied = true
						else
							externalVelocity = Vector3.new(0, externalVelocity.Y, externalVelocity.Z)
						end
					end

					if frictionDecrementZ > 0 then
						if math.abs(externalVelocity.Z) > frictionDecrementZ then
							externalVelocity = Vector3.new(externalVelocity.X, externalVelocity.Y, externalVelocity.Z - frictionDecrementZ * math.sign(externalVelocity.Z))
							frictionApplied = true
						else
							externalVelocity = Vector3.new(externalVelocity.X, externalVelocity.Y, 0)
						end
					end

					if externalVelocity.Y >= gravityDecrement.Y then
						externalVelocity = externalVelocity - gravityDecrement
					else
						externalVelocity = Vector3.new(externalVelocity.X, 0, externalVelocity.Z)
					end
				end
			else
				if wind.Volume > windBaseVolume then
					wind.Volume = wind.Volume - 0.02
				end
			end

			if myClientCharacterContainer and myClientCharacterContainer:FindFirstChild("entity") then
				if frictionApplied then
					local speed = math.clamp(utilities.magnitude(externalVelocity) / 3, 5, 60)

					myClientCharacterContainer.entity.RightFoot.smoke.Rate 	= speed
					myClientCharacterContainer.entity.LeftFoot.smoke.Rate 	= speed
				end

				myClientCharacterContainer.entity.RightFoot.smoke.Enabled = frictionApplied
				myClientCharacterContainer.entity.LeftFoot.smoke.Enabled = frictionApplied
			end

			local velocityMulti = 1
			if isPlayerUnderwater then
				velocityMulti = 0.7
			end

			if player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.state.Value == "dead" then
				movementVelocity = Vector3.new()
			end

			if isPlayerUnderwater and states.isSwimming then
				externalVelocity = Vector3.new()

				return movementVelocity * velocityMulti + Vector3.new(0, 16, 0)
			else
				return (movementVelocity + externalVelocity) * velocityMulti
			end
		end
	end

	-- todo: make it so you can't exploit this, coming soon.

	while not player.Character or not player.Character.PrimaryPart do
		wait(0.5)
	end

	-- todo: fix
	local timeSinceLastInput = tick()
	userInputService.InputBegan:connect(function()
		timeSinceLastInput = tick()
	end)

	spawn(function()
		while true do
			if player.Character and player.Character.PrimaryPart then
				if player.Character.PrimaryPart.state.Value == "idling" and (tick() - timeSinceLastInput) > 5 and not isPlayerEmoting and not basicAttacking then
					local options 	= {"idling_kicking"}
					local option 	= options[math.random(#options)]

					animationInterface:replicatePlayerAnimationSequence("emoteAnimations", option)
				end
			end

			wait(math.random(5, 10))
		end
	end)

	setupRenderSteppedConnection()
end

return module