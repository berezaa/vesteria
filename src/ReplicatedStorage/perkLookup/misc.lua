local perkData = {
	perks = {
		--[[
		["warrior"] = {
			layoutOrder = 1;
			title = "Steadfast";
			subtitle = "Warrior Perk";
			color = Color3.fromRGB(130, 59, 60);
			description = "Take 20% less damage.";
			-- auto-assign based on class
			class = "warrior";			
			apply 		= function(statistics_final)
				statistics_final.damageTakenMulti = statistics_final.damageTakenMulti * 0.8
			end;
		};	
		]]
		["holymagic"] = {
			layoutOrder = 1;
			title = "Holy Magic";
			subtitle = "Cleric Perk";
			color = Color3.fromRGB(235, 198, 48);
			description = "Mage Ability upgrade.";
			-- auto-assign based on class
			class = "cleric";			
		};			
		["colosseum"] = {
			layoutOrder = 2;
			title = "Colosseum Blessing";
			subtitle = "Location Perk";
			color = Color3.fromRGB(226, 166, 61);
			description = "Take 50% less damage.";
			-- auto-assign based on class
			condition   = function(statistics_final)
				return game.PlaceId == 2496503573 or game.PlaceId == 4042381342
			end;					
			apply 		= function(statistics_final)
				statistics_final.damageTakenMulti = statistics_final.damageTakenMulti * 0.5
			end;
		};
		
		["battydagger"] = {
			layoutOrder = 1,
			title = "Nocturnal Flight",
			color = Color3.fromRGB(77, 34, 89),
			description = "Shunpo has no cooldown.",
		}
	}
}
return perkData