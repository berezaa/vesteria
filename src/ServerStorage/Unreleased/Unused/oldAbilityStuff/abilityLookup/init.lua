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

local lookupTable = {}
local registerIds = {}

for i, abilityDataModule in pairs(script:GetChildren()) do
	local abilityData = require(abilityDataModule)
	local abilityDataFunction
	if typeof(abilityData) == "function" then
		abilityDataFunction = abilityData
		abilityData = abilityDataFunction()
	end
	local metatable = {
		__call = function(t, playerData, abilityExecutionData)
			t = abilityDataFunction and abilityDataFunction(playerData, abilityExecutionData) or t
			t.module = abilityDataModule
			return t
		end;
	}
	abilityData.module = abilityDataModule
	setmetatable(abilityData, metatable)
	lookupTable[abilityData.id] 		= abilityData
	lookupTable[abilityDataModule.Name] = abilityData
	
	if not registerIds[abilityData.id] then
		registerIds[abilityData.id] = true
	else
		warn("@@@ ABILITY ID OVERLAP --", abilityData.id, abilityData.name, abilityDataModule.Name)
	end
end

for i = 1, #script:GetChildren() do
	if not registerIds[i] then
		warn("@@@ ABILITY ID NOT TAKEN", i)
	end
end

	
function lookupTable:GetAbilityIds()
	return registerIds
end

return lookupTable