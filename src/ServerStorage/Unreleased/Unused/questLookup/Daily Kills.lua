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
	id = 9;
	QUEST_VERSION = 1;
	
	questLineName = "Daily Colosseum Kills";
	questLineImage = "";
	questLineDescription = "Ethera has challenged me to defeat 5 opponents in the Colosseum arena to prove my worth.";
	--questLineRequirements = "I must be level 20 to start this quest.";
	
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = true, timeInterval = 60*60*12}; 
	requireClass = nil;
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 20;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Ethera";
			handerNpcName = "Ethera";
			
			-- What the quest will appear as
			objectiveName = "Daily Colosseum Kills";
			-- Instructions that will display after quest is complete
			completedText = "Return to Ethera.";
			completedNotes = "Return to Ethera";
			handingNotes = "Quest completed!";
			
			
			-- rewards data
			level 		= 20;
			expMulti 	= 1;
			goldMulti 	= 1;
			rewards 	= {
				{id = 119; stacks = 5};
			};
			
			steps = {
				{
					triggerType = "colosseum-kill";
					requirement = {
						amount 	= 5;
					};
					accompanyingNote = "Opponents defeated";
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
		
		dialogue_unassigned_1	= {{text = "Do you have the grit to step into the arena? Prove to me your worth by defeating 5 opponents, and I will honor you."}};
		dialogue_active_1 		= {{text = "Return to me when you have defeated 5 opponents."}};
		
		dialogue_objectiveDone_1 		= {{text = "Impressive work, adventurer. The arena could use more champions like yourself. Let it get to your head not, though, or you may lose it. Come back another time to show me more of what you can do."}};
		

		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "I accept!";
				response_unassigned_decline_1 = "I'm not much of a fighter";
				
				dialogue_unassigned_accept_1 	= {{text = "You will need that enthusiasm in the arena. It is a merciless place."}};
				dialogue_unassigned_decline_1  = {{text = "More of a spectator then? The stands are open for you in that case. I only deal with the fighters."}};
				

				
			}
		};
	}
}