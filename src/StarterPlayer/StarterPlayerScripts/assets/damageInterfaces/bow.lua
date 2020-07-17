local hitDebounceTable 	= {}
local bow 				= {}
	bow.isEquipped = false

local runService 		= game:GetService("RunService")
local userInputService 	= game:GetService("UserInputService")
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network 			= modules.load("network")
		local utilities 		= modules.load("utilities")
		local client_utilities 	= modules.load("client_utilities")
		local detection 		= modules.load("detection")
		local placeSetup 		= modules.load("placeSetup")
		local projectile 		= modules.load("projectile")
		local configuration 	= modules.load("configuration")
		local damage 			= modules.load("damage")
		local tween 			= modules.load("tween")

local animationInterface = require(script.Parent.Parent.Parent:WaitForChild("repo"):WaitForChild("animationInterface"))--network:invoke("getPlayerCoreService", "animationInterface")

local entityRenderCollectionFolder 		= placeSetup.awaitPlaceFolder("entityRenderCollection")
local entityManifestCollectionFolder 	= placeSetup.awaitPlaceFolder("entityManifestCollection")
local itemsFolder 						= placeSetup.awaitPlaceFolder("items")
local entitiesFolder 					= placeSetup.awaitPlaceFolder("entities")

-- internal stuff specific to the bow
local isBowCharging = false
local currentArrow

local currentWeaponManifest
local bowAnimationsForTool
local animationsForAnimationController

local camera 			= workspace.CurrentCamera
local player 			= game.Players.LocalPlayer
local isPlayerSprinting = false

local function getRayClosestPoint(ray, targetPos)
	local AP = targetPos - ray.Origin
	local AB = (ray.Origin + ray.Direction) - ray.Origin

	local dotProduct 	= AP:Dot(AB) / AB:Dot(AB)
	dotProduct 			= math.clamp(dotProduct, 0, 1)

	return ray.Origin + dotProduct * AB
end

local function onCharacterStateChanged(state, value)
	if state == "isSprinting" then
		isPlayerSprinting = value
	end
end

local function onBowToolStretchStopped()
	if isBowCharging and bowAnimationsForTool.stretchHold then
		bowAnimationsForTool.stretchHold:Play()
	end

	if animationsForAnimationController.bowAnimations.stretching_bow.IsPlaying then
		animationsForAnimationController.bowAnimations.stretching_bow:Stop()
	end

end

local bowPullTime

local function playerHasArrowToShoot(numArrows)
	local inventory = network:invoke("getCacheValueByNameTag", "inventory") or {}

	for i, inventorySlotData in pairs(inventory) do
		if inventorySlotData.id == 87 and inventorySlotData.stacks >= 1 then
			return true, math.min(inventorySlotData.stacks, numArrows)
		end
	end

	return false
end

local BOW_CHARGE_TIME = 0.8
local ARROWS_PER_SECOND = 1 / BOW_CHARGE_TIME

local arrowsToFire = 0

function bow:attackRangerStance()
	local hasArrows, numArrows = playerHasArrowToShoot(1)

	if not hasArrows then
		network:fire("alert", {text = "You don't have any arrows!", id = "noarrows"}, 3)
		return false
	end

	network:invoke("setIsJumpEnabled", false)
	network:invoke("setIsSprintingEnabled", false)
	network:invoke("setIsChanneling", true)

	isBowCharging = true

	animationInterface:replicatePlayerAnimationSequence("bowAnimations", "stretching_bow_stance", nil, {
		attackSpeed = 1,
		numArrows = numArrows,
		firingSeed = math.random(1,2048)
	})

	-- this is intentionally a wait in order to delay
	-- the auto-attack loop that calls this function
	-- so that spam-clicking can't cheese shots per second
	wait(0.8)

	if not isBowCharging then
		return
	elseif not playerHasArrowToShoot(1) then
		network:invoke("setIsJumpEnabled", true)
		network:invoke("setIsSprintingEnabled", true)
		network:invoke("setIsChanneling", false)

		isBowCharging = false

		return
	end

	local abilityExecutionData = network:invoke("getAbilityExecutionData")
	abilityExecutionData.bowChargeTime = configuration.getConfigurationValue("maxBowChargeTime")

	animationInterface:replicatePlayerAnimationSequence("bowAnimations", "firing_bow_stance", nil, abilityExecutionData)

	wait(0.9)

	network:invoke("setIsJumpEnabled", true)
	network:invoke("setIsSprintingEnabled", true)
	network:invoke("setIsChanneling", false)

	isBowCharging = false
end

local timeSinceChargeBow
function bow:attack(inputObject)
	-- make sure we can't slash if these conditions are true
	if not animationsForAnimationController or not animationsForAnimationController.bowAnimations then
		print"no bow anim"
		return
	elseif isPlayerSprinting then
		print"is sprint"
		return
	elseif not bowAnimationsForTool then
		print"no bowtool anim"
		return
	elseif not currentWeaponManifest then
		print("no weapon")
		return
	elseif not player.Character or not player.Character.PrimaryPart or player.Character.PrimaryPart.state.Value == "dead" then
		print"is dead"
		return
	elseif isBowCharging then
		print"already charging"
		return
