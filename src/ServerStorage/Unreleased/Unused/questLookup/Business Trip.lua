local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local mapping = modules.load("mapping")
	local network 			= modules.load("network")
	local utilities			= modules.load("utilities")
	
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
	id = 14;
	QUEST_VERSION = 3;

	questLineName = "Business Trip";
	questLineimage = "";
	questLineDescription = "Albert Figgleglasses has asked me to tend to his plant while he's away for business.";
	--questLineRequirements = "I must be level 8 to start this quest.";
	
	--questEndedNote = "Mobeus gave me his pocketwatch to return to his brother in Nilgarf. Maybe if I give it to him I will get a reward.";
	
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = false, timeInterval = 0}; 
	requireClass = nil;
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 8;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Albert Figgleglasses";
			handerNpcName = "Mr. Plant";
			
			-- What the quest will appear as
			objectiveName = "Business Trip";
			-- Instructions that will display after quest is complete
			completedText = "Talk to Mr. Plant.";
			
			
			completedNotes = "I should talk to Mr. Plant.";
			handingNotes = "Mr. Plant has a special task for me...";
			
			
			
			-- rewards data
			level 		= 9;
			expMulti 	= 1;
			goldMulti 	= 0;
			rewards 	= {
				{id = 72; stacks = 12};
			};
	
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id = 147; 
						amount 	= 40;
					};
				
				};
				{
					triggerType = "found-mrplant";
					requirement = {
						amount 	= 1;
						
					};
					isSequentialStep = true;
					overridingNote = "I must find Albert Figgleglasses' home at the Tree of Life. He said his house has a red roof.";
					--hideAlert = true;
					--hideNote  = true;
				};
			};
			
		};
		
		{
			-- Objective requirements
			requireLevel = 8;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Mr. Plant";
			handerNpcName = "Mr. Plant";
			
			-- What the quest will appear as
			objectiveName = "Business Trip Part 2";
			-- Instructions that will display after quest is complete
			completedText = "Return to Mr. Plant.";
			
			
			completedNotes = "Now that Mrs. Plant is happy, I should return to Mr. Plant.";
			handingNotes = "";
			
			
			
			-- rewards data
			level 		= 9;
			expMulti 	= .4;
			goldMulti 	= 2;
			rewards 	= {
				{id = 26; stacks = 1};
				
				{id = 58; stacks = 1};
			};
			
			steps = {
				{
					triggerType = "talk-mrsplant-1";
					requirement = {
						amount 	= 1;
					};
					overridingNote = "Talk to Mrs. Plant next door to Mr. Plant."
				};
				{
					triggerType = "collect-plant";
					requirement = {
						amount 	= 1;
					};
					isSequentialStep = true;
					overridingNote = "Find a purple sparkly Magic Flower near the Tree of Life."
				};
				
				{
					triggerType = "talk-mrsplant-2";
					requirement = {
						amount 	= 1;
					};
					isSequentialStep = true;
					overridingNote = "Return to Mrs. Plant with the Magic Flower."
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
		
		dialogue_unassigned_1	= {{text = "oh no! i forgot to feed my plant! silly figgleglasses! would you be a pal and visit my house to take care of him?"}};
		
		-- Mr. Plant
		dialogue_active_1 		= {{text = "Me want food! If me no get tasty Goblin Ear to eat me EAT YOU AND MISTER FIGGLEGLASSES TOO!"}}; --hi mister! did you visit my home in [Mage City] to feed my plant?
		dialogue_objectiveDone_1 		= {{text = "YUM GOBLIN EAR! ME BIG HUNGRY! NOM NOM NOM! Ok, me full. But me have one more favor to ask you."}};
		
		
		
		
			
			
		dialogue_unassigned_2	= {{text = "Me girlfriend Mrs. Plant real mad at me. Me don't know why. Me wants you to ask her why and make her happy for me, ok? Me too busy."}};
	
	
		dialogue_active_2 		= {{text = "Me don't know why Mrs. Plant mad at me. Me needs you to make her happy for me."}};
		dialogue_objectiveDone_2 		= {{text = "Mrs. Plant no longer mad at me? Me says yay! Me didn't even have to do anything. Me stole some stuff from mister Figgleglasses that me wants you to have. Me says thank you!"}};
		
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "Sure thing little guy";
				response_unassigned_decline_1 = "Haha! You're so tiny!";
				
				dialogue_unassigned_accept_1 	= {{text = "yay! while you're here, grab 40 ears from those funny goblins! it's the only thing mr. plant will eat. after you collect the ears, you must travel all the way through enchanted forest to my house at the tree of life. my house has a red roof!"}};
				dialogue_unassigned_decline_1  = {{text = "ouchie! little guys have feelings to you know."}};
					
				
				
			
			
				response_unassigned_accept_2 	= "I guess I'll do it";
				response_unassigned_decline_2 = "Ask her yourself";
				
				dialogue_unassigned_accept_2 	= {{text = "Mrs. Plant live next door. You go please talk to her."}};
				dialogue_unassigned_decline_2  = {{text = "ME CAN'T MOVE DUMMY!"}};
				
			
				
				
			}
		};
	}
}