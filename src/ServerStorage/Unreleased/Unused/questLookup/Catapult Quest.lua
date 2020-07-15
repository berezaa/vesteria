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
	id = 15;
	QUEST_VERSION = 3;
	
	questLineName = "Catapult Mechanic";
	questLineImage = "";
	questLineDescription = "The catapult at the Redwood Pass Warrior camp is broken. I'll fix it.";
	--questLineRequirements = "I must be level 7 to start this quest.";
	
	
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = false, timeInterval = 0}; 
	requireClass = nil;
	
	
	
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 13;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Captain Bronzeheart";
			handerNpcName = "Captain Bronzeheart";
			
			-- What the quest will appear as
			objectiveName = "Catapult Mechanic";
			-- Instructions that will display after quest is complete
			completedText = "Talk to Captain Bronzeheart.";
			
			completedNotes = "Talk to Captain Bronzeheart";
			handingNotes = "Quest completed!";
			
			
			-- rewards data
			level 		= 14;
			expMulti 	= .4;
			goldMulti 	= 1;
			rewards 	= {
				
				{id = 150; stacks = 1};
				
			};
		
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id =      143;
						amount 	= 1;
					};
					
					
				};
				
				
			};
			
			localOnFinish = function(utilities)
				
					if workspace:FindFirstChild("Catapult") then
						workspace:FindFirstChild("Catapult").FrontBowl.manifest.Transparency = 0
						workspace:FindFirstChild("Catapult").FrontBowl.manifest.CanCollide = true
						
						workspace:FindFirstChild("Catapult").FrontBowl.manifest.dec1.Transparency = 0
						workspace:FindFirstChild("Catapult").FrontBowl.manifest.dec1.CanCollide = true
						
						workspace:FindFirstChild("Catapult").FrontBowl.manifest.dec2.Transparency = 0
						workspace:FindFirstChild("Catapult").FrontBowl.manifest.dec2.CanCollide = true
						
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
		
		
		dialogue_unassigned_1	= {{text = "At ease, private. We had a little accident with our catapult here. Whole thing is fried. It runs on 100% renewable Guardian Core energy though, should be an easy fix. We just need a single Guardian Core and this puppy will be back up and running and no time. Would you fetch us a core?"}};
		
		-- switch to timmy
		dialogue_active_1 		= {{text = "Did you find that Guardian Core yet?"}}; -- shouldn't trigger
		dialogue_objectiveDone_1 		= {{text = "You have the core? Fantastic work, soldier. In return for your contribution, my troops will let you use the catapult to fling yourself free of charge. Really an underrated mode of transportation if you ask me."}};
		
		
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "Will do";
				response_unassigned_decline_1   = "Negative";
				
				dialogue_unassigned_accept_1 	= {{text = "That's what I like to hear! Just politely, uh, \"ask\" one of the Guardians if they'll let you borrow one of their cores."}};
				dialogue_unassigned_decline_1  = {{text = "Well in that case, scram!"}};
				
			}
		};
	}
}