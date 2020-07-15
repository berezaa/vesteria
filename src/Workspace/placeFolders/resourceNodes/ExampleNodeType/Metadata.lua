-- Node Metadata
-- Rocky28447
-- July 2, 2020



local RNG = Random.new()
local EffectsStorage = script.EffectsStorage

return {
	
	DestroyOnDeplete = false;
	Durability = 3;
	Harvests = 3;
	IsGlobal = true;
	Replenish = 0;
	
	LootTable = {
		Drops = 3;
		Items = {
			[1] = {
				ID = 288;
				Chance = 0.5;
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
		OnHarvest = function(node, dropPoint)
		end;
		
		OnDeplete = function(node)
		end;
		
		OnReplenish = function(node)
		end;
	}
}