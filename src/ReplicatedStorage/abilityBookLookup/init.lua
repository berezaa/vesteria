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
	for i, abilityBookModule in pairs(script:GetChildren()) do
		local abilityBookData = require(abilityBookModule)
		
		-- internal stuff
		abilityBookData.module = abilityBookModule
		
		-- hook ups
		lookupTable[string.lower(abilityBookData.name)] = abilityBookData
		lookupTable[string.upper(abilityBookData.name):sub(1, 1) .. abilityBookData.name:sub(2)] = abilityBookData
	end
end

return lookupTable