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
	id = 11;
	QUEST_VERSION = 2;
	
	questLineName = "Innkeeper's Son";
	questLineImage = "";
	questLineDescription = "Innkeeper Edith has asked me to venture to the city Nilgarf and find her son, Streisand, who is the city barber.";
	--questLineRequirements = "I must be level 7 to start this quest.";
	
	
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = false, timeInterval = 0}; 
	requireClass = nil;
	
	
	
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 6;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Innkeeper Edith";
			handerNpcName = "Barber Streisand";
			
			-- What the quest will appear as
			objectiveName = "Innkeeper's Son";
			-- Instructions that will display after quest is complete
			completedText = "Talk to Barber Streisand.";
			
			completedNotes = "Talk to Barber Streisand";
			handingNotes = "Quest completed!";
			
			
			-- rewards data
			level 		= 14;
			expMulti 	= 0;
			goldMulti 	= 1.5;
			rewards 	= {
				{id = 116; stacks = 2};
				--{id = 14};
			};
			hideAlert = true;
			steps = {
				{
					triggerType = "found-timmy";
					requirement = {
						
						amount 	= 1;
					};
					--hideAlert = true;
					hideNote  = true;
					
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
		
		
		dialogue_unassigned_1	= {{text = "My dearest son Streisand left home for the city of Nilgarf to make it big as a barber. He hasn't written back in a while, and I miss him so much. If your travels ever take you to Nilgarf, might you find Streisand and ask him to write his mother?"}};
		
		-- switch to timmy
		dialogue_active_1 		= {{text = ""}}; -- shouldn't trigger
		dialogue_objectiveDone_1 		= {{text = "My mother asked you to find me? Lots of customers lately, I've been so busy. I'll surely write to her. Here's something for your troubles."}};
		
		
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "Sure";
				response_unassigned_decline_1   = "Can't";
				
				dialogue_unassigned_accept_1 	= {{text = "Thank you deary, I hope you make it to Nilgarf alright."}};
				dialogue_unassigned_decline_1  = {{text = "I miss my boy."}};
				
			}
		};
	}
}