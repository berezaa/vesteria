local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local mapping = modules.load("mapping")
	local network 			= modules.load("network")
	local utilities			= modules.load("utilities")
	local tween =            modules.load("tween")
	
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
	id = 13;
	QUEST_VERSION = 1;

	questLineName = "Baker's Assistant";
	questLineimage = "";
	questLineDescription = "Gertrude needs some baking help.";
	--questLineRequirements = "I must be level 7 to start this quest.";
	
	--questEndedNote = "Mobeus gave me his pocketwatch to return to his brother in Nilgarf. Maybe if I give it to him I will get a reward.";
	
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = false, timeInterval = 0}; 
	requireClass = nil;
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 7;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Gertrude";
			handerNpcName = "Gertrude";
			
			-- What the quest will appear as
			objectiveName = "Baker's Assistant";
			-- Instructions that will display after quest is complete
			completedText = "Return to Gertrude.";
			
			
			completedNotes = "I have gathered the Hog Meat and Sugar for Gertrude's meat pie. I should return to her.";
			handingNotes = "Gertrude has another task for me.";
			
			
			
			-- rewards data
			level 		= 8;
			expMulti 	= 1;
			goldMulti 	= 0;
			rewards 	= {
				{id = 8; stacks = 20};
				{id = 88; stacks = 4};
			};
			
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id = 144;
						amount 	= 8;
					};
					
				};
				{
					triggerType = "item-collected";
					requirement = {
						id = 146;
						amount 	= 1;
					};
					
				};
			};
			
			localOnFinish = function(utilities)
				spawn(function()
					if workspace:FindFirstChild("cut_cauldron") then
						
						local primaryPart = workspace:FindFirstChild("cut_cauldron").PrimaryPart
						
						--tween(dark, {"ImageTransparency"}, 1, 0.3)
						
						for i = 1, 8 do
							local meat = script.cut_meat:Clone()
							meat.Position = primaryPart.Position + Vector3.new(0,3,0)
							meat.Size = meat.Size * 1.2
							meat.Parent = workspace
							meat.swoosh:Play()
							tween(meat, {"Position"}, primaryPart.Position, 0.4)
							wait(.4)
							if meat and meat.Parent then
								meat:Destroy()
							end
						end
						
						
						local sugar = script.cut_sugar:Clone()
						sugar.Parent = workspace
						sugar.Position = primaryPart.Position + Vector3.new(0,3,0)
						tween(sugar, {"Orientation"}, Vector3.new(-90, 90, 0), 0.3)
						sugar.swoosh:Play()
						wait(.3)
						sugar.Water.Enabled = true
						wait(1.5)
						sugar.Water.Enabled = false
						wait(.2)
							if sugar and sugar.Parent then
								sugar:Destroy()
							end
							
							
						local pie = script.cut_pie:Clone()
						pie.Position  = primaryPart.Position
						pie.Parent = workspace
						tween(pie, {"Position"}, primaryPart.Position + Vector3.new(0,3,0) , 0.3)
						pie.Sparkles:Emit(5)
						pie.ray:Emit(3)
						pie.awe:Play()
						wait(2.5)
						if pie and pie.Parent then
							pie:Destroy()
						end
					end
				end)
			end;
			
		};
		{
			-- Objective requirements
			requireLevel = 7;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Gertrude";
			handerNpcName = "Skull Crusher";
			
			-- What the quest will appear as
			objectiveName = "Baker's Assistant Part 2";
			-- Instructions that will display after quest is complete
			completedText = "";
			
			
			completedNotes = "Gertrude needs me to deliver the pie to her son in the Warrior Stronghold. I must travel through the Redwood Pass to reach him.";
			handingNotes = "";
			hideAlert = true;
			
			
			-- rewards data
			level 		= 8;
			expMulti 	= .8;
			goldMulti 	= 2;
			rewards 	= {
				{id = 26; stacks = 1};
				{id = 56; stacks = 1};
			};
			
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id = 141; --CHANGE TO CAKE
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
		
		dialogue_unassigned_1	= {{text = "Hello there stranger. Say, would you mind helping a little old lady bake a pie?"}};
		dialogue_active_1 		= {{text = "Did you gather the 8 Hog Meat and the Bag of Sugar for the pie? Fight the Hogs until you do. It's going to be quite the big tasty pie!"}};
		-- switches speakers here
		
		-- young joe
		dialogue_objectiveDone_1 		= {{text = "Splendid! Time to \"bake\"!"}};
		
		
		
		
		-- gertrude
		dialogue_unassigned_2	= {{text = "The pie isn't for you or me I'm afraid. It's for my son! Would you bring it to him?"}};
	
	-- shouldn't ever be called
		dialogue_active_2 		= {{text = "Hey... you don't have a pie with you. Did you have room in your inventory to hold it?"}};
		
		-- skull crusher
		dialogue_objectiveDone_2 		= {{text = "Mom baked me a pie? AWESOME!"}};
		
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "Sure thing!";
				response_unassigned_decline_1 = "Get lost granny";
				
				dialogue_unassigned_accept_1 	= {{text = "Splendid! I'm making my boy's favorite meat pie, but I'm missing the two most important ingredients: Sugar and Hog Meat! One of those Hogs broke into my kitchen and stole my last bag of sugar! Would you get it back for me? While you're at it, be a dear and also collect 8 Hog Meat."}};
				dialogue_unassigned_decline_1  = {{text = "Well! How rude!"}};
					
				response_unassigned_accept_2 	= "Of course!";
				response_unassigned_decline_2 = "Not today granny";
				
				dialogue_unassigned_accept_2 	= {{text = "Hip hip hurray! My boy is a big strong warrior. You can find him at the Warrior Stronghold after the Redwood Pass. Just follow the path all the way through until you reach him! Thanks a ton, sugarplum!"}};
				dialogue_unassigned_decline_2  = {{text = "Oh dear me!"}};
				
			
				
				
			}
		};
	}
}