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
	id = 12;
	QUEST_VERSION = 1;
	
	questLineName = "The Ratking";
	questLineImage = "";
	questLineDescription = "The Ratking has a challenge for me. This can't be good.";
	questLineRequirements = "I must be level 20 to start this quest.";
	questEndedNote = "I am the Ratking now.";
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = false, timeInterval = 0}; 
	requireClass = nil;
	
	
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 20;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "The Ratking";
			handerNpcName = "The Ratking";
			
			-- What the quest will appear as
			objectiveName = "The Ratking";
			-- Instructions that will display after quest is complete
			completedText = "Return to The Ratking.";
			
			completedNotes = "I have defeated the Rattys. Time to return to The Ratking.";
			handingNotes = "The Ratking has another trial for me.";
			
			-- rewards data
			level 		= 20;
			expMulti 	= .3;
			goldMulti 	= 0;
			rewards 	= {
				--{id = 90; stacks = 2};
			};
			
			steps = {
				{
					triggerType = "monster-killed";
					requirement = {
						monsterName = "Ratty";
						amount 		= 10; 
					};
					
				};
				
				
			};
			
		};
		{
			-- Objective requirements
			requireLevel = 20;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "The Ratking";
			handerNpcName = "The Ratking";
			
			-- What the quest will appear as
			objectiveName = "The Ratking Part 2";
			-- Instructions that will display after quest is complete
			completedText = "Return to The Ratking.";
			
			completedNotes = "I have collected the Ratty Tails. Time to return to The Ratking.";
			handingNotes = "The Ratking has yet another trial for me.";
			
			-- rewards data
			level 		= 20;
			expMulti 	= .5;
			goldMulti 	= 0;
			rewards 	= {
				--{id = 29};
			};
			
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id          = 114;
						amount 		= 27; 
					};
				};
				
				
			};
			
		};
		{
			-- Objective requirements
			requireLevel = 20;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "The Ratking";
			handerNpcName = "The Ratking";
			
			-- What the quest will appear as
			objectiveName = "The Ratking Part 3";
			-- Instructions that will display after quest is complete
			completedText = "Return to The Ratking.";
			
			completedNotes = "I have collected the Ratty Heads. Time to return to The Ratking again.";
			handingNotes = "The Ratking has... another trial for me?!";
			
			-- rewards data
			level 		= 20;
			expMulti 	= .7;
			goldMulti 	= 0;
			rewards 	= {
				--{id = 29};
			};
			
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id          = 115;
						amount 		= 3; 
					};
				};
				
				
			};
			
		};
		{
			-- Objective requirements
			requireLevel = 20;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "The Ratking";
			handerNpcName = "The Ratking";
			
			-- What the quest will appear as
			objectiveName = "The Ratking Part 4";
			-- Instructions that will display after quest is complete
			completedText = "Return to The Ratking.";
			
			completedNotes = "I have collected the Ratty Tails. Time to return to The Ratking again.";
			handingNotes = "Of course, the Ratking has another trial for me.";
			
			-- rewards data
			level 		= 20;
			expMulti 	= .8;
			goldMulti 	= 0;
			rewards 	= {
				--{id = 29};
			};
			
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id          = 114;
						amount 		= 84; 
					};
				};
				
				
			};
			
		};
		{
			-- Objective requirements
			requireLevel = 20;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "The Ratking";
			handerNpcName = "The Ratking";
			
			-- What the quest will appear as
			objectiveName = "The Ratking Part 5";
			-- Instructions that will display after quest is complete
			completedText = "Return to The Ratking.";
			
			completedNotes = "I have collected the Ratty Heads. Time to return to The Ratking... again.";
			handingNotes = "The Ratking better not have another trial for me.";
			
			-- rewards data
			level 		= 20;
			expMulti 	= 1;
			goldMulti 	= 2;
			rewards 	= {
				{id = 139};
			};
			
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id          = 115;
						amount 		= 22; 
					};
				};
				
				
			};
			localOnFinish = function(player)
				local ratking = workspace:WaitForChild("The Ratking")
				for i, part in pairs(ratking.Head:GetChildren()) do
					if part.Name == "BucketPart" then
						part:Destroy()
					end
				end
				ratking.Name = "Carl"
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
		
		
		dialogue_unassigned_1	= {{text = "BELCH"; font = Enum.Font.SourceSansBold},{text = "I need help with dem Rattys. Are you serious about dem Rattys? Kill 10 of dem to show me."}};
		dialogue_active_1 		= {{text = "Have ye defeated the 10 Rattys?"}};
		dialogue_objectiveDone_1 = {{text = "Hmmm. I see you defeated the Rattys, very good. But now I'm hungry."}};
		--dialogue_objectiveDone_1 		= {{text = "DELICIOUS TAILS! WE EATIN TONIGHT! I sees you have a way with dem Rattys. BUT THAT WAS ONLY YOUR FIRST CHALLENGE!"}};
			
		dialogue_unassigned_2	= {{text = "BURP"; font = Enum.Font.SourceSansBold},{text = "Now the Ratking needs you to bring him 27 Ratty Tails. THE RATKING IS FREAKING HUNGRY!"}};
		dialogue_active_2 		= {{text = "BRING ME 27 RATTY TAILS! Oh, please."}}; -- shouldn't actually be called
		dialogue_objectiveDone_2 		= {{text = "BELCH"; font = Enum.Font.SourceSansBold},{text = "DELICIOUS TAILS! I see you really do have a way with dem Rattys. BUT I'M STILL HUNGRY!"}};
		--They must have carried it away towards their hideout. Would you lend a hand and help me find it? I'll reward you handsomely.
		
		dialogue_unassigned_3	= {{text = "For your next task... BRING ME THEIR HEADS! Bring me 3 Ratty Heads. They don't let dem go that often, so you'll have to keep on killing dem until they do."}};
		dialogue_active_3 		= {{text = "Bring me 3 Ratty Heads!"}}; -- shouldn't actually be called
		dialogue_objectiveDone_3 		= {{text = "MMM MMM MMM! SCRUMPTIOUS RATTY HEADS! I'm still hungry though!"}};
		
		dialogue_unassigned_4	= {{text = "BELCH"; font = Enum.Font.SourceSansBold},{text = "I'm in the mood for more Ratty Tails. Bring me... 84 of dem! "}};
		dialogue_active_4 		= {{text = "Bring me 84 Ratty TAILS!"}}; -- shouldn't actually be called
		dialogue_objectiveDone_4 		= {{text = "OH YEAH! SLURP DEM RATTY TAILS LIKE SPAGHETTI!"},{text = "BURP"; font = Enum.Font.SourceSansBold}};
		
		dialogue_unassigned_5	= {{text = "BELCH"; font = Enum.Font.SourceSansBold},{text = "I'm getting kind of full... BUT I'M NOT FULL YET! Bring me.... HAHAHAHAHA.... 22 RATTY HEADS!! That will keep you"},{text = "BURP"; font = Enum.Font.SourceSansBold},{text = "busy!"}};
		dialogue_active_5 		= {{text = "Bring me 22 Ratty HEADS!"}}; -- shouldn't actually be called
		dialogue_objectiveDone_5 		= {{text = "Y.. YOU BROUGHT ME 16 RATTY HEADS?"},{text = "BURP"; font = Enum.Font.SourceSansBold},{text = "I.. I don't know what to say. You... you deserve to be King, I cannot outmatch you. T..t..take my bucket hat..."}};
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "I have what it takes";
				response_unassigned_decline_1 = "No.";
				
				dialogue_unassigned_accept_1 	= {{text = "Get DEM RATTYS!"}};
				dialogue_unassigned_decline_1  = {{text = "WHAT?! What did I say?"}};
				
				response_unassigned_accept_2 	= "Ratty Tails coming up";
				response_unassigned_decline_2 = "EWWWW!";
				
				dialogue_unassigned_accept_2 	= {{text = "YUM YUM."}};
				dialogue_unassigned_decline_2  = {{text = "WHAT??!!"}};
				
				response_unassigned_accept_3 	= "I'll do it";
				response_unassigned_decline_3 = "EWWWWW!!!!";
				
				dialogue_unassigned_accept_3 	= {{text = "THAT'S MY BOY."}};
				dialogue_unassigned_decline_3  = {{text = "NO U!!!!!!!"}};
				
				response_unassigned_accept_4 	= "I'll do it";
				response_unassigned_decline_4 = "Are you serious?";
				
				dialogue_unassigned_accept_4 	= {{text = "VERY GOOD."}};
				dialogue_unassigned_decline_4  = {{text = "OF COURSE I AM. WHO DO YOU THINK I AM? I'M THE FREAKING RATKING!"}};
				
				response_unassigned_accept_5 	= "This might take awhile";
				response_unassigned_decline_5 = "That's crazy";
				
				dialogue_unassigned_accept_5 	= {{text = "HAHAHAHAHAHA!"}};
				dialogue_unassigned_decline_5  = {{text = "YOU ARE WHAT YOU EAT"}};
				
			}
		};
	}
}