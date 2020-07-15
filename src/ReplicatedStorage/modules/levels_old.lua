
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network = modules.load("network")

local module = {}

-- returns the total exp needed to reach this level

function module.getBaseEXPForLevel(level)
	return ((0.08/level)*level^6)/1.15
--	return 0.0444+(1/level)*level^5
--	return (10.5 * (level) ^ (3.24))
end



function module.getEXPForLevel(level)
	return 70 + 100*(level-1)^1.3 + module.getBaseEXPForLevel(level) - module.getBaseEXPForLevel(level - 1)
end

local function getStatForLevel(level)
	return 0.008*level^2 + 13*level^(1/2.1) + level		
end

function module.getMonsterHealthForLevel(level)
	return math.floor(70 + (60 * (level - 1)^1.07))
end

function module.getMonsterDefenseForLevel(level)
	return getStatForLevel(level^1.02) 
end

function module.getMonsterDamageForLevel(level)
	return getStatForLevel(level^1.02) - 7
end

-- bounty data
module.bountyPageInfo = {
	["1"] = {
		{kills = 10;};
		{kills = 30;};
		{kills = 80;};
	};
	["2"] = {
		{kills = 20;};
		{kills = 70;};
		{kills = 150;};
	};	
	["3"] = {
		{kills = 30;};
		{kills = 100;};
		{kills = 250;};
	};	
	["99"] = {
		{kills = 1;};
		{kills = 3;};
		{kills = 10;};
	};		
}


function module.getBountyGoldReward(bountyInfo, monster)
	return bountyInfo.kills * (module.goldMulti or 1) * module.getQuestGoldFromLevel(monster.level or 1)/25 	
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
			local cost = 1.35 * module.getQuestGoldFromLevel(level) * level^(1/3)
			local modifierData 
			if itemBaseData.equipmentSlot then
				if itemBaseData.equipmentSlot == 1 then
					-- weapons
					local damage = stat					
					cost = cost * 0.7
					

					return {damage = math.ceil(damage); cost = math.floor(cost); }
				
				elseif itemBaseData.equipmentSlot == 11 then
					return {cost = math.floor(cost * 0.6)}
				
				else
					local upgradeStat
					
					-- armor
					local defense
					if itemBaseData.equipmentSlot == 8 then
						-- body
						defense = stat
						cost = cost * 1
						
						if itemBaseData.noDefense == true then
							defense = 0
						end
						
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
							upgradeStat = {
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
							upgradeStat = {		
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
							upgradeStat = {							
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
						return {defense = math.ceil(defense); cost = math.floor(cost); modifierData = modifierData; upgradeStat = upgradeStat}
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

-- calculates the exp gained for a monster kill 
function module.getEXPGainedFromMonsterKill(baseMonsterEXP, monsterLevel, playerCurrentLevel)
	-- general formula for this seems to be (baseMultiFactor * levelDifferenceFactor + minimumEXP) * totalMultiFactor
	-- we should always at least grant the player 1 EXP
	-- the formula below is just pulled from Pokemon, we'll customize it later
--	return ((baseMonsterEXP * monsterLevel ^ 0.9) / 8) * ((2 * monsterLevel + 10) ^ 2.5 / (monsterLevel + playerCurrentLevel + 10) ^ 2.5) + 1
	
	local levelDifference = playerCurrentLevel - monsterLevel
	local levelMulti = math.clamp(1 - levelDifference / 7, 0.25, 1.5)
	
	return baseMonsterEXP * levelMulti 
end

return module