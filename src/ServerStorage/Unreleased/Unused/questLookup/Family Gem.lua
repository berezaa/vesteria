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
	id = 6;
	QUEST_VERSION = 2;
	
	questLineName = "The Family Gem";
	questLineImage = "";
	questLineDescription = "Bobby lost his family's prized gem. I need to find a way down under the well and retrieve it.";
	questLineRequirements = "I must be level 15 to start this quest.";
	
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = false, timeInterval = 0}; 
	requireClass = nil;
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 17;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Bobby";
			handerNpcName = "Bobby";
			
			-- What the quest will appear as
			objectiveName = "The Family Gem";
			-- Instructions that will display after quest is complete
			completedText = "Return to Bobby.";
			completedNotes = "Return to Bobby";
			handingNotes = "Quest completed!";
			
			
			-- rewards data
			level 		= 18;
			expMulti 	= 0.45;
			goldMulti 	= 2.5;
			rewards 	= {
				{id = 14};
				{id = 16};
			};
			
			steps = {
				{
					triggerType = "found-family-gem";
					requirement = {
						amount 	= 1;
					};
					accompanyingNote = "Gem found";
				};
				
				
			};
			
			localOnFinish = function(utilities)
				spawn(function()
					if workspace:FindFirstChild("Bobby") then
						if workspace:FindFirstChild("Bobby"):FindFirstChild("greeting") then
							workspace:FindFirstChild("Bobby"):FindFirstChild("greeting"):Destroy()
						end
					end
				end)
			end;
			
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
		
		dialogue_unassigned_1	= {{text = "I can't believe it! I was just walking down the street, and next thing you know I slipped and dropped my priceless family heirloom into this well. O, what a tragedy!"}};
		dialogue_active_1 		= {{text = "You find that gemstone yet? There's gotta be a way to get to whatever is under this well..."}};
		dialogue_objectiveDone_1 		= {{text = "Wow, you actually found it, and my family didn't even know I lost it! Thank you so much! Please, take this."}};
		
		
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "I'll find it!";
				response_unassigned_decline_1 = "That's too bad";
				
				dialogue_unassigned_accept_1 	= {{text = "Really??! Well there's no way you're fitting through that well. Maybe there's another way for you to get down there? Be on the lookout!"}};
				dialogue_unassigned_decline_1  = {{text = "Yeah. Great..."}};
				
			}
		};
	}
}