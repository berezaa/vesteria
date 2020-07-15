--[[
	blessingData {}
		--> identifying information <--
		int blessingId
		
		--> generic information <--
		string name
		string image
		string description
		
		--> execution information <--
		
--]]

local lookupTable = {} do
	for i, blessingDataModule in pairs(script:GetChildren()) do
		local blessingData = require(blessingDataModule)
		
		-- internal stuff
		blessingData.module = blessingDataModule
		
		-- hook ups
		lookupTable[blessingData.id] 			= blessingData
		lookupTable[blessingDataModule.Name] 	= blessingData
	end
end

return lookupTable