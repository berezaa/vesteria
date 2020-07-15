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
	id = 22;
	QUEST_VERSION = 1;
	
	questLineName = "The Lost Palace";
	questLineImage = "";
	questLineDescription = "Dr. Henry Bones' son, Mississippi Bones, has gone missing somewhere in The Whispering Dunes.";
	--questLineRequirements = "I must be level 7 to start this quest.";
	
	--questEndedNote = "I can now talk to Lieutenant Venessa to wear the scout uniform.";
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = false}; 
	--requireClass = "Hunter";
	
	
	
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 35;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName =  "Dr. Henry Bones";
			handerNpcName = "Dr. Henry Bones";
			
			-- What the quest will appear as
			objectiveName = "The Lost Palace";
			-- Instructions that will display after quest is complete
			completedText = "Deliver the bad news to Dr. Henry Bones.";
			
			completedNotes = "I found Mississippi but a mysterious entity disintegrated him before I could save him from his madness. I'd best be on the lookout for Tal-rey in the future...";
			handingNotes = "Quest completed!";
			
			
			-- rewards data
			level 		= 35;
			expMulti 	= 2;
			goldMulti 	= 3;
			rewards 	= {
				
				--{id = 150; stacks = 1};
				
			};
		
			steps = {
				{
					triggerType = "open-surface-door-temple";
					requirement = {
						amount 	= 1;
					};
					isSequentialStep = true;
					overridingNote = "Find the place Mississippi Bones mentioned in his journal."
				};
				
				{
					triggerType = "find-mississippi";
					requirement = {
						amount 	= 1;
					};
					isSequentialStep = true;
					overridingNote = "Find Mississippi Bones in the palace.";
				};
				
				{
					triggerType = "expose-mississippi",
					requirement = {
						amount = 1,
					},
					isSequentialStep = true,
					overridingNote = "Mississippi's gone mad. Talk him out of it. Could a complete journal help convince him?"
				},
				
				{
					triggerType = "place-vase";
					requirement = {
						amount 	= 1;
					};
					isSequentialStep = true;
					overridingNote = "Pass Tal-rey's test.";
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
		
		
		dialogue_unassigned_1	= {{text = "Hello there young chap. Say... what do you have there? An old tattered notebook... that looks quite familiar indeed! That... that looks like it belongs to my boy, Mississipi Bones! I'm... I'm afraid he's gone missing, and I haven't the idea where he's ran off to this time..."}};
		
		-- switch to tal-rey
		dialogue_active_1 = {{text = "Have you found my son, yet?"}}; 
		dialogue_objectiveDone_1 = {{text = "Oh, no... that's grave news, indeed. Well, thank you for telling me. As thanks, I will send word to the museum in the Whispering Dunes that you are allowed to purchase artifacts and equipment."}};
		
		
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				response_unassigned_accept_1 	= "I'll find him!";
				response_unassigned_decline_1   = "Boooriiing...";
				
				dialogue_unassigned_accept_1 	= {{text = "Fantastic! That's a chap! Bravo! My boy and I set up out there in the Dunes to study its secrets. There might be some clues of where he's ran off to in his notebook you found. Keep it to aid in your search! Best of luck to you! I'm not sure I'd be any more of help to you, I've told you all I know."}};
				dialogue_unassigned_decline_1  = {{text = "Be on your way then!"}};
			}
		};
	}
}