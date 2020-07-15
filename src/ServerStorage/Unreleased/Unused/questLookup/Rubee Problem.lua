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
	id = 7;
	QUEST_VERSION = 2;
	
	questLineName = "Rubee Problem";
	questLineImage = "";
	questLineDescription = "Scout Foxtrot reports that the Rubees on the mainland of Scallop Shores are laying new hives. He and the Hunter Scouts need my help.";
	--questLineRequirements = "I must be level 13 to start this quest.";
	
	
    -- questline requirements
	requireQuests = {}; 
	repeatableData = {value = false, timeInterval = 0}; 
	requireClass = nil;
	
	
	objectives 		= {
		-- objective 1
		{
			-- Objective requirements
			requireLevel = 12;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Scout Foxtrot";
			handerNpcName = "Lieutenant Venessa";
			
			-- What the quest will appear as
			objectiveName = "Rubee Problem";
			-- Instructions that will display after quest is complete
			completedText = "Go to the hunter outpost.";
			completedNotes = "I need to bring the Rubee Eye to the Hunter outpost at the end of the mainland jungle path.";
			handingNotes = "Lieutenant Venessa has a task for me.";
			
			
			-- rewards data
			level 		= 13;
			expMulti 	= 0.5;
			goldMulti 	= 0;
			rewards 	= {
				--{id = 16};
			};
			
			steps = {
				{
					triggerType = "item-collected";
					requirement = {
						id 		= 95;
						amount 	= 1;
					};
					
				};
				
				
			};
			
		};
		{
			-- Objective requirements
			requireLevel = 12;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Lieutenant Venessa";
			handerNpcName = "Lieutenant Venessa";
			
			-- What the quest will appear as
			objectiveName = "Rubee Problem Part 2";
			-- Instructions that will display after quest is complete
			completedText = "Return to Lieutenant Venessa.";
			
			
			completedNotes = "Now that I have the dynamite, I need to bring it to Lieutenant Venessa";
			handingNotes = "Lieutenant Venessa has my final task.";
			
			-- rewards data
			level 		= 13;
			expMulti 	= 0.3;
			goldMulti 	= 0;
			rewards 	= {
				--{id = 16};
			};
			
			steps = {
				{
					triggerType = "collect-dynamite";
					requirement = {
						
						amount 	= 1;
					};
					overridingNote = "Find the dynamite in Scallop Shores";
				};
				
				
			};
			
		};
		{
			-- Objective requirements
			requireLevel = 12;
			
			-- processing data
			
			-- used for server validation when accepting/handing a quest
			giverNpcName = "Lieutenant Venessa";
			handerNpcName = "Lieutenant Venessa";
			
			-- What the quest will appear as
			objectiveName = "Rubee Problem Part 3";
			-- Instructions that will display after quest is complete
			completedText = "Return to Lieutenant Venessa.";
			completedNotes = "I have placed the Dynamite charges. Now I should return to Lieutenant Venessa.";
			handingNotes = "Quest completed!";
			
			
			-- rewards data
			level 		= 14;
			expMulti 	= 1.65;
			goldMulti 	= 1;
			rewards 	= {
				{id = 45; stacks = 3;};
				{id = 61; stacks = 1;};
			};
			
			steps = {
				{
					triggerType = "set-rubee-dynamite";
					requirement = {
						amount 	= 3;
					};
					accompanyingNote = "Dynamite placed";
				};
			};
			
			
			serverOnFinish = function(player)
				network:fireAllClients("doRubeeExplosion", player)
				
				
				local damageData = {}
						damageData.damage 			= 9999999
						damageData.sourcePlayerId	= player.userId
						damageData.damageTime		= os.time()
				
				
				wait(6)
				
				
				
				local bomb1 = workspace:WaitForChild("explosion1")
				--local bomb2 = workspace:WaitForChild("explosion2")
				--local bomb3 = workspace:WaitForChild("explosion3")
				
				
				
				local entities = utilities.getEntities("monster")
				local deadRubees = {}
				for i, entityManifest in pairs(entities) do
					
					if entityManifest.entityId.Value == "Rubee" then
						if (entityManifest.Position - bomb1.PrimaryPart.Position).magnitude <= 80 then
							table.insert(deadRubees, entityManifest)
						--[[elseif math.abs((entityManifest.Position - bomb2.PrimaryPart.Position).magnitude) <= 80 then
							table.insert(deadRubees, entityManifest)
						elseif math.abs((entityManifest.Position - bomb3.PrimaryPart.Position).magnitude) <= 80 then
							table.insert(deadRubees, entityManifest)]]--
						end
					end
				end
				
				spawn(function()
					wait(.5)
					for i, rubee in pairs(deadRubees) do
						network:invoke("monsterDamageRequest_server", player, rubee, damageData)
					end
				end)
				
				
				
				wait(9)
				
				local bomb2 = workspace:WaitForChild("explosion2")
				--local bomb2 = workspace:WaitForChild("explosion2")
				--local bomb3 = workspace:WaitForChild("explosion3")
				
				
				
				local entities = utilities.getEntities("monster")
				local deadRubees = {}
				for i, entityManifest in pairs(entities) do
					
					if entityManifest.entityId.Value == "Rubee" then
						if (entityManifest.Position - bomb2.PrimaryPart.Position).magnitude <= 80 then
							table.insert(deadRubees, entityManifest)
						--[[elseif math.abs((entityManifest.Position - bomb2.PrimaryPart.Position).magnitude) <= 80 then
							table.insert(deadRubees, entityManifest)
						elseif math.abs((entityManifest.Position - bomb3.PrimaryPart.Position).magnitude) <= 80 then
							table.insert(deadRubees, entityManifest)]]--
						end
					end
				end
				
				
				spawn(function()
					wait(.5)
					for i, rubee in pairs(deadRubees) do
						network:invoke("monsterDamageRequest_server", player, rubee, damageData)
					end
				end)
				
				
				wait(9)
				
				local bomb3 = workspace:WaitForChild("explosion3")
				--local bomb2 = workspace:WaitForChild("explosion2")
				--local bomb3 = workspace:WaitForChild("explosion3")
				
				
				
				local entities = utilities.getEntities("monster")
				local deadRubees = {}
				for i, entityManifest in pairs(entities) do
					
					if entityManifest.entityId.Value == "Rubee" then
						if (entityManifest.Position - bomb3.PrimaryPart.Position).magnitude <= 80 then
							table.insert(deadRubees, entityManifest)
						--[[elseif math.abs((entityManifest.Position - bomb2.PrimaryPart.Position).magnitude) <= 80 then
							table.insert(deadRubees, entityManifest)
						elseif math.abs((entityManifest.Position - bomb3.PrimaryPart.Position).magnitude) <= 80 then
							table.insert(deadRubees, entityManifest)]]--
						end
					end
				end
				
				
				
				spawn(function()
					wait(.5)
					for i, rubee in pairs(deadRubees) do
						network:invoke("monsterDamageRequest_server", player, rubee, damageData)
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
		
		dialogue_unassigned_1	= {{text = "Roger, Foxtrot reports that the Rubees are laying new hives on the mainland. The hunter outpost must be informed. They'll only trust you if you bring them a"},{text = "Rubee Eye."; font = Enum.Font.SourceSansBold},{text = "Get moving cadet, over."}};
		dialogue_active_1 		= {{text = "I have no business with you."},{text = "(Gather a Rubee Eye)"; font = Enum.Font.SourceSansBold}};
		-- switches speakers here
		
		-- venessa
		dialogue_objectiveDone_1 		= {{text = "So you say Foxtrot has intel the Rubees are laying new hives? Well, we can't have that..."}};
		
		
		dialogue_unassigned_2	= {{text = "We cannot let the Rubees grow in numbers and launch an attack on the city. When new hives form, protocol is to blow them to smithereens! We, however, are out of explosives. You'll have to find some for us! There's got to be some lying around here in Scallop Shores."}};
		dialogue_active_2 		= {{text = "Have you found the dynamite yet? There's got to be some in Scallop Shores."}};
		dialogue_objectiveDone_2 		= {{text = "Excellent! Now I need you to do one last thing..."}};
		
		dialogue_unassigned_3	= {{text = "Admirable work so far, soldier! But our task is not completed. As our most competent recruit, I'll need you to plant the explosives at the three marked charge locations near the hives. Then it's... boom boom for the Rubees."}};
		dialogue_active_3 		= {{text = "Go set up the explosives at the three charge locations. They are marked near the hives."}};
		dialogue_objectiveDone_3 		= {{text = "The explosives are ready? Perfect! BYE BYE BEES!"}};
		
		
		
		
		-- button choices and responses go in here
		-- don't make response tables within the table here, it won't work. can only display one dialogue response from here.
		options = {
			{
				
				
				response_unassigned_accept_1 	= "Roger that!";
				response_unassigned_decline_1 = "I'm allergic to bees";
				
				dialogue_unassigned_accept_1 	= {{text = "Copy. Foxtrot appreciates you, over."}};
				dialogue_unassigned_decline_1  = {{text = "Copy. This is no time for allergies, over."}};
				
				response_unassigned_accept_2 	= "M'am yes m'am!";
				response_unassigned_decline_2 = "Why don't you do it?";
				
				dialogue_unassigned_accept_2 	= {{text = "Good soldier!"}};
				dialogue_unassigned_decline_2  = {{text = "I must stay and defend the outpost! If I'm not here, the Rubees will surely sneak into the city."}};
				
				response_unassigned_accept_3 	= "Boom boom bees";
				response_unassigned_decline_3 = "Nah, I'm tired";
				
				dialogue_unassigned_accept_3 	= {{text = "Let's finish this."}};
				dialogue_unassigned_decline_3  = {{text = "... I thought you were better than that."}};
				
				
			}
		};
	}
}