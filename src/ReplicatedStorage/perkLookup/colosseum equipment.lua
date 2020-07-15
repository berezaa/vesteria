local modules = require(game.ReplicatedStorage.modules)
	local network = modules.load("network")
	local tempData = modules.load("tempData")
	local events = modules.load("events")
	local utilities = modules.load("utilities")

local rand = Random.new()

local perkData = {
	sharedValues = {
		layoutOrder = 0;
		subtitle = "Equipment Perk";
		color = Color3.fromRGB(234, 102, 84);
	},
	perks = {

		["inoculation"] = {
			title = "Inoculation",
			description = "10% chance to heal 200 HP when damaged.",
			
			onDamageTaken = function(sourceManifest, sourceType, sourceId, targetManifest, damageData)
				if damageData.damage > 1 and rand:NextNumber() <= 0.1 then
					-- wait required to seperate damage from healing
					-- healing should probably get its own signal like damage has now
					wait(0.1)
					pcall(function()
						utilities.healEntity(targetManifest, targetManifest, 200)
						local heal = script.heal:Clone()
						heal.Parent = targetManifest
						heal:Emit(30)
						game.Debris:AddItem(heal,3)
						utilities.playSound("item_heal", targetManifest)
					end)
				end
			end;
		},
		["resonance"] = {
			title = "Resonance Charms",
			description = "Restore 35% of damage taken as MP.",
			
			onDamageTaken = function(sourceManifest, sourceType, sourceId, targetManifest, damageData)
				if damageData.damage > 1 then
					-- wait required to seperate damage from healing
					-- healing should probably get its own signal like damage has now
					wait(0.1)
					pcall(function()
						local restored = math.floor(damageData.damage * 0.35)

						local actuallyRestored 
						if targetManifest.mana.Value + restored > targetManifest.maxMana.Value then
							actuallyRestored = targetManifest.maxMana.Value - targetManifest.mana.Value
						else
							actuallyRestored = restored
						end

						targetManifest.mana.Value = math.min(targetManifest.mana.Value + restored, targetManifest.maxMana.Value)
						if actuallyRestored >= 10 then
							
							local heal = script.manaEmitter:Clone()
							heal.Parent = targetManifest
							heal:Emit(math.floor(math.clamp( 3 * actuallyRestored^(1/2), 1, 50)))
							game.Debris:AddItem(heal,3)
							
							utilities.playSound("item_mana", targetManifest, nil, {volume = 0.3; maxDistance = 100; emitterSize = 7}) 

						end
					end)
				end
			end;
		},		
		["reckless"] = {
			title = "Reckless",
			description = "Deal and recieve 120% damage.",
			
			onDamageTaken = function(sourceManifest, sourceType, sourceId, targetManifest, ref_damageData)
				ref_damageData.damage = ref_damageData.damage * 1.2
			end;
			onDamageGiven = function(sourceManifest, sourceType, sourceId, targetManifest, ref_damageData)
				ref_damageData.damage = ref_damageData.damage * 1.2
			end
		},		
	}
}
return perkData