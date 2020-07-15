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
	id = 18;
	QUEST_VERSION = 1;
	
	questLineName = "Spider Fighter";
	questLineImage = "";
	questLineDescription = "The Spider vs. Goblin conflict rages on. I guess I'll help the Goblins.";
	--questLineRequirements = "I must be level 7 to start this quest.";
	
	questEndedNote = "I can complete this quest everyday.";
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = true, timeInterval = 8*60*60}; 
	requireClass = nil;
	
	
	
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 14;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Spider guy";
			handerNpcName = "Spider guy";
			
			-- What the quest will appear as
			objectiveName = "Spider Fighter";
			-- Instructions that will display after quest is complete
			completedText = "Return to spider guy";
			
			completedNotes = "Now that I have slayed the Spiders I should return to spider guy.";
			handingNotes = "Quest completed!";
			
			
			-- rewards data
			level 		= 14;
			expMulti 	= 1;
			goldMulti 	= 1;
			rewards 	= {
				
				--{id = 150; stacks = 1};
				
			};
		
			steps = {
				{
					triggerType = "monster-killed";
					requirement = {
						monsterName = "Spider";
						amount 	= 25;
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
		
		
		dialogue_unassigned_1	= {{text = "Hey, hey you de humanling. You know how I got des scar? De Spidos. Humanling, I need you to join de good fight against de Spiders."}};
		
		-- switch to timmy
		dialogue_active_1 		= {{text = "You fight de Spiders, yes?"}}; 
		dialogue_objectiveDone_1 		= {{text = "You showed the Spiders who is de boss. Come back later to show de Spidos who is de boss, again. GOBLINS RULE!"}};
		
		
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "Bye bye Spiders";
				response_unassigned_decline_1   = "I don't trust Goblins";
				
				dialogue_unassigned_accept_1 	= {{text = "Goblins are de best, Spiders not de good ones. Get rid of 25 of dem."}};
				dialogue_unassigned_decline_1  = {{text = "We have a lover of de Spiders over here! GET OUT OF ME SIGHT!"}};
				
			}
		};
	}
}