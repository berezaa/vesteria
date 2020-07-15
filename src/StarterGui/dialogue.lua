local module = {}

local superRootDialogueData
--[[
	dialogueData {}
		string id
		string dialogue
		
		table responses
			[string playerResponse] = <dialogData>
			
	
	dialogueHandler {}
		instance dialogUI
		instance currentSpeaker
		
		dialogueData rootDialogueData
		dialogueData currentDialogueData
		dialogueData previousDialogueData
	
		event::onPlayerDialogueProceed(string currentId)
		event::onDialogueFinishShowing(string currentId)
		event::onPlayerSelectResponse(string currentId, string selectionId)
		
		method::showDialogue([string startingId])
		method::setSpeaker(instance speakerModel, bool tweenCameraToSpeaker = false[, cframe cameraOffset])
	
	local shopDialogue = dialogue:createDialog({
		id 			= "startTalkingToShopkeeper"
		dialogue 	= "Welcome to my shop, how may I help you?";
		responses 	= {
			["What are you selling?"] = {
				dialogue = "Come take a look!";
			};
			
			["Goodbye"] = {};
		};
	})
	--]]

local dialogueFrameUI = script.Parent.gameUI.dialogueFrame
local gameUI = dialogueFrameUI.Parent
local uiCreator
local userInputService 	= game:GetService("UserInputService")
local textService 		= game:GetService("TextService")
local replicatedStorage = game:GetService("ReplicatedStorage")
	local questLookup 	= require(replicatedStorage.questLookup)
	local itemLookup 	= require(replicatedStorage.itemData)
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")
		local mapping 		= modules.load("mapping")
		local levels 		= modules.load("levels")
		local util 			= modules.load("utilities")
		local questUtil 	= modules.load("client_quest_util")
		local localization 	= modules.load("localization")
		

local globalOnClose

function module.init(Modules)
	
	local utilities = {}
	utilities.network = network	
	utilities.utilities = util
	utilities.levels = levels	
	utilities.quest_util = questUtil
	utilities.mapping = mapping
	
	-- ensure dialogue handler is added to modules table
	uiCreator = Modules.uiCreator

	local function inputUpdate()
		dialogueFrameUI.UIScale.Scale = Modules.input.menuScale or 1
		if Modules.input.mode.Value == "mobile" then
			dialogueFrameUI.Position = UDim2.new(0.5, 0,1, -20)
		else
			dialogueFrameUI.Position = UDim2.new(0.5, 0,1, -140)
		end
	end

	local responseOptionTemplate = script:WaitForChild("responseOption")
	
	local dialogueHandler = {}
		dialogueHandler.events = {}
	
	local function getDialogueDataById(dialogData, dialogDataId, extraData)
		
		if dialogData.id == dialogDataId then
			return dialogData
		end
		
		print("$",dialogData.id,dialogDataId,extraData)
		
		if dialogData.options then
			
			local dialogOptions = dialogData.options
			if type(dialogOptions) == "function" then
				dialogOptions = dialogOptions(utilities, extraData)
			end
			
			if type(dialogOptions) == "table" and #dialogOptions > 0 then	
				for i, v in pairs(dialogData.options) do
					local dialog = getDialogueDataById(v, dialogDataId, extraData)
					if dialog then
						return dialog
					end
				end
			end
		end
	
		return nil
	end
	
	
	function dialogueHandler:moveToId(dialogDataId, extraData)


		local newDialogueData = getDialogueDataById(superRootDialogueData, dialogDataId, extraData)
	
		if newDialogueData then
	
			-- stop any ongoing dialogue
			dialogueHandler:stopDialogue()
			
			-- set dialogueData to new dialogueData
			dialogueHandler:setDialogue(newDialogueData, extraData)

			-- show new dialogueData root
			dialogueHandler:startDialogue()	
		end
						
	end
	
	network:create("dialogueMoveToId", "BindableFunction", "OnInvoke", function(id, extraData)
		dialogueHandler:moveToId(id, extraData)
	end)
	
	
	-- update me
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
					--	return mapping.questState.handing -- quest is done, trigger its removal from the active quests
					--else
						return mapping.questState.objectiveDone
					--end
				else
					
					if playerQuestData.objectives[playerQuestData.currentObjective].started then
						return mapping.questState.active
					else
						return mapping.questState.unassigned
					end
					
			--		return mapping.questState.active
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
	
	local function getPlayerQuestObjectiveByQuestId(questId)
		local quests = network:invoke("getCacheValueByNameTag", "quests")
			
		for i, playerQuestData in pairs(quests.active) do
			if playerQuestData.id == questId then
				return playerQuestData.currentObjective
			end
		end
		return 1
	end
	
	local function checkIfObjectiveStartedByQuestId(questId)
		local quests = network:invoke("getCacheValueByNameTag", "quests")
			
		for i, playerQuestData in pairs(quests.active) do
			if playerQuestData.id == questId then
				
				return playerQuestData.objectives[playerQuestData.currentObjective].started
				
				--return playerQuestData.objectives[playerQuestData.currentObjective].started
			end
		end
		return true
	end
	
	-- returns paginated version of dialogue
	local function paginateDialogueDataDialogue(dialogue)
		
	end
	
	function dialogueHandler:clearEvents()
		for i, v in pairs(dialogueHandler.events) do
			v:disconnect()
		end
		
		dialogueHandler.events = {}
	end
	
	function dialogueHandler:navigateCurrentDialogueData(response)
		if not self.currentDialogueData or not self.currentDialogueData.options or not self.currentDialogueData.options[response] then return end
		
		self.isPlayingDialogue = false
		self:clearEvents()
		self:setDialogue(self.currentDialogueData.options[response])
		
		-- update the new dialogue to match current data
		self:startDialogue()
	end
	
	function dialogueHandler:stopDialogue()
		self.isPlayingDialogue = false
		self:clearEvents()
		
		
		dialogueFrameUI.Visible = true
		Modules.focus.toggle(dialogueFrameUI)
	
		-- hide the UI
