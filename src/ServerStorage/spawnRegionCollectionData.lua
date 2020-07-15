local Table = {}

for monsterName, monsterData in pairs(require(game.ReplicatedStorage.monsterLookup)) do	
	Table[monsterName.."1/2"] = {
		maxMonsters = 5;
	}
		
	Table[monsterName] = {
		maxMonsters = 10;
	}
	
	Table[monsterName.."2"] = {
		maxMonsters = 15;
	}
	
	Table[monsterName.."3"] = {
		maxMonsters = 35;
	}
	
	Table[monsterName.."0"] = {
		maxMonsters = 1;
	}
end

return Table
--[[
{
	["Baby Shroom"] = {
		maxMonsters = 25;
	};
	["Shroom"] = {
		maxMonsters = 15;
	}	
}
]]