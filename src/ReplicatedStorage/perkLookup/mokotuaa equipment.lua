local modules = require(game.ReplicatedStorage.modules)
	local network = modules.load("network")
	local tempData = modules.load("tempData")
	local events = modules.load("events")

local function keyDamage(slot)
	return "perk_rhythmDamage_"..slot
end

local function keyStun(slot)
	return "perk_rhythmStun_"..slot
end

local function keyDefense(slot)
	return "perk_rhythmDefense_"..slot
end

local function keyMana(slot)
	return "perk_rhythmMana_"..slot
end

local function keySplinter(slot)
	return "perk_rhythmSplinter_"..slot
end

local function keyAttackSpeed(slot)
	return "perk_rhythmAttackSpeed_"..slot
end

local perkData = {
	sharedValues = {
		layoutOrder = 0;
		subtitle = "Equipment Perk";
		color = Color3.fromRGB(235, 131, 82);
	},
	perks = {
		["rhythmDamage"] = {
			title = "Rhythmic Ferocity",
			description = "Every 4th basic attack deals extra damage.",
			
			onEquipped = function(player, itemData, slot)
				if slot ~= "1" then return end
				
				local data = {
					hits = 0,
				}
				
				data.guid = events:registerForEvent("playerWillDealDamage", function(playerDamaging, damageData)
					if playerDamaging ~= player then return end
					if damageData.sourceType ~= "equipment" then return end
					
					data.hits = data.hits + 1
					if data.hits == 4 then
						data.hits = 0
						damageData.damage = damageData.damage * 2
					end
				end)
				
				tempData:set(player, keyDamage(slot), data)
			end,
			
			onUnequipped = function(player, itemData, slot)
				if slot ~= "1" then return end
				
				local data = tempData:get(player, keyDamage(slot))
				events:deregisterFromEvent(data.guid)
				tempData:delete(player, keyDamage(slot))
			end
		},
		
		["rhythmStun"] = {
			title = "Rhythmic Concussion",
			description = "Every 4th basic attack hit stuns the victim.",
			
			onEquipped = function(player, itemData, slot)
				local data = {
					hits = 0,
				}
				
				data.guid = events:registerForEvent("playerWillDealDamage", function(playerDamaging, damageData)
					if playerDamaging ~= player then return end
					if damageData.sourceType ~= "equipment" then return end
					
					local char = player.Character
					if not char then return end
					local manifest = char.PrimaryPart
					if not manifest then return end
					
					data.hits = data.hits + 1
					if data.hits == 4 then
						data.hits = 0
						
						network:invoke(
							"applyStatusEffectToEntityManifest",
							damageData.target,
							"stunned",
							{
								duration = 1,
								modifierData = {
									walkspeed_totalMultiplicative = -1,
								},
							},
							manifest,
							"equipment",
							213
						)
					end
				end)
				
				tempData:set(player, keyStun(slot), data)
			end,
			
			onUnequipped = function(player, itemData, slot)
				local data = tempData:get(player, keyStun(slot))
				events:deregisterFromEvent(data.guid)
				tempData:delete(player, keyStun(slot))
			end
		},
		
		["rhythmDefense"] = {
			title = "Rhythmic Tenacity",
			description = "Every 4th hit suffered deals half damage.",
			
			onEquipped = function(player, itemData, slot)
				local data = {
					hits = 0,
				}
				
				data.guid = events:registerForEvent("playerWillTakeDamage", function(playerDamaged, damageData)
					if playerDamaged ~= player then return end
					
					data.hits = data.hits + 1
					if data.hits == 4 then
						data.hits = 0
						damageData.damage = damageData.damage / 2
					end
				end)
				
				tempData:set(player, keyDefense(slot), data)
			end,
			
			onUnequipped = function(player, itemData, slot)
				local data = tempData:get(player, keyDefense(slot))
				events:deregisterFromEvent(data.guid)
				tempData:delete(player, keyDefense(slot))
			end
		},
		
		["rhythmMana"] = {
			title = "Rhythmic Invocation",
			description = "Every 4th ability used costs no mana.",
			
			onEquipped = function(player, itemData, slot)
				local data = {
					uses = 0,
				}
				
				data.guid = events:registerForEvent("playerWillUseAbility", function(playerUsing, abilityData)
					if playerUsing ~= player then return end
					
					data.uses = data.uses + 1
					if data.uses == 4 then
						data.uses = 0
						abilityData.manaCost = 0
					end
				end)
				
				tempData:set(player, keyMana(slot), data)
			end,
			
			onUnequipped = function(player, itemData, slot)
				local data = tempData:get(player, keyMana(slot))
				events:deregisterFromEvent(data.guid)
				tempData:delete(player, keyMana(slot))
			end
		},
		
		["rhythmSplinter"] = {
			title = "Rhythmic Splintering",
			description = "Only every 4th shot uses an arrow.",
			
			onEquipped = function(player, itemData, slot)
				if slot ~= "1" then return end
				
				local data = {
					uses = 0,
				}
				
				data.guid = events:registerForEvent("playerWillUseArrow", function(playerUsing, arrowData)
					if playerUsing ~= player then return end
					
					data.uses = data.uses + 1
					if data.uses == 4 then
						data.uses = 0
						
						arrowData.needsArrow = true
					else
						arrowData.needsArrow = false
					end
				end)
				
				tempData:set(player, keySplinter(slot), data)
			end,
			
			onUnequipped = function(player, itemData, slot)
				if slot ~= "1" then return end
				
				local data = tempData:get(player, keySplinter(slot))
				events:deregisterFromEvent(data.guid)
				tempData:delete(player, keySplinter(slot))
			end
		},
		
		["rhythmAttackSpeed"] = {
			title = "Rhythmic Acceleration",
			description = "Every 4th hit temporarily boosts attack speed.",
			
			onEquipped = function(player, itemData, slot)
				if slot ~= "1" then return end
				
				local data = {
					hits = 0,
				}
				
				data.guid = events:registerForEvent("playerWillDealDamage", function(playerDamaging, damageData)
					if playerDamaging ~= player then return end
					if damageData.sourceType ~= "equipment" then return end
					
					local char = player.Character
					if not char then return end
					local manifest = char.PrimaryPart
					if not manifest then return end
					
					data.hits = data.hits + 1
					if data.hits == 4 then
						data.hits = 0
						
						network:invoke(
							"applyStatusEffectToEntityManifest",
							manifest,
							"empower",
							{
								duration = 2,
								modifierData = {
									attackSpeed = 0.25,
								},
							},
							manifest,
							"item",
							210
						)
					end
				end)
				
				tempData:set(player, keyAttackSpeed(slot), data)
			end,
			
			onUnequipped = function(player, itemData, slot)
				if slot ~= "1" then return end
				
				local data = tempData:get(player, keyAttackSpeed(slot))
				events:deregisterFromEvent(data.guid)
				tempData:delete(player, keyAttackSpeed(slot))
			end
		},
	}
}
return perkData