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
	id = 1;
	QUEST_VERSION = 3;
	
	questLineName = "Scruff's Quest";
	questLineImage = "";
	questLineDescription = "I have come across a villager named Scruff who needs my help.";
	questLineRequirements = "";
	
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = false, timeInterval = 0}; 
	requireClass = nil;
	
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 1;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Scruff";
			handerNpcName = "Scruff";
			
			-- What the quest will appear as
			objectiveName = "Scruff's Quest";
			-- Instructions that will display after quest is complete
			completedText = "Return to Scruff.";
			
			
			completedNotes = "I have gathered 2 Chicken Eggs for Scruff. I should bring them to him.";
			handingNotes = "Scruff is such a nice guy.";
			
			
			-- rewards data
			level 		= 1;
			expMulti 	= 0.5;
			goldMulti 	= 0;
			rewards 	= {
				{id = 6; stacks = 5};
				{id = 22; stacks = 5};
				
			};
			
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id 		= 270;
						amount 	= 2;
					};
				};
				
				
			};
			
		};
		
		{
			-- Objective requirements
			requireLevel = 1;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Scruff";
			handerNpcName = "Mayor Noah";
			
			-- What the quest will appear as
			objectiveName = "Scruff's Quest Part 2";
			-- Instructions that will display after quest is complete
			completedText = "Talk to Mayor Noah.";
			
			completedNotes = "I need to deliver Scruff's letter to Mayor Noah in Mushtown. I can find Mushtown by following the main path.";
			handingNotes = "Quest completed!";
			hideAlert = true;
			
			clientOnAcceptQuest = function(util)
				spawn(function()
					util.network:invoke("setCharacterArrested", true)
					local partA = workspace:FindFirstChild("TownCamPos")
					local partB = workspace:FindFirstChild("TownCamLook")
					
					util.network:invoke("lockCameraPosition",CFrame.new(partA.Position, partB.Position))
					
					
				end)
			end;
			
			-- rewards data
			level 		= 2;
			expMulti 	= 0.6;
			goldMulti 	= 3;
			rewards 	= {

			};
			
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id = 136;
						amount 	= 1;
					};
					hideNote = true;
					hideAlert = true;
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
		
		
		dialogue_unassigned_1	= {{text = "Greetings adventurer. My wife has fallen sick and it's been a while since she's had a warm meal. Might you help me lift her spirits?"}};
		dialogue_active_1 		= {{text = "Thank you adventurer. Please collect"},{text = "2 Chicken Eggs"; font = Enum.Font.SourceSansBold},{text = "from the nearby chickens and come back to me."}};
		dialogue_objectiveDone_1 		= {{text = "Thank you so much! This is exactly what I needed. Please take this as thanks, it's all I have. I've got another task for you as well, if you're up to it..."}};
		
		dialogue_unassigned_2	= {{text = "Mayor Noah in Mushtown asked me to report on the Mushroom situation out here near my house. I have enclosed my report in this letter. Would you deliver it to him for me? He will reward you, I'm sure."}};
		-- switch to Mayor Noah
		dialogue_active_2 		= {{text = "Howdy there citizen."}};
		dialogue_objectiveDone_2 		= {{text = "Ah... you have a letter from Scruff. Let's see... Yes, just as I suspected. The Shrooms are running rampant out there. Here's some money for your efforts, go buy yourself something from Lela's shop."}};
		
		
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "Oh no! I'll help you!";
				response_unassigned_decline_1 = "I'm kind of busy...";
				
				dialogue_unassigned_accept_1 	= {{text = "Really? Thank you adventurer! Please collect"},{text = "2 Chicken Eggs"; font = Enum.Font.SourceSansBold},{text = "from the nearby chickens and come back to me."}};
				dialogue_unassigned_decline_1  = {{text = "You're right, you seem really busy. Sorry I asked."}};
				
				response_unassigned_accept_2 	= "I'll do it";
				response_unassigned_decline_2 = "Not now";
				
				dialogue_unassigned_accept_2 	= {{text = "Great! Mushtown can be found by following the main path. You can't miss it."}};
				dialogue_unassigned_decline_2  = {{text = "Come back to me if you change your mind. I am old and cannot make the journey safely myself."}};
				
				
			}
		};
	}
}