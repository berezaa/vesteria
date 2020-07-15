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
	id = 25;
	QUEST_VERSION = 1;
	
	questLineName = "Abigail's Apples";
	questLineImage = "";
	questLineDescription = "Abigail is STARVING for some fresh fruit!";
	--questLineRequirements = "I must be level 7 to start this quest.";
	
	questEndedNote = "Abigail liked them apples.";
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = false}; 
	requireClass = nil;
	
	
	
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 2;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Abigail";
			handerNpcName = "Abigail";
			
			-- What the quest will appear as
			objectiveName = "Abigail's Apples";
			-- Instructions that will display after quest is complete
			completedText = "Return to Abigail.";
			
			completedNotes = "I should return to Abigail with the Apples.";
			handingNotes = "Quest completed!";
			
			
			-- rewards data
			level 		= 2;
			expMulti 	= 1.5;
			goldMulti 	= 0;
			rewards 	= {				
			};
		
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id = 226;
						amount 	= 12;
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
		
		
		dialogue_unassigned_1	= {{text = "Hiya Adventurer! Say, you look mighty brave, can ya emark on a PERILOUS QUEST for lil ol' Abigail?"}};
		
		-- switch to timmy
		dialogue_active_1 		= {{text = "Hey, I'm starving! You got those Apples? No I don't know where you can find apples, that's your job!"}}; 
		dialogue_objectiveDone_1 		= {{text = "Oh my those apples are so crisp, and shiny!! My tummy is rumbling hand them over!!"}};
		
		
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "Can do";
				response_unassigned_decline_1   = "Get your own apples.";
				
				dialogue_unassigned_accept_1 	= {{text = "Aaaa thank you so much!! Please find two... no three... no a DOZEN apples for me! You can do it, I believe in you!!"}};
				dialogue_unassigned_decline_1  = {{text = "Hmmph!!"}};
				
			}
		};
	}
}