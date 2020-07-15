local abilities = {} do
	--[[
	coroutine.resume(coroutine.create(function()
		for i, v in pairs(game.ReplicatedStorage.abilityLookup:GetChildren()) do
			table.insert(abilities, {id = require(v).id})
		end
	end))
	]]
	spawn(function()
		local abilityLookup = require(game.ReplicatedStorage.abilityLookup)
		for id, ability in pairs(abilityLookup) do
			-- prevent duplicates for string ids
			if typeof(id) == "number" then
				table.insert(abilities, {id = id})
			end
		end
	end)
end

return {
	name 					= "Admin";
	pointsGainPerLevel 		= 5;
	startingPoints 			= 0;
	lockPointsOnClassChange = false;
	minLevel 				= 1;
	maxLevel				= 9999999999;
	
	-- visual attributes
	layoutOrder				= 5;
	bookColor				= Color3.fromRGB(130, 78, 154);
	
	abilities = abilities;
}