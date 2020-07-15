local modules = require(game.ReplicatedStorage.modules)
	local network = modules.load("network")
	local utilities = modules.load("utilities")

local SPIDER_BOW_ID = 92
local SPIDER_DAGGER_ID = 52

local perkData = {
	sharedValues = {
		layoutOrder = 0;
		subtitle = "Equipment Perk";
		color = Color3.fromRGB(147, 40, 234);
	};
	perks = {
		["causticwounds"] = {
			title = "Caustic Wounds";
			description = "Basic attacks inflict poison damage.";
			
			onDamageGiven = function(sourceManifest, sourceType, sourceId, targetManifest, ref_damageData)
				-- only perform this bonus if we're using the dagger in main hand
				local player = game.Players:GetPlayerFromCharacter(sourceManifest.Parent)
				if not player then return end
				local data = network:invoke("getPlayerEquipmentDataByEquipmentPosition", player, 1)
				if data.id ~= SPIDER_DAGGER_ID then return end
				
				if targetManifest:FindFirstChild("poisoned") == nil and ref_damageData.sourceType == "equipment" then
					if targetManifest and targetManifest:FindFirstChild("health") and targetManifest:FindFirstChild("maxHealth") then
						if targetManifest.health.Value > 0 then

							local wasApplied, reason = require(game.ReplicatedStorage.modules.network):invoke(
								"applyStatusEffectToEntityManifest",
								targetManifest,
								"poison",
								{duration = 3; healthLost = 1 * ref_damageData.damage},
								sourceManifest,
								"perk",
								52
							)
							if wasApplied then
								local tag = Instance.new("BoolValue")
								tag.Name = "poisoned"
								tag.Parent = targetManifest
								game.Debris:AddItem(tag, 3)	
								utilities.playSound("bubbles", targetManifest)		
								local poison = script.poison:Clone()
								poison.Parent = targetManifest
								poison:Emit(50)
								poison.Enabled = true
								spawn(function()
									wait(3)
									if poison then
										poison.Enabled = false
									end
								end)
								game.Debris:AddItem(poison,5)					
							end
							return wasApplied
						end
					end
				end
			end;
		};	
		["webbedshots"] = {
			title = "Webbed Shots";
			description = "Ranged attacks slow enemies.";
			
			onDamageGiven = function(sourceManifest, sourceType, sourceId, targetManifest, ref_damageData)
				-- only perform this perk when we're in the main hand
				local player = game.Players:GetPlayerFromCharacter(sourceManifest.Parent)
				if not player then return end
				local data = network:invoke("getPlayerEquipmentDataByEquipmentPosition", player, 1)
				if data.id ~= SPIDER_BOW_ID then return end
				
				if targetManifest and targetManifest:FindFirstChild("health") and targetManifest:FindFirstChild("maxHealth") then
					if targetManifest.health.Value > 0 then
						local wasApplied, reason = require(game.ReplicatedStorage.modules.network):invoke(
							"applyStatusEffectToEntityManifest",
							targetManifest,
							"empower",
							{
								duration 		= 3;
								modifierData 	= {
									walkspeed_totalMultiplicative = -0.35;
								};
							},
							targetManifest,
							"perk",
							92
						)
						if wasApplied then
							local slow = script.slow:Clone()
							slow.Parent = targetManifest
							slow:Emit(30)
							game.Debris:AddItem(slow, 3)
						end
						
						return true
					end
				end
			end;
		};	
		["venombomb"] = {
			title = "Venom Bomb";
			description = "Magic bombs leave behind damaging venom.";
			
			apply = function(ref_statistics_final)			
				ref_statistics_final.VENOM_BOMB = true
			end;
		};	
		["manathief"] = {
			title = "Mana Thief";
			description = "Basic attacks steal Mana.";
			
			onDamageGiven = function(sourceManifest, sourceType, sourceId, targetManifest, ref_damageData)
				if ref_damageData.sourceType == "equipment" then
					if targetManifest and sourceManifest:FindFirstChild("mana") and sourceManifest:FindFirstChild("maxMana") then
						if targetManifest:FindFirstChild("mana") and targetManifest:FindFirstChild("maxMana") then
							sourceManifest.mana.Value = math.clamp(sourceManifest.mana.Value + 5, 0, sourceManifest.maxMana.Value)
							targetManifest.mana.Value = math.clamp(targetManifest.mana.Value - 5, 0, targetManifest.maxMana.Value)
							return true
						else
							sourceManifest.mana.Value = math.clamp(sourceManifest.mana.Value + 2, 0, sourceManifest.maxMana.Value)
						end
					end
				end
			end;
		};						
				
	}
}
return perkData