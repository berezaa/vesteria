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
	id = 3;
	QUEST_VERSION = 1; -- only update when active quest progress should be wiped
	
	
	questLineName = "No More Crabbies!";
	questLineImage = "";
	questLineDescription = "The Crabbies are disturbing Fisherman Gary's fishin'! He needs me to slay them and collect their claws.";
	questLineRequirements = "I must be level 7 to start this quest.";
	
	questEndedNote = "If I return to Fisherman Gary he will trade me Fresh Fish for Crabby Claws.";
	
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
			giverNpcName = "Fisherman Gary";
			handerNpcName = "Fisherman Gary";
			
			-- What the quest will appear as
			objectiveName = "No More Crabbies!";
			-- Instructions that will display after quest is complete
			completedText = "Return to Fisherman Gary.";
			completedNotes = "Return to Fisherman Gary";
			handingNotes = "Quest completed!";
			
			
			-- rewards data
			level 		= 8;
			expMulti 	= 1;
			goldMulti 	= 1;
			rewards 	= {
				{id = 30; stacks = 20};
			};
			
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id 		= 18;
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
		
		
		dialogue_unassigned_1	= {{text = "These gosh darn Crabbys waltzing 'round here like they own the place. They be scarin' away all me fish! I say, you take care of 'em for me and I'll give you something fresh."}};
		dialogue_active_1 		= {{text = "I'm tryin' to catch me some fish! Come back when you've got my"},{text = "30 Crabby Claws!"; font = Enum.Font.SourceSansBold}};
		dialogue_objectiveDone_1 		= {{text = "Perfecto! Those Crabbys won't be getting in my way any more. Here be a fresh reward as promised. Visit me again if you like 'em. You keep killin' these darn Crabbys and I'll keep you fed!"}};
		
		
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "Crabby Cakes coming up!";
				response_unassigned_decline_1   = "I'm not messing with no Crabby.";
				
				dialogue_unassigned_accept_1 	= {{text = "Aw yea! Destroy those nabby Crabbys and bring me 30 Crabby Claws."}};
				dialogue_unassigned_decline_1  = {{text = "Pshh *spits* I knew you were too yellow for these Crabbys."}};
				
			}
		};
	}
}