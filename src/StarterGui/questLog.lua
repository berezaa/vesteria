local module = {}

function module.open()
	
end
--[[
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network 	= modules.load("network")
		local utilities = modules.load("utilities")
		local questUtil = modules.load("client_quest_util")
	local itemData = require(replicatedStorage.itemData)
	local questLookup 	= require(replicatedStorage.questLookup)
-- todo: remove this disgusting absolute reference
--local uiCreator = require(script.Parent.Parent.Parent.Parent:WaitForChild("uiCreator"))

local player 						= game.Players.LocalPlayer

local instructFrame					= script.Parent:WaitForChild("contents").logFrame.curve.questInstructions.contents
local selectFrame					= script.Parent:WaitForChild("contents").quests.curve.contents
--local scrollingMask = script.Parent.Parent.Parent.Parent:WaitForChild("scrollingMask")

local currentQuestOpenId 
local activeQuests = {}
local completedQuests = {}
local unassignedQuests = {}

local lastSelected
local openQuestOnJoinId 


function module.init(Modules)
	
	local function createSingleNote(text, completed, centered, col)
		local slot = script.slot:Clone()
		slot.Text = text
		if completed then
			slot.TextTransparency = .5
		end
		if centered then
			slot.TextXAlignment = "Center"
		end
		
		
		local sizeY = game.TextService:GetTextSize(text, slot.TextSize, slot.Font, instructFrame.AbsoluteSize).Y + 25
		slot.Size = UDim2.new(1,-12,0,sizeY)
		
		if col then
			slot.TextColor3 = col
		end
		
		slot.Parent = instructFrame
		instructFrame.CanvasSize = UDim2.new(0,0,0,instructFrame.UIListLayout.AbsoluteContentSize.Y + 30)
		
	end
	
	
	local function drawQuestNotes(id)
		if id == nil then return end
		currentQuestOpenId = id -- needed don't get rid of me
		local quests = network:invoke("getCacheValueByNameTag", "quests")
		
		for i, child in pairs(instructFrame:GetChildren()) do
			if child.Name == "slot" then
				child:Destroy()
			end
		end
		
		
		
		local baseState = ""
		local questLookUpData = questLookup[id] -- for finding the text, triggertypes, to add to the notes
		local playerQuestData                   -- for displaying progress. if nil then the quest is not started
			
			
		local header = script.Parent:WaitForChild("contents").logFrame.curve.header
		local titleT = header.quest
		titleT.Text = questLookUpData.questLineName
		
		header.titledecor.Size = UDim2.new(0,titleT.TextBounds.X+16,0,36)
		
		
		
		for i, questData in pairs(quests.active) do
			if questData.id == id and questData.objectives[1].started then
				baseState = "active"
				playerQuestData = questData
				createSingleNote(questLookUpData.questLineDescription, false, true)
			end
		end
		
		for i, questData in pairs(quests.completed) do
			if questData.id == id and baseState ~= "active" then
				baseState = "completed"
				playerQuestData = questData
				createSingleNote(questLookUpData.questLineDescription, true, true)
			end
		end
		
		if baseState == "" then
			baseState = "unassigned"
		end
		
		if playerQuestData and baseState == "active" then
			for i, objectiveData in pairs(playerQuestData.objectives) do
			
				if not objectiveData.started then
					break
				end
				
				local objectiveReference = questLookUpData.objectives[i]
				
				local stepsTotal = #objectiveData.steps
				local stepsCompleted = 0
				
				for ii, stepData in pairs(objectiveData.steps) do
					
					local stepReference = questLookUpData.objectives[i].steps[ii]
					
					
					
					local triggerType = questLookUpData.objectives[i].steps[ii].triggerType
					local constructedString = ""
					
					if stepReference.overridingNote then
						constructedString = stepReference.overridingNote
					else
						
						local completedAmount = math.clamp(stepData.completion.amount, 0, stepData.requirement.amount)
						
						
						constructedString = "["..(completedAmount).."/"..(stepData.requirement.amount).."]"
						
						
						if stepReference.accompanyingNote then
							constructedString = constructedString.." "..stepReference.accompanyingNote
						elseif triggerType == "monster-killed" then
							if stepReference.requirement.isGiant then
								constructedString = constructedString.." Giant "..stepReference.requirement.monsterName.." kills"
							else
								constructedString = constructedString.." "..stepReference.requirement.monsterName.." kills"
							end
							
						elseif triggerType == "item-collected" then
							local name = itemData[stepReference.requirement.id].name
							constructedString = constructedString.." "..name .." collected"
						end
					end
					
					
					if stepData.completion.amount >= stepData.requirement.amount then
						stepsCompleted = stepsCompleted + 1
					end
					
					if stepReference.isSequentialStep then
						local checkCompletedSteps = 0
						for iii, stepData in pairs(objectiveData.steps) do
							if iii >= ii then break end
							if stepData.completion.amount >= stepData.requirement.amount then
								checkCompletedSteps = checkCompletedSteps + 1
							end
						end
						
						if checkCompletedSteps >= ii - 1 then
							if stepReference.hideNote == nil then
								createSingleNote(constructedString, stepData.completion.amount >= stepData.requirement.amount, false)
							end
							
						end
					else
						if stepReference.hideNote == nil then
							createSingleNote(constructedString, stepData.completion.amount >= stepData.requirement.amount, false)
						end
					end
				end
				
				if stepsCompleted >= stepsTotal then
					if playerQuestData.currentObjective > i then
						
						if playerQuestData.objectives[i + 1].started then
							-- case 1
							-- player has turned in the current objective AND started the next objective
							createSingleNote(objectiveReference.completedNotes, true, false)
							createSingleNote(objectiveReference.handingNotes, true, true)
						else
							-- case 2
							-- player has turned in the current objective BUT has not started the next objective. (player could not have completed the quest)
							createSingleNote(objectiveReference.completedNotes, true, false)
							createSingleNote(objectiveReference.handingNotes, false, true)
						end
						
					else
						
						if baseState == "completed" then
							-- case 3 player has completed the quest
							
							createSingleNote(objectiveReference.completedNotes, true, false)
							createSingleNote(objectiveReference.handingNotes, false, true)
						elseif baseState == "active" then
							-- case 4 player needs to turn in the quest
							createSingleNote(objectiveReference.completedNotes, false, false, Color3.fromRGB(255, 210, 29))
							
						end
					end
				end
			end
		elseif baseState == "completed" then
			
			local completedNotes = "Quest Completed!"
			if playerQuestData.failed then
				completedNotes = "Quest Failed."
			end
			
			createSingleNote(completedNotes, false, true)
			if questLookUpData.questEndedNote then
				createSingleNote(questLookUpData.questEndedNote, false, false)
			end
			
		else
			-- quest is unassigend, display data accordingly
			--createSingleNote("my name jef", false, false)
		end
		
		
		instructFrame.CanvasPosition = Vector2.new(0,instructFrame.UIListLayout.AbsoluteContentSize.Y)
	end

	
	local function drawQuestSelectButton(id, col)
		local slot = script.slotB:Clone()
				
		slot.itemName.Text = questLookup[id].questLineName
		slot.itemName.TextColor3 = col
		slot.frame.ImageColor3 = col
		slot.shine.ImageColor3 = col
		slot.MouseButton1Click:connect(function()
					-- update
			currentQuestOpenId = id
			drawQuestNotes(id)
		end)
				
				
				
		slot.Parent = selectFrame
				
		selectFrame.CanvasSize = UDim2.new(0,0,0,selectFrame.UIListLayout.AbsoluteContentSize.Y + 10)
				
		if selectFrame.UIListLayout.AbsoluteContentSize.Y >= selectFrame.AbsoluteSize.Y then
			for i, child in pairs(selectFrame:GetChildren()) do
				if child.Name == "slotB" then
					child.Size = UDim2.new(1,-16,0,45)
				end
			end
		end
	end
	
	
	local function updateQuestLog(updateQuestData)
		if updateQuestData then
			activeQuests = {}
			completedQuests = {}
			unassignedQuests = {}
			
			--active first
			for i, quest in pairs(updateQuestData.active) do
				if quest.objectives[1].started then
					table.insert(activeQuests, quest.id)
				end
			end
			
			for i, quest in pairs(updateQuestData.completed) do
				local repeated = false
				for ii, id in pairs(activeQuests) do
					if id == quest.id then
						repeated = true
					end
				end
				if not repeated then
					table.insert(completedQuests, quest.id)
				end
			end
			
			
			for key, val in pairs(questLookup) do
				
				local testKey = tonumber(key)
				if testKey then
					local unassigned =  true
					for i, id in pairs(activeQuests) do
						if id == testKey then
							unassigned = false
						end
					end
					
					for i, id in pairs(completedQuests) do
						if id == testKey then
							unassigned = false
						end
					end
					
					if unassigned then
						table.insert(unassignedQuests, testKey)
					end
				end
			end
			
		
			
			for i, child in pairs(selectFrame:GetChildren()) do
				if child.Name == "slotB" then
					child:Destroy()
				end
			end
			
			
			local alertQuests = 0
			for i, id in pairs(activeQuests) do
				local state = questUtil.getPlayerQuestStateByQuestId(id)
				if state == 9 then
					if openQuestOnJoinId == nil then
						openQuestOnJoinId  = id
					end
					drawQuestSelectButton(id, Color3.fromRGB(255, 210, 29))
					alertQuests = alertQuests + 1
				end
				
			end
			
			for i, id in pairs(activeQuests) do
				local state = questUtil.getPlayerQuestStateByQuestId(id)
				if state ~= 9 then	
					if openQuestOnJoinId == nil then
						openQuestOnJoinId  = id
					end	
					drawQuestSelectButton(id, Color3.fromRGB(255,255,255))
				end
				
			end
			
			
			--for i, id in pairs(unassignedQuests) do
			--	drawQuestSelectButton(id, Color3.fromRGB(147, 147, 147))
			--end
			
			for i, id in pairs(completedQuests) do
				drawQuestSelectButton(id, Color3.fromRGB(147, 147, 147))
			end
			
			if currentQuestOpenId == nil and openQuestOnJoinId ~= nil then
				drawQuestNotes(openQuestOnJoinId)
			else
				drawQuestNotes(currentQuestOpenId)
			end
			
			if alertQuests > 0 then
				script.Parent.Parent.right.buttons.openQuestLog.alert.value.Text = alertQuests
				script.Parent.Parent.right.buttons.openQuestLog.alert.Visible = true
			else
				script.Parent.Parent.right.buttons.openQuestLog.alert.Visible = false
			end
			
			
		end
	end
	
	
	local function onPropogationRequestToSelf(propogationNameTag, propogationData)
		if propogationNameTag == "quests" then
			updateQuestLog(propogationData)
		end
	end
	
	local function main()
		
		updateQuestLog(network:invoke("getCacheValueByNameTag", "quests"))
		network:connect("propogationRequestToSelf", "Event", onPropogationRequestToSelf)
		
		network:create("displayQuestInQuestLog", "BindableEvent")
		network:connect("displayQuestInQuestLog", "Event", drawQuestNotes)
		
		
		script.Parent.close.MouseButton1Click:connect(function()
			Modules.focus.toggle(script.Parent)
		end)
	end
	
	function module.open()
		
		if not script.Parent.Visible then
			script.Parent.UIScale.Scale = (Modules.input.menuScale or 1) * 0.75
			Modules.tween(script.Parent.UIScale, {"Scale"}, (Modules.input.menuScale or 1), 0.5, Enum.EasingStyle.Bounce)
		end				
		Modules.focus.toggle(script.Parent)
		
	end	
	
	main()

end
	

	
]]

return module