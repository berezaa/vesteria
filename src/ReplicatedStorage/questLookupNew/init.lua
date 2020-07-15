local lookupTable = {}

for i, questModule in pairs(script:GetChildren()) do
	local questData = require(questModule)
	if questData then
		if lookupTable[questData.id] then
			warn("QuestId: " .. questData.id .. " already taken.")
		else
			lookupTable[questData.id] = questData
		end
	end
end

return lookupTable
