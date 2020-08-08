local hitDebounceTable 	= {}
local staff 			= {}
	staff.isEquipped = false

local userInputService 	= game:GetService("UserInputService")
local httpService 		= game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network 		= modules.load("network")
		local utilities 	= modules.load("utilities")
		local detection 	= modules.load("detection")
		local placeSetup 	= modules.load("placeSetup")
		local configuration = modules.load("configuration")

local currentDamageGUID = httpService:GenerateGUID(false)

local animationInterface = require(script.Parent.Parent.Parent:WaitForChild("contents"):WaitForChild("animationInterface"))--network:invoke("getPlayerCoreService", "animationInterface")

-- internal stuff specific to the staff
local animationControllerLoaded
local attackSequenceLength
local animationsForAnimationController

local slashAnimationConnection

local myClientCharacterContainer

local isWithinSlash1Window 		= false
local isWithinSlash2Window 		= false
local isWithinDamageSequence 	= false
local canPlayerDoubleSlash 		= false

local currentWeaponManifest
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
	-- staff uses magic attack, no polling
	--[[
	while isDamageSequenceEnabled do
		if animationsForAnimationController.staffAnimations.strike1.IsPlaying or animationsForAnimationController.staffAnimations.strike2.IsPlaying then
			if isWithinDamageSequence then
				-- todo: consider just using serverHitbox in `monsterManifestCollectionFolder` ?
				network:invoke("performClientDamageCycle", "equipment", nil, currentDamageGUID)
			end

			wait(1 / 20)
		else
			break
		end
	end
	]]
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

	if currentWeaponManifest and currentWeaponManifest:FindFirstChild("Trail") then
--		currentWeaponManifest.Trail.Enabled = false
	end
end

-- slash1PeriodStart
-- slash2PeriodStart
-- startDamageSequence
-- stopDamageSequence
local function onSlashAnimationKeyframeReached(keyframeName)
	if keyframeName == "slash1PeriodStart" then
		isWithinSlash1Window = true
		delay(3 / 10, function()
			isWithinSlash1Window = false
		end)
	elseif keyframeName == "slash2PeriodStart" then
		isWithinSlash2Window = true
		delay(3 / 10, function()
			isWithinSlash2Window = false
		end)
	elseif keyframeName == "startDamageSequence" then

		local swingSound = currentWeaponManifest:FindFirstChild("Swing")
		if swingSound == nil then
			swingSound = Instance.new("Sound")
			swingSound.Volume = 1
			swingSound.MaxDistance = 50
			swingSound.SoundId = "rbxassetid://2069260907"
			swingSound.Name = "Swing"
			swingSound.Parent = currentWeaponManifest
		end

--		swingSound:Play()
		isWithinDamageSequence = true

		if currentWeaponManifest and currentWeaponManifest:FindFirstChild("Trail") then
--			currentWeaponManifest.Trail.Enabled = true
		end
	elseif keyframeName == "stopDamageSequence" then
		isWithinDamageSequence = false

		if currentWeaponManifest and currentWeaponManifest:FindFirstChild("Trail") then
--			currentWeaponManifest.Trail.Enabled = false
		end
	end
end

