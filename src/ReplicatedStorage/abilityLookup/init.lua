local lookupTable = {}
local registerIds = {}

for i, abilityDataModule in pairs(script:GetChildren()) do
	local abilityData = require(abilityDataModule)

	lookupTable[abilityData.id] = abilityData
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