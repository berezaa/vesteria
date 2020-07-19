-- Author: Polymorphic

local module = {}
	module.clientAnimations = {}

local assetFolder = script.Parent.Parent:WaitForChild("assets")

-- module requires module!!!!!!! todo: maybe change this into a service?
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage:WaitForChild("modules"))
		local network = modules.load("network")
local characterAnimations = replicatedStorage:WaitForChild("characterAnimations")

local animationsContainer 			= {}
local availableAnimationSequences 	= {}

local rawAnimationData = {} do
	for i, animationDataCollectionModule in pairs(assetFolder.animations:GetChildren()) do
		local animationDataCollection = require(animationDataCollectionModule)

		for animationName, animationData in pairs(animationDataCollection) do
			if animationData.animationId and not animationData.animationId_2 then
				local animation 		= Instance.new("Animation")
				animation.AnimationId 	= animationData.animationId
				animation.Name 			= animationName

				if not characterAnimations:FindFirstChild(animationName) then
					animation.Parent = characterAnimations
				end

				animationData.animation = animation
			elseif animationData.animationId and animationData.animationId_2 then
				local animation 		= Instance.new("Animation")
				animation.AnimationId 	= animationData.animationId
				animation.Name 			= animationName

				local animation_2 		= Instance.new("Animation")
				animation_2.AnimationId = animationData.animationId_2
				animation_2.Name 		= animationName .. "_2"

				if not characterAnimations:FindFirstChild(animation.Name) then
					animation.Parent = characterAnimations
				end

				if not characterAnimations:FindFirstChild(animation_2.Name) then
					animation_2.Parent = characterAnimations
				end

				animationData.animation = {animation; animation_2}
			end
		end

		rawAnimationData[animationDataCollectionModule.Name] = animationDataCollection
	end
end

local function getSingleAnimation(animationController, animationGroup, animationName)
	if rawAnimationData[animationGroup] and rawAnimationData[animationGroup][animationName] then
		local animationData = rawAnimationData[animationGroup][animationName]

		if typeof(animationData.animation) == "Instance" then
			local animationTrack 	= animationController:LoadAnimation(animationData.animation)
			animationTrack.Priority = animationData.priority or Enum.AnimationPriority.Movement
			animationTrack.Looped 	= animationData.looped or false
			animationTrack.Name 	= animationName

			animationTrack:AdjustSpeed(animationData.speed or 1)

			return animationTrack
		elseif typeof(animationData.animation) == "table" then
			local animationTrack 	= animationController:LoadAnimation(animationData.animation[1])
			animationTrack.Priority = animationData.priority or Enum.AnimationPriority.Movement
			animationTrack.Looped 	= animationData.looped or false
			animationTrack.Name 	= animationName

			local animationTrack_2 		= animationController:LoadAnimation(animationData.animation[2])
			animationTrack_2.Priority 	= --[[animationData.priority_2 or]] animationData.priority or Enum.AnimationPriority.Movement
			animationTrack_2.Looped 	= animationData.looped or false
			animationTrack_2.Name 		= animationName

			animationTrack:AdjustSpeed(animationData.speed or 1)

			return {animationTrack; animationTrack_2}
		end
	end

	return nil
end

local function getSingleAnimationCluster(animationsName, animationController)
	local animationTable = {}

	for animationName, animationData in pairs(rawAnimationData[animationsName]) do
		if typeof(animationData.animation) == "Instance" then
			local animationTrack 	= animationController:LoadAnimation(animationData.animation)
			animationTrack.Priority = animationData.priority or Enum.AnimationPriority.Movement
			animationTrack.Looped 	= animationData.looped or false
			animationTrack.Name 	= animationName

			animationTrack:AdjustSpeed(animationData.speed or 1)

			animationTable[animationName] = animationTrack
		elseif typeof(animationData.animation) == "table" then
			local animationTrack 	= animationController:LoadAnimation(animationData.animation[1])
			animationTrack.Priority = animationData.priority or Enum.AnimationPriority.Movement
			animationTrack.Looped 	= animationData.looped or false
			animationTrack.Name 	= animationName

			local animationTrack_2 	= animationController:LoadAnimation(animationData.animation[2])
			animationTrack_2.Priority = --[[animationData.priority_2 or]] animationData.priority or Enum.AnimationPriority.Movement
			animationTrack_2.Looped 	= animationData.looped or false
			animationTrack_2.Name 	= animationName

			animationTrack:AdjustSpeed(animationData.speed or 1)
			animationTrack_2:AdjustSpeed(animationData.speed or 1)

			animationTable[animationName] = {animationTrack; animationTrack_2}
		end
	end

	return animationTable
end

function module:getAnimationsForAnimationController(animationController, ...)
	local animationTable 	= {}
	local animationsWanted 	= { ... }

	for i, animationDataCollectionName in pairs(animationsWanted) do
		if rawAnimationData[animationDataCollectionName] then
			animationTable[animationDataCollectionName] = getSingleAnimationCluster(animationDataCollectionName, animationController)
		end
	end

	return animationTable
end

function module:registerAnimationsForAnimationController(animationController, ...)
	local animationTable 	= {}
	local animationsWanted 	= { ... }

	for i, animationDataCollectionName in pairs(animationsWanted) do
		if rawAnimationData[animationDataCollectionName] then
			animationTable[animationDataCollectionName] = getSingleAnimationCluster(animationDataCollectionName, animationController)
		end
	end

	animationsContainer[animationController] = animationTable

	return animationTable
