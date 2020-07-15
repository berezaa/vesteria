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
	id = 19;
	QUEST_VERSION = 2; -- removed from quest rotation, cannot be started anymore
	
	questLineName = "Ruth's Revenge";
	questLineImage = "";
	questLineDescription = "Ruth got roughed up by a \"giant\" Baby Shroom. I should be on the lookout for one.";
	--questLineRequirements = "I must be level 7 to start this quest.";
	
	questEndedNote = "I can complete this quest everyday.";
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = false}; 
	requireClass = nil;
	
	
	
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 1;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Rough Ruth";
			handerNpcName = "Rough Ruth";
			
			-- What the quest will appear as
			objectiveName = "Ruth's Revenge";
			-- Instructions that will display after quest is complete
			completedText = "Return to Rough Ruth.";
			
			completedNotes = "Now that I have slayed the Giant Baby Shroom, I should return to Rough Ruth with the news.";
			handingNotes = "Quest completed!";
			
			
			-- rewards data
			level 		= 2;
			expMulti 	= 1;
			goldMulti 	= 1;
			rewards 	= {
				
				--{id = 150; stacks = 1};
				
			};
		
			steps = {
				{
					triggerType = "monster-killed";
					requirement = {
						monsterName = "Baby Shroom";
						amount 	= 1;
						isGiant = true;
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
		
		
		dialogue_unassigned_1	= {{text = "There's this Giant Baby Shroom. A cruel, heartless creature. It ambushed me on the road. I've never seen a Baby Shroom like it before, it was GIANT! None of the townsfolk believe me, they all think I'm fibbing."}};
		
		-- switch to timmy
		dialogue_active_1 		= {{text = "You take care of that Giant Baby Shroom yet? You might need to wait around for it to come out."}}; 
		dialogue_objectiveDone_1 		= {{text = "I told you I wasn't lying about that Giant Baby Shroom! Rough Ruth ain't no fibber!"}};
		
		
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "I'll slay it.";
				response_unassigned_decline_1   = "No way! You're fibbing!";
				
				dialogue_unassigned_accept_1 	= {{text = "You?? Slay that THING? Now that's something I'd like to see! Be on the lookout for a massive Baby Shroom. If you wait long enough, you should be able to spot it."}};
				dialogue_unassigned_decline_1  = {{text = "I TOLD YA, ROUGH RUTH AIN'T NO FIBBER!"}};
				
			}
		};
	}
}