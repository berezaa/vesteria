local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = require(ReplicatedStorage.modules)
local Network = Modules.load("network")

local questData = {
	id = 1;
	name = "Test Quest";
	questType = "findAndReturn";
	
	steps = {
		[1] = {
			stepData = {
				stepType = "findAndReturn";
				objective = "Apple"; -- Item name.
				timeLimit = 0; -- Time in seconds, 0 = Infinite
			};
		};
		
		[2] = {
			stepData = {
				stepType = "killMonster";
				objective = "Baby Shroom"; -- Monster name.
				timeLimit = 0; -- Time in seconds, 0 = Infinite
			};
		};
	};
	
	startData = {
		triggerType = "npc";
		trigger = "Test NPC";
	};
	
	finishData = {
		triggerType = "npcReturn";
		trigger = "Test NPC";
	};
}

function questData:beginQuest(player)
	
end

function questData:beginQuestServer(player)
	
end

function questData:endQuest(player)
	
end

function questData:endQuestServer(player)
	
end

return questData
