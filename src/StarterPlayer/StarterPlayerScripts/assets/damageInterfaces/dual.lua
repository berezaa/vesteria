local dual 			= {}
	dual.isEquipped = false

local userInputService 	= game:GetService("UserInputService")
local httpService 		= game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("assets"):WaitForChild("abilityAnimations")

	local modules = require(replicatedStorage.modules)
		local network 		= modules.load("network")
		local utilities 	= modules.load("utilities")
		local detection 	= modules.load("detection")
		local placeSetup 	= modules.load("placeSetup")

local currentDamageGUID = httpService:GenerateGUID(false)

local animationInterface = require(script.Parent.Parent.Parent:WaitForChild("repo"):WaitForChild("animationInterface"))--network:invoke("getPlayerCoreService", "animationInterface")

-- internal stuff specific to the dual
local animationControllerLoaded
local attackSequenceLength
local animationsForAnimationController

local slashAnimationConnection

local isWithinSlash1Window 		= false
local isWithinSlash2Window 		= false
local isWithinDamageSequence 	= false
local canPlayerDoubleSlash 		= false
local canPlayerTripleSlash 		= false

local weaponManifestRight, weaponManifestLeft
local myClientCharacterContainer
local playerAbilitiesSlotDataCollection

local player 			= game.Players.LocalPlayer
local isPlayerSprinting = false

local function onCharacterStateChanged(state, value)
	if state == "isSprinting" then
		isPlayerSprinting = value
	end
end

local function doesPlayerHaveAbilityUnlocked(abilityId)
	if playerAbilitiesSlotDataCollection then
		for _, abilitySlotData in pairs(playerAbilitiesSlotDataCollection) do
			if abilitySlotData.id == abilityId and abilitySlotData.rank > 0 then
				return true
			end
		end
	end

	return false
end

local isDamageSequenceEnabled = false
local function startDamageSequencePolling()
	if isDamageSequenceEnabled then return end
	isDamageSequenceEnabled = true

	while isDamageSequenceEnabled do
		if animationsForAnimationController.dualAnimations.strike1.IsPlaying or animationsForAnimationController.dualAnimations.strike2.IsPlaying or animationsForAnimationController.dualAnimations.strike3.IsPlaying then
			if isWithinDamageSequence then
				network:invoke("performClientDamageCycle", "equipment", nil, currentDamageGUID)
			end

			wait(1 / 20)
		else
			break
		end
	end

	isDamageSequenceEnabled = false
end

local function onSlashAnimationTrackStopped()
	currentDamageGUID = httpService:GenerateGUID(false)

	if slashAnimationConnection then
		slashAnimationConnection:disconnect()
		slashAnimationConnection = nil
	end

	if slashAnimationKeyframeConnection then
		slashAnimationKeyframeConnection:disconnect()
		slashAnimationKeyframeConnection = nil
	end
end

-- slash1PeriodStart
-- slash2PeriodStart
-- startDamageSequence
-- stopDamageSequence
local function onSlashAnimationKeyframeReached(keyframeName)
	local anims = animationsForAnimationController.dualAnimations
	if not anims then return end

	local weaponManifests
	if anims.strike1.IsPlaying then
		weaponManifests = {weaponManifestRight}
	elseif anims.strike2.IsPlaying then
		weaponManifests = {weaponManifestLeft}
	elseif anims.strike3.IsPlaying then
		weaponManifests = {weaponManifestRight, weaponManifestLeft}
	else
		-- this should hopefully not happen
		weaponManifests = {}
	end

	if keyframeName == "slash1PeriodStart" then
		isWithinSlash1Window = true
		delay(0.6, function()
			isWithinSlash1Window = false
		end)
	elseif keyframeName == "slash2PeriodStart" then
		isWithinSlash2Window = true
		delay(0.6, function()
			isWithinSlash2Window = false
		end)
	elseif keyframeName == "startDamageSequence" then
		isWithinDamageSequence = true

		for _, currentWeaponManifest in pairs(weaponManifests) do
			local swingSound = currentWeaponManifest:FindFirstChild("Swing")
			if swingSound == nil then
				swingSound = Instance.new("Sound")
				swingSound.Volume = 1
				swingSound.MaxDistance = 50
				swingSound.SoundId = "rbxassetid://2069260907"
				swingSound.Name = "Swing"
				swingSound.Parent = currentWeaponManifest
			end

			swingSound:Play()

			if currentWeaponManifest and currentWeaponManifest:FindFirstChild("Trail") then
				currentWeaponManifest.Trail.Enabled = true
			end
		end
	elseif keyframeName == "stopDamageSequence" then
		isWithinDamageSequence = false

		for _, currentWeaponManifest in pairs(weaponManifests) do
			if currentWeaponManifest and currentWeaponManifest:FindFirstChild("Trail") then
				currentWeaponManifest.Trail.Enabled = false
			end
		end
	end
