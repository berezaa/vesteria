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
	id = 2;
	QUEST_VERSION = 4;
	
	questLineName = "Mushtown Helper";
	questLineImage = "";
	questLineDescription = "Mushtown needs a hero. I must slay the Shrooms in Mushroom Forest.";
	--questLineRequirements = "I must be level 3 to start this quest.";
	
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = false, timeInterval = 0}; 
	requireClass = nil;
	
	
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 3;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Mayor Noah";
			handerNpcName = "Mayor Noah";
			
			-- What the quest will appear as
			objectiveName = "Mushtown Helper I";
			-- Instructions that will display after quest is complete
			completedText = "Return to Mayor Noah.";
			
			completedNotes = "I have slayed the Shrooms. Time for me to return to Mayor Noah.";
			handingNotes = "Quest completed!";
			
			-- rewards data
			level 		= 3;
			expMulti 	= 1;
			goldMulti 	= 2;
			rewards 	= {
				{id = 90;};
			};
			
			steps = {
				{
					triggerType = "monster-killed";
					requirement = {
						monsterName = "Baby Shroom";
						amount 		= 10; 
					};
				};
				{
					triggerType = "monster-killed";
					requirement = {
						monsterName = "Shroom";
						amount 		= 1; 
					};
				};				
				
			};
			
		};
		-- objective 2
		{
			-- Objective requirements
			requireLevel = 5;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Mayor Noah";
			handerNpcName = "Mayor Noah";
			
			-- What the quest will appear as
			objectiveName = "Mushtown Helper II";
			-- Instructions that will display after quest is complete
			completedText = "Return to Mayor Noah.";
			
			completedNotes = "I have thinned the Shroom population and collected samples for study.";
			handingNotes = "Quest completed!";
			
			-- rewards data
			level 		= 5;
			expMulti 	= 1;
			goldMulti 	= 1;
			rewards 	= {
				{id = 90; stacks = 3;};
				{id = 14;}
			};
			
			steps = {
				{
					triggerType = "monster-killed";
					requirement = {
						monsterName = "Shroom";
						amount 		= 10; 
					};
				};
				{
					-- mushroom spore
					triggerType = "item-collected";
					requirement = {
						id = 9;
						amount 	= 20;
					};
					
				};
				{
					-- red mushroom
					triggerType = "item-collected";
					requirement = {
						id = 11;
						amount 	= 20;
					};	
				};												
			};
			
		};		
		-- objective 3
		{
			-- Objective requirements
			requireLevel = 8;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Mayor Noah";
			handerNpcName = "Mayor Noah";
			
			-- What the quest will appear as
			objectiveName = "Mushtown Helper III";
			-- Instructions that will display after quest is complete
			completedText = "Return to Mayor Noah.";
			
			completedNotes = "I have defeated the source of the mushroom corruption.";
			handingNotes = "Quest completed!";
			
			-- rewards data
			level 		= 7;
			expMulti 	= 1;
			goldMulti 	= 2;
			rewards 	= {
				{id = 90; stacks = 3;};
				{id = 16;};
				{id = 150;};
			};
			
			steps = {
				{
					triggerType = "monster-killed";
					requirement = {
						monsterName = "Chad";
						amount 		= 1; 
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
		
		
		dialogue_unassigned_1	= {{text = "Shrooms keep pouring out of Mushroom Forest and attacking the town. We don't know what's gotten into them. Can you help us thin their numbers?"}};
		dialogue_active_1 		= {{text = "Having difficulty finding Mushroom Forest? Try following the signs and paths, or look for the biggest mushroom on the horizon! Make sure you stock up at Lela's shop before you go out."}};
		dialogue_objectiveDone_1 		= {{text = "Mushtown thanks you. Take this magical Rune. When used, it can safely take you back to Mushtown from wherever you are. We may need more of your help yet."}};
			
		dialogue_unassigned_2	= {{text = "Thank you again for your help, Adventurer. I'm afraid Mushtown must call upon your bravery yet again... The Shroom situation is getting dire, we need someone to collect samples from the Shrooms that we can analyze."}};
		dialogue_active_2 		= {{text = "Please return to Mushroom Forest and defeat 10 Shrooms. While you're there, collect 20 Mushroom Spores and 20 Red Mushrooms, then return to me."}};
		dialogue_objectiveDone_2 		= {{text = "Have you collected the samples? Great work! Hand them over and I'll let you know when we have a better understanding of what we're dealing with here."}};
			
		dialogue_unassigned_3	= {{text = "Adventurer! The situation is much worse than we thought. Those samples you brought us... I fear the Shrooms have been corrupted... I've heard the ancient tales, but never would I have imagined something like this happening in my lifetime."}};
		dialogue_active_3 		= {{text = "Rumors say that within Mushroom Forest is an entrance to the Shroom's secret hideaway. No one has ever gone there and lived to tell the tale. If this ripped Shroom is anywhere, it must be there."}};
		dialogue_objectiveDone_3 		= {{text = "I... you don't even need to say it. I can tell by that look in your eye that you've done it. The Shrooms have started to quiet down. You've saved us, Adventurer."}};
			
				
				
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "I will slay the Shrooms.";
				response_unassigned_decline_1 = "Shrooms haven't done me wrong";
				
				dialogue_unassigned_accept_1 	= {{text = "Thank you! Please venture to the Mushroom Forest. Defeat 10 Baby Shrooms and see if you can take out 1 grown Shroom. Be careful, they are dangerous!"}};
				dialogue_unassigned_decline_1  = {{text = "Stick around here long enough and you'll see the Shrooms are no good."}};
				
				response_unassigned_accept_2 	= "Shrooms wont know what hit 'em.";
				response_unassigned_decline_2 = "I can't help you.";
				
				dialogue_unassigned_accept_2 	= {{text = "Such bravery! Please return to Mushroom Forest and defeat 10 Shrooms. While you're there, collect 20 Mushroom Spores and 20 Red Mushrooms, then return to me."}};
				dialogue_unassigned_decline_2  = {{text = "Oh dear, I'm afraid we are in serious trouble then..."}};
				
				response_unassigned_accept_3 	= "Let me help!";
				response_unassigned_decline_3 = "Nope. I'm out.";
				
				dialogue_unassigned_accept_3 	= {{text = "Accepting the challenge before you even know what you're up against. Maybe mushtown has a hope after all... The legends state that once every thousand years a Shroom will be born with an absolutely sick bod. You must venture into the hideaway of the Shrooms, draw out this evil and defeat. Mushtown wishes you luck."}};
				dialogue_unassigned_decline_3  = {{text = "I can't blame you. I guess we must all accept our fate, no?"}};
				
												
				
			}
		};
	}
}