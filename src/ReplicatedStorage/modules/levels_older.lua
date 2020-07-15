local module = {}
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network = modules.load("network")

-- returns the total exp needed to reach this level
function module.getEXPForLevel(level)
	return 70 + (10 * level ^ (3.35)) - (10 * (level - 1) ^ (3.35))
end

function module.getMonsterHealthForLevel(level)
	return 100 + (70 * (level - 1))
end

function module.getMonsterDamageForLevel(level)
	return 8 + (12 * (level - 1))
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
	return math.clamp(0.4 * (dex / (3 * playerLevel)), 0, 1)
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
	return 3 * level
end

-- returns the level associated with the exp
function module.getLevelForEXP(exp)
	return math.floor((5 * exp / 10) ^ (1 / 3))
end

-- returns the exp needed to gain the level above the given
function module.getEXPToNextLevel(currentLevel)
	return module.getEXPForLevel(currentLevel + 1)
end

-- returns the exp granted from a quest at a specific level
function module.getQuestEXPFromLevel(questLevel)
	return 30 + ((7 * questLevel ^ (3.35)) - (7 * (questLevel - 1) ^ (3.35)))
end

-- returns the exp granted from a quest at a specific level
function module.getQuestGoldFromLevel(questLevel)
	return questLevel * 50
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
	local levelMulti = math.clamp(1 - levelDifference / 10, 0.1, 1.5)
	
	return baseMonsterEXP * levelMulti 
end

return module