end

local function resetConnections()
	if slashAnimationConnection then
		slashAnimationConnection:disconnect()
		slashAnimationConnection = nil
	end
	if slashAnimationKeyframeConnection then
		slashAnimationKeyframeConnection:disconnect()
		slashAnimationKeyframeConnection = nil
	end
end

function dual:attack()
	if not animationsForAnimationController then return end

	local anims = animationsForAnimationController.dualAnimations

	if not anims then
		return
	elseif isPlayerSprinting then
		return
	elseif not (weaponManifestRight and weaponManifestRight) then
		return
	elseif not player.Character or not player.Character.PrimaryPart or player.Character.PrimaryPart.state.Value == "dead" then
		return
	elseif anims.strike1.IsPlaying then
		return
	elseif anims.strike2.IsPlaying then
		return
	elseif anims.strike3.IsPlaying then
		return
	end

	-- should slash1 if we're not playing it or we're following through from
	-- slash2 if we're not a triple slash character
	local shouldSlash1 = (not anims.strike1.IsPlaying) or (isWithinSlash1Window and (not canPlayerTripleSlash))

	-- should slash2 if we're not playing it and we're following through from
	-- slash1 and we can double slash
	local shouldSlash2 = (not anims.strike2.IsPlaying) and isWithinSlash2Window and canPlayerDoubleSlash

	-- should slash3 if we're not playing it and we're following through from
	-- slash2 and we can triple slash
	local shouldSlash3 = (not anims.strike3.IsPlaying) and isWithinSlash1Window and canPlayerTripleSlash

	-- so... let's do the slash we're supposed to be doing
	-- prioritize slash3 because sometimes slash1 thinks it's better
	if shouldSlash3 then
		isWithinSlash1Window = false

		resetConnections()
		slashAnimationConnection = anims.strike3.Stopped:Connect(onSlashAnimationTrackStopped)
		slashAnimationKeyframeConnection = anims.strike3.KeyframeReached:Connect(onSlashAnimationKeyframeReached)

		animationInterface:replicateClientAnimationSequence("dualAnimations", "strike3")

		currentDamageGUID = httpService:GenerateGUID(false)
		spawn(startDamageSequencePolling)

	elseif shouldSlash2 then
		isWithinSlash2Window = false

		resetConnections()
		slashAnimationConnection = anims.strike2.Stopped:Connect(onSlashAnimationTrackStopped)
		slashAnimationKeyframeConnection = anims.strike2.KeyframeReached:Connect(onSlashAnimationKeyframeReached)

		animationInterface:replicateClientAnimationSequence("dualAnimations", "strike2")

		currentDamageGUID = httpService:GenerateGUID(false)
		spawn(startDamageSequencePolling)

	elseif shouldSlash1 then
		isWithinSlash1Window = false

		resetConnections()
		slashAnimationConnection = anims.strike1.Stopped:Connect(onSlashAnimationTrackStopped)
		slashAnimationKeyframeConnection = anims.strike1.KeyframeReached:Connect(onSlashAnimationKeyframeReached)

		animationInterface:replicateClientAnimationSequence("dualAnimations", "strike1")

		currentDamageGUID = httpService:GenerateGUID(false)
		spawn(startDamageSequencePolling)
	end
end

function dual:equip()
	isWithinSlash1Window 	= false
	isWithinSlash2Window 	= false
	isWithinDamageSequence 	= false
	isDamageSequenceEnabled = false
	--local
	myClientCharacterContainer = network:invoke("getMyClientCharacterContainer")

	if myClientCharacterContainer then
		local currentlyEquipped = network:invoke("getCurrentlyEquippedForRenderCharacter", myClientCharacterContainer.entity)
		weaponManifestRight = currentlyEquipped["1"].manifest
		weaponManifestLeft  = currentlyEquipped["11"].manifest

		animationsForAnimationController 	= animationInterface:getAnimationsForAnimationController(myClientCharacterContainer.entity.AnimationController)

	--	local grip = myClientCharacterContainer.entity:FindFirstChild("Grip", true)
	--	if grip then
	--		-- force an update
	--		onGripPropertyChanged(grip, "Part1")
	--	end
	end
end

function dual:unequip()

end

local function onPropogationRequestToSelf(propogationNameTag, propogationValue)
	if propogationNameTag == "abilities" then
		playerAbilitiesSlotDataCollection = propogationValue

		canPlayerDoubleSlash = doesPlayerHaveAbilityUnlocked(3)
		canPlayerTripleSlash = doesPlayerHaveAbilityUnlocked(30)
	end
end

local function main()
	onPropogationRequestToSelf("abilities", network:invoke("getCacheValueByNameTag", "abilities"))

	network:connect("propogationRequestToSelf", "Event", onPropogationRequestToSelf)
	network:connect("characterStateChanged", "Event", onCharacterStateChanged)
end

main()

return dual