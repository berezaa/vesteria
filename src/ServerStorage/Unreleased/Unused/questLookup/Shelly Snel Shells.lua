local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local mapping = modules.load("mapping")
	
	
--[[
	Structure:
	
	Questline (that's this script)
		Objective/Quest
			Step1
			Step2
			...
		Objective/Quest
			Step1
			...
--]]


return {
	-- identifying data
	id = 16;
	QUEST_VERSION = 1;
	
	questLineName = "Shelly's Snel Shells";
	questLineImage = "";
	questLineDescription = "Shelly sells Snel Shells by the sea shore, but she's sold out of shells.";
	--questLineRequirements = "I must be level 7 to start this quest.";
	
	questEndedNote = "If I bring Shelly more Snel Shells she will trade me for them.";
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = false, timeInterval = 0}; 
	requireClass = nil;
	
	
	
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 17;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Shelly";
			handerNpcName = "Shelly";
			
			-- What the quest will appear as
			objectiveName = "Shelly's Snel Shells";
			-- Instructions that will display after quest is complete
			completedText = "Return to Shelly.";
			
			completedNotes = "Now that I have the Snel Shells I should return to Shelly by the sea shore.";
			handingNotes = "Quest completed!";
			
			
			
			-- rewards data
			level 		= 19;
			expMulti 	= 1;
			goldMulti 	= 1;
			rewards 	= {
				
				{id = 150; stacks = 1};
				
			};
		
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id =      168;
						amount 	= 1;
					};
					
					
				};
				{
					triggerType = "item-collected";
					requirement = {
						id =      169;
						amount 	= 1;
					};
					
					
				};
				{
					triggerType = "item-collected";
					requirement = {
						id =      170;
						amount 	= 1;
					};
					
					
				};
				{
					triggerType = "item-collected";
					requirement = {
						id =      171;
						amount 	= 1;
					};
					
					
				};
				
				
			};
			
			localOnFinish = function(utilities)
				
					if workspace:FindFirstChild("SnelShopDisplay") then
						for i, child in pairs(workspace:FindFirstChild("SnelShopDisplay"):GetChildren()) do
							child.Transparency = 0
							child.CanCollide = true
						end
					end
			end
			
		};
	};
	
	-- dialogue
	dialogueData = {
		-- refers to the npc response of above\\
		-- these are the first responses you get from the npc
		--[[
			Some notes on the changes:
				the _number at the end of each field represents which objective the player is on. you can now write specific dialogue for a current objective/npc in the quest
				handing as a quest state has been replaced with objectiveDone
	--]]
	-- gold for quests
		responseButtonColor = Color3.fromRGB(255, 207, 66);		
		
		
		dialogue_unassigned_1	= {{text = "Hello! My name is Shelly and I sell Snel Shells. But I have a problem... I'm sold out of shells! Would you help me out and get me some more?"}};
		
		-- switch to timmy
		dialogue_active_1 		= {{text = "Did you get those Snel Shells yet?"}}; 
		dialogue_objectiveDone_1 		= {{text = "Yay, my shells! Thanks friend. Hey... I have an idea. These shells sell faster then you can say \"Shelly sells Snel Shells by the sea shore\"! I'll always need more Snel Shells, and if you bring them to me I'll trade you for them!"}};
		
		
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "Sure";
				response_unassigned_decline_1   = "Sorry, no";
				
				dialogue_unassigned_accept_1 	= {{text = "Great! The shells I sell are rare and only found in Shiprock Bottom. If you bring me some I'll have my Snel Shell stand up and running again!"}};
				dialogue_unassigned_decline_1  = {{text = "Aw shucks."}};
				
			}
		};
	}
}