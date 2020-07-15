 
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network = modules.load("network")

local module = {}

-- returns the total exp needed to reach this level
function module.getEXPForLevel(level)
	return 7 + 5*(level - 2) + 4*(level - 2)^2
end


function module.getTotalAP(playerData)
	return playerData.level - 1
end


-- returns the exp granted from a quest at a specific level
function module.getQuestGoldFromLevel(questLevel)
	return 100 + math.floor(questLevel ^ 1.18 * 300)
end

-- returns the exp needed to gain the level above the given
function module.getEXPToNextLevel(currentLevel)
	return module.getEXPForLevel(currentLevel + 1)
end

-- returns the exp granted from a quest at a specific level
function module.getQuestEXPFromLevel(questLevel)
	return 10 + (module.getEXPToNextLevel(questLevel) * (1/1.5) * questLevel^(-1/6))
end

function module.getMonsterEXPFromLevel(questLevel)
	local killsToLevel = 7 * (1 + questLevel^1.21 - questLevel^1.1)
	return module.getEXPToNextLevel(questLevel) * killsToLevel^-1
end

-- let andrew decide whatever
function module.getBaseStatInfoForMonster(monsterLevel)
	monsterLevel = 0--monsterLevel or 1
	
	return {
		str = monsterLevel * 1;
		int = monsterLevel * 1;
		dex = monsterLevel * 1;
		vit = monsterLevel * 1;
	}
end




-- returns main stat and cost of equipment based on the itemBaseData
function module.getEquipmentInfo(itemBaseData)
	if itemBaseData then
		local level = itemBaseData.level or itemBaseData.minLevel
		if level then
			local stat = getStatForLevel(level)		
--			local stat = 0.009*level^2 + 3*level + 12

			-- me: can we get good cost algorithm
			-- mom: we have good cost algorithm at home
			-- cost algorithm at home:
			local function sig(x)
				local e = 2.7182818284590452353602874713527
				return 15 / (1 + e^(-1 * (0.25 * x - 9)))
			end
			local cost = 1.35 * module.getQuestGoldFromLevel(level) * level^(1/3) * math.max(sig(level), 1)	
			local rarity = itemBaseData.rarity or "Common"
			if rarity == "Legendary" then
				cost = cost * 2
			elseif rarity == "Rare" then
				cost = cost * 1.5
			end
			local modifierData 
			if itemBaseData.equipmentSlot then
				if itemBaseData.equipmentSlot == 1 then
					-- weapons
					local damage = stat					
					cost = cost * 0.7
					if rarity == "Legendary" then
						damage = damage + 10
					elseif rarity == "Rare" then
						damage = damage + 5
					end
					return {damage = math.ceil(damage); cost = math.floor(cost); }
				
				elseif itemBaseData.equipmentSlot == 11 then
					return {cost = math.floor(cost * 0.6)}
				
				else
					local statUpgrade
					
					-- armor
					local defense
					if itemBaseData.equipmentSlot == 8 then
						-- body
						defense = stat 
						if rarity == "Legendary" then
							defense = defense + 10
						elseif rarity == "Rare" then
							defense = defense + 5
						end
						cost = cost * 1
						
						defense = defense * (itemBaseData.defenseModifier or 1)
						
					elseif itemBaseData.equipmentSlot == 9 then
						-- lower
						defense = 0
						cost = cost * 0.35
					elseif itemBaseData.equipmentSlot == 2 then
						-- hat
						defense = 0
						cost = cost * 0.5
						local value = stat/5
						local distribution = itemBaseData.statDistribution
						
						if itemBaseData.minimumClass == "hunter" then
							distribution = distribution or {
								str = 0;
								dex = 1;
								int = 0;
								vit = 0;
							}
							statUpgrade = {
								str = 0;
								dex = 1;
								int = 0;
								vit = 0;
							}
						elseif itemBaseData.minimumClass == "warrior" then
							distribution = distribution or {
								str = 1;
								dex = 0;
								int = 0;
								vit = 0;
							}		
							statUpgrade = {		
								str = 1;
								dex = 0;
								int = 0;
								vit = 0;
							}		
			
						elseif itemBaseData.minimumClass == "mage" then
							distribution = distribution or {
								str = 0;
								dex = 0;
								int = 1;
								vit = 0;
							}	
							statUpgrade = {							
								str = 0;
								dex = 0;
								int = 1;
								vit = 0;
							}	
						end	
						if distribution then
							modifierData = {}
							for stat, coefficient in pairs(distribution) do
								modifierData[stat] = math.floor(value * coefficient)
							end
						end
--						modifierData = {int = math.floor(value)}					
					end
					if defense then
						return {defense = math.ceil(defense); cost = math.floor(cost); modifierData = modifierData; statUpgrade = statUpgrade}
					end
					return false
				end
			end
		end
	end
	return false
end



function module.getPlayerTickHealing(player)
	if player and player.Character and player:FindFirstChild("level") and player.Character.PrimaryPart then
		local level = player.level.Value
		local vit 	= player.vit.Value
		
		return (0.24 * level) + (0.1 * vit)
	end
	
	return 0
end
-- warning: this is just base crit chance. Doesn't include bonus crit chance from equipment
function module.calculateCritChance(dex, playerLevel)
	return 0 --math.clamp(0.4 * (dex / (3 * playerLevel)), 0, 1)
end

function module.getPlayerCritChance(player)
	if runService:IsServer() then
		local playerData = network:invoke("getPlayerData", player)
		
		if playerData then
			return module.calculateCritChance(
				playerData.nonSerializeData.statistics_final.dex,
				playerData.level
			) + (playerData.nonSerializeData.statistics_final.criticalStrikeChance or 0)
		end
	else
		warn("attempt to call getPlayerCritChance on client")
	end
	
	return 0
end

function module.getAttackSpeed(dex)
	return dex * 0.5 / 2
end

function module.getMonsterGoldForLevel(level)
	return 10 + (3 * (level - 1))
end

function module.getStatPointsForLevel(level)
	return 3 * (level-1)
end

-- returns the level associated with the exp
function module.getLevelForEXP(exp)
	return math.floor((5 * exp / 10) ^ (1 / 3))
end


-- returns how much exp you are past the exp required to earn your current level
function module.getEXPPastCurrentLevel(currentEXP)
	return currentEXP
	--return currentEXP - module.getEXPForLevel(math.floor(module.getLevelForEXP(currentEXP)))
end

-- returns fraction of how close you are until next level
function module.getFractionForNextLevel(currentEXP)
	return module.getEXPPastCurrentLevel(currentEXP) / module.getEXPToNextLevel(math.floor(module.getLevelForEXP(currentEXP)))
end


return module