function staff:attack()
	-- make sure we can't slash if these conditions are true

	if not animationsForAnimationController or not animationsForAnimationController.staffAnimations then
		return
	elseif isPlayerSprinting then
		return
	elseif not currentWeaponManifest then
		return
	elseif not player.Character or not player.Character.PrimaryPart or player.Character.PrimaryPart.state.Value == "dead" then
		return
	elseif animationsForAnimationController.staffAnimations.strike1.IsPlaying and (not isWithinSlash2Window or not canPlayerDoubleSlash)then
		return
	elseif animationsForAnimationController.staffAnimations.strike2.IsPlaying and not isWithinSlash1Window then
		return
	end

	-- have to do it this way for now, no reference to ability animations  in animationsForAnimationController
	local animController = myClientCharacterContainer.entity.AnimationController
	for i, track in pairs(animController:GetPlayingAnimationTracks()) do
		if track.Name == "rock_throw_upper" or track.Name == "rock_throw_upper_loop" then
			return
		end
	end

	local abilityExecutionData = network:invoke("getAbilityExecutionData")

	local manaBasicAttackCost = configuration.getConfigurationValue("mageManaDrainFromBasicAttack")
	if player.Character.PrimaryPart.mana.Value < manaBasicAttackCost then
		abilityExecutionData.noRangeManaAttack = true
	end

	if animationsForAnimationController.staffAnimations.strike1.IsPlaying and isWithinSlash2Window then
		if slashAnimationConnection then
			slashAnimationConnection:disconnect()
			slashAnimationConnection = nil
		end

		if slashAnimationKeyframeConnection then
			slashAnimationKeyframeConnection:disconnect()
			slashAnimationKeyframeConnection = nil
		end

		animationsForAnimationController.staffAnimations.strike1:Stop()

		slashAnimationConnection 			= animationsForAnimationController.staffAnimations.strike2.Stopped:connect(onSlashAnimationTrackStopped)
		slashAnimationKeyframeConnection 	= animationsForAnimationController.staffAnimations.strike2.KeyframeReached:connect(onSlashAnimationKeyframeReached)

		animationInterface:replicatePlayerAnimationSequence("staffAnimations", "strike2", nil, abilityExecutionData)

		-- start damage sequence
		currentDamageGUID = httpService:GenerateGUID(false)
		spawn(startDamageSequencePolling)
	elseif not animationsForAnimationController.staffAnimations.strike1.IsPlaying and (not animationsForAnimationController.staffAnimations.strike2.IsPlaying or isWithinSlash1Window) then
		if slashAnimationConnection then
			slashAnimationConnection:disconnect()
			slashAnimationConnection = nil
		end

		if slashAnimationKeyframeConnection then
			slashAnimationKeyframeConnection:disconnect()
			slashAnimationKeyframeConnection = nil
		end

		animationsForAnimationController.staffAnimations.strike2:Stop()

		slashAnimationConnection 			= animationsForAnimationController.staffAnimations.strike1.Stopped:connect(onSlashAnimationTrackStopped)
		slashAnimationKeyframeConnection 	= animationsForAnimationController.staffAnimations.strike1.KeyframeReached:connect(onSlashAnimationKeyframeReached)

		animationInterface:replicatePlayerAnimationSequence("staffAnimations", "strike1", nil, abilityExecutionData)

		-- start damage sequence
		currentDamageGUID = httpService:GenerateGUID(false)
		spawn(startDamageSequencePolling)
	end
end

function staff:equip()
	isWithinSlash1Window 	= false
	isWithinSlash2Window 	= false
	isWithinDamageSequence 	= false
	isDamageSequenceEnabled = false

	myClientCharacterContainer = network:invoke("getMyClientCharacterContainer")

	if myClientCharacterContainer then
		currentWeaponManifest 				= network:invoke("getCurrentWeaponManifest")
		animationsForAnimationController 	= animationInterface:getAnimationsForAnimationController(myClientCharacterContainer.entity.AnimationController)

	--	local grip = myClientCharacterContainer.entity:FindFirstChild("Grip", true)
	--	if grip then
	--		-- force an update
	--		onGripPropertyChanged(grip, "Part1")
	--	end
	end
end

function staff:unequip()

end

local function onPropogationRequestToSelf(propogationNameTag, propogationValue)
	if propogationNameTag == "abilities" then
		playerAbilitiesSlotDataCollection = propogationValue

		if doesPlayerHaveAbilityUnlocked(3) then
			canPlayerDoubleSlash = true
		else
			canPlayerDoubleSlash = false
		end
	end
end

local function main()
	onPropogationRequestToSelf("abilities", network:invoke("getCacheValueByNameTag", "abilities"))

	network:connect("propogationRequestToSelf", "Event", onPropogationRequestToSelf)
	network:connect("characterStateChanged", "Event", onCharacterStateChanged)
end

main()

return staff