--		dialogueFrameUI.Visible = false
	end
	
	function dialogueHandler:setDialogue(dialogueData, extraData)
		self.rootDialogueData 		= dialogueData
		self.currentDialogueData 	= dialogueData
		self.extraData				= extraData
		self.previousDialogueData 	= nil
	end
	
	local isProcessingQuestSubmission = false
	
	function dialogueHandler:acceptQuestRewardsButtonActivated(npcName)
		isProcessingQuestSubmission = true
		
		local success = network:invokeServer("playerRequest_submitQuest", dialogueHandler.questData.id, self.questData.objectives[self.currentQuestObjective].handerNpcName)
		if success then
			if dialogueHandler.questData.objectives[self.currentQuestObjective].localOnFinish then
				dialogueHandler.questData.objectives[self.currentQuestObjective].localOnFinish(utilities, self.extraData)
			end
			utilities.utilities.playSound("questTurnedIn")
		end
		
		module.endDialogue()
		Modules.interaction.stopInteract()
		isProcessingQuestSubmission = false
	end
	
	local acceptButtonConnection
	
	dialogueFrameUI.cancel.Activated:Connect(function()
		module.endDialogue()
		Modules.interaction.stopInteract()
	end)
	
	function dialogueHandler:startDialogue(dialogueNumber, questResponseType)
		if not self.currentDialogueData then return end
		
		dialogueFrameUI.UIScale.Scale = 1
		
		if self.currentDialogueData.onClose then
			globalOnClose = self.currentDialogueData.onClose
		end
		
		local body = self.currentDialogueData.Parent and self.currentDialogueData.Parent.Parent
		if body and body:FindFirstChild("AnimationController") then
			network:invoke("lockCameraTarget", body)
		end
		
		if self.currentDialogueData.sound and self.speaker and self.speaker.PrimaryPart and (dialogueNumber == nil or dialogueNumber <= 1) then
			utilities.utilities.playSound(self.currentDialogueData.sound, self.speaker.PrimaryPart)
		end
		
		-- show the UI
		
		local yOffset_dialogue 		= 30
		dialogueNumber 				= (dialogueNumber and dialogueNumber > 1) and tostring(dialogueNumber) or ""
		local trueDialogueNumber 	= dialogueNumber == "" and 1 or tonumber(dialogueNumber)
		
		
		-- update speaker title
		if self.currentDialogueData.speakerName or self.speaker then
			local speakerText 		= (self.speaker and self.speaker.Name or self.currentDialogueData.speakerName) or "Someone messed up."
			local speakerTextSize 	= textService:GetTextSize(speakerText, dialogueFrameUI.titleFrame.title.TextSize, dialogueFrameUI.titleFrame.title.Font, Vector2.new())
			
			dialogueFrameUI.titleFrame.title.Text 	= speakerText
			dialogueFrameUI.titleFrame.Size 		= UDim2.new(0, speakerTextSize.X + 20, 0, 32)
		end
		
		-- clear text
		dialogueFrameUI.contents.dialogue:ClearAllChildren()
		
		--for i, v in pairs(self.currentDialogueData) do
		--end
		
		-- update text
		local isOnLastDialogue = true
		
		local objective
		if self.currentQuestObjective then
			objective = self.currentQuestObjective
		end
		
		-- "dialogue" .. dialogueNumber .. (self.questState and "_" .. mapping.getMappingByValue("questState", self.questState) .. (questResponseType and "_" .. questResponseType or "") or "")
		--"dialogue" .. dialogueNumber .. (self.questState and "_" .. mapping.getMappingByValue("questState", self.questState) .. ( (questResponseType and "_" .. questResponseType and (objective and "_" .. objective or "")) or (objective and "_" .. objective) or "") or "")
		local target 			= "dialogue" .. dialogueNumber .. (self.questState and "_" .. mapping.getMappingByValue("questState", self.questState) .. (questResponseType and "_" .. questResponseType or "") .. (objective and "_"..objective or "") or "")
		local targetDialogue 	= self.currentDialogueData[target]
		
		-- CONVERT FUNCTION TO TEXT
		if type(targetDialogue) == "function" then
			targetDialogue = targetDialogue(utilities, self.extraData)	
		end
		
		if typeof(targetDialogue) == "string" then
			targetDialogue = localization.translate(targetDialogue, dialogueFrameUI.contents.dialogue)
			targetDialogue = localization.convertToVesteriaDialogueTable(targetDialogue) 
		end
		
		if targetDialogue then
			local dialogueData = targetDialogue
			local dialogueText, yOffset = uiCreator.createTextFragmentLabels(dialogueFrameUI.contents.dialogue, dialogueData)
			
			
			
			dialogueFrameUI.contents.dialogue.Size = UDim2.new(1, 0, 0, yOffset + 18)
			yOffset_dialogue = yOffset_dialogue + yOffset + 18
			
			if self.currentDialogueData["dialogue" .. trueDialogueNumber + 1] then
				isOnLastDialogue = false
			end
		end
		
		-- clear responses
		dialogueFrameUI.contents.options:ClearAllChildren()
		
		yOffset_dialogue 							= yOffset_dialogue + 10
		dialogueFrameUI.contents.options.Position 	= UDim2.new(0, 0, 0, yOffset_dialogue)
		
		local responseButtonCount = 0
		local xOffset_options, yOffset_options = 0, 0
		-- easy function to create responseButtons
		local function createResponseButton(textToDisplay, dialogueData, questState, questData, buttonColor3, callback, curQuestObjective, isQuestAcceptB)
			local responseOptionSize = textService:GetTextSize(textToDisplay, responseOptionTemplate.inner.TextSize, responseOptionTemplate.inner.Font, Vector2.new())

			local responseOption = responseOptionTemplate:Clone()
			
			if textToDisplay == "X" then
				responseOptionSize = Vector2.new(10,0)
				responseOption.inner.Text = "X"
				responseOption.inner.Font = Enum.Font.SourceSansBold
			end
			
			if typeof(textToDisplay) == "string" then							
				textToDisplay = localization.translate(textToDisplay, dialogueFrameUI.contents.options) 
			end
			
			if xOffset_options + (responseOptionSize.X + 20) > dialogueFrameUI.contents.options.AbsoluteSize.X then
				xOffset_options = 0
				yOffset_options = yOffset_options + 42
			end
			
			responseOption.inner.Text 	= textToDisplay
			responseOption.Size 		= UDim2.new(0, responseOptionSize.X + 30, 0, 42)
			responseOption.Position 	= UDim2.new(0, xOffset_options, 0, yOffset_options)
			responseOption.Parent 		= dialogueFrameUI.contents.options
			
			local questResponseType
			if dialogueData then
				local objective = ""
				if self.currentQuestObjective then
					objective = "_"..self.currentQuestObjective
				end
				
				if dialogueData.responseButtonColor then
					responseOption.ImageColor3 = dialogueData.responseButtonColor
				elseif dialogueData.onSelected then
					responseOption.ImageColor3 = Color3.fromRGB(255, 210, 29)
				elseif textToDisplay == dialogueData["response_unassigned_accept"..objective] then
					responseOption.ImageColor3 = Color3.fromRGB(150, 255, 150)
					questResponseType = "accept"
				elseif textToDisplay == dialogueData["response_unassigned_decline"..objective] then
					responseOption.ImageColor3 = Color3.fromRGB(255, 150, 150)
					questResponseType = "decline"
				else
