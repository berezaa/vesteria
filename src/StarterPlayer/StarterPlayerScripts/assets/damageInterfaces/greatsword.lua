local sword 			= {}
	sword.isEquipped = false

local userInputService 	= game:GetService("UserInputService")
local httpService 		= game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")


local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")


	local modules = require(replicatedStorage.modules)
		local network 		= modules.load("network")
		local utilities 	= modules.load("utilities")
		local detection 	= modules.load("detection")
		local placeSetup 	= modules.load("placeSetup")

local currentDamageGUID = httpService:GenerateGUID(false)
		
local animationInterface = require(script.Parent.Parent.Parent:WaitForChild("repo"):WaitForChild("animationInterface"))--network:invoke("getPlayerCoreService", "animationInterface")

-- internal stuff specific to the sword
local animationControllerLoaded
local attackSequenceLength
local animationsForAnimationController

local slashAnimationConnection

local isWithinSlash1Window 		= false
local isWithinSlash2Window 		= false
local isWithinDamageSequence 	= false
local canPlayerDoubleSlash 		= false
local canPlayerTripleSlash 		= false
local isContinueNextStrike 		= false

local currentWeaponManifest
local myClientCharacterContainer
local playerAbilitiesSlotDataCollection

local player 			= game.Players.LocalPlayer
local isPlayerSprinting = false

local function onCharacterStateChanged(state, value)
	if state == "isSprinting" then
		isPlayerSprinting = value
	end
end

local function doesPlayerHaveAbilityUnlocked(abilityId, variant)
	if playerAbilitiesSlotDataCollection then
		for _, abilitySlotData in pairs(playerAbilitiesSlotDataCollection) do
			if abilitySlotData.id == abilityId and abilitySlotData.rank > 0 then
				if variant then
					return abilitySlotData.variant == variant
				else
					return true
				end
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
		if animationsForAnimationController.greatswordAnimations.strike1.IsPlaying or animationsForAnimationController.greatswordAnimations.strike2.IsPlaying or animationsForAnimationController.greatswordAnimations.strike3.IsPlaying then
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


-- slash1PeriodStart
-- slash2PeriodStart
-- startDamageSequence
-- stopDamageSequence
local function onSlashAnimationKeyframeReached(keyframeName)
	if keyframeName == "startDamageSequence" then
		local swingSound = currentWeaponManifest:FindFirstChild("Swing")	
		if swingSound == nil then
			swingSound = Instance.new("Sound")
			swingSound.PlaybackSpeed = 0.6
			swingSound.Volume = 1
			swingSound.MaxDistance = 50
			swingSound.SoundId = "rbxassetid://2069260907"
			swingSound.Name = "Swing"
			swingSound.Parent = currentWeaponManifest
		end		
		
		swingSound:Play()
		isWithinDamageSequence = true
		
		if currentWeaponManifest and currentWeaponManifest:FindFirstChild("Trail") then
			currentWeaponManifest.Trail.Enabled = true
		end
	elseif keyframeName == "stopDamageSequence" then
		isWithinDamageSequence = false
		
		if currentWeaponManifest and currentWeaponManifest:FindFirstChild("Trail") then
			currentWeaponManifest.Trail.Enabled = false
		end
	end
end

