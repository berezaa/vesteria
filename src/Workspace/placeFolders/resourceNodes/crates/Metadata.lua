-- Node Metadata
-- Rocky28447
-- July 2, 2020



local RNG = Random.new()
local EffectsStorage = script.EffectsStorage

return {
	
	DestroyOnDeplete = true;
	Durability = 3;
	Harvests = 1;
	IsGlobal = true;
	Replenish = 20;
	
	LootTable = {
		Drops = 4;
		Items = {
			[1] = {
				ID = 1;
				Chance = 1;
				Amount = function()
					return RNG:NextInteger(2, 3)
				end;
				Modifiers = function()
					return {
						value = RNG:NextInteger(3, 5)
					}
				end
			};
			[2] = {
				ID = 87;
				Chance = 0.75;
				Amount = function()
					return RNG:NextInteger(1, 2)
				end;
				Modifiers = function()
					return {
						stacks = 1
					}
				end
			};
			[3] = {
				ID = 270;
				Chance = 0.75;
				Amount = function()
					return 1
				end;
				Modifiers = function()
					return {
						stacks = 1
					}
				end
			};
			[4] = {
				ID = 226;
				Chance = 0.75;
				Amount = function()
					return 1
				end;
				Modifiers = function()
					return {
						stacks = 1
					}
				end
			};
			[5] = {
				ID = 144;
				Chance = 0.08;
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