end

function module:getAnimationsForAnimationController(animationController)
	return animationsContainer[animationController]
end

function module:deregisterAnimationsForAnimationController(animationController)
	if animationController then
		animationsContainer[animationsContainer] = nil
	end
end

function module:stopPlayingAnimationsByAnimationCollectionName(animationTable, animationCollectionName)
	for i, animationTrack in pairs(animationTable[animationCollectionName]) do
		if typeof(animationTrack) == "Instance" then
			animationTrack:Stop()
		elseif typeof(animationTrack) == "table" then
			for ii, obj in pairs(animationTrack) do
				obj:Stop()
			end
		end
	end
end

function module:stopPlayingAnimationsByAnimationCollectionNameWithException(animationTable, animationCollectionName, exception)
	if animationTable[animationCollectionName] then
		for i, animationTrack in pairs(animationTable[animationCollectionName]) do
			if typeof(animationTrack) == "Instance" then
				if not exception or animationTrack.Name ~= exception then
					animationTrack:Stop()
				end
			elseif typeof(animationTrack) == "table" then
				if not exception or animationTrack[1].Name ~= exception then
					for ii, obj in pairs(animationTrack) do
						obj:Stop()
					end
				end
			end
		end
	end
end

function module:replicateNonPlayerAnimationSequence(animationCollectionName, animationName, callback, extraData)
	if module.clientAnimations[animationCollectionName] and module.clientAnimations[animationCollectionName][animationName] then
		self:stopPlayingAnimationsByAnimationCollectionName(module.clientAnimations, "emoteAnimations")

		network:fire("playNonPlayerAnimationSequence", animationCollectionName, animationName)

		if callback and typeof(module.clientAnimations[animationCollectionName][animationName]) == "Instance" then
			local connection

			connection = module.clientAnimations[animationCollectionName][animationName].Stopped:connect(function()
				connection:disconnect()

				callback()
			end)
		end
	end

	if rawAnimationData[animationCollectionName] and rawAnimationData[animationCollectionName][animationName] then
		network:fireServer("replicateNonPlayerAnimationSequence", animationCollectionName, animationName, extraData)
	end
end

function module:replicatePlayerAnimationSequence(animationCollectionName, animationName, callback, extraData)
	-- todo: remove all calls so no more redirect?
	module:replicateClientAnimationSequence(animationCollectionName, animationName, callback, extraData)
end

local ATTACK_SPEED_ANIMATION_COLLECTION_NAMES = {
	"swordAnimations",
	"staffAnimations",
	"daggerAnimations",
	"bowAnimations",
	"greatswordAnimations",
	"dualAnimations",
	"swordAndShieldAnimations",
}
local function isAttackSpeedAnimationCollection(name)
	for _, attackSpeedAnimationCollectionName in pairs(ATTACK_SPEED_ANIMATION_COLLECTION_NAMES) do
		if attackSpeedAnimationCollectionName == name then
			return true
		end
	end
	return false
end

function module:replicateClientAnimationSequence(animationCollectionName, animationName, callback, extraData)
	if rawAnimationData[animationCollectionName] and rawAnimationData[animationCollectionName][animationName] then
		if isAttackSpeedAnimationCollection(animationCollectionName) then
			extraData = extraData or {}
				extraData.attackSpeed = network:invoke("getCacheValueByNameTag", "nonSerializeData").statistics_final.attackSpeed or 0

		end

		network:fire("playPlayerAnimationSequenceOnClientCharacter", animationCollectionName, animationName, extraData)

		network:fireServer("replicatePlayerAnimationSequence", animationCollectionName, animationName, extraData)
	end
end

function module:getPlayingAnimationTracks()
	local myClientPlayerCharacterContainer = network:invoke("getMyClientCharacterContainer")

	if myClientPlayerCharacterContainer then
		return myClientPlayerCharacterContainer.entity.AnimationController:GetPlayingAnimationTracks()
	end

	return {}
end

local function regenerateClientAnimations(myClientPlayerCharacterContainer)
	local animationController = (myClientPlayerCharacterContainer or network:invoke("getMyClientCharacterContainer")).entity.AnimationController

	module.clientAnimations = {}
	for animationDataCollectionName, animationCollection in pairs(rawAnimationData) do

		-- do not automatically register this animation
		if not string.match(animationDataCollectionName, "_noChar") then
			module.clientAnimations[animationDataCollectionName] = getSingleAnimationCluster(animationDataCollectionName, animationController)
		end
	end
end

local function main()
	module.getSingleAnimation 			= getSingleAnimation
	module.getSingleAnimationCluster 	= getSingleAnimationCluster
	module.rawAnimationData 			= rawAnimationData

	-- generate animationData for player
	local myClientPlayerCharacterContainer = network:invoke("getMyClientCharacterContainer")
	if myClientPlayerCharacterContainer then
		regenerateClientAnimations(myClientPlayerCharacterContainer)
	end

	spawn(function()
		network:connect("myClientCharacterContainerChanged", "Event", regenerateClientAnimations)
	end)
end

spawn(main)

return module