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
	id = 23;
	QUEST_VERSION = 1;
	
	questLineName = "Wheel Woes";
	questLineImage = "";
	questLineDescription = "Jericho's wagon was ambushed in the night, one of its wheels being stolen. The stolen wheel has got to be somewhere in Mushroom Forest...";
	--questLineRequirements = "I must be level 3 to start this quest.";
	
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = false, timeInterval = 0}; 
	requireClass = nil;
	
	
	
	
	objectives 		= {
		{
			-- Objective requirements
			requireLevel = 4;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Jericho";
			handerNpcName = "Jericho";
			
			-- What the quest will appear as
			objectiveName = "Wheel Woes";
			-- Instructions that will display after quest is complete
			completedText = "Return to Jericho.";
			
			clientOnAcceptQuest = function(util)
				spawn(function()
					util.network:invoke("setCharacterArrested", true)
					local partA = workspace:FindFirstChild("WheelCamPos")
					local partB = workspace:FindFirstChild("WheelCamLook")
					
					util.network:invoke("lockCameraPosition",CFrame.new(partA.Position, partB.Position))
					
					
				end)
			end;
			
			completedNotes = "I have found Jericho's wagon wheel. I should return it to him.";
			handingNotes = "Quest Completed!";
			
			-- rewards data
			level 		= 6;
			expMulti 	= 1;
			goldMulti 	= 1;
			rewards 	= {
				{id = 253; stacks = 5;};
				{id = 116; stacks = 5;};
			};
			
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id          = 137;
						amount 		= 1; 
					};
					--overridingNote = "I need to search for Jericho's lost wheel. He said a big Shroom stole it and ran off to its hideout. I wonder if there are any clues nearby...";
				};
				
				
			};
			-- on client end fix cart appearance
			
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
		
		
		
		--They must have carried it away towards their hideout. Would you lend a hand and help me find it? I'll reward you handsomely.
		
		dialogue_unassigned_1	= {{text = "Hey, adventurer! Yeah, you! Would you lend me a hand? It was dark out and some sort of giant, towering beast ambushed my wagon! It stole one of the wheels and ran off..."}};
		dialogue_active_1 		= {{text = "Did you find the wagon wheel yet? It's got to be somewhere in Mushroom Forest, wherever that beast carried it off to. There may be some sort of clue nearby."}}; 
		dialogue_objectiveDone_1 		= {{text = "You found the wheel? Great! Now I can finish my travels to Mushtown. I just have to figure out how to put it back on. This could take awhile..."}};
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				response_unassigned_accept_1	= "I'll find it";
				response_unassigned_decline_1 = "That's not my problem";
				
				dialogue_unassigned_accept_1 	= {{text = "Great! It's got to be somewhere in Mushroom Forest, wherever that beast carried it off to. See if you can pick up any trail nearby..."}};
				dialogue_unassigned_decline_1  = {{text = "It's not with that type of attitude!"}};
				
			}
		};
	}
}