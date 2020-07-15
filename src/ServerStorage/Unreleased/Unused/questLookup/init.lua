--[[
	
	
	
	objectiveData {}
		-- tells the game how to handle this objective
		string objectiveType["kill-monster"; ""]
		
		-- contents will depend on what the objectiveType is
		table requirement
	
	questData {}
		-- identifying data
		int id
		
		-- generic data
		questLineName = "";
		questLineimage = "";
		questLinedescription = "";
		
		-- questline requirements
		requireQuests = {}; 
		repeatableData = {value = true, timeInterval = 60*4}; 
		requireClass = nil;
		
		
		
		-- processing data
		{objectiveData} objectives
		
	playerObjectiveData {}
		
		
		-- rewards data
		{inventorySlotData} rewards
		
		
		requireLevel = 1;
			
		-- processing data
			
		
		giverNpcName = "Bobby";
		handerNpcName = "Bobby";
			
		
		objectiveName = "Test Part 1";
		completedText = "Return to Bobby my boy";
		
		
		table steps
			-- contents will depend on what the objectiveType is
			table requirement
		
			-- contents will depend on what the objectiveType is
			table completion
			
			-- tells the game how to handle this objective
			string triggerType["monster-killed"; "item-collected"]
	
	playerQuestData {}
		int id
		int startTime
		int startTimeUTC
		{playerObjectiveData} objectives
	
	completePlayerQuestData {}
		int id
		int completionTime
		int startTimeUTC
--]]

local lookupTable = {} do
	for i, questDataModule in pairs(script:GetChildren()) do
		local questData = require(questDataModule)
		
		-- internal stuff
		questData.module = questDataModule
		
		-- hook ups
		lookupTable[questData.id] 			= questData
		lookupTable[questDataModule.Name] 	= questData
	end
end

return lookupTable