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
	id = 21;
	QUEST_VERSION = 1;
	
	questLineName = "Love Sick";
	questLineImage = "";
	questLineDescription = "Gnomeo is tired of Gnometta and Gnoma constantly bothering him.";
	--questLineRequirements = "I must be level 7 to start this quest.";
	
	--questEndedNote = "I can now talk to Lieutenant Venessa to wear the scout uniform.";
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = false}; 
	requireClass = nil;
	
	
	
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 34;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName =  "Gnomeo";
			handerNpcName = "witch";
			
			-- What the quest will appear as
			objectiveName = "Love Sick";
			-- Instructions that will display after quest is complete
			completedText = "Find the witch in Enchanted Forest.";
			
			completedNotes = "There's a \"funny lady\" somewhere in Enchanted Forest who can help with Gnomeo's problem.";
			handingNotes = "I should talk to the witch.";
			
			
			-- rewards data
			level 		= 15;
			expMulti 	= .1;
			goldMulti 	= 0;
			rewards 	= {
				
				--{id = 150; stacks = 1};
				
			};
			hideAlert = true;
			steps = {
				{
					triggerType = "found-witch";
					requirement = {
						
						amount 	= 1;
					};
					hideAlert = true;
					hideNote  = true;
					
				};
				
			};
		};
		
		{
			-- Objective requirements
			requireLevel = 15;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName =  "witch";
			handerNpcName = "witch";
			
			-- What the quest will appear as
			objectiveName = "Love Sick";
			-- Instructions that will display after quest is complete
			completedText = "Return to witch.";
			
			completedNotes = "Now that I have all the ingredients, I should return to the witch.";
			handingNotes = "Now I need to get the potion from the witch.";
			
			
			-- rewards data
			level 		= 16;
			expMulti 	= 2;
			goldMulti 	= 0;
			rewards 	= {
				
				--{id = 150; stacks = 1};
				
			};
		
			steps = {
				
				
				{
					triggerType = "item-collected";
					requirement = {
						id   = 30; -- fresh fish
						amount 	= 1;
						
					};
					accompanyingNote = "Catch of the sea";
					
				};
				
				--[[{
					triggerType = "item-collected";
					requirement = {
						id   = 31; -- spider fang
						amount 	= 1;
						
					};
					accompanyingNote = "Arachnid bite";
					
				};
				
				{
					triggerType = "item-collected";
					requirement = {
						id   = 114; -- ratty tail
						amount 	= 1;
						
					};
					accompanyingNote = "Sewer noodle";
					
				};
				
				{
					triggerType = "item-collected";
					requirement = {
						id   = 148; -- magic flower
						amount 	= 1;
						
					};
					accompanyingNote = "Purple dazzling bloom";
					
				};
				
				{
					triggerType = "item-collected";
					requirement = {
						id   = 152; -- yeti antler
						amount 	= 1;
						
					};
					accompanyingNote = "Winter headpiece";
					
				};
				
				{
					triggerType = "item-collected";
					requirement = {
						id   = 18; -- crabby claw
						amount 	= 1;
						
					};
					accompanyingNote = "Pincher of red";
					
				};
				
				{
					triggerType = "item-collected";
					requirement = {
						id   = 182; -- snel eye
						amount 	= 1;
						
					};
					accompanyingNote = "Sight of the deep";
					
				};
				
				{
					triggerType = "item-collected";
					requirement = {
						id   = 144; -- hog meat
						amount 	= 1;
						
					};
					accompanyingNote = "Plain meat";
					
				};
				
				{
					triggerType = "item-collected";
					requirement = {
						id   = 96; -- rubee stinger
						amount 	= 1;
						
					};
					accompanyingNote = "Buzzing sting";
					
				};
				
				{
					triggerType = "item-collected";
					requirement = {
						id   = 9; -- red mushroom
						amount 	= 1;
						
					};
					accompanyingNote = "Seed of mycelium";
					
				};
				
				{
					triggerType = "item-collected";
					requirement = {
						id   = 117; -- batty wing
						amount 	= 1;
						
					};
					accompanyingNote = "Vampiric flight";
					
				};]]
				
				
			};
			
			
			
		};
		
		{
			-- Objective requirements
			requireLevel = 1;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName =  "witch";
			handerNpcName = "Gnomeo";
			
			-- What the quest will appear as
			objectiveName = "Love Sick";
			-- Instructions that will display after quest is complete
			completedText = "Find the witch in Enchanted Forest.";
			
			completedNotes = "It's time for me to deliver the potion to Gnomeo.";
			handingNotes = "Quest completed!";
			
			
			-- rewards data
			level 		= 16;
			expMulti 	= 0;
			goldMulti 	= 2.5;
			rewards 	= {
				
				--{id = 150; stacks = 1};
				
			};
			hideAlert = true;
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id   = 189; -- anti-love potion
						amount 	= 1;
						hideNote = true;
						hideAlert = true;
					};
					
					
				};
				
			};
			
			localOnFinish = function(utilities)
				spawn(function()
					if workspace:FindFirstChild("Gnomeo") then
						workspace:FindFirstChild("Gnomeo").greeting:Destroy()
						
						
						for i, thing in pairs(workspace:FindFirstChild("Gnomeo").pot:GetChildren()) do
							if thing:isA("MeshPart") then
								thing.Transparency = 0
							end
						end
						
						game.CollectionService:RemoveTag(workspace:FindFirstChild("Gnomeo").UpperTorso, "interact")
						
						local track =  workspace:FindFirstChild("Gnomeo").AnimationController:LoadAnimation(workspace:FindFirstChild("Gnomeo").drink)
						
						wait(2)
						track:Play()
						wait(1)
							workspace:FindFirstChild("Gnomeo").pot.drank.Transparency = 1
						wait(4)
						utilities.network:fire("clientNPCChat", "Gnomeo", "ooooo... i dont feel so good")
						wait(4)
						
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
		
		
		dialogue_unassigned_1	= {{text = "heya buddy, i have a problem... gnometta and gnoma wont stop bothering me. i like them and all, but they are really annoying. can you make it so they wont bother me anymore?"}};
		
		-- switch to timmy
		dialogue_active_1 		= {{text = "should not display"}}; 
		dialogue_objectiveDone_1 		= {{text = "Ahhhhh... a wee gnome with a problem at home..."}};
			
		
		dialogue_unassigned_2	= {{text = "Ack ack ack! A potion of solitary is what I forsee, a mixture of oddity lacking homonegy. If ingredients from Vesteria are what you bring, a potion of Anti-Love you shall receive."}};
		dialogue_active_2 		= {{text = "Returned to me has thee, but lacking ingredients I see."}}; 
		dialogue_objectiveDone_2 		= {{text = "Fulfilled has been the list, and to work I will be quick..."}};
		
		dialogue_unassigned_3	= {{text = "A potion that riddens devotion is what I give. Farewell, may Gnomeo's troubles be hidden in a jiff."}};
		dialogue_active_3 		= {{text = "should not show"}}; 
		dialogue_objectiveDone_3 		= {{text = "you have a potion that will make gnometta and gnomera stop bothering me? great! give it to me, please!"}};
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "Ok";
				response_unassigned_decline_1   = "No";
				
				dialogue_unassigned_accept_1 	= {{text = "yay! maybe you can try asking that funny lady in the woods to help. thanks buddy!"}};
				dialogue_unassigned_decline_1  = {{text = "golly gee."}};
				
				response_unassigned_accept_2 	= "Makes sense";
				response_unassigned_decline_2   = "What?";
				
				dialogue_unassigned_accept_2 	= {{text = "In your notes you may check for what I need. Complete the deed and from long ago the problem of Gnomeo will be."}};
				dialogue_unassigned_decline_2  = {{text = "Chicken butt."}};
				
				response_unassigned_accept_3 	= "I'll bring it to him";
				response_unassigned_decline_3   = "Maybe later";
				
				dialogue_unassigned_accept_3 	= {{text = "Farewell- Gnomeo will be free, I gaurantee."}};
				dialogue_unassigned_decline_3  = {{text = "Unwise, your answer you should revise."}};
				
			}
		};
	}
}