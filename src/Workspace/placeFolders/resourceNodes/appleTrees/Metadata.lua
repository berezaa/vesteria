-- Node Metadata
-- Rocky28447
-- July 2, 2020



local RNG = Random.new()
local EffectsStorage = script.EffectsStorage

return {
	
	DestroyOnDeplete = false;
	Durability = 1;
	Harvests = 24;
	IsGlobal = true;
	Replenish = 300;
	
	LootTable = {
		Drops = 1;
		Items = {
			[1] = {
				ID = 226;
				Chance = 1;
				Amount = function()
					return 1
				end;
				Modifiers = function()
					return {
						stacks = 1
					}
				end
			};
		}
	};
	
	-- Used to define weapons that will deal MORE than 1 damage
	Effectiveness = {
		
	};
	
	Animations = {
--		OnHarvest = function(node, dropPoint)
--		end;
--		
--		OnDeplete = function(node)
--		end;
--		
--		OnReplenish = function(node)
--		end;
	}
}