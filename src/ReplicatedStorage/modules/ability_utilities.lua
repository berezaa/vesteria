local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = require(ReplicatedStorage.modules)
local Network = Modules.load("network")
local Utilities = Modules.load("utilities")

local abilityLookup = require(ReplicatedStorage.abilityLookup)

function module.canPlayerEquipAbility(player, playerData, abilityId)
	local abilityData = abilityLookup[abilityId]

	if not playerData then return false, "invalid_data" end
	if not abilityData then return false, "invalid_ability" end

	if playerData.abilities[abilityId] == nil then return false, "ability_locked" end
	if playerData.level < abilityData.prerequisites.playerLevel then return false, "low_level" end

	if abilityData.prerequisites.classRestriction == true then
		if not playerData.class == abilityData.prerequisites.playerClass then return false, "wrong_class" end
	end

	--Check if player is in area which they can equip an ability
	--Probably use region3 to achieve this ^

	return true
end

function module.canPlayerCast(player, playerData, abilityId)
	if not Utilities.isEntityManifestValid(player.Character.PrimaryPart) then return false, "invalid_character" end

	local abilityData = abilityLookup[abilityId]

	local canEquip, errorCode = module.canPlayerEquipAbility(player, playerData, abilityId)
	if not canEquip then return false, errorCode end

	--[[if player.Character.PrimaryPart.mana.Value < abilityData.statistics.manaCost then return false, "lacking_mana" end

	local lastCasted = Network:invoke("returnAbilityCooldown", player, abilityId)
	if lastCasted ~= nil and (tick() - lastCasted) < abilityData.statistics.cooldown then return false, "on_cooldown" end]]
	--Check if ability is equipped???

	return true
end

function module.returnNearbyPlayers(sourceCFrame, maximumDistance)
	if type(sourceCFrame) == type(CFrame) and tonumber(maximumDistance) then
		local nearbyPlayers = {}

		for i, player in pairs(game.Players:GetPlayers()) do
			local char = player.Character
			if char and char.PrimaryPart then
				if (sourceCFrame.p - char.PrimaryPart.CFrame.p).magnitude < maximumDistance then
					table.insert(nearbyPlayers, player)
				end
			end
		end

		if #nearbyPlayers >= 1 then return nearbyPlayers end
	end
end

function module.getCastingPlayer(abilityExecutionData)
	return game:GetService("Players"):GetPlayerByUserId(abilityExecutionData["cast-player-userId"])
end

function module.getAbilityStatisticsForRank(abilityBaseData, rank)

end

function module.calculateStats(playerData, abilityId)
	local abilityData = abilityLookup[abilityId]
	if not abilityData or not playerData then return nil end
	if not playerData.abilities[abilityId] then return nil end

	local increasingStat = abilityData.statistics.increasingStat
	local baseStat = abilityData.statistics[increasingStat]
	local exponent = abilityData.statistics.increaseExponent
	local playerAbilityLevel = playerData.abilities[abilityId].level

	if not increasingStat or not exponent then return nil end
	local finalStatData = baseStat * (1 + (playerAbilityLevel * exponent))

	return increasingStat, finalStatData
end

return module