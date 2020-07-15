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
	id = 20;
	QUEST_VERSION = 1;
	
	questLineName = "Eye See Snels";
	questLineImage = "";
	questLineDescription = "Randy wants some Snel Eyes for his collection.";
	--questLineRequirements = "I must be level 7 to start this quest.";
	
	questEndedNote = "I can return to Randy later with more Snel Eyes.";
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = true, timeInterval = 4*60*60}; 
	requireClass = nil;
	
	
	
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 15;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Randy";
			handerNpcName = "Randy";
			
			-- What the quest will appear as
			objectiveName = "Eye See Snels";
			-- Instructions that will display after quest is complete
			completedText = "Return to Randy.";
			
			completedNotes = "I should return to Randy with the Snel Eyes.";
			handingNotes = "Quest completed!";
			
			
			-- rewards data
			level 		= 17;
			expMulti 	= 1;
			goldMulti 	= 1;
			rewards 	= {
				{id = 89; stacks = 14;};
				{id = 88; stacks = 14;};
				--{id = 150; stacks = 1};
				
			};
		
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id = 182;
						amount 	= 60;
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
		
		
		dialogue_unassigned_1	= {{text = "Hiya pal! I really really really like Snel Eyes! Hey pal, would you gather some to add to my collection?"}};
		
		-- switch to timmy
		dialogue_active_1 		= {{text = "Hey pal! Are you gathering the Snel Eyes for my collection?"}}; 
		dialogue_objectiveDone_1 		= {{text = "Gee wiz, you rule! Thanks for the Snel Eyes pal, they'll fit perfectly in my collection! If you want to gather more, I'll accept them later."}};
		
		
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "Ok";
				response_unassigned_decline_1   = "Weirdo";
				
				dialogue_unassigned_accept_1 	= {{text = "Thanks pal! Would you mind collecting 60 of them?"}};
				dialogue_unassigned_decline_1  = {{text = "Hey pal, what was that for?"}};
				
			}
		};
	}
}