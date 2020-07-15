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
	id = 10;
	QUEST_VERSION = 2;
	
	questLineName = "Treasure Hunt";
	questLineImage = "";
	questLineDescription = "The mysterious Xero has come to the land of Vesteria searching for an ancient treasure! He says he will reward me if I bring it to him.";

	
	
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = false, timeInterval = 0}; 
	requireClass = nil;
	
	
	
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 2;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Xero";
			handerNpcName = "Xero";
			
			-- What the quest will appear as
			objectiveName = "Treasure Hunt";
			-- Instructions that will display after quest is complete
			completedText = "Return to Xero.";
			
			completedNotes = "I have found Xero's Ancient Relic. If I return it to him he may reward me greatly.";
			handingNotes = "Quest completed!";
			
			
			-- rewards data
			level 		= 2;
			expMulti 	= 1;
			goldMulti 	= 0;
			rewards 	= {
				--{id = 30; stacks = 20};
				{id = 26}; {id = 46}; {id = 95};
			};
			
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id 		= 138;
						amount 	= 1;
					};
					overridingNote = "Xero says that his ancient relic is in a treasure chest...";
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
		
		
		dialogue_unassigned_1	= {{text = "I have no time for you. The people of Vesteria do not concern me. Unless..."},{text = "they know where my lost treasure is..."; font = Enum.Font.SourceSansItalic}};
		dialogue_active_1 		= {{text = "You have come empty handed! If you cannot find my treasure then begone!"}};
		dialogue_objectiveDone_1 		= {{text = "Y..you found my treasure? Give it here! Take this assortment of objects, they have no use to me."}};
		
		
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "Ooo a treasure hunt!";
				response_unassigned_decline_1   = "Haha, ok then";
				
				dialogue_unassigned_accept_1 	= {{text = "Fine! You foiled me! I have come to this universe in search of an ancient relic. My intel says that it must be in a treasure chest somewhere. If you can find this relic for me, I shall reward you greatly."}};
				dialogue_unassigned_decline_1  = {{text = "Begone!"}};
				
			}
		};
	}
}