local modules = require(game.ReplicatedStorage.modules)
local network = modules.load("network")
local targeting = modules.load("damage")
local utilities = modules.load("utilities")

local itemLookup = require(game.ReplicatedStorage.itemData)

local function isDay(clockTime)
	return (clockTime > 6) and (clockTime < 18)
end

local function isNight(clockTime)
	return not isDay(clockTime)
end

local perkData = {
	sharedValues = {
		layoutOrder = 0,
		subtitle = "Equipment Perk",
		color = BrickColor.new("Cool yellow").Color,
	},
	
	perks = {
		["overdraw"] = {
			title = "Overdraw",
			description = "Fires larger arrows further.",
			
			-- implementation is with arrow basic attacks
		},
		
		["you look great"] = {
			title = "You Look Great",
			description = "Not even the Sun can stand in your way.",
			
			-- implementation is somewhere
		},		
		
		["solar wind"] = {
			title = "Solar Wind",
			description = "Increases the range of Blink.",
			
			-- implementation is in the Blink ability
		},
		
		["one good hit"] = {
			title = "One Good Hit",
			description = "Execute instantly kills low health non-resilient foes.",
			
			-- implementation is in Execute ability
		},
		
		["aftershock"] = {
			title = "Aftershock",
			description = "Adds shockwaves to Ground Slam.",
			
			-- implementation is in Ground Slam ability
		},
		
		["dunes wisdom"] = {
			title = "Dunes Wisdom",
			description = "Regenerate extra mana during the day.",
			
			onTimeOfDayUpdated = function(player, clockTime, dt)
				if not isDay(clockTime) then return end
				
				local char = player.Character
				if not char then return end
				local entity = char.PrimaryPart
				if not entity then return end
				local mana = entity:FindFirstChild("mana")
				local maxMana = entity:FindFirstChild("maxMana")
				if not (mana and maxMana) then return end
				
				local regenerationPerSecond = 6
				mana.Value = math.min(maxMana.Value, mana.Value + regenerationPerSecond * dt)
			end,
		},
		
		["apogee"] = {
			title = "Apogee",
			description = "During the day, deal more damage and regenerate health.",
			
			onDamageGiven = function(sourceManifest, sourceType, sourceId, targetManifest, damageData)
				if isDay(game.Lighting.ClockTime) then
					damageData.damage = damageData.damage * 1.2
				end
			end,
			
			onTimeOfDayUpdated = function(player, clockTime, dt)
				if not isDay(clockTime) then return end
				
				local char = player.Character
				if not char then return end
				local entity = char.PrimaryPart
				if not entity then return end
				local health = entity:FindFirstChild("health")
				local maxHealth = entity:FindFirstChild("maxHealth")
				local state = entity:FindFirstChild("state")
				if not (health and maxHealth and state) then return end
				if state.Value == "dead" then return end
				
				local regenerationPerSecond = 20
				health.Value = math.min(maxHealth.Value, health.Value + regenerationPerSecond * dt)
			end,
		},
		
		["midnight"] = {
			title = "Midnight",
			description = "During the night, deal more damage and move faster.",
			
			onDamageGiven = function(sourceManifest, sourceType, sourceId, targetManifest, damageData)
				if isNight(game.Lighting.ClockTime) then
					damageData.damage = damageData.damage * 1.2
				end
			end,
			
			onTimeOfDayUpdated = function(player, clockTime, dt)
				if not isNight(clockTime) then return end
				
				local char = player.Character
				if not char then return end
				local entity = char.PrimaryPart
				if not entity then return end
				
				network:invoke(
					"applyStatusEffectToEntityManifest",
					entity,
					"empower",
					{
						hideInStatusBar = true,
						duration = 5,
						modifierData = {walkspeed = 4},
					},
					entity,
					"perk"
				)
			end,
		},
		
		["twilight"] = {
			title = "Twilight",
			description = "Empower Magic Missile to launch Mana Stars.",
			
			-- implementation is in Magic Missile
		},
		
		["acidic arrows"] = {
			title = "Acidic Arrows",
			description = "Critical strikes on enemies create a splash of acid.",
			
			onCritGiven = function(sourceManifest, sourceType, sourceId, targetManifest, damageData)
				local player = game:GetService("Players"):GetPlayerFromCharacter(sourceManifest.Parent)
				if not player then return end
				
				local isArrow = (damageData.sourceType == "equipment") and (damageData.category == "projectile")
				if not isArrow then return end
				
				local radius = 12
				
				network:fireAllClients("effects_requestEffect", "acidSplash", {
					position = damageData.position,
					radius = radius,
					duration = 0.25,
				})
				
				local function damageEntity(entity)
					local entityType = entity:FindFirstChild("entityType")
					if not entityType then return end
					entityType = entityType.Value
					
					local damageData = {
						damage = damageData.damage / 2,
						sourceType = "perk",
						sourceId = 0,
						damageType = "magical",
						sourcePlayerId = player.UserId,
					}
					
					if entityType == "monster" then
						network:invoke("monsterDamageRequest_server", player, entity, damageData)
					else
						network:invoke("playerDamageRequest_server", player, entity, damageData)
					end
				end
				
				local radiusSq = radius * radius
				for _, target in pairs(targeting.getDamagableTargets(game.Players.LocalPlayer)) do
					local delta = target.Position - damageData.position
					local distanceSq = delta.X * delta.X + delta.Y * delta.Y + delta.Z * delta.Z
					if distanceSq < radiusSq then
						damageEntity(target)
					end
				end
			end,
		},
		
		["dunes courage"] = {
			title = "Dunes Courage",
			description = "Deal more damage to non-human Dunes enemies.",
			
			onDamageGiven = function(sourceManifest, sourceType, sourceId, targetManifest, damageData)
				local n = targetManifest.Name
				if
					n == "Stingtail" or
					n == "Deathsting" or
					n == "Sandwurm" or
					n == "Scarab"
				then
					damageData.damage = damageData.damage * 1.2
				end
			end,
		},
		
		["bloodcraze"] = {
			title = "Bloodcraze",
			description = "Critical hits grant a stacking attack speed bonus.",
			
			onCritGiven = function(sourceManifest, sourceType, sourceId, targetManifest, damageData)
				local guid = utilities.getEntityGUIDByEntityManifest(sourceManifest)
				if not guid then return false end
				
				local statuses = network:invoke("getStatusEffectsOnEntityManifestByEntityGUID", guid)
				
				local stacks = 0
				
				for _, status in pairs(statuses) do
					if status.statusEffectType == "bloodcrazed" then
						stacks = status.statusEffectModifier.stacks
					end
				end
				
				stacks = math.min(stacks + 1, 6)
				
				network:invoke(
					"applyStatusEffectToEntityManifest",
					sourceManifest,
					"empower",
					{
						stacks = stacks,
						duration = 8,
						modifierData = {attackSpeed = 0.05 * stacks},
					},
					sourceManifest,
					"item",
					229
				)
			end
		},
		
		["weakening venom"] = {
			title = "Weakening Venom",
			description = "Melee attacks mark a target to take more damage.",
			
			onDamageGiven = function(sourceManifest, sourceType, sourceId, targetManifest, damageData)
				if damageData.sourceType == "equipment" then
					network:invoke(
						"applyStatusEffectToEntityManifest",
						targetManifest,
						"weakened by venom",
						{
							duration = 5,
						},
						sourceManifest,
						"item",
						230
					)
				elseif damageData.sourceType == "ability" then
					local hasStatus, status = network:invoke("doesEntityHaveStatusEffect", targetManifest, "weakened by venom")
					
					if hasStatus then
						damageData.damage = damageData.damage * 1.5
						network:invoke("revokeStatusEffectByStatusEffectGUID", status.statusEffectGUID)
					end
				end
			end,
		},
		
		["just in case"] = {
			title = "Just in Case",
			description = "Increase damage when above 80% health. Does not work in off-hand.",
			
			onDamageGiven = function(sourceManifest, sourceType, sourceId, targetManifest, damageData)
				local bowId = 249
				
				local player = game.Players:GetPlayerFromCharacter(sourceManifest.Parent)
				if not player then return end
				
				local equipmentInfo = network:invoke("getPlayerEquipmentDataByEquipmentPosition", player, 1)
				if equipmentInfo.id ~= bowId then return end
				
				local health = sourceManifest:FindFirstChild("health")
				local maxHealth = sourceManifest:FindFirstChild("maxHealth")
				if not (health and maxHealth) then return end
				
				local ratio = health.Value / maxHealth.Value
				if ratio < 0.8 then return end
				
				damageData.damage = damageData.damage * 1.1
			end
		},
		
		["not like this"] = {
			title = "Not Like This",
			description = "Dramatically increase damage when below 20% health. Works in off-hand.",
			
			onDamageGiven = function(sourceManifest, sourceType, sourceId, targetManifest, damageData)
				local health = sourceManifest:FindFirstChild("health")
				local maxHealth = sourceManifest:FindFirstChild("maxHealth")
				if not (health and maxHealth) then return end
				
				local ratio = health.Value / maxHealth.Value
				if ratio > 0.2 then return end
				
				damageData.damage = damageData.damage * 1.4
			end
		},
		
		["living blade"] = {
			title = "Living Blade",
			description = "Basic attacks deal magic damage and scale accordingly.",
			
			onDamageGiven = function(sourceManifest, sourceType, sourceId, targetManifest, damageData)
				if sourceType == "equipment" then
					damageData.damageType = "magical"
				end
			end,
		}
	},
}
return perkData