--					responseOption.ImageColor3 = Color3.fromRGB(208, 222, 255)
				end
			end
			
			if buttonColor3 then
				responseOption.ImageColor3 = buttonColor3
			end
			
			table.insert(self.events, callback and responseOption.Activated:connect(callback) or responseOption.Activated:connect(function()
				if dialogueData then
					if questState and questData and curQuestObjective then
						self.questState = questState
						self.questData 	= questData
						self.currentQuestObjective = curQuestObjective
					end
					
					if dialogueData.onSelected then
						dialogueData.onSelected()
					end
					
					if questResponseType == "accept" then
						-- request server to add quest!
						local success = network:invokeServer("playerRequest_grantQuestToPlayer", self.questData.id, self.questData.objectives[self.currentQuestObjective].giverNpcName)
						
						if success then
							network:fire("displayQuestInQuestLog", self.questData.id)
							if self.questData.objectives[self.currentQuestObjective].clientOnAcceptQuest then
								self.questData.objectives[self.currentQuestObjective].clientOnAcceptQuest(utilities, self.extraData)
							end
						end
					end
					
					
					
					-- stop any ongoing dialogue
					dialogueHandler:stopDialogue()
					
					-- set dialogueData to new dialogueData
					dialogueHandler:setDialogue(dialogueData)
					
					-- show new dialogueData root
					dialogueHandler:startDialogue(nil, questResponseType)
				else
					if isQuestAcceptB then -- moved in here 
							isProcessingQuestSubmission = true
							
							local success = network:invokeServer("playerRequest_submitQuest", dialogueHandler.questData.id, self.questData.objectives[self.currentQuestObjective].handerNpcName)
							if success then
								if dialogueHandler.questData.objectives[self.currentQuestObjective].localOnFinish then
									dialogueHandler.questData.objectives[self.currentQuestObjective].localOnFinish(utilities, self.extraData)
								end
								utilities.utilities.playSound("questTurnedIn")
							end
							
							module.endDialogue()
							Modules.interaction.stopInteract()
							isProcessingQuestSubmission = false
							
					end
					module.endDialogue()
					Modules.interaction.stopInteract()
				end
			end))
			
			responseButtonCount = responseButtonCount + 1
			
			xOffset_options = xOffset_options + responseOptionSize.X + 20 + 5
		end	

		local dialogOptions = self.currentDialogueData.options

		-- prevent the function from having cache behavior
		if self.currentDialogueData.optionsFunction then
			dialogOptions = self.currentDialogueData.optionsFunction(utilities, self.extraData)
		end
		
		if type(dialogOptions) == "function" then
			self.currentDialogueData.optionsFunction = dialogOptions
			dialogOptions = dialogOptions(utilities, self.extraData)
		end
		
		self.currentDialogueData.options = dialogOptions
		dialogueFrameUI.bottom.Visible = false	
		
		-- update responses
		
		-- accept rewards
		if self.questState == mapping.questState.objectiveDone or self.questState == mapping.questState.handing then
			-- show di!
			if self.questData then
				for i, obj in pairs(dialogueFrameUI.contents.rewards.contents:GetChildren()) do
					if not obj:IsA("UIListLayout") then
						obj:Destroy()
					end
				end
				local curObj = self.currentQuestObjective
				local rewards   = self.questData.objectives[curObj].rewards
				local goldMulti = self.questData.objectives[curObj].goldMulti
				local expMulti = self.questData.objectives[curObj].expMulti
				local level = self.questData.objectives[curObj].level
				
				for i, inventoryTransferData_intermediate in pairs(rewards) do
					local itemBaseData = itemLookup[inventoryTransferData_intermediate.id]
					local amount = inventoryTransferData_intermediate.stacks
					
					if itemBaseData then
						local itemLine_quest 	= script.itemLine_quest:Clone()
						itemLine_quest.AutoLocalize = false
						
						local itemName = localization.translate(itemBaseData.name, dialogueFrameUI.contents.rewards)
						itemLine_quest.Text 	= itemName .. (amount and " x"..amount or "")
						
						itemLine_quest.preview.Image = itemBaseData.image
						
						itemLine_quest.Parent = dialogueFrameUI.contents.rewards.contents
					end
				end
				
				local expText = dialogueFrameUI.contents.rewards.chest.exp
				expText.Visible = false
				if (expMulti or 1) > 0 then
