
-- to be used when writing client quest npc functionality


local replicatedStorage = game:GetService("ReplicatedStorage")
local collectionService = game:GetService("CollectionService")
local runService		= game:GetService("RunService")

local questLookup 	= require(replicatedStorage:WaitForChild("questLookupNew"))


local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
	local network 		= modules.load("network")
	local tween 		= modules.load("tween")
	local utilities 	= modules.load("utilities")
	local mapping		= modules.load("mapping")
	local itemLookup = require(game.ReplicatedStorage:WaitForChild("itemData"))
for i, questDataModule in pairs(script:GetChildren()) do
		local questData = require(questDataModule)

		-- internal stuff
		--questData.module = questDataModule

		-- hook ups
		--lookupTable[questData.id] 			= questData
		--lookupTable[questDataModule.Name] 	= questData
	end

local module = {}

local function questState(questId)
	local quests = network:invoke("getCacheValueByNameTag", "quests")

	for i, playerQuestData in pairs(quests.active) do
		if playerQuestData.id == questId then

			local objectiveSteps 	= 0
			local objectiveStepsDone 	    = 0

			for ii, playerStepData in pairs(playerQuestData.objectives[playerQuestData.currentObjective].steps) do
				objectiveSteps = objectiveSteps + 1
					if playerStepData.requirement.amount <= playerStepData.completion.amount then
						objectiveStepsDone = objectiveStepsDone + 1
					end
			end
			if objectiveStepsDone > 0 and objectiveStepsDone == objectiveSteps and playerQuestData.objectives[playerQuestData.currentObjective].started then
					return mapping.questState.objectiveDone
			else
				if playerQuestData.objectives[playerQuestData.currentObjective].started then
						return mapping.questState.active
					else
						return mapping.questState.unassigned
					end

					return mapping.questState.active
			end
		end
	end

	for i, completePlayerQuestData in pairs(quests.completed) do
		if completePlayerQuestData.id == questId then
			return mapping.questState.completed
		end
	end



	return mapping.questState.unassigned
end


function module.getPlayerQuestStateByQuestId(questId)
	return questState(questId)
end


local function questObjective(questId)
	local quests = network:invoke("getCacheValueByNameTag", "quests")


	for i, playerQuestData in pairs(quests.active) do

		if playerQuestData.id == questId then
			if playerQuestData.objectives[playerQuestData.currentObjective] then --.started
				return playerQuestData.currentObjective
			end
		end
	end

	return -1
end



function module.getQuestObjective(questId)
	return questObjective(questId)
end

local function questObjectiveAndStarted(questId)
	local quests = network:invoke("getCacheValueByNameTag", "quests")
	local notStartedCurrentObjective

	for i, playerQuestData in pairs(quests.active) do

		if playerQuestData.id == questId then
			if playerQuestData.objectives[playerQuestData.currentObjective].started then --.started
				return playerQuestData.currentObjective
			else
				return playerQuestData.currentObjective *-1
			end
		end
	end


	return -1
end




function module.getQuestObjectiveAndStarted(questId)
	return questObjectiveAndStarted(questId)
end

local function levelReq(questId, currentObjective)

	local questData = questLookup[questId]
	if currentObjective == -1 then
		currentObjective = 1
	end
	return questData.objectives[currentObjective].requireLevel or 1
end


function module.getQuestLevelReq(questId, currentObjective)
	return levelReq(questId, currentObjective)
end


local function classReq(questId)
	local questData = questLookup[questId]

	return questData.requireClass
end

function module.getQuestClassReq(questId)
	return classReq(questId)
end

local function reqQuests(questId)
	local questData = questLookup[questId]

	return { unpack(questData.requireQuests) }
end

function module.getQuestRequiredQuests(questId)
	return reqQuests(questId)
end

local function repeatData(questId)
	local questData = questLookup[questId]

	return questData.repeatableData.value, questData.repeatableData.timeInterval
end

function module.getQuestRepeatData(questId)
	return repeatData(questId)
end


function module.canPlayerInventoryObtainItem(itemId)
	local inventory = network:invoke("getCacheValueByNameTag", "inventory")
	local category = itemLookup[itemId].category


	-- if inventory is full but player already has 1 of the item
	for i, itemData in pairs(inventory) do
		if itemData.id == itemId then
			return true
		end
	end

	local spacesTaken = 0
	for i, itemData in pairs(inventory) do
		if itemData.category == category then
			spacesTaken = spacesTaken + 1
		end
	end

	-- inv full
	if spacesTaken >= 20 then -- remember to change to 20 when that update comes
		return false
	end

	-- inv not full
	return true


end


-- will go through all the checks and return true/false if player can start quest. used for npcquestmarker when the reason for not being able to start the quest doesn't matter
function module.masterCanStartQuest(questId)
	local currentObjective = questObjective(questId)



	local playerLevel = network:invoke("getCacheValueByNameTag", "level")
	local completedQuests = network:invoke("getCacheValueByNameTag", "quests").completed
	local playerClass = network:invoke("getCacheValueByNameTag", "class")

	--local playerLevel, completedQuests, playerClass = network:invokeServer("playerRequest_questStartStats")



	local requireLevel = levelReq(questId, currentObjective)
	local requireClass = classReq(questId)
	local requireQuests = reqQuests(questId)

	local isRepeatable, repeatInterval = repeatData(questId)

	if currentObjective == -1 then
		currentObjective = 1
	end

	-- check level
	if playerLevel < requireLevel then
		return false
	end

	-- check class
	if requireClass and requireClass ~= playerClass then
		return false
	end

	-- check quest reqs
	if #requireQuests > 0 then
		for i, reqQuest in pairs(requireQuests) do
			local hasQuest = false
			for ii, completeQuest in pairs(completedQuests) do
				if completeQuest.id == reqQuest then
					hasQuest = true
				end
			end
			if not hasQuest then
				return false
			end
		end
	end

	-- is repeatable

	if isRepeatable then
		local activeQuests = network:invoke("getCacheValueByNameTag", "quests").active
		local canStartAfterTim
		for i, activeData in pairs(activeQuests) do
			if activeData.id == questId and activeData.canStartAfterTime then
				if activeData.canStartAfterTime > os.time() then
					return false
				end
			end
		end
	end

	-- special check for desert quest
	if questId == 22 then
		local started = false
		local activeQuests = network:invoke("getCacheValueByNameTag", "quests").active
		for i, quest in pairs(activeQuests) do
			if quest.id == 22 then
				started = false
			end
		end

		local hasNotebook = false
		if not started then

			local inv = network:invoke("getCacheValueByNameTag", "inventory")
			for i, item in pairs(inv) do

				if item.id == 187 then
					hasNotebook = true
				end
			end
			if not hasNotebook then return false end
		end

	end

	return true
end




return module
