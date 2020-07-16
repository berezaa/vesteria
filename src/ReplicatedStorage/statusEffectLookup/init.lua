--[[
	abilityData {}
		--> identifying information <--
		int abilityId

		--> generic information <--
		string name
		string image
		string description

		--> execution information <--
		function 	execute
		number 		maxRank
		number 		cooldown
		number 		cost
		table 		prerequisite

	prerequisiteData {}
		number abilityId
		number points
--]]

local lookupTable = {} do
	for _, statusEffectDataModule in pairs(script:GetChildren()) do
		local statusEffectData = require(statusEffectDataModule)

		-- internal stuff
		statusEffectData.module = statusEffectDataModule

		-- hook ups
		lookupTable[statusEffectData.id] 			= statusEffectData
		lookupTable[statusEffectDataModule.Name] 	= statusEffectData
	end
end

return lookupTable