--	elseif network:invoke("getCharacterMovementStates").isInAir then
--		return
	end

	if inputObject.UserInputState ~= Enum.UserInputState.Begin then print"not begin" return end

	if utilities.doesEntityHaveStatusEffect(player.Character.PrimaryPart, "ranger stance") then
		self:attackRangerStance()

		return
	end

	local stats = network:invoke("getCacheValueByNameTag", "nonSerializeData").statistics_final
	local maxNumArrows = utilities.calculateNumArrowsFromDex(stats.dex)

	local hasArrows, numArrows = playerHasArrowToShoot(maxNumArrows)

	if not hasArrows then
		network:fire("alert", {text = "You don't have any arrows!", id = "noarrows"}, 3)
		return false
	end

	network:invoke("setIsJumpEnabled", false)
	network:invoke("setIsSprintingEnabled", false)
	network:invoke("setIsChanneling", true)

	isBowCharging = true

	-- the bow isn't quite fast enough on its own, so secretly boost attack speed behind the scenes
	local baseAttackSpeedBoost = 0.33
	local bonus = (stats.attackSpeed / 2) + baseAttackSpeedBoost
	local attackSpeedScalar = 1 + bonus

	animationInterface:replicatePlayerAnimationSequence("bowAnimations", "stretching_bow", nil, {
		attackSpeed = stats.attackSpeed,
		numArrows 	= numArrows,
		firingSeed 	= math.random(1,2048)
	})

	-- wait for bow to let go of holding
	bowPullTime = tick()

	while inputObject.UserInputState ~= Enum.UserInputState.End do
		runService.Stepped:wait()
	end

	self:fireArrow()
end

function bow:release()
	-- dummy function to dissuade the system from calling this
	-- one click should lead to one arrow at least no matter what
end

function bow:fireArrow()
	local stats = network:invoke("getCacheValueByNameTag", "nonSerializeData").statistics_final
	local maxNumArrows = utilities.calculateNumArrowsFromDex(stats.dex)

	if not isBowCharging then
		return
	elseif not playerHasArrowToShoot(maxNumArrows) then
		network:invoke("setIsJumpEnabled", true)
		network:invoke("setIsSprintingEnabled", true)
		network:invoke("setIsChanneling", false)

		isBowCharging = false

		return
	end

	isBowCharging = false

	local attackSpeedScalar = 1 + stats.attackSpeed

	local abilityExecutionData = network:invoke("getAbilityExecutionData")
		abilityExecutionData.bowChargeTime = tick() - bowPullTime

	bowPullTime = nil

	network:invoke("setIsJumpEnabled", true)
	network:invoke("setIsSprintingEnabled", true)
	network:invoke("setIsChanneling", false)

	if abilityExecutionData.bowChargeTime <= configuration.getConfigurationValue("minBowChargeTime") then
		abilityExecutionData.canceled = true
	end

	local currentArrow = network:invoke("getPlayerRenderDataByNameTag", player, "primaryArrow")
	if not abilityExecutionData.canceled and currentArrow then
		local targets = damage.getDamagableTargets(player)
		local hitPart, hitPos, hitNormal, hitMaterial, hitRay = client_utilities.raycastFromCurrentScreenPoint({entityRenderCollectionFolder; itemsFolder; entitiesFolder})

		local ray = Ray.new(currentArrow.Position, (hitPos - currentArrow.Position).unit * 50)

		local closestHitbox, closestDist, closestProjection = nil, configuration.getConfigurationValue("bowSnapTargetMaxDistance"), nil
		for i, targetHitbox in pairs(targets) do
			local pointOnRay = getRayClosestPoint(ray, targetHitbox.Position)
			local boxProjection = detection.projection_Box(targetHitbox.CFrame, targetHitbox.Size, pointOnRay)

			local distanceMissed = (pointOnRay - boxProjection).magnitude

			if distanceMissed <= closestDist then
				closestDist 		= distanceMissed
				closestHitbox 		= targetHitbox
				closestProjection 	= boxProjection
			end
		end

		if closestHitbox then
			-- target monster
			abilityExecutionData["target-position"] = closestProjection

			-- target monster
			abilityExecutionData["target-velocity"] = closestHitbox.Velocity

			-- target monster distance away
			if player.Character and player.Character.PrimaryPart then
				abilityExecutionData["target-distance-away"] = (closestHitbox.Position - player.Character.PrimaryPart.Position).magnitude
			end
		end
	end

	animationInterface:replicatePlayerAnimationSequence("bowAnimations", "firing_bow", nil, abilityExecutionData)
end

function bow:equip()
	local myClientCharacterContainer = network:invoke("getMyClientCharacterContainer")

	if myClientCharacterContainer then
		currentWeaponManifest 				= network:invoke("getCurrentWeaponManifest")
		animationsForAnimationController 	= animationInterface:getAnimationsForAnimationController(myClientCharacterContainer.entity.AnimationController)

		if currentWeaponManifest and currentWeaponManifest:FindFirstChild("AnimationController") then
			bowAnimationsForTool = animationInterface:getAnimationsForAnimationController(currentWeaponManifest.AnimationController, "bowToolAnimations_noChar").bowToolAnimations_noChar
		end
	end
end

function bow:unequip()
	network:fire("replicateClientCharacterWeaponStateChanged", "bow", nil)
end

local function main()
	network:connect("characterStateChanged", "Event", onCharacterStateChanged)
end

main()

return bow