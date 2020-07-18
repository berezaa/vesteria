--[[
	monsterData {}

--]]

local replicatedStorage = game:GetService("ReplicatedStorage")

local lookupTable = {} do
	for _, monsterDataModule in pairs(script:GetChildren()) do
		local monsterData = require(monsterDataModule)

		-- internal stuff
		monsterData.module = monsterDataModule
		monsterData.entity = replicatedStorage:WaitForChild("assets"):WaitForChild("monsters"):WaitForChild(monsterDataModule.name):WaitForChild("entity")

		local defaultStatesData = require(replicatedStorage.defaultMonsterState)
		local statesData
		local statesModule = monsterDataModule:FindFirstChild("states")
		if statesModule then
			statesData = require(statesModule)
		end
		if statesData then
			setmetatable(statesData, {__index = defaultStatesData})
			setmetatable(statesData.states, {__index = defaultStatesData.states})
		else
			statesData = defaultStatesData
		end
		monsterData.statesData = statesData
		-- hook ups
		lookupTable[monsterDataModule.Name] = monsterData
	end
end

return lookupTable