local function onSlashAnimationTrackStopped(current)
	currentDamageGUID = httpService:GenerateGUID(false)
	
	if currentWeaponManifest and currentWeaponManifest:FindFirstChild("Trail") then
		currentWeaponManifest.Trail.Enabled = false
	end
		
	if isContinueNextStrike then
		if slashAnimationConnection then
			slashAnimationConnection:disconnect()
			slashAnimationConnection = nil
		end
		
		if slashAnimationKeyframeConnection then
			slashAnimationKeyframeConnection:disconnect()
			slashAnimationKeyframeConnection = nil
		end
		
		local nextStrike = (current == "strike1" and "strike2") or (current == "strike2" and "strike3")
				
		if nextStrike then
			slashAnimationKeyframeConnection 	= animationsForAnimationController.greatswordAnimations[nextStrike].KeyframeReached:connect(onSlashAnimationKeyframeReached)
			slashAnimationConnection 			= animationsForAnimationController.greatswordAnimations[nextStrike].Stopped:connect(function()
				onSlashAnimationTrackStopped(nextStrike)
		end)
			
		--checking if player has the ability to do nextStrike
		--strike0 represents when the player should not strike again
			
		if nextStrike == "strike2" then
			if canPlayerDoubleSlash then else
				nextStrike = "strike0"
			end
		elseif nextStrike == "strike3" then
			if canPlayerTripleSlash then else
				nextStrike = "strike0"
			end
		end
			
			
			if nextStrike == "strike0" then
			else
				animationInterface:replicateClientAnimationSequence("greatswordAnimations", nextStrike)
			
				spawn(startDamageSequencePolling)
			end
		end
	else
		if slashAnimationConnection then
			slashAnimationConnection:disconnect()
			slashAnimationConnection = nil
		end
		
		if slashAnimationKeyframeConnection then
			slashAnimationKeyframeConnection:disconnect()
			slashAnimationKeyframeConnection = nil
		end
	end
	
	isContinueNextStrike = false
end

function sword:attack()

	if not animationsForAnimationController or not animationsForAnimationController.greatswordAnimations then
		return
	elseif isPlayerSprinting then
		return
	elseif not currentWeaponManifest then
		return
	elseif not player.Character or not player.Character.PrimaryPart or player.Character.PrimaryPart.state.Value == "dead" then
		return
	elseif animationsForAnimationController.greatswordAnimations.strike1.IsPlaying and isContinueNextStrike then --or not canPlayerDoubleSlash
		return
	elseif animationsForAnimationController.greatswordAnimations.strike2.IsPlaying and isContinueNextStrike then
		return
	elseif animationsForAnimationController.greatswordAnimations.strike3.IsPlaying then
		return
	end
	
	if not animationsForAnimationController.greatswordAnimations.strike1.IsPlaying and not animationsForAnimationController.greatswordAnimations.strike2.IsPlaying and not animationsForAnimationController.greatswordAnimations.strike3.IsPlaying then
		if slashAnimationConnection then
			slashAnimationConnection:disconnect()
			slashAnimationConnection = nil
		end
		
		if slashAnimationKeyframeConnection then
			slashAnimationKeyframeConnection:disconnect()
			slashAnimationKeyframeConnection = nil
		end
		
		slashAnimationConnection 			= animationsForAnimationController.greatswordAnimations.strike1.Stopped:connect(function() onSlashAnimationTrackStopped("strike1") end)
		slashAnimationKeyframeConnection 	= animationsForAnimationController.greatswordAnimations.strike1.KeyframeReached:connect(onSlashAnimationKeyframeReached)
		
		animationInterface:replicateClientAnimationSequence("greatswordAnimations", "strike1")
		
		-- start damage sequence
		currentDamageGUID = httpService:GenerateGUID(false)
		spawn(startDamageSequencePolling)
	else
		isContinueNextStrike = true
	end
end
	
function sword:equip()
	isWithinSlash1Window 	= false
	isWithinSlash2Window 	= false
	isWithinDamageSequence 	= false
	isDamageSequenceEnabled = false
	myClientCharacterContainer = network:invoke("getMyClientCharacterContainer")
	
	if myClientCharacterContainer then
		currentWeaponManifest 				= network:invoke("getCurrentWeaponManifest")
		animationsForAnimationController 	= animationInterface:getAnimationsForAnimationController(myClientCharacterContainer.entity.AnimationController)
	end
end

function sword:unequip()
	
end

local function onPropogationRequestToSelf(propogationNameTag, propogationValue)
	if propogationNameTag == "abilities" then
		playerAbilitiesSlotDataCollection = propogationValue
		
		canPlayerDoubleSlash = doesPlayerHaveAbilityUnlocked(3)
		canPlayerTripleSlash = doesPlayerHaveAbilityUnlocked(3, "tripleSlash")
	end
end

local function main()
	onPropogationRequestToSelf("abilities", network:invoke("getCacheValueByNameTag", "abilities"))
	
	network:connect("propogationRequestToSelf", "Event", onPropogationRequestToSelf)
	network:connect("characterStateChanged", "Event", onCharacterStateChanged)
end

main()

return sword