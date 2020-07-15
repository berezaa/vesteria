-- Pretty golden punctuation
-- Author: berezaa


local module = {}
--[[

local assetFolder = script.Parent.Parent:WaitForChild("assets")

local replicatedStorage = game:GetService("ReplicatedStorage")
local collectionService = game:GetService("CollectionService")
local runService		= game:GetService("RunService")

local questLookup 	= require(replicatedStorage.questLookup)
local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
	local network 		= modules.load("network")
	local tween 		= modules.load("tween")
	local utilities 	= modules.load("utilities")
	local levels		= modules.load("levels")
	local mapping		= modules.load("mapping")
	local questUtil     = modules.load("client_quest_util")
	local placeSetup 	= modules.load("placeSetup")
	local foilage		= placeSetup.getPlaceFolder("foilage")
	
	
	local utilTable = {}
	utilTable.network = network	
	utilTable.utilities = utilities
	utilTable.levels = levels	
	utilTable.quest_util = questUtil
	utilTable.mapping = mapping	

local function getPlayerQuestStateByQuestId(questId)
	local quests = network:invoke("getCacheValueByNameTag", "quests")
		
	for i, playerQuestData in pairs(quests.active) do
		if playerQuestData.id == questId then
			
			local objectiveSteps 	= 0
			local objectiveStepsDone 	    = 0
			
			-- hacky fix for now but at least it wont break
			if playerQuestData.currentObjective > #playerQuestData.objectives then
				return mapping.questState.completed
			end
			
				
			for ii, playerStepData in pairs(playerQuestData.objectives[playerQuestData.currentObjective].steps) do
				objectiveSteps = objectiveSteps + 1
					if playerStepData.requirement.amount <= playerStepData.completion.amount then
						objectiveStepsDone = objectiveStepsDone + 1
					end
			end
			if objectiveStepsDone > 0 and objectiveStepsDone == objectiveSteps and playerQuestData.objectives[playerQuestData.currentObjective].started then
				--if playerQuestData.currentObjective == #playerQuestData.objectives then
				--	return mapping.questState.handing 
				--else
					return mapping.questState.objectiveDone
				--end
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


local function checkIfObjectiveStartedByQuestId(questId)
		local quests = network:invoke("getCacheValueByNameTag", "quests")
			
		for i, playerQuestData in pairs(quests.active) do
			if playerQuestData.id == questId then
				
				return playerQuestData.objectives[playerQuestData.currentObjective].started
			end
		end
		return true
	end

local colors = {
	active = Color3.fromRGB(255, 179, 25);
	inactive = Color3.fromRGB(88, 88, 88);
}

local questData

local questMarkers = {}

local updatingParts = false

local rings = {}

local function updateDialoguePart(dialoguePart)
	
	updatingParts = true
	local existingPart = questMarkers[dialoguePart]
	if existingPart then
		existingPart:Destroy()
	end
	local ySize = 4
	
	
	--if dialoguePart.Parent and dialoguePart.Parent:IsA("Model") and dialoguePart:isDescendantOf(game.Workspace) then
		--ySize = 4
		--ySize = dialoguePart.Parent:GetExtentsSize().Y / 2  !this line was lagging the client like crazy when there were enough quest/shop givers in one place!
	--end
	
	
	local markerPart
	local markerStyle
	
	if dialoguePart:FindFirstChild("inventory") then
		markerPart = "Money"
		markerStyle = "active"
	elseif dialoguePart:FindFirstChild("dialogue") then
		local dialogue = require(dialoguePart.dialogue)
		
		
		
		
			if dialogue.flagForQuest then
				
	
				local flagForQuest = dialogue.flagForQuest
				if type(flagForQuest) == "function" then
					flagForQuest = flagForQuest(utilTable)	
				end
		  		
				local questData = questLookup[flagForQuest]
				local questState = getPlayerQuestStateByQuestId(flagForQuest)
				local questCanBeStarted = questUtil.masterCanStartQuest(flagForQuest) -- tests for all quest requirements
				
				
				local currentObjectiveAndStarted = questUtil.getQuestObjectiveAndStarted(flagForQuest)
				
				local canContinue = true
				
				
				local objectiveChoiceTable = dialogue.getObjectiveOptionsTable(utilTable)
				if currentObjectiveAndStarted < 0 then
					if objectiveChoiceTable[currentObjectiveAndStarted *-1] == nil then
						canContinue = false 
					end
				else
					if objectiveChoiceTable[currentObjectiveAndStarted] == nil then
						canContinue = false 
					end
				end
				
				
				-- objective unassigned logic
				if currentObjectiveAndStarted < 0 and canContinue then
					
					local actualObjective = currentObjectiveAndStarted * -1
					
					objectiveChoiceTable = objectiveChoiceTable[actualObjective]
					for i, choice in pairs(objectiveChoiceTable) do
						if choice.isStarterNPC ~= nil and not choice.isStarterNPC then
							canContinue = false 
						end
						
					end
				elseif canContinue then
					-- objective handing logic
					objectiveChoiceTable = objectiveChoiceTable[currentObjectiveAndStarted]
					for i, choice in pairs(objectiveChoiceTable) do
						if choice.isHanderNPC ~= nil and not choice.isHanderNPC then
							canContinue = false 
						end
						
					end
					
				end
				
				if canContinue then
					
					if questData and questState ~= mapping.questState.completed then
							
						if questState == mapping.questState.handing or questState == mapping.questState.objectiveDone then
								-- quest to hand in takes max priority
							markerPart = "Question"
							markerStyle = "active"
								
						elseif questState == mapping.questState.unassigned then
							if questCanBeStarted then
									-- valid quest to do
								markerPart = "Exclaim"
								markerStyle = "active"
							elseif markerPart == nil then
									-- quest out of requirement
										-- ber edit remove marker from quests you cant do
						--		markerPart = "Exclaim" -- if they don't have the requirements don't show the marker at all
						--		markerStyle = "inactive"
							end
						elseif questState == mapping.questState.active and markerPart == nil then
								
							markerPart = "Question"
							markerStyle = "inactive"	
						end
							
					end
				end
				end
				
	elseif dialoguePart:FindFirstChild("QuestObjectiveTag") then
				markerPart = "Exclaim"
				markerStyle = "active"
				
	end
				

	
	if markerPart then
		


		
		local primaryPart = dialoguePart.Parent.PrimaryPart or dialoguePart
		
		local radius = dialoguePart:FindFirstChild("range") and dialoguePart.range.Value or 8


		local realMarker = assetFolder:FindFirstChild(markerPart)
		if realMarker and dialoguePart:IsDescendantOf(game.workspace) then
			realMarker = realMarker:Clone()
			questMarkers[dialoguePart] = realMarker
			realMarker.Anchored = true
			realMarker.Color = colors[markerStyle] or colors["inactive"]
			
			local primaryPart = dialoguePart.Parent.PrimaryPart or dialoguePart
			
			realMarker.CFrame = primaryPart.CFrame * CFrame.Angles(-math.pi/2, 0, 0) + Vector3.new(0, ySize + realMarker.Size.Y/2 + 3, 0) 
			realMarker.Parent = foilage
			local realMarkerMask = realMarker:Clone()
			realMarkerMask.Parent = realMarker
			realMarkerMask.Material = Enum.Material.Neon
			realMarkerMask.Transparency = 0.7
			
			if markerStyle == "inactive" then
				realMarker.Transparency = 0.4
			end
		end
	end	
			
end
				
collectionService:GetInstanceAddedSignal("interact"):connect(function(interaction)
	updateDialoguePart(interaction)
end)				

collectionService:GetInstanceRemovedSignal("interact"):connect(function(interaction)
	local existingPart = questMarkers[interaction]
	if existingPart then
		existingPart:Destroy()
	end
end)

local function updateAllParts()
	local dialogueParts = collectionService:GetTagged("interact")
	for i,dialoguePart in pairs(dialogueParts) do
		updateDialoguePart(dialoguePart)
	end	
end

spawn(function()
	wait(3)
	updateAllParts()
end)


local function onDataChange(key, value)
	if key == "quests" or key == "class" or key == "level" then
		updateAllParts()
	
	end
end


network:create("npcmarkers_force_update", "BindableEvent", "Event", function(player)
	updateAllParts()
end)
	
network:connect("propogationRequestToSelf", "Event", onDataChange)
	
local angleOffset = 0
local heightOffset = -0.25
	
-- todo: yikes
runService.Heartbeat:connect(function()
	for rootPart, marker in pairs(questMarkers) do
		if rootPart.Parent then
			
		
			if rootPart.Parent.PrimaryPart then
				rootPart = rootPart.Parent.PrimaryPart
			end
			local baseCF = rootPart.CFrame * CFrame.Angles(-math.pi/2, 0, 0) + Vector3.new(0, 5.75, 0)
			marker.CFrame = baseCF * CFrame.Angles(0, 0, math.rad(angleOffset)) + Vector3.new(0, heightOffset, 0) 
			local markerMask = marker:FindFirstChild(marker.Name)
			if markerMask then
				markerMask.CFrame = marker.CFrame
			end
		else
			questMarkers[rootPart] = nil
		end
	end
end)

spawn(function()
	while runService.Heartbeat:wait() do
		angleOffset = angleOffset + 1
		if angleOffset >= 360 then
			angleOffset = 0
		end
	end
end)
spawn(function()
	while runService.Heartbeat:wait() do
		for i=1,100 do
			heightOffset = heightOffset + 1/200
			runService.Heartbeat:wait()
		end
		for i=1,100 do
			heightOffset = heightOffset - 1/200
			runService.Heartbeat:wait()
		end
	end
end)
]]
return module