--					local itemLine_quest 	= script.itemLine_quest:Clone()
					expText.Visible = true
					expText.Text = "+ "..math.floor(levels.getQuestEXPFromLevel(level or 1) * (expMulti or 1)) .. " EXP"
					
--					itemLine_quest.preview.Image = ""
					
--					itemLine_quest.Parent = dialogueFrameUI.contents.rewards.contents
				end
				
				if (goldMulti or 1) > 0 then
					local reward = levels.getQuestGoldFromLevel(level or 1) * (goldMulti or 1)
				
					--[[
					local itemLine_quest 	= script.itemLine_quest:Clone()
					itemLine_quest.Text 	= levels.getQuestGoldFromLevel(self.questData.level or 1) * (self.questData.goldMulti or 1) .. " Gold"
					
					itemLine_quest.preview.Image = ""
					
					itemLine_quest.Parent = dialogueFrameUI.contents.rewards.contents
					]]
					local itemLine_quest = script.itemLine_money:clone()
					Modules.money.setLabelAmount(itemLine_quest, reward)
					itemLine_quest.Parent = dialogueFrameUI.contents.rewards.contents
				end
				
				local tYSize_rewards = 0
				for i, obj in pairs(dialogueFrameUI.contents.rewards.contents:GetChildren()) do
					if obj:IsA("GuiObject") and obj.Visible then
						tYSize_rewards = tYSize_rewards + 29
					end
				end
				
				dialogueFrameUI.contents.rewards.contents.Size 	= UDim2.new(1, -15, 0, tYSize_rewards)
				dialogueFrameUI.contents.rewards.Size 			= UDim2.new(1, 0, 0, tYSize_rewards + 18 + 24)
			end
			dialogueFrameUI.contents.rewards.Visible = true
			dialogueFrameUI.contents.taxi.Visible = false
			
			--(textToDisplay, dialogueData, questState, questData)
			createResponseButton("Accept Rewards", nil, nil, nil, Color3.fromRGB(85, 255, 76), nil, nil, true)
			createResponseButton("X")
			--[[
			
			dialogueFrameUI.accept.Visible 				= true
			if acceptButtonConnection then
				acceptButtonConnection:Disconnect()
				acceptButtonConnection = nil
			end
			]]
			-- ugly ugly hack -ber
			acceptButtonConnection = dialogueFrameUI.accept.Activated:connect(function()
				self:acceptQuestRewardsButtonActivated(self.questData.objectives[self.currentQuestObjective].handerNpcName)				
			end)
			--dialogueFrameUI.cancel.Visible				= true
		elseif self.currentDialogueData.taxiMenu then
			dialogueFrameUI.accept.Visible 					= false
			dialogueFrameUI.cancel.Visible				= false
