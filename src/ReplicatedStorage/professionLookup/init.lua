	

local lookupTable = {} do
	for i, professionDataModule in pairs(script:GetChildren()) do
		local professionData = require(professionDataModule)
		
		-- internal stuff
		professionData.module = professionDataModule
		
		-- hook ups
		lookupTable[professionData.id] 		= professionData
		lookupTable[professionDataModule.Name] = professionData
	end
end

return lookupTable