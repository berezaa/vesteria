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
	id = 4;
	QUEST_VERSION = 2;
	-- currently not in use
	questLineName = "A Respected Guard";
	questLineImage = "";
	questLineDescription = "Greg, the City Guard, has tasked me to gather Elder Beards from the Elder Shrooms in the Mushroom Forest.";
	--questLineRequirements = "I must be level 5 to start this quest.";
	
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = false, timeInterval = 0}; 
	requireClass = nil;
	
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 6;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Greg, the City Guard";
			handerNpcName = "Greg, the City Guard";
			
			-- What the quest will appear as
			objectiveName = "A Respected Guard";
			-- Instructions that will display after quest is complete
			completedText = "Return to Greg, the City Guard.";
			completedNotes = "Return to Greg, the City Guard";
			handingNotes = "Quest completed!";
			
			
			-- rewards data
			level 		= 4;
			expMulti 	= 1;
			goldMulti 	= 1;
			rewards 	= {
				{id = 24};
			};
			
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id 		= 10;
						amount 	= 10;
					};
				};
				
				
			};
			
			localOnFinish = function(utilities)
				spawn(function()
					if workspace:FindFirstChild("Greg, the City Guard") and workspace["Greg, the City Guard"]:FindFirstChild("Head") then
						if workspace["Greg, the City Guard"].Head:FindFirstChild("ShroomPeople") then
							workspace["Greg, the City Guard"].Head.ShroomPeople.Transparency = 0
						end
						if workspace["Greg, the City Guard"].Head:FindFirstChild("ShroomPeople2") then
							workspace["Greg, the City Guard"].Head.ShroomPeople2.Transparency = 0
						end		
						--if workspace["City Guard"]:FindFirstChild("UpperTorso") and workspace["City Guard"].UpperTorso:FindFirstChild("dialogue") then
						--	local dialogueObject = require(workspace["City Guard"].UpperTorso.dialogue)
						--	dialogueObject.dialogue = {{text = "Ah yes, I feel more respected already."}}
						--end		
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
		
		
		dialogue_unassigned_1	= {{text = "Hey bud. Ya know, it's real hard to get some respect around here as a City Guard. Think you could help me out? I'll make it worth your time."}};
		dialogue_active_1 		= {{text = "Hey! Come back when you have those"},{text = "10 Elder Beards."; font = Enum.Font.SourceSansBold},{text = "I've heard from some of the other guards that theres a hideout with tons of beared Shrooms somewhere..."}};
		dialogue_objectiveDone_1 		= {{text = "My word! These are perfect! I'll be truely respected as a city guard with these. Here, take this... maybe you'll get some respect now too."}};
		
		
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "No problem my man.";
				response_unassigned_decline_1 = "Sorry, can't help.";
				
				dialogue_unassigned_accept_1 	= {{text = "I knew you'd be able to help me. I've heard there's a hideout somewhere in the forest populated by massive Shrooms with some manly beards. Get me 10 of them."}};
				dialogue_unassigned_decline_1  = {{text = "Ugh. Guess I'll have to find a more RESPECTABLE adventurer."}};
				
			}
		};
	}
}