--			createResponseButton("X")

			dialogueFrameUI.contents.rewards.Visible = false
			dialogueFrameUI.contents.taxi.Visible = true												
		else
			dialogueFrameUI.accept.Visible 					= false
			dialogueFrameUI.cancel.Visible				= false

			dialogueFrameUI.contents.rewards.Visible = false
			dialogueFrameUI.contents.taxi.Visible = false
			dialogueFrameUI.contents.rewards.contents.Size 	= UDim2.new(0, 0, 0, 0)
			dialogueFrameUI.contents.rewards.Size 			= UDim2.new(0, 0, 0, 0)
			
			if self.currentDialogueData.options then
				-- iterate through all responses and create buttons
				for i, dialogueData in pairs(self.currentDialogueData.options) do
					local doSkipShowing 		= false
					local isQuestDecisionPrompt = false
					local textToDisplay
					local questState
					local questData
					local currentQuestObjective
					
					if dialogueData.questId then
						questData = questLookup[dialogueData.questId]
						
						if questData and questData.dialogueData then
							dialogueData 	= questData.dialogueData
							questState 		= getPlayerQuestStateByQuestId(questData.id)
							currentQuestObjective = getPlayerQuestObjectiveByQuestId(questData.id)
							
							local objectiveStarted = checkIfObjectiveStartedByQuestId(questData.id)
							
							local objectiveName = questData.objectives[currentQuestObjective].objectiveName
							
							
							
							-- for multiple npc handling
							
							local flagForQuest = self.currentDialogueData.flagForQuest
							if type(flagForQuest) == "function" then
								flagForQuest = flagForQuest(utilities, self.extraData)	
							end
							
							local currentObjectiveAndStarted = questUtil.getQuestObjectiveAndStarted(self.currentDialogueData.flagForQuest)
				
							local canContinue = true
							
							
							local objectiveChoiceTable = self.currentDialogueData.getObjectiveOptionsTable(utilities, self.extraData)
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
							
							
							
							
		
								if questState == mapping.questState.completed then
									doSkipShowing = true
								elseif questState == mapping.questState.unassigned or not objectiveStarted then
									textToDisplay = "[Quest] " .. objectiveName
								elseif questState == mapping.questState.active then
									textToDisplay = "[In-progress] " .. objectiveName
								elseif questState == mapping.questState.handing or questState == mapping.questState.objectiveDone then
									textToDisplay = "[Complete] " .. objectiveName
								end
							
							end
						end
					else
						
						-- check if the nextObjective has been started
						
						local forceDisplayQuest = false
						local currentObjective
						local fixed_response_unassinged = "response_unassigned"
						local fixed_response_unassinged_accept = "response_unassigned_accept"
						local fixed_response_unassinged_decline = "response_unassigned_decline"
						local fixed_response_active = "response_active"
						if self.questData and self.currentQuestObjective then
							forceDisplayQuest = not checkIfObjectiveStartedByQuestId(self.questData.id) 
							currentObjective = self.currentQuestObjective
							fixed_response_unassinged = fixed_response_unassinged.."_"..currentObjective
							fixed_response_unassinged_accept = fixed_response_unassinged_accept.."_"..currentObjective
							fixed_response_unassinged_decline = fixed_response_unassinged_decline.."_"..currentObjective
							fixed_response_active = fixed_response_active.."_"..currentObjective
						end
						
						if self.questState then
							if forceDisplayQuest then
								if dialogueData[fixed_response_unassinged_accept] and dialogueData[fixed_response_unassinged_decline] then
									
									isQuestDecisionPrompt = true
								elseif dialogueData[fixed_response_unassinged] then
									textToDisplay = dialogueData[fixed_response_unassinged]
								else
									doSkipShowing = true
								end
							
							elseif self.questState == mapping.questState.handing then -- obsolete
								textToDisplay = dialogueData.response_handing
							elseif self.questState == mapping.questState.active then
								textToDisplay = dialogueData[fixed_response_active]
							elseif self.questState == mapping.questState.unassigned then
								
								if dialogueData[fixed_response_unassinged_accept] and dialogueData[fixed_response_unassinged_decline] then
									
									isQuestDecisionPrompt = true
								elseif dialogueData[fixed_response_unassinged] then
									textToDisplay = dialogueData[fixed_response_unassinged]
								else
									doSkipShowing = true
								end
							elseif self.questState == mapping.questState.completed then
								doSkipShowing = true
							end
						else
							
							textToDisplay = dialogueData.response
						end
					end
					
					if not doSkipShowing and (textToDisplay or isQuestDecisionPrompt) then
						if isQuestDecisionPrompt then
							
							local acceptText = "response_unassigned_accept"
							local declineText = "response_unassigned_decline"
							if self.currentQuestObjective then
								acceptText = "response_unassigned_accept".."_"..self.currentQuestObjective
								declineText = "response_unassigned_decline".."_"..self.currentQuestObjective
							end
							
							createResponseButton(dialogueData[acceptText], dialogueData, questState, questData, nil, nil, currentQuestObjective)
							createResponseButton(dialogueData[declineText], dialogueData, questState, questData, nil, nil, currentQuestObjective)
						else
							createResponseButton(textToDisplay, dialogueData, questState, questData, nil, nil, currentQuestObjective)
						end
					end
				end
			end
		end
	
		dialogueFrameUI.contents.next.Visible = false

		if not isOnLastDialogue then
			dialogueFrameUI.contents.options.Visible = false
			dialogueFrameUI.contents.next.Visible = true
			dialogueFrameUI.contents.next.inner.Text = "→"
			dialogueFrameUI.contents.next.tooltip.Value = "Next"
			table.insert(self.events, dialogueFrameUI.contents.next.Activated:connect(function()
				self:startDialogue(trueDialogueNumber + 1)
			end))		
		elseif responseButtonCount > 0 then

			dialogueFrameUI.contents.options.Visible = true
			dialogueFrameUI.contents.next.Visible = false
			
			if self.currentDialogueData.canExit and (not self.questState or (self.questState ~= mapping.questState.handing and self.questState ~= mapping.questState.objectiveDone)) then
				createResponseButton("X")
			end			
			
		elseif self.currentDialogueData.moveToId then
				
			local newDialogueData = getDialogueDataById(superRootDialogueData, self.currentDialogueData.moveToId )

			if newDialogueData then

				dialogueFrameUI.contents.options.Visible = false
				dialogueFrameUI.contents.next.Visible = true
				dialogueFrameUI.contents.next.inner.Text = "→"	
				dialogueFrameUI.contents.next.tooltip.Value = "Next"		
				-- oh boy
				table.insert(self.events, dialogueFrameUI.contents.next.Activated:connect(function()
		
					-- stop any ongoing dialogue
					dialogueHandler:stopDialogue()
					
					-- set dialogueData to new dialogueData
					dialogueHandler:setDialogue(newDialogueData)

					-- show new dialogueData root
					dialogueHandler:startDialogue(nil, questResponseType)	
				end))			
					
			else
				dialogueFrameUI.contents.options.Visible = false
				dialogueFrameUI.contents.next.Visible = true
				dialogueFrameUI.contents.next.inner.Text = "X"
				dialogueFrameUI.contents.next.tooltip.Value = "Exit"
				table.insert(self.events, dialogueFrameUI.contents.next.Activated:connect(function()
					module.endDialogue()
					Modules.interaction.stopInteract()
				end))						
			end
		elseif not self.questState or self.questState ~= mapping.questState.handing then
			dialogueFrameUI.contents.options.Visible = false
			dialogueFrameUI.contents.next.Visible = true
			dialogueFrameUI.contents.next.inner.Text = "X"
			dialogueFrameUI.contents.next.tooltip.Value = "Exit"
			table.insert(self.events, dialogueFrameUI.contents.next.Activated:connect(function()
				module.endDialogue()
				Modules.interaction.stopInteract()
			end))		
		end
		
		yOffset_dialogue = yOffset_dialogue + yOffset_options
		
		-- update size!
		dialogueFrameUI.contents.options.Size = UDim2.new(1, 0, 0, yOffset_options + 42)
		dialogueFrameUI.bottom.Size = UDim2.new(1,0,0,yOffset_options + 52)
		dialogueFrameUI.bottom.Visible = true
		
		local tYSize = 0
		for i, obj in pairs(dialogueFrameUI.contents:GetChildren()) do
			if obj:IsA("GuiObject") and obj.Visible then
				local size = obj.Size.Y.Offset
				if size > 0 then
					tYSize = tYSize + size + dialogueFrameUI.contents.UIListLayout.Padding.Offset
				end
			end
		end
		
		dialogueFrameUI.Size = UDim2.new(0, 400, 0, tYSize + 36)
