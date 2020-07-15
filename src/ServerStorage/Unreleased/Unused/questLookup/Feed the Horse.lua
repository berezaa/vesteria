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
	id = 5;
	QUEST_VERSION = 1;
	
	questLineName = "Feed Old Sally";
	questLineImage = "";
	questLineDescription = "Farmer Sam needs my help to feed his horse, Old Sally. I need to collect Hay from the Scarecrows.";
--	questLineRequirements = "I must be level 11 to start this quest.";
	questEndedNote = "I can return to Farmer Sam later to feed Old Sally.";
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = true, timeInterval = 60*60*8}; 
	requireClass = nil;
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 13;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Farmer Sam";
			handerNpcName = "Farmer Sam";
			
			-- What the quest will appear as
			objectiveName = "Feed Old Sally";
			-- Instructions that will display after quest is complete
			completedText = "Return to Farmer Sam.";
			completedNotes = "Return to Farmer Sam";
			handingNotes = "Quest completed!";
			
			
			-- rewards data
			level 		= 15;
			expMulti 	= 1.2;
			goldMulti 	= 1.5;
			rewards 	= {
				{id = 89; stacks = 20;};
				{id = 88; stacks = 20;};
			};
			
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id 		= 86;
						amount 	= 50;
					};
				};
			};
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
		
		dialogue_unassigned_1	= {{text = "Look at my poor horse here, Old Sally's wasting away- almost starved to death surely! Could you be a pal and help me feed her?"}};
		dialogue_active_1 		= {{text = "Please get the hay, my Old Sally isn't going to make it much longer. Get it back from those cursed scarecrows!"},{text = "(Gather 50 hay)"; font = Enum.Font.SourceSansBold}};
		dialogue_objectiveDone_1 		= {{text = "Thanks kind stranger! It looks like Old Sally is going to just make it. But she'll need to eat again tomorrow..."}};
		
		
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "Ok, I'll help";
				response_unassigned_decline_1 = "She looks fine";
				
				dialogue_unassigned_accept_1 	= {{text = "Now that's a lad! Gather 50 hay from those darn scarecrows around here and my little darling might just make it."}};
				dialogue_unassigned_decline_1  = {{text = "But she'll starve for sure!"}};
				
			}
		};
	}
}