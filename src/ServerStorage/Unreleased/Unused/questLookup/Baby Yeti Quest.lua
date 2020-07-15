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
	id = 17;
	QUEST_VERSION = 2;
	
	questLineName = "Mountain Patrol";
	questLineImage = "";
	questLineDescription = "Baby Yeti's may be cute... but have you seen a full grown Yeti?";
	--questLineRequirements = "I must be level 7 to start this quest.";
	
	questEndedNote = "I can return to Sid at a later time to patrol the mountain again.";
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = true, timeInterval = 8*60*60}; 
	requireClass = nil;
	
	
	
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 11;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Sid";
			handerNpcName = "Sid";
			
			-- What the quest will appear as
			objectiveName = "Mountain Patrol";
			-- Instructions that will display after quest is complete
			completedText = "Return to Sid.";
			
			completedNotes = "Now that I have slayed the Baby Yetis I should return to Sid.";
			handingNotes = "Quest completed!";
			
			
			-- rewards data
			level 		= 12;
			expMulti 	= 1.2;
			goldMulti 	= 1.4;
			rewards 	= {
				
				{id = 70; stacks = 20};
				
			};
		
			steps = {
				{
					triggerType = "monster-killed";
					requirement = {
						monsterName = "Baby Yeti";
						amount 	= 30;
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
		
		
		dialogue_unassigned_1	= {{text = "The Baby Yetis may be cute... but have you seen what they grow up to be? A full-grown yeti is too great of a danger to those on Redwood Pass. Will you help the cause and battle the Baby Yetis?"}};
		
		-- switch to timmy
		dialogue_active_1 		= {{text = "Are you battling the Baby Yetis?"}}; 
		dialogue_objectiveDone_1 		= {{text = "Your efforts have helped maintain the balance of the mountain. Come back later if you wish to help again."}};
		
		
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "Ok";
				response_unassigned_decline_1   = "I will not";
				
				dialogue_unassigned_accept_1 	= {{text = "Defeat 30 Baby Yetis and return to me."}};
				dialogue_unassigned_decline_1  = {{text = "That is unfortunate."}};
				
			}
		};
	}
}