--		dialogueFrameUI.Position = UDim2.new(0.5, 0, 1, - (150 + dialogueFrameUI.Size.Y.Scale/2)) 
		
		dialogueFrameUI.Visible = false
	
		inputUpdate()
		Modules.focus.toggle(dialogueFrameUI)
		
		if Modules.input.mode.Value == "xbox" and (game.GuiService.SelectedObject == nil or not game.GuiService.SelectedObject:IsDescendantOf(dialogueFrameUI)) then
			game.GuiService.SelectedObject = Modules.focus.getBestButton(dialogueFrameUI.contents)
		end
		
	end
	
	function dialogueHandler:setSpeaker(speaker)
		-- body
		
		self.speaker = speaker
	end
	
	
	
	
	function module.beginDialogue(triggerPart, dialogueData)
		dialogueHandler.questState 	= nil
		dialogueHandler.questData 	= nil
		
		-- stop any ongoing dialogue
		dialogueHandler:stopDialogue()
		
		-- set dialogueData to new dialogueData
		dialogueHandler:setDialogue(dialogueData)
		
		-- set speaker if there
		if triggerPart then
			local rootPart = triggerPart.Parent:FindFirstChild("HumanoidRootPart")
			if rootPart and rootPart.Parent:IsA("Model") then
--				network:invoke("lockCameraTarget", triggerPart.Parent.HumanoidRootPart)
				local pos = rootPart.Position + rootPart.CFrame.lookVector * 3.5 + Vector3.new(0,1.75,0)
				local lookat = rootPart.Position + Vector3.new(0,1.25,0)
				local camCf = CFrame.new(pos, lookat)
				network:invoke("lockCameraPosition",camCf--[[,0.5]])
			end
			
			dialogueHandler:setSpeaker(triggerPart.Parent)
		end
		
		superRootDialogueData = dialogueData
	

		
		-- show new dialogueData root
		network:invoke("setCharacterArrested", true)
		dialogueHandler:startDialogue()


		for i,child in pairs(dialogueFrameUI:GetDescendants()) do
			if child:IsA("TextLabel") or child:IsA("TextButton") then
				child.TextScaled = false
				child.TextWrapped = false
			end
		end
		--[[
		dialogueFrameUI.UIScale.Scale = 0.8
		Modules.tween(dialogueFrameUI.UIScale, {"Scale"}, 1, 0.5, Enum.EasingStyle.Bounce)	
		]]
	end
	
	network:create("beginDialogue","BindableFunction","OnInvoke",module.beginDialogue)
	
	function module.endDialogue()
		
		dialogueFrameUI.Visible = false
		
		if globalOnClose then
			globalOnClose(utilities, dialogueHandler.extraData)
			globalOnClose = nil
		end	
		
		network:invoke("lockCameraTarget", nil)	
		
		dialogueHandler:stopDialogue()
		superRootDialogueData = nil
		network:invoke("setCharacterArrested", false)
	end
end



return module